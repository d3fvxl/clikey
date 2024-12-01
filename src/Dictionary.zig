const print = @import("std").debug.print;
const Allocator = @import("std").mem.Allocator;
const ArrayList = @import("std").ArrayList;
const DictionaryFile = @import("DictionaryFile.zig");

// Dictionary interface.
pub const Dictionary = union(enum) {
    file: *const DictionaryFile,

    pub fn nextN(self: Dictionary, n: usize) !*ArrayList([]const u8) {
        switch (self) {
            .file => |file| return try file.nextN(n),
        }
    }
};

pub const DictionaryMock = struct {
    nextNFunc: *const fn(self: DictionaryMock, n: usize) anyerror!ArrayList([]const u8),

    pub fn nextN(self: DictionaryMock, n: usize) !ArrayList([]const u8) {
        return self.nextNFunc(self, n);
    }
};
