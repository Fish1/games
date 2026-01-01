const rl = @import("raylib");

pub const Tower = struct {
    color: rl.Color,

    pub fn init(color: rl.Color) Tower {
        return .{
            .color = color,
        };
    }
};
