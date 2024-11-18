@echo off

:: ffmpeg 无损合并脚本
:: zyyme 20240324
:: v2

:: 切换utf-8和支持 !!
chcp 65001
setlocal enabledelayedexpansion

:: ffmpeg程序路径配置
set "ffmpeg=ffmpeg.exe"

:: 检查是否有输入文件
if "%~1"=="" (
    echo 将文件按顺序选中后拖到脚本上来进行合并
    pause
    goto :eof
)

:: 提取第一个文件的文件名和扩展名
for %%A in ("%~1") do set "fileName=%%~nA"
for %%A in ("%~1") do set "ext=%%~xA"

:: 提取最后一个文件的文件名
for %%A in (%*) do set "lastFile=%%A"
for %%A in ("%lastFile%") do set "fileNameLast=%%~nA"

:: 按下划线分割最后一个文件名并取最后一个部分
set "lastPart="
for %%A in ("%fileNameLast:_=" "%") do (
    set "lastPart=%%A"
)

:: 最后一部分时间拼接到输出文件名
if defined lastPart (
    set "outputFile=%fileName%_%lastPart%"
) else (
    set "outputFile=%fileName%"
)

:: 后缀名
set "outputFile=%outputFile%-%ext%"

:: 创建一个临时的文件列表
set "listFile=%~dp0files.txt"
if exist "!listFile!" del "!listFile!"

:: 生成文件列表
:loop
if "%~1"=="" goto :endloop
echo file '%~f1' >> "!listFile!"
shift
goto :loop
:endloop

:: 使用ffmpeg合并视频
%ffmpeg% -f concat -safe 0 -i "!listFile!" -c copy "%~dp0!outputFile!" || (
    echo 出现错误，请检查ffmpeg路径配置是否正确
    pause
)

:: 清理临时文件
if exist "!listFile!" del "!listFile!"

endlocal