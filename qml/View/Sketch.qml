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
        id: sketchImg
        anchors.verticalCenter: parent.verticalCenter
        x:parent.width/2+10
        width:parent.width/2-20;height: parent.height-300
        onWidthChanged: updateSize()
        onHeightChanged: updateSize()

    }

    Connections{
        target: window
        onGetpic:{
            console.log(window.filepath)
            var p=JSON.stringify(window.filepath)
            originalImg.updateImage(p)
            originalImg.updateSize()
        }
    }

    ZButton{
        id:sketchbutton
        y:50
        anchors.horizontalCenter: parent.horizontalCenter
        pixelSize:25
        font_family: "楷体"
        width: 200;height: 50
        content: isChinese ? "素描化" : "Sketching"
        onSelected: {
            if(window.getPicture)
            {
                isopen=true
                var p=JSON.stringify(window.filepath)
                sketchImg.imagesketch(p,10)
                sketchImg.updateSize()
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

    // 滑块
    Item {
        id: sketchContainer
        y:75
        x:parent.width*3/4-100
        width: parent.width/4; height: 20

        ZSlider{
            id:sketchslider
            width: parent.width; height: 15
            from: 1; to: 100
            onMoved: {
                if(isopen)
                {
                    var p=JSON.stringify(window.filepath)
                    sketchImg.imagesketch(p,sketchslider.value)
                }
            }

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
            case "png": sketchImg.saveImage(filesavepath,fileName,fileType); isSaved=true;break;
            case "bmp": sketchImg.saveImage(filesavepath,fileName,fileType); isSaved=true;break;
            default: break;
            }
        }
        if(isSaved)
        {
           globalFun.showMessageBox(2, "图片已被保存。")
        }
    }
}

