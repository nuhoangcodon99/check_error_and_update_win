# Chạy với quyền quản trị
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Script không chạy với quyền quản trị. Đang nâng quyền..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Output "Kiểm tra và sửa chữa các lỗi hệ thống..."

# Chạy System File Checker để kiểm tra và sửa chữa các tệp hệ thống bị hỏng
Write-Output "Đang kiểm tra các tệp hệ thống với SFC..."
$sfcResult = sfc /scannow

if ($sfcResult.ExitCode -ne 0) {
    Write-Output "Đã xảy ra lỗi trong quá trình kiểm tra tệp hệ thống. Kiểm tra chi tiết trong file CBS.log."
} else {
    Write-Output "Kiểm tra tệp hệ thống hoàn tất. Không có lỗi hoặc đã được sửa chữa."
}

# Sử dụng DISM để sửa chữa Windows image
Write-Output "Đang kiểm tra và sửa chữa Windows image với DISM..."
$scanHealthResult = DISM /Online /Cleanup-Image /ScanHealth

if ($scanHealthResult.ExitCode -ne 0) {
    Write-Output "Đã xảy ra lỗi trong quá trình quét image. Kiểm tra chi tiết trong file CBS.log."
} else {
    Write-Output "Kiểm tra image hoàn tất. Không có lỗi hoặc đã được sửa chữa."
}

Write-Output "Đang sửa chữa Windows image với DISM..."
$restoreHealthResult = DISM /Online /Cleanup-Image /RestoreHealth

if ($restoreHealthResult.ExitCode -ne 0) {
    Write-Output "Đã xảy ra lỗi trong quá trình sửa chữa image. Kiểm tra chi tiết trong file CBS.log."
} else {
    Write-Output "Sửa chữa image hoàn tất."
}

# Kiểm tra và cập nhật Windows
Write-Output "Đang kiểm tra và cập nhật Windows..."
Install-Module PSWindowsUpdate -Force
Import-Module PSWindowsUpdate
$updateResult = Get-WindowsUpdate -AcceptAll -Install -AutoReboot

if ($LASTEXITCODE -ne 0) {
    Write-Output "Đã xảy ra lỗi trong quá trình cập nhật Windows. Kiểm tra chi tiết trong Windows Update logs."
} else {
    Write-Output "Cập nhật Windows hoàn tất. Hệ thống sẽ khởi động lại nếu cần thiết."
}

Write-Output "Hoàn tất kiểm tra và sửa chữa các lỗi hệ thống."