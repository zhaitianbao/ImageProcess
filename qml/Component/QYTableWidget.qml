import QtQuick 2.12
import QtQuick.Controls 2.5
import QYTableWidgetModel 1.0

// 自定义数据报表
Rectangle {
    id: tableWidget
    color: m_skin.moduleBarBackground

    property string fontFamily: "微软雅黑"
    property int pixelSize: 14
    property int currentSelectRow: -1

    property QYTableWidgetModel currentModel: staticModel ? dataTableModel : tableWidgetModel

    property var horizontalHeaderData: []           // 列头数据
    property var horizontalHeaderWidth: []          // 列宽
    property bool verticalHeaderVisible: false      // 是否显示行头
    property var verticalHeaderWidth: 25            // 行宽
    property var tableWidgetData: []                // 报表的数据
    property bool staticModel: false                // 使用全局 Model

    signal rightButtonPressed(var rx, var ry)

    onHorizontalHeaderDataChanged: {
        horizontalHeaderModel.clear()
        for ( var i = 0; i < horizontalHeaderData.length; ++i )
        {
            if ( i < horizontalHeaderWidth.length ) {
                var itemWidth = horizontalHeaderWidth[i]
            } else {
                itemWidth = 60
            }

            horizontalHeaderModel.append({typeName: horizontalHeaderData[i], itemWidth: itemWidth})
        }
        // 根据列头数据设置列数
        currentModel.setColumnCount(horizontalHeaderData.length)
    }

    // 鼠标事件
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onClicked: {
            if ( mouse.button === Qt.LeftButton ) {
                mouse.accepted = false
            } else if ( mouse.button === Qt.RightButton ) {
                rightButtonPressed(mouseX, mouseY)
            }
        }
    }

    // 行与列的交叉点
    Rectangle {
        id: intersect
        x: 0; y: 0
        width: verticalHeader.width; height: 30
        color: intersectArea.pressed ? m_skin.buttonPressColor : "transparent"
        visible: verticalHeader.visible

        MouseArea {
            id: intersectArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                currentModel.setIsSelect(0, 0, horizontalHeaderModel.count, verticalHeaderModel.count, true)
                currentSelectRow = -1
            }
        }
    }

    // 列头
    ListView {
        id: horizontalHeader
        x: intersect.visible ? intersect.width : 0
        width: intersect.visible ? parent.width - intersect.width : parent.width
        height: 30
        orientation: ListView.Horizontal
        contentX: tableView.contentX
        interactive: false
        clip: true

        model: ListModel { id: horizontalHeaderModel }

        delegate: Rectangle {
            width: itemWidth; height: 30
            color: horizontalItemArea.pressed ? m_skin.buttonPressColor :
                                                horizontalItemArea.containsMouse ? m_skin.buttonHoverColor : "transparent"

            Rectangle {
                anchors.fill: parent
                anchors.leftMargin: model.index === 0 ? 0 : -1
                color: parent.color
                visible: horizontalItemArea.containsMouse
            }

            Text {
                id: horizontalItemText
                anchors.fill: parent
                anchors.rightMargin: 5
                font.family: fontFamily
                font.pixelSize: pixelSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                color: m_skin.menuTextColor
                text: typeName
            }

            MouseArea {
                id: horizontalItemArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    currentModel.setIsSelect(index, 0, index + 1, verticalHeaderModel.count, true)
                    currentSelectRow = -1
                }
            }
        }
    }

    // 行头
    ListView {
        id: verticalHeader
        x: 0; y: 30
        width: verticalHeaderWidth; height: parent.height - 30
        orientation: ListView.Vertical
        interactive: false
        clip: true
        visible: verticalHeaderVisible && verticalHeaderModel.count > 0

        ScrollBar.vertical: vertical

        model: ListModel { id: verticalHeaderModel }

        delegate: Rectangle {
            width: verticalItemText.contentWidth + 4 > verticalHeaderWidth ? verticalItemText.contentWidth + 4 : verticalHeaderWidth
            height: 25
            color: verticalItemArea.pressed ? m_skin.buttonPressColor :
                                              verticalItemArea.containsMouse ? m_skin.buttonHoverColor : "transparent"

            Text {
                id: verticalItemText
                anchors.fill: parent
                font.family: fontFamily
                font.pixelSize: pixelSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: m_skin.menuTextColor
                text: number

                onTextChanged: {
                    if ( verticalItemText.contentWidth + 4 > verticalHeaderWidth ) {
                        verticalHeaderWidth = verticalItemText.contentWidth + 4
                    }
                }
            }

            MouseArea {
                id: verticalItemArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    currentModel.setIsSelect(0, index, horizontalHeaderModel.count, index + 1, true)
                    currentSelectRow = index
                }
            }
        }
    }

    // TableView
    TableView {
        id: tableView
        width: horizontalHeader.width; height: parent.height - horizontalHeader.height
        anchors.top: horizontalHeader.bottom
        anchors.left: horizontalHeader.left
        columnWidthProvider: function (column) { return horizontalHeaderModel.get(column).itemWidth }
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        clip: true

        ScrollBar.horizontal: ScrollBar {
            id: horizontal
            policy: tableView.contentWidth > tableView.width ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        }

        ScrollBar.vertical: ScrollBar {
            id: vertical
            policy: tableView.contentHeight > tableView.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        }

        model: currentModel

        delegate: Rectangle {
            implicitWidth: horizontalHeaderModel.get(model.column).itemWidth
            implicitHeight: 25
            color: "transparent"

            // 选中时背景颜色, 后面的上下左右矩形会把这线条位置覆盖，所以不用设置大小
            Rectangle {
                anchors.fill: parent
                color: isSelect ? m_skin.tableWidgetItemPressColor : "transparent"
            }

            // 文本显示
            Text {
                anchors.centerIn: parent
                width: parent.width - 2; height: parent.height
                font.family: fontFamily
                font.pixelSize: pixelSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                color: m_skin.menuTextColor
                text: visible ? value : ""
                visible: isText && !editable
            }

            // 文本编辑
            TextInput {
                anchors.fill: parent
                font.family: fontFamily
                font.pixelSize: pixelSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: m_skin.menuTextColor
                text: visible ? value : ""
                visible: isText && editable

                onEditingFinished: {
                    model.value = text
                }
            }

            // 图片
            Image {
                anchors.fill: parent
                anchors.margins: 2
                fillMode: Image.PreserveAspectFit
                source: visible ? value : ""
                clip: true
                visible: !isText
            }

            // 上
            Rectangle {
                anchors.top: parent.top
                width: parent.width; height: model.row === 0 ? 2 : 1
                color: m_skin.tableWidgetSeparatorLineColor
            }

            // 下
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width;
                height: model.row === tableView.rows - 1 ? 2 : 1
                color: m_skin.tableWidgetSeparatorLineColor
            }

            // 左
            Rectangle {
                anchors.left: parent.left
                width: model.column === 0 ? 2 : 1
                height: parent.height
                color: m_skin.tableWidgetSeparatorLineColor
            }

            // 右
            Rectangle {
                anchors.right: parent.right
                width: model.column === tableView.columns - 1 ? 2 : 1
                height: parent.height
                color: m_skin.tableWidgetSeparatorLineColor
            }

            MouseArea {
                id: item
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    currentModel.setIsSelect(model.column, model.row, model.column + 1, model.row + 1, true)
                    currentSelectRow = model.row
                }
            }

        }
    }

    // TableView model
    QYTableWidgetModel { id: tableWidgetModel }

    // 初始化报表数据
    function initTableData() {
        // 清空报表数据
        currentModel.clear()

        // 添加报表数据
        for ( var i = 0; i < tableWidgetData.length; ++i )
        {
            currentModel.push_backRow(tableWidgetData[i])
        }

        // 清空行数据
        verticalHeaderModel.clear()

        // 添加行数据
        var row = currentModel.totalCount() / currentModel.columnCount()
        for ( var j = 0; j < row; ++j )
        {
            verticalHeaderModel.append({ "number": j+1 })
        }
    }

	// 删除选中行
	function removeRow(row) {
        currentModel.removeRow(row)
        currentSelectRow = -1
    }

    // 更新行数据
    function updateRows(row) {
        if ( row > verticalHeaderModel.count ) {
            for ( var i = verticalHeaderModel.count; i < row; ++i )
            {
                verticalHeaderModel.append({ "number": i+1 })
            }
        }

        if ( row < verticalHeaderModel.count ) {
            verticalHeaderModel.remove(row, verticalHeaderModel.count - row)
        }
    }

    // 获取某一列数据
    function getColumnData(column) {
        return currentModel.getColumnData(column)
    }

    // 更新报表中某一列数据
    function updateColumnData(list, col, state) {
        currentModel.updateColumnData(list, col, state)
    }

    // 获取和行数相等的数据
    function getRowNullData() {
        var array = []
        for ( var i = 0; i < currentModel.rowCount(); ++i )
        {
            array.push(i)
        }
        return array
    }

    // 导出CSV
    function exportCSV() {
        var path = m_config.file_exportCSVPath === "" ? globalFun.isDirExist("D:/") ? "D:/" : "C:/" : m_config.file_exportCSVPath

        var file = globalFun.getSaveFileName(isChinese ? "导出CSV" : "Export CSV",
                                             path + "/" + globalFun.getCurrentTime(5) + ".csv",
                                             "CSV Files (*.csv)")

        if ( file !== "" ) {
            // 存储路径
            m_config.file_exportCSVPath = file.substring(0, file.lastIndexOf('/'))

            // 导出CSV
            currentModel.exportCSV(file, horizontalHeaderData)
        }
    }
}
