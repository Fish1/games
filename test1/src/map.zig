const std = @import("std");
const rl = @import("raylib");
const vec = @import("Vector.zig");

const Tower = @import("tower.zig").Tower;
const Enemy = @import("enemy.zig").Enemy;

pub fn Map(width: usize) type {
    return struct {
        size: usize = width * width,
        towers: [width * width]?Tower,
        enemies: [width * width]?Enemy,
        build_position: rl.Vector2 = rl.Vector2{ .x = 0, .y = 0 },

        pub fn init() @This() {
            return @This(){
                .towers = std.mem.zeroes([width * width]?Tower),
                .enemies = std.mem.zeroes([width * width]?Enemy),
            };
        }

        pub fn get_mouse_tile_position(_: *@This(), camera: rl.Camera2D) vec.Vector2i32 {
            return .{
                .x = @intFromFloat(rl.getScreenToWorld2D(rl.getMousePosition(), camera).x / 64.0),
                .y = @intFromFloat(rl.getScreenToWorld2D(rl.getMousePosition(), camera).y / 64.0),
            };
        }

        pub fn add_tower(self: *@This(), tower: Tower, pos: vec.Vector2i32) void {
            if (pos.x < 0 or pos.x >= width or pos.y < 0 or pos.y >= width) {
                return;
            }
            const x: usize = @intCast(pos.x);
            const y: usize = @intCast(pos.y);
            const index = (y * width) + x;
            self.towers[index] = tower;
        }

        pub fn add_enemy(self: *@This(), enemy: Enemy, pos: vec.Vector2i32) void {
            if (pos.x < 0 or pos.x >= width or pos.y < 0 or pos.y >= width) {
                return;
            }
            const x: usize = @intCast(pos.x);
            const y: usize = @intCast(pos.y);
            const index = (y * width) + x;
            self.enemies[index] = enemy;
        }

        pub fn process(self: *@This(), camera: rl.Camera2D) void {
            self.put_build_template(camera);
        }

        pub fn put_build_template(self: *@This(), camera: rl.Camera2D) void {
            const world_position = rl.getScreenToWorld2D(rl.getMousePosition(), camera);
            self.build_position = world_position;
        }

        pub fn can_place_tile(self: *@This(), pos: vec.Vector2i32) bool {
            const x: i32 = pos.x;
            const y: i32 = pos.y;
            const size: i32 = @intCast(width);

            if (x < 0 or x >= width or y < 0 or y >= width) {
                return false;
            }

            const left_index: usize = @intCast(@max((y * size) + (x - 1), 0));
            const right_index: usize = @intCast(@min((y * size) + (x + 1), size - 1));
            const up_index: usize = @intCast(@max(((y - 1) * size) + x, 0));
            const down_index: usize = @intCast(@min(((y + 1) * size) + x, size - 1));

            var left = self.towers[left_index];
            if (x == 0) {
                left = null;
            }
            if (left) |_| {
                return true;
            }

            var right = self.towers[right_index];
            if (x == width - 1) {
                right = null;
            }
            if (right) |_| {
                return true;
            }

            var up = self.towers[up_index];
            if (y == 0) {
                up = null;
            }
            if (up) |_| {
                return true;
            }

            var down = self.towers[down_index];
            if (y == width - 1) {
                down = null;
            }
            if (down) |_| {
                return true;
            }

            return false;
        }

        pub fn next_turn(self: *@This()) void {
            std.debug.print("next turn!\n", .{});

            for (self.enemies, 0..) |_enemy, index| {
                if (_enemy) |enemy| {
                    const x: usize = @intCast(index % width);
                    const y: usize = @intCast(index / width);
                    if (x + 1 >= width or y >= width) {
                        continue;
                    }
                    const new_index: usize = (y * width) + (x + 1);
                    if (self.towers[new_index]) |_| {
                        continue;
                    }
                    self.enemies[new_index] = enemy;
                    self.enemies[index] = null;
                }
            }
        }

        pub fn draw(self: @This()) void {
            for (self.towers, 0..) |_tower, index| {
                if (_tower) |tower| {
                    const x: i32 = @intCast(index % width);
                    const y: i32 = @intCast(index / width);
                    const px = x * 64;
                    const py = y * 64;
                    rl.drawRectangle(px, py, 64, 64, tower.color);
                }
            }

            for (self.enemies, 0..) |_enemy, index| {
                if (_enemy) |enemy| {
                    const x: i32 = @intCast(index % width);
                    const y: i32 = @intCast(index / width);
                    const px = x * 64;
                    const py = y * 64;
                    rl.drawRectangle(px, py, 64, 64, enemy.color);
                }
            }

            const build_tile_x: i32 = @intFromFloat(@floor(self.build_position.x / 64.0));
            const build_world_x: i32 = build_tile_x * 64;
            const build_tile_y: i32 = @intFromFloat(@floor(self.build_position.y / 64.0));
            const build_world_y: i32 = build_tile_y * 64;

            rl.drawRectangle(build_world_x, build_world_y, 12, 12, .white);
            rl.drawRectangle(build_world_x + 64 - 12, build_world_y, 12, 12, .white);
            rl.drawRectangle(build_world_x, build_world_y + 64 - 12, 12, 12, .white);
            rl.drawRectangle(build_world_x + 64 - 12, build_world_y + 64 - 12, 12, 12, .white);
        }
    };
}
