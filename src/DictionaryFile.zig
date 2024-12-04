const std = @import("std");
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
    gp_alloc: Allocator,
    data: []const u8,
    words: [][]const u8,
    cursor: usize,

    pub fn init(alloc: Allocator, path: []const u8) !*DictionaryFile {
        // open dictionary file
        const f = try fs.cwd().openFile(path, .{});
        defer f.close();
        // read file content into buffer
        const data = try f.readToEndAlloc(alloc, MB);
        errdefer {
            alloc.free(data);
        }
        const words = try filter(alloc, data);
        const self = try alloc.create(DictionaryFile);
        self.* = DictionaryFile{
            .gp_alloc = alloc,
            .data = data,
            .words = words,
            .cursor = 0,
        };
        return self;
    }

    pub fn deinit(self: DictionaryFile) void {
        self.gp_alloc.free(self.data);
        self.gp_alloc.free(self.words);
    }

    // Returns a list of random words from dictionary.
    // These errors are possible:
    //  - error.NoWordsAvailable: self-descriptive.
    pub fn nextN(self: *DictionaryFile, n: usize) ![]const u8 {
        if (self.words.len == 0) {
            return error.NoWordsAvailable;
        }
        const word_indexes = try self.gp_alloc.alloc(usize, self.words.len);
        for (self.words, 0..) |_, idx| {
            word_indexes[idx] = idx;
        }
        std.crypto.random.shuffle(usize, word_indexes);
        const count = if (n > self.words.len) self.words.len else n;

        var total_length: usize = 0;
        for (word_indexes[0..count]) |idx| {
            total_length += self.words[idx].len;
            // +1 for space
            if (idx < word_indexes.len - 1) {
                total_length += 1;
            }
        }

        var result = try self.gp_alloc.alloc(u8, total_length);
        errdefer {
            self.gp_alloc.free(result);
        }

        var offset: usize = 0;
        for (word_indexes[0..count]) |idx| {
            const word = self.words[idx];
            std.mem.copyForwards(u8, result[offset .. offset + word.len], word);
            offset += word.len;
            if (offset < total_length - 1) {
                result[offset] = ' ';
                offset += 1;
            }
        }

        return result[0..offset];
    }
};

const allowed_special_chars = [_]u8{};

fn isAllowedSpecialChar(c: u8) bool {
    return std.mem.indexOf(u8, allowed_special_chars[0..], c) != null;
}

fn isIdentifierStart(c: u8) bool {
    return (c >= 'A' and c <= 'Z') or (c >= 'a' and c <= 'z') or c == '_';
}

fn isIdentifierPart(c: u8) bool {
    return isIdentifierStart(c) or (c >= '0' and c <= '9');
}

fn isWhitespace(c: u8) bool {
    return c == ' ' or c == '\t' or c == '\n' or c == '\r';
}

fn isLetter(c: u8) bool {
    return (c >= 'A' and c <= 'Z') or (c >= 'a' and c <= 'z');
}

fn isDigit(c: u8) bool {
    return c >= '0' and c <= '9';
}

pub fn filter(alloc: std.mem.Allocator, raw_input: []const u8) ![][]const u8 {
    var word_set = std.StringHashMap([]const u8).init(alloc);
    defer word_set.deinit();

    var i: usize = 0;

    while (i < raw_input.len) {
        // skop non-letter characters
        while (i < raw_input.len and !isLetter(raw_input[i])) {
            i += 1;
        }
        if (i >= raw_input.len) break;

        // first letter character
        const start = i;
        if (isLetter(raw_input[i])) {
            // continue until a non-letter character is found
            i += 1;
            while (i < raw_input.len and isLetter(raw_input[i])) {
                i += 1;
            }

            const word_slice = raw_input[start..i];

            if (word_slice.len > 4) {
                if (word_set.get(word_slice) == null) {
                    const word_copy = try alloc.dupe(u8, word_slice);
                    try word_set.put(word_copy, "");
                }
            }
        } else {
            i += 1;
        }
    }

    var words_array = std.ArrayList([]const u8).init(alloc);

    var it = word_set.keyIterator();
    while (it.next()) |entry| {
        try words_array.append(entry.*);
    }

    return words_array.toOwnedSlice();
}
