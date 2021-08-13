import QtQuick 2.0
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.12
import "../Component"

// 自定义复选按钮
Rectangle {
    id: radioButton
    width: 120; height: 30
    radius: 2
    color: mouseArea.containsMouse ? hoverColor : backgroundColor

    property bool checked: false
    property bool unselectedAble: true
    property bool isPairCheckBox: false					// 是否用作一对checkbox
    property bool showInCenter: false
    property ExclusiveGroup exclusiveGroup: null
    property alias content: label.text
    property int pixelSize: 12
    property bool showUnderLine: false                 // 是否显示底下的下划线

    property string backgroundColor: m_skin.moduleBarBackground
    property string hoverColor: m_skin.buttonHoverColor
    property string circleColor: m_skin.menuTextColor

    signal selected()

    onExclusiveGroupChanged: {
        if (exclusiveGroup) {
            exclusiveGroup.bindCheckable(radioButton)
        }
    }

    // 同心圆
    Rectangle {
        id: concircle
        x: parent.height / 5; y: parent.height / 5
        width: parent.height - 2 * x; height: width
        radius: width
        color: "transparent"
        border.color: circleColor
        border.width: 2

        Rectangle {
            x: parent.width / 4; y: parent.width / 4
            width: parent.width / 2; height: width
            radius: width
            color: circleColor
            visible: checked
        }
    }

    Text {
        id: label
        x: showInCenter ? (concircle.width + concircle.x) : (concircle.width + concircle.x * 2)
        width: parent.width - x; height: parent.height
        font.family: "微软雅黑"
        font.pixelSize: pixelSize
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: showInCenter ? Text.AlignHCenter : Text.AlignLeft
        elide: Text.ElideRight
        color: enabled ? m_skin.menuTextColor : m_skin.unenableTextColor
    }

    // 渐变下划线 - result设置界面使用
    Rectangle {
        x: 5; y: parent.height
        width: parent.width - 10; height: 2
        visible: showUnderLine

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(parent.width, 0)

            gradient: Gradient {
                GradientStop {  position: 0.0;    color: backgroundColor  }
                GradientStop {  position: 0.5;    color: m_skin.buttonPressColor }
                GradientStop {  position: 1.0;    color: backgroundColor  }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            focus = true

            if ( isPairCheckBox ) {
                selected()
                return
            }

            if ( unselectedAble ) {
                checked = !checked
            } else {
                if ( !checked ) {
                    checked = !checked
                }
            }
			selected()
        }
    }

}
