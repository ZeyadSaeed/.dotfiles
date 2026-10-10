import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts

PopupPanel {
    id: menu

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool enabled: adapter !== null && adapter.enabled
    // Skip nameless devices that only advertise their MAC address
    readonly property var devices: adapter ? adapter.devices.values.filter(d => d.name !== "" && !/^([0-9A-F]{2}[-:]){5}[0-9A-F]{2}$/i.test(d.name)) : []
    readonly property var paired: devices.filter(d => d.paired).sort((a, b) => b.connected - a.connected)
    readonly property var available: devices.filter(d => !d.paired)

    function deviceIcon(d) {
        const i = d.icon || "";
        if (i.includes("headset")) return "󰋎";
        if (i.includes("headphone") || i.includes("audio")) return "󰋋";
        if (i.includes("mouse")) return "󰍽";
        if (i.includes("keyboard")) return "󰌌";
        if (i.includes("phone")) return "󰄜";
        if (i.includes("gaming")) return "󰊴";
        if (i.includes("computer")) return "󰟀";
        return "󰂯";
    }

    function status(d) {
        switch (d.state) {
        case BluetoothDeviceState.Connecting: return "Connecting…";
        case BluetoothDeviceState.Disconnecting: return "Disconnecting…";
        }
        if (d.pairing) return "Pairing…";
        if (d.connected) {
            const bat = d.batteryAvailable ? " · 󰁹 " + Math.round(d.battery * 100) + "%" : "";
            return "Connected" + bat;
        }
        return d.paired ? "Paired" : "";
    }

    function activate(d) {
        if (d.connected) {
            d.disconnect();
        } else if (d.paired) {
            d.connect();
        } else {
            d.trusted = true;
            d.pair();
        }
    }

    title: "Bluetooth"
    icon: enabled ? "󰂯" : "󰂲"
    iconColor: enabled ? Theme.accent : Theme.muted

    headerExtra: Toggle {
        checked: menu.enabled
        onToggled: if (menu.adapter) menu.adapter.enabled = !menu.adapter.enabled
    }

    // Discover nearby devices only while the menu is open
    Binding {
        target: menu.adapter
        property: "discovering"
        value: menu.visible && menu.enabled
        when: menu.adapter !== null
    }

    Text {
        Layout.fillWidth: true
        Layout.margins: 6
        visible: !menu.enabled || menu.devices.length === 0
        text: !menu.adapter ? "No Bluetooth adapter found"
            : menu.adapter.state === BluetoothAdapterState.Blocked ? "Bluetooth is blocked (rfkill)"
            : !menu.enabled ? "Bluetooth is off"
            : "Searching for devices…"
        color: Theme.muted
        font.family: Theme.font
        font.pixelSize: Theme.fontSize
        horizontalAlignment: Text.AlignHCenter
    }

    Flickable {
        Layout.fillWidth: true
        visible: menu.enabled && menu.devices.length > 0
        implicitHeight: Math.min(list.implicitHeight, 420)
        contentHeight: list.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            id: list
            width: parent.width
            spacing: 2

            SectionLabel {
                visible: menu.paired.length > 0
                text: "Paired"
            }

            Repeater {
                model: menu.paired

                MenuRow {
                    required property var modelData

                    icon: menu.deviceIcon(modelData)
                    iconColor: modelData.connected ? Theme.accent : Theme.subtext
                    label: modelData.name
                    sublabel: menu.status(modelData)
                    highlighted: modelData.connected
                    busy: modelData.state === BluetoothDeviceState.Connecting || modelData.state === BluetoothDeviceState.Disconnecting
                    actionIcon: "󰆴"
                    onClicked: menu.activate(modelData)
                    onActionClicked: modelData.forget()
                }
            }

            SectionLabel {
                visible: menu.available.length > 0
                text: "Available"
            }

            Repeater {
                model: menu.available

                MenuRow {
                    id: availRow
                    required property var modelData

                    icon: menu.deviceIcon(modelData)
                    label: modelData.name
                    sublabel: menu.status(modelData)
                    busy: modelData.pairing
                    onClicked: menu.activate(modelData)

                    // Connect right after a successful pair
                    Connections {
                        target: availRow.modelData

                        function onPairedChanged() {
                            if (availRow.modelData.paired)
                                availRow.modelData.connect();
                        }
                    }
                }
            }
        }
    }
}
