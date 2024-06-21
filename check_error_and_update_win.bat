@echo off
:: Tắt echo để không hiển thị các lệnh trong quá trình chạy

echo Kiểm tra và sửa chữa các lỗi hệ thống...

:: Chạy System File Checker để kiểm tra và sửa chữa các tệp hệ thống bị hỏng
echo Đang kiểm tra các tệp hệ thống với SFC...
sfc /scannow

:: Kiểm tra kết quả của lệnh SFC
if %errorlevel% neq 0 (
    echo Đã xảy ra lỗi trong quá trình kiểm tra tệp hệ thống. Kiểm tra chi tiết trong file CBS.log.
) else (
    echo Kiểm tra tệp hệ thống hoàn tất. Không có lỗi hoặc đã được sửa chữa.
)

:: Sử dụng DISM để sửa chữa Windows image
echo Đang kiểm tra và sửa chữa Windows image với DISM...
DISM /Online /Cleanup-Image /ScanHealth

:: Kiểm tra kết quả của lệnh DISM ScanHealth
if %errorlevel% neq 0 (
    echo Đã xảy ra lỗi trong quá trình quét image. Kiểm tra chi tiết trong file CBS.log.
) else (
    echo Kiểm tra image hoàn tất. Không có lỗi hoặc đã được sửa chữa.
)

:: Sửa chữa Windows image nếu phát hiện lỗi
echo Đang sửa chữa Windows image với DISM...
DISM /Online /Cleanup-Image /RestoreHealth

:: Kiểm tra kết quả của lệnh DISM RestoreHealth
if %errorlevel% neq 0 (
    echo Đã xảy ra lỗi trong quá trình sửa chữa image. Kiểm tra chi tiết trong file CBS.log.
) else (
    echo Sửa chữa image hoàn tất.
)

:: Kiểm tra và cập nhật Windows
echo Đang kiểm tra và cập nhật Windows...
powershell.exe -Command "Install-Module PSWindowsUpdate -Force; Import-Module PSWindowsUpdate; Get-WindowsUpdate -AcceptAll -Install -AutoReboot"

:: Kiểm tra kết quả của lệnh cập nhật Windows
if %errorlevel% neq 0 (
    echo Đã xảy ra lỗi trong quá trình cập nhật Windows. Kiểm tra chi tiết trong Windows Update logs.
) else (
    echo Cập nhật Windows hoàn tất. Hệ thống sẽ khởi động lại nếu cần thiết.
)

echo Hoàn tất kiểm tra và sửa chữa các lỗi hệ thống.
pause