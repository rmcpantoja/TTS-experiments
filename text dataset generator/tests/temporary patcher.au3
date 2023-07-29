; temporary text dataset patcher
#include <array.au3>
main()
Func main()
local $aSections
local $sDatasetPath, $sOut
$sDatasetPath = @ScriptDir &"\..\TextDataset.dat"
$aSections = IniReadSectionNames($sDatasetPath)
For $I = 1 to $aSections[0]
; put ljspeech format:
IniRenameSection($sDatasetPath, $aSections[$I], "wavs/" &$I &".wav|" &$aSections[$I])
Next
msgbox(0, "Ready", "Text dataset patched")
EndFunc