#ifndef IMAGEPROCESS_H
#define IMAGEPROCESS_H
#include <QObject>
#include <QDebug>
#include <QQuickWindow>
#include <QFontDatabase>
#include <QBuffer>

#include <iostream>
#include <opencv2/opencv.hpp>
#include <vector>
using namespace std;
using namespace cv;

class ImageProcess : public QObject
{
public:
    explicit ImageProcess(QObject *parent = 0);

    // QImage 转 cv::Mat
    static cv::Mat convertQImageToMat(QImage &image);

    // cv::Mat 转 QImage
    static QImage convertMatToQImage(const cv::Mat mat);

    // 对算法中获取的 mat 做数据处理，使其可以在界面上显示，CV_32FC1 转 CV_8UC3
    static cv::Mat dataProcessing(cv::Mat mat, bool state = false);

    // 判断图像是否为空
    static bool judVecAvailable(std::vector<cv::Mat> vec);

    // BGR 转 GRAY
    static std::vector<cv::Mat> cvtBGR2GRAY(const std::vector<cv::Mat> &vec, cv::Rect rect = cv::Rect(), bool state = false);

    // QImage 转 Base64
    static QString convertImageToBase64(const QImage& img);

    // Base64 转 QImage
    static QImage convertBase64ToImage(const QString& str);

    // 图像过曝检测
    static void overExposure(QImage &image);

    // 删除二值图像中面积小于设置像素值的对象
    static void bwareaopen(cv::Mat src, cv::Mat &dst, double min_area);

    // 获取中心点的坐标（在整张图中）
    static void getCenterPoint(cv::Mat ori, int &px, int &py);

    // 图像素描化
    static cv::Mat ImageSketch(QImage src,int size=10);

    // 图像尺寸调整
    static cv::Mat ImageReasize(QImage src,int fx=0,int fy=0,int type=1);

    // 图像组合
    static cv::Mat ImageSplicing(QVector<cv::Mat> images,int type);
};

#endif // IMAGEPROCESS_H
