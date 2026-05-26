// Copyright (C) 2023-2024  Lightpanda (Selecy SAS)
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

/// Browser profiles for TLS/HTTP fingerprint impersonation.
/// Used to reduce bot detection by matching browser signatures.
/// Profiles match curl-impersonate targets from https://github.com/unstableneutron/curl-impersonate
pub const Profile = enum {
    // === No impersonation ===
    /// No impersonation - original LightPanda behavior (default)
    lightpanda,

    // === Chrome (Windows) ===
    /// Chrome 99.0.4844.51 (Windows 10)
    chrome99,
    /// Chrome 100.0.4896.75 (Windows 10)
    chrome100,
    /// Chrome 101.0.4951.67 (Windows 10)
    chrome101,
    /// Chrome 104.0.0.0 (Windows 10)
    chrome104,
    /// Chrome 107.0.0.0 (Windows 10)
    chrome107,
    /// Chrome 110.0.0.0 (Windows 10)
    chrome110,
    /// Chrome 116.0.0.0 (Windows 10)
    chrome116,

    // === Chrome (macOS) ===
    /// Chrome 119.0.0.0 (macOS Sonoma)
    chrome119,
    /// Chrome 120.0.0.0 (macOS Sonoma)
    chrome120,
    /// Chrome 123.0.0.0 (macOS Sonoma)
    chrome123,
    /// Chrome 124.0.0.0 (macOS Sonoma)
    chrome124,
    /// Chrome 131.0.0.0 (macOS Sonoma)
    chrome131,
    /// Chrome 133.0.0.0 (macOS Sequoia) - alternative build
    chrome133a,
    /// Chrome 136.0.0.0 (macOS Sequoia)
    chrome136,
    /// Chrome 142.0.0.0 (macOS Tahoe)
    chrome142,
    /// Chrome 145.0.0.0 (macOS Tahoe)
    chrome145,
    /// Chrome 146.0.0.0 (macOS Tahoe)
    chrome146,

    // === Chrome (Android) ===
    /// Chrome 99.0.4844.58 (Android 12, Pixel 6)
    chrome99_android,
    /// Chrome 131.0.0.0 (Android 10)
    chrome131_android,

    // === Edge (Windows) ===
    /// Edge 99.0.1150.30 (Windows 10)
    edge99,
    /// Edge 101.0.1210.47 (Windows 10)
    edge101,

    // === Safari (macOS) ===
    /// Safari 15.3 (macOS Big Sur)
    safari153,
    /// Safari 15.5 (macOS Monterey)
    safari155,
    /// Safari 17.0 (macOS Sonoma)
    safari170,
    /// Safari 18.0 (macOS Sequoia)
    safari180,
    /// Safari 18.4 (macOS Sequoia)
    safari184,
    /// Safari 26.0 (macOS Tahoe)
    safari260,
    /// Safari 26.0.1 (macOS Tahoe)
    safari2601,

    // === Safari (iOS) ===
    /// Safari 17.2 (iOS 17.2)
    safari172_ios,
    /// Safari 18.0 (iOS 18.0)
    safari180_ios,
    /// Safari 18.4 (iOS 18.0)
    safari184_ios,
    /// Safari 26.0 (iOS 26.0)
    safari260_ios,

    // === Firefox (Windows) ===
    /// Firefox 91 ESR (Windows 10)
    firefox91esr,
    /// Firefox 95 (Windows 10)
    firefox95,
    /// Firefox 98 (Windows 10)
    firefox98,
    /// Firefox 100 (Windows 10)
    firefox100,
    /// Firefox 102 (Windows 10)
    firefox102,
    /// Firefox 109 (Windows 10)
    firefox109,
    /// Firefox 117 (Windows 10)
    firefox117,

    // === Firefox (macOS) ===
    /// Firefox 133 (macOS Sonoma)
    firefox133,
    /// Firefox 135 (macOS Sonoma)
    firefox135,
    /// Firefox 144 (macOS Tahoe)
    firefox144,
    /// Firefox 147 (macOS Tahoe)
    firefox147,

    // === Tor ===
    /// Tor Browser 14.5 (macOS Sonoma, based on Firefox 128 ESR)
    tor145,

    /// Parse a profile name string into a Profile enum.
    /// Returns null if the string doesn't match any known profile.
    pub fn fromString(s: []const u8) ?Profile {
        const map = std.StaticStringMap(Profile).initComptime(.{
            // Default
            .{ "lightpanda", .lightpanda },
            .{ "default", .lightpanda },
            // Chrome Windows
            .{ "chrome99", .chrome99 },
            .{ "chrome100", .chrome100 },
            .{ "chrome101", .chrome101 },
            .{ "chrome104", .chrome104 },
            .{ "chrome107", .chrome107 },
            .{ "chrome110", .chrome110 },
            .{ "chrome116", .chrome116 },
            // Chrome macOS
            .{ "chrome119", .chrome119 },
            .{ "chrome120", .chrome120 },
            .{ "chrome123", .chrome123 },
            .{ "chrome124", .chrome124 },
            .{ "chrome131", .chrome131 },
            .{ "chrome133a", .chrome133a },
            .{ "chrome136", .chrome136 },
            .{ "chrome142", .chrome142 },
            .{ "chrome145", .chrome145 },
            .{ "chrome146", .chrome146 },
            .{ "chrome", .chrome146 },
            .{ "latest-chrome", .chrome146 },
            .{ "latest_chrome", .chrome146 },
            // Chrome Android
            .{ "chrome99_android", .chrome99_android },
            .{ "chrome131_android", .chrome131_android },
            // Edge
            .{ "edge99", .edge99 },
            .{ "edge101", .edge101 },
            // Safari macOS
            .{ "safari153", .safari153 },
            .{ "safari155", .safari155 },
            .{ "safari170", .safari170 },
            .{ "safari180", .safari180 },
            .{ "safari184", .safari184 },
            .{ "safari260", .safari260 },
            .{ "safari2601", .safari2601 },
            // Safari iOS
            .{ "safari172_ios", .safari172_ios },
            .{ "safari180_ios", .safari180_ios },
            .{ "safari184_ios", .safari184_ios },
            .{ "safari260_ios", .safari260_ios },
            // Firefox Windows
            .{ "firefox91esr", .firefox91esr },
            .{ "firefox95", .firefox95 },
            .{ "firefox98", .firefox98 },
            .{ "firefox100", .firefox100 },
            .{ "firefox102", .firefox102 },
            .{ "firefox109", .firefox109 },
            .{ "firefox117", .firefox117 },
            // Firefox macOS
            .{ "firefox133", .firefox133 },
            .{ "firefox135", .firefox135 },
            .{ "firefox144", .firefox144 },
            .{ "firefox147", .firefox147 },
            // Tor
            .{ "tor145", .tor145 },
        });
        return map.get(s);
    }

    /// Returns the curl-impersonate target string, or null for no impersonation.
    /// This is passed to curl_easy_impersonate().
    pub fn curlTarget(self: Profile) ?[:0]const u8 {
        return switch (self) {
            .lightpanda => null,
            // Chrome Windows
            .chrome99 => "chrome99",
            .chrome100 => "chrome100",
            .chrome101 => "chrome101",
            .chrome104 => "chrome104",
            .chrome107 => "chrome107",
            .chrome110 => "chrome110",
            .chrome116 => "chrome116",
            // Chrome macOS
            .chrome119 => "chrome119",
            .chrome120 => "chrome120",
            .chrome123 => "chrome123",
            .chrome124 => "chrome124",
            .chrome131 => "chrome131",
            .chrome133a => "chrome133a",
            .chrome136 => "chrome136",
            .chrome142 => "chrome142",
            .chrome145 => "chrome145",
            .chrome146 => "chrome146",
            // Chrome Android
            .chrome99_android => "chrome99_android",
            .chrome131_android => "chrome131_android",
            // Edge
            .edge99 => "edge99",
            .edge101 => "edge101",
            // Safari macOS
            .safari153 => "safari153",
            .safari155 => "safari155",
            .safari170 => "safari170",
            .safari180 => "safari180",
            .safari184 => "safari184",
            .safari260 => "safari260",
            .safari2601 => "safari2601",
            // Safari iOS
            .safari172_ios => "safari172_ios",
            .safari180_ios => "safari180_ios",
            .safari184_ios => "safari184_ios",
            .safari260_ios => "safari260_ios",
            // Firefox Windows
            .firefox91esr => "firefox91esr",
            .firefox95 => "firefox95",
            .firefox98 => "firefox98",
            .firefox100 => "firefox100",
            .firefox102 => "firefox102",
            .firefox109 => "firefox109",
            .firefox117 => "firefox117",
            // Firefox macOS
            .firefox133 => "firefox133",
            .firefox135 => "firefox135",
            .firefox144 => "firefox144",
            .firefox147 => "firefox147",
            // Tor
            .tor145 => "tor145",
        };
    }

    /// Returns the full User-Agent header line (with "User-Agent: " prefix).
    /// Used for HTTP requests.
    pub fn userAgent(self: Profile) [:0]const u8 {
        return switch (self) {
            .lightpanda => "User-Agent: Lightpanda/1.0",
            // Chrome Windows
            .chrome99 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36",
            .chrome100 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36",
            .chrome101 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36",
            .chrome104 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36",
            .chrome107 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
            .chrome110 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
            .chrome116 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
            // Chrome macOS
            .chrome119 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
            .chrome120 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            .chrome123 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
            .chrome124 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
            .chrome131 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
            .chrome133a => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36",
            .chrome136 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36",
            .chrome142 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
            .chrome145 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36",
            .chrome146 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36",
            // Chrome Android
            .chrome99_android => "User-Agent: Mozilla/5.0 (Linux; Android 12; Pixel 6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.58 Mobile Safari/537.36",
            .chrome131_android => "User-Agent: Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36",
            // Edge
            .edge99 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36 Edg/99.0.1150.30",
            .edge101 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36 Edg/101.0.1210.47",
            // Safari macOS
            .safari153 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Safari/605.1.15",
            .safari155 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15",
            .safari170 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15",
            .safari180 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15",
            .safari184 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Safari/605.1.15",
            .safari260 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15",
            .safari2601 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0.1 Safari/605.1.15",
            // Safari iOS
            .safari172_ios => "User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 17_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604.1",
            .safari180_ios => "User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1",
            .safari184_ios => "User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Mobile/15E148 Safari/604.1",
            .safari260_ios => "User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 26_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Mobile/15E148 Safari/604.1",
            // Firefox Windows
            .firefox91esr => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0",
            .firefox95 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:95.0) Gecko/20100101 Firefox/95.0",
            .firefox98 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101 Firefox/98.0",
            .firefox100 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:100.0) Gecko/20100101 Firefox/100.0",
            .firefox102 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0",
            .firefox109 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/109.0",
            .firefox117 => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/117.0",
            // Firefox macOS
            .firefox133 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:133.0) Gecko/20100101 Firefox/133.0",
            .firefox135 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:135.0) Gecko/20100101 Firefox/135.0",
            .firefox144 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:144.0) Gecko/20100101 Firefox/144.0",
            .firefox147 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:147.0) Gecko/20100101 Firefox/147.0",
            // Tor (based on Firefox 128 ESR)
            .tor145 => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:128.0) Gecko/20100101 Firefox/128.0",
        };
    }

    /// Returns navigator.userAgent (without "User-Agent: " prefix).
    /// Used for JavaScript navigator.userAgent property.
    pub fn navigatorUserAgent(self: Profile) []const u8 {
        const ua = self.userAgent();
        const prefix = "User-Agent: ";
        return ua[prefix.len..];
    }

    /// Returns navigator.platform value.
    pub fn platform(self: Profile) []const u8 {
        return switch (self) {
            .lightpanda => "MacIntel",
            // Chrome Windows
            .chrome99, .chrome100, .chrome101, .chrome104, .chrome107, .chrome110, .chrome116 => "Win32",
            // Chrome macOS
            .chrome119, .chrome120, .chrome123, .chrome124, .chrome131, .chrome133a, .chrome136, .chrome142, .chrome145, .chrome146 => "MacIntel",
            // Chrome Android
            .chrome99_android, .chrome131_android => "Linux armv8l",
            // Edge Windows
            .edge99, .edge101 => "Win32",
            // Safari macOS
            .safari153, .safari155, .safari170, .safari180, .safari184, .safari260, .safari2601 => "MacIntel",
            // Safari iOS
            .safari172_ios, .safari180_ios, .safari184_ios, .safari260_ios => "iPhone",
            // Firefox Windows
            .firefox91esr, .firefox95, .firefox98, .firefox100, .firefox102, .firefox109, .firefox117 => "Win32",
            // Firefox macOS
            .firefox133, .firefox135, .firefox144, .firefox147 => "MacIntel",
            // Tor (macOS)
            .tor145 => "MacIntel",
        };
    }

    /// Returns navigator.vendor value.
    pub fn vendor(self: Profile) []const u8 {
        return switch (self) {
            .lightpanda => "",
            // Chrome (all platforms) - Google Inc.
            .chrome99, .chrome100, .chrome101, .chrome104, .chrome107, .chrome110, .chrome116 => "Google Inc.",
            .chrome119, .chrome120, .chrome123, .chrome124, .chrome131, .chrome133a, .chrome136, .chrome142, .chrome145, .chrome146 => "Google Inc.",
            .chrome99_android, .chrome131_android => "Google Inc.",
            // Edge - Google Inc. (Chromium-based)
            .edge99, .edge101 => "Google Inc.",
            // Safari - Apple
            .safari153, .safari155, .safari170, .safari180, .safari184, .safari260, .safari2601 => "Apple Computer, Inc.",
            .safari172_ios, .safari180_ios, .safari184_ios, .safari260_ios => "Apple Computer, Inc.",
            // Firefox - empty string
            .firefox91esr, .firefox95, .firefox98, .firefox100, .firefox102, .firefox109, .firefox117 => "",
            .firefox133, .firefox135, .firefox144, .firefox147 => "",
            // Tor - empty string (Firefox-based)
            .tor145 => "",
        };
    }

    /// Returns navigator.appVersion value.
    pub fn appVersion(self: Profile) []const u8 {
        return switch (self) {
            .lightpanda => "1.0",
            // Chrome Windows
            .chrome99 => "5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36",
            .chrome100 => "5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36",
            .chrome101 => "5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36",
            .chrome104 => "5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36",
            .chrome107 => "5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36",
            .chrome110 => "5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
            .chrome116 => "5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
            // Chrome macOS
            .chrome119 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
            .chrome120 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            .chrome123 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36",
            .chrome124 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
            .chrome131 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
            .chrome133a => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36",
            .chrome136 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36",
            .chrome142 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
            .chrome145 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36",
            .chrome146 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36",
            // Chrome Android
            .chrome99_android => "5.0 (Linux; Android 12; Pixel 6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.58 Mobile Safari/537.36",
            .chrome131_android => "5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36",
            // Edge
            .edge99 => "5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36 Edg/99.0.1150.30",
            .edge101 => "5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36 Edg/101.0.1210.47",
            // Safari macOS
            .safari153 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Safari/605.1.15",
            .safari155 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15",
            .safari170 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15",
            .safari180 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15",
            .safari184 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Safari/605.1.15",
            .safari260 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15",
            .safari2601 => "5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0.1 Safari/605.1.15",
            // Safari iOS
            .safari172_ios => "5.0 (iPhone; CPU iPhone OS 17_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604.1",
            .safari180_ios => "5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1",
            .safari184_ios => "5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Mobile/15E148 Safari/604.1",
            .safari260_ios => "5.0 (iPhone; CPU iPhone OS 26_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Mobile/15E148 Safari/604.1",
            // Firefox Windows
            .firefox91esr => "5.0 (Windows)",
            .firefox95 => "5.0 (Windows)",
            .firefox98 => "5.0 (Windows)",
            .firefox100 => "5.0 (Windows)",
            .firefox102 => "5.0 (Windows)",
            .firefox109 => "5.0 (Windows)",
            .firefox117 => "5.0 (Windows)",
            // Firefox macOS
            .firefox133 => "5.0 (Macintosh)",
            .firefox135 => "5.0 (Macintosh)",
            .firefox144 => "5.0 (Macintosh)",
            .firefox147 => "5.0 (Macintosh)",
            // Tor
            .tor145 => "5.0 (Macintosh)",
        };
    }

    /// Returns Accept-Language header.
    pub fn acceptLanguage(self: Profile) [:0]const u8 {
        _ = self;
        return "Accept-Language: en-US,en;q=0.9";
    }

    /// Returns navigator.languages array.
    pub fn languages(self: Profile) []const []const u8 {
        _ = self;
        return &[_][]const u8{ "en-US", "en" };
    }

    pub const ClientHintBrand = struct {
        brand: []const u8,
        version: []const u8,
    };

    pub fn isChromium(self: Profile) bool {
        return switch (self) {
            .chrome99,
            .chrome100,
            .chrome101,
            .chrome104,
            .chrome107,
            .chrome110,
            .chrome116,
            .chrome119,
            .chrome120,
            .chrome123,
            .chrome124,
            .chrome131,
            .chrome133a,
            .chrome136,
            .chrome142,
            .chrome145,
            .chrome146,
            .chrome99_android,
            .chrome131_android,
            .edge99,
            .edge101,
            => true,
            else => false,
        };
    }

    pub fn isMobile(self: Profile) bool {
        return switch (self) {
            .chrome99_android,
            .chrome131_android,
            .safari172_ios,
            .safari180_ios,
            .safari184_ios,
            .safari260_ios,
            => true,
            else => false,
        };
    }

    pub fn majorVersion(self: Profile) []const u8 {
        return switch (self) {
            .lightpanda => "1",
            .chrome99, .chrome99_android, .edge99 => "99",
            .chrome100 => "100",
            .chrome101, .edge101 => "101",
            .chrome104 => "104",
            .chrome107 => "107",
            .chrome110 => "110",
            .chrome116 => "116",
            .chrome119 => "119",
            .chrome120 => "120",
            .chrome123 => "123",
            .chrome124 => "124",
            .chrome131, .chrome131_android => "131",
            .chrome133a => "133",
            .chrome136 => "136",
            .chrome142 => "142",
            .chrome145 => "145",
            .chrome146 => "146",
            .safari153 => "15",
            .safari155 => "15",
            .safari170, .safari172_ios => "17",
            .safari180, .safari184, .safari180_ios, .safari184_ios => "18",
            .safari260, .safari2601, .safari260_ios => "26",
            .firefox91esr => "91",
            .firefox95 => "95",
            .firefox98 => "98",
            .firefox100 => "100",
            .firefox102 => "102",
            .firefox109 => "109",
            .firefox117 => "117",
            .firefox133 => "133",
            .firefox135 => "135",
            .firefox144 => "144",
            .firefox147 => "147",
            .tor145 => "128",
        };
    }

    pub fn fullVersion(self: Profile) []const u8 {
        return switch (self) {
            .lightpanda => "1.0.0.0",
            .chrome99 => "99.0.4844.51",
            .chrome100 => "100.0.4896.75",
            .chrome101 => "101.0.4951.67",
            .chrome104 => "104.0.0.0",
            .chrome107 => "107.0.0.0",
            .chrome110 => "110.0.0.0",
            .chrome116 => "116.0.0.0",
            .chrome119 => "119.0.0.0",
            .chrome120 => "120.0.0.0",
            .chrome123 => "123.0.0.0",
            .chrome124 => "124.0.0.0",
            .chrome131, .chrome131_android => "131.0.0.0",
            .chrome133a => "133.0.0.0",
            .chrome136 => "136.0.0.0",
            .chrome142 => "142.0.0.0",
            .chrome145 => "145.0.0.0",
            .chrome146 => "146.0.0.0",
            .chrome99_android => "99.0.4844.58",
            .edge99 => "99.0.1150.30",
            .edge101 => "101.0.1210.47",
            else => self.majorVersion(),
        };
    }

    pub fn clientHintPlatform(self: Profile) []const u8 {
        return switch (self) {
            .chrome99,
            .chrome100,
            .chrome101,
            .chrome104,
            .chrome107,
            .chrome110,
            .chrome116,
            .edge99,
            .edge101,
            .firefox91esr,
            .firefox95,
            .firefox98,
            .firefox100,
            .firefox102,
            .firefox109,
            .firefox117,
            => "Windows",
            .chrome99_android, .chrome131_android => "Android",
            .safari172_ios, .safari180_ios, .safari184_ios, .safari260_ios => "iOS",
            else => "macOS",
        };
    }

    pub fn clientHintBrands(self: Profile) []const ClientHintBrand {
        return switch (self) {
            .chrome99, .chrome99_android => chromiumBrands("99"),
            .chrome100 => chromiumBrands("100"),
            .chrome101 => chromiumBrands("101"),
            .chrome104 => chromiumBrands("104"),
            .chrome107 => chromiumBrands("107"),
            .chrome110 => chromiumBrands("110"),
            .chrome116 => chromiumBrands("116"),
            .chrome119 => chromiumBrands("119"),
            .chrome120 => chromiumBrands("120"),
            .chrome123 => chromiumBrands("123"),
            .chrome124 => chromiumBrands("124"),
            .chrome131, .chrome131_android => chromiumBrands("131"),
            .chrome133a => chromiumBrands("133"),
            .chrome136 => chromiumBrands("136"),
            .chrome142 => chromiumBrands("142"),
            .chrome145 => chromiumBrands("145"),
            .chrome146 => chromiumBrands("146"),
            .edge99 => edgeBrands("99"),
            .edge101 => edgeBrands("101"),
            else => lightpandaBrands(),
        };
    }

    pub fn secChUaHeader(self: Profile) [:0]const u8 {
        return switch (self) {
            .chrome99, .chrome99_android => chromiumSecChUa("99"),
            .chrome100 => chromiumSecChUa("100"),
            .chrome101 => chromiumSecChUa("101"),
            .chrome104 => chromiumSecChUa("104"),
            .chrome107 => chromiumSecChUa("107"),
            .chrome110 => chromiumSecChUa("110"),
            .chrome116 => chromiumSecChUa("116"),
            .chrome119 => chromiumSecChUa("119"),
            .chrome120 => chromiumSecChUa("120"),
            .chrome123 => chromiumSecChUa("123"),
            .chrome124 => chromiumSecChUa("124"),
            .chrome131, .chrome131_android => chromiumSecChUa("131"),
            .chrome133a => chromiumSecChUa("133"),
            .chrome136 => chromiumSecChUa("136"),
            .chrome142 => chromiumSecChUa("142"),
            .chrome145 => chromiumSecChUa("145"),
            .chrome146 => chromiumSecChUa("146"),
            .edge99 => edgeSecChUa("99"),
            .edge101 => edgeSecChUa("101"),
            else => "Sec-Ch-Ua: \"Lightpanda\";v=\"1\"",
        };
    }

    pub fn clientHintFullVersionList(self: Profile) []const ClientHintBrand {
        return switch (self) {
            .chrome99 => chromiumFullVersionList("99.0.4844.51"),
            .chrome99_android => chromiumFullVersionList("99.0.4844.58"),
            .chrome100 => chromiumFullVersionList("100.0.4896.75"),
            .chrome101 => chromiumFullVersionList("101.0.4951.67"),
            .chrome104 => chromiumFullVersionList("104.0.0.0"),
            .chrome107 => chromiumFullVersionList("107.0.0.0"),
            .chrome110 => chromiumFullVersionList("110.0.0.0"),
            .chrome116 => chromiumFullVersionList("116.0.0.0"),
            .chrome119 => chromiumFullVersionList("119.0.0.0"),
            .chrome120 => chromiumFullVersionList("120.0.0.0"),
            .chrome123 => chromiumFullVersionList("123.0.0.0"),
            .chrome124 => chromiumFullVersionList("124.0.0.0"),
            .chrome131, .chrome131_android => chromiumFullVersionList("131.0.0.0"),
            .chrome133a => chromiumFullVersionList("133.0.0.0"),
            .chrome136 => chromiumFullVersionList("136.0.0.0"),
            .chrome142 => chromiumFullVersionList("142.0.0.0"),
            .chrome145 => chromiumFullVersionList("145.0.0.0"),
            .chrome146 => chromiumFullVersionList("146.0.0.0"),
            .edge99 => edgeFullVersionList("99.0.1150.30"),
            .edge101 => edgeFullVersionList("101.0.1210.47"),
            else => lightpandaFullVersionList(),
        };
    }

    fn lightpandaBrands() []const ClientHintBrand {
        return &[_]ClientHintBrand{.{ .brand = "Lightpanda", .version = "1" }};
    }

    fn lightpandaFullVersionList() []const ClientHintBrand {
        return &[_]ClientHintBrand{.{ .brand = "Lightpanda", .version = "1.0.0.0" }};
    }

    fn chromiumBrands(comptime version: []const u8) []const ClientHintBrand {
        return &[_]ClientHintBrand{
            .{ .brand = "Not A(Brand", .version = "24" },
            .{ .brand = "Chromium", .version = version },
            .{ .brand = "Google Chrome", .version = version },
        };
    }

    fn chromiumFullVersionList(comptime full: []const u8) []const ClientHintBrand {
        return &[_]ClientHintBrand{
            .{ .brand = "Not A(Brand", .version = "24.0.0.0" },
            .{ .brand = "Chromium", .version = full },
            .{ .brand = "Google Chrome", .version = full },
        };
    }

    fn chromiumSecChUa(comptime version: []const u8) [:0]const u8 {
        return "Sec-Ch-Ua: \"Not A(Brand\";v=\"24\", \"Chromium\";v=\"" ++ version ++ "\", \"Google Chrome\";v=\"" ++ version ++ "\"";
    }

    fn edgeBrands(comptime version: []const u8) []const ClientHintBrand {
        return &[_]ClientHintBrand{
            .{ .brand = "Not A(Brand", .version = "24" },
            .{ .brand = "Chromium", .version = version },
            .{ .brand = "Microsoft Edge", .version = version },
        };
    }

    fn edgeFullVersionList(comptime full: []const u8) []const ClientHintBrand {
        return &[_]ClientHintBrand{
            .{ .brand = "Not A(Brand", .version = "24.0.0.0" },
            .{ .brand = "Chromium", .version = full },
            .{ .brand = "Microsoft Edge", .version = full },
        };
    }

    fn edgeSecChUa(comptime version: []const u8) [:0]const u8 {
        return "Sec-Ch-Ua: \"Not A(Brand\";v=\"24\", \"Chromium\";v=\"" ++ version ++ "\", \"Microsoft Edge\";v=\"" ++ version ++ "\"";
    }

    pub fn documentAcceptHeader(self: Profile) [:0]const u8 {
        return switch (self) {
            .chrome99,
            .chrome100,
            .chrome101,
            .chrome104,
            .chrome107,
            .chrome110,
            .chrome116,
            .chrome119,
            .chrome120,
            .chrome123,
            .chrome124,
            .chrome131,
            .chrome133a,
            .chrome136,
            .chrome142,
            .chrome145,
            .chrome146,
            .chrome99_android,
            .chrome131_android,
            .edge99,
            .edge101,
            => "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            else => "Accept: */*",
        };
    }

    pub const supported_profiles = "lightpanda (default), " ++
        "chrome/latest-chrome/latest_chrome (alias for chrome146), " ++
        "chrome99, chrome100, chrome101, chrome104, chrome107, chrome110, chrome116, " ++
        "chrome119, chrome120, chrome123, chrome124, chrome131, chrome133a, chrome136, chrome142, chrome145, chrome146, " ++
        "chrome99_android, chrome131_android, " ++
        "edge99, edge101, " ++
        "safari153, safari155, safari170, safari180, safari184, safari260, safari2601, " ++
        "safari172_ios, safari180_ios, safari184_ios, safari260_ios, " ++
        "firefox91esr, firefox95, firefox98, firefox100, firefox102, firefox109, firefox117, " ++
        "firefox133, firefox135, firefox144, firefox147, " ++
        "tor145";

    /// Returns a list of supported profile names for help text.
    pub fn supportedProfiles() []const u8 {
        return supported_profiles;
    }
};

test "Profile.fromString" {
    const testing = std.testing;

    try testing.expectEqual(Profile.lightpanda, Profile.fromString("lightpanda").?);
    try testing.expectEqual(Profile.lightpanda, Profile.fromString("default").?);
    try testing.expectEqual(Profile.firefox144, Profile.fromString("firefox144").?);
    try testing.expectEqual(Profile.chrome136, Profile.fromString("chrome136").?);
    try testing.expectEqual(Profile.chrome99, Profile.fromString("chrome99").?);
    try testing.expectEqual(Profile.chrome142, Profile.fromString("chrome142").?);
    try testing.expectEqual(Profile.chrome146, Profile.fromString("chrome").?);
    try testing.expectEqual(Profile.chrome146, Profile.fromString("latest-chrome").?);
    try testing.expectEqual(Profile.chrome146, Profile.fromString("latest_chrome").?);
    try testing.expectEqual(Profile.safari260, Profile.fromString("safari260").?);
    try testing.expectEqual(Profile.safari172_ios, Profile.fromString("safari172_ios").?);
    try testing.expectEqual(Profile.tor145, Profile.fromString("tor145").?);
    try testing.expectEqual(@as(?Profile, null), Profile.fromString("invalid"));
}

test "Profile.curlTarget" {
    const testing = std.testing;

    try testing.expectEqual(@as(?[:0]const u8, null), Profile.lightpanda.curlTarget());
    try testing.expectEqualStrings("firefox144", Profile.firefox144.curlTarget().?);
    try testing.expectEqualStrings("chrome136", Profile.chrome136.curlTarget().?);
    try testing.expectEqualStrings("chrome99", Profile.chrome99.curlTarget().?);
    try testing.expectEqualStrings("safari260_ios", Profile.safari260_ios.curlTarget().?);
    try testing.expectEqualStrings("tor145", Profile.tor145.curlTarget().?);
}

test "Profile.navigatorUserAgent" {
    const testing = std.testing;

    try testing.expectEqualStrings("Lightpanda/1.0", Profile.lightpanda.navigatorUserAgent());
    try testing.expect(std.mem.startsWith(u8, Profile.firefox144.navigatorUserAgent(), "Mozilla/5.0"));
    try testing.expect(std.mem.indexOf(u8, Profile.firefox144.navigatorUserAgent(), "Firefox/144.0") != null);
    try testing.expect(std.mem.indexOf(u8, Profile.chrome99.navigatorUserAgent(), "Chrome/99.0.4844.51") != null);
    try testing.expect(std.mem.indexOf(u8, Profile.safari172_ios.navigatorUserAgent(), "iPhone") != null);
}

test "Profile.platform" {
    const testing = std.testing;

    try testing.expectEqualStrings("MacIntel", Profile.lightpanda.platform());
    try testing.expectEqualStrings("MacIntel", Profile.firefox144.platform());
    try testing.expectEqualStrings("Win32", Profile.edge101.platform());
    try testing.expectEqualStrings("Win32", Profile.chrome99.platform());
    try testing.expectEqualStrings("MacIntel", Profile.chrome136.platform());
    try testing.expectEqualStrings("iPhone", Profile.safari172_ios.platform());
    try testing.expectEqualStrings("Linux armv8l", Profile.chrome99_android.platform());
}

test "Profile.vendor" {
    const testing = std.testing;

    try testing.expectEqualStrings("", Profile.lightpanda.vendor());
    try testing.expectEqualStrings("", Profile.firefox144.vendor());
    try testing.expectEqualStrings("Google Inc.", Profile.chrome136.vendor());
    try testing.expectEqualStrings("Google Inc.", Profile.chrome99.vendor());
    try testing.expectEqualStrings("Apple Computer, Inc.", Profile.safari180.vendor());
    try testing.expectEqualStrings("Apple Computer, Inc.", Profile.safari172_ios.vendor());
    try testing.expectEqualStrings("", Profile.tor145.vendor());
}

test "Profile chromium client hints" {
    const testing = std.testing;

    try testing.expect(Profile.chrome146.isChromium());
    try testing.expectEqualStrings("146", Profile.chrome146.majorVersion());
    try testing.expectEqualStrings("146.0.0.0", Profile.chrome146.fullVersion());
    try testing.expectEqualStrings("macOS", Profile.chrome146.clientHintPlatform());
    try testing.expectEqual(false, Profile.chrome146.isMobile());
    try testing.expectEqualStrings("Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7", Profile.chrome146.documentAcceptHeader());

    const brands = Profile.chrome146.clientHintBrands();
    try testing.expectEqual(@as(usize, 3), brands.len);
    try testing.expectEqualStrings("Chromium", brands[1].brand);
    try testing.expectEqualStrings("146", brands[1].version);
    try testing.expectEqualStrings("Google Chrome", brands[2].brand);
    try testing.expectEqualStrings("146", brands[2].version);
    try testing.expectEqualStrings("Sec-Ch-Ua: \"Not A(Brand\";v=\"24\", \"Chromium\";v=\"146\", \"Google Chrome\";v=\"146\"", Profile.chrome146.secChUaHeader());

    const full_version_brands = Profile.chrome146.clientHintFullVersionList();
    try testing.expectEqual(@as(usize, 3), full_version_brands.len);
    try testing.expectEqualStrings("146.0.0.0", full_version_brands[1].version);
    try testing.expectEqualStrings("146.0.0.0", full_version_brands[2].version);
}
