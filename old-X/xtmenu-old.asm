BITS 32
EXTERN commandWidgetClass
EXTERN exit
EXTERN XtVaAppInitialize
EXTERN XtAppMainLoop
EXTERN XtRealizeWidget
EXTERN XtCreatePopupShell
EXTERN XtVaCreateManagedWidget
EXTERN XtAddCallback
EXTERN menuButtonWidgetClass
EXTERN simpleMenuWidgetClass
EXTERN smeBSBObjectClass
EXTERN smeLineObjectClass
EXTERN XtCreateManagedWidget
EXTERN formWidgetClass
EXTERN boxWidgetClass
EXTERN printf

[section .data]
File:	db	"File",0
.New	db	"New",0
.NewID	dd	"101"
.Open	db	"Open",0
.OpenID	dd	"102"
.Save	db	"Save",0
.SaveID	dd	"103"
.Close	db	"Close",0
.CloseID dd	104
.Exit	db	"Exit",0
.ExitID	dd	105

Help:	db	"Help",0
.About	db	"About",0
.AboutID dd	201
szSep	db	"line",0
;Widgets
ptrShell	dd	0
ptrForm		dd	0
ptrFileButton	dd	0
ptrHelpButton	dd	0
ptrFileMenu	dd	0
ptrHelpMenu	dd	0
ptrMenuEntry	dd	0
ptrMenuBar
MenuBar		dd	"menubar"
ptrMainWindow	dd	0
MainWindow	db	"appwindow"
;Classes
Form:		db "Form",0
Menu:		db "menu",0
;Misc
ARGC:	times 128 db	0
CallbackType	db	"callback",0
szOutString	db	"%s selected",0ah,0dh,0
;InitXt
AppContext	dd	0
XtMenu:		db	"XtMenu",0

[section .text]
GLOBAL CBMenuSelect
CBMenuSelect:
%define CallData 	[ebp+8]
%define ClientData 	[ebp+12]
%define Widget		[ebp+16]
	push ebp
	mov ebp, esp
	mov ebx, ClientData
	mov eax, [ebx]
	cmp eax, dword [File.NewID]
	je  MenuNew
	cmp eax, dword [File.OpenID]
	je  MenuOpen
	cmp eax, dword [File.SaveID]
	je  MenuSave
	cmp eax, dword [File.CloseID]
	je  MenuClose
	cmp eax, dword [File.ExitID]
	je  MenuExit
	cmp eax, dword [Help.AboutID]
	je  MenuAbout
	jmp unhandled
MenuNew:
	push dword File.New
	jmp do_printf
MenuOpen:
	push dword File.Open
	jmp do_printf
MenuSave:
	push dword File.Save
	jmp do_printf
MenuClose:
	push dword File.Close
	jmp do_printf
MenuAbout:
	push dword Help.About
do_printf:
	push dword szOutString
	call printf
	add  esp, 8
unhandled:	
	mov  esp, ebp
	pop  ebp
	ret
MenuExit:
	mov  esp, ebp
	pop  ebp
	push dword 0
	call exit
	ret
	
GLOBAL main
main:
	push dword 0
	push dword 0
	push dword 0
	push dword 0
	push dword ARGC
	push dword 0
	push dword 0
	push dword XtMenu
	push dword AppContext
	call XtVaAppInitialize
	add esp, 36
	mov [ptrShell], eax ;toplevel = XtVaAppInitialize(&app_context,"menu",NULL,0, &argc,argv,NULL,NULL);
       		
	push dword 0
	push dword 0
	push dword [ptrShell]
	push dword [boxWidgetClass]
	push dword MenuBar
	call XtCreateManagedWidget
	mov  [ptrMenuBar], eax
	add esp, 20		
        
	push dword 0
	push dword 0
	push dword [ptrMenuBar]
	push dword [menuButtonWidgetClass]
	push dword File
	call XtCreateManagedWidget ;button1 = XtCreateManagedWidget("button1", menuButtonWidgetClass, form, NULL, 0);
	mov  [ptrFileButton], eax
	add esp, 20
	
	push dword 0
	push dword 0
	push dword [ptrMenuBar]
	push dword [menuButtonWidgetClass]
	push dword Help
	call XtCreateManagedWidget ;button1 = XtCreateManagedWidget("button1", menuButtonWidgetClass, form, NULL, 0);
	mov  [ptrHelpButton], eax
	add esp, 20        
	     
	push dword 0
	push dword 0
	push dword [ptrFileButton]
	push dword [simpleMenuWidgetClass]
	push dword Menu
	call XtCreatePopupShell
	mov  [ptrFileMenu], eax
	add  esp, 20
	
	;Create "New" Menu Item
	push dword 0
	push dword 0
	push dword [ptrFileMenu]
	push dword [smeBSBObjectClass]
	push dword File.New
	call XtCreateManagedWidget
	mov [ptrMenuEntry], eax
	add esp, 20
	
	push dword File.NewID
	push dword CBMenuSelect
	push dword CallbackType	;XtNcallback
	push dword [ptrMenuEntry]
	call XtAddCallback
	add  esp, 16
	
	;Create "Open" Menu Item
	push dword 0
	push dword 0
	push dword [ptrFileMenu]
	push dword [smeBSBObjectClass]
	push dword File.Open
	call XtCreateManagedWidget
	mov [ptrMenuEntry], eax
	add esp, 20
	
	push dword File.OpenID
	push dword CBMenuSelect
	push dword CallbackType	;XtNcallback
	push dword [ptrMenuEntry]
	call XtAddCallback
	add  esp, 16
	
	;Create "Save" Menu Item
	push dword 0
	push dword 0
	push dword [ptrFileMenu]
	push dword [smeBSBObjectClass]
	push dword File.Save
	call XtCreateManagedWidget
	mov [ptrMenuEntry], eax
	add esp, 20
	
	push dword File.SaveID
	push dword CBMenuSelect
	push dword CallbackType	;XtNcallback
	push dword [ptrMenuEntry]
	call XtAddCallback
	add  esp, 16
	
	;Create "Close" Menu Item
	push dword 0
	push dword 0
	push dword [ptrFileMenu]
	push dword [smeBSBObjectClass]
	push dword File.Close
	call XtCreateManagedWidget
	mov [ptrMenuEntry], eax
	add esp, 20
	
	push dword File.CloseID
	push dword CBMenuSelect
	push dword CallbackType	;XtNcallback
	push dword [ptrMenuEntry]
	call XtAddCallback
	add  esp, 16
	
	;Create "Exit" Menu Item
	push dword 0
	push dword 0
	push dword [ptrFileMenu]
	push dword [smeBSBObjectClass]
	push dword File.Exit
	call XtCreateManagedWidget
	mov [ptrMenuEntry], eax
	add esp, 20
	
	push dword File.ExitID
	push dword CBMenuSelect
	push dword CallbackType	;XtNcallback
	push dword [ptrMenuEntry]
	call XtAddCallback
	add  esp, 16
	
	;-------------------------------------done with file menu
	        
	
             
	push dword 0
	push dword 0
	push dword [ptrHelpButton]
	push dword [simpleMenuWidgetClass]
	push dword Menu
	call XtCreatePopupShell
	mov  [ptrHelpMenu], eax
	add  esp, 20
	
	;Create "About" Menu Item
	push dword 0
	push dword 0
	push dword [ptrHelpMenu]
	push dword [smeBSBObjectClass]
	push dword Help.About
	call XtCreateManagedWidget
	mov [ptrMenuEntry], eax
	add esp, 20
	
	push dword Help.AboutID
	push dword CBMenuSelect
	push dword CallbackType	;XtNcallback
	push dword [ptrMenuEntry]
	call XtAddCallback
	add  esp, 16
	;-------------------------------------done with help menu
	
	
	     ;entry = XtCreateManagedWidget("one", smeBSBObjectClass,menu, NULL, 0);
             ;XtAddCallback(entry, XtNcallback, print_string, "one");
             
	     ;entry = XtCreateManagedWidget("two", smeBSBObjectClass,menu, NULL, 0);
             ;XtAddCallback(entry, XtNcallback, print_string, "two");
             
	     ;entry = XtCreateManagedWidget("three", smeBSBObjectClass,menu, NULL, 0);
             ;XtAddCallback(entry, XtNcallback, print_string, "three");
             
	     ;line1 = XtCreateManagedWidget("line1", smeLineObjectClass,menu, NULL, 0);
             ;quit = XtCreateManagedWidget("quit", smeBSBObjectClass,menu, NULL, 0);            
	     ;XtAddCallback(quit, XtNcallback, quit_callback, NULL);	
	push dword [ptrShell]
	call XtRealizeWidget
	add esp, 4
	
	push dword [AppContext]
	call XtAppMainLoop
	add  esp, 4
	push dword 0
	call exit

 ;   nasm -f elf xmenu.asm
 ;   gcc -o xtmenu xmenu.o -lXaw -lXt -lX11 -L/usr/X11R6/lib
	
