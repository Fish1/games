const rl = @import("raylib");

pub const SoundID = enum(usize) {
    game_over,
    score,
    swap,
    jump,
    powerup,
    laser,
};

pub const SoundLoader = struct {
    sounds: [6]rl.Sound,

    pub fn init() !@This() {
        return .{
            .sounds = .{
                try rl.loadSound("./assets/gameover.wav"),
                try rl.loadSound("./assets/score.wav"),
                try rl.loadSound("./assets/swap.wav"),
                try rl.loadSound("./assets/jump.wav"),
                try rl.loadSound("./assets/powerup.wav"),
                try rl.loadSound("./assets/laser.wav"),
            },
        };
    }

    pub fn deinit(self: *@This()) void {
        for (self.sounds) |sound| {
            sound.unload();
        }
    }

    pub fn play(self: *@This(), sound_id: SoundID) void {
        const sound = self.get(sound_id);
        rl.playSound(sound.*);
    }

    fn get(self: *@This(), sound_id: SoundID) *rl.Sound {
        return &self.sounds[@intFromEnum(sound_id)];
    }
};

pub const MusicID = enum(usize) {
    example,
};

pub const MusicLoader = struct {
    music: [1]rl.Music,

    pub fn init() !@This() {
        return .{
            .music = .{try rl.loadMusicStream("./assets/song.wav")},
        };
    }

    pub fn deinit(self: *@This()) void {
        for (self.music) |music| {
            music.unload();
        }
    }

    pub fn play(self: *@This(), music_id: MusicID) void {
        const music = self.get(music_id);
        rl.playMusicStream(music.*);
    }

    pub fn stop(self: *@This(), music_id: MusicID) void {
        const music = self.get(music_id);
        rl.stopMusicStream(music.*);
    }

    pub fn update(self: *@This()) void {
        for (&self.music) |*music| {
            if (rl.isMusicStreamPlaying(music.*) == true) {
                rl.updateMusicStream(music.*);
            }
        }
    }

    fn get(self: *@This(), music_id: MusicID) *rl.Music {
        return &self.music[@intFromEnum(music_id)];
    }
};
