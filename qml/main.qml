import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import "qrc:/js/InitData.js" as JSInitData
import "./Content"


Window {
    id:window
    visible: true
    width: 1500; height: 1000
    minimumWidth: 1000; minimumHeight: 600
    title: qsTr("ImageProcess-ZTB")

    property var m_config: Object                       // 配置 Object
    property var m_skin: Object                         // 皮肤 Object
    property bool isChinese: true                       // 语言类型 true-中文 false-英文
    property var pictureNum: 0
    property var filepath: ""
    property int currentIndex: 1                        // StackView 当前页面

    property int lineWidth: 4                           // 线条宽度，全局适用
    property int margin: 5                              // 边界宽度，全局适用
    property bool showTransparentMask: false            // 是否显示菜单栏、工具栏的透明遮罩

    /*
     * 透明遮罩设置层级规则:
     * 1. 菜单栏因为其大小是整个窗口，需要显示在其他窗口之上，所以z为1，菜单栏中的遮罩z为2，菜单栏中的下拉框z为3，鼠标事件穿透到下一层
     * 2. 菜单栏和工具栏的遮罩z为2，通过 showTransparentMask 来控制显示，捕获鼠标事件并反馈信号给视图
     * 3. 功能栏的遮罩z为1，通过 showTransparentMask 来控制显示，捕获鼠标事件并反馈信号给视图
     * 4. 主界面中有弹窗的都需要添加遮罩，z为1，通过 showTransparentMask 来控制显示，如果带了视图的就需要把上层的信号反馈给视图
     * 5. 视图的z为2，因为视图中的弹窗需要在主界面的遮罩之上显示
     */
    signal getFocus()                                   // 主界面捕获焦点
    signal lostFocus()                                  // 主界面失去焦点
    signal skinChanged()                                // 修改皮肤（用于更新2D图表刻度颜色）

    signal getpic()

    // 切换页面
    onCurrentIndexChanged: {
        view.changeIndex(currentIndex)
    }

    // 透明遮罩，显示时主界面失去焦点，隐藏时主界面获取焦点
    onShowTransparentMaskChanged: {
        if ( showTransparentMask ) {
            lostFocus()
        } else {
            getFocus()
        }
    }

    onPictureNumChanged: {
        getpic()
    }

    // 数据初始化
    Component.onCompleted: {
        // 配置文件路径
        var configPath = globalFun.getCurrentPath() + "/config.json"

        if ( globalFun.isFileExist(configPath) ) {
            // 如果文件已存在，加载解析配置文件
            m_config = JSON.parse(globalFun.read(configPath))
        } else {
            // 如果文件不存在，创建默认配置文件
            m_config = JSInitData.createDefaultJSON()

            // 保存配置文件到根目录下
            globalFun.write(configPath, JSON.stringify(m_config))
        }

        //------------------------------------------------------------------------------

        // 从配置文件中获取主题等信息
        m_skin = JSInitData.getSkin(m_config.common_skinType)
        isChinese = m_config.common_languageType === 1
    }

    // 关闭界面时保存配置文件
    // @disable-check M16
    onClosing: {
        // 配置文件路径
        var configPath = globalFun.getCurrentPath() + "/config.json"

        // 保存配置文件到根目录下
        globalFun.write(configPath, JSON.stringify(m_config))

        // the window is allowed to close
        close.accepted = true
    }

    // 菜单栏
    MenuBar {
        id: menuBar
        x: 0; y: 0; z: 1
        width: window.width; height: window.height
    }
    // 工具栏
    ToolBar {
        id: toolBar
        x: 0; y: 20
        width: window.width; height: 40

    }


    // 背景
    Rectangle {
        id: background
        x: 0; y: toolBar.y + toolBar.height
        width: window.width; height: window.height - background.y

        // 功能栏
        ModuleBar {
            id: moduleBar
            width: 180
            anchors.top: background.top
            anchors.bottom: background.bottom
            anchors.left: background.left
        }

        // 主界面
        View {
            id: view
            anchors.top: background.top
            anchors.bottom: background.bottom
            anchors.left: moduleBar.right
            anchors.right: background.right
        }
    }




}
