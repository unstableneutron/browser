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
const builtin = @import("builtin");

const BrowserProfile = @import("../../browser_profile.zig").Profile;
const js = @import("../js/js.zig");
const Frame = @import("../Frame.zig");

const NavigatorUAData = @This();

_pad: bool = false,

const Brand = BrowserProfile.ClientHintBrand;

pub fn getBrands(_: *const NavigatorUAData, frame: *Frame) []const Brand {
    return activeProfile(frame).clientHintBrands();
}

pub fn getMobile(_: *const NavigatorUAData, frame: *Frame) bool {
    return activeProfile(frame).isMobile();
}

pub fn getPlatform(_: *const NavigatorUAData, frame: *Frame) []const u8 {
    return activeProfile(frame).clientHintPlatform();
}

pub fn toJSON(_: *const NavigatorUAData, frame: *Frame) struct {
    brands: []const Brand,
    mobile: bool,
    platform: []const u8,
} {
    const profile = activeProfile(frame);
    return .{
        .mobile = profile.isMobile(),
        .brands = profile.clientHintBrands(),
        .platform = profile.clientHintPlatform(),
    };
}

pub fn getHighEntropyValues(_: *const NavigatorUAData, hints: []const []const u8, frame: *Frame) !js.Promise {
    // This should always return `brands` + `mobile` + `platform` and then whatever
    // "hints" field is requested (assuming the browser has permission), but it's
    // also valid to just return everything.

    _ = hints;

    const profile = activeProfile(frame);
    return frame.js.local.?.resolvePromise(.{
        .brands = profile.clientHintBrands(),
        .mobile = profile.isMobile(),
        .platform = profile.clientHintPlatform(),
        .architecture = uaArchitecture(),
        .bitness = uaBitness(),
        .model = "",
        .platformVersion = "",
        .uaFullVersion = profile.fullVersion(),
        .fullVersionList = profile.clientHintFullVersionList(),
        .wow64 = false,
        .formFactor = if (profile.isMobile()) [_][]const u8{"Mobile"} else [_][]const u8{"Desktop"},
    });
}

fn activeProfile(frame: *const Frame) BrowserProfile {
    return frame._session.browser.app.config.impersonate();
}

fn uaArchitecture() []const u8 {
    return switch (builtin.cpu.arch) {
        .x86, .x86_64 => "x86",
        .aarch64, .aarch64_be, .arm, .armeb => "arm",
        else => "",
    };
}

fn uaBitness() []const u8 {
    return switch (builtin.cpu.arch) {
        .x86_64, .aarch64, .aarch64_be, .powerpc64, .powerpc64le, .riscv64 => "64",
        else => "32",
    };
}

pub const JsApi = struct {
    pub const bridge = js.Bridge(NavigatorUAData);

    pub const Meta = struct {
        pub const name = "NavigatorUAData";
        pub const prototype_chain = bridge.prototypeChain();
        pub var class_id: bridge.ClassId = undefined;
        pub const empty_with_no_proto = true;
    };

    pub const brands = bridge.accessor(NavigatorUAData.getBrands, null, .{});
    pub const mobile = bridge.accessor(NavigatorUAData.getMobile, null, .{});
    pub const platform = bridge.accessor(NavigatorUAData.getPlatform, null, .{});
    pub const toJSON = bridge.function(NavigatorUAData.toJSON, .{});
    pub const getHighEntropyValues = bridge.function(NavigatorUAData.getHighEntropyValues, .{});
};
