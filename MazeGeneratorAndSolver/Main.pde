/*

MazeGeneratorAndSolver
by MikkoKur
2020

*/

int gameWindowSize = 800;
int infoBoxSize = 60;
int cellCount;
float cellSize;
int speed;
int resolution;
int minResolution = 2;
int maxResolution = 200;
int minSpeed = 1;
int maxSpeed = 50000;
color cellColor = color(100);
color backgroundColor = color(50);
Cell[][] maze;
MazeGenerator mg;
MazeSolver ms;
Cell startCell = null;
Cell endCell = null;
String input = "";
String ask = "";
int askState = 0;
boolean startEndPointsSet = false;
boolean settingsSet = false;

void setup() {
    ask = "Type resolution (" + minResolution + " - " + maxResolution + ") and press enter";
    surface.setSize(gameWindowSize, gameWindowSize + infoBoxSize);
    frameRate(30);
}

void draw() {
    if(!settingsSet) {
        SettingsUi();
        return;
    }
    
    if(!mg.IsMazeCreated() || !startEndPointsSet) {
        GenerateMaze();
    } else {
        if (!ms.IsffDone()) {
            //do flood fill
            ms.FloodFill();
        } else {
            //find path using flood fill numbers
            for (int i = 0; i < round(speed / 10) + 1; i++) {
                ms.PathFindingStep();
            }
        }
    }
    
    DrawMaze();
    InfoBoxText();
}

void mouseClicked() {
    if(mg != null) {
        if (mg.IsMazeCreated() && !startEndPointsSet) {
            SetStartAndEndPoints();
        }
    }
}

void keyPressed() {
    if (key == 'r' || key == 'R') {
        Reset();
    }
    if(!settingsSet) {
        AskSettings(key);
    }
}

void InfoBoxText() {
    int fontSize = 20;
    textSize(fontSize);
    textAlign(CENTER, TOP);
    fill(cellColor);
    String txt = "Press R to restart anytime \nPress mouse1 to set startpoint and mouse2 to set endpoint for pathfinder";
    text(txt, width / 2, height - infoBoxSize - 1);
}

void SetStartAndEndPoints() {    
    int xIndex = int(mouseX / (cellSize * 2));
    int yIndex = int(mouseY / (cellSize * 2));
    
    //return if out of bounds
    if (xIndex > cellCount - 1 || yIndex > cellCount - 1) {
        return;
    }

    //set start point with mouseleft and endpoint with mouseright
    if (mouseButton == LEFT) {
        startCell = maze[yIndex][xIndex];
        startCell.SetColor(color(0, 255, 0));
    } else {
        endCell = maze[yIndex][xIndex];
        endCell.SetColor(color(255, 0, 0));
    }

    if (startCell != null && endCell != null) {
        startEndPointsSet = true;
    }
    
    if(startEndPointsSet) {
        ms = new MazeSolver();
    }
}

void AskSettings(char _key) {
    //add number (char) to input
    //ascii 0-9 = 48-57
    for(int i = 48; i < 58; i++) {
        if(_key == i) {
            if(input.length() < 8) {
                input += _key;
            }
        }
    }
    
    //remove char from input
    if(_key == BACKSPACE) {
        if(input.length() > 0) {
            input = input.substring(0, input.length() - 1);
        }
    }
    
    //apply input
    if(_key == ENTER) {
        if(input.length() > 0) {
            if(askState == 0) {
                //apply resolution
                resolution = Integer.parseInt(input);
                if(resolution < minResolution) { resolution = minResolution; }
                if(resolution > maxResolution) { resolution = maxResolution; }
                ask = "Type speed (" + minSpeed + " - " + maxSpeed + ") and press enter";
                input = "";
                askState++;
                cellSize = float(gameWindowSize) / float(resolution * 2 + 1);
                cellCount = resolution;
                mg = new MazeGenerator();
            } else {
                //apply speed
                speed = Integer.parseInt(input);
                if(speed < minSpeed) { speed = minSpeed; }
                if(speed > maxSpeed) { speed = maxSpeed; }
                input = "";
                askState++;
                settingsSet = true;
            }
        }
    }
}

void SettingsUi() {
    background(backgroundColor);
    int fontSize = 32;
    textSize(fontSize);
    textAlign(CENTER);
    fill(cellColor);
    text(ask, width / 2, height / 2 - fontSize);
    text(input, width / 2, height / 2 + 5); 
}

void Reset() {
    mg = new MazeGenerator();
    if(ms != null) {
        ms.ClearPath();
    }
    startEndPointsSet = false;
    startCell = null;
    endCell = null;
    settingsSet = false;
    askState = 0;
    ask = "Type resolution (" + minResolution + " - " + maxResolution + ")";
    input = "";
}

void GenerateMaze() {
    for (int i = 0; i < speed; i++) {
        maze = mg.GenerateMazeStep();
    }
}

void DrawMaze() {
    background(backgroundColor);
    float xPos = cellSize;
    float yPos = cellSize;
    
    for (int y = 0; y < maze.length; y++) {
        for (int x = 0; x < maze[y].length; x++) {
            Cell c = maze[y][x];
            //draw open cells
            color col = c.GetColor();
            fill(col);
            stroke(col, map(resolution, 2, 200, 200, 0));
            rect(xPos, yPos, cellSize, cellSize);
            //draw opened walls with cellcolor
            fill(cellColor);
            stroke(cellColor, map(resolution, minResolution, maxResolution, 225, 0));
            if (!c.GetWall("right")) {
                rect(xPos + cellSize, yPos, cellSize, cellSize);
            }
            if (!c.GetWall("bottom")) {
                rect(xPos, yPos + cellSize, cellSize, cellSize);
            }
            
            xPos += cellSize + cellSize;
        }
        xPos = cellSize;
        yPos += cellSize * 2;
    }
    
    //draw path
    if(ms != null) {
        ArrayList<PVector> path = ms.GetPath();
        for (int i = 0; i < path.size() - 1; i++) {            
            PVector currPos = path.get(i);
            PVector nextPos = path.get(i + 1);
            stroke(0, 255, 0, 255);
            strokeWeight(cellSize / 2);
            float offset = cellSize / 2;
            line(
                currPos.x * 2 * cellSize + cellSize + offset, 
                currPos.y * 2 * cellSize + cellSize + offset, 
                nextPos.x * 2 * cellSize + cellSize + offset, 
                nextPos.y * 2 * cellSize + cellSize + offset
            );
        }
    }
    
    strokeWeight(1);
}
