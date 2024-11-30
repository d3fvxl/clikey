const ArrayList = @import("std").ArrayList;
const ScreenTerminal = @import("ScreenTerminal.zig");
const ScreenMock = @import("ScreenMock.zig").ScreenMock;

// Screen interface.
pub const Screen = union(enum) {
    terminal: *const ScreenTerminal,

    pub fn clear(self: Screen) !void {
        switch (self) {
            .terminal => |terminal| try terminal.clear(),
        }
    }

    pub fn print(self: Screen, words: ArrayList([]const u8)) !void {
        switch (self) {
            .terminal => |terminal| try terminal.print(words),
        }
    }

    pub fn move(self: Screen, row: usize, col: usize) !void {
        switch (self) {
            .terminal => |terminal| try terminal.move(row, col),
        }
    }
};
