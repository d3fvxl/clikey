const std = @import("std");
const game = @import("Game.zig");
const Dictionary = @import("Dictionary.zig").Dictionary;
const Screen = @import("Screen.zig").Screen;
const DictionaryFile = @import("DictionaryFile.zig").DictionaryFile;
const ScreenTerminal = @import("ScreenTerminal.zig");

pub fn main() !void {


    const allocator = std.heap.page_allocator;
    const path: []const u8 = "dict.txt";

    // initialize ditionary
    var dictionary_file = try DictionaryFile.init(allocator, path);
    defer dictionary_file.deinit();
    var dictionary = Dictionary{ .file = dictionary_file };

    const screen_terminal = try ScreenTerminal.init(allocator);
    const screen = Screen{ .terminal = screen_terminal };
    // Play a round of the game.
    const stats = try game.playRound(&dictionary, &screen);

    try screen.clear();
    // Display the results.
    std.debug.print("\nResults:\n", .{});
    std.debug.print("Words Per Minute (WPM): {d}\n", .{stats.cpm});
}
