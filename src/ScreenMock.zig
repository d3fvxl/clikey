const print = @import("std").debug.print;

pub const ScreenMock = struct {
    pub fn clear(_: ScreenMock) !void {
        print("clear\n", .{});
        return;
    }
};
