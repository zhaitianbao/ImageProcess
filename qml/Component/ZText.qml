import QtQuick 2.0

// 自定义文本框
Rectangle {
    width: isChinese ? 20 : 30; height: 24
    color: "transparent"

    property alias content: textBox.text
    property alias contentWidth: textBox.contentWidth
    property alias contentHeight: textBox.contentHeight
    property int pixelSize: 14
    property bool fontBold: false
    property bool useThemeColor: true
    property string specialColor: "#FFFFFF"

    Text {
        id: textBox
        height: parent.height
        font.family: "微软雅黑"
        font.bold: fontBold
        font.pixelSize: pixelSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
        color: useThemeColor ? m_skin.menuTextColor : specialColor
    }
}
