import Quickshell
import Quickshell.Io
import QtQuick

// Popup menus opened from waybar via: qs ipc call menu toggle <wifi|vpn|bluetooth|agents|power> <cursor x>
ShellRoot {
    id: root

    property string active: ""
    property real anchorX

    IpcHandler {
        target: "menu"

        function toggle(name: string, x: int): void {
            root.anchorX = x;
            root.active = root.active === name ? "" : name;
        }

        function close(): void {
            root.active = "";
        }
    }

    WifiMenu {
        visible: root.active === "wifi"
        anchorX: root.anchorX
        onCloseRequested: root.active = ""
    }

    VpnMenu {
        visible: root.active === "vpn"
        anchorX: root.anchorX
        onCloseRequested: root.active = ""
    }

    BluetoothMenu {
        visible: root.active === "bluetooth"
        anchorX: root.anchorX
        onCloseRequested: root.active = ""
    }

    AgentsMenu {
        visible: root.active === "agents"
        anchorX: root.anchorX
        onCloseRequested: root.active = ""
    }

    PowerMenu {
        visible: root.active === "power"
        anchorX: root.anchorX
        onCloseRequested: root.active = ""
    }
}
