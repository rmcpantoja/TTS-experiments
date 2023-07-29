; create aligments from text dataset
#include <array.au3>
#include "include\audio.au3"
#include <File.au3>
#include <GuiConstantsEx.au3>
#include "include\kbc.au3"
#include "include\reader.au3"
#include "wpms.au3"
;$oSound = $device.opensound(@ScriptDir &"/wavs/1.wav", True)
;_SoundFrafmenting($oSound, 1000, 8000)
;if @error then msgbox(0, "oops", "Seek not supported.")

main()
Func Main()
local $aIniSections, $aSection
LOCAL $IStart = 0
global $iLine = 0
global $iNext = 1, $iSpeakingRate, $iThisRate = 0, $iType, $iTimeline = 0, $iMove = 500
local $sTextdataset = @ScriptDir &"\TextDataset.dat"
$hGui = GuiCreate("Dataset align")
GuiSetState(@SW_SHOW)
sleep(500)
Speaking("Presiona enter para comenzar.")
$aIniSections = IniReadSectionNames($sTextdataset)
while 1
If _isPressed($enter) then
if $iStart = $aIniSections[0] then
MsgBox(48, "Congrats", "Dataset aligned!")
ExitLoop
Else
$iStart = $iStart +1
$iLine = $iLine +1
_Start($aIniSections, $iStart, $sTextdataset)
EndIF
while _isPressed($enter)
sleep(10)
WEnd
EndIf
sleep(10)
WEnd
EndFunc
Func _Start($aIniSections, $iStart, $sTextdataset)
local $aSplitCommand
global $oSpeech
global $sSpeechFile, $sTextFragment, $sType
Speaking("Frase #" &$iStart &": " &$aIniSections[$iStart], True)
$sSpeechFile = StringSplit($aIniSections[$iStart], "|")[1]
$oSpeech = $device.opensound(@ScriptDir &"/" &$sSpeechFile, 1)
$aSection = IniReadSection($sTextdataset, $aIniSections[$iStart])
$iSpeakingRate = int(InputBox("Velocidad de habla", "¿Cuál es la velocidad de pronunciación del hablante? (en milisegundos)"))
while 1
$sTextFragment = $aSection[$iNext][0]
$iLine = $iLine +1
If not StringInSTR($sTextFragment, "sil:") then
$iType = 1
$sType = "palabra"
Else
$iType = 2
$sType = "sílaba"
EndIf
$iTimeline = $iThisRate +1
; si el fragmento anterior era una palabra monosílaba y el actual va a ser la sílaba, entonces dejar las líneas de tiempo como están y solo crearlas en caso de que cambien las siguientes.
$aSplitCommand = StringSplit($sTextFragment, ":")
if uBound($aSplitCommand) >= 3 then
if not $aSection[$iNext-1][0] = $aSplitCommand[2] then
$iThisRate = _WPMS($sTextFragment, $iSpeakingRate)
$iThisRate = int($iThisRate * 44.1)
EndIf
EndIf
Speaking("¿Qué te parece el alineamiento de la " &$sType &" " &$sTextFragment &"? Si no, ajústalo. A y s para aumentar y disminuir comienzo, q y w para el final. Barra espaciadora para validar e ir a la siguiente palabra o sílaba.")
_SoundFrafmenting($oSpeech, $iTimeline, $iThisRate)
; key interact:
_keyinteract()
; write/save aligment:
_FileWriteToLine($sTextdataset, $iLine, $sTextFragment &"=" &$iTimeline &"-" &$iThisRate, True)
speaking("Guardado! Siguiente...")
$iNext = $iNext +1
Sleep(10)
WEnd
EndFunc
func _keyinteract()
while 1
if _IsPressed($t1) then
$iMove = 500
while _IsPressed($t1)
Sleep(10)
WEnd
EndIf
if _IsPressed($t2) then
$iMove = 1000
while _IsPressed($t2)
Sleep(10)
WEnd
EndIf
if _IsPressed($t3) then
$iMove = 2000
while _IsPressed($t3)
Sleep(10)
WEnd
EndIf
if _IsPressed($t4) then
$iMove = 4000
while _IsPressed($t4)
Sleep(10)
WEnd
EndIf
if _IsPressed($t5) then
$iMove = 8000
while _IsPressed($t5)
Sleep(10)
WEnd
EndIf
if _IsPressed($a) then
if $iTimeline <= $iMove then
$iTimeline = 500
Else
$iTimeline = $iTimeline -$iMove
EndIf
_SoundFrafmenting($oSpeech, $iTimeline, $iThisRate)
while _IsPressed($a)
Sleep(10)
WEnd
EndIF
if _IsPressed($s) then
if $iTimeline >= $iThisRate then 
$iTimeline = $iThisRate
else
$iTimeline = $iTimeline +$iMove
EndIf
_SoundFrafmenting($oSpeech, $iTimeline, $iThisRate)
while _IsPressed($s)
Sleep(10)
WEnd
EndIF
if _IsPressed($q) then
if $iThisRate <= $iTimeline + $iMove then
$iThisRate = $iTimeline+$iMove
Else
$iThisRate = $iThisRate -$iMove
EndIf
_SoundFrafmenting($oSpeech, $iTimeline, $iThisRate)
while _IsPressed($q)
Sleep(10)
WEnd
EndIF
if _IsPressed($w) then
if $iThisRate >= $oSpeech.length - 500 then
$iThisRate = $oSpeech.lenght -$iMove
Else
$iThisRate = $iThisRate +$iMove
EndIf
_SoundFrafmenting($oSpeech, $iTimeline, $iThisRate)
while _IsPressed($w)
Sleep(10)
WEnd
EndIF
if _IsPressed($spacebar) then
Speaking("OK!")
ExitLoop
while _IsPressed($spacebar)
Sleep(10)
WEnd
EndIF
sleep(10)
WEnd
EndFunc
Func _SoundFrafmenting($oSound, $iStart, $iEnd)
if not $oSound.Seekable then Return SetError(1, 0, "")
if not IsObj($oSound) then Return SetError(2, 0, "")
$OSound.position = $iStart
$oSound.play
While 1
if $oSound.position >= $iEnd then ExitLoop
;sleep(1)
WEnd
$oSound.stop
EndFunc
Func _GetPos($oSound)
local $sSR
$sSR = _GetSR($oSound)
return int($oSound.position/$sSR)
EndFunc
Func _SetPos($oSound, $iPos)
local $sSR
$sSR = _GetSR($oSound)
$oSound.position = int($iPos/$sSR)
EndFunc
Func _GetSR($oSound)
return $oSound.sampleRate/1000
EndFunc