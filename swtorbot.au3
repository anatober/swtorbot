#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=swtorbot.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_ProductName=SWTOR Bot
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#Tidy_Parameters=/tc 4 /sf /reel
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

AutoItSetOption("MouseCoordMode", 2)
AutoItSetOption("PixelCoordMode", 2)

;~ HotKeySet("{F2}", "GetMouse")

#include <Misc.au3>
#include <File.au3>
#include <Array.au3>

Global $paused = False, $handle = 0, $ExpBoostSlot, $GiveGiftsModule, $CraftModule, $MissionsModule, $THLockboxesModule, $SpaceBotRecordModule, $SpaceBotReplayModule, $BlackTalonModule, $GiveGiftsButton, $ShipGrade, $Side, $SkipConvos, $SkipConvosChoice, $LoopJabiimEscort, $LoopFondorEscort, $Alignment

CheckForSWTORWindow()
ReadIni()
TogglePause()

Select
    Case $GiveGiftsModule
        GiveGifts()
    Case $CraftModule
        Craft()
    Case $MissionsModule
        Missions()
    Case $THLockboxesModule
        TreasureHuntingLockboxes()
    Case $SpaceBotRecordModule
        SpacebotRecord()
    Case $SpaceBotReplayModule
        SpaceBot()
    Case $BlackTalonModule
        BlackTalon()
    Case $SkipConvos
        SkipConvos()
    Case $LoopJabiimEscort
        LoopJabiimEscort()
    Case $LoopFondorEscort
        LoopFondorEscort()
EndSelect

Func BlackTalon()
    Local $arr[] = ['-', 1, 1, '-', 3, 3, 1, '-', 3, 2, 3, 1, '-', 1, '-', 2, 3, 1, 2, 2, 2, '-', 3, 3, 1, 3, 1, 2, 3, '-', 3, 3, '-', 3, '-', 3, 3, 2, 2, '-', 3, '-', 3, 2, 3, 2, 2, '-', 2, '-']
    While True
        For $i = 0 To UBound($arr) - 1
            If ($arr[$i] = '-') Then
                TogglePause()
            Else
                ConvClick($arr[$i])
            EndIf
        Next
        ClickAccept()
    WEnd
EndFunc   ;==>BlackTalon

Func CheckForSWTORWindow()
    $handle = WinActivate("Star Wars™: The Old Republic™")
    If $handle = 0 Then
        Local $iMsgBoxAnswer = MsgBox(21, "SWTOR Bot", "SWTOR window not found.")
        Select
            Case $iMsgBoxAnswer = 4 ;Retry
                CheckForSWTORWindow()
            Case $iMsgBoxAnswer = 2 ;Cancel
                Exit
        EndSelect
    EndIf
EndFunc   ;==>CheckForSWTORWindow

Func ChooseGrade($grade)
    MouseClick("left", 1643, 241, 1) ;click on grade dropdown
    Sleep(200)
    MouseClick("left", 1643, 244 + ($grade * 20)) ;click on needed grade
EndFunc   ;==>ChooseGrade

Func ClickAccept()
    While True ;accept rewards
        $temp = PixelSearch(1251, 456, 1635, 715, 7258089, 0, 1, $handle)
        If @error <> 1 Then
            MouseClick("left", $temp[0], $temp[1])
            MouseMove(1000, 500)
        Else
            ExitLoop
        EndIf
    WEnd
EndFunc   ;==>ClickAccept

Func ConvClick($number)
    Send("{SPACE 10}")
    Sleep(500)
    Send("{" & $number & " 5}")
    Sleep(500)
    Send("{SPACE 10}")
EndFunc   ;==>ConvClick

Func Craft()
    While True
        Send("{V 10}") ;anti-afk
        For $i = 0 To 2 ;for each companion
            MouseClick("left", 102, 193 + ($i * 75)) ;click on crew skill
            MouseClick("left", 1807, 838) ;click on craft
        Next
        ;MouseClick("right", 53, 765) ;buy recipe from vendor
        ;MouseClick("left", 1268, 444) ;click on needed craft item
    WEnd
EndFunc   ;==>Craft

Func GetMouse()
    $temp = MouseGetPos()
    MsgBox(0, "", $temp[0] & " " & $temp[1] & " " & PixelGetColor($temp[0], $temp[1], $handle))
EndFunc   ;==>GetMouse

Func GiveGifts()
    While True
        Send("{" & $GiveGiftsButton & " 10")
        Sleep(1300)
    WEnd
EndFunc   ;==>GiveGifts

Func LoadingScreen()
    While PixelGetColor(821, 31, $handle) <> 16774043 ;wait for loading to begin
        Sleep(1)
    WEnd
    While PixelGetColor(821, 31, $handle) = 16774043 ;wait for loading to end
        Sleep(1)
    WEnd
EndFunc   ;==>LoadingScreen

Func LoopFondorEscort()
    Send("{" & $ExpBoostSlot & " 10}")
    Local $alignmentSwitcher = False
    Select
        Case $Alignment = "l"
            MouseClick("left", 1675, 1052)
        Case $Alignment = "d"
            MouseClick("left", 1625, 1052)
    EndSelect
    Local $start = TimerInit()
    While True
        If TimerDiff($start) > 10800000 Then
            Send("{" & $ExpBoostSlot & " 10}")
            $start = TimerInit()
        EndIf
        If $Alignment = "n" Then
            If $alignmentSwitcher Then
                MouseClick("left", 1675, 1052)
            Else
                MouseClick("left", 1625, 1052)
            EndIf
            $alignmentSwitcher = Not $alignmentSwitcher
        EndIf
        SpaceBotReplay("Fondor Escort")
    WEnd
EndFunc   ;==>LoopFondorEscort

Func LoopJabiimEscort()
    Send("{" & $ExpBoostSlot & " 10}")
    Local $start = TimerInit()
    While True
        If TimerDiff($start) > 10800000 Then
            Send("{" & $ExpBoostSlot & " 10}")
            $start = TimerInit()
        EndIf
        SpaceBotReplay("Jabiim Escort")
    WEnd
EndFunc   ;==>LoopJabiimEscort

Func Missions()
    Local $fileRead
    _FileReadToArray("out", $fileRead, $FRTA_NOCOUNT) ;read the "out" file
    Local $amountOfCompanions = UBound($fileRead), $colors[$amountOfCompanions], $missions[$amountOfCompanions][4], $actualCompanionIndeces[$amountOfCompanions]
    For $i = 0 To $amountOfCompanions - 1 ;for each companion
        $actualCompanionIndeces[$i] = 0
        Local $newArr = StringSplit($fileRead[$i], " ") ;get his mission grades
        For $j = $newArr[0] To 0 Step -1
            If $newArr[$j] = "" Then
                _ArrayDelete($newArr, $j)
            EndIf
        Next
        _ArrayDelete($newArr, 1)
        For $j = 1 To $newArr[0] - 2
            $missions[$i][$j - 1] = $newArr[$j]
        Next
    Next
    For $i = 0 To $amountOfCompanions - 1
        $colors[$i] = PixelGetColor(194, 458 + (100 * $i), $handle) ;get color of crew skill icon for each companion
    Next
    While True
        Send("{V 10}") ;Anti-afk
        Local $isBack[3], $someoneIsBack = False
        For $i = 0 To $amountOfCompanions - 1 ;for each companion
            $isBack[$i] = PixelGetColor(194, 458 + (100 * $i), $handle) = $colors[$i] ;check if pixel color is the same
            If $someoneIsBack = False And $isBack[$i] = True Then
                $someoneIsBack = True
            EndIf
        Next
        If Not $someoneIsBack Then
            ContinueLoop ;if all are working - do nothing
        EndIf

        ClickAccept()
        For $i = 0 To $amountOfCompanions - 1 ;for each companion
            If $isBack[$i] Then ;if is back
                MouseClick("left", 244, 459 + (100 * $i)) ;click on his crew skill
                Sleep(100)
                ChooseGrade($missions[$i][$actualCompanionIndeces[$i]]) ;choose corresponding grade (from "out")
;~ 				If $i = 0 Then
;~ 					MouseClick("left", 1832, 711) ;scroll down
;~ 				Else
;~ 					MouseClick("right", 1561, 514)
;~ 				EndIf
                MouseClick("right", 1565, 317) ;send him on the mission
                NextInArray($i, $missions, $actualCompanionIndeces) ;set next grade
            EndIf
        Next
    WEnd
EndFunc   ;==>Missions

Func NextInArray($companionNum, ByRef $missions, ByRef $actualCompanionIndeces)
    $actualCompanionIndeces[$companionNum] = $actualCompanionIndeces[$companionNum] + 1
    If $actualCompanionIndeces[$companionNum] = UBound($missions, 2) Then
        $actualCompanionIndeces[$companionNum] = 0
    ElseIf $missions[$companionNum][$actualCompanionIndeces[$companionNum]] = "" Then
        $actualCompanionIndeces[$companionNum] = 0
    EndIf
EndFunc   ;==>NextInArray

Func Quit()
    Exit
EndFunc   ;==>Quit

Func ReadIni()
    HotKeySet("{" & IniRead(@ScriptDir & "\swtorbot.ini", "General", "PauseKey", "F1") & "}", "TogglePause")
    HotKeySet("{" & IniRead(@ScriptDir & "\swtorbot.ini", "General", "ShutdownKey", "F5") & "}", "Quit")
    HotKeySet("{" & IniRead(@ScriptDir & "\swtorbot.ini", "General", "RotationReplayKey", "F3") & "}", "ReplayRotation")
    $GiveGiftsButton = IniRead(@ScriptDir & "\swtorbot.ini", "General", "GiveGiftsButton", "1")
    $SkipConvosChoice = IniRead(@ScriptDir & "\swtorbot.ini", "General", "SkipConvosChoice", 1)

    $GiveGiftsModule = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "GiveGifts", 0) = 1
    $CraftModule = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "Craft", 0) = 1
    $MissionsModule = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "Missions", 0) = 1
    $THLockboxesModule = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "THLockboxes", 0) = 1
    $SpaceBotRecordModule = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "SpaceBotRecord", 0) = 1
    $SpaceBotReplayModule = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "SpaceBotReplay", 0) = 1
    $BlackTalonModule = IniRead(@ScriptDir & "\swtorbot.ini", "Flashpoints", "BlackTalon", 0) = 1
    $SkipConvos = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "SkipConvos", 0) = 1
    $LoopJabiimEscort = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "LoopJabiimEscort", 0) = 1
    $LoopFondorEscort = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "LoopFondorEscort", 0) = 1
    $ShipGrade = IniRead(@ScriptDir & "\swtorbot.ini", "SpaceBot", "Grade", 0)
    $Side = IniRead(@ScriptDir & "\swtorbot.ini", "SpaceBot", "Side", 0)
    $ExpBoostSlot = IniRead(@ScriptDir & "\swtorbot.ini", "SpaceBot", "ExpBoostSlot", 6)
    $Alignment = IniRead(@ScriptDir & "\swtorbot.ini", "SpaceBot", "$Alignment", "n")
EndFunc   ;==>ReadIni

Func RecordRotation()
    Local $vDLL = DllOpen("user32.dll"), $timer = TimerInit(), $records[0]
    While Not _IsPressed(71)
        For $i = 0 To 10
            If _IsPressed(30 + $i) Then
                _ArrayAdd($records, TimerDiff($timer) & ' ' & $i)
            ElseIf _IsPressed("BB") Then
                _ArrayAdd($records, TimerDiff($timer) & ' ' & "=")
            ElseIf _IsPressed("BD") Then
                _ArrayAdd($records, TimerDiff($timer) & ' ' & "-")
            EndIf
        Next
    WEnd
    Local $fileHandle = FileOpen("recorded/rotations/jk", 2)
    For $i = 0 To UBound($records) - 1
        FileWriteLine($fileHandle, $records[$i])
    Next
    FileClose($fileHandle)
EndFunc   ;==>RecordRotation

Func ReplayRotation()
    Send("{F3 UP}")
    Local $lastSavedChar = '', $data, $records[0][2]
    _FileReadToArray("recorded/rotations/jk", $data) ;read data from the file
    For $i = 1 To $data[0] - 1
        $data[$i] = StringSplit($data[$i], ' ') ;make array of each line
        If ($data[$i])[2] <> $lastSavedChar Then
            $lastSavedChar = ($data[$i])[2]
            _ArrayAdd($records, $i & '|' & $lastSavedChar)
        EndIf
    Next

    While Not _IsPressed(72)
        Local $j = 0, $startPlayTime = TimerInit() ;start timer
        For $i = 1 To $data[0] - 1
            While TimerDiff($startPlayTime) < ($data[$i])[1] ;if it's not time for another line yet
                Sleep(1)
            WEnd
            If $j < UBound($records) And $records[$j][0] = $i Then
                Send("{" & $records[$j][1] & " 10}")
                $j = $j + 1
            EndIf
        Next
    WEnd
EndFunc   ;==>ReplayRotation

Func SkipConvos()
    While True
        If $SkipConvosChoice = 'r' Then
            ConvClick(Random(1, 4))
        Else
            ConvClick($SkipConvosChoice)
        EndIf
    WEnd
EndFunc   ;==>SkipConvos

Func SpaceBot()
;~ 	MouseClick("right", 963, 325)
;~ 	Sleep(1000)
;~ 	For $i = 0 To 30
;~ 		MouseClick("left", 569, 677)
;~ 	Next
    Local $fileList = _FileListToArray("recorded/spacebot/" & $Side & '/' & $ShipGrade) ;read all files in the folder
    For $i = 1 To $fileList[0] ;for each file
        SpaceBotReplay($fileList[$i]) ;play space mission
    Next
EndFunc   ;==>SpaceBot

Func SpacebotRecord()
    Local $vDLL = DllOpen("user32.dll"), $missionCoords[4] ;coords of the mission on the galaxy map
    Send("+M") ;open galaxy map
    While Not _IsPressed(01, $vDLL) ;wait for lmb to get pressed
        Sleep(1)
    WEnd
    MouseUp("left") ;release lmb
    Local $mc = MouseGetPos()
    $missionCoords[0] = $mc[0] ;coord x of the galaxy part
    $missionCoords[1] = $mc[1] ;coord y of the galaxy part
    While Not _IsPressed(01, $vDLL) ;wait for lmb to get pressed
        Sleep(1)
    WEnd
    MouseUp("left")
    $mc = MouseGetPos()
    $missionCoords[2] = $mc[0] ;coord x of the mission in the galaxy part
    $missionCoords[3] = $mc[1] ;coord y of the mission in the galaxy part
    Local $currentArray[0][4], $fileHandle = FileOpen("recorded/spacebot/" & $Side & '/' & $ShipGrade & '/' & _ArrayToString($missionCoords, ' '), 2)
    LoadingScreen()
    Local $startRecordTime = TimerInit() ;start timer
    While Not _IsPressed(71, $vDLL) ;until F2 is pressed
        Local $strToAdd = "-", $pos = MouseGetPos(), $timerDiff = TimerDiff($startRecordTime)
        Select
            Case _IsPressed(01, $vDLL) ;if lmb is pressed
                $strToAdd = "L"
            Case _IsPressed(02, $vDLL) ;if rmb is pressed
                $strToAdd = "R"
        EndSelect
        _ArrayAdd($currentArray, $timerDiff & '|' & $pos[0] & '|' & $pos[1] & '|' & $strToAdd) ;add time, coords and mouse button to timeline
    WEnd

    For $i = 0 To UBound($currentArray) - 1 ;write to file
        FileWriteLine($fileHandle, _ArrayToString($currentArray, ' ', $i, $i)) ;append current timeline to the file
    Next

    FileClose($fileHandle)
    DllClose($vDLL)
EndFunc   ;==>SpacebotRecord

Func SpaceBotReplay($fileName)
    Local $data, $records[0][2], $lastSavedChar = ''
    _FileReadToArray("recorded/spacebot/" & $Side & '/' & $ShipGrade & '/' & $fileName, $data) ;read data from the file
    For $i = 3 To $data[0] - 1
        $data[$i] = StringSplit($data[$i], ' ') ;make array of each line
        If ($data[$i])[4] <> $lastSavedChar Then
            $lastSavedChar = ($data[$i])[4]
            _ArrayAdd($records, $i & '|' & $lastSavedChar)
        EndIf
    Next

    Local $coords = StringSplit($data[1], ' ')
    Send("+M") ;open galaxy map
    Sleep(1000)
    MouseClick("left", $coords[1], $coords[2]) ;click part of the galaxy
    Sleep(1000)
    MouseClick("left", $coords[3], $coords[4]) ;click mission
    Sleep(1000)
    MouseClick("left", 1381, 494) ;click travel
    Sleep(1000)
    MouseClick("left", 1058, 576) ;click confirm

    LoadingScreen()

    Local $j = 0, $startPlayTime = TimerInit() ;start timer
    For $i = 3 To $data[0] - 1
        While TimerDiff($startPlayTime) < ($data[$i])[1] ;if it's not time for another line yet
            Sleep(1)
        WEnd
        MouseMove(($data[$i])[2], ($data[$i])[3], 0) ;move mouse to coord
        If $j < UBound($records) And $records[$j][0] = $i Then
            Select
                Case $records[$j][1] = 'L'
                    MouseUp("right")
                    MouseDown("left")
                Case $records[$j][1] = 'R'
                    MouseUp("left")
                    MouseDown("right")
                Case Else
                    MouseUp("left")
                    MouseUp("right")
            EndSelect
            $j = $j + 1
        EndIf
    Next
    MouseUp("left")
    MouseUp("right")
    MouseClick("left", 1616, 519)
    ClickAccept()
    LoadingScreen()
    ClickAccept()
EndFunc   ;==>SpaceBotReplay

Func TogglePause()
    $paused = Not $paused
;~ 	ToolTip("SWTOR Bot " & ($paused ? "paused." : "unpaused."))
;~ 	TrayTip("SWTOR Bot", $paused ? "Paused." : "Unpaused.", 5)
    While $paused
        Sleep(1)
    WEnd
EndFunc   ;==>TogglePause

Func TreasureHuntingLockboxes()
    While True
        Send("{V 10}") ;Anti-afk

        $first = PixelGetColor(247, 263, $handle) = 16764730 ;Check if first companion is back
        $second = PixelGetColor(247, 363, $handle) = 16762909 ;Check if second companion is back
        $third = PixelGetColor(247, 463, $handle) = 16696337 ;Check if third companion is back
        $fourth = PixelGetColor(247, 563, $handle) = 16566830 ;Check if fourth companion is back

        If (Not $first) And (Not $second) And (Not $third) And (Not $fourth) Then
            ContinueLoop ;if all are working - do nothing
        EndIf

        If $first Then
            MouseClick("left", 247, 265)
            Sleep(100)
            MouseClick("left", 1461, 510, 2)
        EndIf
        If $second Then
            MouseClick("left", 247, 365)
            Sleep(100)
            MouseClick("left", 1461, 510, 2)
        EndIf
        If $third Then
            MouseClick("left", 247, 465)
            Sleep(100)
            ChooseGrade(9)
            MouseClick("left", 1461, 510, 2)
        EndIf
        If $fourth Then
            MouseClick("left", 247, 565)
            Sleep(100)
            ChooseGrade(9)
            MouseClick("left", 1461, 510, 2)
        EndIf

        ClickAccept()

        MouseMove(853, 20)
        MouseClick("left", 853, 115) ;open inventory

        ;While PixelGetColor(839, 207, $handle) <> 3222561;wait for items to load
        ;	Sleep(1)
        ;WEnd
        Sleep(3000)

        Local $coordsX[8] = [1185, 1128, 1085, 1067, 1010, 953, 896, 839] ;x coords of top inventory cells

        For $i = 0 To 7
            If PixelGetColor($coordsX[$i], 205, $handle) = 9210508 Then ;if it's a lockbox
                MouseClick("right", $coordsX[$i], 205) ;open it
                $await = 0
                While PixelGetColor($coordsX[$i], 205, $handle) <> 16711422 ;wait until it's open
                    $await = $await + 1
                    If $await < 5000 Then
                        Sleep(1)
                    Else
                        ContinueLoop
                    EndIf
                WEnd
                MouseClick("left") ;accept lockbox item
                While PixelGetColor($coordsX[$i], 205, $handle) = 16711422
                    Sleep(1) ;wait for menu to disappear
                WEnd
            EndIf
        Next

        MouseClick("right", 971, 754) ;click shop
        While PixelGetColor(551, 424, $handle) <> 9163245 ;wait for shop to open
            Sleep(1)
        WEnd
        For $i = 0 To 7
            MouseClick("right", $coordsX[$i], 205) ;sell items
        Next

        MouseClick("left", 228, 1020) ;open buy back menu
        ;While PixelGetColor(290, 1027, $handle) <> 1806277
        ;	Sleep(1);wait for it to load
        ;WEnd
        Sleep(500)
        For $i = 0 To 9 ;search for accidetally sold lockboxes
            If PixelGetColor(495, 522 + ($i * 57), $handle) = 16 Then
                Sleep(500)
                MouseClick("right", 495, 522 + ($i * 57)) ;buy them back
                MouseMove(497, 436)
                $i = 0
            EndIf
        Next

        MouseClick("left", 551, 424) ;close shop
    WEnd
EndFunc   ;==>TreasureHuntingLockboxes
