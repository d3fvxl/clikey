const std = @import("std");
const game = @import("Game.zig");
const Dictionary = @import("Dictionary.zig").Dictionary;
const Screen = @import("Screen.zig").Screen;
const DictionaryFile = @import("DictionaryFile.zig").DictionaryFile;
const ScreenTerminal = @import("ScreenTerminal.zig").ScreenTerminal;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var args = std.process.args();
    if (!args.skip()) {
        return error.InvalidArgument;
    }
    const path = args.next() orelse return error.InvalidArgument;

    var dictionary_file = try DictionaryFile.init(allocator, path[0..]);
    defer dictionary_file.deinit();
    var dictionary = Dictionary{ .file = dictionary_file };

    const screen_terminal = try ScreenTerminal.init(allocator);
    const screen = Screen{ .terminal = screen_terminal };

    var stdin = std.io.getStdIn().reader();

    while (true) {
        const stats = try game.playRound(&dictionary, &screen);

        try screen.clear();
        try screen.printStats(stats);

        _ = try stdin.readByte();
    }
    try screen.clear();
}
