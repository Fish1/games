const rl = @import("raylib");

pub const RedEnemy = DefineEnemy(1, .orange);
pub const GreenEnemy = DefineEnemy(2, .green);
pub const BlueEnemy = DefineEnemy(3, .blue);
pub const BlackEnemy = DefineEnemy(4, .gray);

pub const Enemy = union(enum) {
    red: RedEnemy,
    green: GreenEnemy,
    blue: BlueEnemy,
    black: BlackEnemy,
};

fn DefineEnemy(t: i32, color: rl.Color) type {
    return struct {
        type: i32 = t,
        color: rl.Color = color,

        pub fn init() @This() {
            return .{};
        }
    };
}
