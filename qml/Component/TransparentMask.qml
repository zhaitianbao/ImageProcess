import QtQuick 2.0

// 自定义透明遮罩，实现鼠标事件的穿透
Rectangle {
    id: transparentMask
    color: "transparent"

    property alias zValue: transparentMask.z
    property bool crossEnable: true

    signal close()

    MouseArea {
        anchors.fill: parent;
        propagateComposedEvents: true   // 允许事件穿透
        hoverEnabled: true
        acceptedButtons: Qt.AllButtons

        onClicked: {
            if ( crossEnable ) {
                mouse.accepted = false  // 不处理此事件，将其传递到下一层
                close()
            } else {
                close()
            }
        }

        onWheel: {}
    }
}
