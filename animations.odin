package main

import "core:strings"
import rl "vendor:raylib"


// all data needed for animating a sprite sheet for mostly any entity
animated_sprite_sheet :: struct {
	texture:        rl.Texture2D,
	frame_rec:      rl.Rectangle,
	max_frames:     i32,
	num_frames:     i32,
	num_animations: i32,
	cur_animation:  i32,
	frame_timer:    f32,
	curr_frame:     i32,
	frame_speed:    f32,
}

// loads texture and sets all data needed for animation
load_animated_sprite :: proc(
	texture: string,
	num_animations, max_frames: i32,
	frame_speed: f32,
) -> animated_sprite_sheet {
	a: animated_sprite_sheet
	a.texture = rl.LoadTexture(strings.clone_to_cstring(texture))
	a.max_frames = max_frames
	a.num_frames = max_frames
	a.frame_speed = frame_speed
	a.num_animations = num_animations
	a.frame_rec = {
		0,
		0,
		f32(a.texture.width / a.max_frames),
		f32(a.texture.height / a.num_animations),
	}
	return a
}

// updates frames to animate the sprite
animate_sprite :: proc(s: ^animated_sprite_sheet, dt: f32) {
	s.frame_timer += dt
	if s.frame_timer >= 1 / s.frame_speed {
		s.frame_timer = 0
		s.curr_frame += 1
		if s.curr_frame > s.num_frames {
			s.curr_frame = 0
		}
		s.frame_rec.x = f32(s.curr_frame) * s.frame_rec.width
	}
}

// changes the sprite frame_rec up or down, to change the animation
update_animation :: proc(s: ^animated_sprite_sheet, a: i32) {
	s.cur_animation = a
	s.frame_rec.y = f32(s.cur_animation) * s.frame_rec.height
}


// draws the animation, should work for any entity using the animated_sprite_sheet
draw_animated_sprite :: proc(s: ^animated_sprite_sheet, pos: rl.Vector2) {
	rl.DrawTextureRec(s.texture, s.frame_rec, pos, rl.WHITE)
}
