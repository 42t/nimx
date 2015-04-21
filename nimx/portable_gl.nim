
import opengl
# export opengl

when defined js:
    type
        GL* = ref GLObj
        GLObj {.importc.} = object
            VERTEX_SHADER* : GLenum
            FRAGMENT_SHADER* : GLenum
            TEXTURE_2D* : GLenum
            ONE_MINUS_SRC_ALPHA* : GLenum
            SRC_ALPHA* : GLenum
            BLEND* : GLenum
            TRIANGLE_FAN* : GLenum
            COLOR_BUFFER_BIT*: int
            STENCIL_BUFFER_BIT*: int
            TEXTURE_MIN_FILTER* : GLenum
            TEXTURE_MAG_FILTER* : GLenum
            LINEAR* : GLint
            NEAREST* : GLint
            FRAMEBUFFER* : GLenum
            RENDERBUFFER* : GLenum
            RGBA* : GLenum
            ALPHA* : GLenum
            UNSIGNED_BYTE* : GLenum
            COLOR_ATTACHMENT0* : GLenum
            DEPTH_ATTACHMENT* : GLenum
            DEPTH_STENCIL_ATTACHMENT* : GLenum
            DEPTH_COMPONENT16* : GLenum
            DEPTH_STENCIL* : GLenum
            DEPTH24_STENCIL8* : GLenum
            FRAMEBUFFER_BINDING* : GLenum
            RENDERBUFFER_BINDING* : GLenum
            STENCIL_TEST* : GLenum
            NEVER*, LESS*, LEQUAL*, GREATER*, GEQUAL*, EQUAL*, NOTEQUAL*, ALWAYS*: GLenum
            KEEP*, ZERO*, REPLACE*, INCR*, INCR_WRAP*, DECR*, DECR_WRAP*, INVERT*: GLenum

            compileShader*: proc(shader: GLuint)
            deleteShader*: proc(shader: GLuint)
            deleteProgram*: proc(prog: GLuint)
            attachShader*: proc(prog, shader: GLuint)

            linkProgram*: proc(prog: GLuint)
            drawArrays*: proc (mode: GLenum, first: GLint, count: GLsizei)
            createShader*: proc (shaderType: GLenum): GLuint
            createProgram*: proc (): GLuint
            createTexture*: proc(): GLuint
            createFramebuffer*: proc(): GLuint
            createRenderbuffer*: proc(): GLuint

            deleteFramebuffer*: proc(name: GLuint)
            deleteRenderbuffer*: proc(name: GLuint)

            bindAttribLocation*: proc (program, index: GLuint, name: cstring)
            enableVertexAttribArray*: proc (attrib: GLuint)
            disableVertexAttribArray*: proc (attrib: GLuint)
            getUniformLocation*: proc(prog: GLuint, name: cstring): GLint
            useProgram*: proc(prog: GLuint)
            enable*: proc(flag: GLenum)
            disable*: proc(flag: GLenum)
            viewport*: proc(x, y: GLint, width, height: GLsizei)
            clear*: proc(mask: int)
            bindTexture*: proc(target: GLenum, name: GLuint)
            bindFramebuffer*: proc(target: GLenum, name: GLuint)
            bindRenderbuffer*: proc(target: GLenum, name: GLuint)

            uniform4fv*: proc(location: GLint, data: array[4, GLfloat])
            uniform1f*: proc(location: GLint, data: GLfloat)
            uniformMatrix4fv*: proc(location: GLint, transpose: GLboolean, data: array[16, GLfloat])

            clearColor*: proc(r, g, b, a: GLfloat)
            clearStencil*: proc(s: GLint)
            blendFunc*: proc(sfactor, dfactor: GLenum)
            texParameteri*: proc(target, pname: GLenum, param: GLint)

            texImage2D*: proc(target: GLenum, level, internalformat: GLint, width, height: GLsizei, border: GLint, format, t: GLenum, pixels: pointer)
            framebufferTexture2D*: proc(target, attachment, textarget: GLenum, texture: GLuint, level: GLint)
            renderbufferStorage*: proc(target, internalformat: GLenum, width, height: GLsizei)
            framebufferRenderbuffer*: proc(target, attachment, renderbuffertarget: GLenum, renderbuffer: GLuint)

            stencilFunc*: proc(fun: GLenum, refe: GLint, mask: GLuint)
            stencilOp*: proc(fail, zfail, zpass: GLenum)
            colorMask*: proc(r, g, b, a: bool)
            depthMask*: proc(d: bool)
            stencilMask*: proc(m: GLuint)

            getError*: proc(): GLenum


else:
    type GL* = ref object
    template VERTEX_SHADER*(gl: GL): GLenum = GL_VERTEX_SHADER
    template FRAGMENT_SHADER*(gl: GL): GLenum = GL_FRAGMENT_SHADER
    template TEXTURE_2D*(gl: GL): GLenum = GL_TEXTURE_2D
    template ONE_MINUS_SRC_ALPHA*(gl: GL): GLenum = GL_ONE_MINUS_SRC_ALPHA
    template SRC_ALPHA*(gl: GL): GLenum = GL_SRC_ALPHA
    template BLEND*(gl: GL): GLenum = GL_BLEND
    template TRIANGLE_FAN*(gl: GL): GLenum = GL_TRIANGLE_FAN
    template COLOR_BUFFER_BIT*(gl: GL): GLbitfield = GL_COLOR_BUFFER_BIT
    template STENCIL_BUFFER_BIT*(gl: GL): GLbitfield = GL_STENCIL_BUFFER_BIT
    template TEXTURE_MIN_FILTER*(gl: GL): GLenum = GL_TEXTURE_MIN_FILTER
    template TEXTURE_MAG_FILTER*(gl: GL): GLenum = GL_TEXTURE_MAG_FILTER
    template LINEAR*(gl: GL): GLint = GL_LINEAR
    template NEAREST*(gl: GL): GLint = GL_NEAREST
    template FRAMEBUFFER*(gl: GL): GLenum = GL_FRAMEBUFFER
    template RENDERBUFFER*(gl: GL): GLenum = GL_RENDERBUFFER
    template RGBA*(gl: GL): expr = GL_RGBA
    template ALPHA*(gl: GL): expr = GL_ALPHA
    template UNSIGNED_BYTE*(gl: GL): GLenum = GL_UNSIGNED_BYTE
    template COLOR_ATTACHMENT0*(gl: GL): GLenum = GL_COLOR_ATTACHMENT0
    template DEPTH_ATTACHMENT*(gl: GL): GLenum = GL_DEPTH_ATTACHMENT
    template DEPTH_STENCIL_ATTACHMENT*(gl: GL): GLenum = GL_DEPTH_ATTACHMENT
    template DEPTH_COMPONENT16*(gl: GL): GLenum = GL_DEPTH_COMPONENT16
    template DEPTH_STENCIL*(gl: GL): GLenum = GL_DEPTH_STENCIL
    template DEPTH24_STENCIL8*(gl: GL): GLenum = GL_DEPTH24_STENCIL8
    template FRAMEBUFFER_BINDING*(gl: GL): GLenum = GL_FRAMEBUFFER_BINDING
    template RENDERBUFFER_BINDING*(gl: GL): GLenum = GL_RENDERBUFFER_BINDING
    template STENCIL_TEST*(gl: GL): GLenum = GL_STENCIL_TEST

    template NEVER*(gl: GL): GLenum = GL_NEVER
    template LESS*(gl: GL): GLenum = GL_LESS
    template LEQUAL*(gl: GL): GLenum = GL_LEQUAL
    template GREATER*(gl: GL): GLenum = GL_GREATER
    template GEQUAL*(gl: GL): GLenum = GL_GEQUAL
    template EQUAL*(gl: GL): GLenum = GL_EQUAL
    template NOTEQUAL*(gl: GL): GLenum = GL_NOTEQUAL
    template ALWAYS*(gl: GL): GLenum = GL_ALWAYS

    template KEEP*(gl: GL): GLenum = GL_KEEP
    template ZERO*(gl: GL): GLenum = GL_ZERO
    template REPLACE*(gl: GL): GLenum = GL_REPLACE
    template INCR*(gl: GL): GLenum = GL_INCR
    template INCR_WRAP*(gl: GL): GLenum = GL_INCR_WRAP
    template DECR*(gl: GL): GLenum = GL_DECR
    template DECR_WRAP*(gl: GL): GLenum = GL_DECR_WRAP
    template INVERT*(gl: GL): GLenum = GL_INVERT

    template compileShader*(gl: GL, shader: GLuint) = glCompileShader(shader)
    template deleteShader*(gl: GL, shader: GLuint) = glDeleteShader(shader)
    template deleteProgram*(gl: GL, prog: GLuint) = glDeleteProgram(prog)
    template attachShader*(gl: GL, prog, shader: GLuint) = glAttachShader(prog, shader)


    template linkProgram*(gl: GL, prog: GLuint) = glLinkProgram(prog)

    template drawArrays*(gl: GL, mode: GLenum, first: GLint, count: GLsizei) = glDrawArrays(mode, first, count)
    template createShader*(gl: GL, shaderType: GLenum): GLuint = glCreateShader(shaderType)
    template createProgram*(gl: GL): GLuint = glCreateProgram()
    proc createTexture*(gl: GL): GLuint = glGenTextures(1, addr result)
    proc createFramebuffer*(gl: GL): GLuint {.inline.} = glGenFramebuffers(1, addr result)
    proc createRenderbuffer*(gl: GL): GLuint {.inline.} = glGenRenderbuffers(1, addr result)

    proc deleteFramebuffer*(gl: GL, name: GLuint) {.inline.} =
        var n = name
        glDeleteFramebuffers(1, addr n)

    proc deleteRenderbuffer*(gl: GL, name: GLuint) {.inline.} =
        var n = name
        glDeleteRenderbuffers(1, addr n)

    template bindAttribLocation*(gl: GL, program, index: GLuint, name: cstring) = glBindAttribLocation(program, index, name)
    template enableVertexAttribArray*(gl: GL, attrib: GLuint) = glEnableVertexAttribArray(attrib)
    template disableVertexAttribArray*(gl: GL, attrib: GLuint) = glDisableVertexAttribArray(attrib)
    template getUniformLocation*(gl: GL, prog: GLuint, name: cstring): GLint = glGetUniformLocation(prog, name)
    template useProgram*(gl: GL, prog: GLuint) = glUseProgram(prog)
    template enable*(gl: GL, flag: GLenum) = glEnable(flag)
    template disable*(gl: GL, flag: GLenum) = glDisable(flag)
    template viewport*(gl: GL, x, y: GLint, width, height: GLsizei) = glViewport(x, y, width, height)
    template clear*(gl: GL, mask: GLbitfield) = glClear(mask)
    template bindTexture*(gl: GL, target: GLenum, name: GLuint) = glBindTexture(target, name)
    template bindFramebuffer*(gl: GL, target: GLenum, name: GLuint) = glBindFramebuffer(target, name)
    template bindRenderbuffer*(gl: GL, target: GLenum, name: GLuint) = glBindRenderbuffer(target, name)

    template uniform1f*(gl: GL, location: GLint, data: GLfloat) = glUniform1f(location, data)
    proc uniformMatrix4fv*(gl: GL, location: GLint, transpose: GLboolean, data: array[16, GLfloat]) {.inline.} =
        var p : ptr GLfloat
        {.emit: "`p` = `data`;".}
        glUniformMatrix4fv(location, 1, transpose, p)

    template clearColor*(gl: GL, r, g, b, a: GLfloat) = glClearColor(r, g, b, a)
    template clearStencil*(gl: GL, s: GLint) = glClearStencil(s)

    template blendFunc*(gl: GL, sfactor, dfactor: GLenum) = glBlendFunc(sfactor, dfactor)
    template texParameteri*(gl: GL, target, pname: GLenum, param: GLint) = glTexParameteri(target, pname, param)

    template texImage2D*(gl: GL, target: GLenum, level, internalformat: GLint, width, height: GLsizei, border: GLint, format, t: GLenum, pixels: pointer) =
        glTexImage2D(target, level, internalformat, width, height, border, format, t, pixels)
    template framebufferTexture2D*(gl: GL, target, attachment, textarget: GLenum, texture: GLuint, level: GLint) =
        glFramebufferTexture2D(target, attachment, textarget, texture, level)
    template renderbufferStorage*(gl: GL, target, internalformat: GLenum, width, height: GLsizei) = glRenderbufferStorage(target, internalformat, width, height)
    template framebufferRenderbuffer*(gl: GL, target, attachment, renderbuffertarget: GLenum, renderbuffer: GLuint) =
        glFramebufferRenderbuffer(target, attachment, renderbuffertarget, renderbuffer)

    template stencilFunc*(gl: GL, fun: GLenum, refe: GLint, mask: GLuint) = glStencilFunc(fun, refe, mask)
    template stencilOp*(gl: GL, fail, zfail, zpass: GLenum) = glStencilOp(fail, zfail, zpass)
    template colorMask*(gl: GL, r, g, b, a: bool) = glColorMask(r, g, b, a)
    template depthMask*(gl: GL, d: bool) = glDepthMask(d)
    template stencilMask*(gl: GL, m: GLuint) = glStencilMask(m)

    template getError*(gl: GL): GLenum = glGetError()


# TODO: This is a quick and dirty hack for render to texture.
var globalGL: GL

proc newGL*(canvasId: cstring): GL =
    when defined js:
        asm """
            var canvas = document.getElementById(`canvasId`);
            try
            {
                `result` = canvas.getContext("webgl", {stencil:true});
            }
            catch(err) {}
            if (`result` === null)
            {
                try
                {
                    `result` = canvas.getContext("experimental-webgl", {stencil:true});
                }
                catch(err) {}
            }

            if (`result` !== null)
            {
                `result`.viewportWidth = canvas.width;
                `result`.viewportHeight = canvas.height;
                `result`.getExtension('OES_standard_derivatives');
            }
            else
            {
                alert("Your browser does not support WebGL. Please, use a modern browser.");
            }
            """
        globalGL = result

proc sharedGL*(): GL = globalGL

proc shaderInfoLog*(gl: GL, s: GLuint): string =
    when defined js:
        var m: cstring
        asm """
            `m` = `gl`.getShaderInfoLog(`s`);
            """
        result = $m
    else:
        var infoLen: GLint
        result = ""
        glGetShaderiv(s, GL_INFO_LOG_LENGTH, addr infoLen)
        if infoLen > 0:
            var infoLog : cstring = cast[cstring](alloc(infoLen + 1))
            glGetShaderInfoLog(s, infoLen, nil, infoLog)
            result = $infoLog
            dealloc(infoLog)

proc programInfoLog*(gl: GL, s: GLuint): string =
    when defined js:
        var m: cstring
        asm "`m` = `gl`.getProgramInfoLog(`s`);"
        result = $m
    else:
        var infoLen: GLint
        result = ""
        glGetProgramiv(s, GL_INFO_LOG_LENGTH, addr infoLen)
        if infoLen > 0:
            var infoLog : cstring = cast[cstring](alloc(infoLen + 1))
            glGetProgramInfoLog(s, infoLen, nil, infoLog)
            result = $infoLog
            dealloc(infoLog)

proc shaderSource*(gl: GL, s: GLuint, src: cstring) =
    when defined js:
        asm "`gl`.shaderSource(`s`, `src`);"
    else:
        var srcArray = [src]
        glShaderSource(s, 1, cast[cstringArray](addr srcArray), nil)

proc isShaderCompiled*(gl: GL, shader: GLuint): bool =
    when defined js:
        asm "`result` = `gl`.getShaderParameter(`shader`, `gl`.COMPILE_STATUS);"
    else:
        var compiled: GLint
        glGetShaderiv(shader, GL_COMPILE_STATUS, addr compiled)
        result = if compiled == GL_TRUE: true else: false

proc isProgramLinked*(gl: GL, prog: GLuint): bool =
    when defined js:
        asm "`result` = `gl`.getProgramParameter(`prog`, `gl`.LINK_STATUS);"
    else:
        var linked: GLint
        glGetProgramiv(prog, GL_LINK_STATUS, addr linked)
        result = if linked == GL_TRUE: true else: false

proc vertexAttribPointer*(gl: GL, index: GLuint, size: GLint, normalized: GLboolean,
                        stride: GLsizei, data: openarray[GLfloat]) =
    when defined js:
        asm """
            if (typeof(`vertexAttribPointer`.__nimxSharedBuffer) == "undefined")
            {
                `vertexAttribPointer`.__nimxSharedBuffer = `gl`.createBuffer();
            }

            `gl`.bindBuffer(`gl`.ARRAY_BUFFER, `vertexAttribPointer`.__nimxSharedBuffer);
            `gl`.bufferData(`gl`.ARRAY_BUFFER, new Float32Array(`data`), `gl`.DYNAMIC_DRAW);
            `gl`.vertexAttribPointer(`index`, `size`, `gl`.FLOAT, `normalized`, `stride`, 0);
            """
    else:
        glVertexAttribPointer(index, size, cGL_FLOAT, normalized, stride, cast[pointer](data));

proc getParami*(gl: GL, pname: GLenum): GLint =
    when defined js:
        asm "`result` = `gl`.getParameter(`pname`);"
    else:
        glGetIntegerv(pname, addr result)

proc getViewport*(gl: GL): array[4, GLint] =
    when defined js:
        asm "`result` = `gl`.getParameter(`gl`.VIEWPORT);"
    else:
        glGetIntegerv(GL_VIEWPORT, addr result[0])

