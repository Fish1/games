const std = @import("std");
const rl = @import("raylib");
const Enemy = @import("enemy.zig").Enemy;

const width = 14;
const height = 4;
const size = width * height;

pub const Map = struct {
    enemies_left: [size]?Enemy = std.mem.zeroes([size]?Enemy),
    enemies_right: [size]?Enemy = std.mem.zeroes([size]?Enemy),
    enemies_up: [size]?Enemy = std.mem.zeroes([size]?Enemy),
    enemies_down: [size]?Enemy = std.mem.zeroes([size]?Enemy),

    pub fn init() @This() {
        var result: Map = .{};
        result.enemies_left[0] = .{ .red = .init() };
        result.enemies_left[1] = .{ .red = .init() };
        result.enemies_left[2] = .{ .red = .init() };

        result.enemies_right[0] = .{ .blue = .init() };
        return result;
    }

    pub fn draw(self: @This()) void {
        const tile_size = 64;
        for (0..width * height) |index| {
            const x: i32 = @intCast(@mod(index, width) * tile_size);
            const y: i32 = @intCast(@divFloor(index, height) * tile_size + (tile_size * width));
            const _e = self.enemies_left[index];
            if (_e) |e| {
                switch (e) {
                    .red => |re| {
                        rl.drawRectangle(x, y, tile_size, tile_size, re.color);
                    },
                    .green => |ge| {
                        rl.drawRectangle(x, y, tile_size, tile_size, ge.color);
                    },
                    .blue => |be| {
                        rl.drawRectangle(x, y, tile_size, tile_size, be.color);
                    },
                    .black => |ge| {
                        rl.drawRectangle(x, y, tile_size, tile_size, ge.color);
                    },
                }
            }

            const _e2 = self.enemies_right[index];
            if (_e2) |e| {
                switch (e) {
                    .red => |re| {
                        rl.drawRectangle(x, y, tile_size, tile_size, re.color);
                    },
                    .green => |ge| {
                        rl.drawRectangle(x, y, tile_size, tile_size, ge.color);
                    },
                    .blue => |be| {
                        rl.drawRectangle(x, y, tile_size, tile_size, be.color);
                    },
                    .black => |ge| {
                        rl.drawRectangle(x, y, tile_size, tile_size, ge.color);
                    },
                }
            }
        }
    }

    pub fn get_x_left(self: @This(), y: i32) i32 {
        const start: usize = @intCast(y * width);
        const end: usize = @intCast((y + 1) * width);
        for (start..end) |index| {
            const _enemy = self.enemies_left[index];
            if (_enemy) |_| {} else {
                const x: i32 = @intCast(@mod(index, width));
                return x;
            }
        }
        return width;
    }

    pub fn get_x_right(self: @This(), y: i32) i32 {
        const start: usize = @intCast(y * width);
        const end: usize = @intCast((y + 1) * width);
        var index: usize = end - 1;
        while (index >= start) : (index = index - 1) {
            const _enemy = self.enemies_right[index];
            if (_enemy) |_| {} else {
                return @intCast(@mod(index, width) + 18);
            }
        }
        return width + 18;
    }

    pub fn get_y_up(x: i32) i32 {
        return x + 1;
    }

    pub fn get_y_down(x: i32) i32 {
        return x + 1;
    }
};
