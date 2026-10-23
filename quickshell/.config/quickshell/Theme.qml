pragma Singleton

import Quickshell
import QtQuick

// Tokyo Night, matching waybar/style.css: bright or dimmed; yellow only for VPN connecting
Singleton {
    readonly property color bg: "#1a1b26"
    readonly property color surface: "#1f2335"
    readonly property color hover: "#292e42"
    readonly property color border: "#292e42"
    readonly property color text: "#c0caf5"
    readonly property color subtext: "#565f89"
    readonly property color muted: "#565f89"
    readonly property color accent: "#c0caf5"
    readonly property color teal: "#c0caf5"
    readonly property color green: "#c0caf5"
    readonly property color yellow: "#e0af68"
    readonly property color red: "#c0caf5"

    readonly property string font: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 13
    readonly property int iconSize: 18
    readonly property int radius: 8
}
