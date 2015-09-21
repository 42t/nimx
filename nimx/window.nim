
import view
import animation
import times
import context
import font

export view

# Window type is defined in view module


#TODO: Window size has two notions. Think about it.

method init*(w: Window, frame: Rect) =
    procCall w.View.init(frame)
    w.window = w
    w.animations = @[]
    w.needsDisplay = true

method `title=`*(w: Window, t: string) {.base.} = discard
method title*(w: Window): string {.base.} = ""


method onResize*(w: Window, newSize: Size) {.base.} =
    procCall w.View.setFrameSize(newSize)

# Bug 2488. Can not use {.global.} for JS target.
var lastTime = epochTime()
var lastFrame = 0.0

proc fps(): int =
    let curTime = epochTime()
    let thisFrame = curTime - lastTime
    lastFrame = (lastFrame * 0.9 + thisFrame * 0.1)
    result = (1.0 / lastFrame).int
    lastTime = curTime

method drawWindow*(w: Window) {.base.} =
    w.needsDisplay = false
    let c = currentContext()
    var pt = newPoint(w.frame.width - 80, 2)
    c.fillColor = blackColor()
    c.drawText(systemFont(), pt, "FPS: " & $fps())

    w.recursiveDrawSubviews()

method enableAnimation*(w: Window, flag: bool) {.base.} = discard

method startTextInput*(w: Window, r: Rect) {.base.} = discard
method stopTextInput*(w: Window) {.base.} = discard

proc runAnimations*(w: Window) =
    let t = epochTime()
    var i = 0
    w.needsDisplay = w.needsDisplay or w.animations.len > 0
    while i < w.animations.len:
        w.animations[i].tick(t)
        if w.animations[i].finished:
            w.animations.del(i)
            if w.animations.len == 0:
                w.enableAnimation(false)
        else:
            inc i

proc addAnimation*(w: Window, a: Animation) =
    if w.animations.len == 0:
        w.enableAnimation(true)
    a.prepare()
    w.animations.add(a)
