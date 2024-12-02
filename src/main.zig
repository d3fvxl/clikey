const std = @import("std");
const game = @import("Game.zig");
const Dictionary = @import("Dictionary.zig").Dictionary;
const Screen = @import("Screen.zig").Screen;
const DictionaryFile = @import("DictionaryFile.zig").DictionaryFile;
const ScreenTerminal = @import("ScreenTerminal.zig").ScreenTerminal;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    // const path: []const u8 = "dict.txt";
    const path: []const u8 = "src/ScreenTerminal.zig";

    // Initialize the dictionary
    var dictionary_file = try DictionaryFile.init(allocator, path);
    defer dictionary_file.deinit();
    var dictionary = Dictionary{ .file = dictionary_file };

    const screen_terminal = try ScreenTerminal.init(allocator);
    const screen = Screen{ .terminal = screen_terminal };

    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    while (true) {
        // Play a round of the game
        const stats = try game.playRound(&dictionary, &screen);

        try screen.clear();
        // Display the results
        try stdout.print("\nResults:\n", .{});
        try stdout.print("Characters Per Minute (CPM): {d}\n", .{stats.cpm});

        _ = try stdin.readByte();
    }

    // Clear the screen before exiting
    try screen.clear();
}

