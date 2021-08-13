import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls 1.4
import QYGraphView 1.0

// 自定义绘图控件，可实时刷新图像，并绘制掩膜
Rectangle {
    id: root
    z: (viewPopup.visible || itemPopUp.visible) ? 2 : 0
    color: "transparent"

    property bool isHandMode: true                      // 测量模式
    property bool polygonCreating: false                // 是否正在创建多边形
    property real drawMaskHeight: grid.height + 20      // 图形选择器的高度
    property real actualWidth: qyGraphView.width * qyGraphView.scale
    property real actualHeight: qyGraphView.height * qyGraphView.scale

    property string pv: ""
    property string rms: ""
    property string unit: ""

    signal measurementFinished(var error)

    // 绘制掩膜区域
    Rectangle {
        id: background
        width: root.width; height: root.height - drawMask.height - lineWidth - window.margin*2
        anchors.top: parent.top
        anchors.left: parent.left
        color: m_skin.moduleBarBackground
        clip: !viewPopup.visible && !itemPopUp.visible

        Flickable {
            id: flickable
            anchors.fill: parent
            contentX: (contentWidth - background.width) / 2
            contentY: (contentHeight - background.height) / 2
            contentWidth: actualWidth > background.width ? actualWidth : background.width
            contentHeight: actualHeight > background.height ? actualHeight : background.height
            interactive: false
            clip: true

            ScrollBar.vertical: ScrollBar { policy: actualHeight > root.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff }
            ScrollBar.horizontal: ScrollBar { policy: actualWidth > root.width ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff }

            QYGraphView {
                id: qyGraphView
                width: background.width * 0.95; height: background.height * 0.95
                anchors.centerIn: parent
                isLocked: false                                 // 默认不锁定
                isActual: true                                  // 默认实时模式
                isShowMask: true                                // 默认显示掩膜
                isHandMode: root.isHandMode                     // 手动自动模式
                isWorking: false                                // 默认相机不工作
                m_ratio: 1                                      // 默认比例是1
                m_pixel: m_config.camera_pixel_calibration      // 像素标定值
                m_level: 1                                      // 默认像素等级是1
                focus: true                                     // 获取焦点
                enabled: !showTransparentMask                   // 弹窗显示时不可用

                // 切换模式
                onModeChanged: root.isHandMode = isHandMode

                // 宽度改变
                onWidthChanged: updateMaskAndItem()

                // 高度改变
                onHeightChanged: updateMaskAndItem()

                // 键盘事件: ctrl + 放大视图，ctrl - 缩小视图，ctrl 0 还原默认大小
                Keys.onPressed: {
                    if ( viewPopup.visible || itemPopUp.visible ) {
                        return
                    }

                    if ( event.modifiers === Qt.ControlModifier && event.key === Qt.Key_Minus )
                    {
                        if ( qyGraphView.scale > 0.1 ) {
                            qyGraphView.scale -= 0.05
                        }
                        event.accepted = true
                    }

                    if ( event.modifiers === Qt.ControlModifier && event.key === Qt.Key_Equal )
                    {
                        if ( qyGraphView.scale < 5 ) {
                            qyGraphView.scale += 0.05
                        }
                        event.accepted = true
                    }

                    if ( event.modifiers === Qt.ControlModifier && event.key === Qt.Key_0 )
                    {
                        qyGraphView.scale = 1
                        event.accepted = true
                    }
                }

                // 保存图形到JSON文件
                onSaveItemToJSON: {
                    var file = globalFun.getSaveFileName("Save path", globalFun.getCurrentPath() + "/" +
                                                         globalFun.getCurrentTime(5) + ".json", "JSON Files (*.json)")
                    if ( file !== "" ) {
                        globalFun.write(file, str)
                    }
                }

                // 视图右键弹窗
                onDropViewPopup: {
                    /*
                     * width，height 为视图的宽度和高度，是固定尺寸，值为背景宽高 * 0.95
                     * actualWidth，actualHeight 为视图的实际尺寸，值为宽高 * 缩放比例
                     * contentWidth，contentHeight 为视图的内容尺寸，当内容超过 width，height 就会显示滚动条
                     * contentX，contentY 为开始显示内容的位置，为了居中显示，则值为 （内容尺寸 - 固定窗口）/2
                     */

//                    console.log("background.width: " + background.width + ", background.height: " + background.height)
//                    console.log("qyGraphView.width: " + qyGraphView.width + ", qyGraphView.height: " + qyGraphView.height)
//                    console.log("actualWidth: " + actualWidth + ", actualHeight: " + actualHeight)
//                    console.log("contentWidth: " + flickable.contentWidth + ", contentHeight: " + flickable.contentHeight)
//                    console.log("contentX: " + flickable.contentX + ", contentY: " + flickable.contentY)

                    // 视图居于正中心时的 contentX 和 contentY
                    var dx = (flickable.contentWidth - background.width) / 2 - flickable.contentX
                    var dy = (flickable.contentHeight - background.height) / 2 - flickable.contentY
//                    console.log("dx: " + dx + ", dy: " + dy)
//                    console.log("-----------------------------\n")

                    // 坐标根据视图缩放，再转换到实际窗口
                    viewPopup.x = x * qyGraphView.scale + (background.width - actualWidth)/2 + dx
                    viewPopup.y = y * qyGraphView.scale + (background.height - actualHeight)/2 + dy

                    isLockRadioBtn.checked = qyGraphView.isLocked
                    isLiveRadioBtn.checked = qyGraphView.isActual
                    isShowMaskRadioBtn.checked = qyGraphView.isShowMask

                    viewPopup.visible = true
                    itemPopUp.visible = false
                    showTransparentMask = true
                }

                // 图形右键弹窗
                onDropItemPopup: {
                    // 视图居于正中心时的 contentX 和 contentY
                    var dx = (flickable.contentWidth - background.width) / 2 - flickable.contentX
                    var dy = (flickable.contentHeight - background.height) / 2 - flickable.contentY

                    // 坐标根据视图缩放，再转换到实际窗口
                    itemPopUp.x = x * qyGraphView.scale + (background.width - actualWidth)/2 + dx
                    itemPopUp.y = y * qyGraphView.scale + (background.height - actualHeight)/2 + dy

                    itemPopUp.itemType = qyGraphView.getItemProperty(1)
                    itemPopUp.createState = qyGraphView.getItemProperty(11) === 1
                    itemPopUp.getItemProperty()

                    itemPopUp.visible = true
                    showTransparentMask = true
                }

                // 绑定相机，实时刷新图像
                Connections {
                    target: cameraCtl
                    onCallQmlRefeshImg: {
                        if ( qyGraphView.isActual ) {
                            // 更新图像
                            qyGraphView.updateImage(image)

                            // 更新图像的比例和XY
                            qyGraphView.updateRadioAndImageXY()
                        }

                        if ( !qyGraphView.isWorking ) {
                            // 相机正在工作中
                            qyGraphView.isWorking = true

                            // 如果是面形界面，则自动加载掩膜
                            if ( currentIndex == 1 ) {
                                loadMask()
                            }
                        }
                    }
                }

                // 绑定开始测量、开始计算
                Connections {
                    target: window
                    onStartMeasure: {
                        // 日志记录
                        console.log("startMeasurement !")
                        logCtl.write(globalFun.getCurrentTime(6) + " - Start measurement");

                        // 判断是否在计算中
                        if ( is_in_calculation ) {
                            return
                        }

                        // 检测掩膜
                        if ( qyGraphView.getItemCount() === 0 ) {
                            globalFun.showMessageBox(3, "Please draw the mask first !")
                            return
                        }

                        // 检测相机是否正常
                        if ( !cameraCtl.isAvailable() ) {
                            globalFun.showMessageBox(3, "The camera is not working !")
                            return
                        }

                        // 检测移项器是否正常
                        if ( !daCardCtl.isAvailable() ) {
                            globalFun.showMessageBox(3, "The phase shifter is not connected !")
                            return
                        }

                        // 正在测量中
                        is_in_calculation = true

                        // 清空图像列表
                        algorithmCtl.clearMatList()

                        // 日志记录
                        logCtl.write(globalFun.getCurrentTime(6) + " - Start phase shift");

                        // DA卡开始增压取图
                        daCardCtl.startPhaseShifting()
                    }

                    onStartAnalysis: {
                        console.log("startAnalysis !")
                        logCtl.write(globalFun.getCurrentTime(6) + " - Start analysis");

                        // 判断是否在计算中
                        if ( is_in_calculation ) {
                            return
                        }

                        // 检测掩膜（分析ASC或者XYZ文件可以不画掩膜）
                        if ( qyGraphView.getItemCount() === 0 && !is_load_ASCOrXYZ ) {
                            globalFun.showMessageBox(3, "Please draw the mask first !")
                            return
                        }

                        // 检测图像
                        if ( !algorithmCtl.getActualState() ) {
                            globalFun.showMessageBox(3, "There are no images to analyze !")
                            return
                        }

                        // 判断图像大小与掩膜大小是否一致
                        if ( !qyGraphView.judMaskSize() ) {
                            globalFun.showMessageBox(3, "The image is not consistent with the mask size !")
                            return
                        }

                        // 调用算法计算
                        calWithAlgorithm(0)
                    }

                    onStartRetest: {
                        console.log("startRetest - " + (remainingTestTimes - 1) + " !")
                        logCtl.write("\n" + globalFun.getCurrentTime(6) + " - Start retest - " + (remainingTestTimes - 1) + " !");

                        // 清空图像列表
                        algorithmCtl.clearMatList()

                        // 日志记录
                        logCtl.write(globalFun.getCurrentTime(6) + " - Start phase shift");

                        // DA卡开始增压取图
                        daCardCtl.startPhaseShifting()
                    }

                    onPixelChanged: {
                        // 更新视图像素值，并且更新视图中所有图形的像素值
                        qyGraphView.m_pixel = m_config.camera_pixel_calibration
                        qyGraphView.updateItemPixelFromNewPixelOrRatio()
                    }
                }

                // 绑定移项器，获取开始调用算法信号，调用前根据图形修改配置参数
                Connections {
                    target: daCardCtl

                    // 全部加压完成，开始使用算法计算
                    onCallQmlAcquisitionComplete: {
                        // 日志记录
                        logCtl.write(globalFun.getCurrentTime(6) + " - Phase shift finished");

                        // 不使用相位图分析
                        is_load_ASCOrXYZ = false

                        // 如果是非实时模式，则刷新图片
                        if ( !qyGraphView.isActual ) {
                            algorithmCtl.sendImageToGraph()
                        }

                        // 调用算法计算
                        calWithAlgorithm(0)
                    }
                }

                // 绑定算法，获取计算完成信号绘制掩膜，传递算法中的图像列表到视图
                Connections {
                    target: algorithmCtl

                    onCallQmlCalFinish: {
                        // 日志记录
                        logCtl.write(globalFun.getCurrentTime(6) + " - Algorithm calculation finished");

                        if ( is_load_ASCOrXYZ ) {
                            // 分析 ASC 或者 XYZ 文件时，掩膜为手动掩膜和文件中的掩膜的交集
                            qyGraphView.drawHandMask(true, m_fillMask)
                        } else {
                            if ( root.isHandMode ) {
                                // 绘制手动掩膜
                                qyGraphView.drawHandMask(false, m_fillMask)
                            } else {
                                // 绘制自动掩膜，需要根据算法计算的结果绘制
                                qyGraphView.drawAutoMask(m_fillMask, m_edgeMask, errorType === 0)
                            }
                        }

                        // 更新掩膜的大小
                        qyGraphView.updateMask()

                        // 更新界面上的 pv rms
                        root.pv = algorithmCtl.getSingleData(1, m_config.common_decimal)
                        root.rms = algorithmCtl.getSingleData(2, m_config.common_decimal)

                        // 日志记录
                        logCtl.write(globalFun.getCurrentTime(6) + " - Update mask finished");

                        // 向上一层发送测量结束信号
                        measurementFinished(errorType)
                    }

                    onCallQmlSendImageList: {
                        // 把算法中保存的图像列表传递到视图中显示（非实时模式）
                        qyGraphView.reciveImageList(list)
                    }

                    onCallQmlLoadPicFinished: {
                        // 不使用相位图分析
                        is_load_ASCOrXYZ = false

                        // 切换到非实时模式
                        algorithmCtl.sendImageToGraph()

                        // 更新所有图形
                        qyGraphView.updateItemPixelFromNewPixelOrRatio()

                        // 调用算法计算
                        calWithAlgorithm(0)
                    }

                    onCallQmlLoadSiriusFinished: {
                        // 不使用相位图分析
                        is_load_ASCOrXYZ = false

                        // 切换到非实时模式
                        algorithmCtl.sendImageToGraph()

                        // 更新所有图形
                        qyGraphView.updateItemPixelFromNewPixelOrRatio()

                        // 调用算法计算
                        calWithAlgorithm(pixel)
                    }

                    onCallQmlLoadASCOrXYZFinished: {
                        // 使用相位图分析
                        is_load_ASCOrXYZ = true

                        // 切换到非实时模式
                        algorithmCtl.sendImageToGraph()

                        // 更新所有图形
                        qyGraphView.updateItemPixelFromNewPixelOrRatio()

                        // 调用算法计算
                        calWithAlgorithm(pixel)
                    }
                }

                // 更新掩膜和图形
                function updateMaskAndItem() {
                    // 如果相机不在工作中，并且是实时模式，需要初始化图像
                    if ( qyGraphView.isActual && !qyGraphView.isWorking ) {
                        initImage()
                    }

                    // 更新图像的比例和XY
                    qyGraphView.updateRadioAndImageXY()

                    // 更新掩膜的大小
                    qyGraphView.updateMask()

                    // 更新所有图形
                    qyGraphView.updateItemPixelFromDataPacket()
                }
            }

            // 创建多边形时的遮罩
            Rectangle {
                id: mask
                z: 1
                anchors.fill: qyGraphView
                color: "transparent"
                visible: polygonCreating
                enabled: polygonCreating

                property int count: 0   // 多边形顶点个数

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.AllButtons
                    onClicked: {
                        if ( mouse.button === Qt.LeftButton )
                        {
                            // 鼠标左键添加多边形顶点
                            mask.count++
                            qyGraphView.addPoint(mouseX, mouseY, true)
                        }

                        else if ( mouse.button === Qt.RightButton )
                        {
                            if ( mask.count >= 3 ) {
                                // 鼠标右键完成所有顶点的收集（多边形需要至少3个顶点）
                                qyGraphView.addPoint(0, 0, false)
                                mask.count = 0
                                polygonCreating = false
                            }
                        }
                    }
                }
            }

        }

        // PV
        Row {
            x: 5; y: 5
            spacing: 10

            QYText {
                width: 72
                fontBold: true
                pixelSize: 26
                useThemeColor: false
                content: "PV : "
            }

            QYText {
                fontBold: true
                pixelSize: 26
                useThemeColor: false
                content: root.pv + " " + root.unit
            }
        }

        // RMS
        Row {
            x: 5; y: 35
            spacing: 10

            QYText {
                width: 72
                fontBold: true
                pixelSize: 26
                useThemeColor: false
                content: "RMS : "
            }

            QYText {
                fontBold: true
                pixelSize: 26
                useThemeColor: false
                content: root.rms + " " + root.unit
            }
        }
    }

    // Separator line - landscape
    Rectangle {
        width: root.width; height: lineWidth
        radius: lineWidth
        anchors.bottom: drawMask.top
        anchors.left: drawMask.left
        anchors.bottomMargin: margin
        color: m_skin.separatorLineColor
    }

    // Draw mask
    Rectangle {
        id: drawMask
        width: root.width; height: root.drawMaskHeight
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: m_skin.moduleBarBackground

        property var buttonWidth: (root.width - margin*7) / 6

        Grid {
            id: grid
            anchors.centerIn: parent
            rows: 2
            columns: 6
            rowSpacing: margin
            columnSpacing: drawMask.buttonWidth > 116 ? (root.width - 700) / 8 : (root.width - drawMask.buttonWidth*6) / 8

            // The first line
            QYButton {
                width: drawMask.buttonWidth > 100 ? 100 : drawMask.buttonWidth
                imageSource: m_skin.isDark ? "qrc:/image/Mask/CircleL.png" : "qrc:/image/Mask/Circle.png"
                content: isChinese ? "圆" : "Circle"
                pixelSize: 14
                enabled: root.isHandMode && !root.polygonCreating
                onSelected: qyGraphView.createGraphItem(1, m_config.common_maskSize)
            }

            QYButton {
                width: drawMask.buttonWidth > 120 ? 120 : drawMask.buttonWidth
                imageSource: m_skin.isDark ? "qrc:/image/Mask/Con_circleL.png" : "qrc:/image/Mask/Con_circle.png"
                content: isChinese ? "同心圆" : "Con_circle"
                pixelSize: isChinese ? 14 : width > 100 ? 14 : 10
                enabled: root.isHandMode && !root.polygonCreating
                onSelected: qyGraphView.createGraphItem(3, m_config.common_maskSize)
            }

            QYButton {
                width: drawMask.buttonWidth > 120 ? 120 : drawMask.buttonWidth
                imageSource: m_skin.isDark ? "qrc:/image/Mask/RectangleL.png" : "qrc:/image/Mask/Rectangle.png"
                content: isChinese ? "矩形" : "Rectangle"
                pixelSize: isChinese ? 14 : width > 100 ? 14 : 10
                enabled: root.isHandMode && !root.polygonCreating
                onSelected: qyGraphView.createGraphItem(4, m_config.common_maskSize)
            }

            QYButton {
                width: drawMask.buttonWidth > 110 ? 110 : drawMask.buttonWidth
                imageSource: m_skin.isDark ? "qrc:/image/Mask/PillL.png" : "qrc:/image/Mask/Pill.png"
                content: isChinese ? "圆端矩形" : "Pill"
                pixelSize: isChinese ? width > 100 ? 14 : 10 : 14
                enabled: root.isHandMode && !root.polygonCreating
                onSelected: qyGraphView.createGraphItem(7, m_config.common_maskSize)
            }

            QYButton {
                width: drawMask.buttonWidth > 100 ? 100 : drawMask.buttonWidth
                imageSource: m_skin.isDark ? "qrc:/image/Mask/LoadL.png" : "qrc:/image/Mask/Load.png"
                content: isChinese ? "加载" : "Load"
                pixelSize: 14
                enabled: root.isHandMode && !root.polygonCreating
                onSelected: {
                    var file = globalFun.getOpenFileName("Load path", globalFun.getCurrentPath(), "JSON Files (*.json)")
                    if ( file !== "" ) {
                        var str = globalFun.read(file)
                        qyGraphView.loadGraphItem(str)
                    }
                }
            }

            QYButton {
                width: drawMask.buttonWidth > 100 ? 100 : drawMask.buttonWidth
                imageSource: m_skin.isDark ? "qrc:/image/Mask/SaveMaskL.png" : "qrc:/image/Mask/SaveMask.png"
                content: isChinese ? "保存" : "Save"
                pixelSize: 14
                enabled: root.isHandMode && !root.polygonCreating
                onSelected: {
                    if ( qyGraphView.getItemCount() > 0 ) {
                        qyGraphView.saveGraphItem()
                    } else {
                        globalFun.showMessageBox(2, "There is no mask to save !")
                    }
                }
            }

            // The second line
            QYButton {
                width: drawMask.buttonWidth > 100 ? 100 : drawMask.buttonWidth
                imageSource: m_skin.isDark ? "qrc:/image/Mask/EllipseL.png" : "qrc:/image/Mask/Ellipse.png"
                content: isChinese ? "椭圆" : "Ellipse"
                pixelSize: 14
                enabled: root.isHandMode && !root.polygonCreating
                onSelected: qyGraphView.createGraphItem(2, m_config.common_maskSize)
            }

            QYButton {
                width: drawMask.buttonWidth > 120 ? 120 : drawMask.buttonWidth
                imageSource: m_skin.isDark ? "qrc:/image/Mask/PolygonL.png" : "qrc:/image/Mask/Polygon.png"
                content: isChinese ? "多边形" : "Polygon"
                pixelSize: isChinese ? 14 : width > 100 ? 14 : 10
                enabled: root.isHandMode && !root.polygonCreating
                onSelected: {
                    qyGraphView.createGraphItem(6, m_config.common_maskSize)
                    polygonCreating = true
                }
            }

            QYButton {
                width: drawMask.buttonWidth > 120 ? 120 : drawMask.buttonWidth
                imageSource: m_skin.isDark ? "qrc:/image/Mask/SquareL.png" : "qrc:/image/Mask/Square.png"
                content: isChinese ? "正方形" : "Square"
                pixelSize: isChinese ? 14 : width > 100 ? 14 : 10
                enabled: root.isHandMode && !root.polygonCreating
                onSelected: qyGraphView.createGraphItem(5, m_config.common_maskSize)
            }

            QYButton {
                width: drawMask.buttonWidth > 110 ? 110 : drawMask.buttonWidth
                imageSource: m_skin.isDark ? "qrc:/image/Mask/ChamferL.png" : "qrc:/image/Mask/Chamfer.png"
                content: isChinese ? "圆角矩形" : "Chamfer"
                pixelSize: width > 100 ? 14 : 10
                enabled: root.isHandMode && !root.polygonCreating
                onSelected: qyGraphView.createGraphItem(8, m_config.common_maskSize)
            }

            QYButton {
                width: drawMask.buttonWidth > 100 ? 100 : drawMask.buttonWidth
                imageSource: m_skin.isDark ? "qrc:/image/Mask/ClearL.png" : "qrc:/image/Mask/Clear.png"
                content: isChinese ? "清空" : "Clear"
                pixelSize: 14
                enabled: root.isHandMode && !root.polygonCreating
                onSelected: qyGraphView.clearGraphItem()
            }

            QYButton {
                width: drawMask.buttonWidth + 10 > 150 ? 150 : drawMask.buttonWidth + 10
                imageSource: m_skin.isDark ? ( isHandMode ? "qrc:/image/Mask/Hand_modeL.png" : "qrc:/image/Mask/AutoModeL.png") :
                                          ( isHandMode ? "qrc:/image/Mask/Hand_mode.png" : "qrc:/image/Mask/AutoMode.png" )
                content: isChinese ? ( isHandMode ? "切换至自动模式" : "切换至手动模式") :
                                    ( isHandMode ? "To Auto Mode" : "To Hand Mode" )
                pixelSize: width >= 150 ? 14 : width > 130 ? 12 : 10
                enabled: !root.polygonCreating
                onSelected: {
                    qyGraphView.changeMode(isHandMode)

                    if ( root.isHandMode ) {
                        root.isHandMode = false
                        m_config.common_measureType = 2
                        qyGraphView.createGraphItem(9, m_config.common_maskSize)
                    } else {
                        root.isHandMode = true
                        m_config.common_measureType = 1
                    }
                }
            }

        }

        // 当视图弹窗或者图形弹窗显示时，遮挡掩膜绘制区域
        TransparentMask {
            z: 1
            anchors.fill: parent
            crossEnable: false
            visible: showTransparentMask
            onClose: closePopUp()
        }
    }

    // View pop up
    Rectangle {
        id: viewPopup
        z: 2
        width: viewColumn.width; height: viewColumn.height
        color: m_skin.actionBackground
        visible: false

        Column {
            id: viewColumn
            spacing: 2

            QYRadioButton {
                id: isLockRadioBtn
                content: isChinese ? "锁定" : "Lock"
                backgroundColor: m_skin.actionBackground
                hoverColor: m_skin.actionHoverColor
                onSelected: {
                    qyGraphView.isLocked = checked
                    viewPopup.visible = false
                    showTransparentMask = false
                }
            }

            QYRadioButton {
                id: isLiveRadioBtn
                content: isChinese ? "实时模式" : "Live"
                backgroundColor: m_skin.actionBackground
                hoverColor: m_skin.actionHoverColor
                enabled: !qyGraphView.isLocked
                onSelected: {
                    viewPopup.visible = false
                    showTransparentMask = false

                    if ( checked ) {
                        // 切换到实时模式，掩膜和图像都不变
                        qyGraphView.isActual = checked

                        // 未连接相机时，显示默认黑色背景
                        if ( !qyGraphView.isWorking ) {
                            qyGraphView.initImage()
                        }
                    } else {
                        // 切换到非实时模式，掩膜和图像都不变
                        if ( algorithmCtl.getActualState() ) {
                            algorithmCtl.sendImageToGraph()
                        } else {
                            globalFun.showMessageBox(3, "No pictures to show !")
                        }
                    }
                }
            }

            QYRadioButton {
                id: isShowMaskRadioBtn
                content: isChinese ? "显示掩膜" : "Mask"
                backgroundColor: m_skin.actionBackground
                hoverColor: m_skin.actionHoverColor
                enabled: !qyGraphView.isLocked
                onSelected: {
                    qyGraphView.isShowMask = checked
                    viewPopup.visible = false
                    showTransparentMask = false
                }
            }
        }
    }

    // Item pop up
    Rectangle {
        id: itemPopUp
        z: 2
        width: isHandMode ? handModeColumn.width : autoModeColumn.width
        height: isHandMode ? handModeColumn.height : autoModeColumn.height
        color: m_skin.actionBackground
        visible: false

        property int itemType: 0
        property bool createState: true
        property bool treatment: true

        onVisibleChanged: {
            if ( !visible ) {
                // 属性弹窗关闭后图形滚轮事件可用
                qyGraphView.itemWheelEnabled()

                if ( isHandMode ) {
                    // Add out of range message
                    if ( (hand_width.resultValue < hand_width.minValue || hand_width.resultValue > hand_width.maxValue) &&
                            (itemPopUp.itemType == 6 || itemPopUp.itemType == 7) ) {
                        globalFun.showMessageBox(3, "The minimum width is " + hand_width.minValue + " !")
                    }
                    if ( (hand_height.resultValue < hand_height.minValue || hand_height.resultValue > hand_height.maxValue) &&
                            itemPopUp.itemType == 7 ) {
                        globalFun.showMessageBox(3, "The minimum height is " + hand_height.minValue + " !")
                    }
                    if ( (hand_radius.resultValue < hand_radius.minValue || hand_radius.resultValue > hand_radius.maxValue) &&
                            itemPopUp.itemType == 7 ) {
                        globalFun.showMessageBox(3, "The radius ranges from " + hand_radius.minValue + " to " + hand_radius.maxValue + " !")
                    }

                    if ( hand_scale.resultValue < hand_scale.minValue || hand_scale.resultValue > hand_scale.maxValue ) {
                        globalFun.showMessageBox(3, "The scale ranges from 1 to 100 !")
                    }
                    if ( hand_rotation.resultValue < hand_rotation.minValue || hand_rotation.resultValue > hand_rotation.maxValue ) {
                        globalFun.showMessageBox(3, "The rotation ranges from -360° to 360° !")
                    }

                    // init data
                    hand_diameter1.spinBoxValue = hand_diameter1.resultValue
                    hand_diameter2.spinBoxValue = hand_diameter2.resultValue
                    hand_width.spinBoxValue = hand_width.resultValue
                    hand_height.spinBoxValue = hand_height.resultValue
                    hand_length.spinBoxValue = hand_length.resultValue
                    hand_radius.spinBoxValue = hand_radius.resultValue
                    hand_scale.spinBoxValue = hand_scale.resultValue
                    hand_rotation.spinBoxValue = hand_rotation.resultValue

                } else {
                    // Add out of range message
                    if ( auto_erode.resultValue < auto_erode.minValue || auto_erode.resultValue > auto_erode.maxValue ) {
                        globalFun.showMessageBox(3, "The erode ranges from 1 to 4 !")
                    }
                    if ( auto_scale.resultValue < auto_scale.minValue || auto_scale.resultValue > auto_scale.maxValue ) {
                        globalFun.showMessageBox(3, "The scale ranges from 50 to 100 !")
                    }

                    // init data
                    auto_length_1.spinBoxValue = auto_length_1.resultValue
                    auto_length_2.spinBoxValue = auto_length_2.resultValue
                    auto_diameter.spinBoxValue = auto_diameter.resultValue
                    auto_width.spinBoxValue = auto_width.resultValue
                    auto_height.spinBoxValue = auto_height.resultValue
                    auto_radius.spinBoxValue = auto_radius.resultValue
                    auto_distance1.spinBoxValue = auto_distance1.resultValue
                    auto_distance2.spinBoxValue = auto_distance2.resultValue
                    auto_erode.spinBoxValue = auto_erode.resultValue
                    auto_scale.spinBoxValue = auto_scale.resultValue
                }

            }
        }

        // 获取图形属性
        function getItemProperty() {
            if ( isHandMode ) {
                hand_diameter1.spinBoxValue = qyGraphView.getItemProperty(2)
                hand_diameter2.spinBoxValue = qyGraphView.getItemProperty(4)
                hand_width.spinBoxValue = qyGraphView.getItemProperty(2)
                hand_height.spinBoxValue = qyGraphView.getItemProperty(3)
                hand_length.spinBoxValue = qyGraphView.getItemProperty(2)
                hand_radius.spinBoxValue = qyGraphView.getItemProperty(4)
                hand_scale.spinBoxValue = qyGraphView.getItemProperty(5)
                hand_rotation.spinBoxValue = qyGraphView.getItemProperty(6)
            } else {
                auto_length_1.spinBoxValue = qyGraphView.getItemProperty(2)
                auto_length_2.spinBoxValue = qyGraphView.getItemProperty(3)
                auto_diameter.spinBoxValue = qyGraphView.getItemProperty(15)
                auto_width.spinBoxValue = qyGraphView.getItemProperty(13)
                auto_height.spinBoxValue = qyGraphView.getItemProperty(14)
                auto_radius.spinBoxValue = qyGraphView.getItemProperty(16)
                auto_distance1.spinBoxValue = qyGraphView.getItemProperty(17)
                auto_distance2.spinBoxValue = qyGraphView.getItemProperty(18)
                auto_erode.spinBoxValue = qyGraphView.getItemProperty(12)
                auto_scale.spinBoxValue = qyGraphView.getItemProperty(19)
            }
        }

        // Hand mode
        Column {
            id: handModeColumn
            spacing: 1
            visible: isHandMode

            // 直径1
            QYSpinBox {
                id: hand_diameter1
                spinBoxPrefix: {
                    if ( itemPopUp.itemType == 0 ) {
                        return isChinese ? "直径 : " : "Diameter : "
                    } else if ( itemPopUp.itemType == 2 ) {
                        return isChinese ? "直径1: " : "Diameter1: "
                    } else {
                        return ""
                    }
                }
                spinBoxSuffix: "mm"
                visible: itemPopUp.itemType == 0 || itemPopUp.itemType == 2

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue && itemPopUp.treatment ) {
                        qyGraphView.setItemProperty(2, resultValue)
                    }
                }
            }

            // 直径2
            QYSpinBox {
                id: hand_diameter2
                spinBoxPrefix: isChinese ? "直径2: " : "Diameter2: "
                spinBoxSuffix: "mm"
                visible: itemPopUp.itemType == 2

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue && itemPopUp.treatment ) {
                        qyGraphView.setItemProperty(4, resultValue)
                    }
                }
            }

            // 宽度
            QYSpinBox {
                id: hand_width
                spinBoxPrefix: isChinese ? "宽度 : " : "Width : "
                spinBoxSuffix: "mm"
                minValue: {
                    if ( itemPopUp.itemType == 6 ) {
                        return hand_height.spinBoxValue
                    } else if ( itemPopUp.itemType == 7 ) {
                        return qyGraphView.getItemProperty(4) * 2
                    } else {
                        return 0.1
                    }
                }
                visible: itemPopUp.itemType == 1 || itemPopUp.itemType == 3 || itemPopUp.itemType == 6 || itemPopUp.itemType == 7

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue && itemPopUp.treatment ) {
                        qyGraphView.setItemProperty(2, resultValue)
                    }
                }
            }

            // 高度
            QYSpinBox {
                id: hand_height
                spinBoxPrefix: isChinese ? "高度 : " : "Height : "
                spinBoxSuffix: "mm"
                minValue: itemPopUp.itemType == 7 ? qyGraphView.getItemProperty(4) * 2 : 0.1
                visible: itemPopUp.itemType == 1 || itemPopUp.itemType == 3 || itemPopUp.itemType == 6 || itemPopUp.itemType == 7

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue && itemPopUp.treatment ) {
                        qyGraphView.setItemProperty(3, resultValue)
                    }
                }
            }

            // 边长
            QYSpinBox {
                id: hand_length
                spinBoxPrefix: isChinese ? "边长 : " : "Length : "
                spinBoxSuffix: "mm"
                visible: itemPopUp.itemType == 4

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue && itemPopUp.treatment ) {
                        qyGraphView.setItemProperty(2, resultValue)
                    }
                }
            }

            // 半径
            QYSpinBox {
                id: hand_radius
                spinBoxPrefix: isChinese ? "半径 : " : "Radius : "
                spinBoxSuffix: "mm"
                maxValue: hand_width.spinBoxValue > hand_height.spinBoxValue ? hand_height.spinBoxValue / 2 : hand_width.spinBoxValue / 2
                visible: itemPopUp.itemType == 7

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue && itemPopUp.treatment ) {
                        qyGraphView.setItemProperty(4, resultValue)
                    }
                }
            }

            // 比例
            QYSpinBox {
                id: hand_scale
                spinBoxPrefix: isChinese ? "比例 : " : "Scale : "
                spinBoxSuffix: "%"
                spinBoxDecimals: 0
                spinBoxStepSize: 1
                minValue: 1
                maxValue: 100
                visible: itemPopUp.itemType != 5

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue ) {
                        var width = qyGraphView.getItemProperty(2) * 100 / qyGraphView.getItemProperty(5)
                        var height = qyGraphView.getItemProperty(3) * 100 / qyGraphView.getItemProperty(5)
                        var radius = qyGraphView.getItemProperty(4) * 100 / qyGraphView.getItemProperty(5)

                        // QTSpinBox 不处理数值的变化
                        itemPopUp.treatment = false

                        var decimal = 5 / Math.pow(10, 3)
                        var divisor = Math.pow(10, 2)

                        // 按照比例缩放数值
                        hand_diameter1.spinBoxValue = Math.floor((width * resultValue / 100 + decimal) * divisor) / divisor
                        hand_diameter2.spinBoxValue = Math.floor((radius * resultValue / 100 + decimal) * divisor) / divisor
                        hand_width.spinBoxValue = Math.floor((width * resultValue / 100 + decimal) * divisor) / divisor
                        hand_height.spinBoxValue = Math.floor((height * resultValue / 100 + decimal) * divisor) / divisor
                        hand_length.spinBoxValue = Math.floor((width * resultValue / 100 + decimal) * divisor) / divisor
                        hand_radius.spinBoxValue = Math.floor((radius * resultValue / 100 + decimal) * divisor) / divisor

                        // QTSpinBox 处理数值的变化
                        itemPopUp.treatment = true

                        qyGraphView.setItemProperty(5, resultValue)
                    }
                }
            }

            // 旋转
            QYSpinBox {
                id: hand_rotation
                spinBoxPrefix: isChinese ? "旋转 : " : "Rotation : "
                spinBoxSuffix: "°"
                spinBoxDecimals: 0
                spinBoxStepSize: 1
                minValue: -360
                maxValue: 360

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue ) {
                        qyGraphView.setItemProperty(6, resultValue)
                    }
                }
            }
        }

        // Auto mode
        Column {
            id: autoModeColumn
            spacing: 1
            visible: !isHandMode

            // 矩形的宽度
            QYSpinBox {
                id: auto_length_1
                spinBoxPrefix: isChinese ? "边长1: " : "Length1: "
                spinBoxSuffix: "mm"

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue ) {
                        qyGraphView.setItemProperty(2, resultValue)
                    }
                }
            }

            // 矩形的高度
            QYSpinBox {
                id: auto_length_2
                spinBoxPrefix: isChinese ? "边长2: " : "Length2: "
                spinBoxSuffix: "mm"

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue ) {
                        qyGraphView.setItemProperty(3, resultValue)
                    }
                }
            }

            // 直径
            QYSpinBox {
                id: auto_diameter
                spinBoxPrefix: isChinese ? "直径 : " : "Diameter : "
                spinBoxSuffix: "mm"
                visible: itemPopUp.createState && itemPopUp.itemType == 10

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue ) {
                        qyGraphView.setItemProperty(15, resultValue)
                    }
                }
            }

            // 宽度
            QYSpinBox {
                id: auto_width
                spinBoxPrefix: isChinese ? "宽度 : " : "Width : "
                spinBoxSuffix: "mm"
                visible: itemPopUp.createState && (itemPopUp.itemType == 11 || itemPopUp.itemType == 12 ||
                                                   itemPopUp.itemType == 13 || itemPopUp.itemType == 14)

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue ) {
                        qyGraphView.setItemProperty(13, resultValue)
                    }
                }
            }

            // 高度
            QYSpinBox {
                id: auto_height
                spinBoxPrefix: isChinese ? "高度 : " : "Height : "
                spinBoxSuffix: "mm"
                visible: itemPopUp.createState && (itemPopUp.itemType == 11 || itemPopUp.itemType == 12 ||
                                                   itemPopUp.itemType == 13 || itemPopUp.itemType == 14)

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue ) {
                        qyGraphView.setItemProperty(14, resultValue)
                    }
                }
            }

            // 半径
            QYSpinBox {
                id: auto_radius
                spinBoxPrefix: isChinese ? "半径 : " : "Radius : "
                spinBoxSuffix: "mm"
                visible: itemPopUp.createState && itemPopUp.itemType == 13

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue ) {
                        qyGraphView.setItemProperty(16, resultValue)
                    }
                }
            }

            // 距离1
            QYSpinBox {
                id: auto_distance1
                spinBoxPrefix: isChinese ? "距离1: " : "Distance1: "
                spinBoxSuffix: "mm"
                minValue: -9999
                minusEnable: true
                visible: itemPopUp.createState && itemPopUp.itemType == 15

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue ) {
                        qyGraphView.setItemProperty(17, resultValue)
                    }
                }
            }

            // 距离2
            QYSpinBox {
                id: auto_distance2
                spinBoxPrefix: isChinese ? "距离2: " : "Distance2: "
                spinBoxSuffix: "mm"
                minValue: -9999
                minusEnable: true
                visible: itemPopUp.createState && itemPopUp.itemType == 15

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue ) {
                        qyGraphView.setItemProperty(18, resultValue)
                    }
                }
            }

            // 腐蚀量
            QYSpinBox {
                id: auto_erode
                spinBoxPrefix: isChinese ? "腐蚀 : " : "Erode : "
                spinBoxSuffix: "pixel"
                spinBoxDecimals: 0
                spinBoxStepSize: 1
                minValue: 1
                maxValue: 4
                visible: itemPopUp.itemType == 16

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue ) {
                        qyGraphView.setItemProperty(12, resultValue)
                    }
                }
            }

            // 比例
            QYSpinBox {
                id: auto_scale
                spinBoxPrefix: isChinese ? "比例 : " : "Scale : "
                spinBoxSuffix: "%"
                spinBoxDecimals: 0
                spinBoxStepSize: 1
                minValue: 50
                maxValue: 100
                visible: !itemPopUp.createState && itemPopUp.itemType != 16

                onResultValueChanged: {
                    if ( resultValue >= minValue && resultValue <= maxValue ) {
                        qyGraphView.setItemProperty(19, resultValue)
                    }
                }
            }

            // 数值还是比例
            Rectangle {
                width: auto_length_1.width; height: auto_length_1.height
                color: "transparent"
                visible: itemPopUp.itemType != 16

                ExclusiveGroup { id: stateGroup }

                QYRadioButton {
                    width: parent.width/2 - 1; height: parent.height
                    anchors.left: parent.left
                    content: isChinese ? "数值" : "Value"
                    exclusiveGroup: stateGroup
                    checked: itemPopUp.createState
                    unselectedAble: false
                    onSelected: {
                        qyGraphView.setItemProperty(11, 1)
                        itemPopUp.createState = true
                    }
                }

                QYRadioButton {
                    width: parent.width/2 - 1; height: parent.height
                    anchors.right: parent.right
                    content: isChinese ? "比例" : "Scale"
                    exclusiveGroup: stateGroup
                    checked: !itemPopUp.createState
                    unselectedAble: false
                    onSelected: {
                        qyGraphView.setItemProperty(11, 0)
                        itemPopUp.createState = false
                    }
                }
            }

            // 自动类型
            Rectangle {
                width: auto_length_1.width; height: column.height
                color: "transparent"

                ExclusiveGroup { id: typeGroup }

                Column {
                    id: column
                    width: parent.width
                    spacing: 2

                    QYRadioButton {
                        width: parent.width
                        content: isChinese ? "自动圆" : "Auto circle"
                        exclusiveGroup: typeGroup
                        checked: itemPopUp.itemType == 10
                        unselectedAble: false
                        onSelected: {
                            qyGraphView.setItemProperty(1, 10)
                            itemPopUp.itemType = 10
                        }
                    }

                    QYRadioButton {
                        width: parent.width
                        content: isChinese ? "自动椭圆" : "Auto ellipse"
                        exclusiveGroup: typeGroup
                        checked: itemPopUp.itemType == 11
                        unselectedAble: false
                        onSelected: {
                            qyGraphView.setItemProperty(1, 11)
                            itemPopUp.itemType = 11
                        }
                    }

                    QYRadioButton {
                        width: parent.width
                        content: isChinese ? "自动圆端矩形" : "Auto pill"
                        exclusiveGroup: typeGroup
                        checked: itemPopUp.itemType == 12
                        unselectedAble: false
                        onSelected: {
                            qyGraphView.setItemProperty(1, 12)
                            itemPopUp.itemType = 12
                        }
                    }

                    QYRadioButton {
                        width: parent.width
                        content: isChinese ? "自动圆角矩形" : "Auto chamfer"
                        exclusiveGroup: typeGroup
                        checked: itemPopUp.itemType == 13
                        unselectedAble: false
                        onSelected: {
                            qyGraphView.setItemProperty(1, 13)
                            itemPopUp.itemType = 13
                        }
                    }

                    QYRadioButton {
                        width: parent.width
                        content: isChinese ? "自动旋转矩形" : "Auto rotate rectangle"
                        exclusiveGroup: typeGroup
                        checked: itemPopUp.itemType == 14
                        unselectedAble: false
                        onSelected: {
                            qyGraphView.setItemProperty(1, 14)
                            itemPopUp.itemType = 14
                        }
                    }

                    QYRadioButton {
                        width: parent.width
                        content: isChinese ? "自动圆边矩形" : "Auto edge rectangle"
                        exclusiveGroup: typeGroup
                        checked: itemPopUp.itemType == 15
                        unselectedAble: false
                        onSelected: {
                            qyGraphView.setItemProperty(1, 15)
                            itemPopUp.itemType = 15
                        }
                    }

                    QYRadioButton {
                        width: parent.width
                        content: isChinese ? "全自动识别" : "Auto distinguish"
                        exclusiveGroup: typeGroup
                        checked: itemPopUp.itemType == 16
                        unselectedAble: false
                        onSelected: {
                            qyGraphView.setItemProperty(1, 16)
                            itemPopUp.itemType = 16
                        }
                    }
                }
            }
        }

    }

    // 调用算法计算
    function calWithAlgorithm(pixel) {
        // 如果是复测，则不需要修改配置
        if ( remainingTestTimes === 0 ) {
            // 正在测量中
            is_in_calculation = true

            // 日志记录
            logCtl.write(globalFun.getCurrentTime(6) + " - Start modifying algorithm parameters");

            // 修改掩膜口径
            algorithmCtl.setAperture(qyGraphView.getAperture())

            // 修改算法配置
            algorithmCtl.modifyConfig(modifyConfig(pixel))

            // 计算矩形框
            algorithmCtl.setRect(qyGraphView.getRect())

            // 计算掩膜
            algorithmCtl.setMask(qyGraphView.getMask(is_load_ASCOrXYZ))
        }

        // 日志记录
        logCtl.write(globalFun.getCurrentTime(6) + " - Start calling algorithm calculation");

        // 开始计算
        algorithmCtl.startCalculation(is_load_ASCOrXYZ)
    }

    // 修改算法配置
    function modifyConfig(px_1mm) {
        var obj = {}

        obj.isLog = m_config.algorithm_log
        obj.isPhaseAverage = m_config.algorithm_phaseAverage
        obj.isWaveLengthTuning = m_config.algorithm_waveLengthTuning
        obj.isASCFile = is_load_ASCOrXYZ
        obj.removeResidualFlag = m_config.algorithm_removeResidual
        obj.isFillSpikes = m_config.algorithm_fillSpikes
        obj.scaleFactor = m_config.algorithm_scaleFactor
        obj.highPassFilterCoef = m_config.algorithm_highPassFilterCoef
        obj.residuesNumThresh = m_config.algorithm_residuesNumThresh

        if ( isHandMode && qyGraphView.getItemCount() > 0 ) {
            obj.isEdgeEroding = false
            obj.edge_erode_r = 0
        } else {
            obj.isEdgeEroding = qyGraphView.judAutomatic()
            obj.edge_erode_r = qyGraphView.getIndentPixel()
        }

        obj.phaseShiftThr = m_config.algorithm_phaseShiftThr
        obj.stdPhaseHistThr = m_config.algorithm_stdPhaseHistThr
        obj.resPvThr = 0
        obj.resRmsThr = 0

        obj.psiMethod = m_config.algorithm_psiMethod
        obj.unwrapMethod = m_config.algorithm_unwrapMethod
        obj.filterType = m_config.algorithm_filterType
        obj.filterWindowSize = m_config.algorithm_filterWindowSize
        obj.rsFlag = m_config.algorithm_removeSpikes
        obj.removeSize = m_config.algorithm_removeSize
        obj.rsThreshCoef = m_config.algorithm_rsThreshCoef

        obj.zernikeMethod = qyGraphView.getItemCirCleLevel()
        obj.isUseScale = isHandMode ? 0 : qyGraphView.getAutoItemValue(1)
        obj.detecScale = isHandMode ? 1 : qyGraphView.getAutoItemValue(2)
        obj.maskShape = isHandMode ? 0 : qyGraphView.getAutoItemValue(3)
        obj.width = qyGraphView.getAutoItemValue(4)
        obj.height = qyGraphView.getAutoItemValue(5)
        obj.inputRadius = qyGraphView.getAutoItemValue(6)

        obj.positionFlag = m_config.algorithm_piston
        obj.tiltFlag = m_config.algorithm_tilt
        obj.powerFlag = m_config.algorithm_power
        obj.astFlag = m_config.algorithm_ast
        obj.comaFlag = m_config.algorithm_coma
        obj.sphericalFlag = m_config.algorithm_spherical

        obj.pvFlag = m_resultParameter.pv
        obj.pvxFlag = m_resultParameter.pvx
        obj.pvyFlag = m_resultParameter.pvy
        obj.pvxyFlag = m_resultParameter.pvxy
        obj.pvrFlag = m_resultParameter.pvr
        obj.pvresFlag = m_resultParameter.pvres

        obj.rmsFlag = m_resultParameter.rms
        obj.rmsxFlag = m_resultParameter.rmsx
        obj.rmsyFlag = m_resultParameter.rmsy
        obj.rmsxyFlag = m_resultParameter.rmsxy
        obj.rmsresFlag = m_resultParameter.rmsres

        obj.zernikeTiltFlag = m_resultParameter.zernikeTilt
        obj.zernikePowerFlag = m_resultParameter.zernikePower
        obj.zernikePowerXFlag = m_resultParameter.zernikePowerX
        obj.zernikePowerYFlag = m_resultParameter.zernikePowerY
        obj.zernikeAstFlag = m_resultParameter.zernikeAst
        obj.zernikeComaFlag = m_resultParameter.zernikeComa
        obj.zernikeSphericalFlag = m_resultParameter.zernikeSpherical

        obj.seidelTiltFlag = m_resultParameter.seidelTilt
        obj.seidelFocusFlag = m_resultParameter.seidelFocus
        obj.seidelAstFlag = m_resultParameter.seidelAst
        obj.seidelComaFlag = m_resultParameter.seidelComa
        obj.seidelSphericalFlag = m_resultParameter.seidelSpherical
        obj.seidelTiltClockFlag = m_resultParameter.seidelTiltClock
        obj.seidelAstClockFlag = m_resultParameter.seidelAstClock
        obj.seidelComaClockFlag = m_resultParameter.seidelComaClock

        obj.rmsPowerFlag = m_resultParameter.rmsPower
        obj.rmsAstFlag = m_resultParameter.rmsAst
        obj.rmsComaFlag = m_resultParameter.rmsComa
        obj.rmsSaFlag = m_resultParameter.rmsSa

        obj.sagFlag = m_resultParameter.sag
        obj.irrFlag = m_resultParameter.irr
        obj.rsiFlag = m_resultParameter.rsi
        obj.rmstFlag = m_resultParameter.rmst
        obj.rmsaFlag = m_resultParameter.rmsa
        obj.rmsiFlag = m_resultParameter.rmsi

        obj.ttvFlag = m_resultParameter.ttv
        obj.fringesFlag = m_resultParameter.fringes
        obj.strehlFlag = m_resultParameter.strehl
        obj.parallelThetaFlag = m_resultParameter.parallelTheta
        obj.apertureFlag = m_resultParameter.aperture
        obj.sizeXFlag = m_resultParameter.sizeX
        obj.sizeYFlag = m_resultParameter.sizeY
        obj.grmsFlag = m_resultParameter.grms
        obj.concavityFlag = m_resultParameter.concavity

        obj.px_1mm = px_1mm === 0 ? m_config.camera_pixel_calibration : px_1mm
        obj.refractiveIndex = m_config.algorithm_refractiveIndex
        obj.testWavelength = m_config.algorithm_testWavelength
        obj.ISOWavelength = m_config.algorithm_isoWavelength
        obj.disPlayWavelength = m_config.algorithm_disPlayWavelength
        obj.unitType = m_config.common_unit

        return JSON.stringify(obj)
    }

    // 加载掩膜
    function loadMask() {
        // 如果掩膜存在则加载掩膜
        var file = globalFun.getCurrentPath() + "/item.json"
        if ( globalFun.isFileExist(file) ) {
            var str = globalFun.read(file)
            qyGraphView.loadGraphItem(str)
        }
    }

    // 保存掩膜（我们规定：没有打开相机就不自动保存掩膜）
    function saveMask() {
        if ( qyGraphView.getItemCount() > 0 && qyGraphView.isWorking ) {
            qyGraphView.autoSaveGraphItem()
        } else {
            globalFun.removeFile(globalFun.getCurrentPath() + "/item.json")
        }
    }

    // 关闭弹窗
    function closePopUp() {
        qyGraphView.focus = true
        viewPopup.visible = false
        itemPopUp.visible = false
        showTransparentMask = false
    }
}
