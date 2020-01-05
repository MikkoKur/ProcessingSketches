/*

OOPTetris
by MikkoKur
2020

*/

//world size = block count
int worldSizeX = 9;
int worldSizeY = 21;
//block size = pixels per block
int blockSize = 45;
int sleepMs;
int time = 0;
int score = 0;
boolean gameOver = false;
PVector newGameButtonSize;
PVector newGameButtonPosition;
ArrayList<Block> stillBlocks = new ArrayList<Block>();
Tetromino currentTetromino = new Tetromino(worldSizeX, worldSizeY);
boolean gameStarted = false;

void setup() {
    int windowSizeX = worldSizeX * blockSize;
    int windowSizeY = worldSizeY * blockSize;
    surface.setSize(windowSizeX, windowSizeY);
    UpdateSpeed();
    frameRate(100);
}

void draw() {
    background(120, 120, 255);
    
    if(!gameStarted) {
        ShowInstructions();
        return; 
    }
    
    ShowScore();
    DrawWorld();
    
    if(millis() >= time + sleepMs && !gameOver) {
        if(!currentTetromino.CheckVerticalCollision(stillBlocks)) {
            //if there is no collision with floor or stillblocks, move current tetromino down
            currentTetromino.Move(0, 1);
        } else {            
            //when colliding with floor, put current tetromino to stillblocks list
            Block[] blocks = currentTetromino.GetShape();
            for(int i = 0; i < blocks.length; i++) {
                stillBlocks.add(blocks[i]);
            }
            
            //create new tetromino
            currentTetromino = new Tetromino(worldSizeX, worldSizeY);
            
            //remove full rows, update score and speed
            CheckFullRows();
            UpdateSpeed();
            
            //game over when current tetromino overlaps with stillblock
            if(currentTetromino.CheckOverlap(stillBlocks)) {
                gameOver = true;
            }
        }
        time = millis();
    }
    
    if(gameOver && millis() >= time + 1000) {
        ShowGameOverScene();
    }
}

void mousePressed() {
    //game over button press
    if(gameOver) {
        if(mouseX > newGameButtonPosition.x && mouseX < newGameButtonPosition.x + newGameButtonSize.x && 
        mouseY > newGameButtonPosition.y && mouseY < newGameButtonPosition.y + newGameButtonSize.y) {
            ResetGame();
        }
    }
}

int i = 0;

void keyPressed() {
    if(key == 'a' || key == 'A') {
        if(!currentTetromino.CheckHorizontalCollision('L', stillBlocks)) {
            currentTetromino.Move(-1, 0);
        }
    }
    if(key == 'd' || key == 'D') {
        if(!currentTetromino.CheckHorizontalCollision('R', stillBlocks)) {
            currentTetromino.Move(1, 0);
        }
    }
    if(key == 's' || key == 'S') {
        if(!currentTetromino.CheckVerticalCollision(stillBlocks)) {
            currentTetromino.Move(0, 1);
        }
    }
    if(key == 'j' || key == 'J') {
        currentTetromino.Rotate('L', stillBlocks);
    }
    if(key == 'k' || key == 'K') {
        currentTetromino.Rotate('R', stillBlocks);
    }
    if(key == ENTER || key == RETURN) {
        gameStarted = true;
    }
}

void ShowScore() {
    textSize(40);
    fill(0, 40);
    String scoreText = "Score: " + score;
    text(scoreText, 10, 40);
}

void ShowInstructions() {
    textSize(25);
    fill(10,255,255);
    String instructionsText = 
        "Move tetromino: W,A,S,D\n" + 
        "Rotate left: J\n" + 
        "Rotate right: K\n" + 
        "Start game: Enter";
    text(instructionsText, 10, 25);
}

void ShowGameOverScene() {
    background(10);
    textSize(32);
    fill(255, 0, 0);
    String gameOverTxt = "Game over\nScore: " + score;
    text(gameOverTxt, 10, 35);
    
    //new game button
    newGameButtonSize = new PVector(200, 50);
    newGameButtonPosition = new PVector((width / 2) - newGameButtonSize.x / 2, (height / 2) + newGameButtonSize.y / 2);
    fill(250, 10, 10);
    rect(newGameButtonPosition.x, newGameButtonPosition.y, newGameButtonSize.x, newGameButtonSize.y);
    fill(255);
    String buttonTxt = "New game";
    text(buttonTxt, newGameButtonPosition.x + 20, newGameButtonPosition.y + 35);
}

void ResetGame() {
    score = 0;
    UpdateSpeed();
    stillBlocks = new ArrayList<Block>();
    currentTetromino = new Tetromino(worldSizeX, worldSizeY);
    gameOver = false;
    time = millis();
}

void UpdateSpeed() {
    if(score >= 25) {
        sleepMs = 150;
    } else if(score >= 20) {
        sleepMs = 200;
    } else if(score >= 15) {
        sleepMs = 400;
    } else if(score >= 10) {
        sleepMs = 600;
    } else if(score >= 5) {
        sleepMs = 800;
    } else if(score >= 0) {
        sleepMs = 1000;
    }
}

void CheckFullRows() {    
    for(int y = 0; y < worldSizeY; y++) {
        int count = 0;
        for(int i = 0; i < stillBlocks.size(); i++) {
            Block b = stillBlocks.get(i);
            if(b.GetGlobalPosition().y == y) {
                count++;
            }
        }
        
        //if full row, remove row and update score
        if(count == worldSizeX) {
            RemoveRow(y);
            score++;
        }
    }
}

void RemoveRow(int _row) {
    //remove row
    for(int i = stillBlocks.size() - 1; i >= 0; i--) {
        Block b = stillBlocks.get(i);
        if(b.GetGlobalPosition().y == _row) {
            stillBlocks.remove(i);
        }
    }
    
    //drop stillBlocks above removed row
    for(int i = 0; i < stillBlocks.size(); i++) {
        Block b = stillBlocks.get(i);
        if(b.GetGlobalPosition().y < _row) {
            b.Move(0, 1);
        }
    }
}

void DrawWorld() {
    DrawTetrominos();
    DrawLines();
}

void DrawLines() {
    stroke(0,0,0,70);
    //horizontal lines
    for(int i = blockSize; i < height; i += blockSize) {
        line(0, i, width, i);
    }
    //vertical lines
    for(int i = blockSize; i < width; i += blockSize) {
        line(i, 0, i, height);
    }
}

void DrawTetrominos() {
    stroke(0,0,0,0);
    
    //draw still blocks with sligthly darker color
    for(int i = 0; i < stillBlocks.size(); i++) {
        Block b = stillBlocks.get(i);
        PVector pos = b.GetGlobalPosition();
        color c = b.GetColor();
        color darkColor = color(red(c) / 1.12, green(c) / 1.12, blue(c) / 1.12);
        fill(darkColor);
        rect(pos.x * blockSize, pos.y * blockSize, blockSize, blockSize);
    }
    
    //draw current tetromino
    Block[] currentTetrominoBlocks = currentTetromino.GetShape();
    for(int i = 0; i < currentTetrominoBlocks.length; i++) {
        Block b = currentTetrominoBlocks[i];
        fill(b.GetColor());
        PVector pos = b.GetGlobalPosition();
        rect(pos.x * blockSize, pos.y * blockSize, blockSize, blockSize);
    }
}
