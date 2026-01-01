const std = @import("std");
const rl = @import("raylib");

const Tower = @import("tower.zig").Tower;
const Enemy = @import("enemy.zig").Enemy;

pub fn Map(width: usize) type {
    return struct {
        size: usize = width * width,
        towers: [width * width]?Tower,
        enemies: [width * width]?Enemy,

        pub fn init() @This() {
            return @This(){
                .towers = std.mem.zeroes([width * width]?Tower),
                .enemies = std.mem.zeroes([width * width]?Enemy),
            };
        }

        pub fn add_tower(self: *@This(), tower: Tower, x: usize, y: usize) void {
            const index = (y * width) + x;
            self.towers[index] = tower;
        }

        pub fn add_enemy(self: *@This(), enemy: Enemy, x: usize, y: usize) void {
            const index = (y * width) + x;
            self.enemies[index] = enemy;
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
        }
    };
}
