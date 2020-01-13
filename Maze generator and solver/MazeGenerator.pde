public class MazeGenerator {
    
    //using recursive backtracker algorithm (without recursion)
    
    private Cell[][] generatedMaze;
    private int posX;
    private int posY;
    private boolean mazeCreated = false;
    private ArrayList<Cell> backtrackCells;
    
    public MazeGenerator() {
        generatedMaze = new Cell[cellCount][cellCount];
        for(int y = 0; y < generatedMaze.length; y++) {
            for(int x = 0; x < generatedMaze[y].length; x++) {
                generatedMaze[y][x] = new Cell(backgroundColor, new PVector(x, y));
            }
        }
        
        //pick random start point
        posY = int(random(cellCount));
        generatedMaze[posY][posX].SetVisited(true);
        generatedMaze[posY][posX].SetColor(cellColor);
        backtrackCells = new ArrayList<Cell>();
        backtrackCells.add(generatedMaze[posY][posX]);
    }
    
    public boolean IsMazeCreated() {
        return mazeCreated;
    }
    
    public Cell[][] GenerateMazeStep() {    
        if(mazeCreated) { return generatedMaze; }
        generatedMaze[posY][posX].SetColor(cellColor);
        
        //get neighbour cells
        ArrayList<Cell> neighbours = new ArrayList<Cell>();
        //top
        if(posY > 0) {
            Cell c = generatedMaze[posY - 1][posX];
            if(!c.GetVisited()) {
                neighbours.add(c);
            }
        }
        
        //bottom
        if(posY < cellCount - 1) { 
            Cell c = generatedMaze[posY + 1][posX];
            if(!c.GetVisited()) {
                neighbours.add(c);
            } 
        }
        //left
        if(posX > 0) { 
            Cell c = generatedMaze[posY][posX - 1];
            if(!c.GetVisited()) {
                neighbours.add(c);
            }  
        }
        //right
        if(posX < cellCount - 1) { 
            Cell c = generatedMaze[posY][posX + 1];
            if(!c.GetVisited()) {
                neighbours.add(c);
            } 
        }
        
        //backtrack if cant go anywhere from current position
        if(neighbours.size() == 0) {
            if(backtrackCells.size() == 0) {
                mazeCreated = true;
                return generatedMaze;
            }
            Cell c = backtrackCells.get(backtrackCells.size() - 1);
            c.SetColor(color(255, 0, 0));
            PVector cellPos = c.GetPosition();
            posX = int(cellPos.x);
            posY = int(cellPos.y);
            backtrackCells.remove(backtrackCells.size() - 1);
            return generatedMaze;
        }
        
        //pick random neighbour cell
        Cell randomCell = neighbours.get(int(random(neighbours.size())));
        randomCell.SetVisited(true);
        randomCell.SetColor(color(255, 0, 0));
        PVector randomCellPos = randomCell.GetPosition();
        backtrackCells.add(randomCell);
        
        //remove walls
        //top
        if(randomCellPos.y < posY) {
            randomCell.SetWall("bottom", false);
            generatedMaze[posY][posX].SetWall("top", false);
        }
        //bottom
        if(randomCellPos.y > posY) {
            randomCell.SetWall("top", false);
            generatedMaze[posY][posX].SetWall("bottom", false);
        }
        //left
        if(randomCellPos.x < posX) {
            randomCell.SetWall("right", false);
            generatedMaze[posY][posX].SetWall("left", false);
        }
        //right
        if(randomCellPos.x > posX) {
            randomCell.SetWall("left", false);
            generatedMaze[posY][posX].SetWall("right", false);
        }
        
        //update positions to randomCellPos and continue there in next call
        posX = int(randomCellPos.x);
        posY = int(randomCellPos.y);
        
        return generatedMaze;
    }
}
