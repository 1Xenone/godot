extends Resource
class_name Ship

export(float) var vSpeed = 80
export(float) var vDistance = 0
export(float) var Fuel = 0
export(float) var thrust = 0

enum GameState {Running, Crashed, Landed}

export(GameState) var state = GameState.Running
