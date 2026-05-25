// Copyright (C) 2023-2026  Lightpanda (Selecy SAS)
//
// Francis Bouvier <francis@lightpanda.io>
// Pierre Tachoire <pierre@lightpanda.io>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

const std = @import("std");
const js = @import("../js/js.zig");

pub fn registerTypes() []const type {
    return &.{ PluginArray, Plugin, MimeTypeArray, MimeType };
}

const PluginArray = @This();

_pad: bool = false,

pub fn refresh(_: *const PluginArray) void {}

pub fn getLength(_: *const PluginArray) u32 {
    return 1;
}

pub fn getAtIndex(_: *const PluginArray, index: usize) ?*Plugin {
    if (index == 0) return &pdf_plugin;
    return null;
}

pub fn getByName(_: *const PluginArray, name: []const u8) ?*Plugin {
    if (std.mem.eql(u8, name, "PDF Viewer") or
        std.mem.eql(u8, name, "Chrome PDF Viewer") or
        std.mem.eql(u8, name, "Chromium PDF Viewer") or
        std.mem.eql(u8, name, "Mozilla PDF Viewer") or
        std.mem.eql(u8, name, "WebKit built-in PDF"))
    {
        return &pdf_plugin;
    }
    return null;
}

const Plugin = struct {
    name: []const u8 = "",
    description: []const u8 = "",
    filename: []const u8 = "",

    pub fn getName(self: *const Plugin) []const u8 {
        return self.name;
    }

    pub fn getDescription(self: *const Plugin) []const u8 {
        return self.description;
    }

    pub fn getFilename(self: *const Plugin) []const u8 {
        return self.filename;
    }

    pub fn getLength(_: *const Plugin) u32 {
        return 1;
    }

    pub fn getAtIndex(_: *const Plugin, index: usize) ?*MimeType {
        if (index == 0) return &pdf_mime_type;
        return null;
    }

    pub fn getByName(_: *const Plugin, name: []const u8) ?*MimeType {
        if (std.mem.eql(u8, name, "application/pdf")) return &pdf_mime_type;
        return null;
    }

    pub const JsApi = struct {
        pub const bridge = js.Bridge(Plugin);
        pub const Meta = struct {
            pub const name = "Plugin";
            pub const prototype_chain = bridge.prototypeChain();
            pub var class_id: bridge.ClassId = undefined;
            pub const empty_with_no_proto = true;
        };

        pub const name = bridge.accessor(Plugin.getName, null, .{});
        pub const description = bridge.accessor(Plugin.getDescription, null, .{});
        pub const filename = bridge.accessor(Plugin.getFilename, null, .{});
        pub const length = bridge.accessor(Plugin.getLength, null, .{});
        pub const @"[int]" = bridge.indexed(Plugin.getAtIndex, null, .{ .null_as_undefined = true });
        pub const @"[str]" = bridge.namedIndexed(Plugin.getByName, null, null, .{ .null_as_undefined = true });
        pub const item = bridge.function(_item, .{});
        fn _item(self: *const Plugin, index: i32) ?*MimeType {
            if (index < 0) return null;
            return self.getAtIndex(@intCast(index));
        }
        pub const namedItem = bridge.function(Plugin.getByName, .{});
    };
};

const MimeType = struct {
    type_string: []const u8 = "",
    description: []const u8 = "",
    suffixes: []const u8 = "",

    pub fn getType(self: *const MimeType) []const u8 {
        return self.type_string;
    }

    pub fn getDescription(self: *const MimeType) []const u8 {
        return self.description;
    }

    pub fn getSuffixes(self: *const MimeType) []const u8 {
        return self.suffixes;
    }

    pub fn getEnabledPlugin(_: *const MimeType) *Plugin {
        return &pdf_plugin;
    }

    pub const JsApi = struct {
        pub const bridge = js.Bridge(MimeType);
        pub const Meta = struct {
            pub const name = "MimeType";
            pub const prototype_chain = bridge.prototypeChain();
            pub var class_id: bridge.ClassId = undefined;
            pub const empty_with_no_proto = true;
        };

        pub const @"type" = bridge.accessor(MimeType.getType, null, .{});
        pub const description = bridge.accessor(MimeType.getDescription, null, .{});
        pub const suffixes = bridge.accessor(MimeType.getSuffixes, null, .{});
        pub const enabledPlugin = bridge.accessor(MimeType.getEnabledPlugin, null, .{});
    };
};

pub const MimeTypeArray = struct {
    _pad: bool = false,

    pub fn getLength(_: *const MimeTypeArray) u32 {
        return 1;
    }

    pub fn getAtIndex(_: *const MimeTypeArray, index: usize) ?*MimeType {
        if (index == 0) return &pdf_mime_type;
        return null;
    }

    pub fn getByName(_: *const MimeTypeArray, name: []const u8) ?*MimeType {
        if (std.mem.eql(u8, name, "application/pdf")) return &pdf_mime_type;
        return null;
    }

    pub const JsApi = struct {
        pub const bridge = js.Bridge(MimeTypeArray);
        pub const Meta = struct {
            pub const name = "MimeTypeArray";
            pub const prototype_chain = bridge.prototypeChain();
            pub var class_id: bridge.ClassId = undefined;
            pub const empty_with_no_proto = true;
        };

        pub const length = bridge.accessor(MimeTypeArray.getLength, null, .{});
        pub const @"[int]" = bridge.indexed(MimeTypeArray.getAtIndex, null, .{ .null_as_undefined = true });
        pub const @"[str]" = bridge.namedIndexed(MimeTypeArray.getByName, null, null, .{ .null_as_undefined = true });
        pub const item = bridge.function(_item, .{});
        fn _item(self: *const MimeTypeArray, index: i32) ?*MimeType {
            if (index < 0) return null;
            return self.getAtIndex(@intCast(index));
        }
        pub const namedItem = bridge.function(MimeTypeArray.getByName, .{});
    };
};

var pdf_plugin = Plugin{
    .name = "PDF Viewer",
    .description = "Portable Document Format",
    .filename = "internal-pdf-viewer",
};

var pdf_mime_type = MimeType{
    .type_string = "application/pdf",
    .description = "Portable Document Format",
    .suffixes = "pdf",
};

pub const JsApi = struct {
    pub const bridge = js.Bridge(PluginArray);

    pub const Meta = struct {
        pub const name = "PluginArray";
        pub const prototype_chain = bridge.prototypeChain();
        pub var class_id: bridge.ClassId = undefined;
        pub const empty_with_no_proto = true;
    };

    pub const length = bridge.accessor(PluginArray.getLength, null, .{});
    pub const refresh = bridge.function(PluginArray.refresh, .{});
    pub const @"[int]" = bridge.indexed(PluginArray.getAtIndex, null, .{ .null_as_undefined = true });
    pub const @"[str]" = bridge.namedIndexed(PluginArray.getByName, null, null, .{ .null_as_undefined = true });
    pub const item = bridge.function(_item, .{});
    fn _item(self: *const PluginArray, index: i32) ?*Plugin {
        if (index < 0) {
            return null;
        }
        return self.getAtIndex(@intCast(index));
    }
    pub const namedItem = bridge.function(PluginArray.getByName, .{});
};
