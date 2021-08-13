import QtQuick 2.0

// 自定义图像与文字结合的复选按钮，只用于工具栏
Rectangle {
    width: label.width + 40; height: 32
    anchors.verticalCenter: parent.verticalCenter
    radius: 2
    color: (checked || mouseArea.pressed) ? m_skin.toolButtonPressColor :
                                            (mouseArea.containsMouse ? m_skin.toolButtonHoverColor : "transparent")

    property alias imageSource: image.source
    property alias content: label.text
    property bool checkable: false
    property bool checked: false

    signal selected()

    Image {
        id: image
        width: 26; height: 26
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 3
        anchors.bottomMargin: 3
        anchors.leftMargin: 7
        anchors.rightMargin: 7
    }

    Text {
        id: label
        width: label.contentWidth + 7; height: 32
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 40
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
        onClicked: {
            selected()
            
            if ( checkable ) {
                checked = !checked
            }
        }
    }
}
