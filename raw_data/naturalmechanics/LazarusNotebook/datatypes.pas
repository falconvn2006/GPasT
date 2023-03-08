unit dataTypes;

{$mode ObjFPC}{$H+}{$modeswitch advancedrecords} // ------------------------------// The advancedrecords switch is needed the struct pointers

interface

uses
  Classes, SysUtils, Dialogs, Graphics;

type
    genNodePtr = ^NodeStruct; // -------------------------------------------------// The ^ symbol in front of the struct type is of type :
                                                                                  //// **pointer (reference) to particular type of struct**.
                                                                                  //// Pointers correspond to the types they are pointing to.
                                                                                  //// Each instance of a type gets the same *pointer type*.
    vc         = Array of Integer;    // -----------------------------------------// vc ==> vector
    mt         = Array of vc;         // -----------------------------------------// mt ==> matrix


    NodeStruct  = packed record                                                   // Struct type (basic). not used directly.
      ID        : Integer;

      end;
    TNodeArray = Array of NodeStruct; // -----------------------------------------// Array of menu structs.

    { stringNodeStruct }

    strNodePtr = ^stringNodeStruct ;  // -----------------------------------------// Pointer to menu struct.
                                                                                  //// The pointer declaration needs to be *before* the
                                                                                  //// ACTUAL struct declaration, because
                                                                                  //// the struct will include a pointer type like this inside it.
                                                                                  //// But if the pointer is declared before hand,
                                                                                  //// then the compiler associates a generic pointer here.
                                                                                  //// All pointers are 4 or 8 bytes.
                                                                                  //// But the compiler needs to know what sort of variable is there.
    stringNodeStruct = packed record  // -----------------------------------------// This is NOT a generic node-
                                                                                  //// It is built to suit the needs of a Menu Item.
      ID        : Integer;// -----------------------------------------------------// An *unique* ID.
                                                                                  //// It is currently implemented using a simple counter...
      name      : String; // -----------------------------------------------------// An internal name, to refer to it instead of just an ID.
      stringVal : String; // -----------------------------------------------------// The display value of the menu,
                                                                                  //// e.g. the file menu can have the internal name ( = name) 'fileMenu'
                                                                                  //// and display value ( = stringVal) 'File'
      Parent    : strNodePtr; // -------------------------------------------------// The same struct is used for submenu entries
                                                                                  //// If B is a submenu of A, then A is the parent of B
      Children  : Array of strNodePtr; // ----------------------------------------// All the submenus.
                                                                                  //// The submenus are ALSO doubly linked, just like
                                                                                  //// the parent and its prev, resp. next.
                                                                                  //// So, children [0] .next = children [1]
                                                                                  //// and, children[1] .prev = children [0]
      prev      : strNodePtr; // -------------------------------------------------// The previous menu in the same level
      next      : strNodePtr; // -------------------------------------------------// The next menu in the same level




      isSubMenu : Boolean; //-----------------------------------------------------// Is it a submenu?

      hasCheckBox:Boolean; //-----------------------------------------------------// Is it a checkbox?
      checkBoxStatus: Boolean; //-------------------------------------------------// Status

      hasPicture: Boolean; //-----------------------------------------------------// Icon?
      picturePath:String; //------------------------------------------------------// Where is the picture?

      shortCut : String; //-------------------------------------------------------// Keyboard shortcut

      isSubMenuDrawn : Boolean; //------------------------------------------------// Is the submenu drawn
      subMenuContainer: TObject; //-----------------------------------------------// Container for submenu

      FGColorCp : TColor;
      BGColorCp : TColor;
      BGColorOriginal : TColor;
      FGColorOriginal : TColor;
      BGColorCopied:Boolean;
      FGColorCopied:Boolean;

      shortCutString : String;
      hasShortCut    : Boolean;

      hasPanelHighLightColor : Boolean;
      panelHighLightColor : TColor;


    end;



  { tree_ofStrings } // ----------------------------------------------------------// This is the class

  tree_ofStrings = class // ------------------------------------------------------// Class, like struct, is defined with a "=" symbol
                                                                                  //// The class represents here the Entire menu tree, i.e.
                                                                                  //// EVERY item of the main menu, their submenus, and their submenus and so on.
  public  // ---------------------------------------------------------------------// The Public keyword exists in Pascal
      root                   : strNodePtr; // ------------------------------------// The first item of the top-level menu list
                                                                                  //// which is a doubly linked list.
      constructor Create(); // ---------------------------------------------------// I need this so that I can create new
                                                                                  //// **UNIQUE** instances of this class bound to
                                                                                  //// different variables
      // -------------------------------------------------------------------------// For procedures, see the implementations
      procedure AppendNode(var ChildObj : NodeStruct);
      procedure AppendString_asNode(var insertionObject : String; var IDName : String; var ID : Integer);
      procedure AppendString_asSubNode ( var target: mt; var insertionObject : String; var ID : Integer);
      procedure AppendString_asSubNode_byName(var target: String ; var insertionObject: String; var name: String; var ID: Integer);
      procedure AppendString_asSubSubNode_byName(var target: String ; var insertionObject: String; var name: String; var ID: Integer);
  end;



implementation



{ tree_ofStrings }

constructor tree_ofStrings.Create; // --------------------------------------------// No additional information
begin

end;

procedure tree_ofStrings.AppendNode(var ChildObj: NodeStruct); // ----------------// NOIMPL YET
begin

end;

procedure tree_ofStrings.AppendString_asNode(var insertionObject: String;  var IDName : String; var ID: Integer);
                                                               // ----------------// ++++ The menus, in any particular level is a doubly linked list
                                                                                  // ++++ Example, the main menu :
                                                                                  // ++++ File <---> Edit <---> View <---> Tools .. etc
                                                                                  // ++++ or, the submenus of menu entry "File" :
                                                                                  // ++++ New <---> Open <---> Save <---> Close <---> Quit program .. etc.
                                                                                  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                                                                  // ++++ This PROCEDURE inserts a new menu item
                                                                                  // ++++ at the end of the doubly linked list
                                                                                  // ++++ used to contain the main menu (top level menu)
                                                                                  // ++++ i.e. the doubly linked list that contains (using the above example)
                                                                                  // ++++ File <---> Edit <---> View <---> Tools .. etc
                                                                                  // ++++ This PROCEDURE can't be used to introduce an item to the submenus.
                                                                                  // ++++ That is, it is not possible to introduce anything to :
                                                                                  // ++++ New <---> Open <---> Save <---> Close <---> Quit program etc
                                                                                  // ++++ using this PROCEDURE.
                                                                                  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                                                                  // ++++ Arguments :
                                                                                  // ++++ insertionObject   : The display name of the item to be inserted at the END
                                                                                  // ++++ of the doubly linked list used to contain the main menu
                                                                                  // ++++ Example : "File", or "Edit".
                                                                                  // ++++ IDName            : The INTERNAL NAME of the menu item
                                                                                  // ++++ Example : "fileMenu", or "editMenu".
                                                                                  // ++++ ID                : An **UNIQUE** integer ID.

var
   newNode                       : ^stringNodeStruct; //--------------------------// The new node to be inserted
   currNode                      : ^stringNodeStruct; //--------------------------// The current element being inspected, to find the tail element of the list

   argStr                        : String; //-------------------------------------// NOIMPL YET
begin

   newNode               := New(strNodePtr); //-----------------------------------// Create a new menu item struct
   newNode^.stringVal    := insertionObject; //-----------------------------------// Assign the display name. The ^ symbol after the variable name means dereferencing.
                                                                                  //// The ^ implies the variable pointed by the address
                                                                                  //// denoted by newnode. We know that is the menu item struct.
   newNode^.ID           := ID;     //--------------------------------------------// The unique numerical (Integer) ID
   newNode^.name         := IDName; //--------------------------------------------// The internal name
   newNode^.next         := nil;    //--------------------------------------------// We do not know what will follow, so set everything to nil
                                                                                  //// Pascal has 'nil' to support the nulltype.
   newNode^.prev         := nil;
   newNode^.Children     := nil;
   newNode^.Parent       := nil;

   newNode^.isSubMenu    := False; //---------------------------------------------// This function will not be called to add a submenu
   newNode^.hasCheckBox  := False; //---------------------------------------------// Unless it is specified, set to be false
   newNode^.checkBoxStatus:=False; //---------------------------------------------// Set it to false, because no other info supplied
   newNode^.hasPicture   := False; //---------------------------------------------// Same Logic
   newNode^.picturePath  := ''; //------------------------------------------------// NOTHING. main menu should not have any of this.

   newNode^.isSubMenuDrawn:=False; //---------------------------------------------// Submenu is not drawn Yet
   newNode^.subMenuContainer:= nil;//---------------------------------------------// Currently Nothing

   newNode^.BGColorCp    := clNone;
   newNode^.BGColorCopied:= False;
   newNode^.FGColorCp    := clNone;
   newNode^.FGColorCopied:= False;

   newNode^.hasShortCut  := False;
   newNode^.shortCut     := '';

   newNode^.hasPanelHighLightColor:= False;
   newNode^.panelHighLightColor   := clNone;


   if root = nil then  //---------------------------------------------------------// The tree does not exist yet, i.e. not even the first item of the
                                                                                  // has been defined until this point.
   begin
     new(root); //----------------------------------------------------------------// We know that 'root', the class member variable of the class tree_ofStrings
                                                                                  //// (class used to contain the entire menutree) is of type 'strNodePtr'
                                                                                  //// So I need to allocate a new address usable to point to a stringNodeStruct
                                                                                  //// (definition see above within the type block).
                                                                                  //// That is acomplished using new(root). This creates a new address,
                                                                                  //// the type of which is inferred from the type of 'root'.
                                                                                  //// 'root' is supplied as an argument to root.
                                                                                  //// REFACTOR : do i need it????
     root     := newNode; //------------------------------------------------------// The known address stored in 'newNode' has been assigend to *root* now.
   end
   else
   begin

     currNode    := root;//-------------------------------------------------------// root is set,so we start scanning at Root.
     while currNode^.next <> nil do //--------------------------------------------// As long as there is another element after it, marked as 'next'
     begin
       currNode  := currNode^.next; //--------------------------------------------// Move to next one
     end;

     newNode^.prev  := currNode; //-----------------------------------------------// Update new node. Now, newnode is an address
                                                                                  //// So all changes in the variable held in this address
                                                                                  //// will be reflected even after we add it to the double linked list
     currNode^.next := newNode; //------------------------------------------------// Add to the List...

   end;
end;

procedure tree_ofStrings.AppendString_asSubNode(var target: mt ; var insertionObject: String; var ID: Integer);
                                                               // ----------------// ++++ THIS FUNCTION IS NOT CURRENTLY RELIABLE
var
   newNode                       : ^stringNodeStruct;
   currNode                      : ^stringNodeStruct;

   argStr                        : String;

   ii                            : Integer;
   ii_id                         : Integer;
   ti                            : vc;
   nodeNum                       : Integer;
   branchNum                     : Integer;

   jj                            : Integer;
   jj_id                         : Integer;

begin

   currNode := root;

   for ii   := 0 to length(target) -1 do
   begin
     ti     := target[ii];
     nodeNum:= ti[0];
     branchNum:=ti[1];

     for jj := 1 to nodeNum do
     begin
       currNode := currNode^.next;
     end;

     if (branchNum > -1) then
     begin
       currNode := currNode^.Children[branchNum];
     end;
   end;

   if length(currNode^.Children) = 0 then
   begin
     newNode               := New(strNodePtr);
     newNode^.stringVal    := insertionObject;
     newNode^.ID           := ID;
     newNode^.next         := nil;
     newNode^.prev         := nil;
     newNode^.Children     := nil;
     newNode^.Parent       := nil;
     newNode^.BGColorCp    := clNone;
     newNode^.BGColorCopied:= False;
     newNode^.FGColorCp    := clNone;
     newNode^.FGColorCopied:= False;

     newNode^.hasShortCut  := False;
     newNode^.shortCut     := '';
     newNode^.isSubMenuDrawn:=False; //-------------------------------------------// Submenu is not drawn Yet
     newNode^.subMenuContainer:= nil;//-------------------------------------------// Currently Nothing

     SetLength(currNode^.Children, length(currNode^.Children)+1);
     currNode^.Children[length(currNode^.Children) - 1] := newNode;
   end
   else
   begin
     newNode               := New(strNodePtr);
     newNode^.stringVal    := insertionObject;
     newNode^.ID           := ID;
     newNode^.next         := nil;
     newNode^.prev         := nil;
     newNode^.Children     := nil;
     newNode^.Parent       := nil;
     newNode^.BGColorCp    := clNone;
     newNode^.BGColorCopied:= False;
     newNode^.FGColorCp    := clNone;
     newNode^.FGColorCopied:= False;

     newNode^.hasShortCut  := False;
     newNode^.shortCut     := '';
     newNode^.isSubMenuDrawn:=False; //-------------------------------------------// Submenu is not drawn Yet
     newNode^.subMenuContainer:= nil;//-------------------------------------------// Currently Nothing


     newNode^.prev         := currNode^.Children[length(currNode^.Children) - 1] ;
     currNode^.Children[length(currNode^.Children) - 1]^.next := newNode;

     SetLength(currNode^.Children, length(currNode^.Children)+1);
     currNode^.Children[length(currNode^.Children) - 1] := newNode;



   end;


end;


procedure tree_ofStrings.AppendString_asSubNode_byName(var target: String ; var insertionObject: String; var name: String; var ID: Integer);
                                                               // ----------------// ++++ The menus, in any particular level, is a doubly linked list
                                                                                  // ++++ Example, the main menu :
                                                                                  // ++++ File <---> Edit <---> View <---> Tools .. etc
                                                                                  // ++++ or, the submenus of menu entry "File" :
                                                                                  // ++++ New <---> Open <---> Save <---> Close <---> Quit program .. etc.
                                                                                  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                                                                  // ++++ This PROCEDURE inserts a sub menu item as a child to a given menu.
                                                                                  // ++++ The children item itself always is also a doubly linked list.
                                                                                  // ++++ This function adds an item at the end of that list.
                                                                                  // ++++ For example, for the menu entry "file", the item "children" would be
                                                                                  // ++++ the doubly linked list that contains (using the above example)
                                                                                  // ++++ New <---> Open <---> Save <---> Close <---> Quit program .. etc.
                                                                                  // ++++ Then, the parent of the newly inserted item is adjusted accordingly.
                                                                                  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                                                                  // ++++ Arguments :
                                                                                  // ++++ target          : The parent menu Item (specifically, it's name as string)
                                                                                  // ++++ such as "fileMenu"
                                                                                  // ++++ insertionObject : The display name of the item to be inserted at the END
                                                                                  // ++++ of the doubly linked list used to contain the main menu
                                                                                  // ++++ Example : "Open", or "Save".
                                                                                  // ++++ IDName          : The INTERNAL NAME of the menu item
                                                                                  // ++++ Example : "openMenu", or "saveMenu".
                                                                                  // ++++ ID              : An **UNIQUE** integer ID.
var
   newNode                       : ^stringNodeStruct; //--------------------------// A new node to be inserted
   currNode                      : ^stringNodeStruct; //--------------------------// The current element being inspected, to find the tail element of the list

   argStr                        : String; //-------------------------------------// NOIMPL YET

   ii                            : Integer;//-------------------------------------// Some dummy / Index variables.
   ii_id                         : Integer;
   ti                            : vc;
   nodeNum                       : Integer;
   branchNum                     : Integer;

   jj                            : Integer;
   jj_id                         : Integer;

   nameFound     : Boolean; //----------------------------------------------------// A boolean to track whether the target name was found.
begin
   if (root = nil) then
   begin
     Exit; //---------------------------------------------------------------------// If inserting a submenu, the root item of the main menu list must be set.
   end;
   currNode := root; //-----------------------------------------------------------// If the root item of the main menu is set, continue process
   nameFound:= False;//-----------------------------------------------------------// Have not found yet

   while not (currNode^.next = nil) do //-----------------------------------------// Have not found last element yet.
   begin
     if (currNode^.name = target) then //-----------------------------------------// name has matched with target.
     begin
       nameFound:= True; //-------------------------------------------------------// set the boolean.
                                                                                  // If the boolean was not set, then it would mean that the while loop ran to end
       Break; //------------------------------------------------------------------// break loop.
     end
     else
     begin
       currNode := currNode^.next;  //--------------------------------------------// no match, so continue with the next
     end;
   end;

   if not nameFound then Exit;  //------------------------------------------------// If you have not found any match, but the while loop just ended,
                                                                                  // Exit.
                                                                                  // otherwise, the parent (given by 'target') is matched
                                                                                  // and saved in 'currnode'

   if length(currNode^.Children) = 0 then  //-------------------------------------// is there is no children yet
   begin
     newNode               := New(strNodePtr);  //--------------------------------// create newnode ( create a pointer)
     newNode^.stringVal    := insertionObject;  //--------------------------------// Insert the data
     newNode^.ID           := ID;
     newNode^.name         := name;
     newNode^.next         := nil;
     newNode^.prev         := nil; //---------------------------------------------// no prev, and no next as newnode will be the only child so far
     newNode^.Children     := nil;
     newNode^.Parent       := currNode; //----------------------------------------// currNode, which matched the expected parent
                                                                                  // is set as the parent of the newNode


     newNode^.isSubMenu    := True; //--------------------------------------------// This function will not be called to add a submenu
     newNode^.hasCheckBox  := False; //-------------------------------------------// Unless it is specified, set to be false
     newNode^.checkBoxStatus:=False; //-------------------------------------------// Set it to false, because no other info supplied
     newNode^.hasPicture   := False; //-------------------------------------------// Same Logic
     newNode^.picturePath  := ''; //----------------------------------------------// NOTHING. main menu should not have any of this.
     newNode^.isSubMenuDrawn:=False; //-------------------------------------------// Submenu is not drawn Yet
     newNode^.subMenuContainer:= nil;//-------------------------------------------// Currently Nothing
     newNode^.hasShortCut  := False;
     newNode^.shortCut     := '';

     newNode^.BGColorCp    := clNone;
     newNode^.BGColorCopied:= False;
     newNode^.FGColorCp    := clNone;
     newNode^.FGColorCopied:= False;


     newNode^.hasPanelHighLightColor:= False;
     newNode^.panelHighLightColor   := clNone;


     SetLength(currNode^.Children, length(currNode^.Children)+1); //--------------// Children array is increased in size by 1
     currNode^.Children[length(currNode^.Children) - 1] := newNode; //------------// Newly created iten is insreted in Children array
   end
   else //------------------------------------------------------------------------// Some children Exists.
   begin
     newNode               := New(strNodePtr); //---------------------------------// same as above.
     newNode^.stringVal    := insertionObject;
     newNode^.ID           := ID;
     newNode^.name         := name;
     newNode^.next         := nil;
     newNode^.prev         := nil; //---------------------------------------------// initialize as nil, but will change soon
     newNode^.Children     := nil;
     newNode^.Parent       := currNode;
     newNode^.prev         := currNode^.Children[length(currNode^.Children) - 1]; // here, the prev field of the new node is set as the address of
                                                                                  // the last child in the children field of the parent
                                                                                  // (parent is given by currnode)
     newNode^.isSubMenu    := True; //--------------------------------------------// This function will not be called to add a submenu
     newNode^.hasCheckBox  := False; //-------------------------------------------// Unless it is specified, set to be false
     newNode^.checkBoxStatus:=False; //-------------------------------------------// Set it to false, because no other info supplied
     newNode^.hasPicture   := False; //-------------------------------------------// Same Logic
     newNode^.picturePath  := ''; //----------------------------------------------// NOTHING. main menu should not have any of this.
     newNode^.isSubMenuDrawn:=False; //-------------------------------------------// Submenu is not drawn Yet
     newNode^.subMenuContainer:= nil;//-------------------------------------------// Currently Nothing
     newNode^.hasShortCut  := False;
     newNode^.shortCut     := '';

     newNode^.BGColorCp    := clNone;
     newNode^.BGColorCopied:= False;
     newNode^.FGColorCp    := clNone;
     newNode^.FGColorCopied:= False;


     newNode^.hasPanelHighLightColor:= False;
     newNode^.panelHighLightColor   := clNone;

     currNode^.Children[length(currNode^.Children) - 1]^.next := newNode; //------// newnode is assigned as the next item of the last element
                                                                                  // of the children (newnode is not inserted in the children array yet)

     SetLength(currNode^.Children, length(currNode^.Children)+1); //--------------// Children array is updated as before.
     currNode^.Children[length(currNode^.Children) - 1] := newNode;



   end;


end;

procedure tree_ofStrings.AppendString_asSubSubNode_byName(var target: String ; var insertionObject: String; var name: String; var ID: Integer);
                                                               // ----------------// ++++ The menus, in any particular level, is a doubly linked list
                                                                                  // ++++ Example, the main menu :
                                                                                  // ++++ File <---> Edit <---> View <---> Tools .. etc
                                                                                  // ++++ or, the submenus of menu entry "File" :
                                                                                  // ++++ New <---> Open <---> Save <---> Close <---> Quit program .. etc.
                                                                                  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                                                                  // ++++ This PROCEDURE inserts a sub menu item as a child to a given menu.
                                                                                  // ++++ The children item itself always is also a doubly linked list.
                                                                                  // ++++ This function adds an item at the end of that list.
                                                                                  // ++++ For example, for the menu entry "file", the item "children" would be
                                                                                  // ++++ the doubly linked list that contains (using the above example)
                                                                                  // ++++ New <---> Open <---> Save <---> Close <---> Quit program .. etc.
                                                                                  // ++++ Then, the parent of the newly inserted item is adjusted accordingly.
                                                                                  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                                                                  // ++++ Arguments :
                                                                                  // ++++ target          : The parent menu Item (specifically, it's name as string)
                                                                                  // ++++ such as "fileMenu"
                                                                                  // ++++ insertionObject : The display name of the item to be inserted at the END
                                                                                  // ++++ of the doubly linked list used to contain the main menu
                                                                                  // ++++ Example : "Open", or "Save".
                                                                                  // ++++ IDName          : The INTERNAL NAME of the menu item
                                                                                  // ++++ Example : "openMenu", or "saveMenu".
                                                                                  // ++++ ID              : An **UNIQUE** integer ID.
var
   newNode                       : ^stringNodeStruct; //--------------------------// A new node to be inserted
   currNode                      : ^stringNodeStruct; //--------------------------// The current element being inspected, to find the tail element of the list

   argStr                        : String; //-------------------------------------// NOIMPL YET

   ii                            : Integer;//-------------------------------------// Some dummy / Index variables.
   ii_id                         : Integer;
   ti                            : vc;
   nodeNum                       : Integer;
   branchNum                     : Integer;

   jj                            : Integer;
   jj_id                         : Integer;

   nameFound     : Boolean; //----------------------------------------------------// A boolean to track whether the target name was found.
begin
   if (root = nil) then
   begin
     Exit; //---------------------------------------------------------------------// If inserting a submenu, the root item of the main menu list must be set.
   end;
   currNode := root; //-----------------------------------------------------------// If the root item of the main menu is set, continue process
   nameFound:= False;//-----------------------------------------------------------// Have not found yet


   while (True) do //-------------------------------------------------------------// Have not found last element yet.
   begin

     if (currNode^.name = target) then //-----------------------------------------// name has matched with target.
     begin



       nameFound:= True; //-------------------------------------------------------// set the boolean.
                                                                                  // If the boolean was not set, then it would mean that the while loop ran to end
       Break; //------------------------------------------------------------------// break loop.
     end;


     //---------------------------------------------------------------------------// If at this point, then nothing was found yet


     if ( Length(currNode^.Children) <> 0) then
     begin
       currNode := currNode^.Children[0]; //--------------------------------------// take the the first child
       Continue; //---------------------------------------------------------------// Go back to the begining
     end;


     //---------------------------------------------------------------------------// If at this point, then nothing was found yet,
                                                                                  // and no children


     if (currNode^.next <> nil) then
     begin
       currNode := currNode^.next; //---------------------------------------------// take the the next element
       Continue; //---------------------------------------------------------------// Go back to the begining
     end;


     //---------------------------------------------------------------------------// If at this point, then nothing was found yet,
                                                                                  // and no children, and nothing next


     if (currNode^.Parent <> nil) then //-----------------------------------------// Need to jump back
     begin
      currNode  := currNode^.Parent;  //------------------------------------------// parent reached, but parent was already checked.
      if (currNode^.next <> nil) then //------------------------------------------// check if we can do it
      begin
        currNode:= currNode^.next;
        Continue;
      end; //---------------------------------------------------------------------// If can't find next of parent,
                                                                                  // controll will go past this point
                                                                                  // and the next 'end' keyword
                                                                                  // and reach break
     end;


     Break;
   end;


   if not nameFound then Exit;  //------------------------------------------------// If you have not found any match, but the while loop just ended,
                                                                                  // Exit.
                                                                                  // otherwise, the parent (given by 'target') is matched
                                                                                  // and saved in 'currnode'

   if length(currNode^.Children) = 0 then  //-------------------------------------// is there is no children yet
   begin
     newNode               := New(strNodePtr);  //--------------------------------// create newnode ( create a pointer)
     newNode^.stringVal    := insertionObject;  //--------------------------------// Insert the data
     newNode^.ID           := ID;
     newNode^.name         := name;
     newNode^.next         := nil;
     newNode^.prev         := nil; //---------------------------------------------// no prev, and no next as newnode will be the only child so far
     newNode^.Children     := nil;
     newNode^.Parent       := currNode; //----------------------------------------// currNode, which matched the expected parent
                                                                                  // is set as the parent of the newNode


     newNode^.isSubMenu    := True; //--------------------------------------------// This function will not be called to add a submenu
     newNode^.hasCheckBox  := False; //-------------------------------------------// Unless it is specified, set to be false
     newNode^.checkBoxStatus:=False; //-------------------------------------------// Set it to false, because no other info supplied
     newNode^.hasPicture   := False; //-------------------------------------------// Same Logic
     newNode^.picturePath  := ''; //----------------------------------------------// NOTHING. main menu should not have any of this.
     newNode^.isSubMenuDrawn:=False; //-------------------------------------------// Submenu is not drawn Yet
     newNode^.subMenuContainer:= nil;//-------------------------------------------// Currently Nothing
     newNode^.hasShortCut  := False;
     newNode^.shortCut     := '';

     newNode^.hasPanelHighLightColor:= False;
     newNode^.panelHighLightColor   := clNone;

     newNode^.BGColorCp    := clNone;
     newNode^.BGColorCopied:= False;
     newNode^.FGColorCp    := clNone;
     newNode^.FGColorCopied:= False;


     SetLength(currNode^.Children, length(currNode^.Children)+1); //--------------// Children array is increased in size by 1
     currNode^.Children[length(currNode^.Children) - 1] := newNode; //------------// Newly created iten is insreted in Children array
   end
   else //------------------------------------------------------------------------// Some children Exists.
   begin
     newNode               := New(strNodePtr); //---------------------------------// same as above.
     newNode^.stringVal    := insertionObject;
     newNode^.ID           := ID;
     newNode^.name         := name;
     newNode^.next         := nil;
     newNode^.prev         := nil; //---------------------------------------------// initialize as nil, but will change soon
     newNode^.Children     := nil;
     newNode^.Parent       := currNode;
     newNode^.prev         := currNode^.Children[length(currNode^.Children) - 1]; // here, the prev field of the new node is set as the address of
                                                                                  // the last child in the children field of the parent
                                                                                  // (parent is given by currnode)
     newNode^.isSubMenu    := True; //--------------------------------------------// This function will not be called to add a submenu
     newNode^.hasCheckBox  := False; //-------------------------------------------// Unless it is specified, set to be false
     newNode^.checkBoxStatus:=False; //-------------------------------------------// Set it to false, because no other info supplied
     newNode^.hasPicture   := False; //-------------------------------------------// Same Logic
     newNode^.picturePath  := ''; //----------------------------------------------// NOTHING. main menu should not have any of this.
     newNode^.isSubMenuDrawn:=False; //-------------------------------------------// Submenu is not drawn Yet
     newNode^.subMenuContainer:= nil;//-------------------------------------------// Currently Nothing
     newNode^.hasShortCut  := False;
     newNode^.shortCut     := '';

     newNode^.hasPanelHighLightColor:= False;
     newNode^.panelHighLightColor   := clNone;

     newNode^.BGColorCp    := clNone;
     newNode^.BGColorCopied:= False;
     newNode^.FGColorCp    := clNone;
     newNode^.FGColorCopied:= False;

     currNode^.Children[length(currNode^.Children) - 1]^.next := newNode; //------// newnode is assigned as the next item of the last element
                                                                                  // of the children (newnode is not inserted in the children array yet)

     SetLength(currNode^.Children, length(currNode^.Children)+1); //--------------// Children array is updated as before.
     currNode^.Children[length(currNode^.Children) - 1] := newNode;



   end;


end;

end.



