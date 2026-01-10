const std = @import("std");
const rl = @import("raylib");

const game = @import("game.zig");

var camera = rl.Camera2D{
    .offset = .{
        .x = 0,
        .y = 0,
    },
    .target = .{
        .x = 0,
        .y = 0,
    },
    .rotation = 0,
    .zoom = 0.5,
};

pub fn main() void {
    rl.initWindow(800, 450, "Raylib Test1");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    game.setup();

    while (rl.windowShouldClose() == false) {
        const delta = rl.getFrameTime();
        process(delta);
        draw();
    }
}

fn process(delta: f32) void {
    control_camera(delta);
    game.process(delta, camera);
}

fn control_camera(delta: f32) void {
    const camera_speed = 500;
    const zoom_speed = 1;

    if (rl.isKeyDown(.right)) {
        camera.target.x = camera.target.x + camera_speed * delta;
    } else if (rl.isKeyDown(.left)) {
        camera.target.x = camera.target.x - camera_speed * delta;
    } else if (rl.isKeyDown(.up)) {
        camera.target.y = camera.target.y - camera_speed * delta;
    } else if (rl.isKeyDown(.down)) {
        camera.target.y = camera.target.y + camera_speed * delta;
    }

    if (rl.isKeyDown(.right_bracket)) {
        camera.zoom = camera.zoom + zoom_speed * delta;
    }

    if (rl.isKeyDown(.left_bracket)) {
        camera.zoom = camera.zoom - zoom_speed * delta;
    }
}

fn draw() void {
    rl.beginDrawing();
    defer rl.endDrawing();
    rl.beginMode2D(camera);

    rl.clearBackground(.black);
    game.draw();

    rl.endMode2D();
    rl.drawText("Press space for next turn...", 5, 5, 24, .white);
    game.draw_ui();
}
