# CHANGELOG

## v1.0 (2026-11-03)

```
[База]
- Nothing OS 5.0 (Nothing Phone 3, C5.0-260924-2115, Android 17)
- вендор: сток Pixel BP1A.250505.005 (Android 15)
- system / system_ext / product (EROFS lz4hc), полная пересборка с xattr/SELinux-метками
- vendor_boot: сток + fstab под EROFS-разделы Nothing
- vbmeta: сток, --disable-verity --disable-verification
- SELinux enforcing

[Bluetooth]
- звук в наушниках: стек Nothing (com.android.bt) слал Qualcomm VSC на A2DP offload,
  контроллер Pixel отклонял (status 12) → нет звука
- патч libbluetooth_jni.so: cbz→nop @0x641744 (start) / @0x63e5d8 (stop),
  offload идёт по пути AOSP 0xFD5D, как в стоке Pixel
- APEX переподписан (AVB hashtree SHA256_RSA4096 + APK v2)

[Камера]
- Pixel Camera (GCam) вшита в product/priv-app, все модули
- PixelCameraServices + 6 jar'ов и xml'ов камеры Pixel в system_ext
- EdgeTPU: vendor.google.edgetpu_app_service + VINTF, метка edgetpu_app_server_exec
- SELinux-домен google_camera_app (product_sepolicy + mapping 202404 + seapp_contexts)
- feature PIXEL_2019_EXPERIENCE, разрешения выданы заранее
- GCam стоит в доке по умолчанию (RRO лаунчера Nothing)
- Nothing Camera удалена (несовместима с HAL камеры Pixel)

[Система]
- статус-бар 66dp (RRO): верхние кнопки в TikTok и др. нажимаются
- RRO выровнены (arsc 16K) и подписаны v2: устанавливаются все APK (targetSdk ≥ 30)
- свежий mtime в EROFS: PackageManager не берёт старый кэш парсинга
- mediaserver 64-bit (у Tensor G4 нет AArch32)
- вибрация через стоковый HAL (бит RichTap выключен)
- падение system_server при зарядке (richtap): /vendor/etc overlay
- рингтоны и звуки Nothing, процессор и модель в «О телефоне»
- Shannon IMS/RCS, RRO NFC и телефонии Pixel

[Работает]
- загрузка, UI Nothing, лаунчер, настройки
- отпечаток, NFC, LTE, Wi-Fi, Bluetooth со звуком
- Pixel Camera, зарядка, AOD, установка приложений

[Известные проблемы]
- нет разблокировки по лицу
- VoLTE/VoWiFi не проверены
- спам BoostFramework/IPerf в logcat
- AOD местами дёргается

[Установка]
- flash-all.sh (Linux/macOS) / flash-all.bat (Windows)
- поверх стока BP1A.250505.005, вайп обязателен
- root не входит (KernelSU/Magisk через init_boot из стока)
```
