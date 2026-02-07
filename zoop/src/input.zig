const rl = @import("raylib");

pub const Action = enum(usize) {
    move_left,
    move_right,
    move_up,
    move_down,

    attack_left,
    attack_right,
    attack_up,
    attack_down,

    start_game,
};

pub const Input = struct {
    keys: [9]rl.KeyboardKey,

    pub fn init() @This() {
        return .{
            .keys = .{
                .left,
                .right,
                .up,
                .down,
                .a,
                .d,
                .w,
                .s,
                .space,
            },
        };
    }

    fn action_to_key(self: @This(), action: Action) rl.KeyboardKey {
        return self.keys[@intFromEnum(action)];
    }

    pub fn is_action_pressed(self: @This(), action: Action) bool {
        return rl.isKeyPressed(self.action_to_key(action));
    }
};
