const std = @import("std");
const fs = @import("std").fs;
const heap = @import("std").heap;
const debug = @import("std").debug;
const mem = @import("std").mem;

const MB: usize = 1024 * 1024;
const DEBUG_LOADED =
    \\Loading dictionary from path: {s}, size: {d} bytes, words: {d}\n
;

// Dictionary contains words used by clikey.
pub const Dictionary = struct {
    path: []const u8,
    words: std.ArrayList([]const u8),

    // init inits word Dictionary from file by path using alloc Allocator.
    pub fn init(alloc: mem.Allocator, path: []const u8) !*const Dictionary {
        // open dictionary file
        const f = try fs.cwd().openFile(path, .{});
        defer f.close();
        // read file content into buffer
        const data = try f.readToEndAlloc(alloc, MB);
        const words = try parseWords(alloc, data);
        const result = alloc.create(Dictionary) catch return error.OutOfMemory;
        result.* = Dictionary{
            .path = path,
            .words = words,
        };
        return result;
    }

    // deinit deinits Dictionary memory.
    pub fn deinit(self: *const Dictionary) void {
        self.words.deinit();
    }

    pub fn printWords(self: *const Dictionary) void {
        debug.print("Words len: {d}\n", .{self.words.items.len});

        for (self.words.items, 0..) |item, i| {
            debug.print("Word {d}: {s}\n", .{ i, item });
        }
    }
};

// parse parses data into std.ArrayList of []const u8 using alloc allocator.
fn parseWords(alloc: mem.Allocator, data: []u8) !std.ArrayList([]const u8) {
    // array of words
    var words = std.ArrayList([]const u8).init(alloc);
    // split file by line
    var lines = mem.splitSequence(u8, data, "\n");
    while (lines.next()) |line| {
        // split line by " "
        var line_words = mem.splitSequence(u8, line, " ");
        while (line_words.next()) |word| {
            if (word.len <= 0) continue;
            // add words to dictionary
            try words.append(word);
        }
    }
    return words;
}
