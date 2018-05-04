#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

AutoItSetOption("MouseCoordMode", 2)
AutoItSetOption("PixelCoordMode", 2)

#include <Misc.au3>
#include <Date.au3>

Global $paused = False

HotKeySet("{F1}", "TogglePause")
HotKeySet("{F5}", "Quit")
HotKeySet("{F2}", "GetMouse")
$handle = WinActivate("Star Wars™: The Old Republic™")

TogglePause()

;BlackTalon()
;GiveGifts()
;GetMouse()
;Craft()
;Missions()
;DistributedMissions()
TreasureHuntingLockboxes()
;Slp()

Func Slp()
	While True
		Send("{SPACE 10}")
		Sleep(60000)
	WEnd
EndFunc

Func DistributedMissions()
	$countFirst = 10
	$countSecond = 9
	$coundThird = 8
	$countFourth = 7
	While True
		Send("{SPACE 10}");Jump (Anti-afk)
		ClickAccept()

		$first = PixelGetColor(247, 263, $handle) = 16764730;Check if first companion is back
		$second = PixelGetColor(247, 363, $handle) = 16762909;Check if second companion is back
		$third = PixelGetColor(247, 463, $handle) = 16696337;Check if third companion is back
		$fourth = PixelGetColor(247, 563, $handle) = 16566830;Check if fourth companion is back

		If $first Then
			if ($countFirst = 10) Then
				$countFirst = 1
			ElseIf ($countFirst = 1) Then
				$countFirst = 2
			ElseIf ($countFirst = 2) Then
				$countFirst = 10
			EndIf
			MouseClick("left", 247, 265)
			Sleep(100)
			ChooseGrade($countFirst)
			MouseClick("left", 1582, 172, 2)
		EndIf
		If $second Then
			if ($countSecond = 5) Then
				$countSecond = 9
			ElseIf ($countSecond = 9) Then
				$countSecond = 5
			EndIf
			MouseClick("left", 247, 365)
			Sleep(100)
			ChooseGrade($countSecond)
			MouseClick("left", 1582, 172, 2)
		EndIf
		If $third Then
			if ($coundThird = 6) Then
				$coundThird = 8
			ElseIf ($coundThird = 8) Then
				$coundThird = 6
			EndIf
			MouseClick("left", 247, 465)
			Sleep(100)
			ChooseGrade($coundThird)
			MouseClick("left", 1582, 172, 2)
		EndIf
		If $fourth Then
			if ($countFourth = 7) Then
				$countFourth = 3
			ElseIf ($countFourth = 3) Then
				$countFourth = 4
			ElseIf ($countFourth = 4) Then
				$countFourth = 7
			EndIf
			MouseClick("left", 247, 565)
			Sleep(100)
			ChooseGrade($countFourth)
			MouseClick("left", 1582, 172, 2)
		EndIf
	WEnd
EndFunc

Func ChooseGrade($grade)
	MouseClick("left",1685,72,1)
	Sleep(200)
	MouseClick("left",1685,75 + ($grade * 20))
EndFunc

Func ConvClick($number)
	Send("{SPACE 10}")
	Sleep(500)
	Send("{" & $number & " 5}")
	Sleep(500)
	Send("{SPACE 10}")
EndFunc

Func GetMouse()
	$temp = MouseGetPos()
	MsgBox(0, "", $temp[0] & " " & $temp[1] & " " & PixelGetColor($temp[0], $temp[1], $handle))
EndFunc

Func BlackTalon()
	While True
		TogglePause()
		ConvClick(1);accept
		ConvClick(1)
		TogglePause()
		ConvClick(3);leitenant
		ConvClick(3)
		ConvClick(1)
		TogglePause()
		ConvClick(3);droid
		ConvClick(2)
		ConvClick(3)
		ConvClick(1)
		TogglePause()
		ConvClick(1);leitenant
		TogglePause()
		ConvClick(2);captain
		ConvClick(3)
		ConvClick(1)
		ConvClick(2)
		ConvClick(2)
		ConvClick(2)
		TogglePause()
		ConvClick(3);satele
		ConvClick(3)
		ConvClick(1)
		ConvClick(3)
		ConvClick(1)
		ConvClick(2)
		ConvClick(3)
		TogglePause()
		ConvClick(3);robot
		ConvClick(3)
		TogglePause()
		ConvClick(3);yadira
		TogglePause()
		ConvClick(3);general
		ConvClick(3)
		ConvClick(2)
		ConvClick(2)
		TogglePause()
		ConvClick(3);robot
		TogglePause()
		ConvClick(3);moff
		ConvClick(2)
		ConvClick(3)
		ConvClick(2)
		ConvClick(2)
		TogglePause()
		ConvClick(2);panel
		TogglePause()
		ClickAccept()
	WEnd
EndFunc

Func TreasureHuntingLockboxes()
	While True
		Send("{SPACE}");Jump (Anti-afk)

		$first = PixelGetColor(247, 263, $handle) = 16764730;Check if first companion is back
		$second = PixelGetColor(247, 363, $handle) = 16762909;Check if second companion is back
		$third = PixelGetColor(247, 463, $handle) = 16696337;Check if third companion is back
		$fourth = PixelGetColor(247, 563, $handle) = 16566830;Check if fourth companion is back

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
            if (Not $first) and (not $second) and (not $third) and (not $fourth) Then
			ContinueLoop;if all are working - do nothing
		EndIf

		ClickAccept()

		MouseMove(853, 20)
		MouseClick("left", 853, 115);open inventory

		;While PixelGetColor(839, 207, $handle) <> 3222561;wait for items to load
		;	Sleep(1)
		;WEnd
		Sleep(3000)

		Local $coordsX[8]
		$coordsX[0] = 1185
		$coordsX[1] = 1128
		$coordsX[2] = 1085
		$coordsX[3] = 1067
		$coordsX[4] = 1010
		$coordsX[5] = 953
		$coordsX[6] = 896
		$coordsX[7] = 839

		For $i = 0 To 7
			if PixelGetColor($coordsX[$i], 205, $handle) = 9210508 Then;if it's a lockbox
				MouseClick("right", $coordsX[$i], 205);open it
				$await = 0
				While PixelGetColor($coordsX[$i], 205, $handle) <> 16711422;wait until it's open
					$await = $await + 1
					If $await < 5000 Then
						Sleep(1)
					Else
						ContinueLoop
					EndIf
				WEnd
				MouseClick("left");accept lockbox item
				While PixelGetColor($coordsX[$i], 205, $handle) = 16711422
					Sleep(1);wait for menu to disappear
				WEnd
			EndIf
		Next

		MouseClick("right", 971, 754);click shop
		While PixelGetColor(551,424,$handle) <> 9163245;wait for shop to open
			Sleep(1)
		WEnd
		For $i = 0 To 7
			MouseClick("right", $coordsX[$i], 205);sell items
		Next

		MouseClick("left", 228, 1020);open buy back menu
		;While PixelGetColor(290, 1027, $handle) <> 1806277
		;	Sleep(1);wait for it to load
		;WEnd
		Sleep(500)
		For $i = 0 To 9;search for accidetally sold lockboxes
			if PixelGetColor(495, 522 + ($i * 57), $handle) = 16 Then
				Sleep(500)
				MouseClick("right", 495, 522 + ($i * 57));buy them back
				MouseMove(497, 436)
				$i = 0
			EndIf
		Next

		MouseClick("left", 551, 424);close shop
	WEnd
EndFunc

Func GiveGifts()
	While True
		Send("{1 10}")
		Sleep(1300)
	WEnd
EndFunc

Func Missions()
	$start = _NowCalc()
	$coordToClick = 188;188;246
	While True
		if ($coordToClick = 188 and _DateDiff('h',$start,_NowCalc()) > 4) then
			$coordToClick = 246
		EndIf
		Send("{SPACE 10}")
		MouseClick("left", $coordToClick, 258, 1, 6)
		MouseClick("left", 1635, 150, 2, 6)
		ClickAccept()
		MouseClick("left", $coordToClick, 358, 1, 6)
		MouseClick("left", 1635, 150, 2, 6)
		ClickAccept()
		MouseClick("left", $coordToClick, 458, 1, 6)
		MouseClick("left", 1635, 150, 2, 6)
		ClickAccept()
		MouseClick("left", $coordToClick, 558, 1, 6)
		MouseClick("left", 1635, 150, 2, 6)
		ClickAccept()
		MouseClick("left", 486, 629, 1, 6);scroll down
		MouseClick("left", $coordToClick, 484, 1, 6)
		MouseClick("left", 1635, 150, 2, 6)
		ClickAccept()
		;MouseClick("left", $coordToClick, 588, 1, 6)
		;MouseClick("left", 1635, 150, 2, 6)
		;ClickAccept()
		MouseClick("left", 486, 202, 1, 6);scroll up
		MouseClick("right", 965, 200)
		MouseClick("right", 925, 200)
		MouseClick("right", 869, 200)
	WEnd
EndFunc

Func Craft()
	While True
		Send("{SPACE}")
		MouseClick("left", 150, 258, 1, 6)
		MouseClick("left", 1863, 734, 1, 6)
		MouseClick("left", 150, 358, 1, 6)
		MouseClick("left", 1863, 734, 1, 6)
		MouseClick("left", 150, 458, 1, 6)
		MouseClick("left", 1863, 734, 1, 6)
	WEnd
EndFunc

Func TogglePause()
    $paused = Not $paused
    While $paused
        Sleep(100)
    WEnd
EndFunc   ;==>TogglePause

Func Quit()
	Exit
EndFunc

Func ClickAccept()
	While True;accept rewards
			$temp = PixelSearch(1771, 962, 1920, 1080, 7258089, 0, 1, $handle)
			If @error <> 1 Then
				MouseClick("left", $temp[0], $temp[1])
				MouseMove(1000, 500)
			Else
				ExitLoop
			EndIf
		WEnd
EndFunc