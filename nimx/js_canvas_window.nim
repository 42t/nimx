import window
import logging
import view
import context
import matrixes
import dom
import app
import portable_gl
import event

type JSCanvasWindow* = ref object of Window
    renderingContext: GraphicsContext

export window

proc setupWebGL() =
    asm """
        window.requestAnimFrame = (function() {
            return window.requestAnimationFrame ||
                window.webkitRequestAnimationFrame ||
                window.mozRequestAnimationFrame ||
                window.oRequestAnimationFrame ||
                window.msRequestAnimationFrame ||
                function(/* function FrameRequestCallback */ callback, /* DOMElement Element */ element) {
                window.setTimeout(callback, 1000/60);
        };
    })();
    """

setupWebGL()

proc buttonCodeFromJSEvent(e: ref TEvent): KeyCode =
    case e.button:
        of 1: kcMouseButtonPrimary
        of 2: kcMouseButtonSecondary
        of 3: kcMouseButtonMiddle
        else: kcUnknown

proc eventLocationFromJSEvent(e: ref TEvent, c: ref dom.TNode): Point =
    var offx, offy: Coord
    asm """
    var r = `c`.getBoundingClientRect();
    `offx` = r.left;
    `offy` = r.top;
    """
    result.x = e.clientX.Coord - offx
    result.y = e.clientY.Coord - offy

proc setupEventHandlersForCanvas(w: JSCanvasWindow, c: ref dom.TNode) =
    let onmousedown = proc (e: ref TEvent) =
        var evt = newMouseDownEvent(eventLocationFromJSEvent(e, c), buttonCodeFromJSEvent(e))
        evt.window = w
        discard mainApplication().handleEvent(evt)

    let onmouseup = proc (e: ref TEvent) =
        var evt = newMouseUpEvent(eventLocationFromJSEvent(e, c), buttonCodeFromJSEvent(e))
        evt.window = w
        discard mainApplication().handleEvent(evt)

    let onmousemove = proc (e: ref TEvent) =
        var evt = newMouseMoveEvent(eventLocationFromJSEvent(e, c))
        evt.window = w
        discard mainApplication().handleEvent(evt)

    # TODO: Remove this hack, when handlers definition in dom.nim fixed.
    asm """
    `c`.onmousedown = `onmousedown`;
    `c`.onmouseup = `onmouseup`;
    `c`.onmousemove = `onmousemove`;
    """

method initWithCanvasId*(w: JSCanvasWindow, id: cstring) =
    var width, height: Coord
    var canvas = document.getElementById(id)
    asm """
    `width` = `canvas`.width;
    `height` = `canvas`.height;
    """
    procCall w.Window.init(newRect(0, 0, width, height))
    w.renderingContext = newGraphicsContext(id)

    w.setupEventHandlersForCanvas(canvas)

    w.enableAnimation(true)
    mainApplication().addWindow(w)

proc newJSCanvasWindow*(canvasId: string): JSCanvasWindow =
    result.new()
    result.initWithCanvasId(canvasId)

method drawWindow*(w: JSCanvasWindow) =
    let c = w.renderingContext
    c.gl.clear(c.gl.COLOR_BUFFER_BIT)
    let oldContext = setCurrentContext(c)
    defer: setCurrentContext(oldContext)
    c.withTransform ortho(0, w.frame.width, w.frame.height, 0, -1, 1):
        procCall w.Window.drawWindow()

method onResize*(w: JSCanvasWindow, newSize: Size) =
    #glViewport(0, 0, GLSizei(newSize.width), GLsizei(newSize.height))
    procCall w.Window.onResize(newSize)

proc startAnimation*() =
    mainApplication().runAnimations()
    mainApplication().drawWindows()
    asm "window.requestAnimFrame(`startAnimation`);"

