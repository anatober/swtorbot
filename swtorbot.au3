#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

AutoItSetOption("MouseCoordMode", 2)
AutoItSetOption("PixelCoordMode", 2)

#include <Misc.au3>
#include <File.au3>
#include <Array.au3>

Global $paused = True, $handle = 0, $GiveGiftsModule, $CraftModule, $MissionsModule, $THLockboxesModule, $SpaceBotRecordModule, $SpaceBotModule, $BlackTalonModule, $GiveGiftsButton

CheckForSWTORWindow()
ReadIni()
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
	Case $SpaceBotModule
		SpaceBot()
	Case $BlackTalonModule
		BlackTalon()
EndSelect

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

Func SpaceBot()
	Local $fileList = _FileListToArray("recorded") ;read all files in the folder
	For $i = 1 To $fileList[0] ;for each file
		SpaceBotReplay($fileList[$i]) ;play space mission
	Next
EndFunc   ;==>SpaceBot

Func SpacebotRecord()
	Local $missionCoords[4] ;coords to create the fileName
	While Not _IsPressed(01) ;wait for lmb to get pressed
		Sleep(1)
	WEnd
	MouseUp("left") ;hold down lmb
	Local $mc = MouseGetPos()
	$missionCoords[0] = $mc[0] ;coord x of the galaxy part
	$missionCoords[1] = $mc[1] ;coord y of the galaxy part
	While Not _IsPressed(01) ;wait for lmb to get pressed
		Sleep(1)
	WEnd
	MouseUp("left")
	$mc = MouseGetPos()
	$missionCoords[2] = $mc[0] ;coord x of the mission in the galaxy part
	$missionCoords[3] = $mc[1] ;coord y of the mission in the galaxy part
	Local $currentArray[1][4], $spaceBotFileHandle = FileOpen("recorded/" & _ArrayToString($missionCoords, ' '), 2), $currentMousePos[2] = [0, 0]
	_ArrayDelete($currentArray, 0)
;~ 	While PixelGetColor(821, 31) <> 16774043 ;wait for loading to begin
;~ 		Sleep(1)
;~ 	WEnd
;~ 	While PixelGetColor(821, 31) = 16774043 ;wait for loading to end
;~ 		Sleep(1)
;~ 	WEnd
	Local $startRecordTime = TimerInit() ;start timer
	While True
		While _IsPressed(01) Or _IsPressed(02) ;if some mb is pressed
			Local $strToAdd = "-"
			Local $pos = MouseGetPos()
			If ($pos[0] = $currentMousePos[0] And $pos[1] = $currentMousePos[1]) Then ;if mouse position didn't change
				ContinueLoop
			ElseIf _IsPressed(02) Then ;if rmb is pressed
				$strToAdd = "R"
			EndIf
			$currentMousePos[0] = $pos[0] ;current pos = new pos
			$currentMousePos[1] = $pos[1]
			_ArrayAdd($currentArray, TimerDiff($startRecordTime) & '|' & $pos[0] & '|' & $pos[1] & '|' & $strToAdd) ;add time, coords and mouse button to timeline
		WEnd

		For $i = 0 To UBound($currentArray) - 1 ;write to file
			FileWriteLine($spaceBotFileHandle, $currentArray[$i][0] & ' ' & $currentArray[$i][1] & ' ' & $currentArray[$i][2] & ' ' & $currentArray[$i][3]) ;append current timeline to the file
		Next
		Local $currentArray[1][4] ;clear the timeline
		_ArrayDelete($currentArray, 0)
	WEnd
EndFunc   ;==>SpacebotRecord

Func SpaceBotReplay($fileName)
	Local $data[1][4]
	_ArrayDelete($data, 0)
	_FileReadToArray("recorded/" & $fileName, $data) ;read data from the file
	_ArrayDelete($data, 0)
	For $i = 0 To UBound($data) - 1
		$data[$i] = StringSplit($data[$i], ' ') ;make array of each line
		_ArrayDelete($data[$i], 0)
	Next

;~ 	Local $coords = StringSplit($fileName, ' ')
;~ 	Send("+M") ;open galaxy map
;~ 	Sleep(1000)
;~ 	MouseClick("left", $coords[1], $coords[2]) ;click part of the galaxy
;~ 	Sleep(1000)
;~ 	MouseClick("left", $coords[3], $coords[4]) ;click mission
;~ 	Sleep(1000)
;~ 	MouseClick("left", 1381, 494) ;click travel
;~ 	Sleep(1000)
;~ 	MouseClick("left", 1058, 576) ;click confirm

;~ 	While PixelGetColor(821, 31) <> 16774043 ;wait for loading to begin
;~ 		Sleep(1)
;~ 	WEnd
;~ 	While PixelGetColor(821, 31) = 16774043 ;wait for loading to end
;~ 		Sleep(1)
;~ 	WEnd

	MouseDown("left")
	Local $startPlayTime = TimerInit() ;start timer
	For $i = 0 To UBound($data) - 1
		While TimerDiff($startPlayTime) < ($data[$i])[0] ;if it's not time for another line yet
			Sleep(1)
		WEnd
		If ($data[$i])[3] = "R" Then ;if rmb needs to be held
			If Not _IsPressed(02) Then ;if rmb isn't held
				MouseUp("left") ;release lmb
				MouseDown("right") ;hold rmb
			EndIf
		ElseIf _IsPressed(02) Then ;otherwise if rmb is held
			MouseUp("right") ;release rmb
			MouseDown("left") ;hold lmb
		EndIf
		MouseMove(($data[$i])[1], ($data[$i])[2], 0) ;move mouse to coord
	Next
	MouseUp("left")
	MouseUp("right")
;~ 	ClickAccept()
;~ 	While PixelGetColor(821, 31) <> 16774043 ;wait for loading to begin
;~ 		Sleep(1)
;~ 	WEnd
;~ 	While PixelGetColor(821, 31) = 16774043 ;wait for loading to end
;~ 		Sleep(1)
;~ 	WEnd
;~ 	ClickAccept()
EndFunc   ;==>SpaceBotReplay

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
EndFunc   ;==>DistributedMissions

Func ChooseGrade($grade)
	MouseClick("left", 1643, 241, 1) ;click on grade dropdown
	Sleep(200)
	MouseClick("left", 1643, 244 + ($grade * 20)) ;click on needed grade
EndFunc   ;==>ChooseGrade

Func ConvClick($number)
	Send("{SPACE 10}")
	Sleep(500)
	Send("{" & $number & " 5}")
	Sleep(500)
	Send("{SPACE 10}")
EndFunc   ;==>ConvClick

Func GetMouse()
	$temp = MouseGetPos()
	MsgBox(0, "", $temp[0] & " " & $temp[1] & " " & PixelGetColor($temp[0], $temp[1], $handle))
EndFunc   ;==>GetMouse

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

Func TreasureHuntingLockboxes()
	While True
		Send("{V 10}") ;Jump (Anti-afk)

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

Func GiveGifts()
	While True
		Send("{" & $GiveGiftsButton & " 10")
		Sleep(1300)
	WEnd
EndFunc   ;==>GiveGifts

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

Func TogglePause()
	$paused = Not $paused
	TrayTip("SWTOR Bot", $paused ? "Paused." : "Unpaused.", 5)
	While $paused
		Sleep(1)
	WEnd
EndFunc   ;==>TogglePause

Func Quit()
	Exit
EndFunc   ;==>Quit

Func ClickAccept()
	MouseClick("left", 1266, 347)
	Sleep(500)
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

Func NextInArray($companionNum, ByRef $missions, ByRef $actualCompanionIndeces)
	$actualCompanionIndeces[$companionNum] = $actualCompanionIndeces[$companionNum] + 1
	If $actualCompanionIndeces[$companionNum] = UBound($missions, 2) Then
		$actualCompanionIndeces[$companionNum] = 0
	ElseIf $missions[$companionNum][$actualCompanionIndeces[$companionNum]] = "" Then
		$actualCompanionIndeces[$companionNum] = 0
	EndIf
EndFunc   ;==>NextInArray

Func ReadIni()
    HotKeySet("{" & IniRead(@ScriptDir & "\swtorbot.ini", "General", "PauseKey", "F1") & "}", "TogglePause")
    HotKeySet("{" & IniRead(@ScriptDir & "\swtorbot.ini", "General", "ShutdownKey", "F5") & "}", "Quit")
	$GiveGiftsButton = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "GiveGiftsButton", "1")

	$GiveGiftsModule = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "GiveGifts", 0) = 1
	$CraftModule = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "Craft", 0) = 1
	$MissionsModule = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "Missions", 0) = 1
	$THLockboxesModule = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "THLockboxes", 0) = 1
	$SpaceBotRecordModule = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "SpaceBotRecord", 0) = 1
	$SpaceBotModule = IniRead(@ScriptDir & "\swtorbot.ini", "Modules", "SpaceBot", 0) = 1
	$BlackTalonModule = IniRead(@ScriptDir & "\swtorbot.ini", "Flashpoints", "BlackTalon", 0) = 1
EndFunc   ;==>ReadIni