@echo off

:: ffmpeg 无损剪辑脚本
:: zyyme 202400407
:: v2.0

:: 切换utf-8和支持 !!
chcp 65001
setlocal enabledelayedexpansion

:: ffmpeg程序路径配置
set "ffmpeg=ffmpeg.exe"

:: 检查是否有输入文件
if "%~1"=="" (
    echo 将文件拖到脚本上来进行剪辑
    pause
    goto :eof
)

set "input_file=%~1"

:: 提取文件的文件名和扩展名
for %%F in ("%input_file%") do (
    set "filename=%%~nF"
    set "extension=%%~xF"
)

set /p start_time="请输入开始时间（格式：HH:MM:SS，留空从头开始）: "

:: 如果开始时间为空，则设为0:00
if "%start_time%"=="" (
    set "start_time=00-00-00"
    set "ss_option="
) else (
    :: 将开始时间中的冒号替换为破折号
    set "ss_option=-ss %start_time%"
    set "start_time=!start_time::=-!"
)

set /p end_time="请输入结束时间（格式：HH:MM:SS，留空直到结尾）: "

:: 如果结束时间为空，则获取视频总时长
if "%end_time%"=="" (
    for /f "tokens=1-4 delims=:. " %%a in ('%ffmpeg% -i "%input_file%" 2^>^&1 ^| find "Duration"') do (
        set "end_time=%%b-%%c-%%d"
        set "to_option="
    )
) else (
    :: 将结束时间中的冒号替换为破折号
    set "to_option=-to %end_time%"
    set "end_time=!end_time::=-!"
)

:: 输出文件名
set "output_file=!filename!_!start_time!_!end_time!!extension!"


%ffmpeg% -i "%input_file%" %ss_option% %to_option% -c:v copy -c:a copy "%output_file%"


endlocal