import QtQuick 2.0

// 自定义数字调整框
Rectangle {
    width: isChinese ? 160 : 190; height: 30
    color: enabled ? (textInput.activeFocus ? m_skin.unenableTextColor : m_skin.menuBarBackground) : "transparent"
    border.width: textInput.activeFocus ? 2 : 1
    border.color: textInput.activeFocus ? m_skin.activeBorderColor : m_skin.defaultBorderColor
    anchors.margins: 1

    property string spinBoxPrefix: ""       // 前缀文本
    property string spinBoxSuffix: ""       // 后缀文本
    property int spinBoxDecimals: 2         // 保留小数位
    property int pixelSize: 12              // 字体大小
    property real spinBoxStepSize: 0.1      // 步进
    property real spinBoxValue: -9999       // 数值
    property real minValue: 0.1             // 最小值
    property real maxValue: 9999            // 最大值
    property bool minusEnable: false        // 是否可以是负数
    property real resultValue: 0            // 结果数值

    onSpinBoxValueChanged: textInput.text = spinBoxValue

    // 前缀文本
    Text {
        x: 5
        width: isChinese ? 45 : 72; height: parent.height
        font.family: "微软雅黑"
        font.pixelSize: pixelSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        elide: Text.ElideRight
        color: enabled ? m_skin.menuTextColor : m_skin.unenableTextColor
        text: spinBoxPrefix

        MouseArea {
            anchors.fill: parent
            onClicked: focusScope.focus = true
        }
    }

    FocusScope
    {
        id: focusScope
        width: 100 + (spinBoxPrefix === "" ? 0 : (isChinese ? 45 : 72))
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: spinBoxPrefix === "" ? 5 : (isChinese ? 45 : 72)

        onFocusChanged: {
            // 不符合正则校验式的情况
            if(!focus && !textInput.acceptableInput)
            {
                // 超出最小或最大值，则为最小值或最大值
                if (minValue > spinBoxValue)
                    resultValue = minValue
                if (maxValue < spinBoxValue)
                    resultValue = maxValue
            }

            textInput.text = spinBoxValue = resultValue
        }

        // 数值
        TextInput {
            id: textInput
            anchors.fill: parent
            horizontalAlignment: TextInput.AlignLeft
            verticalAlignment: TextInput.AlignVCenter
            font.family: "微软雅黑"
            font.pixelSize: pixelSize + 2
            maximumLength: 8
            cursorVisible: false
            selectByMouse: true
            selectionColor: "transparent"
            color: enabled ? m_skin.menuTextColor : m_skin.unenableTextColor
            validator: DoubleValidator{
                top: maxValue
                bottom: minValue
                decimals: spinBoxDecimals
                notation: DoubleValidator.StandardNotation //限制输入位数
            }

            Keys.onPressed: {
                if ( event.key === Qt.Key_Return || event.key === Qt.Key_Enter ) {
                    textInput.focus = false
                }
            }

            onTextChanged: {
                // 符合输入条件的情况
                if (acceptableInput) {
                    resultValue = Number(text)

                    // 若确实输入一个0的情况
                    if (text === "0") {
                        spinBoxValue = resultValue
                        return
                    }

                    // 处理0.或-0.的情况
                    if (resultValue !== 0 ) {
                        spinBoxValue = resultValue
                    }
                }
                else{
                    // 是数字的情况
                    if(!isNaN(text) && text !== "") {
                        spinBoxValue = Number(text)
                    }
                }

            }
        }

        // 后缀文本（单位）
        Text {
            width: 40; height: parent.height
            anchors.left: textInput.left
            anchors.leftMargin: textInput.contentWidth + 5
            font.family: "微软雅黑"
            font.pixelSize: pixelSize
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            elide: Text.ElideRight
            color: enabled ? m_skin.menuTextColor : m_skin.unenableTextColor
            text: spinBoxSuffix
        }
    }

    // 上加箭头
    Rectangle {
        width: 20; height: 13
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 2
        color: area_up.containsMouse ? m_skin.buttonPressColor : "transparent"

        Image {
            width: 12; height: 12
            anchors.centerIn: parent
            source: m_skin.isDark ? "qrc:/image/Component/UpSL.png" : "qrc:/image/Component/UpS.png"
        }

        MouseArea {
            id: area_up
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                focusScope.focus = true
                // 若已经比最小值小，则加的时候直接设为最小值
                if (spinBoxValue < minValue) {
                    spinBoxValue = minValue.toFixed(spinBoxDecimals)
                    return
                }

                if ( spinBoxValue < maxValue ) {
                    var tmp = spinBoxValue + spinBoxStepSize
                    if (tmp > maxValue) tmp = maxValue
                    spinBoxValue = tmp.toFixed(spinBoxDecimals)
                }
            }
        }
    }

    // 下减箭头
    Rectangle {
        width: 20; height: 13
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 2
        color: area_down.containsMouse ? m_skin.buttonPressColor : "transparent"

        Image {
            width: 12; height: 12
            anchors.centerIn: parent
            source: m_skin.isDark ? "qrc:/image/Component/DownSL.png" : "qrc:/image/Component/DownS.png"
        }

        MouseArea {
            id: area_down
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                focusScope.focus = true

                // 若已经比最大值大，则减的时候直接设为最大值
                if (spinBoxValue > maxValue) {
                    spinBoxValue = maxValue.toFixed(spinBoxDecimals)
                    return
                }

                if ( spinBoxValue > minValue ) {
                    var tmp = spinBoxValue - spinBoxStepSize
                    if (tmp < minValue) tmp = minValue
                    spinBoxValue = tmp.toFixed(spinBoxDecimals)
                }
            }
        }
    }

}
