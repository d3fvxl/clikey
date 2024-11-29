const std = @import("std");
const dict = @import("dictionary.zig");
const screen = @import("screen.zig");

pub fn main() !void {
    const path: []const u8 = "dict.txt";
    var d = try dict.Dictionary.init(std.heap.page_allocator, path);
    defer d.deinit();
    d.printWords();
    const stdin = std.io.getStdIn().reader();
    var line: []const u8 = "Hello!";
    while (true) {
        screen.clear();
        try screen.printCenteredText(line);
        var input: [256]u8 = undefined;
        line = try stdin.readUntilDelimiter(&input, '\n');
        if (std.mem.eql(u8, line, "q")) break;    }
}
