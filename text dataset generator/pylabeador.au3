; pylabeador and sillable support:

local $sPunctuation = '¡!¿?";,.-_:'

Func _Sillabice($sWord)
if not isString($sWord) Then Return SetError(1, 0, "")
return _SplitSillable(_Pylabeador($sWord))
EndFunc
Func _Pylabeador($sWord)
if not isString($sWord) Then Return SetError(1, 0, "")
Local $iPID
local $sFinalPunc = "", $sReturn = ""
IF _IsPunctuation($sWord) then
; preserve final punctuation:
$sFinalPunc = StringRight($sWord, 1)
; remove punctuation before syllable processing.
$sWord = _RemovePuncts($sWord)
EndIF
$iPID = Run(@ComSpec & ' /C pylabeador ' & $sWord, @ScriptDir, @SW_HIDE, 6)
ProcessWaitClose($iPID)
$sReturn = StringTrimRight(StdoutRead($iPID), 2)
if not $sFinalPunc = "" then $sReturn &= $sFinalPunc
return $sReturn
EndFunc
Func _SplitSillable($sSils)
If not IsString($sSils) then Return SetError(1, 0, "")
If StringInSTR($sSils, "-") then
return StringSplit($sSils, "-")
Else
return $sSils
EndIf
EndFunc
func _RemovePuncts($sText)
if not isString($sText) Then Return SetError(1, 0, "")
Return StringRegExpReplace($sText, '[' &$sPunctuation &']', '')
endFunc
Func _IsPunctuation($sWord)
if not isString($sWord) then Return SetError(1, 0, "")
If StringInSTR($sWord, " ") then Return SetError(2, 0, "")
LOCAL $bReturn = false
local $sPunc
For $I = 1 to StringLen($sPunctuation)
$sPunc = StringMid($sPunctuation, $i, 1)
If StringInSTR($sWord, $sPunc) then
$bReturn = True
ExitLoop
EndIf
Next
return $bReturn
EndFunc