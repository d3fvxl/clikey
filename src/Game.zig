const std = @import("std");
const os = @import("std").os;
const Screen = @import("Screen.zig").Screen;
const Dictionary = @import("Dictionary.zig").Dictionary;

pub const RoundStats = struct {
    wpm: f64,
    cpm: f64,
};

pub fn playRound(
    dictionary: *Dictionary,
    screen: *const Screen,
) !RoundStats {
    const words = try dictionary.nextN(10);

    std.debug.print("{s}", .{words});
    try screen.clear();
    const start_pixel = try screen.print(words);
    try screen.move(start_pixel.row, start_pixel.col);

    var char_index: usize = 0; // Index of the current character in the word
    var buf: [1]u8 = undefined;
    // Record the start time
    const start_time = std.time.milliTimestamp();
    while (char_index < words.len) {
        const expected_char = words[char_index];
        // Read one character from stdin
        _ = try std.posix.read(std.posix.STDIN_FILENO, &buf);
        const char = buf[0];
        if (char == expected_char) {
            char_index += 1;
            try screen.write("\x1b[32m");
            try screen.write(buf[0..]);
            try screen.write("\x1b[0m");
            try screen.move(start_pixel.row, start_pixel.col + char_index);
        }
    }

    // Record the end time
    const end_time = std.time.milliTimestamp();
    const time_taken_ms = end_time - start_time;

    const wpm = @divFloor(60000, @divFloor(time_taken_ms, 10));
    const cpm = @divFloor(60000, @divFloor(time_taken_ms, @as(i64, @intCast(char_index))));

    return RoundStats{
        .wpm = @as(f64, @floatFromInt(wpm)),
        .cpm = @as(f64, @floatFromInt(cpm)),
    };
}
