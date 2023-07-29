#include <array.au3>
#include "bass.au3"
#include "BassMix.au3"
#include "BassEnc.au3"
#include-once
Func _SoundFrafmenting($hChan, $iStart, $iEnd)
local $aInfo
local $iBpf, $iPos, $iSecs
Global $tBuffer = DllStructCreate("byte[20000]")
Global $iBuffer = DllStructGetSize($tBuffer)
Global $pBuffer = DllStructGetPtr($tBuffer)

$aInfo = _BASS_ChannelGetInfo($hChan)
ConsoleWrite("ctype: " &$aInfo[3] &@crlf)
if ($aInfo[4] + $aInfo[4] <> 8 + $AInfo[4] <> 16) then
ConsoleWrite("Format: " &$aInfo[0] &" hz, " &$aInfo[1] &" channels, " &$aInfo[4] &" bit, " &$aInfo[2] &$BASS_SAMPLE_8BITS &@crlf)
Else
ConsoleWrite("Format: " &$aInfo[0] &" hz" &$aInfo[1] &" channels " &$aInfo[2] &$BASS_SAMPLE_8BITS &@crlf)
EndIf
$iBpf = $aInfo[1] * ($aInfo[2] + $BASS_SAMPLE_8BITS ? 2 : 2)
$iPos = _BASS_ChannelGetLength($hChan, $BASS_POS_BYTE)
if ($iPos <> -1) then
$iSecs = _BASS_ChannelBytes2Seconds($hChan, $iPos);
ConsoleWrite("length: " & int($iSecs/60) &":" &int($iSecs) &" " &$iPos/$iBPf &" samples.")
EndIf
$iStart = Number($iStart)
if not (_BASS_ChannelSetPosition($hChan, $iStart * $iBpf, 0)) then MsgBox(16, "Error", "Can't set start position")
$iEnd = number($iEnd)
_BASS_ChannelSetPosition($hChan, $iEnd * $iBpf, $BASS_POS_END)
;$hMixer = _BASS_Mixer_StreamCreate(44100, $aInfo[1], BitOR($BASS_MIXER_END, $BASS_STREAM_DECODE))
;_BASS_Mixer_StreamAddChannel($hMixer, $hChan, $BASS_MIXER_FILTER)
;$hEncoder = _BASS_Encode_Start($hMixer, @ScriptDir & "\cut.wav", $BASS_ENCODE_PCM)
;$iDone = 0
;While _BASS_ChannelIsActive($hMixer)
;	$iLength = _BASS_ChannelGetData($hMixer, $pBuffer, $iBuffer)
;	$iDone += $iLength
;WEnd
;_BASS_Encode_Stop($hEncoder)
_BASS_ChannelPlay($hChan, 0)
EndFunc
func _open_bass()
_BASS_Startup()
if @error then
MsgBox(16, "Error", "Can't initialize bass")
Exit
EndIF
_BASS_Init(0, -1, 44100, 0, "")
if @error then
MsgBox(16, "Error", "Can't initialize device")
Exit
EndIF
EndFunc