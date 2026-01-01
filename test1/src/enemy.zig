const rl = @import("raylib");

pub const Enemy = struct {
    color: rl.Color,

    pub fn init(color: rl.Color) Enemy {
        return .{
            .color = color,
        };
    }
};
