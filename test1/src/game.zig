const rl = @import("raylib");
const std = @import("std");
const Map = @import("map.zig").Map(100);

var map = Map.init();
var lives: u32 = 3;
var build: u32 = 1;

const Enemy = @import("enemy.zig").Enemy;
const BasicEnemy = Enemy.init(.red);

const Tower = @import("tower.zig").Tower;
const Basic = Tower.init(.white, 2, 2);
const Fast = Tower.init(.green, 1, 1);
const Strong = Tower.init(.blue, 3, 5);

pub fn setup() void {}

pub fn process(_: f32, camera: rl.Camera2D) void {
    map.process(camera);
    if (rl.isMouseButtonReleased(.left) and build > 0) {
        const tile_position = map.get_mouse_tile_position(camera);
        const can_build = map.can_place_tile(tile_position);
        if (can_build == true) {
            map.add_tower(Basic.copy(), tile_position);
            build = build - 1;
        }
    }
    if (rl.isKeyReleased(.space)) {
        map.next_turn();
        build = build + 10;
    }

    for (map.towers, 0..) |_tower, index| {
        if (_tower) |tower| {
            const x: i32 = @intCast(@mod(index, 100));
            const y: i32 = @intCast(@divFloor(index, 100));
            tower.process(.{ .x = x, .y = y }, &map.enemies);
        }
    }
}

pub fn draw() void {
    map.draw();
}

pub fn draw_ui() void {
    draw_lives();
    draw_builds();
}

fn draw_lives() void {
    var buffer: [24]u8 = undefined;
    const result = std.fmt.bufPrintZ(&buffer, "Lives: {d}", .{lives}) catch unreachable;
    rl.drawText(result, 5, 48, 24, .white);
}

fn draw_builds() void {
    var buffer: [24]u8 = undefined;
    const result = std.fmt.bufPrintZ(&buffer, "Builds: {d}", .{build}) catch unreachable;
    rl.drawText(result, 5, 48 + 24, 24, .white);
}
