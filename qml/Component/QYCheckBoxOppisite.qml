import QtQuick 2.0

// 自定义选择框
Rectangle {
    width: 80; height: 30
    color: "transparent"

    property bool isChecked: false
    property int spacing: 10
    property string prefix: " Yes"
    property string suffix: " No"
    property int buttonWidth: (width - spacing) / 2

    QYRadioButton {
        id: yes
        width: buttonWidth; height: parent.height
        anchors.left: parent.left
        content: prefix
        checked: isChecked
        isPairCheckBox: true
        showInCenter: true
        onSelected: isChecked = !isChecked
    }

    QYRadioButton {
        id: no
        width: buttonWidth; height: parent.height
        anchors.right: parent.right
        content: suffix
        checked: !isChecked
        isPairCheckBox: true
        showInCenter: true
        onSelected: isChecked = !isChecked
    }
}
