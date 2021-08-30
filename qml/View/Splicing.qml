import QtQuick 2.2
import QtQuick.Window 2.12
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
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
    property var filepath1:""
    property var filepath2:""
    property var filepath3:""
    property var filepath4:""
    property bool isone:false
    property bool istwo:false
    property bool isthree:false
    property bool isfour:false
    property int picnum:0
    property int space: 10


    // Separator line - portrait
    Rectangle {
        width: lineWidth; height: parent.height - margin*50
        radius: lineWidth
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: m_skin.separatorLineColor
    }

    Column{
        id:imgrcol
        y:150-itemHeight/2
        x:10
        width:parent.width/2-20;height: parent.height-300
        Row{
            id:imgrow1
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height/2
            width: parent.width
            ImageDisplay {
                id: originalImg1
                width: parent.width/2
                height: parent.height
                onWidthChanged: updateSize()
                onHeightChanged: updateSize()
            }
            ImageDisplay {
                id: originalImg2
                width: parent.width/2
                height: parent.height
                onWidthChanged: updateSize()
                onHeightChanged: updateSize()
            }
        }

        Row{
            id:imgrow2
            anchors.horizontalCenter: parent.horizontalCenter
            height: itemHeight
            width: parent.width
        }

        Row{
            id:imgrow3
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height/2
            width: parent.width
            ImageDisplay {
                id: originalImg3
                width: parent.width/2
                height: parent.height
                onWidthChanged: updateSize()
                onHeightChanged: updateSize()
            }
            ImageDisplay {
                id: originalImg4
                width: parent.width/2
                height: parent.height
                onWidthChanged: updateSize()
                onHeightChanged: updateSize()
            }
        }

    }

    Connections{
        target: window
        onGetpic:{
            console.log(window.filepath)
            var p=JSON.stringify(window.filepath)
            filepath1=p;
            originalImg1.updateImage(p)
            originalImg1.updateSize()
            picnum+=1
        }
    }


    ImageDisplay {
        id: splicingImg
        anchors.verticalCenter: parent.verticalCenter
        x:parent.width/2+10
        width:parent.width/2-20;height: parent.height-300
        onWidthChanged: updateSize()
        onHeightChanged: updateSize()
    }

    Row{
        id:buttonrow
        y:15
        x:10
        width: parent.width/2;height: 130
        spacing:space
        ZButton{
            id:loadbutton1
            anchors.verticalCenter: parent.verticalCenter
            pixelSize:20
            font_family: "楷体"
            width: parent.width/4-10;height: 50
            content: isChinese ? "加载第一张" : "Load first picture"
            onSelected: {
                isone=true
                istwo=false
                isthree=false
                isfour=false
                fileDialog_load.visible=true;
                picnum+=1
            }
        }

        ZButton{
            id:loadbutton2
            anchors.verticalCenter: parent.verticalCenter
            pixelSize:20
            font_family: "楷体"
            width: parent.width/4-10;height: 50
            content: isChinese ? "加载第二张" : "Load second picture"
            onSelected: {
                isone=false
                istwo=true
                isthree=false
                isfour=false
                fileDialog_load.visible=true;
                picnum+=1
            }
        }

        ZButton{
            id:loadbutton3
            anchors.verticalCenter: parent.verticalCenter
            pixelSize:20
            font_family: "楷体"
            width: parent.width/4-10;height: 50
            content: isChinese ? "加载第三张" : "Load third picture"
            onSelected: {
                isone=false
                istwo=false
                isthree=true
                isfour=false
                fileDialog_load.visible=true;
                picnum+=1
            }
        }

        ZButton{
            id:loadbutton4
            anchors.verticalCenter: parent.verticalCenter
            pixelSize:20
            font_family: "楷体"
            width: parent.width/4-10;height: 50
            content: isChinese ? "加载第四张" : "Load four picture"
            onSelected: {
                isone=false
                istwo=false
                isthree=false
                isfour=true
                fileDialog_load.visible=true;
                picnum+=1
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
            if(isone){
                filepath1=JSON.stringify(fileDialog_load.fileUrl);
                originalImg1.updateImage(filepath1)
                originalImg1.updateSize()
            }
            else if(istwo){
                filepath2=JSON.stringify(fileDialog_load.fileUrl)
                originalImg2.updateImage(filepath2)
                originalImg2.updateSize()
            }
            else if(isthree){
                filepath3=JSON.stringify(fileDialog_load.fileUrl);
                originalImg3.updateImage(filepath3)
                originalImg3.updateSize()
            }
            else if(isfour){
                filepath4=JSON.stringify(fileDialog_load.fileUrl);
                originalImg4.updateImage(filepath4)
                originalImg4.updateSize()
            }
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    ZButton{
        id:splicingbutton
        pixelSize:20
        font_family: "楷体"
        y:55
        x:parent.width*9/16
        width: parent.width/8; height: 50
        content: isChinese ? "图像拼接" : "Splicing"
        onSelected: {
            if(picnum!==0)
            {
                var type=0;
                if(rbutton1.checked)
                {
                    type=0;
                }
                else{
                    type=1;
                }
                isopen=true
                splicingImg.imagesplicing(filepath1,filepath2,filepath3,filepath4,type)
                splicingImg.updateSize()
            }
        }
    }

    Column{
        id:modelcol
        y:30
        x:parent.width*13/16
        width: parent.width/6; height: 100
        spacing: space
        ZText{
            id:modeltext
            anchors.left: parent.left;
            pixelSize: 20
            content: isChinese ? "模式:" : "Model:"
        }
        Row{
            id:modelrow1
            anchors.top: modeltext.bottom;
            anchors.topMargin: 10;
            anchors.left: parent.left;
            RadioButton{
                id:rbutton1
                checked: true
                style: RadioButtonStyle {
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 9
                        border.width: 1
                        Rectangle {
                            anchors.fill: parent
                            visible: control.checked
                            color: "#555"
                            radius: 9
                            anchors.margins: 4
                        }
                    }
                }
                onClicked: {
                    rbutton2.checked=!rbutton2.checked
                }
            }
            ZText{
                id:rbuttontext1
                y:-5
                pixelSize: 18
                anchors.left: parent.left;
                anchors.leftMargin: 50;
                content: isChinese ? "横向" : "Horizontal"
            }
        }
        Row{
            id:modelrow2
            anchors.top: modelrow1.bottom;
            anchors.topMargin: 30;
            anchors.left: parent.left;
            RadioButton{
                id:rbutton2
                checked: false
                style: RadioButtonStyle {
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 9
                        border.width: 1
                        Rectangle {
                            anchors.fill: parent
                            visible: control.checked
                            color: "#555"
                            radius: 9
                            anchors.margins: 4
                        }
                    }
                }
                onClicked: {
                    rbutton1.checked=!rbutton1.checked
                }
            }
            ZText{
                id:rbuttontext2
                y:-5
                pixelSize: 18
                anchors.left: parent.left;
                anchors.leftMargin: 50;
                content: isChinese ? "纵向" : "Vertical"
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
            case "png": splicingImg.saveImage(filesavepath,fileName,fileType); isSaved=true;break;
            case "bmp": splicingImg.saveImage(filesavepath,fileName,fileType); isSaved=true;break;
            default: break;
            }
        }
        if(isSaved)
        {
           globalFun.showMessageBox(2, "图片已被保存。")
        }
    }
}

