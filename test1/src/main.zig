const std = @import("std");
const rl = @import("raylib");

const Map = @import("map.zig").Map(100);

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
    .zoom = 1,
};

var map = Map.init();

pub fn main() void {
    const width = 800;
    const height = 450;

    rl.initWindow(width, height, "Raylib Test1");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    setup();

    while (rl.windowShouldClose() == false) {
        const delta = rl.getFrameTime();
        process(delta);
        draw();
    }
}

fn setup() void {
    map.add_tower(.init(.green), 0, 0);
    map.add_tower(.init(.blue), 1, 1);

    map.add_enemy(.init(.red), 3, 3);
}

fn process(delta: f32) void {
    control_camera(delta);
    if (rl.isKeyReleased(.space)) {
        map.next_turn();
    }
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
    map.draw();

    rl.endMode2D();
    rl.drawText("Press space for next turn...", 5, 5, 24, .white);
}
