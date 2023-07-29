; create text dataset for aligment whit purpose of make TTS voices.
#include <array.au3>
#include <dataset.au3>
#include "pylabeador.au3"
; Spanish syllable support.
local $aSillList = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "ñ", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"]
local $SVocals = "aeiou"
local $sDiptongo = "iu"
main()
Func main()
local $aFilelist, $aDict
local $hFileDict
local $iSils, $iWords, $iWordCount = 0
local $sListPath, $sOutPath, $sTextDict = "", $sCurrentSentence = ""
; LIST.TXT (LJSPEECH FORMAT)
$sListPath = @ScriptDir &"\list.txt"
$sOutPath = @ScriptDir &"\TextDataset.dat"
$aFilelist = _dataset_open_transcription($sListPath)
$hFileDict = FileOpen($sOutPath, 2)
;IniWrite($sOutPath, "Voice", "Base folder", "wavs")
For $I = 0 to UBound($aFilelist, 1) -1
ConsoleWrite($I &"/" &UBound($aFilelist, 1) &@crlf)
$sCurrentSentence = $aFilelist[$I][1]
$iWords = int(StringSplit($sCurrentSentence, " ")[0])
FileWriteLine ($hFileDict, "[" &$sCurrentSentence &"]")
;IniWrite($sOutPath, $sCurrentSentence, _GetWord($sCurrentSentence, 1), "")
For $J = 1 to $iWords
$sTextDict = _GetWord($sCurrentSentence, $j)
FileWriteLine($hFileDict, $sTextDict &"=")
; write sillables of the word:
$asSillables = _Sillabice($sTextDict)
if IsArray($asSillables) then
For $iSils = 1 to $asSillables[0]
FileWriteLine($hFileDict, "sil:" &$asSillables[$iSils] &"=")
Next
Else
FileWriteLine($hFileDict, "sil:" &$asSillables &"=")
EndIf
;$aDict = IniReadSection($sOutPath, $sCurrentSentence)
;if not @error then
;if _ArraySearch($aDict, $sTextDict, 0, 0, 0, 1, 1, 0) >= 0 or not @error then
;$iWordCount = $iWordCount +1
;IniWrite($sOutPath, $sCurrentSentence, $sTextDict &"_" &$iWordCount, "")
;Else
;IniWrite($sOutPath, $sCurrentSentence, $sTextDict, "")
;EndIF
;EndIf
;sleep(10)
Next
$iWordCount = 0
Next
FileClose($hFileDict)
MSgBox(48, "Done", "Saved text ataset.")
EndFunc
Func RemoveLeftWord($sString, $iWordsToRemove)
local $aWords
local $iWords, $iToRemove
if not IsString($sString) then Return SetError(1, 0, "")
$aWords = StringSplit($sString, " ")
$iWords = $aWords[0]
if $iWordsToRemove > $iWords then Return SetError(2, 0, "")
$iToRemove = $iWords - $iWordsToRemove
for $I = $iWords to $iToRemove step -1
;if $iWords = $iToRemove then
;ExitLoop
;Else
_ArrayDelete($aWords, $I+1)
;EndIf
Next
return _ArrayToString($aWords, " ", 1, default, @crlf, 1, default)
EndFunc
func _GetWord($sString, $iWord)
if $iWord <=0 then Return SetError(1, 0, "")
if not IsInt($iWord) or not IsString($sString) then Return SetError(2, 0, "")
return StringSplit($sString, " ")[$iWord]
EndFunc
; todo:
func _isSillable($sSil)
IF StringLen($sSil) >4 then Return SetError(1, 0, "")

EndFunc
Func _GenerateSillable($sText)
If Not IsString($sText) then Return SetError(1, 0, "")
local $aSillable

EndFunc
Func _GenerateSillTable($aSillList)
if Not IsArray($aSillList) then Return SetERror(1, 0, "")
local $aSillTable[][]
;For $I = 0 to uBound($aSillList) -1
;For $J = 1 to 5
;$aSillTable[$I][$J] =
;Next
;Next
EndFunc
Func _isVocal($sVocal)
if StringLen($sVocal) >1 then Return SetError(1, 0, "")
return $sVocal = StringInStr($SVocals, $sVocal)
EndFunc