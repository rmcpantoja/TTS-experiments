#include "include\SoundFragment.au3"
_open_bass()
;_BASS_ENCODE_Startup()
;_BASS_MIX_Startup()
local $hSpeech
local $sSpeechFile
$sSpeechFile = @scriptDir &"\wavs\1.wav"
$hSpeech = _BASS_StreamCreateFile(FALSE, $sSpeechFile, 0, 0, 0)
;Check if we opened the file correctly.
If @error Then
	MsgBox(0, "Error", "Could not load audio file" & @CR & "Error = " & @error)
	Exit
EndIf
_SoundFrafmenting($hSpeech, 1000, 11000)
sleep(2000)
