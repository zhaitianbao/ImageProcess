import QtQuick 2.12
import QtQuick.Controls 2.12

// 自定义滑块
// orientation: Qt.Horizontal | Qt.Vertical
Slider {
    id: slider
    stepSize: 1

    property int handleHeight: (horizontal ? slider.height : slider.width) + 4
    property real startPoint: handleHeight - (horizontal ? slider.height : slider.width)

    background: Rectangle {
        width: slider.width; height: slider.height
        radius: height
        color: m_skin.comboBoxBackground
        border.color: m_skin.defaultBorderColor
        border.width: 1

        // 已经划过的矩形框
        Rectangle {
            width: horizontal ? slider.visualPosition * (parent.width - slider.handleHeight) + slider.handleHeight : parent.width
            height: horizontal ? parent.height : slider.visualPosition * (parent.height - slider.handleHeight) + slider.handleHeight
            color: Qt.darker(m_skin.buttonHoverColor,1.2)
            radius: horizontal ? height : width
            border.color: m_skin.defaultBorderColor
            border.width: 1
        }
    }

    handle: Rectangle {
        x: horizontal ? slider.visualPosition * (slider.width - width) : - slider.startPoint / 2
        y: horizontal ? - slider.startPoint / 2 : slider.visualPosition * (slider.height - height)
        width: height; height: slider.handleHeight
        radius: height
        color: m_skin.buttonPressColor
        border.color: m_skin.defaultBorderColor
        border.width: 1
    }
}

