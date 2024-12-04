const ArrayList = @import("std").ArrayList;
const ScreenTerminal = @import("ScreenTerminal.zig").ScreenTerminal;
const RoundStats = @import("Game.zig").RoundStats;

pub const ScreenPixel = struct {
    row: usize,
    col: usize,
};

// Screen interface.
pub const Screen = union(enum) {
    terminal: *ScreenTerminal,

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

    pub fn printStats(self: Screen, stats: RoundStats) !void {
    switch (self) {
        .terminal => |terminal| return try terminal.printStats(stats),
    }
}

    pub fn move(self: Screen, row: usize, col: usize) !void {
        switch (self) {
            .terminal => |terminal| try terminal.move(row, col),
        }
    }

    pub fn write(self: Screen, chars: []const u8) !void {
        switch (self) {
            .terminal => |terminal| try terminal.write(chars),
        }
    }
};
