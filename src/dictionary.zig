const ArrayList = @import("std").ArrayList;

// Dictionary interface.
pub const Dictionary = struct {
    ptr: *anyopaque,
    nextNFunc: *const fn (ptr: *anyopaque, n: usize) anyerror!ArrayList,

    fn nextN(self: Dictionary, n: usize) !ArrayList {
        return self.nextNFunc(self.ptr, n);
    }
};
