const std = @import("std");
const builtin = @import("builtin");
const io = std.io;
const os = std.os;
const ScreenTerminal = @This();
const ArrayList = @import("std").ArrayList;
const ScreenPixel = @import("Screen.zig").ScreenPixel;

pub fn clear(_: ScreenTerminal) !void {
    // ANSI escape code to clear the terminal screen
    std.debug.print("\x1b[2J", .{}); // Clear screen
    std.debug.print("\x1b[H", .{}); // Move cursor to home position
}

pub fn print(self: ScreenTerminal, words: []const u8) !ScreenPixel {
    try self.clear();
    const ts = try termSize(std.io.getStdOut()) orelse TermSize{
        .width = 60,
        .height = 80,
    };

    const row = ts.height / 2; // Center row
    var col: usize = 0;
    if (ts.width > words.len) {
        col = (ts.width - words.len) / 2; // Center column
    }
    try self.move(row, col); // Move cursor to the center

    std.debug.print("{s}", .{words});

    return ScreenPixel{
        .row = row,
        .col = col,
    };
}

pub fn move(_: ScreenTerminal, row: usize, col: usize) !void {
    // ANSI escape code to move the cursor to a specific position
    std.debug.print("\x1b[{};{}H", .{ row, col });
}

/// Terminal size dimensions
pub const TermSize = struct {
    /// Terminal width as measured number of characters that fit into a terminal horizontally
    width: u16,
    /// terminal height as measured number of characters that fit into terminal vertically
    height: u16,
};

/// supports windows, linux, macos
///
/// ## example
///
/// ```zig
/// const std = @import("std");
/// const termSize = @import("termSize");
///
/// fn main() !void {
///   std.debug.print(
///     "{any}",
///     termSize.termSize(std.os.getStdOut()),
///   );
/// }
/// ```
pub fn termSize(file: std.fs.File) !?TermSize {
    if (!file.supportsAnsiEscapeCodes()) {
        return null;
    }
    return switch (builtin.os.tag) {
        .windows => blk: {
            var buf: os.windows.CONSOLE_SCREEN_BUFFER_INFO = undefined;
            break :blk switch (os.windows.kernel32.GetConsoleScreenBufferInfo(
                file.handle,
                &buf,
            )) {
                os.windows.TRUE => TermSize{
                    .width = @intCast(buf.srWindow.Right - buf.srWindow.Left + 1),
                    .height = @intCast(buf.srWindow.Bottom - buf.srWindow.Top + 1),
                },
                else => error.Unexpected,
            };
        },
        .linux, .macos => blk: {
            var buf: std.posix.system.winsize = undefined;
            break :blk switch (std.posix.errno(
                std.posix.system.ioctl(
                    file.handle,
                    std.posix.T.IOCGWINSZ,
                    @intFromPtr(&buf),
                ),
            )) {
                .SUCCESS => TermSize{
                    .width = buf.col,
                    .height = buf.row,
                },
                else => error.IoctlError,
            };
        },
        else => error.Unsupported,
    };
}

test "termSize" {
    std.debug.print("termsize {any}", .{termSize(std.io.getStdOut())});
}
