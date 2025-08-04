
# USB Fix Tool v2.1

🛠 PowerShell-скрипт / script to fix USB write protection and clean USB drives.

---

## 🇷🇺 Описание (Russian)

### Что делает:

- Показывает список всех дисков, выделяет USB
- Удаляет атрибут "только для чтения"
- Полностью очищает USB-диск (`diskpart clean`)
- Создаёт новый раздел, форматирует в NTFS
- Устанавливает метку тома: "USB_FIXED"
- Проверяет и сбрасывает параметр `WriteProtect` в реестре

### ⚠️ Важно:

- **Все данные на выбранном диске будут удалены!**
- **Требуется запуск PowerShell от имени администратора**

### 📥 Скачать

Скачайте последнюю версию из [Releases](https://github.com/BearMarstar/usb-fix-tool/releases/latest)

### 🖥 Как использовать

1. Открой PowerShell **от имени администратора**
2. Разреши запуск скриптов (однократно):
   ```powershell
   Set-ExecutionPolicy RemoteSigned
   ```
3. Запусти скрипт:
   ```powershell
   .\USB_Fix_Tool.ps1
   ```

---

## 🇺🇸 English Description

### What it does:

- Lists all disks, highlights USB drives
- Clears "ReadOnly" attribute from USB
- Fully wipes the USB drive (`diskpart clean`)
- Creates new partition, formats it to NTFS
- Sets volume label: "USB_FIXED"
- Checks and resets registry key `WriteProtect`

### ⚠️ Important:

- **All data on the selected USB drive will be erased**
- **Requires running PowerShell as Administrator**

### 📥 Download

Download the latest version from [Releases](https://github.com/BearMarstar/usb-fix-tool/releases/latest)

### 🖥 How to use

1. Run PowerShell **as Administrator**
2. Allow script execution (only once):
   ```powershell
   Set-ExecutionPolicy RemoteSigned
   ```
3. Run the script:
   ```powershell
   .\USB_Fix_Tool.ps1
   ```

---

## 📄 License

MIT — free to use and distribute.
