#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QSharedMemory>
#include <QBuffer>
#include <QWindow>
#include <windows.h>
#include <QDebug>
#include <QQmlContext>
#include <QApplication>
#include <QMessageBox>
#include "function/globalfun.h"
#include "function/imageprocess.h"
#include "function/imagedisplay.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    app.setOrganizationName("ImageProcessZTB");
    app.setOrganizationDomain("ImageProcessZTB.com");
    app.setApplicationName("ImageProcessZTB");

    //******************************************************************************************************************
    // 用共享内存来控制单例模式，此模块为读取共享内存中的数据

    QSharedMemory sharemem;                                             // 声明QSharedMemory类，并且命名为sharemem
    QString key1, readstring;                                           // 声明共享内存的密钥和读出来的字符串
    QBuffer buffer1;                                                    // 声明缓冲区
    QDataStream in(&buffer1);                                           // 声明数据流
    key1 = "ImageProcessZTB";                                           // 确定共享内存的密匙
    sharemem.setKey(key1);                                              // 设置共享内存的访问密钥，使其能够找到指定共享内存
    sharemem.attach();                                                  // 找到指定的共享内存后关联此内存
    sharemem.lock();                                                    // 锁上共享内存
    buffer1.setData((char *)sharemem.constData(), sharemem.size());     // 用缓冲区得到共享内存关联后得到的数据和数据大小
    buffer1.open(QBuffer::ReadOnly);                                    // 打开缓冲区进行访问
    in >> readstring;                                                   // 使用数据流从缓冲区获得共享内存的数据，然后输出到字符串中
    sharemem.unlock();                                                  // 解锁共享内存空间
    sharemem.detach();                                                  // 与共享内存空间分离
    qDebug() << "The string of the shared memory is: " << readstring;
    //******************************************************************************************************************

    if ( readstring == "ImageProcessZTB" )
    {
        // 若能够读取到共享内存中的数据，则客户端已开启，不能再开启客户端
        HWND hwnd = FindWindow(NULL, L"ImageSketch-ZTB");
        QMessageBox::information(nullptr, "Information", "ImageSketch-ZTB has been opened", QMessageBox::Ok);
        QWindow* window = QWindow::fromWinId((WId)hwnd);
        window->showNormal();
        exit(0);
    } else {

        //**************************************************************************************************************
        // 用共享内存来控制单例模式，此模块向共享内存中的写入数据

        QSharedMemory smem;                                             // 声明QSharedMemory类，并且命名为smem
        QString key2, sharedstring;                                     // 声明访问密匙和共享的数据
        QBuffer buffer2;                                                // 声明缓冲区
        QDataStream qdsm(&buffer2);                                     // 声明数据流
        key2 = "ImageProcessZTB";                                       // 确定共享内存的密匙
        smem.setKey(key2);                                              // 设置访问标识
        if ( smem.isAttached() ) smem.detach();                         // 判断是否已经连接到共享内存块，如果是的话，就先分离
        sharedstring = "ImageProcessZTB";                              // 确定共享的数据
        buffer2.open(QBuffer::ReadWrite);                               // 设置读取模式，打开缓冲区
        qdsm << sharedstring;                                           // 输入共享字符串到数据流，缓冲区就会得到数据的大小
        int size = buffer2.size();                                      // 获得字节大小
        if ( !smem.create(size) )                                       // 让共享内存创建一段内存空间，并检测共享内存段是否创建成功
        {
            qDebug() << "Could not create sharing memory !";
            return app.exec();
        }
        smem.lock();                                                    // 创建成功后，为了不影响其他的程序，锁定共享内存
        char * to = (char *)smem.data();                                // 共享内存的数据的指针
        const char * from = buffer2.data().data();                      // 被共享内存的数据的指针
        memcpy(to, from, qMin(smem.size(), size));                      // 把要共享的数据拷贝到共享数据的空间里，拷贝的数据大小是两者中小的那位
        smem.unlock();                                                  // 解锁共享内存空间，使其能够被其他程序访问
        qDebug() << "Sharing memory was successful. The key of shared memory is: " <<
                    key2 << ", The string of the shared memory is: " << sharedstring << endl;
        //**************************************************************************************************************

        QQmlApplicationEngine engine;

        GlobalFun globalFun;
        engine.rootContext()->setContextProperty("globalFun", &globalFun);
        ImageProcess imageprocess;
        engine.rootContext()->setContextProperty("imageprocess", &imageprocess);

        qmlRegisterType<ImageDisplay>("ImageDisplay", 1, 0, "ImageDisplay");

        const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
        QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                         &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
        engine.load(url);

        return app.exec();
    }


}
