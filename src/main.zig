const std = @import("std");
const DictionaryFile = @import("DictionaryFile.zig");
const Game = @import("game.zig").Game;
const ScreenMock = @import("game.zig").ScreenMock;

pub fn main() !void {
    const path: []const u8 = "dict.txt";

    var dictionary_file = try DictionaryFile.init(std.heap.page_allocator, path);
    defer dictionary_file.deinit();

    const screen_mock = ScreenMock{};

    var game = Game.init(screen_mock.screen(), dictionary_file.dictionary());
    game.start();

    // const stdin = std.io.getStdIn().reader();
    // while (true) {
    //     screen.clear();
    //     try screen.printCenteredText("Hello!");
    //     const input = try stdin.readByte();
    //     if (input == 'q') break;
    // }
}
