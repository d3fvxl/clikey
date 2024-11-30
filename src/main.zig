const std = @import("std");
const game = @import("Game.zig");
const Dictionary = @import("Dictionary.zig").Dictionary;
const Screen = @import("Screen.zig").Screen;
const DictionaryFile = @import("DictionaryFile.zig");
const ScreenTerminal = @import("ScreenTerminal.zig");

pub fn main() !void {
    const path: []const u8 = "dict.txt";

    var dictionary_file = try DictionaryFile.init(std.heap.page_allocator, path);
    defer dictionary_file.deinit();

    const screen_terminal = &ScreenTerminal{};

    const stats = try game.playRound(Dictionary{ .file = dictionary_file }, Screen{ .terminal = screen_terminal });
    std.debug.print("WPM: {d}", .{stats.wpm});

    // const stdin = std.io.getStdIn().reader();
    // while (true) {
    //     screen.clear();
    //     try screen.printCenteredText("Hello!");
    //     const input = try stdin.readByte();
    //     if (input == 'q') break;
    // }
}
