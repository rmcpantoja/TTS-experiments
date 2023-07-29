; testremove:
$sString = "vamos a la calle."
$iCount = stringSplit($sString, " ")[0]
for $iWordsToRemove = 0 to $iCount -1
msgbox(0, "removing " &$iWordsToRemove &"words", RemoveLeftWord($sString, $iWordsToRemove))
Next
msgbox(0, "done", "finished")
