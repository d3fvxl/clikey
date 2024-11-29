const print = @import("std").debug.print;
const ArrayList = @import("std").ArrayList;
const Screen = @import("Screen.zig").Screen;
const Dictionary = @import("Dictionary.zig").Dictionary;

pub const Game = struct {
    screen: Screen,
    dictionary: Dictionary,

    pub fn init(screen: Screen, dictionary: Dictionary) *Game {
        return .{
            .screen = screen,
            .dictionary = dictionary,
        };
    }

    pub fn deinit() void {}

    pub fn start(self: Game) !void {
        // clear screen
        try self.screen.clear();
        const words = try self.dictionary.nextN(10);
        try self.screen.move(20, 20);
        try self.screen.print(words);
    }
};

pub const ScreenMock = struct {
    pub fn clear(_: *anyopaque) !void {
        // const self: *ScreenMock = @ptrCast(@alignCast(ctx));
        print("clear", .{});
        return;
    }

    pub fn screen(_: ScreenMock) Screen {
        return .{
            .ptr = undefined,
            .clearFunc = clear,
        };
    }
};

test "Game_init" {
    Game.init();
}
