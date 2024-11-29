const ScreenTerminal = @This();
const print = @import("std").debug.print;

pub fn clear(_: ScreenTerminal) !void {
    // ANSI escape code to clear the terminal screen
    print("\x1b[2J", .{}); // Clear screen
    print("\x1b[H", .{}); // Move cursor to home position
}
