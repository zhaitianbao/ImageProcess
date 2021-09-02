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
            ZButton {
                anchors.horizontalCenter: parent.horizontalCenter
                imageSource:  m_skin.isDark ?"qrc:/image/ModuleBar/resize.png":"qrc:/image/ModuleBar/resizeL.png"
                useInModuleBar: true
                content: isChinese ? "尺寸调整" : "resize"
                checked: currentIndex === 3
                onSelected: currentIndex = 3
            }
            ZButton {
                anchors.horizontalCenter: parent.horizontalCenter
                imageSource:  m_skin.isDark ?"qrc:/image/ModuleBar/splicing.png":"qrc:/image/ModuleBar/splicingL.png"
                useInModuleBar: true
                content: isChinese ? "图像拼接" : "splicing"
                checked: currentIndex === 4
                onSelected: currentIndex = 4
            }
            ZButton {
                anchors.horizontalCenter: parent.horizontalCenter
                imageSource:  m_skin.isDark ?"qrc:/image/ModuleBar/eclosion.png":"qrc:/image/ModuleBar/eclosionL.png"
                useInModuleBar: true
                content: isChinese ? "羽化" : "eclosion"
                checked: currentIndex === 5
                onSelected: currentIndex = 5
            }
            ZButton {
                anchors.horizontalCenter: parent.horizontalCenter
                imageSource:  m_skin.isDark ?"qrc:/image/ModuleBar/filter.png":"qrc:/image/ModuleBar/filterL.png"
                useInModuleBar: true
                content: isChinese ? "滤镜" : "filter"
                checked: currentIndex === 6
                onSelected: currentIndex = 6
            }
            ZButton {
                anchors.horizontalCenter: parent.horizontalCenter
                imageSource:  m_skin.isDark ?"qrc:/image/ModuleBar/comicStrip.png":"qrc:/image/ModuleBar/comicStripL.png"
                useInModuleBar: true
                content: isChinese ? "连环画" : "comicStrip"
                checked: currentIndex === 7
                onSelected: currentIndex = 7
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
