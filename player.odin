package main

import "core:fmt"
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

PLAYER_DIRECTIONS :: enum {
	up,
	down,
	left,
	right,
}

// todo: figure out how to update all animations and movement using a state machine
player_state :: enum {
	walking,
	running,
	hoe,
	axe,
	water,
}

// todo: make collision rect the size of player, not size of frame
Player :: struct {
	sprite:           animated_sprite_sheet,
	pos:              rl.Vector2,
	velocity:         rl.Vector2,
	dir:              rl.Vector2,
	side:             f32,
	forward_backward: f32,
	is_running:       bool,
	walk_speed:       f32,
	run_speed:        f32,
	curr_animation:   PLAYER_ANIMATIONS,
	is_facing:        PLAYER_DIRECTIONS,
}

// makes player and loads all data needed
init_player :: proc(file_name: string, pos: rl.Vector2, frame_speed: f32) -> Player {
	p: Player
	p.pos = pos
	p.sprite = load_animated_sprite(file_name, 24, 8, frame_speed)
	p.walk_speed = 10
	p.run_speed = 20
	return p
}

// turns bools from key inputs into a 1 or 0,
// and sets side and forward_backward to a 1, -1,
// or 0 to be used in direction later
process_player_input :: proc(p: ^Player) {
	p.side = (rl.IsKeyDown(.D) ? 1 : 0) - (rl.IsKeyDown(.A) ? 1 : 0)
	fmt.println(p.side)
	p.forward_backward = (rl.IsKeyDown(.S) ? 1 : 0) - (rl.IsKeyDown(.W) ? 1 : 0)
	p.is_running = rl.IsKeyDown(.LEFT_SHIFT)

}

// update player position
move_player :: proc(p: ^Player, dt: f32) {
	// detect whether player is moving up/down, left/right, or both (will normalize speed if both)
	p.dir = {p.side, p.forward_backward}
	if p.side != 0 && p.forward_backward != 0 {
		p.dir = rl.Vector2Normalize(p.dir)
	}
	// odin one line if statement to determine speed of movement
	speed := p.is_running ? p.run_speed : p.walk_speed
	p.pos += p.dir * speed * 10 * dt
}

// change player animation based on movement/direction
update_player_animation :: proc(p: ^Player) {
	switch {
	case p.forward_backward > 0:
		p.is_facing = .down
		if p.is_running {
			update_animation(&p.sprite, i32(PLAYER_ANIMATIONS.run_forward))
		} else {
			update_animation(&p.sprite, i32(PLAYER_ANIMATIONS.walk_forward))
		}
	case p.forward_backward < 0:
		p.is_facing = .up
		if p.is_running {
			update_animation(&p.sprite, i32(PLAYER_ANIMATIONS.run_backward))
		} else {
			update_animation(&p.sprite, i32(PLAYER_ANIMATIONS.walk_backward))
		}

	}
	switch {
	case p.side > 0:
		p.is_facing = .right
		if p.is_running {
			update_animation(&p.sprite, i32(PLAYER_ANIMATIONS.run_right))
		} else {
			update_animation(&p.sprite, i32(PLAYER_ANIMATIONS.walk_right))
		}
	case p.side < 0:
		p.is_facing = .left
		if p.is_running {
			update_animation(&p.sprite, i32(PLAYER_ANIMATIONS.run_left))
		} else {
			update_animation(&p.sprite, i32(PLAYER_ANIMATIONS.walk_left))
		}

	}
	if p.side == 0 && p.forward_backward == 0 {
		switch p.is_facing {
		case .up:
			update_animation(&p.sprite, i32(PLAYER_ANIMATIONS.idle_back))
		case .down:
			update_animation(&p.sprite, i32(PLAYER_ANIMATIONS.idle_front))
		case .left:
			update_animation(&p.sprite, i32(PLAYER_ANIMATIONS.idle_left))
		case .right:
			update_animation(&p.sprite, i32(PLAYER_ANIMATIONS.idle_right))
		}
	}
}
