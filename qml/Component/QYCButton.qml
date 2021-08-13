import QtQuick 2.0
import "../Component"

// 自定义图像与文字结合的花式按钮，可通用
Rectangle {
    width: isChinese ? 140 : 160; height: 40
    color: mouseArea.pressed || checked ? m_skin.buttonPressColor : (mouseArea.containsMouse ? m_skin.buttonHoverColor : "transparent")
    border.color: mouseArea.containsMouse ? m_skin.activeBorderColor : m_skin.defaultBorderColor
    radius: height

    property alias imageSource: image.source
    property alias content: label.text
    property int pixelSize: 14
    property bool checked: false

    signal selected()

    Image {
        id: image
        x: source == "" ? 0 : parent.height/4
        width: source == "" ? 0 : height; height: parent.height/4*3
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: label
        x: image.width + image.x*2
        width: parent.width - x; height: parent.height
        font.family: "微软雅黑"
        font.pixelSize: pixelSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
        color: enabled ? m_skin.menuTextColor : m_skin.unenableTextColor
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: selected()
    }
}
