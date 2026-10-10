import QtQuick
import QtQuick.Layouts

// Clickable list row: icon, label + optional sublabel, optional trailing text/action
Rectangle {
    id: row

    property string icon
    property color iconColor: Theme.subtext
    property string label
    property string sublabel
    property color labelColor: Theme.text
    property bool highlighted: false
    property bool busy: false
    property string trailing
    property color trailingColor: Theme.muted
    // Small icon button on the far right (e.g. forget device); empty = hidden
    property string actionIcon
    signal clicked
    signal actionClicked

    Layout.fillWidth: true
    implicitHeight: 44
    radius: Theme.radius - 2
    color: mouse.containsMouse ? Theme.hover : (highlighted ? Theme.surface : "transparent")
    opacity: busy ? 0.6 : 1

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: row.clicked()
    }

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 10
        }
        spacing: 12

        Text {
            text: row.icon
            color: row.iconColor
            font.family: Theme.font
            font.pixelSize: Theme.iconSize
            Layout.preferredWidth: 22
            horizontalAlignment: Text.AlignHCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Text {
                Layout.fillWidth: true
                text: row.label
                color: row.labelColor
                elide: Text.ElideRight
                font.family: Theme.font
                font.pixelSize: Theme.fontSize
                font.bold: row.highlighted
            }

            Text {
                Layout.fillWidth: true
                visible: row.sublabel !== ""
                text: row.sublabel
                color: Theme.muted
                elide: Text.ElideRight
                font.family: Theme.font
                font.pixelSize: Theme.fontSize - 2
            }
        }

        Text {
            visible: row.trailing !== ""
            text: row.trailing
            color: row.trailingColor
            font.family: Theme.font
            font.pixelSize: Theme.fontSize
        }

        Text {
            visible: row.actionIcon !== ""
            text: row.actionIcon
            color: actionMouse.containsMouse ? Theme.red : Theme.muted
            font.family: Theme.font
            font.pixelSize: Theme.fontSize + 2

            MouseArea {
                id: actionMouse
                anchors.fill: parent
                anchors.margins: -6
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: row.actionClicked()
            }
        }
    }
}
