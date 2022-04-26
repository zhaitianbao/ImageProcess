@echo off

md %USERPROFILE%\Desktop\Test

<<<<<<< HEAD
copy ..\build-ImageProcessZTB-Desktop_Qt_5_12_8_MSVC2017_64bit-Release\ImageProcessZTB.exe %USERPROFILE%\Desktop\Test\

xcopy .\64_release\* %USERPROFILE%\Desktop\Test\ /s /e /c /y /h /r

cd /d %USERPROFILE%\Desktop\Test

windeployqt ImageProcessZTB.exe --qmldir F:\qt5.12\QT\5.12.8\msvc2017_64\qml
=======
copy ..\build-ImageProcessZTB-Desktop_Qt_5_12_9_MSVC2017_64bit-Release\ImageProcessZTB.exe %USERPROFILE%\Desktop\Test\

xcopy .\64_release\ %USERPROFILE%\Desktop\Test\ /s /e /c /y /h /r

cd /d %USERPROFILE%\Desktop\Test

windeployqt ImageProcessZTB.exe --qmldir D:\Qt\5.12.9\msvc2017_64\qml
>>>>>>> d528f27294b42d2b72cc81f258c0c18b721909d2
