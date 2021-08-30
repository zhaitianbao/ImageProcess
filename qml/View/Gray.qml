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

    property bool isopen:false
    property var filesavepath:""
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
        id: grayImg
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
        id:graybutton
        y:50
        anchors.horizontalCenter: parent.horizontalCenter
        pixelSize:25
        font_family: "楷体"
        width: 200;height: 50
        content: isChinese ? "灰度化" : "Graying"
        onSelected: {
            if(window.pictureNum!==0)
            {
                isopen=true
                var p=JSON.stringify(window.filepath)
                grayImg.imagegray(p)
                grayImg.updateSize()
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
            case "png": grayImg.saveImage(filesavepath,fileName,fileType); isSaved=true;break;
            case "bmp": grayImg.saveImage(filesavepath,fileName,fileType); isSaved=true;break;
            default: break;
            }
        }
        if(isSaved)
        {
           globalFun.showMessageBox(2, "图片已被保存。")
        }
    }
}

