Scriptname QETEffectScript extends ActiveMagicEffect  

GlobalVariable property QETEffectTimesFired auto 

;Custom function to subtract 
int function oneLess(int index, int sub) 
    int counter = sub
    int loopNum =0
    int EndIndex = 0
    While (counter<index)
        counter+=1
        loopNum+=1
        EndIndex=loopNum
    EndWhile
        return EndIndex
EndFunction 

Event OnEfFectStart(Actor target, Actor caster)
    ;Tracks the number of times the spell has been cast
    QETEffectTimesFired.SetValueInt(QETEffectTimesFired.GetValueInt()+1)
    ; Creates a unique id so the script reads the new "show quest targets"
    String sqtUnique = "UniqueSQT"+QETEffectTimesFired.GetValueInt()
    ConsoleUtil.PrintMessage(sqtUnique)
    ConsoleUtil.ExecuteCommand("showquesttargets")

    ;gets the console text, finds my unique id, and gets the text after the custom id
    string consoleText = UI.GetString("Console","_global.Console.ConsoleInstance.CommandHistory.text")
    int consoleTextSearchIndex = StringUtil.Find(consoleText,sqtUnique)
    consoleText = StringUtil.Substring(consoleText,consoleTextSearchIndex,0)

    ;gets the first curret quest listed by sqt
    int questIDIndex = StringUtil.Find(consoleText,"Current Quest: ")
    String questSQT = StringUtil.Substring(consoleText,questIDIndex+15,0)
 
    ;gets index to trim text
    int questIDEndIndex = StringUtil.Find(questSQT," ")
    int EndIndex = oneLess(questIDEndIndex,2)
    
    ;isolates questID
    String questID = StringUtil.Substring(questSQT,0,EndIndex)
    int counter=0
    int loopint=256
    int nxtQuestIndex
    ;if quest is not active, finds first active quest
    if Quest.GetQuest(questID).isActive()
    Else
        while(counter<loopint)
            counter+=1
            ;gets next quest in console text
            nxtQuestIndex = StringUtil.Find(questSQT,"Current Quest: ")
            questSQT = StringUtil.Substring(questSQT,nxtQuestIndex+15,0)
            questIDEndIndex = StringUtil.Find(questSQT," ")
            EndIndex = oneLess(questIDEndIndex,2)
            questID = StringUtil.Substring(questSQT,0,EndIndex)

            ;if new quest is active ends loop
            if Quest.GetQuest(questID).isActive()
                counter=loopint
            EndIF
        EndWhile
    EndIF


    ;trims out "current quest"
    String questSQTargets = StringUtil.Substring(questSQT,0,0)
    int sqtENDIndex = StringUtil.Find(questSQTargets,"Current Quest: ")
    questSQTargets = StringUtil.Substring(questSQTargets,0,sqtENDIndex)

    ;gets/isolates load door id
    int sLoadDoorIndex = StringUtil.Find(questSQTargets,"load door:")
    String sDoor = StringUtil.Substring(questSQTargets,sLoadDoorIndex,0)    
    sLoadDoorIndex = StringUtil.Find(sDoor,":")
    sDoor = StringUtil.Substring(sDoor,sLoadDoorIndex+4,8)

    ;teleports player to quest
    String cmd1 = "player.moveto "+sDoor
    ConsoleUtil.ExecuteCommand(cmd1)

EndEvent