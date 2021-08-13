import QtQuick 2.0

// 自定义图像与文字结合的控件，只用于菜单栏下拉列表
Rectangle {
    width: isChinese ? 130 : 150; height: 40
    color: mouseArea.containsMouse ? m_skin.actionHoverColor : m_skin.actionBackground

    property alias imageSource: image.source
    property alias content: label.text
    property alias font_family:label.font.family

    signal selected()

    Image {
        id: image
        width: 26; height: 26
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 7
    }

    Text {
        id: label
        width: isChinese ? 80 : 100; height: 40
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 50
        font.family: "微软雅黑"
        font.pixelSize: 14
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: enabled ? m_skin.menuTextColor : m_skin.unenableTextColor
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: selected()
    }
}
