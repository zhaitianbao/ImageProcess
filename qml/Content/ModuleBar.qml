import QtQuick 2.0
import "../Component"

// Background
Rectangle {
    id: root
    color: m_skin.background

    Rectangle {
        id: list
        y: 5
        width: parent.width - 10; height: list_column.height + 20
        anchors.horizontalCenter: parent.horizontalCenter
        color: m_skin.moduleBarBackground
        visible: true

        Column {
            id:list_column
            y: 10
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5

            ZButton {
                anchors.horizontalCenter: parent.horizontalCenter
                imageSource: m_skin.isDark ? "qrc:/image/ModuleBar/pen.png" : "qrc:/image/ModuleBar/penL.png"
                useInModuleBar: true
                content: isChinese ? "素描化" : "sketch"
                checked: currentIndex === 1
                onSelected: currentIndex = 1
            }
            ZButton {
                anchors.horizontalCenter: parent.horizontalCenter
                imageSource: "qrc:/image/ModuleBar/gray.png"
                useInModuleBar: true
                content: isChinese ? "灰度化" : "gray"
                checked: currentIndex === 2
                onSelected: currentIndex = 2
            }
        }
    }


    // Company Logo
    Image {
        width: parent.width - 10; height: width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        source: "qrc:/image/Setting/Camera.png"
        asynchronous: true
    }

}
