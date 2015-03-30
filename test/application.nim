import nimx.view
import nimx.logging
import nimx.context
import nimx.matrixes
import nimx.button
import nimx.event
import nimx.text_field
import nimx.app
import nimx.image
import nimx.render_to_image


when defined js:
    import nimx.js_canvas_window
    type PlatformWindow = JSCanvasWindow
else:
    import nimx.sdl_window
    type PlatformWindow = SdlWindow

const isMobile = defined(ios) or defined(android)

template c*(a: string) = discard

type GameWindow = ref object of PlatformWindow

var catImage : Image

var renderedImage : Image

proc startApplication() =
    var mainWindow : GameWindow
    mainWindow.new()

    when isMobile:
        mainWindow.initFullscreen()
    elif defined js:
        mainWindow.initWithCanvasId("mainCanvas")
    else:
        mainWindow.init(newRect(0, 0, 800, 600))

    catImage = imageWithResource("cat.jpg")

    mainWindow.title = "Test MyGame"

    let v1 = newView(newRect(20, 20, mainWindow.frame.width - 40, 100))
    mainWindow.addSubview(v1)

    let b1 = newButton(newRect(20, 20, 50, 50))
    v1.addSubview(b1)

    b1.title = "button"
    v1.autoresizingMask = { afFlexibleWidth, afFlexibleMaxY }

    b1.onAction do ():
        echo "Hello world!"

    let t1 = newTextField(newRect(90, 20, v1.bounds.width - 110, 25))
    v1.addSubview(t1)
    t1.autoresizingMask = { afFlexibleWidth, afFlexibleHeight }
    t1.text = "This is a text field"

    let t2 = newTextField(newRect(90, 50, v1.bounds.width - 110, 25))
    v1.addSubview(t2)
    t2.autoresizingMask = { afFlexibleWidth, afFlexibleHeight }
    t2.text = "This is another text field"

var rot = 0.0

method draw(w: GameWindow, r: Rect) =
    let c = currentContext()
    c.fillColor = newGrayColor(0.5)
    var imageRect = zeroRect
    imageRect.size = catImage.size
    imageRect.origin = centerInRect(imageRect.size, w.bounds)
    c.drawImage(catImage, imageRect)
    var tmpTransform = c.transform
    tmpTransform.translate(newVector3(w.frame.width/2, w.frame.height/3, 0))
    tmpTransform.rotateZ(rot)
    tmpTransform.translate(newVector3(-50, -50, 0))
    rot += 0.03
    c.withTransform tmpTransform:
        c.fillColor = newColor(0, 1, 1)
        c.strokeColor = newColor(0, 0, 0, 1)
        c.strokeWidth = 9.0
        c.drawEllipseInRect(newRect(0, 0, 100, 200))

    tmpTransform = c.transform

    tmpTransform.translate(newVector3(w.frame.width/2, w.frame.height/3 * 2, 0))
    tmpTransform.rotateZ(-rot)
    tmpTransform.translate(newVector3(-50, -50, 0))
    if renderedImage.isNil:
        renderedImage = imageWithSize(newSize(100, 200))
        renderedImage.draw do():
            let ctx = currentContext()
            c.fillColor = newColor(0.5, 0.5, 0)
            ctx.drawRoundedRect(newRect(0, 0, 100, 200), 40)

    c.withTransform tmpTransform:
        c.drawImage(renderedImage, newRect(0, 0, 100, 200))

when defined js:
    import dom
    window.onload = proc (e: ref TEvent) =
        startApplication()
        startAnimation()
else:
    startApplication()
    runUntilQuit()

