# USB Fix Tool

PowerShell скрипт для исправления ошибки "Защищено от записи" на USB-накопителях

## Функции
- Сброс атрибута ReadOnly через DiskPart
- Исправление параметров реестра
- Интерактивный выбор диска
- Поддержка всех версий Windows

## Как использовать
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\USB_Fix_Tool.ps1
```

## Требования
- Windows 7/10/11
- PowerShell 5.1 или выше
- Права администратора