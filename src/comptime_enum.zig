const std = @import("std");
const print = std.debug.print;
const EnumField = std.builtin.Type.EnumField;

pub fn EnumFromStringList(comptime tag_type: type, comptime string_list: []const []const u8) type {
    comptime var enum_field_list: [string_list.len]EnumField = undefined;

    comptime var index = 0;
    inline while (index < string_list.len) : (index += 1) {
        enum_field_list[index] = .{
            .name = string_list[index],
            .value = index,
        };
    }

    return @Type(.{
        .Enum = .{
            .tag_type = tag_type,
            .fields = &enum_field_list,
            .decls = &.{},
            .is_exhaustive = true,
        },
    });
}

pub fn main() !void {
    print("lets build an enum with comptime\n", .{});

    const direction_list = [_][]const u8{
        "north",
        "south",
        "east",
        "west",
    };

    const Direction = EnumFromStringList(u32, &direction_list);
    const north = Direction.north;

    switch (north) {
        .north => print("you chose north\n", .{}),
        .south => print("you chose south\n", .{}),
        .east => print("you chose east\n", .{}),
        .west => print("you chose west\n", .{}),
    }
}
