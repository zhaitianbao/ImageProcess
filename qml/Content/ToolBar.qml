import QtQuick 2.0
import "../Component"

// Background
Rectangle {
    id: root
    color: m_skin.toolBarBackground

    // ToolBar
    Row {
        id: row
        height: parent.height
        spacing: 2

        // Decorate
        Column {
            width: 15; height: parent.height/2
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Rectangle {
                width: 3; height: 3; radius: 3
                anchors.left: parent.left
                anchors.margins: 6
                color: "#2F2F2F"
            }

            Rectangle {
                width: 3; height: 3; radius: 3
                anchors.left: parent.left
                anchors.margins: 6
                color: "#2F2F2F"
            }

            Rectangle {
                width: 3; height: 3; radius: 3
                anchors.left: parent.left
                anchors.margins: 6
                color: "#2F2F2F"
            }

            Rectangle {
                width: 3; height: 3; radius: 3
                anchors.left: parent.left
                anchors.margins: 6
                color: "#2F2F2F"
            }
        }
    }
}
