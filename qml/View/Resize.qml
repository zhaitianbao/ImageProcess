import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.0
import ImageDisplay 1.0
import "../Component"
import "../Content"
import "qrc:/js/InitData.js" as JSInitData

// Background
Rectangle {
    id: root
    color: "#708090"

    property int itemWidth: 200
    property int itemHeight: 30
    property int space: 10
    property int pixelSize: 14
    property bool isopen:false
    property var filesavepath:""

    property var rx:1
    property var ry:1
    property var type: 1

    // Separator line - portrait
    Rectangle {
        width: lineWidth; height: parent.height - margin*50
        radius: lineWidth
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: m_skin.separatorLineColor
    }

    ImageDisplay {
        id: originalImg
        anchors.verticalCenter: parent.verticalCenter
        x:10
        width: parent.width/2-20;height: parent.height-300
        onWidthChanged: updateSize()
        onHeightChanged: updateSize()
    }

    ImageDisplay {
        id: resizeImg
        anchors.verticalCenter: parent.verticalCenter
        x:parent.width/2+10
        width:parent.width/2-20;height: parent.height-300
        onWidthChanged: updateSize()
        onHeightChanged: updateSize()

    }

    Connections{
        target: window
        onGetpic:{
            //console.log(window.filepath)
            var p=JSON.stringify(window.filepath)
            originalImg.updateImage(p)
            originalImg.updateSize()
        }
    }

    ZButton{
        id:resizebutton
        y:50
        anchors.horizontalCenter: parent.horizontalCenter
        pixelSize:25
        font_family: "楷体"
        width: 200;height: 50
        content: isChinese ? "尺寸调整" : "Resize"
        onSelected: {
            if(window.pictureNum!==0)
            {
                isopen=true
                var p=JSON.stringify(window.filepath)
                resizeImg.imageresize(p,rx,ry,type)
                resizeImg.updateSize()
            }
        }
    }

    // 参数区
    Column {
        id:resizeColumn
        y:space
        x:parent.width*2/3
        width: parent.width/4; height: space*10
        Row{
            spacing: space
            anchors.horizontalCenter: resizeColumn.horizontalCenter
            ZText {
                width: contentWidth; height: contentHeight
                pixelSize:root.pixelSize+5
                content: isChinese ? "尺寸参数" : "Size Parameters"
            }
        }
        Row{
            spacing: space
            anchors.horizontalCenter: resizeColumn.horizontalCenter
            ZSpinBox{
                id:resizex
                spinBoxPrefix:isChinese ?"横向":"H"
                width: root.itemWidth; height: root.itemHeight
                spinBoxValue: 0
                pixelSize: root.pixelSize
                minValue: 0; maxValue: 10
                spinBoxDecimals: 0
                spinBoxStepSize: 1
                onResultValueChanged: rx = resultValue
            }
        }
        Row{
            spacing: space
            anchors.horizontalCenter: resizeColumn.horizontalCenter
            ZSpinBox{
                id:resizey
                spinBoxPrefix:isChinese ? "纵向" : "V"
                width: root.itemWidth; height: root.itemHeight
                spinBoxValue: 0
                pixelSize: root.pixelSize
                minValue: 0; maxValue: 10
                spinBoxDecimals: 0
                spinBoxStepSize: 1
                onResultValueChanged: ry = resultValue
            }
        }
        Row{
            spacing: space
            anchors.horizontalCenter: resizeColumn.horizontalCenter
            ZCombobox{
                id:rtype
                width: root.itemWidth; height: root.itemHeight
                model: ["INTER_NEAREST", "INTER_LINEAR", "INTER_CUBIC", "INTER_AREA", "INTER_LANCZOS4"]
                font.pixelSize: root.pixelSize
                font.family: "微软雅黑"
                currentIndex: 0
                onCurrentIndexChanged: {
                    type = currentIndex
                    console.log(type)
                }
            }
        }
    }




    ZButton{
        id:exportbutton
        y:parent.height-100
        anchors.horizontalCenter: parent.horizontalCenter
        pixelSize:25
        font_family: "楷体"
        width: 200;height: 50
        content: isChinese ? "导出图片" : "Export picture"
        onSelected: {
            savePicture()
        }
    }

    function savePicture()
    {
        var file = globalFun.getSaveFileName(isChinese ? "保存图片" : "Save Picture",
                                             "D://"  + globalFun.getCurrentTime(5),
                                             "All Files (*.png *.bmp);;
                                              Image Files (*.png);; Image Files (*.bmp)")
        var isSaved=false
        if ( file !== "" ) {
            // 存储路径
            filesavepath = file.substring(0, file.lastIndexOf('/'))
            // 获取文件类型
            var fileType = file.substring(file.lastIndexOf('.') + 1, file.length)
            var fileName = file.substring(file.lastIndexOf('/') + 1,file.lastIndexOf('.'))

            // 保存文件
            switch ( fileType )
            {
            case "png": resizeImg.saveImage(filesavepath,fileName,fileType); isSaved=true;break;
            case "bmp": resizeImg.saveImage(filesavepath,fileName,fileType); isSaved=true;break;
            default: break;
            }
        }
        if(isSaved)
        {
           globalFun.showMessageBox(2, "图片已被保存。")
        }
    }
}

