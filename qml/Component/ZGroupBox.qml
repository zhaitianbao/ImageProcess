import QtQuick 2.0

// 自定义组合框
Rectangle {
    color: m_skin.moduleBarBackground

    property string title: ""
    property int titleHeight: 30
    property int pixelSize: 16
    property bool fontBold: false

    Rectangle {
        width: parent.width ; height: titleHeight
        color: m_skin.buttonPressColor

        Text {
            anchors.fill: parent
            anchors.leftMargin: 10
			font.family: "微软雅黑"
            font.bold: fontBold
            font.pixelSize: pixelSize
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
			color: m_skin.menuTextColor
            text: title
        }
    }
}
