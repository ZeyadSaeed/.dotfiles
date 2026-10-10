import Quickshell.Io
import QtQuick
import QtQuick.Layouts

// One agent's usage record: plan, limit meters, today's stats and a 7-day activity strip
ColumnLayout {
    id: card

    property string path
    property var panel
    property var record: null

    readonly property var limits: record ? (record.limits || []) : []
    readonly property var days: record ? (record.recentDays || []).slice(-7) : []
    readonly property int maxDay: Math.max(1, ...days.map(d => d.messageCount || 0))
    readonly property string topModel: {
        if (!record) return "";
        const byModel = record.todayTokensByModel || {};
        let best = "", bestN = 0;
        for (const m in byModel) {
            if (byModel[m] > bestN) {
                best = m;
                bestN = byModel[m];
            }
        }
        return best.replace(/^claude-/, "");
    }

    visible: record !== null
    spacing: 6

    FileView {
        path: card.path
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: {
            try {
                card.record = JSON.parse(text());
            } catch (e) {
                card.record = null;
            }
        }
        onLoadFailed: card.record = null
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 1
        color: Theme.border
        visible: card.Layout.topMargin > 0
    }

    // Name + plan
    RowLayout {
        Layout.fillWidth: true
        Layout.leftMargin: 4
        spacing: 8

        Text {
            text: card.record ? card.record.name : ""
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.fontSize + 1
            font.bold: true
        }

        Rectangle {
            visible: card.record && card.record.tierLabel
            implicitWidth: tier.implicitWidth + 12
            implicitHeight: tier.implicitHeight + 4
            radius: 4
            color: Theme.surface
            border.color: Theme.border

            Text {
                id: tier
                anchors.centerIn: parent
                text: card.record && card.record.tierLabel ? card.record.tierLabel : ""
                color: Theme.accent
                font.family: Theme.font
                font.pixelSize: Theme.fontSize - 3
                font.capitalization: Font.AllUppercase
            }
        }

        Item { Layout.fillWidth: true }

        Text {
            visible: card.record && card.record.usageStatusText
            text: card.record ? (card.record.usageStatusText || "") : ""
            color: Theme.red
            font.family: Theme.font
            font.pixelSize: Theme.fontSize - 2
        }
    }

    // Rate-limit meters
    Repeater {
        model: card.limits

        ColumnLayout {
            id: limit
            required property var modelData

            Layout.fillWidth: true
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            spacing: 3

            RowLayout {
                Layout.fillWidth: true

                Text {
                    Layout.fillWidth: true
                    text: limit.modelData.label
                    color: Theme.subtext
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize - 1
                }

                Text {
                    text: Math.round(limit.modelData.percent * 100) + "%"
                    color: card.panel.meterColor(limit.modelData.percent)
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize - 1
                    font.bold: true
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 6
                radius: 3
                color: Theme.hover
                opacity: card.record && card.record.limitsStale ? 0.5 : 1

                Rectangle {
                    width: parent.width * Math.min(1, Math.max(0, limit.modelData.percent))
                    height: parent.height
                    radius: 3
                    color: card.panel.meterColor(limit.modelData.percent)

                    Behavior on width {
                        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                    }
                }
            }

            Text {
                visible: !!limit.modelData.resetsAt
                text: "resets in " + card.panel.formatDuration(Date.parse(limit.modelData.resetsAt) - card.panel.now)
                color: Theme.muted
                font.family: Theme.font
                font.pixelSize: Theme.fontSize - 3
            }
        }
    }

    // Today
    RowLayout {
        Layout.fillWidth: true
        Layout.leftMargin: 4
        Layout.rightMargin: 4
        Layout.topMargin: 2
        spacing: 14

        Repeater {
            model: card.record ? [
                { icon: "󰆼", value: card.panel.formatTokens(card.record.todayTotalTokens), hint: "tokens" },
                { icon: "󰍩", value: String(card.record.todayPrompts || 0), hint: "prompts" },
                { icon: "󰆍", value: String(card.record.todaySessions || 0), hint: "sessions" }
            ] : []

            RowLayout {
                required property var modelData
                spacing: 5

                Text {
                    text: modelData.icon
                    color: Theme.accent
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize
                }

                Text {
                    text: modelData.value
                    color: Theme.text
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize - 1
                }

                Text {
                    text: modelData.hint
                    color: Theme.muted
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize - 3
                }
            }
        }

        Item { Layout.fillWidth: true }

        Text {
            text: "today"
            color: Theme.muted
            font.family: Theme.font
            font.pixelSize: Theme.fontSize - 3
        }
    }

    Text {
        Layout.leftMargin: 4
        visible: card.topModel !== ""
        text: "Top model today: " + card.topModel
        color: Theme.muted
        font.family: Theme.font
        font.pixelSize: Theme.fontSize - 3
    }

    // Last 7 days of tokens (recentDays.messageCount holds token totals)
    RowLayout {
        Layout.fillWidth: true
        Layout.leftMargin: 4
        Layout.rightMargin: 4
        Layout.topMargin: 2
        visible: card.days.some(d => (d.messageCount || 0) > 0)
        spacing: 6

        Repeater {
            model: card.days

            ColumnLayout {
                id: day
                required property var modelData
                required property int index

                Layout.fillWidth: true
                spacing: 3

                Item {
                    Layout.fillWidth: true
                    implicitHeight: 28

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: Math.max(2, parent.height * (day.modelData.messageCount || 0) / card.maxDay)
                        radius: 2
                        color: day.index === card.days.length - 1 ? Theme.accent : Theme.border
                    }

                    MouseArea {
                        id: dayMouse
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: dayMouse.containsMouse
                        ? card.panel.formatTokens(day.modelData.messageCount || 0)
                        : new Date(day.modelData.date + "T00:00:00").toLocaleDateString(Qt.locale(), "ddd").slice(0, 2)
                    color: dayMouse.containsMouse ? Theme.text : Theme.muted
                    font.family: Theme.font
                    font.pixelSize: Theme.fontSize - 4
                }
            }
        }
    }
}
