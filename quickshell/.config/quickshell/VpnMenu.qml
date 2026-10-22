import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

// VPN (OpenVPN/WireGuard) connections from NetworkManager; only one up at a time (Proton Free allows 1 device)
PopupPanel {
    id: menu

    readonly property var countries: ({
        ca: "Canada", ch: "Switzerland", jp: "Japan", mx: "Mexico", nl: "Netherlands",
        no: "Norway", pl: "Poland", ro: "Romania", sg: "Singapore", us: "United States"
    })

    // [{ name, active }] sorted by name
    property var conns: []
    // Connection being switched to, and last one that failed to come up
    property string pending: ""
    property string failed: ""

    function country(name) {
        const m = name.match(/^proton-([a-z]+)/);
        return m && countries[m[1]] ? countries[m[1]] : name;
    }

    // Regional indicator letters render as the country's flag emoji
    function flag(name) {
        const m = name.match(/^proton-([a-z]{2})\b/);
        return m ? String.fromCodePoint(...[...m[1]].map(ch => 0x1F1E6 + ch.charCodeAt(0) - 97)) : "󰦞";
    }

    function activate(c) {
        if (switcher.running)
            return;
        failed = "";
        pending = c.active ? "" : c.name;
        // Down every active VPN connection first, then bring up the target (if any)
        switcher.command = ["sh", "-c",
            "nmcli -t -f NAME,TYPE connection show --active | sed -nE 's/:(vpn|wireguard)$//p' | while IFS= read -r n; do nmcli connection down \"$n\"; done; [ -z \"$1\" ] || nmcli connection up \"$1\"",
            "sh", pending];
        switcher.running = true;
    }

    onVisibleChanged: if (visible) lister.running = true

    Timer {
        running: menu.visible
        interval: 2000
        repeat: true
        onTriggered: lister.running = true
    }

    Process {
        id: lister
        command: ["nmcli", "-t", "-f", "NAME,TYPE,ACTIVE", "connection", "show"]
        stdout: StdioCollector {
            onStreamFinished: menu.conns = text.split("\n")
                .map(l => l.split(":"))
                .filter(f => f[1] === "vpn" || f[1] === "wireguard")
                .map(f => ({ name: f[0], active: f[2] === "yes" }))
                .sort((a, b) => a.name.localeCompare(b.name))
        }
    }

    Process {
        id: switcher
        onExited: exitCode => {
            if (exitCode !== 0)
                menu.failed = menu.pending;
            menu.pending = "";
            lister.running = true;
        }
    }

    title: "VPN"
    icon: conns.some(c => c.active) ? "󰦝" : "󰦞"
    iconColor: conns.some(c => c.active) ? Theme.green : Theme.muted

    Text {
        Layout.fillWidth: true
        Layout.margins: 6
        visible: menu.conns.length === 0
        text: "No VPN connections"
        color: Theme.muted
        font.family: Theme.font
        font.pixelSize: Theme.fontSize
        horizontalAlignment: Text.AlignHCenter
    }

    Repeater {
        model: menu.conns

        MenuRow {
            required property var modelData

            icon: menu.flag(modelData.name)
            iconColor: modelData.active ? Theme.green : Theme.subtext
            label: menu.country(modelData.name)
            sublabel: modelData.name
            highlighted: modelData.active
            busy: menu.pending === modelData.name
            trailing: busy ? "Connecting…" : menu.failed === modelData.name ? "Failed" : modelData.active ? "Connected" : ""
            trailingColor: menu.failed === modelData.name ? Theme.red : modelData.active ? Theme.green : Theme.muted
            onClicked: menu.activate(modelData)
        }
    }
}
