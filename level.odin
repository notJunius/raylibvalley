package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"


// i hope we remember what everything is lmao
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

update_animate_sprite :: proc(s: ^animated_sprite_sheet, dt: f32) {
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

update_animation :: proc(s: ^animated_sprite_sheet, a: i32) {
	s.cur_animation = a
	s.frame_rec.y = f32(s.cur_animation) * s.frame_rec.height
}


draw_animated_sprite :: proc(s: ^animated_sprite_sheet) {
	rl.DrawTextureRec(s.texture, s.frame_rec, {100, 100}, rl.WHITE)
}
