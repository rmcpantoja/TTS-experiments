; create aligments from text dataset
#include <array.au3>
#include "include\bass.au3"
#include <File.au3>
#include <GuiConstantsEx.au3>
#include "include\kbc.au3"
#include "include\reader.au3"
#include "include\SoundFragment.au3"
#include "wpms.au3"


main()
Func Main()
local $aIniSections, $aSection
LOCAL $IStart = 0
global $iLine = 0
global $iNext = 1, $iSpeakingRate, $iThisRate = 0, $iType, $iTimeline = 0
local $sTextdataset = @ScriptDir &"\TextDataset.dat"
$hGui = GuiCreate("Dataset aligner")
GuiSetState(@SW_SHOW)
sleep(500)
Speaking("Cargando...")
_open_bass()
$aIniSections = IniReadSectionNames($sTextdataset)
while 1
if $iStart = $aIniSections[0] then
MsgBox(48, "Congrats", "Dataset aligned!")
ExitLoop
Else
$iStart = $iStart +1
$iLine = $iLine +1
speaking("Alineando " &$iStart &" de " &$aIniSections[0] &"...")
_Start($aIniSections, $iStart, $sTextdataset)
EndIF
sleep(10)
WEnd
EndFunc
Func _Start($aIniSections, $iStart, $sTextdataset)
local $bSillable, $bSkip = False
global $hSpeech
global $sSpeechFile, $sTextFragment, $sType
Speaking("Frase #" &$iStart &": " &$aIniSections[$iStart], True)
$sSpeechFile = StringSplit($aIniSections[$iStart], "|")[1]
$hSpeech = _BASS_StreamCreateFile(FALSE, $sSpeechFile, 0, 0, 0)
;Check if we opened the file correctly.
If @error Then
	MsgBox(0, "Error", "Could not load audio file" & @CR & "Error = " & @error)
	Exit
EndIf
$aSection = IniReadSection($sTextdataset, $aIniSections[$iStart])
if StringLen($aSection[$iNext][1]) <= 0 then $iSpeakingRate = int(InputBox("Velocidad de habla", "¿Cuál es la velocidad de pronunciación del hablante? (en milisegundos)"))
while 1
$iLine = $iLine +1
if not uBound($aSection, 2) = 1 then
$bSkip = True
speaking("Regresando en " &$aSection[$iNext][0])
Else
$bSkip = False
Speaking("Saltando " &$aSection[$iNext][0] &"...")
$iTimeline = StringSplit($aSection[$iNext][1], "-")[1]
$iThisRate = StringSplit($aSection[$iNext][1], "-")[2]
EndIf
if $bSkip then
$sTextFragment = $aSection[$iNext][0]
If not StringInSTR($sTextFragment, "sil:") then
$bSillable = True
Else
$bSillable = False
EndIf
if $iSpeakingRate = "" then
$iSpeakingRate = 50
speaking("Restaurado. Se ha establecido velocidad de hablante a " &$iSpeakingRate, true)
EndIf
; si el fragmento anterior era una palabra monosílaba y el actual va a ser la sílaba, entonces dejar las líneas de tiempo como están y solo crearlas en caso de que cambien las siguientes.
if not $bSillable then
if StringSplit($sTextFragment, ":")[2] = $aSection[$iNext-1][0] then
$iTimeline = $iThisRate +1
$iThisRate = _WPMS($sTextFragment, $iSpeakingRate)
$iThisRate = int($iThisRate * 44.1)
EndIf
EndIf
if $iThisRate <=1 then $iThisRate = int(_WPMS($sTextFragment, $iSpeakingRate)*44.1)
_SoundFrafmenting($hSpeech, $iTimeline, $iThisRate)
if @error then MsgBox(0, "warning", @error)
_keyinteract()
; write/save aligment:
_FileWriteToLine($sTextdataset, $iLine, $sTextFragment &"=" &$iTimeline &"-" &$iThisRate, True)
speaking("Guardado! Siguiente...")
EndIf
$iNext = $iNext +1
Sleep(10)
WEnd
EndFunc
func _keyinteract()
local $iAdjustTimeline, $iAdjustRate
While 1
$active_window = WinGetProcess("")
If $active_window = @AutoItPID Then
Else
Sleep(10)
ContinueLoop
EndIf
if _IsPressed($i) then
Speaking("Editando " &$sTextFragment &" en " &int($iTimeline/44.1) &", " &int($iThisRate/44.1))
while _IsPressed($i)
Sleep(10)
WEnd
EndIF
if _IsPressed($m) then
$iAdjustTimeline = InputBox("Modificar alineamiento", "Ajusta el principio del alineamiento en milisegundos", int($iTimeline/44.1))
$iTimeline = int($iAdjustTimeline*44.1)
$iAdjustRate = InputBox("Modificar alineamiento", "Ajusta el final del alineamiento en milisegundos", int($iThisRate/44.1))
$iThisRate = int($iAdjustRate*44.1)
while _IsPressed($M)
Sleep(10)
WEnd
EndIF
if _IsPressed($spacebar) then
_SoundFrafmenting($hSpeech, $iTimeline, $iThisRate)
if @error then MsgBox(0, "warning", @error)
while _IsPressed($spacebar)
Sleep(10)
WEnd
EndIF
if _isPressed($enter) then
Speaking("OK! Siguiente.")
sleep(200)
ExitLoop
while _IsPressed($enter)
Sleep(10)
WEnd
EndIf
if _isPressed($escape) then
Speaking("Saliendo...")
sleep(500)
Exit
while _IsPressed($escape)
Sleep(10)
WEnd
EndIf

sleep(10)
WEnd
EndFunc