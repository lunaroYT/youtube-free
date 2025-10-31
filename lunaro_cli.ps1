# lunaro_cli_software_downloader.ps1
Clear-Host
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Pause { Read-Host "`nPress Enter to return to menu" }

# List of popular applications with their official download URLs
$applications = @{
    "1"  = @{ Name = "Google Chrome"; URL = "https://dl.google.com/chrome/install/GoogleChromeStandaloneEnterprise64.msi" }
    "2"  = @{ Name = "Mozilla Firefox"; URL = "https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US" }
    "3"  = @{ Name = "Microsoft Edge"; URL = "https://go.microsoft.com/fwlink/p/?linkid=2093437" }
    "4"  = @{ Name = "VLC Media Player"; URL = "https://get.videolan.org/vlc/3.0.21/win64/vlc-3.0.21-win64.msi" }
    "5"  = @{ Name = "7-Zip"; URL = "https://www.7-zip.org/a/7z2301-x64.msi" }
    "6"  = @{ Name = "Adobe Acrobat Reader DC"; URL = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2300820084/AcroRdrDCx64230820084_en_US.msi" }
    "7"  = @{ Name = "Spotify"; URL = "https://download.scdn.co/SpotifyFullSetup.exe" }
    "8"  = @{ Name = "Discord"; URL = "https://discord.com/api/download?platform=win" }
    "9"  = @{ Name = "Telegram Desktop"; URL = "https://github.com/telegramdesktop/tdesktop/releases/download/v4.16.7/tsetup.4.16.7.exe" }
    "10" = @{ Name = "Zoom"; URL = "https://zoom.us/client/latest/ZoomInstallerFull.msi" }
    "11" = @{ Name = "WinRAR"; URL = "https://www.win-rar.com/fileadmin/winrar-6/x64/600winrar-x64-602es.exe" }
    "12" = @{ Name = "TeamViewer"; URL = "https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe" }
    "13" = @{ Name = "OBS Studio"; URL = "https://github.com/obsproject/obs-studio/releases/download/30.0.2/OBS-Studio-30.0.2-Full-Installer-x64.exe" }
    "14" = @{ Name = "GIMP"; URL = "https://download.gimp.org/mirror/pub/gimp/v2.10/windows/gimp-2.10.36-setup.exe" }
    "15" = @{ Name = "Notepad++"; URL = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.1/npp.8.6.1.Installer.x64.exe" }
    "16" = @{ Name = "Visual Studio Code"; URL = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64" }
    "17" = @{ Name = "Steam"; URL = "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe" }
    "18" = @{ Name = "LibreOffice"; URL = "https://download.documentfoundation.org/libreoffice/stable/24.2.5/win/x86_64/LibreOffice_24.2.5_Win_x64.msi" }
    "19" = @{ Name = "ShareX"; URL = "https://github.com/ShareX/ShareX/releases/download/v15.0.0/ShareX-15.0.0-setup.exe" }
    "20" = @{ Name = "PowerToys"; URL = "https://github.com/microsoft/PowerToys/releases/download/v0.81.1/PowerToysSetup-0.81.1-x64.exe" }
    "21" = @{ Name = "CPU-Z"; URL = "https://download.cpuid.com/cpu-z/cpu-z_2.09-en.msi" }
    "22" = @{ Name = "GPU-Z"; URL = "https://download.techpowerup.com/GPU-Z/GPU-Z.msi" }
    "23" = @{ Name = "NVIDIA GeForce Experience"; URL = "https://www.nvidia.com/content/driver/en-March/2024/geforce-experience-3.27.0.112-win10-win11-dch-64bit-international.exe" }
    "24" = @{ Name = "iTunes"; URL = "https://www.apple.com/itunes/download/win64" }
    "25" = @{ Name = "Paint.NET"; URL = "https://www.dotpdn.com/files/paint.net.4.3.13.install.anycpu.msi" }
    "26" = @{ Name = "Audacity"; URL = "https://github.com/audacity/audacity/releases/download/Audacity-3.4.2/audacity-win-3.4.2-64bit.exe" }
    "27" = @{ Name = "Blender"; URL = "https://download.blender.org/release/Blender4.1/blender-4.1.3-windows-x64.msi" }
    "28" = @{ Name = "Inkscape"; URL = "https://inkscape.org/gallery/item/37338/Inkscape-1.3.2_2024-01-23_dc2a832b-x64.msi" }
    "29" = @{ Name = "FileZilla"; URL = "https://download.filezilla-project.org/client/FileZilla_3.67.2_win64-setup.exe" }
    "30" = @{ Name = "PuTTY"; URL = "https://the.earth.li/~sgtatham/putty/latest/x86/putty-64bit-0.81-installer.msi" }
    "31" = @{ Name = "WinSCP"; URL = "https://winscp.net/download/WinSCP-6.3.4-Setup.exe" }
    "32" = @{ Name = "Epic Games Launcher"; URL = "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi" }
    "33" = @{ Name = "Microsoft Teams"; URL = "https://statics.teams.cdn.office.net/production-windows-x64/Teams-3.2.1.2855.msi" }
    "34" = @{ Name = "Skype"; URL = "https://get.skype.com/msi" }
    "35" = @{ Name = "Viber"; URL = "https://download.viber.com/desktop/ViberDesktop.exe" }
    "36" = @{ Name = "WhatsApp Desktop"; URL = "https://www.whatsapp.com/download" }
    "37" = @{ Name = "LINE"; URL = "https://desktop.line.me/dist/win/LineInst.exe" }
    "38" = @{ Name = "WeChat"; URL = "https://www.wechat.com/en/" }
    "39" = @{ Name = "CCleaner"; URL = "https://download.ccleaner.com/ccsetup644.exe" }
    "40" = @{ Name = "Malwarebytes"; URL = "https://data-cdn.mbamupdates.com/web/mb4-setup-online/MBSetup.exe" }
    "41" = @{ Name = "Avast Free Antivirus"; URL = "https://install.avastcdn.com/AvastFreeEditorSetup.exe" }
    "42" = @{ Name = "AVG Free Antivirus"; URL = "https://free.avg.com/en-us/download-free-antivirus" }
    "43" = @{ Name = "AnyDesk"; URL = "https://download.anydesk.com/AnyDesk.exe" }
    "44" = @{ Name = "Java 8 Runtime"; URL = "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=242990_3d5a2bb8a8c419e9a93cc545c210040f" }
    "45" = @{ Name = ".NET Framework 4.8"; URL = "https://go.microsoft.com/fwlink/?linkid=2088631" }
    "46" = @{ Name = "DirectX End-User Runtime"; URL = "https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-D2CC6493F64E/dxwebsetup.exe" }
    "47" = @{ Name = "Visual C++ 2015-2022 Redist"; URL = "https://aka.ms/vs/17/release/vc_redist.x64.exe" }
    "48" = @{ Name = "Microsoft WebView2"; URL = "https://go.microsoft.com/fwlink/p/?LinkId=2124703" }
}

function Download-Application {
    Clear-Host
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "             AVAILABLE APPLICATIONS TO DOWNLOAD" -ForegroundColor Yellow
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""

    $appsPerPage = 25
    $totalPages = [Math]::Ceiling($applications.Count / $appsPerPage)
    $currentPage = 1

    while ($true) {
        Clear-Host
        $startIndex = ($currentPage - 1) * $appsPerPage
        $endIndex = [Math]::Min($startIndex + $appsPerPage, $applications.Count)

        Write-Host "============================================================" -ForegroundColor Cyan
        Write-Host "             AVAILABLE APPLICATIONS TO DOWNLOAD" -ForegroundColor Yellow
        if ($totalPages -gt 1) {
            Write-Host "            (Page $currentPage of $totalPages)" -ForegroundColor Yellow
        }
        Write-Host "============================================================" -ForegroundColor Cyan
        Write-Host ""

        $maxNameLength = ($applications.Values | ForEach-Object { $_.Name.Length } | Measure-Object -Maximum).Maximum

        foreach ($key in ($applications.Keys | Sort-Object { [int]$_ })) {
            $keyNum = [int]$key
            if ($keyNum -gt $startIndex -and $keyNum -le $endIndex) {
                $name = $applications[$key].Name
                $paddedName = $name.PadRight($maxNameLength, ' ')
                Write-Host "  [$key]  $paddedName" -ForegroundColor Green
            }
        }

        Write-Host ""
        Write-Host "============================================================" -ForegroundColor Cyan
        Write-Host ""

        if ($totalPages -gt 1) {
            Write-Host "Commands: [N] Next Page | [P] Previous Page | [B] Back to Menu | [#] Select Number" -ForegroundColor Yellow
        } else {
            Write-Host "Commands: [B] Back to Menu | [#] Select Number" -ForegroundColor Yellow
        }

        $choice = Read-Host "Enter your choice"

        if ($choice -eq 'B' -or $choice -eq 'b') {
            Write-Host "`nReturning to main menu..." -ForegroundColor Cyan
            Start-Sleep -Milliseconds 500
            return
        }

        if ($choice -eq 'N' -or $choice -eq 'n') {
            if ($currentPage -lt $totalPages) {
                $currentPage++
                Write-Host "Moved to next page..." -ForegroundColor Cyan
                Start-Sleep -Milliseconds 300
            } else {
                Write-Host "Already on the last page." -ForegroundColor Yellow
            }
            continue
        }

        if ($choice -eq 'P' -or $choice -eq 'p') {
            if ($currentPage -gt 1) {
                $currentPage--
                Write-Host "Moved to previous page..." -ForegroundColor Cyan
                Start-Sleep -Milliseconds 300
            } else {
                Write-Host "Already on the first page." -ForegroundColor Yellow
            }
            continue
        }

        # Check if it's a valid application number
        if ($applications.ContainsKey($choice)) {
            break
        } else {
            Write-Host "Invalid choice. Please enter a valid number or command." -ForegroundColor Red
        }
    }

    $app = $applications[$choice]
    $appName = $app.Name
    $appUrl = $app.URL

    Write-Host "`nSelected: $appName" -ForegroundColor Cyan
    $confirm = Read-Host "Download this application? (Y/N)"
    if ($confirm -ne 'Y' -and $confirm -ne 'y') {
        Write-Host "Download cancelled." -ForegroundColor Yellow
        Pause
        return
    }

    Write-Host "`nDownloading $appName..." -ForegroundColor Magenta

    try {
        # Get the Desktop path and create "Terminal Downloads" folder
        $desktop = [Environment]::GetFolderPath("Desktop")
        $downloadFolder = Join-Path $desktop "Terminal Downloads"

        # Create folder if it doesn't exist
        if (-not (Test-Path $downloadFolder)) {
            New-Item -ItemType Directory -Path $downloadFolder -Force | Out-Null
            Write-Host "Created folder: Terminal Downloads" -ForegroundColor Green
        }

        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $filename = "$($appName.Replace(' ', '_'))_${timestamp}.exe"

        # For .msi files, also change extension
        if ($appUrl -match "\.msi") {
            $filename = "$($appName.Replace(' ', '_'))_${timestamp}.msi"
        }

        $outputPath = Join-Path $downloadFolder $filename

        Write-Host "Saving to: Terminal Downloads on Desktop" -ForegroundColor Cyan
        Write-Host "File: $filename" -ForegroundColor Yellow
        Write-Host ""

        # Download the file with feedback
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")

        Write-Host "Starting download..." -ForegroundColor Magenta
        Write-Host ""

        # Simple download with spinner
        $spinnerChars = @('|', '/', '-', '\')
        $spinnerIndex = 0

        $downloadJob = {
            param($url, $path)
            $client = New-Object System.Net.WebClient
            $client.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
            $client.DownloadFile($url, $path)
        }

        $job = Start-Job -ScriptBlock $downloadJob -ArgumentList $appUrl, $outputPath

        # Show spinner while downloading
        while ($job.State -eq 'Running') {
            $spinnerChar = $spinnerChars[$spinnerIndex % $spinnerChars.Length]
            Write-Host "`r$spinnerChar Downloading $appName..." -ForegroundColor Cyan -NoNewline
            $spinnerIndex++
            Start-Sleep -Milliseconds 100
        }

        # Clear the spinner line
        Write-Host ""

        # Check if job completed successfully
        Receive-Job -Job $job | Out-Null
        if ($job.State -ne 'Completed') {
            Remove-Job -Job $job -Force
            throw "Download failed"
        }
        Remove-Job -Job $job -Force

        # Verify the downloaded file is valid
        if (-not (Test-Path $outputPath)) {
            throw "Downloaded file not found"
        }

        $fileInfo = Get-Item $outputPath
        $fileSizeKB = [math]::Round($fileInfo.Length / 1KB, 2)

        # Check if file is too small (likely an error page or redirect)
        if ($fileInfo.Length -lt 10KB -and ($fileInfo.Extension -eq ".exe" -or $fileInfo.Extension -eq ".msi")) {
            Remove-Item $outputPath -Force -ErrorAction SilentlyContinue
            throw "Downloaded file is too small ($fileSizeKB KB). The URL might have redirected to an error page or login page."
        }

        Write-Host "`n[OK] Download completed successfully!" -ForegroundColor Green
        Write-Host "Location: $outputPath" -ForegroundColor Green
        Write-Host "Size: $fileSizeKB KB" -ForegroundColor Green
        Write-Host ""
        Write-Host "TIP: Navigate to Desktop -> Terminal Downloads to find your file." -ForegroundColor Cyan
        Write-Host "     You may need to run the installer as Administrator." -ForegroundColor Yellow
    } catch {
        # Clear spinner if it was running
        Write-Host ""

        Write-Host "`n[ERROR] Error downloading file: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Possible reasons:" -ForegroundColor Yellow
        Write-Host "  1. Network connection issue" -ForegroundColor Gray
        Write-Host "  2. URL redirected or invalid" -ForegroundColor Gray
        Write-Host "  3. Antivirus blocking the download" -ForegroundColor Gray
        Write-Host "  4. File not available at this URL" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Try:" -ForegroundColor Yellow
        Write-Host "  - Checking your internet connection" -ForegroundColor Gray
        Write-Host "  - Trying a different application" -ForegroundColor Gray
        Write-Host "  - Disabling antivirus temporarily" -ForegroundColor Gray
        Write-Host "  - Manually downloading from the official website" -ForegroundColor Gray
    }

    Pause
}

function Search-Applications {
    Clear-Host
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "               SEARCH APPLICATIONS" -ForegroundColor Yellow
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""

    $searchTerm = Read-Host "Enter application name to search"

    if ([string]::IsNullOrWhiteSpace($searchTerm)) {
        Write-Host "No search term entered." -ForegroundColor Yellow
        Pause
        return
    }

    Write-Host ""
    Write-Host "Searching for: '$searchTerm'" -ForegroundColor Cyan
    Write-Host ""

    $foundApps = @()

    foreach ($key in $applications.Keys) {
        $app = $applications[$key]
        if ($app.Name -like "*$searchTerm*") {
            $foundApps += @{ Key = $key; Name = $app.Name; URL = $app.URL }
        }
    }

    if ($foundApps.Count -eq 0) {
        Write-Host "[INFO] No applications found matching your search." -ForegroundColor Yellow
        Pause
        return
    }

    Write-Host "Found $($foundApps.Count) application(s):" -ForegroundColor Green
    Write-Host ""

    foreach ($app in $foundApps) {
        Write-Host "  [$($app.Key)] $($app.Name)" -ForegroundColor White
    }

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan

    $confirm = Read-Host "Do you want to download one of these? (Y/N)"
    if ($confirm -ne 'Y' -and $confirm -ne 'y') {
        Pause
        return
    }

    $appNumber = Read-Host "Enter the number of the application to download"

    if (-not $applications.ContainsKey($appNumber)) {
        Write-Host "Invalid selection." -ForegroundColor Red
        Pause
        return
    }

    $app = $applications[$appNumber]
    $appName = $app.Name
    $appUrl = $app.URL

    Write-Host "`nSelected: $appName" -ForegroundColor Cyan
    $confirmDownload = Read-Host "Download this application? (Y/N)"
    if ($confirmDownload -ne 'Y' -and $confirmDownload -ne 'y') {
        Write-Host "Download cancelled." -ForegroundColor Yellow
        Pause
        return
    }

    Write-Host "`nDownloading $appName..." -ForegroundColor Magenta

    try {
        # Get the Desktop path and create "Terminal Downloads" folder
        $desktop = [Environment]::GetFolderPath("Desktop")
        $downloadFolder = Join-Path $desktop "Terminal Downloads"

        # Create folder if it doesn't exist
        if (-not (Test-Path $downloadFolder)) {
            New-Item -ItemType Directory -Path $downloadFolder -Force | Out-Null
            Write-Host "Created folder: Terminal Downloads" -ForegroundColor Green
        }

        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $filename = "$($appName.Replace(' ', '_'))_${timestamp}.exe"

        # For .msi files, also change extension
        if ($appUrl -match "\.msi") {
            $filename = "$($appName.Replace(' ', '_'))_${timestamp}.msi"
        }

        $outputPath = Join-Path $downloadFolder $filename

        Write-Host "Saving to: Terminal Downloads on Desktop" -ForegroundColor Cyan
        Write-Host "File: $filename" -ForegroundColor Yellow
        Write-Host ""

        # Download the file with feedback
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")

        Write-Host "Starting download..." -ForegroundColor Magenta
        Write-Host ""

        # Simple download with spinner
        $spinnerChars = @('|', '/', '-', '\')
        $spinnerIndex = 0

        $downloadJob = {
            param($url, $path)
            $client = New-Object System.Net.WebClient
            $client.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
            $client.DownloadFile($url, $path)
        }

        $job = Start-Job -ScriptBlock $downloadJob -ArgumentList $appUrl, $outputPath

        # Show spinner while downloading
        while ($job.State -eq 'Running') {
            $spinnerChar = $spinnerChars[$spinnerIndex % $spinnerChars.Length]
            Write-Host "`r$spinnerChar Downloading $appName..." -ForegroundColor Cyan -NoNewline
            $spinnerIndex++
            Start-Sleep -Milliseconds 100
        }

        # Clear the spinner line
        Write-Host ""

        # Check if job completed successfully
        Receive-Job -Job $job | Out-Null
        if ($job.State -ne 'Completed') {
            Remove-Job -Job $job -Force
            throw "Download failed"
        }
        Remove-Job -Job $job -Force

        # Verify the downloaded file is valid
        if (-not (Test-Path $outputPath)) {
            throw "Downloaded file not found"
        }

        $fileInfo = Get-Item $outputPath
        $fileSizeKB = [math]::Round($fileInfo.Length / 1KB, 2)

        # Check if file is too small (likely an error page or redirect)
        if ($fileInfo.Length -lt 10KB -and ($fileInfo.Extension -eq ".exe" -or $fileInfo.Extension -eq ".msi")) {
            Remove-Item $outputPath -Force -ErrorAction SilentlyContinue
            throw "Downloaded file is too small ($fileSizeKB KB). The URL might have redirected to an error page or login page."
        }

        Write-Host "`n[OK] Download completed successfully!" -ForegroundColor Green
        Write-Host "Location: $outputPath" -ForegroundColor Green
        Write-Host "Size: $fileSizeKB KB" -ForegroundColor Green
        Write-Host ""
        Write-Host "TIP: Navigate to Desktop -> Terminal Downloads to find your file." -ForegroundColor Cyan
        Write-Host "     You may need to run the installer as Administrator." -ForegroundColor Yellow
    } catch {
        # Clear spinner if it was running
        Write-Host ""

        Write-Host "`n[ERROR] Error downloading file: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Possible reasons:" -ForegroundColor Yellow
        Write-Host "  1. Network connection issue" -ForegroundColor Gray
        Write-Host "  2. URL redirected or invalid" -ForegroundColor Gray
        Write-Host "  3. Antivirus blocking the download" -ForegroundColor Gray
        Write-Host "  4. File not available at this URL" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Try:" -ForegroundColor Yellow
        Write-Host "  - Checking your internet connection" -ForegroundColor Gray
        Write-Host "  - Trying a different application" -ForegroundColor Gray
        Write-Host "  - Disabling antivirus temporarily" -ForegroundColor Gray
        Write-Host "  - Manually downloading from the official website" -ForegroundColor Gray
    }

    Pause
}

function View-Downloads {
    Clear-Host
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "                 DOWNLOADED FILES" -ForegroundColor Yellow
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""

    $downloadFolder = Join-Path ([Environment]::GetFolderPath("Desktop")) "Terminal Downloads"

    if (-not (Test-Path $downloadFolder)) {
        Write-Host "Terminal Downloads folder does not exist yet." -ForegroundColor Yellow
        Write-Host "No downloads have been made." -ForegroundColor Yellow
        Pause
        return
    }

    $files = Get-ChildItem -Path $downloadFolder -File | Sort-Object LastWriteTime -Descending

    if ($files.Count -eq 0) {
        Write-Host "No files found in Terminal Downloads folder." -ForegroundColor Yellow
        Pause
        return
    }

    Write-Host "Found $($files.Count) file(s):" -ForegroundColor Green
    Write-Host ""

    foreach ($file in $files) {
        $sizeMB = [math]::Round($file.Length / 1MB, 2)
        $date = $file.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
        Write-Host "  [$($files.IndexOf($file) + 1)] $($file.Name)" -ForegroundColor White
        Write-Host "       Size: $sizeMB MB | Modified: $date" -ForegroundColor Gray
        Write-Host ""
    }

    Write-Host "============================================================" -ForegroundColor Cyan
    Pause
}

function Clear-Downloads {
    Clear-Host
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "                 CLEAR DOWNLOADS" -ForegroundColor Yellow
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""

    $downloadFolder = Join-Path ([Environment]::GetFolderPath("Desktop")) "Terminal Downloads"

    if (-not (Test-Path $downloadFolder)) {
        Write-Host "Terminal Downloads folder does not exist." -ForegroundColor Yellow
        Pause
        return
    }

    $files = Get-ChildItem -Path $downloadFolder -File

    if ($files.Count -eq 0) {
        Write-Host "Terminal Downloads folder is already empty." -ForegroundColor Yellow
        Pause
        return
    }

    Write-Host "This will delete ALL $($files.Count) file(s) from Terminal Downloads." -ForegroundColor Red
    Write-Host ""
    $confirm = Read-Host "Are you sure you want to delete all files? (Y/N)"
    if ($confirm -eq 'Y' -or $confirm -eq 'y') {
        Remove-Item -Path "$downloadFolder\*" -Force
        Write-Host ""
        Write-Host "[OK] All files deleted successfully!" -ForegroundColor Green
    } else {
        Write-Host "[INFO] Operation cancelled." -ForegroundColor Yellow
    }

    Pause
}

function Play-MenuMusic {
    $musicPath = "C:\Users\LUNARO YT\Desktop\app\New Look (Wii U Mii Maker Lofi Mix) 4.mp3"
    if (Test-Path $musicPath) {
        # Start PowerShell Media Player module or use Start-Process
        Start-Process -FilePath $musicPath -WindowStyle Hidden
    }
}

function Show-Menu {
    Clear-Host
    Play-MenuMusic
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host "                    MAIN MENU" -ForegroundColor Yellow
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "[1] Download popular applications" -ForegroundColor Green
    Write-Host "[2] Search applications" -ForegroundColor Green
    Write-Host "[3] View downloaded files" -ForegroundColor Green
    Write-Host "[4] Clear downloads folder" -ForegroundColor Green
    Write-Host "[5] Exit" -ForegroundColor Green
    Write-Host ""
}

# Main program loop
while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice"
    switch ($choice) {
        '1' { Download-Application }
        '2' { Search-Applications }
        '3' { View-Downloads }
        '4' { Clear-Downloads }
        '5' { Write-Host "Goodbye!" -ForegroundColor Cyan; break }
        default { Write-Host "Invalid choice, try again." -ForegroundColor Red; Pause }
    }
}
