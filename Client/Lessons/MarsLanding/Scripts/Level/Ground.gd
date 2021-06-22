extends Area2D


export(Resource) var ship


func _on_Finish_area_shape_entered(area_id, area, area_shape, local_shape):
	ship.state = ship.GameState.Crashed
