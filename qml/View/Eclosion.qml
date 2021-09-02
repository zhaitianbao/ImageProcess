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

    property int itemWidth: 100
    property int itemHeight: 30
    property int pixelSize: 14
    property bool isopen:false
    property var filesavepath:""
    property int space: 10
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
        id: eclosionImg
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
        id:eclosionbutton
        y:50
        anchors.horizontalCenter: parent.horizontalCenter
        pixelSize:25
        font_family: "楷体"
        width: 200;height: 50
        content: isChinese ? "羽化" : "Eclosion"
        onSelected: {
            if(window.pictureNum!==0)
            {
                isopen=true
                var p=JSON.stringify(window.filepath)
                var fx=editx.inputText.text
                var fy=edity.inputText.text
                if(editx.inputText.text===""||edity.inputText.text==="")
                {
                    eclosionImg.imageeclosion(p,0,0,eclosionslider.value)
                }
                else{
                    eclosionImg.imageeclosion(p,fx,fy,eclosionslider.value)
                }
                eclosionImg.updateSize()
            }
        }
    }

    // 参数区1
    Column {
        id:eclosionColumn1
        y:space*2
        x:parent.width*2/3
        width: parent.width/4; height: space*10
        Row{
            spacing: space
            anchors.horizontalCenter: eclosionColumn1.horizontalCenter
            ZText {
                width: root.itemWidth; height: root.itemHeight
                pixelSize:root.pixelSize+5
                content: isChinese ? "羽化半径" : "Eclosion radius"
            }
        }
        Row{
            spacing: eclosionColumn1.width - 2* root.itemWidth
            ZText {
                width: root.itemWidth; height: root.itemHeight
                pixelSize: root.pixelSize
                content: isChinese ? "最小值: 0.1" : "Min: 0.1"
            }
            ZText {
                width: root.itemWidth; height: root.itemHeight
                pixelSize: root.pixelSize
                content: isChinese ? "最大值: 0.9" : "Max: 0.9"
            }
        }
        Row{
            spacing: space
            width: parent.width; height: 20
            // 滑块
            Item {
                id: eclosionContainer
                width: parent.width; height: 20
                ZSlider{
                    id:eclosionslider
                    width: parent.width; height: 15
                    from: 0.1; to: 0.9
                    stepSize:0.1
                    onMoved: {
                        if(isopen)
                        {
                            isopen=true
                            var p=JSON.stringify(window.filepath)
                            var fx=editx.inputText.text
                            var fy=edity.inputText.text
                            if(editx.inputText.text===""||edity.inputText.text==="")
                            {
                                eclosionImg.imageeclosion(p,0,0,eclosionslider.value)
                            }
                            else{
                                eclosionImg.imageeclosion(p,fx,fy,eclosionslider.value)
                            }
                            eclosionImg.updateSize()
                        }
                    }
                }
            }
        }
    }

    // 参数区2
    Column {
        id:eclosionColumn2
        y:space
        x:parent.width/12
        width: parent.width/4; height: space*10
        spacing: space
        Row{
            spacing: space
            anchors.horizontalCenter: eclosionColumn2.horizontalCenter
            ZText {
                width: root.itemWidth; height: root.itemHeight
                pixelSize:root.pixelSize+5
                content: isChinese ? "羽化中心" : "Eclosion center"
            }
        }
        Row{
            spacing: space
            anchors.horizontalCenter: eclosionColumn2.horizontalCenter
            ZTextEdit {
                id:editx
                width: 2.5*root.itemWidth; height: root.itemHeight
                prefixText:isChinese ? "X(横)：" : "X(Horizontal)："
                pixelSize: root.pixelSize
            }
        }
        Row{
            spacing: space
            anchors.horizontalCenter: eclosionColumn2.horizontalCenter
            ZTextEdit {
                id:edity
                width: 2.5*root.itemWidth; height: root.itemHeight
                prefixText:isChinese ? "Y(纵)：" : "Y(Vertical)："
                pixelSize: root.pixelSize
            }

        }

    }

    // 参数区3
    Column {
        id:eclosionColumn3
        y:parent.height-100
        x:parent.width/12
        width: parent.width/4; height: space*10
        spacing: space
        Row{
            spacing: space
            anchors.horizontalCenter: eclosionColumn3.horizontalCenter
            ZText {
                width: root.itemWidth; height: root.itemHeight
                pixelSize:root.pixelSize+5
                content: isChinese ? "图像尺寸" : "Picture size"
            }
        }
        Row{
            spacing: eclosionColumn3.width - 2* root.itemWidth
            ZText {
                width: root.itemWidth; height: root.itemHeight
                pixelSize:root.pixelSize+5
                content: isChinese ? ("宽："+originalImg.m_size.width) : ("Width："+originalImg.m_size.width)
            }
            ZText {
                width: root.itemWidth; height: root.itemHeight
                pixelSize:root.pixelSize+5
                content: isChinese ? ("高："+originalImg.m_size.height) : ("Height:"+originalImg.m_size.height)
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
            case "png": eclosionImg.saveImage(filesavepath,fileName,fileType); isSaved=true;break;
            case "bmp": eclosionImg.saveImage(filesavepath,fileName,fileType); isSaved=true;break;
            default: break;
            }
        }
        if(isSaved)
        {
           globalFun.showMessageBox(2, "图片已被保存。")
        }
    }
}

