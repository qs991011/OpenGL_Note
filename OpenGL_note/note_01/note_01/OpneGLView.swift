//
//  OpneGLView.swift
//  note_01
//
//  Created by qiansheng on 2017/11/9.
//  Copyright © 2017年 qiansheng. All rights reserved.
//

import UIKit

class OpneGLView: UIView {
    var glCongtext : EAGLContext?
    var eagLayer : CAEAGLLayer?
    var myProgram : GLuint = 0
    var ColorRenderBuffer : GLuint = 0
    var ColorFrameBuffer : GLuint = 0
    var positionSlot : GLuint = 0
    var textCoor : GLuint = 0
    
    override  class var layerClass: AnyClass {
         return CAEAGLLayer.self
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
        initContext()
        setupProgram()
        
    }
    override func layoutSubviews() {
        //EAGLContext.setCurrent(glCongtext)
        self.backgroundColor = UIColor.white
        destoryrenderAndFrameBuffer()
        setupRenderBuffer()
        setupFrameBuffer()
        render()
    }
    
    func initContext() {
        glCongtext = EAGLContext(api: .openGLES2)
        if glCongtext == nil {
            print("Failed to initial OpenGLES 2.0 context")
            exit(1)
        }
        if !EAGLContext.setCurrent(glCongtext) {
            glCongtext = nil
            exit(1)
        }
    }
    
    func setupLayer() {
        eagLayer =  self.layer as? CAEAGLLayer
        eagLayer?.isOpaque = true
        eagLayer?.drawableProperties = [kEAGLDrawablePropertyRetainedBacking:false,kEAGLColorFormatSRGBA8:kEAGLDrawablePropertyColorFormat]
        
    }
    
    func destoryrenderAndFrameBuffer() {
        glDeleteFramebuffers(1, &ColorFrameBuffer)
        self.ColorFrameBuffer = 0
        glDeleteRenderbuffers(1, &ColorRenderBuffer)
        self.ColorRenderBuffer = 0
    }
    
    func setupRenderBuffer()  {
        var buffer : GLuint = 0
        glGenRenderbuffers(1, &buffer)
        ColorRenderBuffer = buffer
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), ColorRenderBuffer)
        glCongtext?.renderbufferStorage(Int(GL_RENDERBUFFER), from: self.eagLayer)
    }
    
    func setupFrameBuffer() {
        var buffer : GLuint = 0
        glGenFramebuffers(1, &buffer)
        self.ColorFrameBuffer = buffer
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), ColorFrameBuffer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), ColorRenderBuffer)
    }
    
    func render() {
        glClearColor(0, 1.0, 0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        //glCongtext?.presentRenderbuffer(Int(GL_RENDERBUFFER))
        glViewport(0, 0, GLsizei(self.frame.size.width), GLsizei(self.frame.size.height))
        let verrices : [GLfloat] = [
            0.0 , 0.5 , 0.0,
            -0.5 , -0.5, 0.0,
            0.5 , -0.5 , 0.0 ]
        let texCoords : [GLfloat] = [
            0,0,
            1,0,
            0,1]
        
//        var attrBuffer : GLuint = 0
//        glGenBuffers(1, &attrBuffer)
//        glBindBuffer(GLenum(GL_ARRAY_BUFFER), attrBuffer)
//        // swift3.0之后 将sizeof 移到MemoryLayout这个类
//        let size = MemoryLayout.size(ofValue: verrices) * verrices.count
//        glBufferData(GLenum(GL_ARRAY_BUFFER), GLsizeiptr(size), verrices, GLenum(GL_DYNAMIC_DRAW))
//        glVertexAttribPointer(positionSlot, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout.size(ofValue: GLfloat.self) * 3), nil)
        glVertexAttribPointer(positionSlot, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, verrices)
        let  atextCoor = GLuint(glGetAttribLocation(myProgram, "textCoordinate"))
        
        glVertexAttribPointer(atextCoor, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, texCoords)
        
       
        glEnableVertexAttribArray(positionSlot)
      //  glEnableVertexAttribArray(textCoor)
        // 加载纹理
       // self.setupTexture(fileName: "for_test")
        let rotate = glGetUniformLocation(myProgram, "rotateMatrix")
        let radians = 10 * 3.14 / 180.0
        let s = GLfloat(sin(radians))
        let c = GLfloat(cos(radians))
        
        let zRotation : [GLfloat] = [
            c, -s, 0, 0.2,
            s, c, 0, 0,
            0, 0, 1.0 ,0,
            0.0, 0, 0, 1.0]
        glUniform4fv(rotate, GLsizei(GL_FALSE), zRotation)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        glCongtext?.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
    
    func setupProgram() {
        let vertexShaderPath = Bundle.main.path(forResource: "VertexShader", ofType: "glsl")
        let fragmentShaderPath = Bundle.main.path(forResource: "FragmentShader", ofType: "glsl")
        myProgram = GLESUtils.loadProgram(vertexShaderFilepath: vertexShaderPath!, fragmentShaderFilepath: fragmentShaderPath!)
        if myProgram == 0 {
            print("Error: Failed to setup program.")
            return
        }
        //激活着色程序
        glUseProgram(myProgram)
        // Get attribute slot from program
        //let name = "vPosition"
        
        positionSlot = GLuint(glGetAttribLocation(myProgram, "vPosition"))
        
    }
    
    func setupTexture(fileName:String) {
        // 获取图片的CGImageRef
        let spriteImage = UIImage(named: fileName)?.cgImage
        if spriteImage == nil {
            print("Failed to load image \(fileName)")
            exit(1)
        }
        let width = spriteImage!.height
        let height = spriteImage!.width
        let spriteData = calloc(width * height, MemoryLayout.size(ofValue: GLubyte.self))
        let spriteContext = CGContext.init(data: spriteData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: (spriteImage?.colorSpace)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
//
//        //在CGContextRef上绘图
        spriteContext!.draw(spriteImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        
        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        glTexParameteri(GLenum(GL_TEXTURE_2D),GLenum(GL_TEXTURE_MIN_FILTER), GLint(GL_LINEAR))
        glTexParameteri(GLenum(GL_TEXTURE_2D),GLenum(GL_TEXTURE_MAG_FILTER), GLint(GL_LINEAR))
        glTexParameteri(GLenum(GL_TEXTURE_2D),GLenum(GL_TEXTURE_WRAP_S), GLint(GL_CLAMP_TO_EDGE))
        glTexParameteri(GLenum(GL_TEXTURE_2D),GLenum(GL_TEXTURE_WRAP_T), GLint(GL_CLAMP_TO_EDGE))
        let fw = width , fh = height
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GLint(GL_RGBA), GLsizei(fw), GLsizei(fh), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), spriteData)
        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        free(spriteData)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
