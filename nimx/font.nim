import ttf
import types

# Quick and dirty interface for fonts.
# TODO:
#  - Remove dependency on OpenGL.
#  - Lazy bucket loading for character ranges
#  - Distance field textures

import opengl


type Font* = ref object
    chars*: array[96, stbtt_bakedchar]
    texture*: GLuint

proc newFont*(pathToTTFile: string, size: float): Font =
    result.new()
    var rawData = readFile(pathToTTFile)
    const width = 512
    const height = 512
    var temp_bitmap : array[width * height, byte]
    const length = result.chars.len()
    let res = stbtt_BakeFontBitmap(cstring(rawData), 0, size, addr temp_bitmap, width, height, 32, length, addr result.chars) # no guarantee this fits!
    glGenTextures(1, addr result.texture)
    glBindTexture(GL_TEXTURE_2D, result.texture)
    glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, width, height, 0, GL_ALPHA, GL_UNSIGNED_BYTE, addr temp_bitmap)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)

var sysFont : Font

proc systemFont*(): Font =
    if sysFont == nil:
        when defined(macosx):
            sysFont = newFont("/Library/Fonts/Arial.ttf", 16.0)
        else:
            sysFont = newFont("/usr/share/fonts/truetype/ubuntu-font-family/Ubuntu-R.ttf", 16.0)
    result = sysFont

proc getQuadDataForChar*(f: Font, ch: char, quad: var array[16, Coord], pt: var Point) =
    if ch.ord >= 32 and ch.ord < 128:
        var x, y: cfloat
        x = pt.x
        y = pt.y
        var q : stbtt_aligned_quad

        stbtt_GetBakedQuad(f.chars, 512, 512, ch.ord-32, x, y, q, true) # true=opengl & d3d10+,false=d3d9
        quad = [ q.x0, q.y0, q.s0, q.t0,
                q.x1, q.y0, q.s1, q.t0,
                q.x1, q.y1, q.s1, q.t1,
                q.x0, q.y1, q.s0, q.t1 ]
        pt.x = x
        pt.y = y
    else:
        f.getQuadDataForChar('?', quad, pt)

