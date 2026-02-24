const std = @import("std");

const ray = @cImport({
    @cInclude("raylib.h");
    @cInclude("raygui.h");
});

const pl = @cImport({
    @cInclude("property_list.h");
});

const screenWidth = 800;
const screenHeight = 480;

pub fn main() void {
    var focus: c_int = 0;
    var scroll: c_int = 0;

    const path = std.posix.getenv("PATH") orelse {
        return;
    };

    std.debug.print("path: {s}\n", .{path});

    ray.InitWindow(800, 600, "rayleigh");
    defer ray.CloseWindow();

    var buf: [24]u8 = undefined;
    @memcpy(buf[0..6], "Hello!");
    buf[6] = 0;

    var props = [_]pl.GuiDMProperty{
        .{ .name = @constCast("Bool"), .type = pl.GUI_PROP_BOOL, .flags = 0, .value = .{ .vbool = true } },
        .{ .name = @constCast("#102#SECTION"), .type = pl.GUI_PROP_SECTION, .flags = 0, .value = .{ .vsection = 2 } },
        .{ .name = @constCast("Int"), .type = pl.GUI_PROP_INT, .flags = 0, .value = .{ .vint = .{ .val = 123, .min = 0, .max = 0, .step = 1 } } },
        .{ .name = @constCast("Float"), .type = pl.GUI_PROP_FLOAT, .flags = 0, .value = .{ .vfloat = .{ .val = 0.99, .min = 0.0, .max = 0.0, .step = 1.0, .precision = 3 } } },
        .{ .name = @constCast("Text"), .type = pl.GUI_PROP_TEXT, .flags = 0, .value = .{ .vtext = .{ .val = &buf, .size = 30 } } },
        .{ .name = @constCast("Select"), .type = pl.GUI_PROP_SELECT, .flags = 0, .value = .{ .vselect = .{ .val = @constCast("ONE;TWO;THREE;FOUR"), .active = 0 } } },
        .{ .name = @constCast("Int Range"), .type = pl.GUI_PROP_INT, .flags = 0, .value = .{ .vint = .{ .val = 32, .min = 0, .max = 100, .step = 1 } } },
        .{ .name = @constCast("Rect"), .type = pl.GUI_PROP_RECT, .flags = 0, .value = .{ .vrect = .{ .x = 0, .y = 0, .width = 100, .height = 200 } } },
        .{ .name = @constCast("Vec2"), .type = pl.GUI_PROP_VECTOR2, .flags = 0, .value = .{ .v2 = .{ .x = 20, .y = 20 } } },
        .{ .name = @constCast("Vec3"), .type = pl.GUI_PROP_VECTOR3, .flags = 0, .value = .{ .v3 = .{ .x = 12, .y = 13, .z = 14 } } },
        .{ .name = @constCast("Vec4"), .type = pl.GUI_PROP_VECTOR4, .flags = 0, .value = .{ .v4 = .{ .x = 12, .y = 13, .z = 14, .w = 15 } } },
        .{ .name = @constCast("Color"), .type = pl.GUI_PROP_COLOR, .flags = 0, .value = .{ .vcolor = .{ .r = 0, .g = 255, .b = 0, .a = 255 } } },
    };

    var gridmousecell = ray.Vector2{ .x = 0, .y = 0 };

    ray.GuiLoadStyleDefault();

    ray.GuiSetStyle(ray.LISTVIEW, ray.LIST_ITEMS_HEIGHT, 24);
    ray.GuiSetStyle(ray.LISTVIEW, ray.SCROLLBAR_WIDTH, 12);

    ray.SetTargetFPS(60);

    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        ray.ClearBackground(ray.GetColor(@bitCast(ray.GuiGetStyle(ray.DEFAULT, ray.BACKGROUND_COLOR))));

        _ = ray.GuiGrid(ray.Rectangle{ .x = 0, .y = 0, .width = screenWidth, .height = screenHeight }, "Property List", 20, 2, &gridmousecell);

        pl.GuiDMPropertyList(pl.Rectangle{ .x = (screenWidth - 180) / 2, .y = (screenHeight - 280) / 2, .width = 180, .height = 280 }, &props, props.len, &focus, &scroll);

        if (props[0].value.vbool == true) {
            ray.DrawText(ray.TextFormat("FOCUS:%i | SCROLL:%i | FPS:%i", focus, scroll, ray.GetFPS()), @intFromFloat(props[8].value.v2.x), @intFromFloat(props[8].value.v2.y), 20, @as(ray.Color, @bitCast(props[11].value.vcolor)));
        }

        // if (ray.GuiButton((ray.Rectangle){ .x = 10, .y = 10, .width = 100, .height = 30 }, "TEST") != 0) {
        //     // click logic
        // }

        ray.EndDrawing();
    }
    ray.CloseWindow();
}
