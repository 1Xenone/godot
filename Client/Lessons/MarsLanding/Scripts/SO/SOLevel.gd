extends Resource
class_name Level

export(float) var mars_gravity = 3.2;
export(float) var frameDuration = .5
export(float) var landingSpeed = 10
export(float) var timeBeforeClosing = 2

export(Vector2) var shipPosition = Vector2(660, 170)
export(Array, Vector2) var landingPad = [Vector2(530, 505), Vector2(800, 505)]
