import view
export view

import composition
import animation
import window

import times
import math

type ProgressIndicator* = ref object of View
    mPosition: Coord
    mIndeterminate: bool
    animation: Animation

var piComposition = newComposition """
uniform float uPosition;

float radius = 5.0;

void compose() {
    float stroke = sdRoundedRect(bounds, radius);
    float fill = sdRoundedRect(insetRect(bounds, 1.0), radius - 1.0);
    drawShape(stroke, newGrayColor(0.78));
    drawShape(fill, newGrayColor(0.88));

    vec4 progressRect = bounds;
    progressRect.z *= uPosition;
    vec4 fc = gradient(smoothstep(bounds.y, bounds.y + bounds.w, vPos.y),
        vec4(0.71, 0.80, 0.88, 1.0),
        0.5, vec4(0.32, 0.68, 0.95, 1.0),
        vec4(0.71, 0.80, 0.88, 1.0));

    drawShape(sdAnd(fill, sdRect(progressRect)), fc);
}
"""

var indeterminateComposition = newComposition """
uniform float uPosition;

float radius = 5.0;

void compose() {
    float stroke = sdRoundedRect(bounds, radius);
    float fill = sdRoundedRect(insetRect(bounds, 1.0), radius - 1.0);
    drawShape(stroke, newGrayColor(0.78));

    float st = 20.0;
    float p = mod(vPos.x + vPos.y - uPosition * st * 3.0, st);
    vec4 fc = gradient(smoothstep(0.0, st, p),
        vec4(0.88, 0.88, 0.88, 1.0),
        0.5, vec4(0.32, 0.68, 0.95, 1.0),
        vec4(0.88, 0.88, 0.88, 1.0));

    drawShape(fill, fc);
}
"""

method init(v: ProgressIndicator, r: Rect) =
    procCall v.View.init(r)
    v.animation = newAnimation()
    v.animation.finished = true
    v.animation.onAnimate = proc(p: float) =
        v.setNeedsDisplay()

proc drawBecauseNimBug(v: ProgressIndicator, r: Rect) =
    if v.mIndeterminate:
        indeterminateComposition.draw v.bounds:
            setUniform("uPosition", float32(epochTime() mod 1.0))
    else:
        piComposition.draw v.bounds:
            setUniform("uPosition", v.mPosition)

method draw*(v: ProgressIndicator, r: Rect) =
    v.drawBecauseNimBug(r)

proc `position=`*(v: ProgressIndicator, p: Coord) =
    v.mPosition = p
    v.setNeedsDisplay()

proc position*(v: ProgressIndicator): Coord = v.mPosition

proc indeterminate*(v: ProgressIndicator): bool = v.mIndeterminate
proc `indeterminate=`*(v: ProgressIndicator, flag: bool) =
    v.mIndeterminate = flag
    if v.animation.finished and flag and not v.window.isNil:
        v.window.addAnimation(v.animation)
    elif not flag:
        v.animation.cancel()

method viewWillMoveToWindow*(v: ProgressIndicator, w: Window) =
    if w.isNil:
        v.animation.cancel()
    elif v.mIndeterminate:
        w.addAnimation(v.animation)
