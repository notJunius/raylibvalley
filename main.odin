package main

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "stardew valley")
	defer rl.CloseWindow()


	player := init_player("./assets/Characters/Premium Charakter Spritesheet.png", {100, 100}, 16)
	defer rl.UnloadTexture(player.sprite.texture)
	target_fps: i32 = 60


	camera := rl.Camera2D {
		target = {
			100 + player.sprite.frame_rec.width / 2,
			100 + player.sprite.frame_rec.height / 2,
		},
		zoom   = 10,
		offset = {f32(rl.GetRenderWidth()) / 2, f32(rl.GetRenderHeight()) / 2},
	}

	// this will change the anim which is set to an int which will change hight of player texture rect
	player.curr_animation = .water_left
	update_animation(&player.sprite, i32(player.curr_animation))

	rl.SetTargetFPS(target_fps)

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		update_animate_sprite(&player.sprite, dt)

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.BeginMode2D(camera)
		draw_animated_sprite(&player.sprite)
		rl.DrawRectangleLines(
			100,
			100,
			i32(player.sprite.frame_rec.width),
			i32(player.sprite.frame_rec.height),
			rl.WHITE,
		)
		rl.EndMode2D()
		rl.EndDrawing()
	}

}
