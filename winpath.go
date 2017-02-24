package winpath

import (
	"golang.org/x/sys/windows/registry"
)

func AppData() (string, error) {
	return GetVal(registry.CURRENT_USER, `Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders`, "AppData")
}

func CommonAppData() (string, error) {
	return GetVal(registry.LOCAL_MACHINE, `Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders`, "Common AppData")
}

func CommonFilesDir() (string, error) {
	return GetVal(registry.LOCAL_MACHINE, `SOFTWARE\Microsoft\Windows\CurrentVersion`, "CommonFilesDir")
}

func CommonFilesDirX86() (string, error) {
	return GetVal(registry.LOCAL_MACHINE, `SOFTWARE\Microsoft\Windows\CurrentVersion`, "CommonFilesDir (x86)")
}

func Desktop() (string, error) {
	return GetVal(registry.CURRENT_USER, `Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders`, "Desktop")
}

func LocalAppData() (string, error) {
	return GetVal(registry.CURRENT_USER, `Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders`, "Local AppData")
}

func ProgramFilesDir() (string, error) {
	return GetVal(registry.LOCAL_MACHINE, `SOFTWARE\Microsoft\Windows\CurrentVersion`, "ProgramFilesDir")
}

func ProgramFilesDirX86() (string, error) {
	return GetVal(registry.LOCAL_MACHINE, `SOFTWARE\Microsoft\Windows\CurrentVersion`, "ProgramFilesDir (x86)")
}

func StartMenu() (string, error) {
	return GetVal(registry.CURRENT_USER, `Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders`, "Start Menu")
}

func Startup() (string, error) {
	return GetVal(registry.CURRENT_USER, `Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders`, "Startup")
}
