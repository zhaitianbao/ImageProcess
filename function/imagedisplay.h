#ifndef SHOWIMAGEITEM_H
#define SHOWIMAGEITEM_H

#include <QQuickPaintedItem>
#include <QImage>
#include <QString>
#include <QMessageBox>
#include <QTextCodec>
#include <opencv2/opencv.hpp>
#include <string>
#include <vector>
using namespace std;

class ImageDisplay : public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(QRect m_rect READ getRect WRITE setRect NOTIFY rectChanged)
    Q_PROPERTY(QSize m_size READ getSize WRITE setSize NOTIFY sizeChanged)
    Q_PROPERTY(bool m_refresh READ getRefresh WRITE setRefresh NOTIFY refreshChanged)

public:
    explicit ImageDisplay(QQuickItem *parent = nullptr);

    QRect getRect() const { return m_rect; }
    void setRect(QRect rect) { m_rect = rect; emit rectChanged(); }

    QSize getSize() const { return m_size; }
    void setSize(QSize size) { m_size = size; emit sizeChanged();}

    bool getRefresh() const { return m_refresh; }
    void setRefresh(bool refresh) { m_refresh = refresh; emit refreshChanged();}

    Q_INVOKABLE void updateImage(QImage image);
    Q_INVOKABLE void updateImage(QString url);
    Q_INVOKABLE void imagesketch(QString url,int size=10);
    Q_INVOKABLE void imagegray(QString url);
    Q_INVOKABLE void imageresize(QString url,int fx=0,int fy=0,int type=1);
    Q_INVOKABLE void imagesplicing(QString url1,QString url2,QString url3,QString url4,int type);

    Q_INVOKABLE void imageeclosion(QString url,int fx=0,int fy=0,float level=0.5);
    Q_INVOKABLE void imagefilter(QString url,int type=0);
    Q_INVOKABLE void imagecomicstrip(QString url);

    Q_INVOKABLE void updateImageList(QList<QImage> list);
    Q_INVOKABLE void updateSize();
    Q_INVOKABLE void showImageInIndex(int index);
    Q_INVOKABLE void saveImage(QString path, QString name, QString type);

protected:
    void paint(QPainter *painter) override;

signals:
    void rectChanged();
    void sizeChanged();
    void refreshChanged();

private:
    QImage m_image;
    QImage result_image;
    QList<QImage> m_imageList;

    QRect m_rect;
    QSize m_size;
    bool m_refresh;
};

#endif // SHOWIMAGEITEM_H
