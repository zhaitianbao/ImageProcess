// 创建默认配置文件
function createDefaultJSON()
{
    var obj = {}

    // Common
    obj.common_languageType = 1                 // 语言类型，1-中文 2-英文
    obj.common_skinType = 1                     // 皮肤，1-爆焰黑 2-工业灰
    obj.common_decimal = 3                      // 保留小数点个数

    // File
    obj.file_loadPath = ""                      // 加载文件的路径
    obj.file_savePath = ""                      // 保存文件的路径
    obj.file_exportPDFPath = ""                 // 导出PDF的路径
    obj.file_screenshotPath = ""                // 导出截图的路径
    obj.file_exportCSVPath = ""                 // 导出CSV的路径

    obj.file_save_picture = 0                   // 保存图片，0-不保存 1-都保存 2-NG时都保存 3-仅保存截图 4-NG时仅保存截图
    obj.file_save_asc = 0                       // 保存ASC文件，0-不保存 1-都保存 2-NG时保存
    obj.file_log_path = "D:/DataLog"            // log 文件保存路径
    obj.file_pic_path = "D:/PicSave"            // pic 文件保存路径
    obj.file_asc_path = "D:/AscSave"            // asc 文件保存路径

    return obj
}

// 切换主题
function getSkin(type)
{
    var obj = {}

    switch ( type )
    {
    case 1:
        // 菜单栏
        obj.menuBarBackground = "#2D2D2D"
        obj.menuHoverColor = "#646464"
        obj.menuTextColor = "#FFFFFF"
        obj.unenableTextColor = "#9B9B9B"
        obj.actionBackground = "#373737"
        obj.actionHoverColor = "#4FA0F1"

        // 工具栏
        obj.toolBarBackground = "#AAAAAA"
        obj.toolButtonHoverColor = "#999999"
        obj.toolButtonPressColor = "#777777"
        obj.toolBarSeparatorLineColor = "#FFFFFF"

        // 功能栏及常用按钮
        obj.background = "#858585"
        obj.moduleBarBackground = "#3F3F3F"
        obj.buttonHoverColor = "#999999"
        obj.buttonDefaultColor = "#909090"
        obj.buttonPressColor = "#666666"
        obj.isDark = true

        // 分割线
        obj.separatorLineColor = "#707070"

        // 下拉框
        obj.comboBoxBackground = "#2D2D2D"
        obj.comboBoxHoverColor = "#4F4F4F"
        obj.comboBoxPressColor = "#363636"

        // 数据报表
        obj.tableWidgetItemPressColor = "#696969"
        obj.tableWidgetSeparatorLineColor = "#CFCFCF"

        // 边框
        obj.defaultBorderColor = "#9B9B9B"
        obj.activeBorderColor = "#FFFFFF"

        // 3D视图背景色
        obj.viewBackgroundIn3D = "#363636"

        break
    case 2:
        obj.menuBarBackground = "#CFCFCF"
        obj.menuHoverColor = "#A2A2A2"
        obj.menuTextColor = "#17202A"
        obj.unenableTextColor = "#9B9B9B"
        obj.actionBackground = "#E5E7E9"
        obj.actionHoverColor = "#4FA0F1"

        obj.toolBarBackground = "#DCDDDD"
        obj.toolButtonHoverColor = "#D0D0D0"
        obj.toolButtonPressColor = "#9FA0A0"
        obj.toolBarSeparatorLineColor = "#5C5E5F"

        obj.background = "#F0F0F0"
        obj.moduleBarBackground = "#DCDDDD"
        obj.buttonHoverColor = "#D0D0D0"
        obj.buttonDefaultColor = "#CBCBCB"
        obj.buttonPressColor = "#9FA0A0"
        obj.isDark = false

        obj.separatorLineColor = "#D7DBDD"

        obj.comboBoxBackground = "#CFCFCF"
        obj.comboBoxHoverColor = "#DCDDDD"
        obj.comboBoxPressColor = "#C0C0C0"

        obj.tableWidgetItemPressColor = "#B5B5B5"
        obj.tableWidgetSeparatorLineColor = "#828282"

        obj.defaultBorderColor = "#828282"
        obj.activeBorderColor = "#646464"

        obj.viewBackgroundIn3D = "#4F4F4F"

        break
    case 3: break
    case 4: break
    case 5: break
    default: break
    }

    return obj
}
