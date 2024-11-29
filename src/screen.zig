const ArrayList = @import("std").ArrayList;

// Screen interface.
pub const Screen = struct {
    ptr: *anyopaque,
    clearFunc: *const fn (ptr: *anyopaque) anyerror!void,

    fn clear(self: Screen) !void {
        return self.clearFunc(self.ptr);
    }
};
