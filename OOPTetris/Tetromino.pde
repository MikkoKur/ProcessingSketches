/*

OOPTetris
by MikkoKur
2020

*/

public class Tetromino {
    
    private Block[] shape;
    private char type;
    private color col;
    private int worldSizeX;
    private int worldSizeY;
    private int startPosOffset;
    private PVector centerPoint;
    private int recursiveOverlapChecks = 0;
    
    public Tetromino(int _worldSizeX, int _worldSizeY) {
        startPosOffset = floor(_worldSizeX / 2) - 1;
        type = GetRandomType();
        col = GetRandomColor();
        shape = CreateShape(type);
        worldSizeX = _worldSizeX;
        worldSizeY = _worldSizeY;
        Move(startPosOffset, 0);
    }
    
    public Tetromino(char _type, color _color, int _blockCountX, int _blockCountY) {
        startPosOffset = floor(_blockCountX / 2) - 1;
        type = _type;
        col = _color;
        shape = CreateShape(type);
        worldSizeX = _blockCountX;
        worldSizeY = _blockCountY;
        Move(startPosOffset, 0);
    }
    
    private char GetRandomType() {
        char[] shapeChars = {'I','O','T','J','L','S','Z'};
        return shapeChars[(int)random(shapeChars.length)];
    }
    
    private color GetRandomColor() {
        color[] colors = {
            //red
            color(230, 20, 20),
            //green
            color(10, 250, 10),
            //blue
            color(10, 10, 255),
            //orange
            color(255, 140, 10),
            //yellow
            color(255, 255, 10),
            //cyan
            color(10,255,255),
            //violet
            color(148,10,211)
        };
        
        return colors[(int)random(colors.length)];
    }
    
    private Block[] CreateShape(char _type) {
        switch(_type) {
            case 'I':
                centerPoint = new PVector(1.5, 0);
                return new Block[] {
                    new Block(new PVector(0,0), new PVector(0,2), col),
                    new Block(new PVector(1,0), new PVector(1,2), col),
                    new Block(new PVector(2,0), new PVector(2,2), col),
                    new Block(new PVector(3,0), new PVector(3,2), col)
                };
            case 'O':
                centerPoint = new PVector(0, 0);
                return new Block[] {
                    new Block(new PVector(0,0), new PVector(0,0), col),
                    new Block(new PVector(1,0), new PVector(0,0), col),
                    new Block(new PVector(0,1), new PVector(0,0), col),
                    new Block(new PVector(1,1), new PVector(0,0), col)
                };
            case 'T':
                centerPoint = new PVector(1, 0);
                return new Block[] {
                    new Block(new PVector(0,0), new PVector(0,1), col),
                    new Block(new PVector(1,0), new PVector(1,1), col),
                    new Block(new PVector(2,0), new PVector(2,1), col),
                    new Block(new PVector(1,1), new PVector(1,2), col)
                };
            case 'J':
                centerPoint = new PVector(1, 0);
                return new Block[] {
                    new Block(new PVector(0,0), new PVector(0,1), col),
                    new Block(new PVector(1,0), new PVector(1,1), col),
                    new Block(new PVector(2,0), new PVector(2,1), col),
                    new Block(new PVector(2,1), new PVector(2,2), col)
                };
            case 'L':
                centerPoint = new PVector(1, 0);
                return new Block[] {
                    new Block(new PVector(0,0), new PVector(0,1), col),
                    new Block(new PVector(1,0), new PVector(1,1), col),
                    new Block(new PVector(2,0), new PVector(2,1), col),
                    new Block(new PVector(0,1), new PVector(0,2), col)
                };
            case 'S':
                centerPoint = new PVector(1, 0);
                return new Block[] {
                    new Block(new PVector(1,0), new PVector(1,1), col),
                    new Block(new PVector(2,0), new PVector(2,1), col),
                    new Block(new PVector(1,1), new PVector(1,2), col),
                    new Block(new PVector(0,1), new PVector(0,2), col)
                };
            case 'Z':
                centerPoint = new PVector(1, 0);
                return new Block[] {
                    new Block(new PVector(0,0), new PVector(0,1), col),
                    new Block(new PVector(1,0), new PVector(1,1), col),
                    new Block(new PVector(1,1), new PVector(1,2), col),
                    new Block(new PVector(2,1), new PVector(2,2), col)
                };
            default:
                return new Block[] {};
        }
    }
    
    //use local position to apply rotatetable vector for each block
    public void Rotate(char _dir, ArrayList<Block> _stillBlocks) {
        //there is no point to rotate o type block so return
        if(type == 'O') { return; }
        
        PVector[][] rotateTable;
        
        //create 4x4 rotatetable for I type block
        if(type == 'I') {
            if(_dir == 'R') {
                rotateTable = new PVector[][] {
                    {new PVector(3,0), new PVector(2,1), new PVector(1,2), new PVector(0,3)},
                    {new PVector(2,-1), new PVector(1,0), new PVector(0,1), new PVector(-1,2)},
                    {new PVector(1,-2), new PVector(0,-1), new PVector(-1,0), new PVector(-2,1)},
                    {new PVector(0,-3), new PVector(-1,-2), new PVector(-2,-1), new PVector(-3,0)}
                };
            } else {
                rotateTable = new PVector[][] {
                    {new PVector(0,3), new PVector(-1,2), new PVector(-2,1), new PVector(-3,0)},
                    {new PVector(1,2), new PVector(0,1), new PVector(-1,0), new PVector(-2,-1)},
                    {new PVector(2,1), new PVector(1,0), new PVector(0,-1), new PVector(-1,-2)},
                    {new PVector(3,0), new PVector(2,-1), new PVector(1,-2), new PVector(0,-3)}
                };
            }
        //create 3x3 rotatetable for T,J,L,S,Z block types
        } else {
            if(_dir == 'R') {
                rotateTable = new PVector[][] {
                    {new PVector(2,0), new PVector(1,1), new PVector(0,2)},
                    {new PVector(1,-1), new PVector(0,0), new PVector(-1,1)},
                    {new PVector(0,-2), new PVector(-1,-1), new PVector(-2,0)}
                };
            } else {
                rotateTable = new PVector[][] {
                    {new PVector(0,2), new PVector(-1,1), new PVector(-2,0)},
                    {new PVector(1,1), new PVector(0,0), new PVector(-1,-1)},
                    {new PVector(2,0), new PVector(1,-1), new PVector(0,-2)}
                };
            }
        }
        
        ApplyRotateTable(rotateTable, _stillBlocks);
    }
    
    private void ApplyRotateTable(PVector[][] _rotateTable, ArrayList<Block> _stillBlocks) {
        //get original block positions of this tetromino in case something blocks rotation
        PVector originalCenterPoint = new PVector(centerPoint.x, centerPoint.y);
        ArrayList<PVector> originalGlobalPositions = new ArrayList<PVector>();
        ArrayList<PVector> originalLocalPositions = new ArrayList<PVector>();
        for(int i = 0; i < shape.length; i++) {
            PVector gPos = shape[i].GetGlobalPosition();
            PVector lPos = shape[i].GetLocalPosition();
            originalGlobalPositions.add(new PVector(gPos.x, gPos.y));
            originalLocalPositions.add(new PVector(lPos.x, lPos.y));
        }
        
        //do rotation using local coords and rotatetable
        for(int i = 0; i < shape.length; i++) {
            Block b = shape[i];
            PVector localCoord = b.GetLocalPosition();
            PVector move = _rotateTable[(int)localCoord.y][(int)localCoord.x];
            b.Move((int)move.x, (int)move.y);
            b.MoveLocal((int)move.x, (int)move.y);
        }
        
        //check wall and block overlaps recursively
        RecursiveOverlapChecking(_stillBlocks, 3);
        
        //return orig rotation if something blocks rotation
        if(recursiveOverlapChecks >= 3) {
            for(int i = 0; i < shape.length; i++) {
                PVector gPos = originalGlobalPositions.get(i);
                PVector lPos = originalLocalPositions.get(i);
                shape[i].SetGlobalPosition(gPos);
                shape[i].SetLocalPosition(lPos);
            }
            centerPoint = originalCenterPoint;
        }
        
        recursiveOverlapChecks = 0;
    }
    
    private void RecursiveOverlapChecking(ArrayList<Block> _stillBlocks, int maxCalls) {
        if(maxCalls > 0) {
            maxCalls--;
            for(int i = 0; i < shape.length; i++) {
                Block b = shape[i];
                PVector blockPos = b.GetGlobalPosition();
                
                //check if overlaps with stillblock
                for(int n = 0; n < _stillBlocks.size(); n++) {
                    PVector stillBlockPos = _stillBlocks.get(n).GetGlobalPosition();
                    if(blockPos.x == stillBlockPos.x && blockPos.y == stillBlockPos.y) {
                        if(blockPos.x < centerPoint.x) {
                            Move(1, 0);
                            RecursiveOverlapChecking(_stillBlocks, maxCalls);
                            recursiveOverlapChecks++;
                        }
                        if(blockPos.x > centerPoint.x) {
                            Move(-1, 0);
                            RecursiveOverlapChecking(_stillBlocks, maxCalls);
                            recursiveOverlapChecks++;
                        }
                    }
                }
                
                //check if overlaps with wall
                if(blockPos.x < 0) {
                    Move(1, 0);
                    RecursiveOverlapChecking(_stillBlocks, maxCalls);
                    recursiveOverlapChecks++;
                }
                if(blockPos.x > worldSizeX - 1) {
                    Move(-1, 0);
                    RecursiveOverlapChecking(_stillBlocks, maxCalls);
                    recursiveOverlapChecks++;
                }
            }
        }
    }
    
    public boolean CheckHorizontalCollision(char _dir, ArrayList<Block> _stillBlocks) {
        for(int i = 0; i < shape.length; i++) {
            PVector blockPos = shape[i].GetGlobalPosition();
            //moving left
            if(_dir == 'L') {
                //check left wall
                if(blockPos.x == 0) {
                    return true;
                }
                
                //check if there is stillblock on left
                for(int n = 0; n < _stillBlocks.size(); n++) {
                    PVector stillBlockPos = _stillBlocks.get(n).GetGlobalPosition();
                    if(stillBlockPos.x == blockPos.x - 1 &&
                    stillBlockPos.y == blockPos.y) {
                        return true;
                    }
                }
            //moving right
            } else {
                 //check right wall
                if(blockPos.x >= worldSizeX - 1) {
                    return true;
                }
                
                //check if there is stillblock on right
                for(int n = 0; n < _stillBlocks.size(); n++) {
                    PVector stillBlockPos = _stillBlocks.get(n).GetGlobalPosition();
                    if(stillBlockPos.x == blockPos.x + 1 &&
                    stillBlockPos.y == blockPos.y) {
                        return true;
                    }
                }
            }
        }
        
        return false;
    }
    
    public boolean CheckVerticalCollision(ArrayList<Block> _stillBlocks) {      
        for(int i = 0; i < shape.length; i++) {
            PVector thisBlockPos = shape[i].GetGlobalPosition();
            
            //hit on floor
            if(thisBlockPos.y >= worldSizeY - 1) {
                return true;
            }
            
            //hit on block
            for(int n = 0; n < _stillBlocks.size(); n++) {
                PVector stillBlockPos = _stillBlocks.get(n).GetGlobalPosition();
                if(thisBlockPos.y + 1 == stillBlockPos.y && thisBlockPos.x == stillBlockPos.x) {
                    return true;
                }
            }
        }
        
        return false;
    }
    
    public boolean CheckOverlap(ArrayList<Block> _stillBlocks) {
        for(int i = 0; i < shape.length; i++) {
            PVector b1 = shape[i].GetGlobalPosition();
            
            //check stillblocks
            for(int n = 0; n < _stillBlocks.size(); n++) {
                PVector b2 = _stillBlocks.get(n).GetGlobalPosition();
                if(b1.x == b2.x && b1.y == b2.y) {
                    return true;
                }
            }
            
            //check wall
            if(b1.x < 0 || b1.x > worldSizeX - 1) {
                return true;
            }
        }
        
        return false;
    }
    
    public void Move(int _moveX, int _moveY) {
        for(int i = 0; i < shape.length; i++) {
            shape[i].Move(_moveX, _moveY);
        }
        centerPoint.x += _moveX;
        centerPoint.y += _moveY;
    }
    
    public color GetColor() {
        return col;
    }
    
    public Block[] GetShape() {
        return shape;
    }
}
