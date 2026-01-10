const rl = @import("raylib");
const vec = @import("Vector.zig");
const Enemy = @import("enemy.zig").Enemy;

pub const Tower = struct {
    color: rl.Color,
    speed: i32,
    power: i32,
    last_shot: i32,

    pub fn init(color: rl.Color, speed: i32, power: i32) @This() {
        return .{
            .color = color,
            .speed = speed,
            .power = power,
            .last_shot = 0,
        };
    }

    pub fn copy(self: @This()) @This() {
        return .{
            .color = self.color,
            .speed = self.speed,
            .power = self.power,
            .last_shot = self.last_shot,
        };
    }

    pub fn process(_: @This(), _: vec.Vector2i32, _: []?Enemy) void {}
};
