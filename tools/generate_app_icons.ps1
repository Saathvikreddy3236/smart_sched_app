$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

function Save-ResizedPng {
  param(
    [System.Drawing.Image]$Source,
    [int]$Size,
    [string]$Path
  )

  $target = New-Object System.Drawing.Bitmap $Size, $Size
  $graphics = [System.Drawing.Graphics]::FromImage($target)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $graphics.Clear([System.Drawing.Color]::Transparent)
  $graphics.DrawImage($Source, 0, 0, $Size, $Size)
  $target.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $graphics.Dispose()
  $target.Dispose()
}

function Save-Ico {
  param(
    [System.Drawing.Image]$Source,
    [string]$Path
  )

  $iconBitmap = New-Object System.Drawing.Bitmap 256, 256
  $graphics = [System.Drawing.Graphics]::FromImage($iconBitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $graphics.Clear([System.Drawing.Color]::Transparent)
  $graphics.DrawImage($Source, 0, 0, 256, 256)
  $handle = $iconBitmap.GetHicon()
  $icon = [System.Drawing.Icon]::FromHandle($handle)
  $stream = [System.IO.File]::Create($Path)
  $icon.Save($stream)
  $stream.Dispose()
  $icon.Dispose()
  $graphics.Dispose()
  $iconBitmap.Dispose()
}

$root = Split-Path -Parent $PSScriptRoot
$sourcePath = Join-Path $root "assets/logo.png"

if (-not (Test-Path $sourcePath)) {
  throw "Source logo not found at $sourcePath"
}

$source = [System.Drawing.Image]::FromFile($sourcePath)

$targets = @(
  @{ Path = "android/app/src/main/res/mipmap-mdpi/ic_launcher.png"; Size = 48 },
  @{ Path = "android/app/src/main/res/mipmap-hdpi/ic_launcher.png"; Size = 72 },
  @{ Path = "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png"; Size = 96 },
  @{ Path = "android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png"; Size = 144 },
  @{ Path = "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png"; Size = 192 },
  @{ Path = "web/favicon.png"; Size = 64 },
  @{ Path = "web/icons/Icon-192.png"; Size = 192 },
  @{ Path = "web/icons/Icon-512.png"; Size = 512 },
  @{ Path = "web/icons/Icon-maskable-192.png"; Size = 192 },
  @{ Path = "web/icons/Icon-maskable-512.png"; Size = 512 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png"; Size = 20 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png"; Size = 40 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png"; Size = 60 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png"; Size = 29 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png"; Size = 58 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png"; Size = 87 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png"; Size = 40 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png"; Size = 80 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png"; Size = 120 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png"; Size = 120 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png"; Size = 180 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png"; Size = 76 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png"; Size = 152 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png"; Size = 167 },
  @{ Path = "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png"; Size = 1024 },
  @{ Path = "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png"; Size = 16 },
  @{ Path = "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png"; Size = 32 },
  @{ Path = "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png"; Size = 64 },
  @{ Path = "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png"; Size = 128 },
  @{ Path = "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png"; Size = 256 },
  @{ Path = "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png"; Size = 512 },
  @{ Path = "macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png"; Size = 1024 }
)

foreach ($target in $targets) {
  $absolutePath = Join-Path $root $target.Path
  Save-ResizedPng -Source $source -Size $target.Size -Path $absolutePath
}

$windowsIconPath = Join-Path $root "windows/runner/resources/app_icon.ico"
Save-Ico -Source $source -Path $windowsIconPath

$source.Dispose()
Write-Output "Generated app icons from assets/logo.png."
