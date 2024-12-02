const fs = @import("std").fs;
const heap = @import("std").heap;
const debug = @import("std").debug;
const mem = @import("std").mem;
const testing = @import("std").testing;

const Allocator = mem.Allocator;
const ArrayList = @import("std").ArrayList;
const Dictionary = @import("Dictionary.zig");

const MB: usize = 1024 * 1024;
const DEBUG_LOADED =
    \\Loading dictionary from path: {s}, size: {d} bytes, words: {d}\n
;

pub const DictionaryFile = struct {
    alloc: Allocator,
    words: []const u8,
    cursor: usize,

    pub fn init(alloc: Allocator, path: []const u8) !*DictionaryFile {
        // open dictionary file
        const f = try fs.cwd().openFile(path, .{});
        defer f.close();
        // read file content into buffer
        const data = try f.readToEndAlloc(alloc, MB);
        const self = try alloc.create(DictionaryFile);
        self.* = DictionaryFile{
            .alloc = alloc,
            .words = data,
            .cursor = 0,
        };
        return self;
    }

    // deinit deinits Dictionary memory.
    pub fn deinit(self: DictionaryFile) void {
        self.alloc.free(self.words);
    }

    pub fn nextN(self: *DictionaryFile, n: usize) ![]const u8 {
        var words_count: usize = 0;
        const start: usize = self.cursor;

        while (self.cursor < self.words.len and words_count < n) {
            const char = self.words[self.cursor];

            if (char == ' ') {
                words_count += 1;
            }

            self.*.cursor += 1;

            if (words_count >= n) {
                break;
            }
        }

        return self.words[start..self.cursor];
    }
};
