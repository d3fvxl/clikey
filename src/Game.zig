const std = @import("std");
const os = @import("std").os;
const Screen = @import("Screen.zig").Screen;
const Dictionary = @import("Dictionary.zig").Dictionary;

pub const RoundStats = struct {
    wpm: f64,
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

    return RoundStats{
        .wpm = 9,
    };
}
