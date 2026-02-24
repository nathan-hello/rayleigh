const std = @import("std");

const ray = @cImport({
    @cInclude("raylib.h");
    @cInclude("raygui.h");
});

pub fn main() void {

    const path = std.posix.getenv("PATH") orelse return;

    std.debug.print("path: {s}\n", .{path});

    

    // path.?.len;
    //
    //
    // ray.InitWindow(800, 60, "mwitg");
    // defer ray.CloseWindow();
    //
    // while (!ray.WindowShouldClose()) {
    //     ray.BeginDrawing();
    //     ray.ClearBackground(ray.BLACK);
    //
    //     
    //     
    //     
    //     if (ray.GuiButton((ray.Rectangle){ .x = 10, .y = 10, .width = 100, .height = 30 }, "TEST") != 0) {
    //         // click logic
    //     }
    //
    //     ray.EndDrawing();
    // }
}
