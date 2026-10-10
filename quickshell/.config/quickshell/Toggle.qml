import QtQuick

Rectangle {
    id: toggle

    property bool checked
    signal toggled

    implicitWidth: 40
    implicitHeight: 22
    radius: height / 2
    color: checked ? Theme.accent : Theme.hover

    Behavior on color {
        ColorAnimation { duration: 120 }
    }

    Rectangle {
        width: 16
        height: 16
        radius: 8
        y: 3
        x: toggle.checked ? toggle.width - width - 3 : 3
        color: toggle.checked ? Theme.bg : Theme.muted

        Behavior on x {
            NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: toggle.toggled()
    }
}
