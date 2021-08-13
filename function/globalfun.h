#ifndef GLOBALFUN_H
#define GLOBALFUN_H

#include <QObject>
#include <QDebug>
#include <QQuickWindow>
#include <QFontDatabase>

#include <iostream>
using namespace std;

class GlobalFun : public QObject
{
    Q_OBJECT

public:
    explicit GlobalFun(QObject *parent = 0);

    // 读取文件
    Q_INVOKABLE QString read(const QString &path);

    // 保存文件
    Q_INVOKABLE bool write(const QString &path, const QString &data);

    // 获取当前工程执行路径
    Q_INVOKABLE QString getCurrentPath();

    // 判断文件夹是否存在
    Q_INVOKABLE bool isDirExist(const QString &path, bool onlyJud = true);

    // 判断文件是否存在
    Q_INVOKABLE bool isFileExist(const QString &fileName);

    // 删除文件
    Q_INVOKABLE bool removeFile(const QString &fileName);

    // 消息对话框
    Q_INVOKABLE void showMessageBox(int type, QString info);

    // 文件对话框（文件夹）
    Q_INVOKABLE QString getExistingDirectory(QString title, QString path);

    // 文件对话框（加载文件）
    Q_INVOKABLE QString getOpenFileName(QString title, QString path, QString filter);

    // 文件对话框（保存文件）
    Q_INVOKABLE QString getSaveFileName(QString title, QString path, QString filter);

    // 获取时间
    Q_INVOKABLE QString getCurrentTime(int type);

    // 睡眠
    Q_INVOKABLE void bsleep(int msecond);

    // 保存截图
    Q_INVOKABLE void grabWindow(QString path, QQuickWindow *window);

    // 获取范围内的随机数
    Q_INVOKABLE int getRand(int min, int max);

    // 判断日期是否超出限制
    Q_INVOKABLE bool inspectionDate(QString strDate, int restriction);

    //------------------------------------------------------------------------------

    // 判断文件夹是否存在（static）
    static bool isDirExistStatic(const QString &path, bool onlyJud = true);

    // 判断文件是否存在（static）
    static bool isFileExistStatic(const QString &fileName);

    // 保存文件（static）
    static bool writeStatic(const QString &path, const QString &data);

    // 获取时间（static）
    static QString getCurrentTimeStatic(int type);

    // 保存截图（static）
    static void grabWindowStatic(QString path, QQuickWindow *window);

    // 睡眠（static）
    static void bsleepStatic(int msecond);

    //------------------------------------------------------------------------------

	// 获取字体
    static QString getTTF(int id);
};

#endif // GLOBALFUN_H
