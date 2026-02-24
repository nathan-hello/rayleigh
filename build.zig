const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "rayleigh",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // 1. Link C standard library
    exe.linkLibC();

    // 2. Add include paths (search for headers here)
    // For your local raygui.h
    exe.addIncludePath(b.path("include"));
    // For the system raylib.h
    exe.addIncludePath(.{ .cwd_relative = "/usr/local/include" });

    // 3. Compile the raygui implementation file
    exe.addCSourceFile(.{
        .file = b.path("include/raygui.c"),
        .flags = &[_][]const u8{ "-std=c99" }, // Standard for raylib/gui
    });

    // 4. Link the system raylib and its dependencies
    exe.linkSystemLibrary("raylib");
    // Standard Linux raylib dependencies
    exe.linkSystemLibrary("GL");
    exe.linkSystemLibrary("X11");
    exe.linkSystemLibrary("dl");
    exe.linkSystemLibrary("m");
    exe.linkSystemLibrary("rt");

    // 5. Build Artifacts
    b.installArtifact(exe);

    // 6. Create 'zig build run' step
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
