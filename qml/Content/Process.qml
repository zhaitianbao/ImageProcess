import QtQuick 2.0
import "../Component"

Item {
    // 移项器
    Connections {
        target: daCardCtl

        // 移项器出现错误
        onCallQmlErrorOccurred: console.log("DA Card error, the error code is: " + type)

        // 加压完成，通过相机取图
        onCallQmltakeAPic: cameraCtl.takeAPic()

        // 全部加压完成，可以调用算法计算标定值
        onCallQmlCalibrationComplete: algorithmCtl.daCardCalibration(x, y, w, h);
    }

    // 相机
    Connections {
        target: cameraCtl

        // 加压之后，获取到一帧图片，存储于算法中的 matList
        onCallQmlReciveImg: algorithmCtl.addImageToList(image)

        // 定时分析图片，光强自动调节
        onCallQmlAnalysisImg: {}

        // 相机出现错误
        onCallQmlErrorOccurred: console.log("Camera error, the error message is: " + message)

        // 相机曝光改变，修改配置文件中的相机曝光
        onCallQmlRefeshEps: {
            console.log("Exposure: " + exposure)
            m_config.camera_exposure = exposure
        }
    }

    // 算法
    Connections {
        target: algorithmCtl

        // 导出 PDF 中的强度图和掩膜
        onCallQmlExportOriginalImg: pdfCtl.setValue(7, 0, image)

        onCallQmlSeidelInfo: pdfCtl.setValue(11, list)
    }
}
