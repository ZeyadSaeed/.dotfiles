import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

// AI agent usage: rate limits and local token stats from agents/update.sh records
PopupPanel {
    id: menu

    readonly property string stateDir: (Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state") + "/agent-usage"
    readonly property var agentIds: ["claude", "codex"]

    // Ticks so "resets in" / "updated" texts stay current while open
    property real now: Date.now()

    function refresh() {
        if (!updater.running)
            updater.running = true;
    }

    function formatTokens(n) {
        if (n >= 1e9) return (n / 1e9).toFixed(1) + "B";
        if (n >= 1e6) return (n / 1e6).toFixed(1) + "M";
        if (n >= 1e3) return Math.round(n / 1e3) + "K";
        return String(n || 0);
    }

    function formatDuration(ms) {
        if (ms <= 0) return "now";
        const m = Math.floor(ms / 60000);
        const d = Math.floor(m / 1440), h = Math.floor((m % 1440) / 60), mm = m % 60;
        if (d > 0) return d + "d " + h + "h";
        if (h > 0) return h + "h " + mm + "m";
        return mm + "m";
    }

    // Bar and menus are monochrome; meters no longer color by usage
    function meterColor(p) {
        return Theme.text;
    }

    onVisibleChanged: if (visible) {
        now = Date.now();
        refresh();
    }

    Timer {
        running: menu.visible
        interval: 30000
        repeat: true
        onTriggered: menu.now = Date.now()
    }

    Process {
        id: updater
        command: [Quickshell.shellDir + "/agents/update.sh"]
    }

    panelWidth: 380
    title: "Agents"
    icon: "󰚩"

    headerExtra: Text {
        id: refreshIcon
        text: "󰑐"
        color: updater.running ? Theme.accent : (refreshMouse.containsMouse ? Theme.text : Theme.muted)
        font.family: Theme.font
        font.pixelSize: Theme.iconSize

        RotationAnimation on rotation {
            running: updater.running
            loops: Animation.Infinite
            from: 0
            to: 360
            duration: 1000
            onStopped: refreshIcon.rotation = 0
        }

        MouseArea {
            id: refreshMouse
            anchors.fill: parent
            anchors.margins: -4
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: menu.refresh()
        }
    }

    Repeater {
        model: menu.agentIds

        AgentCard {
            required property string modelData
            required property int index

            Layout.fillWidth: true
            Layout.topMargin: index > 0 ? 8 : 0
            path: menu.stateDir + "/" + modelData + ".json"
            panel: menu
        }
    }
}
