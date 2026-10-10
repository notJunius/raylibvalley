package main

import rl "vendor:raylib"

PLAYER_ANIMATIONS :: enum i32 {
	idle_front = 0,
	idle_back,
	idle_right,
	idle_left,
	walk_forward,
	walk_backward,
	walk_right,
	walk_left,
	run_forward,
	run_backward,
	run_right,
	run_left,
	hoe_forward,
	hoe_backward,
	hoe_right,
	hoe_left,
	axe_forward,
	axe_backward,
	axe_right,
	axe_left,
	water_forward,
	water_backward,
	water_right,
	water_left,
}

Player :: struct {
	sprite:         animated_sprite_sheet,
	pos:            rl.Vector2,
	velocity:       rl.Vector2,
	curr_animation: PLAYER_ANIMATIONS,
}

init_player :: proc(file_name: string, pos: rl.Vector2, frame_speed: f32) -> Player {
	p: Player
	p.pos = pos
	p.sprite = load_animated_sprite(file_name, 24, 8, frame_speed)
	return p
}
