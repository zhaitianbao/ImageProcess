import QtQuick 2.12

// 自定义文本输入框
Rectangle {
    id: textEdit
    width: isChinese ? 120 : 160; height: 40
    color: "transparent"

    property alias prefixText: prefix.text
    property string content: ""		
    property alias inputText: textinput

    property int spacing: 0
	property int inputBoxMaxHeight: height
    property int pixelSize: 12

    // 字体宽度固定为四个中文一个空格一个冒号的总宽度
    Text {
        id: prefix
        width: {
            // 输入框的宽度最小值为30，若小于这个数，那么就将前缀超出部分显示为...
            if (text === "") return 0
            if ((parent.width - 30) < (isChinese ? 60 : 100))
            {
                return parent.width - 30
            }
            else
            {
                return isChinese ? 60 : 100
            }
        }
        height: parent.height
        color: enabled ? m_skin.menuTextColor : m_skin.unenableTextColor
        font.family: "微软雅黑"
        font.pixelSize: pixelSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
    }

    Rectangle {
        id: inputBox
        x: prefix.width + spacing + (prefix.text === "" ? 0 : 5)
        y: inputBoxMaxHeight < parent.height ? (parent.height - inputBoxMaxHeight) / 2 : 0
        width: parent.width - x
        height: parent.height - 2 * y
        border.width: textinput.activeFocus ? 2 : 1
        border.color: textinput.activeFocus ? m_skin.activeBorderColor : m_skin.defaultBorderColor
        color: textEdit.enabled ? (textinput.activeFocus ? m_skin.unenableTextColor : m_skin.menuBarBackground) : "transparent"
        radius: textEdit.radius

        TextInput {
            id: textinput
            anchors.fill: parent
            font.family: "微软雅黑"
            font.pixelSize: pixelSize + 2
            horizontalAlignment: TextInput.AlignLeft
            verticalAlignment: TextInput.AlignVCenter
            leftPadding: 5
            color: enabled ? m_skin.menuTextColor : m_skin.unenableTextColor
            selectByMouse: true
            clip: true
            selectionColor: "transparent"
            text: content
            Keys.onPressed: {
                if ( event.key === Qt.Key_Return || event.key === Qt.Key_Enter ) {
                    textinput.focus = false
                }
            }

            onTextChanged: {
                // 符合输入条件的情况
                if (acceptableInput) {
                    content = text
                } else {
                    if ( text !== "" ) {
                        text = content
                    }
                }
            }

            onFocusChanged: {
                // 不符合正则校验式的情况
                if (!acceptableInput && !focus) {
                    text = content
                }
            }
        }
    }
}
