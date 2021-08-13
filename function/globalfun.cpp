#include "globalfun.h"
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QMessageBox>
#include <QFileDialog>
#include <QDateTime>
#include <QCoreApplication>

GlobalFun::GlobalFun(QObject *parent) : QObject(parent)
{

}

QString GlobalFun::read(const QString &path)
{
    if ( path.isEmpty() ) {
        return "The path is empty !";
    }

    QFile file(path);
    QString result;

    // 以只读的方式打开本地文件，一行一行的读取内容并追加在后面，最后返回一个一行的字符串
    if ( file.open(QIODevice::ReadOnly) ) {
        QString line;
        QTextStream t( &file );
        do {
            line = t.readLine();
            result += line;
        } while (!line.isNull());

        file.close();
    } else {
        return "Unable to open the file !";
    }

    return result;
}

bool GlobalFun::write(const QString &path, const QString &data)
{
    if ( path.isEmpty() ) {
        qDebug() << "The path is empty !";
        return false;
    }

    QFile file(path);
    if ( !file.open(QFile::WriteOnly | QFile::Truncate) ) {
        qDebug() << "Unable to open the file !";
        return false;
    }

    QTextStream out(&file);

    QStringList dataArray = data.split(",", QString::SkipEmptyParts);
    dataArray[0].remove(0, 1);
    dataArray[dataArray.size() - 1].remove(dataArray[dataArray.size() - 1].size() - 1, 1);

    out << "{" << endl;
    int i = 0;
    for ( ; i < dataArray.size() - 1; ++i )
    {
        out << dataArray[i] << "," << endl;
    }
    out << dataArray[i] << endl << "}" << endl;

    file.close();

    return true;
}

QString GlobalFun::getCurrentPath()
{
    return QDir::currentPath();
}

bool GlobalFun::isDirExist(const QString &path, bool onlyJud)
{
    QDir dir(path);

    if( dir.exists() ) {
        return true;
    } else {
        if ( onlyJud ) {
            return false;   // 仅仅判断，没有该文件夹返回错误
        } else {
            return dir.mkdir(path); // 没有文件夹时创建（只创建一级子目录，即必须保证上级目录存在）
        }
    }
}

bool GlobalFun::isFileExist(const QString &fileName)
{
    QFileInfo fileInfo(fileName);
    return fileInfo.isFile();
}

bool GlobalFun::removeFile(const QString &fileName)
{
    if( QFile::exists(fileName) ) {
        return QFile(fileName).remove();
    } else {
        return true;
    }
}

void GlobalFun::showMessageBox(int type, QString info)
{
    switch ( type )
    {
    case 1: QMessageBox::question(nullptr, "Question", info, QMessageBox::Ok); break;       // 在正常操作中提出问题
    case 2: QMessageBox::information(nullptr, "Information", info, QMessageBox::Ok); break; // 用于报告有关正常操作的信息
    case 3: QMessageBox::warning(nullptr, "Warning", info, QMessageBox::Ok); break;         // 用于报告非关键错误
    case 4: QMessageBox::critical(nullptr, "Error", info, QMessageBox::Ok); break;          // 用于报告关键错误
    default: break;
    }
}

QString GlobalFun::getExistingDirectory(QString title, QString path)
{
    QString file = QFileDialog::getExistingDirectory(nullptr, title, path);
    return file;
}

QString GlobalFun::getOpenFileName(QString title, QString path, QString filter)
{
    QString file = QFileDialog::getOpenFileName(nullptr, title, path, filter);
    return file;
}

QString GlobalFun::getSaveFileName(QString title, QString path, QString filter)
{
    QString file = QFileDialog::getSaveFileName(nullptr, title, path, filter);
    return file;
}

QString GlobalFun::getCurrentTime(int type)
{
    QDateTime time( QDateTime::currentDateTime() );
    switch ( type )
    {
    case 1: return time.toString("yyyy-MM");
    case 2: return time.toString("yyyy-MM-dd");
    case 3: return time.toString("yyyy-MM-dd hh:mm:ss");
    case 4: return time.toString("yyyy-MM-dd_hh:mm:ss");
    case 5: return time.toString("yyyy-MM-dd-hh_mm_ss");
    case 6: return time.toString("yyyy-MM-dd_hh:mm:ss.zzz");
    default: return "";
    }
}

void GlobalFun::bsleep(int msecond)
{
    QTime timer;
    timer.start();

    while ( timer.elapsed() < msecond )
    {
        QCoreApplication::processEvents();  // 非阻塞延时 - 不停地处理事件，让程序保持响应
    }
}

void GlobalFun::grabWindow(QString path, QQuickWindow *window)
{
    QImage image = window->grabWindow();
    image.save(path);
}

int GlobalFun::getRand(int min, int max)
{
    return rand() % (max - min + 1) + min;
}

bool GlobalFun::inspectionDate(QString strDate, int restriction)
{
    QDate oldTime = QDate::fromString(strDate, "yyyy-MM-dd");
    QDate newTime = QDate::currentDate();
    qint64 day = oldTime.daysTo(newTime);

    if ( day <= restriction ) {
        return true;
    } else {
        return false;
    }
}

//------------------------------------------------------------------------------

bool GlobalFun::isDirExistStatic(const QString &path, bool onlyJud)
{
    QDir dir(path);

    if( dir.exists() ) {
        return true;
    } else {
        if ( onlyJud ) {
            return false;   // 仅仅判断，没有该文件夹返回错误
        } else {
            return dir.mkdir(path); // 没有文件夹时创建（只创建一级子目录，即必须保证上级目录存在）
        }
    }
}

bool GlobalFun::isFileExistStatic(const QString &fileName)
{
    QFileInfo fileInfo(fileName);
    return fileInfo.isFile();
}

bool GlobalFun::writeStatic(const QString &path, const QString &data)
{
    if ( path.isEmpty() ) {
        qDebug() << "The path is empty !";
        return false;
    }

    QFile file(path);
    if ( !file.open(QFile::WriteOnly | QFile::Truncate) ) {
        qDebug() << "Unable to open the file !";
        return false;
    }

    QTextStream out(&file);

    QStringList dataArray = data.split(",", QString::SkipEmptyParts);
    dataArray[0].remove(0, 1);
    dataArray[dataArray.size() - 1].remove(dataArray[dataArray.size() - 1].size() - 1, 1);

    out << "{" << endl;
    int i = 0;
    for ( ; i < dataArray.size() - 1; ++i )
    {
        out << dataArray[i] << "," << endl;
    }
    out << dataArray[i] << endl << "}" << endl;

    file.close();

    return true;
}

QString GlobalFun::getCurrentTimeStatic(int type)
{
    QDateTime time( QDateTime::currentDateTime() );
    switch ( type )
    {
    case 1: return time.toString("yyyy-MM");
    case 2: return time.toString("yyyy-MM-dd");
    case 3: return time.toString("yyyy-MM-dd hh:mm:ss");
    case 4: return time.toString("yyyy-MM-dd_hh:mm:ss");
    case 5: return time.toString("yyyy-MM-dd-hh_mm_ss");
    case 6: return time.toString("yyyy-MM-dd_hh:mm:ss.zzz");
    default: return "";
    }
}

void GlobalFun::grabWindowStatic(QString path, QQuickWindow *window)
{
    QImage image = window->grabWindow();
    image.save(path);
}

void GlobalFun::bsleepStatic(int msecond)
{
    QTime timer;
    timer.start();

    while ( timer.elapsed() < msecond )
    {
        QCoreApplication::processEvents();  // 非阻塞延时 - 不停地处理事件，让程序保持响应
    }
}

//------------------------------------------------------------------------------

QString GlobalFun::getTTF(int id)
{
    QString fileName = "";

    switch (id)
    {
    case 1: fileName = ":/ttf/BalooBhaina-Regular.ttf"; break;
    case 2: fileName = ":/ttf/BRUX.otf"; break;
    case 3: fileName = ":/ttf/Aldrich-Regular.ttf"; break;
    case 4: fileName = ":/ttf/Branch-zystoo.otf"; break;
    case 5: fileName = ":/ttf/Times_New_Roman.ttf"; break;
    default: fileName = "微软雅黑"; break;
    }

    int fontId = QFontDatabase::addApplicationFont(fileName);
    QString ttf = QFontDatabase::applicationFontFamilies(fontId).at(0);
    return ttf;
}
