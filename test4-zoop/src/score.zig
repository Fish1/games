const std = @import("std");

pub var score: i32 = 0;
pub var pickup_speed_multiplier: i32 = 1;
pub var pickup_speed_multiplier_timer: f32 = 0.0;
pub var pickup_speed_multiplier_timer_reset: f32 = 1.0;

pub fn get_current_level() i32 {
    return switch (score) {
        0...99 => 1,
        100...299 => 2,
        300...599 => 3,
        600...1399 => 4,
        1400...2999 => 5,
        3000...6199 => 6,
        6200...12599 => 7,
        12600...25399 => 8,
        25400...50999 => 9,
        else => 10,
    };
}

pub fn get_score_to_levelup() i32 {
    return switch (get_current_level()) {
        1 => 100,
        2 => 300,
        3 => 600,
        4 => 1400,
        5 => 3000,
        6 => 6200,
        7 => 12600,
        8 => 25400,
        9 => 51000,
        else => 100000,
    };
}

fn get_score_bonus() i32 {
    return @divFloor(score, 1000);
}

fn get_score_multiplier() i32 {
    return pickup_speed_multiplier;
}

fn get_score_per_gem() i32 {
    return std.math.pow(i32, get_current_level(), 2);
}

pub fn calculate_score(gems: i32) i32 {
    return (gems * get_score_per_gem() * get_score_multiplier()) + get_score_bonus();
}
