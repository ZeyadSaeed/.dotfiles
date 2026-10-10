pragma Singleton

import Quickshell
import QtQuick

// Colors match waybar/style.css (catppuccin frappe on a near-black base)
Singleton {
    readonly property color bg: "#101010"
    readonly property color surface: "#18181c"
    readonly property color hover: "#232329"
    readonly property color border: "#2a2a33"
    readonly property color text: "#c6d0f5"
    readonly property color subtext: "#a5adce"
    readonly property color muted: "#737994"
    readonly property color accent: "#8caaee"
    readonly property color teal: "#99d1db"
    readonly property color green: "#a6d189"
    readonly property color yellow: "#e5c890"
    readonly property color red: "#e78284"

    readonly property string font: "JetBrainsMono Nerd Font"
    readonly property int fontSize: 13
    readonly property int iconSize: 18
    readonly property int radius: 8
}
