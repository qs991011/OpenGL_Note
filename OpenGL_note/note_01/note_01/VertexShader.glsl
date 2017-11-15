attribute vec4 vPosition; 
attribute vec2 textCoordinate;


varying lowp vec2 varyTextCoord;
void main(void)
{
    varyTextCoord = textCoordinate;
   

    gl_Position = vPosition;
}
