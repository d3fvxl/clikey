const print = @import("std").debug.print;
const heap = @import("std").heap;
const ArrayList = @import("std").ArrayList;
const Screen = @import("Screen.zig").Screen;
const ScreenMock = @import("ScreenMock.zig").ScreenMock;
const Dictionary = @import("Dictionary.zig").Dictionary;
const DictionaryMock = @import("DictionaryMock.zig").DictionaryMock;

pub const Game = struct {
    screen: Screen,
    dictionary: Dictionary,

    pub fn init(screen: Screen, dictionary: Dictionary) Game {
        return .{
            .screen = screen,
            .dictionary = dictionary,
        };
    }

    pub fn deinit() void {}

    pub fn start(self: Game) !void {
        try self.screen.clear();
        const words = try self.dictionary.nextN(10);
        print("{any}\n", .{words.items});
        // try self.screen.move(20, 20);
        // try self.screen.print(words);
    }
};

test "Game_init" {
    const screen_mock = Screen{ .mock = ScreenMock{} };
    const dictionary_mock = Dictionary{ .mock = DictionaryMock{ .alloc = heap.page_allocator } };

    var game = Game.init(screen_mock, dictionary_mock);
    try game.start();
}
