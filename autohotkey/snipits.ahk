;Header
;set a variable width to the screen width minus the width of the app -270 
;show me a gui with this width and height
;Don't activate it, give it a title
width :=A_ScreenWidth-270
Gui, show, x%width% y4 w260 h60 NoActivate, Snipit
;make it resizable and keep it always on top of other windows.
Gui +Resize AlwaysOnTop
 
;menu setup
;add the submenu's for each menu item.
Menu, FileMenu, Add, E&xit, GuiClose
Menu, HelpMenu, Add, &About, About
;Attach the sub-menu created above to the menue items of the menubar
Menu, MyMenuBar, Add, &File, :FileMenu 
Menu, MyMenuBar, Add, &Help, :HelpMenu
Gui, Menu, MyMenuBar

;data gather and setup Gui

;set a variable snipits that calls the function list_files

;get the file list
FileList =
	Loop *.txt
		FileList = %FileList%%A_LoopFileName%`n
		
;diagnostic confirm variable was filled with the file names
;MsgBox, %FileList%

;put the variable into an array
snipits = 0
Loop, parse, FileList, `n
{
    if A_LoopField =  ; Ignore the blank item at the end of the list.
		continue
	snipits += 1
	Array%snipits% := A_LoopField
	;diagnostic to show the index for each name/field
	;MsgBox, %A_Index% is %A_LoopField%.
}

;diagnosticused to confirm the array read the list of files variable
;Loop, %snipits%
;{
;this_file := Array%A_Index%
;Msgbox, File number %A_Index% is %this_file%
;}

;add a drop down box give it a variable(v) with a control(g) the control is executed upon selection
;Gui, Add, DropDownList, vChoice gSelection w80, Snipits|

;loop through the array snipits
Loop, %snipits%
;now add the amount of text lines based on index of loop and they all trigger command
{
this_file := Array%A_Index%
Gui, Add, Text, cBlue v%a_index% w200 gCommand, %this_file%
GuiControl, Show, text%a_index%
}

;show the gui built
Gui, Show, AutoSize
return

;footer section controls, return, window close and exit

;Command Control
Command:
Gui, Submit, NoHide
Loop, %snipits%
{
thefile := Array%A_Index%
if (a_index == A_GuiControl)
	{
	;msgbox %thefile%
	clipboard =   ; Empty the clipboard.
	FileRead, clipboard, %thefile%
	;MsgBox % clipboard
	Snip := RegExReplace(clipboard, "\r\n?|\n\r?", "`n")
	Send !{Esc}
	Send ^v 
	}
}
return



About:
{
Gui +OwnDialogs
msgbox,4096,About,Snipit V1.0.0`nBy The Andyman (ASC)
return
}

;keep program running
return

;If window is close do the next thing.
GuiClose:
 
;Do this exit the app
ExitApp
