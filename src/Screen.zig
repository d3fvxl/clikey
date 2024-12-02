const ArrayList = @import("std").ArrayList;
const ScreenTerminal = @import("ScreenTerminal.zig");
const ScreenMock = @import("ScreenMock.zig").ScreenMock;

pub const ScreenPixel = struct {
    row: usize,
    col: usize,
};

// Screen interface.
pub const Screen = union(enum) {
    terminal: *const ScreenTerminal,

    pub fn clear(self: Screen) !void {
        switch (self) {
            .terminal => |terminal| try terminal.clear(),
        }
    }

    pub fn print(self: Screen, words: []const u8) !ScreenPixel {
        switch (self) {
            .terminal => |terminal| return try terminal.print(words),
        }
    }

    pub fn move(self: Screen, row: usize, col: usize) !void {
        switch (self) {
            .terminal => |terminal| try terminal.move(row, col),
        }
    }
};
