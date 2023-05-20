BITS 32
EXTERN commandWidgetClass
EXTERN exit
EXTERN printf
;==========================================================macros
%macro InitXtApp 4
EXTERN XtVaAppInitialize 
	push dword 0
	push dword 0
	push dword 0
	push dword 0
	push dword %4
	push dword 0
	push dword 0
	push dword %3
	push dword %2t
	call XtVaAppInitialize
	add esp, 36
	mov [%1], eax 
%endmacro

%macro CALLBACK 1
GLOBAL %1
%1:
%define CallData 	[ebp+8]
%define ClientData 	[ebp+12]
%define Widget		[ebp+16]
	push ebp
	mov ebp, esp
%endmacro
%macro CALLBACK_RETURN 0
	mov  esp, ebp
	pop  ebp
	ret
%endmacro
%macro CreateMenuBar 3
EXTERN boxWidgetClass
EXTERN XtCreateManagedWidget        		
	push dword 0
	push dword 0
	push dword [%1]		;[Shell.ptr]
	push dword [boxWidgetClass]
	push dword %2		;MenuBar
	call XtCreateManagedWidget
	mov  [%3], eax		;[MenuBar.ptr]	
	add esp, 20
%endmacro 		
	
%macro AddMenu 4
%ifndef _menu_classname
EXTERN menuButtonWidgetClass
EXTERN XtCreateManagedWidget
EXTERN simpleMenuWidgetClass
EXTERN XtCreatePopupShell         
[section .data]
_menu_class	db	"menu",0
[section .text]
%define _menu_classname
%endif
	push dword 0
	push dword 0
	push dword [%1]	
	push dword [menuButtonWidgetClass]
	push dword %2	
	call XtCreateManagedWidget
	mov  [%3], eax	
	add esp, 20       
	     
	push dword 0
	push dword 0
	push dword [%3]
	push dword [simpleMenuWidgetClass]
	push dword _menu_class
	call XtCreatePopupShell
	mov  [%4], eax	
	add  esp, 20
%endmacro
	
%macro AddMenuItem 4 ;Menu, Item, ID, Callback
%ifndef menu_entry_ptr
EXTERN smeBSBObjectClass
EXTERN XtCreateManagedWidget
EXTERN XtAddCallback  
[section .data]
MenuEntry:
.ptr		dd	0
_callback_type	db	"callback",0	
[section .text]
%define menu_entry_ptr
%endif
	push dword 0
	push dword 0
	push dword [%1.ptr]
	push dword [smeBSBObjectClass]
	push dword %2
	call XtCreateManagedWidget
	mov [MenuEntry.ptr], eax
	add esp, 20
	
	push dword %3
	push dword %4
	push dword _callback_type	
	push dword [MenuEntry.ptr]
	call XtAddCallback
	add  esp, 16
%endmacro 
%macro AddMenuSeparator 2 
%ifndef _szseperator
EXTERN smeLineObjectClass
EXTERN XtCreateManagedWidget  
[section .data]
_szSep	db	"line",0	
[section .text]
%define _szseperator
%endif
	push dword 0
	push dword 0
	push dword [%1.ptr]
	push dword [smeLineObjectClass]
	push dword %2
	call XtCreateManagedWidget
	mov [MenuEntry.ptr], eax
	add esp, 20
%endmacro
%macro ShowXtWidget 1
EXTERN XtRealizeWidget 
	push dword [%1]
	call XtRealizeWidget
	add esp, 4
%endmacro
%macro XtAppLoop 1
EXTERN exit
EXTERN XtAppMainLoop 	
	push dword [%1]
	call XtAppMainLoop
	add  esp, 4
	push dword 0
	call exit
%endmacro	

;==========================================================data
[section .data]
;______________Widgets
Shell:
.ptr		dd	0
.name		db	"shell",0
MenuBar:
.ptr		dd	0
.name		db	"menubar",0

FileMenu:
.ptr		dd	0
.name		db	"File",0
.button		dd	0
.New		db	"New",0
.NewID		dd	"101"
.Open		db	"Open",0
.OpenID		dd	"102"
.Save		db	"Save",0
.SaveID		dd	"103"
.Close		db	"Close",0
.CloseID 	dd	104
.Sep		dd	0
.Exit		db	"Exit",0
.ExitID		dd	105

HelpMenu:
.ptr		dd	0
.name		db	"Help",0
.button		dd	0
.About		db	"About",0
.AboutID 	dd	201

;____Classes
XtMenu:		db	"XtMenu",0

;____Misc
ARGC:	times 128 db	0
szOutString	db	"%s selected",0ah,0dh,0
AppContext	dd	0

[section .text]
CALLBACK CBMenuSelect
	mov ebx, ClientData
	mov eax, [ebx]
	cmp eax, dword [FileMenu.NewID]
	je  MenuNew
	cmp eax, dword [FileMenu.OpenID]
	je  MenuOpen
	cmp eax, dword [FileMenu.SaveID]
	je  MenuSave
	cmp eax, dword [FileMenu.CloseID]
	je  MenuClose
	cmp eax, dword [FileMenu.ExitID]
	je  MenuExit
	cmp eax, dword [HelpMenu.AboutID]
	je  MenuAbout
	jmp unhandled
MenuNew:
	push dword FileMenu.New
	jmp do_printf
MenuOpen:
	push dword FileMenu.Open
	jmp do_printf
MenuSave:
	push dword FileMenu.Save
	jmp do_printf
MenuClose:
	push dword FileMenu.Close
	jmp do_printf
MenuAbout:
	push dword HelpMenu.About
do_printf:
	push dword szOutString
	call printf
	add  esp, 8
unhandled:	
	CALLBACK_RETURN
MenuExit:
	mov  esp, ebp
	pop  ebp
	push dword 0
	call exit
	ret
	
GLOBAL main
main:
	InitXtApp Shell.ptr, AppContext, XtMenu, ARGC



	CreateMenuBar Shell.ptr, MenuBar.name, MenuBar.ptr
	AddMenu MenuBar.ptr, FileMenu.name,FileMenu.button, FileMenu.ptr	
	AddMenu MenuBar.ptr, HelpMenu.name,HelpMenu.button, HelpMenu.ptr
		
	AddMenuItem FileMenu, FileMenu.New, FileMenu.NewID, CBMenuSelect	
	AddMenuItem FileMenu, FileMenu.Open, FileMenu.OpenID, CBMenuSelect
	AddMenuItem FileMenu, FileMenu.Save, FileMenu.SaveID, CBMenuSelect
	AddMenuItem FileMenu, FileMenu.Close, FileMenu.CloseID, CBMenuSelect
	AddMenuSeparator FileMenu, FileMenu.Sep
	AddMenuItem FileMenu, FileMenu.Exit, FileMenu.ExitID, CBMenuSelect
	
	AddMenuItem HelpMenu, HelpMenu.About, HelpMenu.AboutID, CBMenuSelect

	ShowXtWidget Shell.ptr

	XtAppLoop AppContext

 ;   nasm -f elf xtmenu.asm
 ;   gcc -o xtmenu xtmenu.o -lXaw -lXt -lX11 -L/usr/X11R6/lib
	
