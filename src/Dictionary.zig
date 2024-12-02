const print = @import("std").debug.print;
const Allocator = @import("std").mem.Allocator;
const ArrayList = @import("std").ArrayList;
const DictionaryFile = @import("DictionaryFile.zig").DictionaryFile;

// Dictionary interface.
pub const Dictionary = union(enum) {
    file: *DictionaryFile,

    pub fn nextN(self: Dictionary, n: usize) ![]const u8 {
        switch (self) {
            .file => |file| return try file.nextN(n),
        }
    }
};
