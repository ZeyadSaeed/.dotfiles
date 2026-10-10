import QtQuick
import QtQuick.Layouts

Rectangle {
    id: field

    property bool active: false
    signal submitted(string psk)

    implicitHeight: 38
    radius: Theme.radius - 2
    color: Theme.surface
    border.color: input.activeFocus ? Theme.accent : Theme.border
    border.width: 1

    onActiveChanged: {
        input.text = "";
        if (active)
            input.forceActiveFocus();
    }

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 12
            rightMargin: 6
        }
        spacing: 8

        TextInput {
            id: input
            Layout.fillWidth: true
            echoMode: reveal.shown ? TextInput.Normal : TextInput.Password
            color: Theme.text
            selectionColor: Theme.accent
            selectedTextColor: Theme.bg
            font.family: Theme.font
            font.pixelSize: Theme.fontSize
            clip: true
            onAccepted: if (text.length > 0) field.submitted(text)

            Text {
                visible: input.text === ""
                text: "Password"
                color: Theme.muted
                font: input.font
            }
        }

        Text {
            id: reveal
            property bool shown: false
            text: shown ? "󰈈" : "󰈉"
            color: Theme.muted
            font.family: Theme.font
            font.pixelSize: Theme.iconSize - 2

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                cursorShape: Qt.PointingHandCursor
                onClicked: reveal.shown = !reveal.shown
            }
        }

        Rectangle {
            implicitWidth: 28
            implicitHeight: 28
            radius: 6
            color: input.text.length > 0 ? Theme.accent : Theme.hover

            Text {
                anchors.centerIn: parent
                text: "󰁔"
                color: input.text.length > 0 ? Theme.bg : Theme.muted
                font.family: Theme.font
                font.pixelSize: Theme.iconSize - 2
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: if (input.text.length > 0) field.submitted(input.text)
            }
        }
    }
}
