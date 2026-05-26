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
_items: [5]Plugin = pdfPlugins(),

pub fn refresh(_: *const PluginArray) void {}

pub fn getLength(self: *const PluginArray) u32 {
    return self._items.len;
}

pub fn getAtIndex(self: *PluginArray, index: usize) ?*Plugin {
    if (index < self._items.len) return &self._items[index];
    return null;
}

pub fn getByName(self: *PluginArray, name: []const u8) ?*Plugin {
    for (&self._items) |*plugin| {
        if (std.mem.eql(u8, name, plugin.name)) return plugin;
    }
    return null;
}

const Plugin = struct {
    name: []const u8 = "",
    description: []const u8 = "",
    filename: []const u8 = "",
    _mime_types: [2]MimeType = pdfMimeTypes(),

    pub fn getName(self: *const Plugin) []const u8 {
        return self.name;
    }

    pub fn getDescription(self: *const Plugin) []const u8 {
        return self.description;
    }

    pub fn getFilename(self: *const Plugin) []const u8 {
        return self.filename;
    }

    pub fn getLength(self: *const Plugin) u32 {
        return self._mime_types.len;
    }

    pub fn getAtIndex(self: *Plugin, index: usize) ?*MimeType {
        if (index < self._mime_types.len) return &self._mime_types[index];
        return null;
    }

    pub fn getByName(self: *Plugin, name: []const u8) ?*MimeType {
        for (&self._mime_types) |*mime_type| {
            if (std.mem.eql(u8, name, mime_type.type_string)) return mime_type;
        }
        return null;
    }

    pub const JsApi = struct {
        pub const bridge = js.Bridge(Plugin);
        pub const Meta = struct {
            pub const name = "Plugin";
            pub const prototype_chain = bridge.prototypeChain();
            pub var class_id: bridge.ClassId = undefined;
        };

        pub const name = bridge.accessor(Plugin.getName, null, .{});
        pub const description = bridge.accessor(Plugin.getDescription, null, .{});
        pub const filename = bridge.accessor(Plugin.getFilename, null, .{});
        pub const length = bridge.accessor(Plugin.getLength, null, .{});
        pub const @"[int]" = bridge.indexed(Plugin.getAtIndex, null, .{ .null_as_undefined = true });
        pub const item = bridge.function(_item, .{});
        fn _item(self: *Plugin, index: i32) ?*MimeType {
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
        return &fallback_pdf_plugin;
    }

    pub const JsApi = struct {
        pub const bridge = js.Bridge(MimeType);
        pub const Meta = struct {
            pub const name = "MimeType";
            pub const prototype_chain = bridge.prototypeChain();
            pub var class_id: bridge.ClassId = undefined;
        };

        pub const @"type" = bridge.accessor(MimeType.getType, null, .{});
        pub const description = bridge.accessor(MimeType.getDescription, null, .{});
        pub const suffixes = bridge.accessor(MimeType.getSuffixes, null, .{});
        pub const enabledPlugin = bridge.accessor(MimeType.getEnabledPlugin, null, .{});
    };
};

pub const MimeTypeArray = struct {
    _pad: bool = false,
    _items: [2]MimeType = pdfMimeTypes(),

    pub fn getLength(self: *const MimeTypeArray) u32 {
        return self._items.len;
    }

    pub fn getAtIndex(self: *MimeTypeArray, index: usize) ?*MimeType {
        if (index < self._items.len) return &self._items[index];
        return null;
    }

    pub fn getByName(self: *MimeTypeArray, name: []const u8) ?*MimeType {
        for (&self._items) |*mime_type| {
            if (std.mem.eql(u8, name, mime_type.type_string)) return mime_type;
        }
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
        fn _item(self: *MimeTypeArray, index: i32) ?*MimeType {
            if (index < 0) return null;
            return self.getAtIndex(@intCast(index));
        }
        pub const namedItem = bridge.function(MimeTypeArray.getByName, .{});
    };
};

fn pdfPlugins() [5]Plugin {
    return .{
        .{ .name = "PDF Viewer", .description = "Portable Document Format", .filename = "internal-pdf-viewer" },
        .{ .name = "Chrome PDF Viewer", .description = "Portable Document Format", .filename = "internal-pdf-viewer" },
        .{ .name = "Chromium PDF Viewer", .description = "Portable Document Format", .filename = "internal-pdf-viewer" },
        .{ .name = "Microsoft Edge PDF Viewer", .description = "Portable Document Format", .filename = "internal-pdf-viewer" },
        .{ .name = "WebKit built-in PDF", .description = "Portable Document Format", .filename = "internal-pdf-viewer" },
    };
}

fn pdfMimeTypes() [2]MimeType {
    return .{
        .{ .type_string = "application/pdf", .description = "Portable Document Format", .suffixes = "pdf" },
        .{ .type_string = "text/pdf", .description = "Portable Document Format", .suffixes = "pdf" },
    };
}

var fallback_pdf_plugin = Plugin{
    .name = "PDF Viewer",
    .description = "Portable Document Format",
    .filename = "internal-pdf-viewer",
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
    fn _item(self: *PluginArray, index: i32) ?*Plugin {
        if (index < 0) {
            return null;
        }
        return self.getAtIndex(@intCast(index));
    }
    pub const namedItem = bridge.function(PluginArray.getByName, .{});
};
