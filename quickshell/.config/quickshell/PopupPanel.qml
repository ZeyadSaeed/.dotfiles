import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

// Dropdown under the top-right of the bar. The window covers the screen (minus the bar)
// with a transparent backdrop so clicking anywhere outside the menu closes it.
PanelWindow {
    id: panel

    signal closeRequested

    property string title
    property string icon
    property color iconColor: Theme.accent
    // Optional widget shown at the right of the header (e.g. an on/off switch)
    property alias headerExtra: headerExtra.data
    default property alias content: body.data

    property int panelWidth: 360

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: 0
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "qs-menu"
    // OnDemand, not Exclusive: Hyprland blocks pointer input to other surfaces (waybar)
    // while an exclusive-focus layer is open
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    onVisibleChanged: if (visible) frame.forceActiveFocus()

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onClicked: panel.closeRequested()
    }

    Rectangle {
        id: frame

        anchors {
            top: parent.top
            right: parent.right
            topMargin: 2
            rightMargin: 16
        }
        width: panel.panelWidth
        implicitHeight: layout.implicitHeight + 24
        radius: Theme.radius
        color: Theme.bg
        border.color: Theme.border
        border.width: 1

        focus: true
        Keys.onEscapePressed: panel.closeRequested()

        // Swallow clicks inside the menu so they don't reach the backdrop
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
        }

        ColumnLayout {
            id: layout

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: 12
            }
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: panel.icon
                    color: panel.iconColor
                    font.family: Theme.font
                    font.pixelSize: Theme.iconSize + 2
                }

                Text {
                    Layout.fillWidth: true
                    text: panel.title
                    color: Theme.text
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize + 2
                    font.bold: true
                }

                Item {
                    id: headerExtra
                    implicitWidth: childrenRect.width
                    implicitHeight: childrenRect.height
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: Theme.border
            }

            ColumnLayout {
                id: body
                Layout.fillWidth: true
                spacing: 4
            }
        }
    }
}
