//attribute vec4 vPosition;
//attribute vec2 textCoordinate;
//
//
//varying lowp vec2 varyTextCoord;

//void main(void)
//{
//    varyTextCoord = textCoordinate;
//
//
//    gl_Position = vPosition;
//}

attribute vec4 position;
attribute vec2 textCoordinate;
uniform mat4 rotateMatrix;

varying lowp vec2 varyTextCoord;

void main()
{
    varyTextCoord = textCoordinate;
    
    vec4 vPos = position;
    
    vPos = vPos * rotateMatrix;
    
    gl_Position = position;
}
