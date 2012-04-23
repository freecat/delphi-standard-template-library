@echo off
set /p name=test name: 
echo Compiling %name%\stl_%name%.cpp...
bcc32 %name%\stl_%name%.cpp
echo Compiling %name%\dstl_%name%.pas...
dcc32 %name%\dstl_%name%.pas -U"../dcu"
copy %name%\dstl_%name%.exe dstl_%name%.exe
del %name%\dstl_%name%.exe
pause