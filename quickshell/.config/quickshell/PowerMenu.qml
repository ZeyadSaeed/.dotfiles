import Quickshell
import QtQuick
import QtQuick.Layouts

PopupPanel {
    id: menu

    readonly property var actions: [
        { key: "l", icon: "󰌾", label: "Lock", color: Theme.accent, cmd: "hyprlock" },
        { key: "r", icon: "󰜉", label: "Restart", color: Theme.yellow, cmd: "systemctl reboot" },
        { key: "s", icon: "󰐥", label: "Shutdown", color: Theme.red, cmd: "systemctl poweroff" }
    ]

    function run(action) {
        closeRequested();
        Quickshell.execDetached(["sh", "-c", action.cmd]);
    }

    panelWidth: 260
    title: "Power"
    icon: "󰐥"
    iconColor: Theme.red

    Item {
        focus: menu.visible
        Keys.onPressed: event => {
            const a = menu.actions.find(x => x.key === event.text.toLowerCase());
            if (a) {
                menu.run(a);
                event.accepted = true;
            }
        }
    }

    Repeater {
        model: menu.actions

        MenuRow {
            required property var modelData

            icon: modelData.icon
            iconColor: modelData.color
            label: modelData.label
            trailing: modelData.key.toUpperCase()
            onClicked: menu.run(modelData)
        }
    }
}
