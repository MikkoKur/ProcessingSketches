/*

MazeGeneratorAndSolver
by MikkoKur
2020

*/

public class Cell {
    
    private IntDict walls;
    private color col;
    private boolean visited;
    private PVector position;
    //flood fill number for solver
    private int ffNum;
    
    public Cell(color _col, PVector _position) {
        walls = new IntDict();
        walls.set("top", 1);
        walls.set("bottom", 1);
        walls.set("left", 1);
        walls.set("right", 1);
        col = _col;
        visited = false;
        position = _position;
        ffNum = -1;
    }
    
    public color GetColor() {
        return col;
    }
    
    public void SetColor(color _col) {
        col = _col;
    }
    
    public boolean GetVisited() {
        return visited;
    }
    
    public void SetVisited(boolean _b) {
        visited = _b;
    }
    
    public PVector GetPosition() {
        return position;
    }
    
    public void SetffNum(int _n) {
        ffNum = _n;
    }
    
    public int GetffNum() {
        return ffNum;
    }
    
    public void SetWall(String _wall, boolean _value) {
        if(walls.hasKey(_wall)) {
            int val = 0;
            if(_value == true) { 
                val = 1; 
            }
            walls.set(_wall, val);
        } else {
            println(_wall + " not found in dict");
        }
    }
    
    public boolean GetWall(String _wall) {
        if(walls.hasKey(_wall)) {
            if(walls.get(_wall) == 0) { 
                return false; 
            }
        } else {
            println(_wall + " not found in dict");
        }
        
        return true;
    }
    
    public IntDict GetWalls() {
        return walls;
    }
}
