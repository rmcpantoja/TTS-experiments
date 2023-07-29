; WPMS rate (Word Per Millisecond)
#include <array.au3>
local $aPunctSilences[][] = [[",", 0.5], [".", 1.0], [":", 1.2]]
local $sInflectChars, $sUninflectChars
$sInflectChars = "áéíóúfjlmnñrsvwxz"
$sUninflectChars = 'aeioubcdghkpqty¡¿"_ '
Func _WPMS($sText, $iRate = 50)
if not IsString($sText) or not isInt($iRate) then Return SetError(1, 0)
local $iMillis = 0
local $sCurrentChar
For $I = 1 to StringLen($sText)
$sCurrentChar = StringMid($sText, $I, 1)
if _IsAInflectedLett($sCurrentChar) then
$iMillis = $iMillis + $iRate + random(25, 75)
Elseif _IsAUninflectedLett($sCurrentChar) then
$iMillis = $iMillis + ($iRate/2)
Else
$iMillis = $iMillis + $iRate
EndIf
Next
return int($iMillis)
EndFunc
Func _IsAInflectedLett($sLett)
local $bReturn = false
For $I = 1 to StringLen($sInflectChars)
if StringInSTR(StringMid($sInflectChars, $I, 1), $sLett) then
$bReturn = True
ExitLoop
Else
ContinueLoop
EndIf
Next
return $bReturn
EndFunc
Func _IsAUninflectedLett($sLett)
local $bReturn = false
For $I = 1 to StringLen($sUninflectChars)
if StringInSTR(StringMid($sUninflectChars, $I, 1), $sLett) then
$bReturn = True
ExitLoop
Else
ContinueLoop
EndIf
Next
return $bReturn
EndFunc