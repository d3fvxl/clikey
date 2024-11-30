const print = @import("std").debug.print;
const heap = @import("std").heap;
const testing = @import("std").testing;
const ArrayList = @import("std").ArrayList;
const Screen = @import("Screen.zig").Screen;
const Dictionary = @import("Dictionary.zig").Dictionary;

pub const RoundStats = struct {
    wpm: u8,
};

pub fn playRound(dictionary: Dictionary, screen: Screen) !RoundStats {
    const words = try dictionary.nextN(10);
    try screen.print(words);

    return .{
        .wpm = 10,
    };
}
