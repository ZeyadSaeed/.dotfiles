import Quickshell
import Quickshell.Io
import QtQuick

// Popup menus opened from waybar via: qs ipc call menu toggle <wifi|bluetooth|agents|power>
ShellRoot {
    id: root

    property string active: ""

    IpcHandler {
        target: "menu"

        function toggle(name: string): void {
            root.active = root.active === name ? "" : name;
        }

        function close(): void {
            root.active = "";
        }
    }

    WifiMenu {
        visible: root.active === "wifi"
        onCloseRequested: root.active = ""
    }

    BluetoothMenu {
        visible: root.active === "bluetooth"
        onCloseRequested: root.active = ""
    }

    AgentsMenu {
        visible: root.active === "agents"
        onCloseRequested: root.active = ""
    }

    PowerMenu {
        visible: root.active === "power"
        onCloseRequested: root.active = ""
    }
}
