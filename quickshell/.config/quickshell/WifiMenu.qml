import Quickshell
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts

PopupPanel {
    id: menu

    readonly property var device: {
        const devs = Networking.devices.values;
        for (let i = 0; i < devs.length; i++) {
            if (devs[i].type === DeviceType.Wifi)
                return devs[i];
        }
        return null;
    }
    readonly property bool enabled: Networking.wifiEnabled
    readonly property var networks: {
        if (!device || !enabled)
            return [];
        return device.networks.values
            .filter(n => n.name !== "")
            .sort((a, b) => (b.connected - a.connected) || (b.known - a.known) || (b.signalStrength - a.signalStrength));
    }

    // Network currently asking for a password, and last error message
    property var pskTarget: null
    property string error: ""

    function strength(n) {
        const s = n.signalStrength > 1 ? n.signalStrength / 100 : n.signalStrength;
        return s;
    }

    function signalIcon(n) {
        const s = strength(n);
        if (s > 0.8) return "󰤨";
        if (s > 0.6) return "󰤥";
        if (s > 0.4) return "󰤢";
        if (s > 0.2) return "󰤟";
        return "󰤯";
    }

    function isOpen(n) {
        return n.security === WifiSecurityType.Open || n.security === WifiSecurityType.Owe;
    }

    function activate(n) {
        error = "";
        if (n.connected) {
            n.disconnect();
        } else if (n.known || isOpen(n)) {
            pskTarget = null;
            n.connect();
        } else {
            pskTarget = pskTarget === n ? null : n;
        }
    }

    // True for a while after opening / rescanning, before showing "No networks found"
    property bool scanning: false

    function rescan() {
        scanning = true;
        scanTimer.restart();
        Quickshell.execDetached(["nmcli", "device", "wifi", "rescan"]);
    }

    onVisibleChanged: {
        pskTarget = null;
        error = "";
        if (visible && enabled)
            rescan();
    }

    onEnabledChanged: if (visible && enabled) rescan()

    Timer {
        id: scanTimer
        interval: 10000
        onTriggered: menu.scanning = false
    }

    title: "Wi-Fi"
    icon: enabled ? "󰖩" : "󰖪"
    iconColor: enabled ? Theme.accent : Theme.muted

    headerExtra: RowLayout {
        spacing: 12

        Text {
            id: rescanIcon
            visible: menu.enabled
            text: "󰑐"
            color: menu.scanning ? Theme.accent : (rescanMouse.containsMouse ? Theme.text : Theme.muted)
            font.family: Theme.font
            font.pixelSize: Theme.iconSize

            RotationAnimation on rotation {
                running: menu.scanning
                loops: Animation.Infinite
                from: 0
                to: 360
                duration: 1000
                onStopped: rescanIcon.rotation = 0
            }

            MouseArea {
                id: rescanMouse
                anchors.fill: parent
                anchors.margins: -4
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: menu.rescan()
            }
        }

        Toggle {
            checked: menu.enabled
            onToggled: Networking.wifiEnabled = !Networking.wifiEnabled
        }
    }

    // Scan only while the menu is open
    Binding {
        target: menu.device
        property: "scannerEnabled"
        value: menu.visible && menu.enabled
        when: menu.device !== null
    }

    Text {
        Layout.fillWidth: true
        Layout.margins: 6
        visible: !menu.enabled || !menu.device || menu.networks.length === 0
        text: !menu.device ? "No Wi-Fi adapter found"
            : !Networking.wifiHardwareEnabled ? "Wi-Fi is blocked by a hardware switch"
            : !menu.enabled ? "Wi-Fi is off"
            : menu.scanning ? "Scanning…"
            : "No networks found"
        color: Theme.muted
        font.family: Theme.font
        font.pixelSize: Theme.fontSize
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        Layout.fillWidth: true
        Layout.leftMargin: 6
        visible: menu.error !== ""
        text: menu.error
        color: Theme.red
        wrapMode: Text.Wrap
        font.family: Theme.font
        font.pixelSize: Theme.fontSize - 1
    }

    Flickable {
        Layout.fillWidth: true
        visible: menu.networks.length > 0
        implicitHeight: Math.min(list.implicitHeight, 400)
        contentHeight: list.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            id: list
            width: parent.width
            spacing: 2

            Repeater {
                model: menu.networks

                ColumnLayout {
                    id: entry
                    required property var modelData

                    Layout.fillWidth: true
                    spacing: 4

                    Connections {
                        target: entry.modelData

                        function onConnectionFailed(reason) {
                            if (reason === ConnectionFailReason.NoSecrets && !entry.modelData.known) {
                                menu.pskTarget = entry.modelData;
                                menu.error = "Password required";
                            } else {
                                menu.error = "Failed to connect: " + ConnectionFailReason.toString(reason);
                            }
                        }
                    }

                    MenuRow {
                        icon: menu.signalIcon(entry.modelData)
                        iconColor: entry.modelData.connected ? Theme.accent : Theme.subtext
                        label: entry.modelData.name
                        highlighted: entry.modelData.connected
                        busy: entry.modelData.stateChanging
                        sublabel: entry.modelData.stateChanging
                            ? ConnectionState.toString(entry.modelData.state) + "…"
                            : entry.modelData.connected ? "Connected · click to disconnect"
                            : entry.modelData.known ? "Saved" : ""
                        trailing: menu.isOpen(entry.modelData) ? "" : "󰌾"
                        actionIcon: entry.modelData.known && !entry.modelData.connected ? "󰆴" : ""
                        onClicked: menu.activate(entry.modelData)
                        onActionClicked: entry.modelData.forget()
                    }

                    PasswordField {
                        Layout.fillWidth: true
                        visible: menu.pskTarget === entry.modelData
                        active: visible
                        onSubmitted: psk => {
                            menu.error = "";
                            menu.pskTarget = null;
                            entry.modelData.connectWithPsk(psk);
                        }
                    }
                }
            }
        }
    }
}
