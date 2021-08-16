import QtQuick 2.12
import QtQuick.Controls 2.12

// 自定义下拉框
ComboBox {
    id: comboBox

    property int radius: 2
    property color backgroundColor: m_skin.comboBoxBackground
    property color fontColor: m_skin.menuTextColor
    property color hoverColor: m_skin.comboBoxHoverColor
    property color pressColor: m_skin.comboBoxPressColor
    property alias inputText: txt.text
    property alias comboboxText: txt

    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 40
        color: comboBox.backgroundColor
        border.color: txt.activeFocus ? m_skin.activeBorderColor : m_skin.defaultBorderColor
        border.width: comboBox.visualFocus ? 2 : 1
        radius: comboBox.radius
    }

    delegate: ItemDelegate {
        width: comboBox.width
        highlighted: comboBox.highlightedIndex === index

        background: Rectangle {
            color:  parent.highlighted ? comboBox.pressColor : comboBox.hoverColor
        }

        contentItem: Text {
            id: contentText
            anchors.centerIn: parent
            font: comboBox.font
            elide: Text.ElideRight
            leftPadding: comboBox.leftPadding
            color: comboBox.fontColor
            text: modelData
        }

        MouseArea{
            anchors.fill: parent
            enabled: comboBox.editable
            onClicked: {
                txt.text = contentText.text
                popup.close()
            }
        }
    }


    contentItem: Rectangle {
        anchors.fill:parent
        anchors.leftMargin: 5
        anchors.rightMargin: 36  // 3个indicator的宽
        color: "transparent"

        TextInput {
            id: txt
            anchors.fill: parent
            clip: true
            font: comboBox.font
            color: comboBox.fontColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
			leftPadding: comboBox.leftPadding
            text: comboBox.editable ? "" : comboBox.displayText
            enabled: comboBox.editable
        }
    }

    popup: Popup {
        y: comboBox.height - 1
        width: comboBox.width
        implicitHeight: contentItem.implicitHeight + 2
        padding: 1

        contentItem: ListView {
            implicitHeight: contentHeight
            boundsBehavior: Flickable.StopAtBounds
            currentIndex: comboBox.highlightedIndex
            model: comboBox.popup.visible ? comboBox.delegateModel : null
            ScrollIndicator.vertical: ScrollIndicator { }
            clip: true
        }

        background: Rectangle {
            border.color: m_skin.activeBorderColor
            radius: comboBox.radius
        }
    }
}
