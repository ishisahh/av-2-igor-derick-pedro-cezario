extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var marcador = preload("res://marcador.tscn")




var alvo_movimento = global_position


func _ready() -> void:
	pass


	
func _physics_process(delta: float) -> void:
	
	
	
	
	
	$Sketchfab_Scene.rotate_z(0)
	
	if velocity != Vector3.ZERO:
		set_collision_mask_value(2,false)
	else:
		set_collision_mask_value(2, true)
	
	look_at(alvo_movimento, Vector3.UP, true)
	var direcao = global_position.direction_to(alvo_movimento)
	velocity = direcao * SPEED

	if (global_position.distance_to(alvo_movimento) < SPEED * delta):
		velocity = Vector3.ZERO

	move_and_slide()
	
	
func atirar_raio_da_camera(mouse_pos: Vector2):

	var camera = get_viewport().get_camera_3d()
	var origin = camera.project_ray_origin(mouse_pos)
	var end = origin + camera.project_ray_normal(mouse_pos) * 1000
	var space_state = get_world_3d().direct_space_state

	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)

	if result.is_empty():
		return null
	else:
		return result.position


func _input(event: InputEvent) -> void:
	
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

		var pos_3d = atirar_raio_da_camera(event.position)

		if pos_3d != null:
			print("Sucesso! O mouse clicou na posição 3D: ",pos_3d)
			var mark = marcador.instantiate()
			add_sibling(mark)
			mark.global_position = pos_3d
			alvo_movimento = pos_3d
		else:
			print("O raio foi atirado, mas não atingiu nenhum objeto com colisão.")


func _on_delete_mark_area_entered(area: Area3D) -> void:
	if area.is_in_group("Marcador"):
		var mark = area.get_parent()
		mark.queue_free()
