@echo off
rem NothingOS 5.0 for Pixel 9 Pro XL (komodo) - flasher
rem Run with the phone in BOOTLOADER mode (Power + Vol-) and connected via USB.
setlocal
cd /d "%~dp0"
where fastboot >nul 2>&1 || (echo fastboot not found. Put platform-tools in PATH or copy fastboot.exe here. & pause & exit /b 1)

echo == Checking device
fastboot getvar product 2>&1 | findstr /c:"product: komodo" >nul || (echo This is not a Pixel 9 Pro XL ^(komodo^) or it is not in bootloader mode. & pause & exit /b 1)
fastboot getvar version-bootloader 2>&1 | findstr /c:"ripcurrentpro-15.2-13237002" >nul || (
  echo WARNING: bootloader is not ripcurrentpro-15.2-13237002 ^(stock BP1A.250505.005^).
  echo Flash the BP1A.250505.005 factory image first ^(see README^).
  choice /m "Continue anyway"
  if errorlevel 2 exit /b 1
)

echo == Flashing vendor_boot + vbmeta (bootloader)
fastboot flash vendor_boot vendor_boot.img || goto :err
fastboot flash --disable-verity --disable-verification vbmeta vbmeta.img || goto :err

echo == Rebooting to fastbootd
fastboot reboot fastboot || goto :err
timeout /t 8 >nul
:wait
fastboot getvar is-userspace 2>&1 | findstr /c:"is-userspace: yes" >nul || (timeout /t 2 >nul & goto :wait)

echo == Flashing system images (fastbootd)
fastboot flash product product.img || goto :err
fastboot flash system system.img || goto :err
fastboot flash system_ext system_ext.img || goto :err

choice /m "Wipe data (REQUIRED when coming from stock or another ROM)"
if errorlevel 2 goto :reboot
fastboot -w || goto :err
:reboot
fastboot reboot
echo == Done. First boot takes 3-5 minutes.
pause
exit /b 0
:err
echo.
echo FLASH FAILED. Do not reboot, see README "Troubleshooting".
pause
exit /b 1
