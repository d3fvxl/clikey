const fs = @import("std").fs;
const heap = @import("std").heap;
const debug = @import("std").debug;
const mem = @import("std").mem;
const testing = @import("std").testing;

const Allocator = mem.Allocator;
const ArrayList = @import("std").ArrayList;

const MB: usize = 1024 * 1024;
const DEBUG_LOADED =
    \\Loading dictionary from path: {s}, size: {d} bytes, words: {d}\n
;

// Dictionary contains words used by clikey.
pub const Dictionary = struct {
    alloc: Allocator,
    path: []const u8,
    words: ArrayList([]const u8),

    // init inits word Dictionary from file by path using alloc Allocator.
    pub fn init(alloc: Allocator, path: []const u8) !*const Dictionary {
        // open dictionary file
        const f = try fs.cwd().openFile(path, .{});
        defer f.close();
        // read file content into buffer
        const data = try f.readToEndAlloc(alloc, MB);
        const words = try parseWords(alloc, data);
        const result = alloc.create(Dictionary) catch return error.OutOfMemory;
        result.* = Dictionary{
            .alloc = alloc,
            .path = path,
            .words = words,
        };
        return result;
    }

    // deinit deinits Dictionary memory.
    pub fn deinit(self: *const Dictionary) void {
        self.words.deinit();
        self.alloc.destroy(self);
    }

    pub fn printWords(self: *const Dictionary) void {
        debug.print("Words len: {d}\n", .{self.words.items.len});

        for (self.words.items, 0..) |item, i| {
            debug.print("Word {d}: {s}\n", .{ i, item });
        }
    }
};

// parse parses data into std.ArrayList of []const u8 using alloc allocator.
fn parseWords(alloc: Allocator, data: []const u8) !ArrayList([]const u8) {
    // array of words
    var words = ArrayList([]const u8).init(alloc);
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

test "parseWords: parses sequence of words into array list" {
    const a = testing.allocator;
    var list = ArrayList([]const u8).init(a);
    defer list.deinit();

    try list.append("test");
    try list.append("mest");
    try list.append("vest");

    const input: []const u8 = "test mest vest";

    var words = try parseWords(a, input);
    defer words.deinit();

    while (list.items.len != 0) {
        const expected: []const u8 = list.pop();
        const actual: []const u8 = words.pop();
        try testing.expect(mem.eql(u8, expected, actual));
    }
}
