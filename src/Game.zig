const std = @import("std");
const os = @import("std").os;
const Screen = @import("Screen.zig").Screen;
const Dictionary = @import("Dictionary.zig").Dictionary;

pub const RoundStats = struct {
    cpm: f64,
};

pub fn playRound(
    dictionary: *Dictionary,
    screen: *const Screen,
) !RoundStats {
    const words = try dictionary.nextN(10);
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
        if (char == 'q') {
            break;
        }
        if (buf[0] == expected_char) {
            char_index += 1;
            try screen.move(start_pixel.row, start_pixel.col + char_index);
        }
    }

    // Record the end time
    const end_time = std.time.milliTimestamp();
    const time_taken_ms = end_time - start_time;

    // Calculate CPM
    const cpm = @divFloor(@as(i64, @intCast(char_index)), time_taken_ms);

    return RoundStats{
        .cpm = @as(f64, @floatFromInt(cpm)) / 1000.0,
    };
}
