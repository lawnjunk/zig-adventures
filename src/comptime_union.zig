const std = @import("std");
const print = std.debug.print;
const ContainerLayout = std.builtin.Type.ContainerLayout;
const UnionField = std.builtin.Type.UnionField;

// const ColorPallet = union {
//     simple: u8,
//     complex: u32,
// };

const UnionSpec = struct {
    name: []const u8,
    type: type,
};

pub fn UnionFromUnionSpecList(comptime union_spec_list: []const UnionSpec) type {
    comptime var field_list: [union_spec_list.len]UnionField = undefined;
    comptime var index = 0;
    inline while (index < field_list.len) : (index += 1) {
        const union_spec = union_spec_list[index];
        field_list[index] = .{
            .name = union_spec.name,
            .type = union_spec.type,
            .alignment = @alignOf(union_spec.type),
        };
    }

    return @Type(.{
        .Union = .{
            .layout = ContainerLayout.Auto,
            .fields = field_list[0..],
            .tag_type = null,
            .decls = &.{},
        },
    });
}

pub fn main() void {
    const union_spec_list = [_]UnionSpec{
        .{
            .name = "simple",
            .type = u8,
        },
        .{
            .name = "complex",
            .type = u32,
        },
    };

    const ColorPallet = UnionFromUnionSpecList(union_spec_list[0..]);
    const color = ColorPallet{ .simple = 4 };
    print("simple color {d}\n", .{color.simple});
}
