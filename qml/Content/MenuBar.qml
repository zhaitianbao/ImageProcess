import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.0

import "../Component"
import "qrc:/js/InitData.js" as JSInitData

// Background
Rectangle {
    id: root
    color: "transparent"

    property int menuType: 0
    property bool isPressed: false


    // MenuBar
    Rectangle {
        id: menuBar
        z: 3
        width: parent.width; height: 20
        color: m_skin.menuBarBackground

        Row {
            anchors.fill: parent

            // Menu File
            Rectangle {
                id: menu_file
                width: 40; height: 20
                color: (menu_file.hover || root.menuType == 1) ? m_skin.menuHoverColor : menuBar.color

                property bool hover: false

                Text {
                    width: parent.width; height: parent.height
                    font.family: "微软雅黑"
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: enabled ? m_skin.menuTextColor : m_skin.unenableTextColor
                    text: isChinese ? "文件" : "File"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        menu_file.hover = true
                        root.menuType = 1
                    }
                    onExited: {
                        menu_file.hover = false
                        root.menuType = root.isPressed ? 1 : 0
                    }
                    onPressed: {
                        root.isPressed = !root.isPressed
                        root.menuType = 1
                        menu_file.hover = false
                    }
                }
            }

            // Menu Language
            Rectangle {
                id: menu_language
                width: isChinese ? 40 : 80; height: 20
                color: (menu_language.hover || root.menuType == 2) ? m_skin.menuHoverColor : menuBar.color

                property bool hover: false

                Text {
                    width: parent.width; height: parent.height
                    font.family: "微软雅黑"
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: enabled ? m_skin.menuTextColor : m_skin.unenableTextColor
                    text: isChinese ? "语言" : "Language"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        menu_language.hover = true
                        root.menuType = 2
                    }
                    onExited: {
                        menu_language.hover = false
                        root.menuType = root.isPressed ? 2 : 0
                    }
                    onPressed: {
                        root.isPressed = !root.isPressed
                        root.menuType = 2
                        menu_language.hover = false
                    }
                }
            }

            // Menu Language
            Rectangle {
                id: menu_skin
                width: 40; height: 20
                color: (menu_skin.hover || root.menuType == 3) ? m_skin.menuHoverColor : menuBar.color

                property bool hover: false

                Text {
                    width: parent.width; height: parent.height
                    font.family: "微软雅黑"
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: enabled ? m_skin.menuTextColor : m_skin.unenableTextColor
                    text: isChinese ? "皮肤" : "Skin"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        menu_skin.hover = true
                        root.menuType = 3
                    }
                    onExited: {
                        menu_skin.hover = false
                        root.menuType = root.isPressed ? 3 : 0
                    }
                    onPressed: {
                        root.isPressed = !root.isPressed
                        root.menuType = 3
                        menu_skin.hover = false
                    }
                }
            }

            // Menu Help
            Rectangle {
                id: menu_help
                width: 40; height: 20
                color: (menu_help.hover || root.menuType == 4) ? m_skin.menuHoverColor : menuBar.color

                property bool hover: false

                Text {
                    width: parent.width; height: parent.height
                    font.family: "微软雅黑"
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: enabled ? m_skin.menuTextColor : m_skin.unenableTextColor
                    text: isChinese ? "帮助" : "Help"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        menu_help.hover = true
                        root.menuType = 4
                    }
                    onExited: {
                        menu_help.hover = false
                        root.menuType = root.isPressed ? 4 : 0
                    }
                    onPressed: {
                        root.isPressed = !root.isPressed
                        root.menuType = 4
                        menu_help.hover = false
                    }
                }
            }
        }
    }

    // Drop Down List
    Rectangle {
        id: dropDownList
        x: {
            if ( isChinese ) {
                return (root.menuType - 1) * 40
            } else {
                return root.menuType > 2 ? root.menuType * 40 : (root.menuType - 1) * 40
            }
        }
        y: 20; z: 3
        height: {
            switch ( root.menuType ) {
            case 1: 160; break;
            case 2: 80; break;
            case 3: 80; break;
            case 4: 80; break;
            default: break;
            }
        }
        color: m_skin.actionBackground
        visible: root.isPressed

        // Action File
        Column {
            anchors.fill: parent
            visible: root.menuType == 1

            ZAction {
                imageSource: "qrc:/image/MenuBar/Folder.png"
                content: isChinese ? "加载" : "Load"
                onSelected: acceptSelected(1)
            }

        }

        // Action Language
        Column {
            anchors.fill: parent
            visible: root.menuType == 2

            ZAction {
                imageSource: "qrc:/image/MenuBar/Chinese.png"
                content: isChinese ? "中文" : "Chinese"
                onSelected: acceptSelected(5)
            }

            ZAction {
                imageSource: "qrc:/image/MenuBar/English.png"
                content: isChinese ? "英文" : "English"
                onSelected: acceptSelected(6)
            }
        }

        // Action Skin
        Column {
            anchors.fill: parent
            visible: root.menuType == 3

            ZAction {
                imageSource: "qrc:/image/MenuBar/black.png"
                content: isChinese ? "黑色" : "Black"
                onSelected: acceptSelected(9)
            }

            ZAction {
                imageSource: "qrc:/image/MenuBar/gray.png"
                content: isChinese ? "灰色" : "Gray"
                onSelected: acceptSelected(10)
            }
        }


        // Action Help
        Column {
            anchors.fill: parent
            visible: root.menuType == 4

            ZAction {
                imageSource: "qrc:/image/MenuBar/Help.png"
                content: isChinese ? "帮助" : "Help"
                enabled: false
                onSelected: acceptSelected(7)
            }

            ZAction {
                imageSource: "qrc:/image/MenuBar/About.png"
                content: isChinese ? "关于我们" : "About us"
                onSelected: acceptSelected(8)
            }
        }
    }

    FileDialog{
        id: fileDialog_load
        title: "加载图片"
        folder: shortcuts.desktop
        nameFilters: ["Image files (*.jpg *.png)", "All files (*)"]
        visible: false
        onAccepted: {
            window.filepath = fileDialog_load.fileUrl
            window.pictureNum+=1
            console.log("You chose: " +  window.filepath)
        }
        onRejected: {
            console.log("Canceled")
        }
    }


    // Slot
    function acceptSelected(number)
    {
        root.menuType = 0
        root.isPressed = false
        menu_file.hover = false
        menu_language.hover = false
        menu_help.hover = false

        switch ( number )
        {
        case 1:
            // Load
            fileDialog_load.visible = true
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            // Chinese
            isChinese = true
            m_config.common_languageType = 1
            break;
        case 6:
            // English
            isChinese = false
            m_config.common_languageType = 2
            break;
        case 7:
            // Help
            break;
        case 8:
            // About us
            Qt.openUrlExternally("https://blog.csdn.net/zhaitianbao")
            break;
        case 9:
            m_skin = JSInitData.getSkin(1)
            break;
        case 10:
            m_skin = JSInitData.getSkin(2)
            break;
        default: break;
        }
    }
}
