#include "imagedisplay.h"
#include <QPainter>
#include "imageprocess.h"

ImageDisplay::ImageDisplay(QQuickItem *parent) : QQuickPaintedItem(parent)
{

}

void ImageDisplay::updateImageList(QList<QImage> list)
{
    m_imageList = list;
    updateImage(m_imageList.at(0));
}

void ImageDisplay::updateImage(QImage image)
{
    m_image = image;

    // 图像过曝检测
    ImageProcess::overExposure(m_image);

    if ( !getRefresh() ) {
        updateSize();
    }

    update();
}

void ImageDisplay::updateImage(QString url)
{
    QString temp=url.mid(9,url.size()-10);
    m_image.load(temp);
    result_image=m_image;
    update();
}

void ImageDisplay::imagesketch(QString url,int size)
{
    QString temp=url.mid(9,url.size()-10);
    cv::Mat im=cv::imread(temp.toStdString(),0);
    cv::Mat result=ImageProcess::ImageSketch(im,size);
    m_image = ImageProcess::convertMatToQImage(result);
    result_image=m_image;
    update();
}

void ImageDisplay::updateSize()
{
    if ( m_image.isNull() ) {
        setRect( QRect(0, 0, this->width(), this->height()) );
        setSize( QSize(width(), height()) );
        return;
    }

    double factor_w = (double) m_image.width() / this->width();
    double factor_h =  (double) m_image.height() / this->height();
    double factor = factor_w > factor_h ? factor_w : factor_h;
    int W = m_image.width() / factor;
    int H = m_image.height() / factor;
    int X = (this->width() - W) / 2;
    int Y = (this->height() - H) / 2;
    setRect(QRect(X, Y, W, H));
	setSize(m_image.size());
}

void ImageDisplay::showImageInIndex(int index)
{
    if ( index >= 0 && index < m_imageList.size() )
    {
        updateImage(m_imageList.at(index));
    }
}

void ImageDisplay::paint(QPainter *painter)
{
    if ( !painter->isActive() || m_rect.isNull() ) {
        return;
    }

    painter->drawImage(m_rect, m_image);
}

void ImageDisplay::saveImage(QString path, QString name, QString type)
{
    QString filename=path+"/"+QString("%1.%2").arg(name).arg(type);
    result_image.save(filename);
}
