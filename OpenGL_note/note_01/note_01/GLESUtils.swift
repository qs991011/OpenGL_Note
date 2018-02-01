//
//  GLESUtils.swift
//  note_01
//
//  Created by qiansheng on 2017/11/10.
//  Copyright © 2017年 qiansheng. All rights reserved.
//

import UIKit

let v_type = GL_VERTEX_SHADER
let f_type = GL_FRAGMENT_SHADER


class GLESUtils: NSObject {
    class  func loadShader(type:GLenum,filepath:String) ->GLuint {
        let shaderString : String?
        
        do{
            try shaderString = String(contentsOfFile: filepath, encoding: .utf8)
            if shaderString == nil {
                print("Error: loading shader file:%s",filepath)
                return 0
            }
            return loadShader(type: type, shaderString: shaderString!)
        } catch {
            print(error)
            return 0
        }
    }
    
    class  func loadShader(type:GLenum,shaderString:String) ->GLuint {
        let shader = glCreateShader(type)
        if shader == 0 {
            print("Error: failed to create shader")
            return 0
        }
        var shaderStringUTF8 = (shaderString as NSString).utf8String
        //glShaderSource(shader, 1, &shaderStringUTF8, nil)
        //着色器源码附加到着色器对象上
        glShaderSource(shader, 1, &shaderStringUTF8, nil)
        //把着色器源代码编译成目标代码
        glCompileShader(shader)
        var complied : GLint = 0
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &complied)
        if complied == 0 {
            var infoLen : GLint = 0
            glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH),&infoLen)
            if infoLen > 1 {
                let infolog = UnsafeMutablePointer<GLchar>.allocate(capacity: 1)
                glGetShaderInfoLog(shader, infoLen, nil, infolog)
                print("Error compiling shader:\n%s\n",infolog)
                free(infolog)
            }
            glDeleteShader(shader)
            return 0
        }
        return shader
    }
    
    class func loadProgram(vertexShaderFilepath:String,fragmentShaderFilepath:String)->GLuint {
        let vertexShader = self.loadShader(type: GLenum(GL_VERTEX_SHADER), filepath: vertexShaderFilepath)
        if vertexShader == 0 {
            return 0
        }
        let fragmentShader = self.loadShader(type: GLenum(GL_FRAGMENT_SHADER), filepath: fragmentShaderFilepath)
        
        if  fragmentShader == 0{
            return 0
        }
        //创建一个着色器程序
        let programHandle = glCreateProgram()
        if programHandle == 0 {
            return 0
        }
        /**
         着色器程序对象(Shader Program Object)是多个着色器合并之后并最终链接完成的版本。如果要使用刚才编译的着色器我们必须把它们链接(Link)为一个着色器程序对象，然后在渲染对象的时候激活这个着色器程序。已激活着色器程序的着色器将在我们发送渲染调用的时候被使用。
         当链接着着色器至一个程序的时候，它会把每个着色器的输出链接到下个着色器的输入。当输出和输入不匹配的时候，会得到一个链接错误
         */
        // 链接着色器到着色程序
        glAttachShader(programHandle, vertexShader)
        glAttachShader(programHandle, fragmentShader)
        // 链接着色器程序
        glLinkProgram(programHandle)
        var linked : GLint = 0
        // 验证着色器是否成功
        glGetProgramiv(programHandle, GLenum(GL_LINK_STATUS), &linked)
        if linked == 0 {
            var infoLen : GLint = 0
            glGetProgramiv(programHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLen)
            if infoLen > 1 {
                let infolog = UnsafeMutablePointer<GLchar>.allocate(capacity: 1)
                glGetShaderInfoLog(programHandle, infoLen, nil, infolog)
                print("Error compiling shader:\n%s\n",infolog)
                free(infolog)
            }
            glDeleteProgram(programHandle)
            return 0
        }
        glDeleteShader(vertexShader)
        glDeleteShader(fragmentShader)
        return programHandle
        
    }
    
}
