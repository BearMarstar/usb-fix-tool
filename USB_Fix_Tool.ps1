<#
USB FIX TOOL v2.1 - Исправление защиты от записи
Требует запуска от имени Администратора
#>

function Show-Disks {
    Clear-Host
    Write-Host "`nСПИСОК ДОСТУПНЫХ ДИСКОВ:" -ForegroundColor Cyan -BackgroundColor DarkBlue
    Write-Host "========================================"
    
    $disks = Get-Disk | Select-Object Number, FriendlyName, `
        @{Name="SizeGB"; Expression={[math]::Round($_.Size/1GB,2)}}, `
        OperationalStatus, BusType, `
        @{Name="IsUSB"; Expression={if($_.BusType -eq "USB"){"ДА"}else{"НЕТ"}}}
    
    # Новая версия вывода таблицы без проблемного форматирования
    $disks | ForEach-Object {
        $usbFlag = if($_.IsUSB -eq "ДА") {
            Write-Host "$($_.Number)" -ForegroundColor Green -NoNewline
        } else {
            Write-Host "$($_.Number)" -ForegroundColor Red -NoNewline
        }
        
        Write-Host " | $($_.FriendlyName) | $($_.SizeGB) GB | $($_.OperationalStatus) | $($_.IsUSB)"
    }
    
    Write-Host "`nОБРАТИТЕ ВНИМАНИЕ:" -ForegroundColor Yellow
    Write-Host "• Зеленым цветом отмечены USB-диски" -ForegroundColor Green
    Write-Host "• Красным цветом отмечены НЕ-USB диски" -ForegroundColor Red
    Write-Host "• Системный диск обычно Disk 0 - НЕ выбирать его!" -ForegroundColor Yellow
    Write-Host "========================================"
}

function Select-Disk {
    do {
        Show-Disks
        $selected = Read-Host "`nВведите НОМЕР USB-диска (только цифру) или Q для выхода"
        
        if ($selected -eq 'Q') { exit }
        
        try {
            $disk = Get-Disk -Number $selected -ErrorAction Stop
            if ($disk.BusType -eq 'USB') {
                return $selected
            }
            else {
                Write-Host "Предупреждение: Это НЕ USB-диск! Вы точно хотите продолжить? (Y/N)" -ForegroundColor Red
                $confirm = Read-Host
                if ($confirm -eq 'Y') { return $selected }
            }
        }
        catch {
            Write-Host "ОШИБКА: Диск $selected не существует!" -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    } while ($true)
}

# Основное выполнение скрипта
try {
    # Часть 1: Выбор и обработка диска
    Write-Host "`n=== USB FIX TOOL v2.1 ===" -ForegroundColor Green -BackgroundColor Black
    
    $diskNumber = Select-Disk
    $diskInfo = Get-Disk -Number $diskNumber
    
    Write-Host "`nВыбран диск: $($diskInfo.FriendlyName) (Disk $diskNumber, $([math]::Round($diskInfo.Size/1GB,2)) GB)" -ForegroundColor Cyan
    
    # Часть 2: DiskPart операции
    $DiskPartScript = @"
select disk $diskNumber
attributes disk clear readonly
clean
create partition primary
format fs=ntfs quick label="USB_FIXED"
assign
exit
"@
    
    Write-Host "`nВыполняем DiskPart команды:" -ForegroundColor Yellow
    Write-Host $DiskPartScript -ForegroundColor White
    $DiskPartScript | diskpart
    
    # Часть 3: Проверка реестра
    Write-Host "`nПроверяем реестр..." -ForegroundColor Green
    $RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\StorageDevicePolicies"
    if (Test-Path $RegPath) {
        $CurrentValue = (Get-ItemProperty -Path $RegPath -Name "WriteProtect" -ErrorAction SilentlyContinue).WriteProtect
        if ($CurrentValue -eq 1) {
            Set-ItemProperty -Path $RegPath -Name "WriteProtect" -Value 0
            Write-Host "Исправлено: WriteProtect изменён с 1 на 0" -ForegroundColor Green
        }
        else {
            Write-Host "WriteProtect уже равен 0 (нормальное состояние)" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "Раздел StorageDevicePolicies не найден (не критично)" -ForegroundColor Yellow
    }
    
    # Итоговый отчет
    Write-Host "`n=== РЕЗУЛЬТАТ ===" -ForegroundColor Green
    Write-Host "Операции успешно выполнены для Disk $diskNumber" -ForegroundColor Cyan
    Write-Host "Рекомендуется:" -ForegroundColor White
    Write-Host "1. Извлечь и снова подключить флешку" -ForegroundColor White
    Write-Host "2. Проверить запись файлов" -ForegroundColor White
    Write-Host "3. Если проблема осталась - проверить антивирус" -ForegroundColor White
}
catch {
    Write-Host "`nОШИБКА: $_" -ForegroundColor Red
    Write-Host "Скрипт завершен с ошибками" -ForegroundColor Red -BackgroundColor Black
}
finally {
    Write-Host "`nНажмите любую клавишу для выхода..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}