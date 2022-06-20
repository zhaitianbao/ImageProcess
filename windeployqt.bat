@echo off

md %USERPROFILE%\Desktop\Test

copy ..\build-ImageProcessZTB-Desktop_Qt_5_12_8_MSVC2017_64bit-Release\ImageProcessZTB.exe %USERPROFILE%\Desktop\Test\

xcopy .\64_release\ %USERPROFILE%\Desktop\Test\ /s /e /c /y /h /r

cd /d %USERPROFILE%\Desktop\Test

windeployqt ImageProcessZTB.exe --qmldir C:\Qt\Qt5.12.8\5.12.8\msvc2017_64\qml

