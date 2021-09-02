import QtQuick 2.12
import QtQuick.Controls 2.5
import "../Component"

// Background
Rectangle {
    id: root
    color: m_skin.background

    // Separator line - portrait
    Rectangle {
        width: lineWidth; height: parent.height - margin*2
        radius: lineWidth
        anchors.verticalCenter: parent.verticalCenter
        color: m_skin.separatorLineColor
    }

    // StackView
    StackView {
        id: stack
        x: lineWidth + margin; y: margin
        width: parent.width - lineWidth - margin*2; height: parent.height - margin*2
        focus: true

        // 默认面形界面
        Component.onCompleted: changeIndex(1)

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 100
            }
        }

        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 100
            }
        }

        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 100
            }
        }

        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 100
            }
        }
    }

    // 默认面形界面
    Component.onCompleted: changeIndex(1)

    function changeIndex(pageID) {

        switch ( pageID )
        {
        case 1: stack.push("../View/Sketch.qml"); break;
        case 2: stack.push("../View/Gray.qml"); break;
        case 3: stack.push("../View/Resize.qml"); break;
        case 4: stack.push("../View/Splicing.qml"); break;
        case 5: stack.push("../View/Eclosion.qml"); break;
        case 6: stack.push("../View/Filter.qml"); break;
        case 7: stack.push("../View/ComicStrip.qml"); break;
        }
        stack.currentItem.width = stack.width
        stack.currentItem.height = stack.height
    }
    function closePopUp() {
        stack.currentItem.closePopUp()
    }

}
