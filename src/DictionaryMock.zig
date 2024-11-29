const print = @import("std").debug.print;
const Allocator = @import("std").mem.Allocator;
const ArrayList = @import("std").ArrayList;

pub const DictionaryMock = struct {
    alloc: Allocator,

    pub fn nextN(self: DictionaryMock, n: usize) !ArrayList([]const u8) {
        print("next {d}\n", .{n});
        return ArrayList([]const u8).init(self.alloc);
    }
};
