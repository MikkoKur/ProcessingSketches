public class MazeSolver {
    
    //using flood fill algorithm
    
    private ArrayList<Cell> currentCells;
    private int currentffNum = 0;
    private boolean ffDone = false;
    private boolean pathDone = false;
    private Cell currentPathCell;
    private ArrayList<PVector> path;
    
    public MazeSolver() {
        currentCells = new ArrayList<Cell>();
        currentCells.add(endCell);
        endCell.SetffNum(currentffNum);
        currentPathCell = startCell;
        path = new ArrayList<PVector>();
        path.add(startCell.GetPosition());
    }
    
    public boolean IsffDone() {
        return ffDone;
    }
    
    public ArrayList<PVector> GetPath() {
        return path;
    }
    
    public void ClearPath() {
        path.clear();
    }
    
    public void FloodFill() {
        while(!ffDone) {
            //get neighbours
            ArrayList<Cell> neighbours = new ArrayList<Cell>();
            currentffNum++;
            
            for(int i = 0; i < currentCells.size(); i++) {
                Cell currentffCell = currentCells.get(i);
                PVector cellPos = currentffCell.GetPosition();
                
                //top
                if(!currentffCell.GetWall("top")) {
                    Cell c = maze[int(cellPos.y) - 1][int(cellPos.x)];
                    if(c.GetffNum() == -1) {
                        c.SetffNum(currentffNum);
                        neighbours.add(c);
                    }
                }
                //bottom
                if(!currentffCell.GetWall("bottom")) {
                    Cell c = maze[int(cellPos.y) + 1][int(cellPos.x)];
                    if(c.GetffNum() == -1) {
                        c.SetffNum(currentffNum);
                        neighbours.add(c);
                    }
                }
                //left
                if(!currentffCell.GetWall("left")) {
                    Cell c = maze[int(cellPos.y)][int(cellPos.x) - 1];
                    if(c.GetffNum() == -1) {
                        c.SetffNum(currentffNum);
                        neighbours.add(c);
                    }
                }
                //right
                if(!currentffCell.GetWall("right")) {
                    Cell c = maze[int(cellPos.y)][int(cellPos.x) + 1];
                    if(c.GetffNum() == -1) {
                        c.SetffNum(currentffNum);
                        neighbours.add(c);
                    }
                }
            }
            
            if(neighbours.size() == 0) { 
                ffDone = true;
                currentffNum = startCell.GetffNum();
                break;
            }
            
            currentCells = neighbours;
        }
    }
    
    //creates path using the ffnumbers
    public void PathFindingStep() {
        if(pathDone) { return; }
        
        currentffNum--;
        PVector currentPathCellPos = currentPathCell.GetPosition();
        ArrayList<Cell> neighbours = new ArrayList<Cell>();
        
        //get neighbours
        //top
        if(!currentPathCell.GetWall("top")) {
            Cell c = maze[int(currentPathCellPos.y) - 1][int(currentPathCellPos.x)];
            neighbours.add(c);
        }
        //bottom
        if(!currentPathCell.GetWall("bottom")) {
            Cell c = maze[int(currentPathCellPos.y) + 1][int(currentPathCellPos.x)];
            neighbours.add(c);
        }
        //left
        if(!currentPathCell.GetWall("left")) {
            Cell c = maze[int(currentPathCellPos.y)][int(currentPathCellPos.x) - 1];
            neighbours.add(c);
        }
        //right
        if(!currentPathCell.GetWall("right")) {
            Cell c = maze[int(currentPathCellPos.y)][int(currentPathCellPos.x) + 1];
            neighbours.add(c);
        }
        
        //find neighbour with smallest ffnum
        int smallestffNum = Integer.MAX_VALUE;
        int smallestIndex = 0;
        
        for(int i = 0; i < neighbours.size(); i++) {
            Cell c = neighbours.get(i);
            int ffnum = c.GetffNum();
            if(ffnum < smallestffNum) {
                smallestffNum = ffnum;
                smallestIndex = i;
            }
        }
        
        path.add(neighbours.get(smallestIndex).GetPosition());
        currentPathCell = neighbours.get(smallestIndex);
        
        if(smallestffNum == 0) {
            pathDone = true;
        }
    }
}
