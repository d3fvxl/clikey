const ArrayList = @import("std").ArrayList;
const DictionaryFile = @import("DictionaryFile.zig");
const DictionaryMock = @import("DictionaryMock.zig").DictionaryMock;

// Dictionary interface.
pub const Dictionary = union(enum) {
    file: DictionaryFile,
    mock: DictionaryMock,

    pub fn nextN(self: Dictionary, n: usize) !ArrayList([]const u8) {
        switch (self) {
            .file => |file| return try file.nextN(n),
            .mock => |mock| return try mock.nextN(n),
        }
    }
};
