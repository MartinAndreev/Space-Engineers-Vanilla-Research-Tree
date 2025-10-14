# 🚀 Space Engineers – Vanilla Research Tree (Reworked)

This repository contains the **Vanilla Research Tree – Reworked** mod for **Space Engineers**.  
It includes a helper PowerShell build script that automates copying files, creating a `.build` folder, and linking it to your local Space Engineers Mods directory for testing.

---

## 📦 Getting Started

### 1. Clone the Repository

Clone the repository into a local folder **outside** of your Space Engineers mods directory:

```bash
git clone git@github.com:MartinAndreev/Space-Engineers-Vanilla-Research-Tree.git
```

> ⚠️ **Recommendation:**  
> Avoid cloning directly into your Space Engineers mods folder. The build script will handle linking automatically.

---

## ⚙️ Running the Helper Build Script

### 2. Install PowerShell

If you don’t already have PowerShell installed, follow the guide for your platform:

- 🪟 **Windows:** PowerShell 7+ is usually preinstalled. If not, download it here:  
  👉 [Install PowerShell on Windows](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows)
- 🍎 **macOS:**  
  👉 [Install PowerShell on macOS](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos)
- 🐧 **Linux:**  
  👉 [Install PowerShell on Linux](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux)

---

### 3. Run the Build Script

Open **PowerShell as Administrator**  
> 🧠 The script needs admin privileges to create a **symbolic link** inside your Space Engineers Mods directory.

Navigate to the folder where you cloned the repository and run:

```powershell
.\build.ps1
```

This will:
- Copy all project files (respecting `.gitignore`) into a `.build` folder  
- Create a symbolic link from your Space Engineers Mods folder to the build output

---

## 🔁 Continuous Build Mode

If you want the script to **automatically rebuild** the mod every few minutes while you work, use the `-IntervalMinutes` parameter:

```powershell
.\build.ps1 -IntervalMinutes 1
```

This will rebuild the mod every **1 minute**.  
You can adjust the interval as needed (e.g. `-IntervalMinutes 5`).

---

## 🧩 Notes

- Make sure **Git** is installed and available in your system’s PATH.  
  👉 [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- Space Engineers Mods folder is typically located at:  
  ```
  %AppData%\SpaceEngineers\Mods
  ```
- The script automatically excludes `.git` and `build.ps1` files from the build output.

---

## ✅ Example Output

```
🔨 Running build at 14:32
✅ Build folder created at C:\MyRepo\.build
✅ Symlink created at C:\Users\<User>\AppData\Roaming\SpaceEngineers\Mods\Vanilla Research Tree - Reworked
⏰ Waiting 1 minute(s) before next build...
```
