#include  <X11/StringDefs.h> 
#include  <X11/Intrinsic.h> 
#include  <X11/Xaw/Form.h> 
#include  <X11/Xaw/SimpleMenu.h> 
#include  <X11/Xaw/SmeBSB.h> 
#include  <X11/Xaw/MenuButton.h> 
#include  <X11/Xaw/SmeLine.h> 
//;gcc -o xtmenu xtmenu.c -I/usr/X11R6/include -lXaw -lXt -lX11 -L/usr/X11R6/lib 

void quit_callback(w, client, call)
Widget w;
XtPointer client;
XtPointer call; {
	exit(0);
}


 void print_string(w, client, call)
 Widget w;
 char *client;
 XtPointer call; {
             printf("%s\n",client);
 }
 
 main(argc,argv)
        int argc;
        char **argv; {
        Widget toplevel;
             Widget form;
             Widget quit;
             Widget button1;
             Widget menu;
             Widget line1;
             Widget entry;
             int n;
	     Arg wargs[10];
	     XtAppContext app_context;

       	     toplevel = XtVaAppInitialize(&app_context,"menu",NULL,0, &argc,argv,NULL,NULL);
             form = XtCreateManagedWidget("form", formWidgetClass, toplevel, NULL, 0);
             button1 = XtCreateManagedWidget("button1", menuButtonWidgetClass, form, NULL, 0);

             menu = XtCreatePopupShell("menu", simpleMenuWidgetClass,
                       button1, NULL, 0);
             entry = XtCreateManagedWidget("one", smeBSBObjectClass,
                       menu, NULL, 0);
             XtAddCallback(entry, XtNcallback, print_string, "one");
             
	     entry = XtCreateManagedWidget("two", smeBSBObjectClass,
                       menu, NULL, 0);
             XtAddCallback(entry, XtNcallback, print_string, "two");
             
	     entry = XtCreateManagedWidget("three", smeBSBObjectClass,
                       menu, NULL, 0);
             XtAddCallback(entry, XtNcallback, print_string, "three");
             
	     line1 = XtCreateManagedWidget("line1", smeLineObjectClass,
                       menu, NULL, 0);
             quit = XtCreateManagedWidget("quit", smeBSBObjectClass,
                       menu, NULL, 0);            
	     XtAddCallback(quit, XtNcallback, quit_callback, NULL);	     

	     XtRealizeWidget(toplevel);
             XtAppMainLoop(app_context);

 }
