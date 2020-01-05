/*

OOPTetris
by MikkoKur
2020

*/

public class Block {
    
    private PVector globalPosition;
    private PVector localPosition;
    private color col;
    
    public Block(PVector _globalPosition, PVector _localPosition, color _col) {
        globalPosition = _globalPosition;
        localPosition = _localPosition;
        col = _col;
    }
    
    public PVector GetGlobalPosition() {
        return globalPosition;
    }
    
    public void SetGlobalPosition(PVector p) {
        globalPosition = p;
    }
    
    public PVector GetLocalPosition() {
        return localPosition;
    }
    
    public void SetLocalPosition(PVector p) {
        localPosition = p;
    }
    
    public color GetColor() {
        return col;
    }
    
    public void Move(int _moveX, int _moveY) {
        globalPosition.x += _moveX;
        globalPosition.y += _moveY;
    }
    
    public void MoveLocal(int _moveX, int _moveY) {
        localPosition.x += _moveX;
        localPosition.y += _moveY;
    }
}
