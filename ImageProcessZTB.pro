QT += quick

CONFIG += c++11
QT += widgets
# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

RC_ICONS = logo_ztb.ico

SOURCES += \
        function/globalfun.cpp \
        function/imagedisplay.cpp \
        function/imageprocess.cpp \
        main.cpp

HEADERS += \
        function/globalfun.h \
        function/imagedisplay.h \
        function/imageprocess.h \
        function/globalfun.h \

RESOURCES += qml.qrc \
             font.qrc \
             image.qrc \
             js.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

#******************************************************************************************************************

TARGET = ImageProcessZTB

DESTDIR = ./

# QCustomPlot 需要使用打印模块
QT += printsupport

# RegistryControl 需要使用网络模块
QT += network axcontainer

# 图表
QT += charts

CONFIG += debug_and_release

RESOURCES += \
    image.qrc

INCLUDEPATH += $$PWD/3rd/OpenCV_msvc2017_64/include/

CONFIG(debug, debug|release) {
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_calib3d420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_core420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_dnn420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_features2d420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_flann420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_gapi420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_highgui420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_imgcodecs420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_imgproc420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_ml420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_objdetect420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_photo420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_stitching420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_video420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_videoio420d
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/debug/ -lopencv_world420d
} else {
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_calib3d420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_core420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_dnn420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_features2d420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_flann420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_gapi420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_highgui420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_imgcodecs420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_imgproc420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_ml420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_objdetect420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_photo420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_stitching420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_video420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_videoio420
    LIBS += -L$$PWD/3rd/OpenCV_msvc2017_64/lib/release/ -lopencv_world420
}
