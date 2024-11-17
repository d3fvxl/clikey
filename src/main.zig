const std = @import("std");
const dict = @import("dictionary.zig");

pub fn main() !void {
    const path: []const u8 = "dict.txt";

    var d = try dict.Dictionary.init(std.heap.page_allocator, path);
    defer d.deinit();
    d.printWords();
}
