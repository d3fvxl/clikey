const ArrayList = @import("std").ArrayList;
const ScreenTerminal = @import("ScreenTerminal.zig");
const ScreenMock = @import("ScreenMock.zig").ScreenMock;

// Screen interface.
pub const Screen = union(enum) {
    terminal: ScreenTerminal,
    mock: ScreenMock,

    pub fn clear(self: Screen) !void {
        switch (self) {
            .terminal => |terminal| try terminal.clear(),
            .mock => |mock| try mock.clear(),
        }
    }
};
