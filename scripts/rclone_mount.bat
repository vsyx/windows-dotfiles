@echo off
ping www.google.com -n 1 -w 1000 > nul

if errorlevel 1 (
    echo "No internet connection" 1>&2
    exit /b 1
)

SETLOCAL
set remote=onedrive_venta_rclone
set remote_dir=rclone_mount
set target_dir=%USERPROFILE%\Sync

rclone mount %remote%:%remote_dir% %target_dir% ^
	-v ^
	--dir-cache-time 1000h ^
	--poll-interval 15s ^
	--vfs-cache-mode full ^
	--vfs-cache-max-size 1G ^
	--vfs-cache-max-age 168h
ENDLOCAL
