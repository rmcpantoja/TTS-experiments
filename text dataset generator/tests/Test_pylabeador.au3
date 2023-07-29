$sSilWord = _Pylabeador("efrain")
MSgBox(0, "Sílaba", $sSilWord)
$aSplitted = _SplitSillable($sSilWord)
For $I = 1 to $aSplitted[0]
MsgBox(0, "Sílaba", $aSplitted[$I])
Next
