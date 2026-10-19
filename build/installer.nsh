!ifndef MUI_BGCOLOR
  !define MUI_BGCOLOR "FFFFFF"
!endif
!ifndef MUI_TEXTCOLOR
  !define MUI_TEXTCOLOR "111217"
!endif
!ifndef MUI_DIRECTORYPAGE_BGCOLOR
  !define MUI_DIRECTORYPAGE_BGCOLOR "FFFFFF"
!endif
!ifndef MUI_DIRECTORYPAGE_TEXTCOLOR
  !define MUI_DIRECTORYPAGE_TEXTCOLOR "111217"
!endif
!ifndef MUI_INSTFILESPAGE_COLORS
  !define MUI_INSTFILESPAGE_COLORS "3257F7 FFFFFF"
!endif
!ifndef MUI_FINISHPAGE_LINK_COLOR
  !define MUI_FINISHPAGE_LINK_COLOR "3257F7"
!endif
!ifndef MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE
!endif
!ifndef MUI_HEADERIMAGE_BITMAP_STRETCH
  !define MUI_HEADERIMAGE_BITMAP_STRETCH "FitControl"
!endif
!ifndef MUI_HEADERIMAGE_UNBITMAP_STRETCH
  !define MUI_HEADERIMAGE_UNBITMAP_STRETCH "FitControl"
!endif
!ifndef BUILD_UNINSTALLER
  !ifndef MUI_CUSTOMFUNCTION_GUIINIT
    !define MUI_CUSTOMFUNCTION_GUIINIT LanTingGuiInit
  !endif
!endif

!include LogicLib.nsh
!include FileFunc.nsh
!include StdUtils.nsh
!include nsDialogs.nsh
!include WinMessages.nsh

!ifndef LANTING_INSTALL_DIR_NAME
  !define LANTING_INSTALL_DIR_NAME "LanTing"
!endif
!ifndef LANTING_INSTALL_DIR_NAME_LOWER
  !define LANTING_INSTALL_DIR_NAME_LOWER "lanting"
!endif
!ifndef LANTING_INSTALL_MARKER
  !define LANTING_INSTALL_MARKER ".lanting-install-root"
!endif
!ifndef LANTING_MARKER_APP_ID
  !define LANTING_MARKER_APP_ID "com.lanting.desktop"
!endif
!ifndef LANTING_INSTALL_BRAND
  !define LANTING_INSTALL_BRAND "LANTING"
!endif
!ifndef LANTING_INSTALL_TITLE
  !define LANTING_INSTALL_TITLE "澜听安装"
!endif
!ifndef LANTING_INSTALL_NOTICE
  !define LANTING_INSTALL_NOTICE ""
!endif

!ifndef BUILD_UNINSTALLER
  Var LanTingWelcomePage
  Var LanTingHeroFont
  Var LanTingTitleFont
  Var LanTingBodyFont
  Var LanTingSmallFont
  Var LanTingDirectoryPage
  Var LanTingDirectoryInput
!endif

!macro customInit
  !ifndef BUILD_UNINSTALLER
    Call LanTingUsePreferredInstallDir
    Call LanTingDisableUnsafeOldUninstallers
    ${If} ${Silent}
      Call LanTingValidateInstallDir
    ${EndIf}
  !endif
!macroend

!macro customInstall
  FileOpen $0 "$INSTDIR\${LANTING_INSTALL_MARKER}" w
  ${IfNot} ${Errors}
    FileWrite $0 "LanTing install root$\r$\n"
    FileWrite $0 "appId=${LANTING_MARKER_APP_ID}$\r$\n"
    FileClose $0
  ${EndIf}
!macroend

!macro customRemoveFiles
  Call un.LanTingRemoveInstalledFiles
!macroend

!macro customWelcomePage
  Page custom LanTingWelcomeShow
!macroend

!macro customInstallMode
  StrCpy $isForceCurrentInstall "1"
!macroend

!macro customPageAfterChangeDir
  Page custom LanTingDirectoryShow LanTingDirectoryLeave
!macroend

!macro customFinishPage
  !ifndef HIDE_RUN_AFTER_FINISH
    Function LanTingFinishStartApp
      ${If} ${isUpdated}
        StrCpy $1 "--updated"
      ${Else}
        StrCpy $1 ""
      ${EndIf}
      ${StdUtils.ExecShellAsUser} $0 "$launchLink" "open" "$1"
    FunctionEnd

    !define MUI_FINISHPAGE_RUN
    !define MUI_FINISHPAGE_RUN_FUNCTION "LanTingFinishStartApp"
  !endif
  !define MUI_PAGE_CUSTOMFUNCTION_SHOW LanTingTintCommonControls
  !insertmacro MUI_PAGE_FINISH
!macroend

!ifndef BUILD_UNINSTALLER
Function LanTingGuiInit
  System::Call 'dwmapi::DwmSetWindowAttribute(p $HWNDPARENT, i 20, *i 1, i 4) i .r0'
  System::Call 'dwmapi::DwmSetWindowAttribute(p $HWNDPARENT, i 19, *i 1, i 4) i .r0'
  Call LanTingTintCommonControls
FunctionEnd

Function LanTingTintCommonControls
  SetCtlColors $HWNDPARENT "111217" "FFFFFF"

  GetDlgItem $0 $HWNDPARENT 1
  ${If} $0 <> 0
    SetCtlColors $0 "111217" "FFFFFF"
  ${EndIf}
  GetDlgItem $0 $HWNDPARENT 2
  ${If} $0 <> 0
    SetCtlColors $0 "111217" "FFFFFF"
  ${EndIf}
  GetDlgItem $0 $HWNDPARENT 3
  ${If} $0 <> 0
    SetCtlColors $0 "111217" "FFFFFF"
  ${EndIf}

  GetDlgItem $0 $HWNDPARENT 1028
  ${If} $0 <> 0
    SetCtlColors $0 "4B5263" "FFFFFF"
  ${EndIf}
  GetDlgItem $0 $HWNDPARENT 1256
  ${If} $0 <> 0
    SetCtlColors $0 "4B5263" "FFFFFF"
  ${EndIf}
  GetDlgItem $0 $HWNDPARENT 1034
  ${If} $0 <> 0
    SetCtlColors $0 "" "FFFFFF"
  ${EndIf}
  GetDlgItem $0 $HWNDPARENT 1035
  ${If} $0 <> 0
    SetCtlColors $0 "" "FFFFFF"
  ${EndIf}
  GetDlgItem $0 $HWNDPARENT 1037
  ${If} $0 <> 0
    SetCtlColors $0 "111217" "FFFFFF"
  ${EndIf}
  GetDlgItem $0 $HWNDPARENT 1038
  ${If} $0 <> 0
    SetCtlColors $0 "4B5263" "FFFFFF"
  ${EndIf}
  GetDlgItem $0 $HWNDPARENT 1039
  ${If} $0 <> 0
    SetCtlColors $0 "" "FFFFFF"
  ${EndIf}

  FindWindow $0 "#32770" "" $HWNDPARENT
  ${If} $0 <> 0
    SetCtlColors $0 "111217" "FFFFFF"

    GetDlgItem $1 $0 1000
    ${If} $1 <> 0
      SetCtlColors $1 "111217" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1001
    ${If} $1 <> 0
      SetCtlColors $1 "111217" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1004
    ${If} $1 <> 0
      SetCtlColors $1 "3257F7" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1006
    ${If} $1 <> 0
      SetCtlColors $1 "4B5263" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1016
    ${If} $1 <> 0
      SetCtlColors $1 "4B5263" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1019
    ${If} $1 <> 0
      SetCtlColors $1 "111217" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1020
    ${If} $1 <> 0
      SetCtlColors $1 "4B5263" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1023
    ${If} $1 <> 0
      SetCtlColors $1 "4B5263" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1024
    ${If} $1 <> 0
      SetCtlColors $1 "4B5263" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1027
    ${If} $1 <> 0
      SetCtlColors $1 "111217" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1201
    ${If} $1 <> 0
      SetCtlColors $1 "111217" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1202
    ${If} $1 <> 0
      SetCtlColors $1 "4B5263" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1203
    ${If} $1 <> 0
      SetCtlColors $1 "111217" "FFFFFF"
    ${EndIf}
    GetDlgItem $1 $0 1204
    ${If} $1 <> 0
      SetCtlColors $1 "4B5263" "FFFFFF"
    ${EndIf}
  ${EndIf}
FunctionEnd

Function LanTingUsePreferredInstallDir
  ${GetParameters} $R0
  ClearErrors
  ${GetOptions} $R0 "/D=" $R1
  ${IfNot} ${Errors}
  ${AndIf} $R1 != ""
    StrCpy $INSTDIR "$R1"
  ${Else}
    Call LanTingUseRegisteredInstallDir
    Pop $R2
    ${If} $R2 != "1"
      Call LanTingUseFirstAvailableInstallDir
    ${EndIf}
  ${EndIf}
  Push "$INSTDIR"
  Call LanTingNormalizeInstallDir
  Pop $INSTDIR
FunctionEnd

Function LanTingUseFirstAvailableInstallDir
  IfFileExists "D:\*.*" driveD 0
  IfFileExists "E:\*.*" driveE 0
  IfFileExists "F:\*.*" driveF 0
  IfFileExists "G:\*.*" driveG 0
  IfFileExists "H:\*.*" driveH 0
  IfFileExists "I:\*.*" driveI 0
  IfFileExists "J:\*.*" driveJ 0
  IfFileExists "K:\*.*" driveK 0
  IfFileExists "L:\*.*" driveL 0
  IfFileExists "M:\*.*" driveM 0
  IfFileExists "N:\*.*" driveN 0
  IfFileExists "O:\*.*" driveO 0
  IfFileExists "P:\*.*" driveP 0
  IfFileExists "Q:\*.*" driveQ 0
  IfFileExists "R:\*.*" driveR 0
  IfFileExists "S:\*.*" driveS 0
  IfFileExists "T:\*.*" driveT 0
  IfFileExists "U:\*.*" driveU 0
  IfFileExists "V:\*.*" driveV 0
  IfFileExists "W:\*.*" driveW 0
  IfFileExists "X:\*.*" driveX 0
  IfFileExists "Y:\*.*" driveY 0
  IfFileExists "Z:\*.*" driveZ 0
  StrCpy $INSTDIR "C:\${LANTING_INSTALL_DIR_NAME}"
  Return

  driveD:
    StrCpy $INSTDIR "D:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveE:
    StrCpy $INSTDIR "E:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveF:
    StrCpy $INSTDIR "F:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveG:
    StrCpy $INSTDIR "G:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveH:
    StrCpy $INSTDIR "H:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveI:
    StrCpy $INSTDIR "I:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveJ:
    StrCpy $INSTDIR "J:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveK:
    StrCpy $INSTDIR "K:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveL:
    StrCpy $INSTDIR "L:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveM:
    StrCpy $INSTDIR "M:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveN:
    StrCpy $INSTDIR "N:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveO:
    StrCpy $INSTDIR "O:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveP:
    StrCpy $INSTDIR "P:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveQ:
    StrCpy $INSTDIR "Q:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveR:
    StrCpy $INSTDIR "R:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveS:
    StrCpy $INSTDIR "S:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveT:
    StrCpy $INSTDIR "T:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveU:
    StrCpy $INSTDIR "U:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveV:
    StrCpy $INSTDIR "V:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveW:
    StrCpy $INSTDIR "W:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveX:
    StrCpy $INSTDIR "X:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveY:
    StrCpy $INSTDIR "Y:\${LANTING_INSTALL_DIR_NAME}"
    Return
  driveZ:
    StrCpy $INSTDIR "Z:\${LANTING_INSTALL_DIR_NAME}"
    Return
FunctionEnd

Function LanTingHasPreferredInstallDrive
  IfFileExists "D:\*.*" hasPreferred 0
  IfFileExists "E:\*.*" hasPreferred 0
  IfFileExists "F:\*.*" hasPreferred 0
  IfFileExists "G:\*.*" hasPreferred 0
  IfFileExists "H:\*.*" hasPreferred 0
  IfFileExists "I:\*.*" hasPreferred 0
  IfFileExists "J:\*.*" hasPreferred 0
  IfFileExists "K:\*.*" hasPreferred 0
  IfFileExists "L:\*.*" hasPreferred 0
  IfFileExists "M:\*.*" hasPreferred 0
  IfFileExists "N:\*.*" hasPreferred 0
  IfFileExists "O:\*.*" hasPreferred 0
  IfFileExists "P:\*.*" hasPreferred 0
  IfFileExists "Q:\*.*" hasPreferred 0
  IfFileExists "R:\*.*" hasPreferred 0
  IfFileExists "S:\*.*" hasPreferred 0
  IfFileExists "T:\*.*" hasPreferred 0
  IfFileExists "U:\*.*" hasPreferred 0
  IfFileExists "V:\*.*" hasPreferred 0
  IfFileExists "W:\*.*" hasPreferred 0
  IfFileExists "X:\*.*" hasPreferred 0
  IfFileExists "Y:\*.*" hasPreferred 0
  IfFileExists "Z:\*.*" hasPreferred 0
  Push "0"
  Return

  hasPreferred:
    Push "1"
    Return
FunctionEnd

Function LanTingNormalizeInstallDir
  Exch $0
  Push "$0"
  Call LanTingTrimInstallDir
  Pop $0
  StrLen $4 "${LANTING_INSTALL_DIR_NAME}"
  StrLen $1 "$0"
  ${If} $1 == 2
    StrCpy $2 "$0" 1 1
    ${If} $2 == ":"
      StrCpy $0 "$0\${LANTING_INSTALL_DIR_NAME}"
    ${EndIf}
  ${ElseIf} $1 == 3
    StrCpy $2 "$0" 1 1
    StrCpy $3 "$0" 1 2
    ${If} $2 == ":"
    ${AndIf} $3 == "\"
      StrCpy $0 "$0${LANTING_INSTALL_DIR_NAME}"
    ${EndIf}
  ${EndIf}

  StrLen $1 "$0"
  IntOp $5 $4 + 1
  StrCpy $2 "$0" $5 -$5
  ${If} $1 < $5
  ${OrIf} $2 != "\${LANTING_INSTALL_DIR_NAME}"
  ${AndIf} $2 != "\${LANTING_INSTALL_DIR_NAME_LOWER}"
    StrCpy $0 "$0\${LANTING_INSTALL_DIR_NAME}"
  ${EndIf}
  Exch $0
FunctionEnd

Function LanTingTrimInstallDir
  Exch $0

  trim:
    StrLen $1 "$0"
    ${If} $1 > 3
      StrCpy $2 "$0" 1 -1
      ${If} $2 == "\"
        StrCpy $0 "$0" -1
        Goto trim
      ${EndIf}
    ${EndIf}

  Exch $0
FunctionEnd

Function LanTingInstallDirLooksOwned
  Exch $0
  StrCpy $1 "0"

  IfFileExists "$0\${LANTING_INSTALL_MARKER}" 0 +2
    StrCpy $1 "1"

  StrCpy $0 "$1"
  Exch $0
FunctionEnd

Function LanTingExistingInstallPathCanBeAdopted
  Exch $0
  StrCpy $1 "0"

  ${If} $0 == ""
    Goto done
  ${EndIf}

  Push "$0"
  Call LanTingTrimInstallDir
  Pop $2
  ${If} $2 == ""
    Goto done
  ${EndIf}

  Push "$2"
  Call LanTingNormalizeInstallDir
  Pop $3
  ${If} $2 != $3
    Goto done
  ${EndIf}

  IfFileExists "$2\*.*" 0 done
  IfFileExists "$2\${LANTING_INSTALL_MARKER}" adopt 0
  IfFileExists "$2\${PRODUCT_FILENAME}.exe" adopt 0
  IfFileExists "$2\resources\app.asar" adopt 0
  IfFileExists "$2\resources\app\package.json" adopt 0
  IfFileExists "$2\resources\app\server.js" adopt 0
  Goto done

  adopt:
    StrCpy $1 "1"

  done:
    StrCpy $0 "$1"
    Exch $0
FunctionEnd

Function LanTingUseRegisteredInstallDir
  ReadRegStr $0 HKCU "Software\${APP_GUID}" InstallLocation
  Push "$0"
  Call LanTingExistingInstallPathCanBeAdopted
  Pop $1
  ${If} $1 == "1"
    Push "$0"
    Call LanTingNormalizeInstallDir
    Pop $INSTDIR
    Push "1"
    Return
  ${EndIf}

  ReadRegStr $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" InstallLocation
  Push "$0"
  Call LanTingExistingInstallPathCanBeAdopted
  Pop $1
  ${If} $1 == "1"
    Push "$0"
    Call LanTingNormalizeInstallDir
    Pop $INSTDIR
    Push "1"
    Return
  ${EndIf}

  ReadRegStr $0 HKLM "Software\${APP_GUID}" InstallLocation
  Push "$0"
  Call LanTingExistingInstallPathCanBeAdopted
  Pop $1
  ${If} $1 == "1"
    Push "$0"
    Call LanTingNormalizeInstallDir
    Pop $INSTDIR
    Push "1"
    Return
  ${EndIf}

  ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" InstallLocation
  Push "$0"
  Call LanTingExistingInstallPathCanBeAdopted
  Pop $1
  ${If} $1 == "1"
    Push "$0"
    Call LanTingNormalizeInstallDir
    Pop $INSTDIR
    Push "1"
    Return
  ${EndIf}

  Push "0"
FunctionEnd

Function LanTingRegisteredInstallDirCanBeAdopted
  Exch $0
  StrCpy $1 "0"

  ${If} $0 == ""
    Goto done
  ${EndIf}

  Push "$0"
  Call LanTingNormalizeInstallDir
  Pop $2

  ReadRegStr $3 HKCU "Software\${APP_GUID}" InstallLocation
  Push "$3"
  Call LanTingExistingInstallPathCanBeAdopted
  Pop $4
  ${If} $4 == "1"
    Push "$3"
    Call LanTingNormalizeInstallDir
    Pop $5
    ${If} $5 == $2
      StrCpy $1 "1"
      Goto done
    ${EndIf}
  ${EndIf}

  ReadRegStr $3 HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" InstallLocation
  Push "$3"
  Call LanTingExistingInstallPathCanBeAdopted
  Pop $4
  ${If} $4 == "1"
    Push "$3"
    Call LanTingNormalizeInstallDir
    Pop $5
    ${If} $5 == $2
      StrCpy $1 "1"
      Goto done
    ${EndIf}
  ${EndIf}

  ReadRegStr $3 HKLM "Software\${APP_GUID}" InstallLocation
  Push "$3"
  Call LanTingExistingInstallPathCanBeAdopted
  Pop $4
  ${If} $4 == "1"
    Push "$3"
    Call LanTingNormalizeInstallDir
    Pop $5
    ${If} $5 == $2
      StrCpy $1 "1"
      Goto done
    ${EndIf}
  ${EndIf}

  ReadRegStr $3 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" InstallLocation
  Push "$3"
  Call LanTingExistingInstallPathCanBeAdopted
  Pop $4
  ${If} $4 == "1"
    Push "$3"
    Call LanTingNormalizeInstallDir
    Pop $5
    ${If} $5 == $2
      StrCpy $1 "1"
      Goto done
    ${EndIf}
  ${EndIf}

  done:
    StrCpy $0 "$1"
    Exch $0
FunctionEnd

Function LanTingInstallDirIsEmpty
  Exch $0
  FindFirst $1 $2 "$0\*.*"
  StrCpy $3 "1"

  loop:
    StrCmp $2 "" done
    StrCmp $2 "." next
    StrCmp $2 ".." next
    StrCpy $3 "0"
    Goto done

  next:
    FindNext $1 $2
    Goto loop

  done:
    FindClose $1
    StrCpy $0 "$3"
    Exch $0
FunctionEnd

Function LanTingOldInstallPathNeedsQuarantine
  Exch $0
  StrCpy $1 "0"

  ${If} $0 == ""
    Goto done
  ${EndIf}

  Push "$0"
  Call LanTingTrimInstallDir
  Pop $2
  Push "$2"
  Call LanTingNormalizeInstallDir
  Pop $3

  ${If} $2 != $3
    StrCpy $1 "1"
    Goto done
  ${EndIf}

  IfFileExists "$2\${LANTING_INSTALL_MARKER}" done 0
  Push "$2"
  Call LanTingExistingInstallPathCanBeAdopted
  Pop $4
  ${If} $4 == "1"
    Goto done
  ${EndIf}

  StrCpy $1 "1"

  done:
    StrCpy $0 "$1"
    Exch $0
FunctionEnd

Function LanTingDisableUnsafeOldUninstallers
  StrCpy $2 "0"

  ReadRegStr $0 HKCU "Software\${APP_GUID}" InstallLocation
  Push "$0"
  Call LanTingDeleteLegacyUninstallerFileIfMissingMarker
  Push "$0"
  Call LanTingOldInstallPathNeedsQuarantine
  Pop $1
  ${If} $1 == "1"
    DetailPrint "Skip unsafe legacy LanTing uninstaller: $0"
    StrCpy $2 "1"
  ${EndIf}

  ReadRegStr $0 HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" InstallLocation
  Push "$0"
  Call LanTingDeleteLegacyUninstallerFileIfMissingMarker
  Push "$0"
  Call LanTingOldInstallPathNeedsQuarantine
  Pop $1
  ${If} $1 == "1"
    DetailPrint "Skip unsafe legacy LanTing uninstaller: $0"
    StrCpy $2 "1"
  ${EndIf}

  ${If} $2 == "1"
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}"
    DeleteRegKey HKCU "Software\${APP_GUID}"
  ${EndIf}

  StrCpy $2 "0"

  ReadRegStr $0 HKLM "Software\${APP_GUID}" InstallLocation
  Push "$0"
  Call LanTingDeleteLegacyUninstallerFileIfMissingMarker
  Push "$0"
  Call LanTingOldInstallPathNeedsQuarantine
  Pop $1
  ${If} $1 == "1"
    DetailPrint "Skip unsafe legacy LanTing uninstaller: $0"
    StrCpy $2 "1"
  ${EndIf}

  ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}" InstallLocation
  Push "$0"
  Call LanTingDeleteLegacyUninstallerFileIfMissingMarker
  Push "$0"
  Call LanTingOldInstallPathNeedsQuarantine
  Pop $1
  ${If} $1 == "1"
    DetailPrint "Skip unsafe legacy LanTing uninstaller: $0"
    StrCpy $2 "1"
  ${EndIf}

  ${If} $2 == "1"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${UNINSTALL_APP_KEY}"
    DeleteRegKey HKLM "Software\${APP_GUID}"
  ${EndIf}
FunctionEnd

Function LanTingDeleteLegacyUninstallerFileIfMissingMarker
  Pop $0
  ${If} $0 != ""
    Push "$0"
    Call LanTingTrimInstallDir
    Pop $1
    ${If} $1 != ""
      IfFileExists "$1\${LANTING_INSTALL_MARKER}" done 0
      DetailPrint "Remove legacy LanTing uninstaller file: $1"
      Delete "$1\Uninstall ${PRODUCT_FILENAME}.exe"
    ${EndIf}
  ${EndIf}

  done:
FunctionEnd

Function LanTingValidateInstallDir
  Push "$INSTDIR"
  Call LanTingNormalizeInstallDir
  Pop $INSTDIR

  Push "$INSTDIR"
  Call LanTingRegisteredInstallDirCanBeAdopted
  Pop $3

  Push "$INSTDIR"
  Call LanTingExistingInstallPathCanBeAdopted
  Pop $4

  StrCpy $0 "$INSTDIR" 1 0
  StrCpy $1 "$INSTDIR" 1 1
  ${If} $1 == ":"
    ${If} $0 == "C"
    ${OrIf} $0 == "c"
      Call LanTingHasPreferredInstallDrive
      Pop $2
      ${If} $2 == "1"
      ${AndIf} $3 != "1"
      ${AndIf} $4 != "1"
        MessageBox MB_ICONSTOP|MB_OK "检测到这台电脑还有 D-Z 盘，澜听不安装到 C 盘。请改选 D 盘或其它非 C 盘的澜听文件夹。$\r$\n$\r$\n如果电脑只有 C 盘，安装器会自动放行 C:\LanTing。"
        Abort
      ${EndIf}
    ${EndIf}
  ${EndIf}

  StrLen $0 "$INSTDIR"
  StrLen $2 "${LANTING_INSTALL_DIR_NAME}"
  IntOp $2 $2 + 1
  StrCpy $1 "$INSTDIR" $2 -$2
  ${If} $0 < $2
  ${OrIf} $1 != "\${LANTING_INSTALL_DIR_NAME}"
  ${AndIf} $1 != "\${LANTING_INSTALL_DIR_NAME_LOWER}"
    MessageBox MB_ICONSTOP|MB_OK "安装目录必须是独立的澜听文件夹。请选择一个上级目录，安装器会自动创建澜听子文件夹。"
    Abort
  ${EndIf}

  IfFileExists "$INSTDIR\*.*" 0 valid

  Push "$INSTDIR"
  Call LanTingInstallDirLooksOwned
  Pop $0
  ${If} $0 == "1"
    Goto valid
  ${EndIf}

  ${If} $3 == "1"
    Goto valid
  ${EndIf}

  ${If} $4 == "1"
    Goto valid
  ${EndIf}

  Push "$INSTDIR"
  Call LanTingInstallDirIsEmpty
  Pop $0
  ${If} $0 == "1"
    Goto valid
  ${EndIf}

  MessageBox MB_ICONSTOP|MB_OK "为避免卸载时误删其它文件，澜听不能安装到已有文件的非专属目录。请新建或选择一个空的澜听文件夹。$\r$\n$\r$\n当前路径：$INSTDIR"
  Abort

  valid:
FunctionEnd
Function LanTingWelcomeShow
  Call LanTingUsePreferredInstallDir

  nsDialogs::Create 1018
  Pop $LanTingWelcomePage
  ${If} $LanTingWelcomePage == error
    Abort
  ${EndIf}

  SetCtlColors $LanTingWelcomePage "111217" "FFFFFF"
  CreateFont $LanTingHeroFont "Microsoft YaHei UI" 24 700
  CreateFont $LanTingTitleFont "Microsoft YaHei UI" 11 700
  CreateFont $LanTingBodyFont "Microsoft YaHei UI" 9 400
  CreateFont $LanTingSmallFont "Microsoft YaHei UI" 8 400

  ${NSD_CreateLabel} 22u 20u 120u 10u "${LANTING_INSTALL_BRAND}"
  Pop $0
  SendMessage $0 ${WM_SETFONT} $LanTingSmallFont 1
  SetCtlColors $0 "3257F7" "FFFFFF"

  ${NSD_CreateLabel} 22u 42u 226u 30u "${LANTING_INSTALL_TITLE}"
  Pop $0
  SendMessage $0 ${WM_SETFONT} $LanTingHeroFont 1
  SetCtlColors $0 "111217" "FFFFFF"

  ${NSD_CreateLabel} 22u 78u 36u 2u ""
  Pop $0
  SetCtlColors $0 "" "3257F7"

  ${NSD_CreateLabel} 22u 96u 238u 24u "为这台电脑安装 ${PRODUCT_NAME}。默认安装到 D:\${LANTING_INSTALL_DIR_NAME}，下一步可以自由选择其它位置。"
  Pop $0
  SendMessage $0 ${WM_SETFONT} $LanTingBodyFont 1
  SetCtlColors $0 "4B5263" "FFFFFF"

  ${NSD_CreateLabel} 22u 130u 238u 12u "默认位置：$INSTDIR"
  Pop $0
  SendMessage $0 ${WM_SETFONT} $LanTingTitleFont 1
  SetCtlColors $0 "3257F7" "FFFFFF"

  !ifdef LANTING_INTERNAL_BETA
    ${NSD_CreateLabel} 22u 150u 238u 28u "${LANTING_INSTALL_NOTICE}"
    Pop $0
    SendMessage $0 ${WM_SETFONT} $LanTingSmallFont 1
    SetCtlColors $0 "B42318" "FFFFFF"
  !endif

  nsDialogs::Show
FunctionEnd

Function LanTingDirectoryBrowse
  nsDialogs::SelectFolderDialog "选择 ${PRODUCT_NAME} 安装文件夹" "$INSTDIR"
  Pop $0
  ${If} $0 != error
  ${AndIf} $0 != ""
    Push "$0"
    Call LanTingNormalizeInstallDir
    Pop $0
    StrCpy $INSTDIR "$0"
    SendMessage $LanTingDirectoryInput ${WM_SETTEXT} 0 "STR:$INSTDIR"
  ${EndIf}
FunctionEnd

Function LanTingDirectoryShow
  Call LanTingUsePreferredInstallDir

  nsDialogs::Create 1018
  Pop $LanTingDirectoryPage
  ${If} $LanTingDirectoryPage == error
    Abort
  ${EndIf}

  SetCtlColors $LanTingDirectoryPage "111217" "FFFFFF"
  CreateFont $LanTingTitleFont "Microsoft YaHei UI" 15 700
  CreateFont $LanTingBodyFont "Microsoft YaHei UI" 9 400
  CreateFont $LanTingSmallFont "Microsoft YaHei UI" 8 500

  ${NSD_CreateLabel} 22u 12u 238u 20u "选择安装位置"
  Pop $0
  SendMessage $0 ${WM_SETFONT} $LanTingTitleFont 1
  SetCtlColors $0 "111217" "FFFFFF"

  ${NSD_CreateLabel} 22u 40u 238u 24u "你可以使用默认路径，也可以选择其它磁盘或文件夹。安装器会自动创建缺失的目录。"
  Pop $0
  SendMessage $0 ${WM_SETFONT} $LanTingBodyFont 1
  SetCtlColors $0 "4B5263" "FFFFFF"

  ${NSD_CreateLabel} 22u 76u 238u 10u "安装目录"
  Pop $0
  SendMessage $0 ${WM_SETFONT} $LanTingSmallFont 1
  SetCtlColors $0 "3257F7" "FFFFFF"

  ${NSD_CreateText} 22u 94u 178u 15u "$INSTDIR"
  Pop $LanTingDirectoryInput
  SendMessage $LanTingDirectoryInput ${WM_SETFONT} $LanTingBodyFont 1
  SetCtlColors $LanTingDirectoryInput "111217" "FFFFFF"

  ${NSD_CreateBrowseButton} 210u 93u 50u 17u "浏览..."
  Pop $0
  SendMessage $0 ${WM_SETFONT} $LanTingSmallFont 1
  ${NSD_OnClick} $0 LanTingDirectoryBrowse

  ${NSD_CreateLabel} 22u 122u 238u 12u "默认推荐：D:\${LANTING_INSTALL_DIR_NAME}；选盘符会自动建文件夹。"
  Pop $0
  SendMessage $0 ${WM_SETFONT} $LanTingSmallFont 1
  SetCtlColors $0 "6B7280" "FFFFFF"

  nsDialogs::Show
FunctionEnd

Function LanTingDirectoryLeave
  ${NSD_GetText} $LanTingDirectoryInput $0
  ${If} $0 == ""
    MessageBox MB_ICONEXCLAMATION|MB_OK "请选择安装文件夹。"
    Abort
  ${EndIf}
  Push "$0"
  Call LanTingNormalizeInstallDir
  Pop $0
  StrCpy $INSTDIR "$0"
  SendMessage $LanTingDirectoryInput ${WM_SETTEXT} 0 "STR:$INSTDIR"
  Call LanTingValidateInstallDir
FunctionEnd
!endif

!ifdef BUILD_UNINSTALLER
!macro customUnInit
  Call un.LanTingValidateUninstallDir
!macroend

Function un.LanTingInstallDirLooksOwned
  Exch $0
  StrCpy $1 "0"

  IfFileExists "$0\${LANTING_INSTALL_MARKER}" 0 +2
    StrCpy $1 "1"

  StrCpy $0 "$1"
  Exch $0
FunctionEnd

Function un.LanTingNormalizeInstallDir
  Exch $0
  Push "$0"
  Call un.LanTingTrimInstallDir
  Pop $0
  StrLen $4 "${LANTING_INSTALL_DIR_NAME}"
  StrLen $1 "$0"
  ${If} $1 == 2
    StrCpy $2 "$0" 1 1
    ${If} $2 == ":"
      StrCpy $0 "$0\${LANTING_INSTALL_DIR_NAME}"
    ${EndIf}
  ${ElseIf} $1 == 3
    StrCpy $2 "$0" 1 1
    StrCpy $3 "$0" 1 2
    ${If} $2 == ":"
    ${AndIf} $3 == "\"
      StrCpy $0 "$0${LANTING_INSTALL_DIR_NAME}"
    ${EndIf}
  ${EndIf}

  StrLen $1 "$0"
  IntOp $5 $4 + 1
  StrCpy $2 "$0" $5 -$5
  ${If} $1 < $5
  ${OrIf} $2 != "\${LANTING_INSTALL_DIR_NAME}"
  ${AndIf} $2 != "\${LANTING_INSTALL_DIR_NAME_LOWER}"
    StrCpy $0 "$0\${LANTING_INSTALL_DIR_NAME}"
  ${EndIf}
  Exch $0
FunctionEnd

Function un.LanTingTrimInstallDir
  Exch $0

  trim:
    StrLen $1 "$0"
    ${If} $1 > 3
      StrCpy $2 "$0" 1 -1
      ${If} $2 == "\"
        StrCpy $0 "$0" -1
        Goto trim
      ${EndIf}
    ${EndIf}

  Exch $0
FunctionEnd

Function un.LanTingValidateUninstallDir
  Push "$INSTDIR"
  Call un.LanTingTrimInstallDir
  Pop $0
  Push "$0"
  Call un.LanTingNormalizeInstallDir
  Pop $1
  ${If} $0 != $1
    MessageBox MB_OK|MB_ICONSTOP "当前卸载路径不是澜听专属目录，已阻止卸载以避免误删其它文件。$\r$\n$\r$\n当前路径：$INSTDIR$\r$\n安全路径应为：$0"
    SetErrorLevel 2
    Quit
  ${EndIf}
  StrCpy $INSTDIR "$0"

  Push "$INSTDIR"
  Call un.LanTingInstallDirLooksOwned
  Pop $0
  ${If} $0 != "1"
    MessageBox MB_OK|MB_ICONSTOP "无法确认当前目录属于澜听，已阻止卸载以避免误删其它文件。$\r$\n$\r$\n当前路径：$INSTDIR"
    SetErrorLevel 2
    Quit
  ${EndIf}
FunctionEnd

Function un.LanTingRemoveInstalledFiles
  SetOutPath $TEMP

  Delete "$INSTDIR\${PRODUCT_FILENAME}.exe"
  Delete "$INSTDIR\Uninstall ${PRODUCT_FILENAME}.exe"
  Delete "$INSTDIR\uninstallerIcon.ico"

  Delete "$INSTDIR\chrome_100_percent.pak"
  Delete "$INSTDIR\chrome_200_percent.pak"
  Delete "$INSTDIR\d3dcompiler_47.dll"
  Delete "$INSTDIR\dxcompiler.dll"
  Delete "$INSTDIR\dxil.dll"
  Delete "$INSTDIR\ffmpeg.dll"
  Delete "$INSTDIR\icudtl.dat"
  Delete "$INSTDIR\libEGL.dll"
  Delete "$INSTDIR\libGLESv2.dll"
  Delete "$INSTDIR\LICENSE.electron.txt"
  Delete "$INSTDIR\LICENSES.chromium.html"
  Delete "$INSTDIR\resources.pak"
  Delete "$INSTDIR\snapshot_blob.bin"
  Delete "$INSTDIR\v8_context_snapshot.bin"
  Delete "$INSTDIR\vk_swiftshader.dll"
  Delete "$INSTDIR\vk_swiftshader_icd.json"
  Delete "$INSTDIR\vulkan-1.dll"

  RMDir "$INSTDIR\locales"
  RMDir "$INSTDIR\resources"
  RMDir "$INSTDIR\swiftshader"

  RMDir "$INSTDIR"
FunctionEnd
!endif
