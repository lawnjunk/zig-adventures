const std = @import("std");

const Adventure = struct {
    file_path: []const u8,
    command: []const u8,
    description: []const u8,
};

// to run an adventure run `$ zig build <command>` i.e. `$zig build comptime-enum`
const adventure_list = [_]Adventure{
    .{ .command = "comptime-enum", .file_path = "src/comptime_enum.zig", .description = "build an enum at comptime using @Type" },
    .{ .command = "comptime-union", .file_path = "src/comptime_union.zig", .description = "build a union at comptime using @Type" },
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    for (adventure_list) |adventure| {
        const exe_adventure = b.addExecutable(.{
            .name = adventure.command,
            .root_source_file = .{ .path = adventure.file_path },
            .target = target,
            .optimize = optimize,
        });
        b.installArtifact(exe_adventure);
        const run_cmd_adventure = b.addRunArtifact(exe_adventure);
        run_cmd_adventure.step.dependOn(b.getInstallStep());

        if (b.args) |args| {
            run_cmd_adventure.addArgs(args);
        }

        const run_step_adventure = b.step(adventure.command, adventure.description);
        run_step_adventure.dependOn(&run_cmd_adventure.step);
    }
}
