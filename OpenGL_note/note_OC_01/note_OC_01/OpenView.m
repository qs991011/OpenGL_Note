//
//  OpenView.m
//  note_OC_01
//
//  Created by qiansheng on 2017/11/13.
//  Copyright © 2017年 qiansheng. All rights reserved.
//

#import "OpenView.h"
#import <OpenGLES/ES2/gl.h>

//@interface OpenView()
//@property (nonatomic,strong) EAGLContext *myContext;
//@property (nonatomic,strong) CAEAGLLayer *myEagLayer;
//@property (nonatomic,assign) GLuint myProgram;
//
//@property (nonatomic,assign) GLuint myColorRenderBuffer;
//@property (nonatomic,assign) GLuint myColorFrameBuffer;
//@end
//
//@implementation OpenView
//
//+ (Class)layerClass {
//    return [CAEAGLLayer class];
//}
//
//- (void)layoutSubviews {
//    [self setupLayer];
//    [self setupContext];
//    [self destoryRenderAndFrameBuffer];
//    [self setupRenderBuffer];
//    [self setupFrameBuffer];
//    [self render];
//}
//
//- (void)setupContext {
////    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
////    EAGLContext *context = [[EAGLContext alloc] initWithAPI:api];
////    if (!context) {
////        NSLog(@"Failed to initialize OpenGLES 2.0 context");
////        exit(1);
////    }
////
////    if (![EAGLContext setCurrentContext:context]) {
////        NSLog(@"Failed to set current OpenGL context");
////        exit(1);
////    }
////    _myContext = context;
//    // 指定 OpenGL 渲染 API 的版本，在这里我们使用 OpenGL ES 2.0
//    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
//    EAGLContext* context = [[EAGLContext alloc] initWithAPI:api];
//    if (!context) {
//        NSLog(@"Failed to initialize OpenGLES 2.0 context");
//        exit(1);
//    }
//
//    // 设置为当前上下文
//    if (![EAGLContext setCurrentContext:context]) {
//        NSLog(@"Failed to set current OpenGL context");
//        exit(1);
//    }
//    self.myContext = context;
//}
//
//- (void)setupLayer {
////    _myEagLayer = (CAEAGLLayer*) self.layer;
////    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
////
////    self.myEagLayer.opaque = YES;
////    self.myEagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
//    self.myEagLayer = (CAEAGLLayer*) self.layer;
//    //设置放大倍数
//    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
//
//    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
//    self.myEagLayer.opaque = YES;
//
//    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
//    self.myEagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
//                                          [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
//}
//
//- (void)destoryRenderAndFrameBuffer {
////    glDeleteFramebuffers(1, &_myColorFrameBuffer);
////    self.myColorFrameBuffer = 0;
////    glDeleteRenderbuffers(1, &_myColorRenderBuffer);
////    self.myColorRenderBuffer = 0;
//    glDeleteFramebuffers(1, &_myColorFrameBuffer);
//    self.myColorFrameBuffer = 0;
//    glDeleteRenderbuffers(1, &_myColorRenderBuffer);
//    self.myColorRenderBuffer = 0;
//}
//
//- (void)setupRenderBuffer {
//    GLuint buffer;
//    glGenRenderbuffers(1, &buffer);
//    self.myColorRenderBuffer = buffer;
//    glBindRenderbuffer(GL_RENDERBUFFER, self.myColorRenderBuffer);
//    [self.myContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.myEagLayer];
////    GLuint buffer;
////    glGenRenderbuffers(1, &buffer);
////    self.myColorRenderBuffer = buffer;
////    glBindRenderbuffer(GL_RENDERBUFFER, self.myColorRenderBuffer);
////    // 为 颜色缓冲区 分配存储空间
////    [self.myContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.myEagLayer];
//}
//- (void)setupFrameBuffer {
//    GLuint buffer;
//    glGenFramebuffers(1, &buffer);
//    self.myColorFrameBuffer = buffer;
//    // 设置为当前 framebuffer
//    glBindFramebuffer(GL_FRAMEBUFFER, self.myColorFrameBuffer);
//    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
//                              GL_RENDERBUFFER, self.myColorRenderBuffer);
//}
//- (void)render {
//    glClearColor(0, 0, 1.0, 1.0);
//    glClear(GL_COLOR_BUFFER_BIT);
//    [_myContext presentRenderbuffer:GL_RENDERBUFFER];
//
//
//}

@interface OpenView()
@property (nonatomic , strong) EAGLContext* myContext;
@property (nonatomic , strong) CAEAGLLayer* myEagLayer;
@property (nonatomic , assign) GLuint       myProgram;


@property (nonatomic , assign) GLuint myColorRenderBuffer;
@property (nonatomic , assign) GLuint myColorFrameBuffer;

- (void)setupLayer;

@end

@implementation OpenView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)layoutSubviews {
   // self.backgroundColor = [UIColor redColor];
    [self setupLayer];

    [self setupContext];

    [self destoryRenderAndFrameBuffer];

    [self setupRenderBuffer];

    [self setupFrameBuffer];

    [self render];
}

- (void)render {
    glClearColor(0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
//    [_myContext presentRenderbuffer:GL_RENDERBUFFER];


        CGFloat scale = [[UIScreen mainScreen] scale]; //获取视图放大倍数，可以把scale设置为1试试
    //告诉OpenGL渲染窗口的尺寸大小
        glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale); //设置视口大小
    
        //读取文件路径
    
        NSString* vertFile = [[NSBundle mainBundle] pathForResource:@"shaderv" ofType:@"vsh"];
        NSString* fragFile = [[NSBundle mainBundle] pathForResource:@"shaderf" ofType:@"fsh"];
    
        //加载shader
        self.myProgram = [self loadShaders:vertFile frag:fragFile];
    
        //链接
        glLinkProgram(self.myProgram);
        GLint linkSuccess;
        glGetProgramiv(self.myProgram, GL_LINK_STATUS, &linkSuccess);
        if (linkSuccess == GL_FALSE) { //连接错误
            GLchar messages[256];
            glGetProgramInfoLog(self.myProgram, sizeof(messages), 0, &messages[0]);
            NSString *messageString = [NSString stringWithUTF8String:messages];
            NSLog(@"error%@", messageString);
            return ;
        }
        else {
            NSLog(@"link ok");
            glUseProgram(self.myProgram); //成功便使用，避免由于未使用导致的的bug
        }
    
    
    
        //前三个是顶点坐标， 后面两个是纹理坐标
        GLfloat attrArr[] =
        {
            0.5f, -0.5f, -1.0f,     1.0f, 0.0f,
            -0.5f, 0.5f, -1.0f,     0.0f, 1.0f,
            -0.5f, -0.5f, -1.0f,    0.0f, 0.0f,
            0.5f, 0.5f, -1.0f,      1.0f, 1.0f,
            -0.5f, 0.5f, -1.0f,     0.0f, 1.0f,
            0.5f, -0.5f, -1.0f,     1.0f, 0.0f,
        };
    
        GLuint attrBuffer;
        //生成新缓存对象
        glGenBuffers(1, &attrBuffer);
        //绑定缓存对象 顶点缓冲对象的缓冲类型是GL_ARRAY_BUFFER
        glBindBuffer(GL_ARRAY_BUFFER, attrBuffer);
        //将顶点数据拷贝到缓存对象中
        /**
         第四个参数指定了我们希望显卡如何管理给定的数据。它有三种形式
         GL_STATIC_DRAW ：数据不会或几乎不会改变。
         GL_DYNAMIC_DRAW：数据会被改变很多。
         GL_STREAM_DRAW ：数据每次绘制时都会改变。
         
         */
        glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_DYNAMIC_DRAW);
    
        GLuint position = glGetAttribLocation(self.myProgram, "position");
        glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
        glEnableVertexAttribArray(position);
    
        GLuint textCoor = glGetAttribLocation(self.myProgram, "textCoordinate");
        glVertexAttribPointer(textCoor, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (float *)NULL + 3);
        glEnableVertexAttribArray(textCoor);
    
        //加载纹理
        [self setupTexture:@"for_test"];
    
        //获取shader里面的变量，这里记得要在glLinkProgram后面，后面，后面！
        GLuint rotate = glGetUniformLocation(self.myProgram, "rotateMatrix");
    
        float radians = 10 * 3.14159f / 180.0f;
        float s = sin(radians);
        float c = cos(radians);
    
        //z轴旋转矩阵
        GLfloat zRotation[16] = { //
            c, -s, 0, 0.2, //
            s, c, 0, 0,//
            0, 0, 1.0, 0,//
            0.0, 0, 0, 1.0//
        };
    
        //设置旋转矩阵
       // glUniformMatrix4fv(rotate, 1, GL_FALSE, (GLfloat *)&zRotation[0]);
    
        glDrawArrays(GL_TRIANGLES, 0, 3);
    
        [self.myContext presentRenderbuffer:GL_RENDERBUFFER];
}

/**
 *  c语言编译流程：预编译、编译、汇编、链接
 *  glsl的编译过程主要有glCompileShader、glAttachShader、glLinkProgram三步；
 *  @param vert 顶点着色器
 *  @param frag 片元着色器
 *
 *  @return 编译成功的shaders
 */
- (GLuint)loadShaders:(NSString *)vert frag:(NSString *)frag {
    GLuint verShader, fragShader;
    GLint program = glCreateProgram();

    //编译
    [self compileShader:&verShader type:GL_VERTEX_SHADER file:vert];
    [self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:frag];

    glAttachShader(program, verShader);
    glAttachShader(program, fragShader);


    //释放不需要的shader
    glDeleteShader(verShader);
    glDeleteShader(fragShader);

    return program;
}

- (void)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    //读取字符串
    NSString* content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    const GLchar* source = (GLchar *)[content UTF8String];

    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
}



- (void)setupLayer
{
    self.myEagLayer = (CAEAGLLayer*) self.layer;
    //设置放大倍数
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];

    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    self.myEagLayer.opaque = YES;

    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
    self.myEagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}


- (void)setupContext {
    // 指定 OpenGL 渲染 API 的版本，在这里我们使用 OpenGL ES 2.0
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:api];
    if (!context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }

    // 设置为当前上下文
    if (![EAGLContext setCurrentContext:context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
    self.myContext = context;
}

- (void)setupRenderBuffer {
    GLuint buffer;
    glGenRenderbuffers(1, &buffer);
    self.myColorRenderBuffer = buffer;
    glBindRenderbuffer(GL_RENDERBUFFER, self.myColorRenderBuffer);
    // 为 颜色缓冲区 分配存储空间
    [self.myContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.myEagLayer];
}


- (void)setupFrameBuffer {
    GLuint buffer;
    glGenFramebuffers(1, &buffer);
    self.myColorFrameBuffer = buffer;
    // 设置为当前 framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, self.myColorFrameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    /*
     glFramebufferRenderbuffer (GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer)
     
     GL_COLOR_ATTACHMENT0, GL_DEPTH_ATTACHMENT, GL_STENCIL_ATTACHMENT中的一个，分别对应 color，depth和 stencil三大buffer。
     **/
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, self.myColorRenderBuffer);
}


- (void)destoryRenderAndFrameBuffer
{
    glDeleteFramebuffers(1, &_myColorFrameBuffer);
    self.myColorFrameBuffer = 0;
    glDeleteRenderbuffers(1, &_myColorRenderBuffer);
    self.myColorRenderBuffer = 0;
}




- (GLuint)setupTexture:(NSString *)fileName {
    // 1获取图片的CGImageRef
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }

    // 2 读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);

    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //rgba共4个byte

    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);

    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);

    CGContextRelease(spriteContext);

    // 4绑定纹理到默认的纹理ID（这里只有一张图片，故而相当于默认于片元着色器里面的colorMap，如果有多张图不可以这么做）
    glBindTexture(GL_TEXTURE_2D, 0);

    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);

    glBindTexture(GL_TEXTURE_2D, 0);

    free(spriteData);
    return 0;
}

@end
