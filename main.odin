package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "stardew valley")
	defer rl.CloseWindow()


	player := init_player("./assets/Characters/Premium Charakter Spritesheet.png", {100, 100}, 16)
	defer rl.UnloadTexture(player.sprite.texture)
	target_fps: i32 = 60


	camera := rl.Camera2D {
		target = {
			player.pos.x + player.sprite.frame_rec.width / 2,
			player.pos.y + player.sprite.frame_rec.height / 2,
		},
		zoom   = 5,
		offset = {f32(rl.GetRenderWidth()) / 2, f32(rl.GetRenderHeight()) / 2},
	}

	// this will change the anim which is set to an int which will change hight of player texture rect
	player.curr_animation = .idle_front
	update_animation(&player.sprite, i32(player.curr_animation))

	rl.SetTargetFPS(target_fps)

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()

		process_player_input(&player)
		move_player(&player, dt)

		update_player_animation(&player)

		animate_sprite(&player.sprite, dt)

		camera.target = {
			player.pos.x + player.sprite.frame_rec.width / 2,
			player.pos.y + player.sprite.frame_rec.height / 2,
		}

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.BeginMode2D(camera)
		// draws a bunch of squares
		// this is to see if we are moving
		for i in 0 ..< 100 {
			for j in 0 ..< 100 {
				if i % 2 == 0 {
					if j % 2 == 0 {
						rl.DrawRectangle(i32(i * 20), i32(j * 20), 20, 20, rl.PINK)
					}
				}
			}
		}

		draw_animated_sprite(&player.sprite, player.pos)
		//		rl.DrawRectangleLines(
		//			100,
		//			100,
		//			i32(player.sprite.frame_rec.width),
		//			i32(player.sprite.frame_rec.height),
		//			rl.WHITE,
		//		)
		rl.EndMode2D()
		rl.EndDrawing()
	}

}
