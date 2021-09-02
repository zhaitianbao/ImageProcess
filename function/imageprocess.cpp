#include "imageprocess.h"

ImageProcess::ImageProcess(QObject *parent) : QObject(parent)
{

}

cv::Mat ImageProcess::convertQImageToMat(QImage &image)
{
    cv::Mat mat;
    switch( image.format() )
    {
    case QImage::Format_ARGB32:
    case QImage::Format_RGB32:
    case QImage::Format_ARGB32_Premultiplied:
        mat = cv::Mat(image.height(), image.width(), CV_8UC4, (void*)image.constBits(), image.bytesPerLine());
        break;
    case QImage::Format_RGB888:
        mat = cv::Mat(image.height(), image.width(), CV_8UC3, (void*)image.constBits(), image.bytesPerLine());
        cv::cvtColor(mat, mat, cv::COLOR_BGR2RGB);
        break;
    case QImage::Format_Indexed8:
        mat = cv::Mat(image.height(), image.width(), CV_8UC1, (void*)image.constBits(), image.bytesPerLine());
        break;
    case QImage::Format_Grayscale8:
        mat = cv::Mat(image.height(), image.width(), CV_8UC1, (void*)image.constBits(), image.bytesPerLine());
        break;
    default: mat = cv::Mat(); break;
    }

    return mat.clone();
}

QImage ImageProcess::convertMatToQImage(const cv::Mat mat)
{
    if ( mat.type() == CV_8UC1 )
    {
        QImage image(mat.cols, mat.rows, QImage::Format_Indexed8);

        // Set the color table (used to translate colour indexes to qRgb values)
        image.setColorCount(256);
        for ( int i = 0; i < 256; ++i )
        {
            image.setColor(i, qRgb(i, i, i));
        }

        // Copy input Mat
        uchar *pSrc = mat.data;
        for ( int row = 0; row < mat.rows; ++row )
        {
            uchar *pDest = image.scanLine(row);
            memcpy(pDest, pSrc, mat.cols);
            pSrc += mat.step;
        }

        return image;
    }

    else if ( mat.type() == CV_8UC3 )
    {
        // Copy input Mat
        const uchar *pSrc = (const uchar*)mat.data;
        // Create QImage with same dimensions as input Mat
        QImage image(pSrc, mat.cols, mat.rows, (int)mat.step, QImage::Format_RGB888);
        return image.rgbSwapped();
    }

    else if ( mat.type() == CV_8UC4 )
    {
        // Copy input Mat
        const uchar *pSrc = (const uchar*)mat.data;
        // Create QImage with same dimensions as input Mat
        QImage image(pSrc, mat.cols, mat.rows, (int)mat.step, QImage::Format_RGB32);
        return image.copy();
    }

    else
    {
        qDebug() << "ERROR: Mat could not be converted to QImage.";
        return QImage();
    }
}

cv::Mat ImageProcess::dataProcessing(cv::Mat mat, bool state)
{
    double minV = 0, maxV = 0;
    cv::Mat temp = mat.clone();     // clone mat

    cv::Mat tmpMask = temp == temp; // 不相等为0，相等为1（nan与nan不相等）

    cv::minMaxIdx(temp, &minV, &maxV, nullptr, nullptr, temp == temp);  // 找出最小、最大值
    if (abs(maxV - minV) > 0.00000001) {
        temp = (temp - minV) / (maxV - minV) * 255;     // 数值在0~255之间
    }

    temp.convertTo(temp, CV_8UC1);
    cv::applyColorMap(temp, temp, cv::COLORMAP_JET);

    if ( state ) {
        temp.setTo(cv::Vec3b(255, 255, 255), ~tmpMask);
    } else {
        temp.setTo(nan(""), ~tmpMask);
    }
    return temp;
}

bool ImageProcess::judVecAvailable(std::vector<cv::Mat> vec)
{
    if ( vec.size() == 0 ) {
        return false;
    }

    for ( auto &temp: vec )
    {
        if ( temp.empty() ) {
            return false;
        }
    }

    return true;
}

QString ImageProcess::convertImageToBase64(const QImage& img)
{
    QByteArray array;
    QBuffer buffer(&array);
    buffer.open(QIODevice::WriteOnly);

    img.save(&buffer, "PNG");
    QByteArray array64 = array.toBase64();
    QString str = QString::fromLatin1(array64);

    return str;
}

QImage ImageProcess::convertBase64ToImage(const QString& str)
{
    QImage img;
    QByteArray array = str.toLatin1();
    img.loadFromData(QByteArray::fromBase64(array));

    return img;
}

std::vector<cv::Mat> ImageProcess::cvtBGR2GRAY(const std::vector<cv::Mat> &vec, cv::Rect rect, bool state)
{
    std::vector<cv::Mat> ret;

    for ( auto &temp : vec )
    {
        if ( temp.empty() ) {
            qDebug() << "Image is empty !";
            ret.push_back(cv::Mat());
        } else {
            cv::Mat gray;
            cvtColor(temp, gray, cv::COLOR_BGR2GRAY);   // 转换为灰度图像
            gray.convertTo(gray, CV_32FC1);             // C1数据类型转换为32F
            if ( state ) {
                ret.push_back(gray(rect));
            } else {
                ret.push_back(gray);
            }
        }
    }

    return ret;
}

void ImageProcess::overExposure(QImage &image)
{
//    DWORD start_time = GetTickCount();

    unsigned char *data = image.bits();
    int width = image.width();
    int height = image.height();

    if ( image.format() == QImage::Format_RGB32 )
    {
        for ( int i = 0; i < width; ++i )
        {
            for ( int j = 0; j < height; ++j )
            {
                if ( *data >= 254 && *(data + 1) >= 254 && *(data + 2) >= 254 )
                {
                    *data = 0;
                    *(data + 1) = 0;
                }
                data += 4;
            }
        }
    }
    else if ( image.format() == QImage::Format_RGB888 )
    {
        for ( int i = 0; i < width; ++i )
        {
            for ( int j = 0; j < height; ++j )
            {
                if ( *data >= 254 && *(data + 1) >= 254 && *(data + 2) >= 254 )
                {
                    *(data + 1) = 0;
                    *(data + 2) = 0;
                }
                data += 3;
            }
        }
    }

//    DWORD end_time = GetTickCount();
//    std::cout << "times = " << end_time - start_time << std::endl;
}

void ImageProcess::bwareaopen(cv::Mat src, cv::Mat &dst, double min_area)
{
    dst = src.clone();
    std::vector<std::vector<cv::Point> >  contours;
    std::vector<cv::Vec4i>    hierarchy;

    cv::findContours(src, contours, hierarchy, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_NONE, cv::Point());
    if ( !contours.empty() && !hierarchy.empty() )
    {
        std::vector< std::vector<cv::Point> >::const_iterator itc = contours.begin();

        while ( itc != contours.end() )
        {
            cv::Rect rect = cv::boundingRect( cv::Mat(*itc) );
            double area = contourArea(*itc);

            if ( area < min_area ) {
                for ( int i = rect.y; i < rect.y + rect.height; ++i )
                {
                    uchar *output_data = dst.ptr<uchar>(i);
                    for ( int j = rect.x; j < rect.x + rect.width; ++j )
                    {
                        if ( output_data[j] == 255 ) {
                            output_data[j] = 0;
                        }
                    }
                }
            }
            ++itc;
        }
    }
}

void ImageProcess::getCenterPoint(cv::Mat ori, int &px, int &py)
{
    // 保存原图大小
    int ox = ori.cols/2;
    int oy = ori.rows/2;

    // 取图像中心 100x100
    cv::Mat dst = ori(cv::Range(ori.rows/2 - 50, ori.rows/2 + 50), cv::Range(ori.cols/2 - 50, ori.cols/2 + 50));

    // 转化成灰度图像并进行平滑处理
    cv::Mat src_gray;
    cvtColor(dst, src_gray, cv::COLOR_BGR2GRAY);
    blur(src_gray, src_gray, cv::Size(3,3));

    // 阈值化
    cv::Mat threshold_output;
    cv::Mat src_nor;
    cv::normalize(src_gray, src_nor, 255, 0, cv::NORM_MINMAX);
    threshold(src_nor, threshold_output, 250, 255, cv::THRESH_BINARY); // 像素值小于100变成0，大于100变成255

    int rowt = threshold_output.rows;
    int colt = threshold_output.cols;
    float sumx = 0.0f;
    float sumy = 0.0f;
    int number = 0;

    for ( int i = 0; i < rowt; ++i )
    {
        uchar *m = threshold_output.ptr<uchar>(i);
        for ( int j = 0; j < colt; ++j )
        {
            if ( m[j] == 255 )
            {
                sumx += static_cast<float>(j);
                sumy += static_cast<float>(i);
                number++;
            }
        }
    }

    cv::Point Target_center;
    Target_center.x = int(sumx/number);
    Target_center.y = int(sumy/number);
    px = Target_center.x + ox - dst.cols/2;
    py = Target_center.y + oy - dst.rows/2;
}

cv::Mat ImageProcess::ImageSketch(QImage src,int size)
{
    cv::Mat ori=convertQImageToMat(src);
    Mat blur;
    GaussianBlur(ori, blur, Size(2*size+1, 2*size+1), 0, 0);

    // 提取纹理
    Mat veins;
    divide(ori, blur, veins, 255);

    // 加深处理
    Mat deepenb, deepena;
    divide(255-veins, blur, deepenb, 255);
    deepena = 255 - deepenb;

    return deepena;

}

cv::Mat ImageProcess::ImageReasize(QImage src,int fx,int fy,int type)
{
    cv::Mat ori=convertQImageToMat(src);
    Mat result;
    cv::resize(ori, result, cv::Size(0, 0), fx, fy, type);
    return result;
}

 cv::Mat ImageProcess::ImageSplicing(QVector<cv::Mat> images,int type)
 {
     if (type != 0 && type != 1)
         type = 0;

     int num = images.size();
     int newrow = 0;
     int newcol = 0;
     cv::Mat result;

     // 横向拼接
     if (type == 0)
     {
         int minrow = 10000;
         for (int i = 0; i < num; ++i)
         {
             if (minrow > images[i].rows)
                 minrow = images[i].rows;
         }
         newrow = minrow;
         for (int i = 0; i < num; ++i)
         {
             int tcol = images[i].cols*minrow / images[i].rows;
             int trow = newrow;
             cv::resize(images[i], images[i], cv::Size(tcol, trow));
             newcol += images[i].cols;
             if (images[i].type() != images[0].type())
                 images[i].convertTo(images[i], images[0].type());
         }
         result = cv::Mat(newrow, newcol, images[0].type(), cv::Scalar(255, 255, 255));

         cv::Range rangerow, rangecol;
         int start = 0;
         for (int i = 0; i < num; ++i)
         {
             rangerow = cv::Range((newrow - images[i].rows) / 2, (newrow - images[i].rows) / 2 + images[i].rows);
             rangecol = cv::Range(start, start + images[i].cols);
             images[i].copyTo(result(rangerow, rangecol));
             start += images[i].cols;
         }
     }
     // 纵向拼接
     else if (type == 1) {
         int mincol = 10000;
         for (int i = 0; i < num; ++i)
         {
             if (mincol > images[i].cols)
                 mincol = images[i].cols;
         }
         newcol = mincol;
         for (int i = 0; i < num; ++i)
         {
             int trow = images[i].rows*mincol / images[i].cols;
             int tcol = newcol;
             cv::resize(images[i], images[i], cv::Size(tcol, trow));
             newrow += images[i].rows;
             if (images[i].type() != images[0].type())
                 images[i].convertTo(images[i], images[0].type());
         }
         result = cv::Mat(newrow, newcol, images[0].type(), cv::Scalar(255, 255, 255));

         cv::Range rangerow, rangecol;
         int start = 0;
         for (int i = 0; i < num; ++i)
         {
             rangecol= cv::Range((newcol - images[i].cols) / 2, (newcol - images[i].cols) / 2 + images[i].cols);
             rangerow = cv::Range(start, start + images[i].rows);
             images[i].copyTo(result(rangerow, rangecol));
             start += images[i].rows;
         }
     }

     return result;
 }

 cv::Mat ImageProcess::ImageEclosion(cv::Mat src, cv::Point center,float level)
 {
     CV_Assert(src.channels() == 3);
     if (level>0.9)
         level = 0.9f;
     float diff = (1-level) * (src.rows / 2 * src.rows / 2 + src.cols / 2 * src.cols / 2);
     cv::Mat result = src.clone();
     for (int i = 0; i < result.rows; ++i)
     {
         for (int j = 0; j < result.cols; ++j)
         {
             float dx = float(center.x - j);
             float dy = float(center.y - i);
             float ra = dx * dx + dy * dy;
             float m = ((ra-diff) / diff * 255)>0? ((ra - diff) / diff * 255):0;
             int b = result.at<Vec3b>(i, j)[0];
             int g = result.at<Vec3b>(i, j)[1];
             int r = result.at<Vec3b>(i, j)[2];
             b = (int)(b+ m);
             g = (int)(g + m);
             r = (int)(r + m);
             result.at<Vec3b>(i, j)[0] = (b > 255 ? 255 : (b < 0 ? 0 : b));
             result.at<Vec3b>(i, j)[1] = (g > 255 ? 255 : (g < 0 ? 0 : g));
             result.at<Vec3b>(i, j)[2] = (r > 255 ? 255 : (r < 0 ? 0 : r));
         }
     }
     return result;
 }

 cv::Mat ImageProcess::ImageNostalgic(cv::Mat src)
 {
     CV_Assert(src.channels() == 3);
     int row = src.rows;
     int col = src.cols;
     cv::Mat temp = src.clone();
     for (int i = 0; i < row; ++i)
     {
         uchar *s = src.ptr<uchar>(i);
         uchar *t = temp.ptr<uchar>(i);
         for (int j = 0; j < col; ++j)
         {
             int B = s[3 * j];
             int G = s[3 * j + 1];
             int R = s[3 * j + 2];
             // 怀旧调色
             float newB = 0.272f*R + 0.534f*G + 0.131f*B;
             float newG = 0.349f*R + 0.686f*G + 0.168f*B;
             float newR = 0.393f*R + 0.769f*G + 0.189f*B;
             if (newB < 0)
                 newB = 0;
             if (newB > 255)
                 newB = 255;
             if (newG < 0)
                 newG = 0;
             if (newG > 255)
                 newG = 255;
             if (newR < 0)
                 newR = 0;
             if (newR > 255)
                 newR = 255;
             t[3 * j] = (uchar)newB;
             t[3 * j + 1] = (uchar)newG;
             t[3 * j + 2] = (uchar)newR;
         }
     }
     return temp;
 }

 cv::Mat ImageProcess::ImageComicStrip(cv::Mat src)
 {
     CV_Assert(src.channels() == 3);
     int row = src.rows;
     int col = src.cols;
     cv::Mat temp = src.clone();
     for (int i = 0; i < row; ++i)
     {
         uchar *s = src.ptr<uchar>(i);
         uchar *t = temp.ptr<uchar>(i);
         for (int j = 0; j < col; ++j)
         {
             int B = s[3 * j];
             int G = s[3 * j + 1];
             int R = s[3 * j + 2];
             // 连环画效果
             int newB = abs(B - G + B + R)*R / 256;
             int newG = abs(B - G + B + R)*R / 256;
             int newR = abs(G - B + G + R)*R / 256;

             newR = max(0, min(newR, 255));
             newG = max(0, min(newG, 255));
             newB = max(0, min(newB, 255));

             int gray = (newR + newG + newB) / 3;

             int T = min(255, gray + 10);

             t[3 * j] = gray;
             t[3 * j + 1] = T;
             t[3 * j + 2] = T;
         }
     }
     return temp;
 }
