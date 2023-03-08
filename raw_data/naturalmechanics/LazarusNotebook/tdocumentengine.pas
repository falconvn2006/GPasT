unit TDocumentEngine;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, ExtCtrls, SysUtils;

type

 //-------------------------          TYPE and MARKER ENUMS ----------------------//

 nodeTypes     = (          unknown,         //-----------------------------------// Syntax check passes, but no match
                            pageCommand,     //-----------------------------------// Impacts the entire page, syntax is .. COMMAND ; newline
                            patternCommand,  //-----------------------------------// Impacts a matched pattern, syntax is .# COMMAND ; newline
                            blockCommand,    //-----------------------------------// Impacts a block. Syntax is .! COMMAND ; newline
                            renderTargetDiv, //-----------------------------------// A block. starts with .[, ends with a ]. and newline
                            renterTargetSpan,//-----------------------------------// A section within a block. Syntax .[[ .! command ; content ]]. no newline
                            shapeDrawing,    //-----------------------------------// A drawing. syntax -|- drawing COMMANDS ; newline
                            remoteResource,  //-----------------------------------// An embeddable resource. starts with .( ends with ). and newline
                            incomplete,      //-----------------------------------// Partially matches syntax. not full match yet
                            erroneous        //-----------------------------------// Error
                 );

 formatShorthands=(
                            chapterHeading,  //-----------------------------------// large Heading.   Syntax ##    Heading ;
                            sectionHeading,  //-----------------------------------// medium heading.  Syntax ###   Heading ;
                            subSectionHeading,//----------------------------------// smaller heading. Syntax ####  Heading ;
                            paragraphHeading,//-----------------------------------// Small Heading.   Syntax ##### Heading ;
                            enummeratedList, //-----------------------------------// List with numbers or letters.  Syntax -- Item ;
                            itemList,        //-----------------------------------// List without numbers           Syntax -* Item ;
                            listHeading,     //-----------------------------------// Heading of a list item         Syntax -# Item ;
                            table,           //-----------------------------------// Table...  Syntax ____ (4 underscores) newline |_ item _| for each cell . left side : TOP and LEFT border, right side BOTTOM and RIGHT border. removing one will remove the border. newline. 4 underscores
                            tableHeading,    //-----------------------------------// table heading.   Syntax #_ Heading ;
                            navigation,      //-----------------------------------// A navigation Item, like a link, an anchor, a reference. Syntax  :: NAVIGATION TYPE :: NAME :: TARGET ; Newline   CONTENT ::;
                            box,             //-----------------------------------// A free floating box. Syntax .[] identifier list (comma sep) newline .! COMMAND ; newline .! COMMAND ; newline  Content newline [].
                            side,            //-----------------------------------// A section with a syntactic meaning, such as header or sidebar. Syntax : .| Side type (e.g. footer) newline .! COMMAND ; newline content newline |.
                            highlight,       //-----------------------------------// A formatted segment, such as quote. Syntax .// identifier list newline .! COMMAND ;newline content newline //.
                            equation,        //-----------------------------------// A equation Syntax .= identifier list newline  content =.
                            symbolic,        //-----------------------------------// A symbol area Syntax .$ identifier list newline content $.
                            region           //-----------------------------------// Similar to highlight, but with .@ @.- TO BE IMPLEMENTED
                 );








//#############################################################################################################################






 //-------------------------       PAGE COMMANDS        --------------------------// AFFECTS EVERYTHING on the page
                                                                                  // SUCH as background color, font, margins
                                                                                  // etc

 TPageCommandPtr = ^TPageCommand; //----------------------------------------------// Pointer declared before the object
 TPageCommand    = Packed Record  //----------------------------------------------// The actual Page command object

   //------------------------      Basic COMMANDS       --------------------------// ASSUME PAGE IS RECTANGLE

   rectangleMargin      : Array of Integer; //------------------------------------// 4 side margins
   paragraphSpacing     : Integer; //---------------------------------------------// Space between paragraphs
   lineSpacing          : Integer; //---------------------------------------------// space between lines


   //------------------------      Font COMMANDS       ---------------------------// ASSUME FONT IS USED, and not pixel drawing

   isFontRenderable     : Boolean; //---------------------------------------------// Can be font or some other things
   fontBaseColor        : TColor;
   fontBaseSize         : Integer;
   fontBaseName         : String; //----------------------------------------------// Keep as string;
   fontZoomLevel        : Integer; //---------------------------------------------// Affects only fonts


   //------------------------      Page COMMANDS       ---------------------------// Colors etc

   pageBaseColor        : TColor; //----------------------------------------------// background color
   pagePencolor         : TColor; //----------------------------------------------// Default Drawing pen
   pageHighLightColor   : TColor; //----------------------------------------------// Default highlighting
   pageFillColor        : TColor; //----------------------------------------------// Default fill color of shapes
   pageFillTransparency : Integer;//----------------------------------------------// NOIMPL - not supported by LCL YET



   //----------------------      Linked list items       -------------------------// Neighbors etc

   prev                 : TPageCommandPtr;
   next                 : TPageCommandPtr;



   //----------------------     Command Description      -------------------------// Neighbors etc

   id                   : Integer;
   command              : String;


 end;








 //#############################################################################################################################









 //-------------------------     PATTERN COMMANDS       --------------------------// AFFECTS a particular Text where the pattern is matched
                                                                                  // SUCH as background color, font, margins
                                                                                  // etc. To match all blocks procedurally, use patten commands

 stringSections         = Array of String; //-------------------------------------// A sentence can be made out of sections, each a string
                                                                                  // Need this type inside the record
                                                                                  // I could write array of array of String,
                                                                                  // But it MIGHT cause problems !
 TPatternCommandPtr = ^TPatternCommand;
 TPatternCommand = Packed Record

   //----------------------     Match information        -------------------------// Colors etc

   pattern              : String;
   input                : String;
   matches              : Array of Array of string; //Sections; //-----------------------------// Multiple matches. Each a sentence
                                                                                  // Sentence = stringSections



   //----------------------     Format information       -------------------------// Colors etc

   isFontRenderable     : Boolean; //---------------------------------------------// Can be font or some other things
   fontNewColor         : TColor;
   fontNewSize          : Integer;
   fontNewName          : String; //----------------------------------------------// Keep as string;
   fontNewFormat        : Integer; //---------------------------------------------// Such as bold or italics
                                                                                  // 0: None
                                                                                  // 1: Bold
                                                                                  // 2: Italics
                                                                                  // 3: Bold + Italics
                                                                                  // 4: Underline
                                                                                  // 4+1 = 5 : Underline + Bold
                                                                                  // 8: Strikethrough
                                                                                  // 16: Overline
                                                                                  // 32: Superscript
                                                                                  // 64: Subscript
                                                                                  //etc
   fontZoomLevel        : Integer; //---------------------------------------------// Affects only fonts
   


   //----------------------      Linked list items       -------------------------// Neighbors, ID etc

   prev                 : TPatternCommandPtr;
   next                 : TPatternCommandPtr;

   id                   : Integer;

 end;








 //#############################################################################################################################









 //-------------------------       BLOCK COMMANDS       --------------------------// AFFECTS a particular block, where it is applied
                                                                                  // SUCH as background color, font, margins
                                                                                  // etc. To match all blocks procedurally, use patten commands

 TBlockCommandPtr= ^TBlockCommand;
 TBlockCommand   = Packed Record

   //----------------------     Format information       -------------------------// Colors etc

   isFontRenderable     : Boolean; //---------------------------------------------// Can be font or some other things
   fontNewColor         : TColor;
   fontNewSize          : Integer;
   fontNewName          : String; //----------------------------------------------// Keep as string;
   fontNewFormat        : Integer; //---------------------------------------------// Such as bold or italics
                                                                                  // 0: None
                                                                                  // 1: Bold
                                                                                  // 2: Italics
                                                                                  // 3: Bold + Italics
                                                                                  // 4: Underline
                                                                                  // 4+1 = 5 : Underline + Bold
                                                                                  // 8: Strikethrough
                                                                                  // 16: Overline
                                                                                  // 32: Superscript
                                                                                  // 64: Subscript
                                                                                  //etc
   fontZoomLevel        : Integer; //---------------------------------------------// Affects only fonts



   //----------------------      Linked list items       -------------------------// Neighbors, ID etc

   prev                 : TBlockCommandPtr;
   next                 : TBlockCommandPtr;

   id                   : Integer;


 end;










 //#############################################################################################################################











 //-------------------------     DOCUMENT STRUCTURE     --------------------------// Components, Nodes, etc...


 TDocumentNodePtr = ^TDocumentNode;
 TDocumentNode = Packed Record


   //----------------------------   BLOCK TYPE    --------------------------------//

   blockType            : nodeTypes;



   //----------------------------      DATA       --------------------------------//

   blockData            : String;  //---------------------------------------------// If Renderable text, then render the entire text
                                                                                  // otherwise, if remote resource, then decide
                                                                                  // based on file metadata

   blockFormatNode      : TBlockCommandPtr; //------------------------------------// this directly binds format commands to
                                                                                  // the node.
                                                                                  // This can be set to nil to save memory


   //----------------------      Linked list items       -------------------------// Neighbors, ID etc

   prev                 : TDocumentNodePtr;
   next                 : TDocumentNodePtr;

   parent               : TDocumentNodePtr;
   children             : Array of TDocumentNodePtr;

   id                   : Integer;
 end;








 //#############################################################################################################################









 //------------------------      Raw input storage      --------------------------//

 TDocumentInputPtr = ^TDocumentInput;
 TDocumentInput = Packed Record
   inputVal              : String;  //--------------------------------------------// Raw input string
   prev                  : TDocumentInputPtr;
   next                  : TDocumentInputPtr;
 end;











 //#############################################################################################################################










 { TDocument }

 TDocument = Class
   public
     pageCommandSequence: TPageCommandPtr; //-------------------------------------// Page command is a set of global commands
                                                                                  // A doubly linked list where order of commands
                                                                                  // implies the precedence of application
     patternCommands    : Array of TPatternCommandPtr; //-------------------------// Array of separate pattern matching commands,
                                                                                  // EACH of which individually is a doubly linked list
                                                                                  // where the order again implies the precedence of
                                                                                  // application
     blockCommands      : Array of TBlockCommandPtr; //---------------------------// same thing.
                                                                                  // Each block command has an ID,
                                                                                  // so that the render Engine can look up the
                                                                                  // array and find the correct command
     documentTree_rootNode:TDocumentNodePtr; // -----------------------------------// A Doubly linked list, where
                                                                                  // each element can have children, where the
                                                                                  // chlidren are connected as a doubly linked list as well
                                                                                  // each element also has an pointer to a block command
                                                                                  // Each block takes the block command of its parent
                                                                                  // unless the parent is the page itself.
     rawInput           : TDocumentInputPtr; //-----------------------------------// linked list of document nodes,
                                                                                  // even command nodes are in the same list
     constructor  Create();

 end;





 //#############################################################################################################################




 { TDocumentEngine }


 
 //#############################################################################################################################



 { TDocumentParseEngine }

 TDocumentParseEngine = Class
   public
     currDocument       : TDocument;  //------------------------------------------// The document built from parsed inputs so far
     currInputBuffer    : String;     //------------------------------------------// Current buffer

     currPageCommandID  : Integer;    //------------------------------------------// Track page commands

     constructor Create();

     function parse_codeInput() : Boolean; //-------------------------------------// returns true on success.

     function parse_pageCommand(strInput : String) : TPageCommandPtr; //----------// Parse any input
     procedure insert_newPageCommand(pgCommand : TPageCommandPtr); //-------------// Insert page commands. This function is used
                                                                                  // ONLY in conjuction with page commands.

     function identify_inputBlock() : NodeTypes; //-------------------------------// Identify what is sent in

     function get_newPageCommandID() : Integer;  //-------------------------------// Get new page ID

 end;


 
//#############################################################################################################################


Implementation

{ TDocumentEngine }

constructor TDocumentParseEngine.Create;
begin
  currDocument  := TDocument.Create(); //-----------------------------------------// a NEW DOCUMENT IS CREATED

  currPageCommandID := 0; //------------------------------------------------------// ID Tracker set to zero

end;


//#############################################################################################################################


function TDocumentParseEngine.parse_codeInput: Boolean;
var
  i             : nodeTypes;        //--------------------------------------------// Identified node type, an enum
  outStr        : String;           //--------------------------------------------// Used for debuggin only
  r             : Boolean;          //--------------------------------------------// Result
  possibleBlock : TDocumentNodePtr; //--------------------------------------------// Tracker for lookforward NOIMPL

  new_pageCommand: TPageCommandPtr; //--------------------------------------------// container, in case we get a new command
                                                                                  // which is apage command

begin

  //-------------------       Initialize the variables         -------------------//

  r             := False; //------------------------------------------------------// Still dont know what to return



  //-------------------     try to see if the block is workable   ----------------// Will return "incomplete" or "unknown"
                                                                                  // If it fails

  i             := identify_inputBlock(); //--------------------------------------// actually try to identify


  if (i <> unknown) and (i <> incomplete) then //---------------------------------// SOME sort of characterization worked.
  begin
     r          := True; //-------------------------------------------------------// Consider Success
  end;




  //---------------      Check the command types and act in accordance   ---------//

  case i of
       pageCommand:
         begin
           new_pageCommand := parse_pageCommand(currInputBuffer); //--------------// At this point, we know that we have
                                                                                  // a page command

           insert_newPageCommand(new_pageCommand); //-----------------------------// INSERT
           currInputBuffer := ''; //----------------------------------------------// Onsuccess, clear buffer


         end;
  //     patternCommand:
  //       begin
  //          insert_newPatternCommand(currInputBuffer);
  //          currInputBuffer := '';
  //       end;
  //     blockCommand:
  //       begin
  //          possibleBlock := Nil;
  //          possibleBlock := parseBlock(currInputBuffer);
  //          insert_newDocumentBlock(possibleBlock);
  //          assing_relevantBlockFormatCommands();
  //       end;
       else //--------------------------------------------------------------------// it was neither incomplete nor unknwon
                                                                                  // some other error.
                                                                                  // CLEAR buffer
                                                                                  // for incomplete buffering, the next stream
                                                                                  // will include the history as well
                                                                                  // until the sender (mainform) is informed of
                                                                                  // a successful parse
                                                                                  // SO we can flush the current buffer
         begin
            currInputBuffer := ''; //---------------------------------------------// Flush buffer
         end;
  end;

  Result        := r; //----------------------------------------------------------// Return
end;





//#############################################################################################################################





function TDocumentParseEngine.parse_pageCommand(strInput: String   ): TPageCommandPtr;
var
  new_pageCommand: TPageCommandPtr;
  dtls          : Array of String;
  command       : String;
  args          : Array of String;
  breakPos      : Integer;

  ii            : Integer;

  i_arr         : Array of Integer;
  cl            : TColor;
begin

  strInput      := Trim(strInput);
  strInput      := Copy(strInput, 3);
  Delete(strInput, Length(strInput), 1);
  strInput      := Trim(strInput);


  breakPos      := Pos(' ', strInput,1); //----------------------------------------// Offset explicitely zero. returns first match
  command       := Copy(strInput,1,breakPos);
  args          := (Copy(strInput, breakPos +1)).Split(',');

  new_pageCommand:= Nil;

  command       := Trim(Command);

  case command of

       'margin' :

         begin
           if Length(args) <> 0 then
           begin

              new_pageCommand := new(TPageCommandPtr);

              SetLength(i_arr, 0);

              for ii := 0 to length(args) - 1 do
              begin
                SetLength(i_arr, Length(i_arr) + 1);
                i_arr[Length(i_arr) -1] := StrToInt(args[ii]);
              end;

              new_pageCommand^.rectangleMargin := i_arr;
              new_pageCommand^.command         := 'margin';
              new_pageCommand^.id              := get_newPageCommandID();
              new_pageCommand^.next            := nil;
              new_pageCommand^.prev            := nil;


              // showMessage('created command : ' + new_pageCommand^.command );

           end;
         end;

       'color' :

         begin
           if Length(args) <> 0 then
           begin

              new_pageCommand := new(TPageCommandPtr);

              SetLength(i_arr, 0);

              for ii := 0 to length(args) - 1 do
              begin
                SetLength(i_arr, Length(i_arr) + 1);
                i_arr[Length(i_arr) -1] := StrToInt(args[ii]);
              end;

              cl                               := RGBToColor(i_arr[0], i_arr[1], i_arr[2]);
              new_pageCommand^.pageFillColor   := cl;
              new_pageCommand^.pageFillTransparency:= i_arr[3];
              new_pageCommand^.command         := 'color';
              new_pageCommand^.id              := get_newPageCommandID();
              new_pageCommand^.next            := nil;
              new_pageCommand^.prev            := nil;


              // showMessage('created command : ' + new_pageCommand^.command );

           end;
         end;

       // 'nextcommand' :

  end;

  // showMessage('returning command : ' + new_pageCommand^.command );
  Result        := new_pageCommand;

end;

procedure TDocumentParseEngine.insert_newPageCommand(pgCommand: TPageCommandPtr   );
var
  i             : Integer;
  currCommand   : TPageCommandPtr;
begin

  // showMessage('pagecommand inserting');

  if (currDocument.pageCommandSequence = Nil) then
  begin
     new(currDocument.pageCommandSequence);
     currDocument.pageCommandSequence := pgCommand;

     // showMessage(pgCommand^.command);
     // showMessage(currDocument.pageCommandSequence^.command);
  end
  else
  begin

    currCommand := currDocument.pageCommandSequence;

    while (True) do
    begin

      if (currCommand^.next = Nil) then
      begin
         Break;
      end;
    end;

    pgCommand^.prev   := currCommand;
    currCommand^.next := pgCommand;

  end;

end;

function TDocumentParseEngine.identify_inputBlock : NodeTypes;
var
  classificationResult             : nodeTypes;
  testLine      : String;
  firstTwo      : String;
  lastTwo       : String;
  firstOne      : String;
  lastOne       : String;
begin
  classificationResult := unknown; //---------------------------------------------// NOT KNOWN YET

  testLine      := currInputBuffer; //--------------------------------------------// Set to current Input Buffer
  testLine      :=  Trim(testLine) ; //--------------------------------------------// remove the whitespaces

  writeln('Testline is : ' + testLine);

  if (length(testLine) = 0) then
  begin
     classificationResult := unknown;//-------------------------------------------// FAILED to classify, line length 0
  end
  else
  begin
    firstOne    :=  LeftStr(testLine, 1);
    firstTwo    :=  LeftStr(testLine, 2);

    lastOne     :=  RightStr(testLine, 1);
    lastTwo     :=  RightStr(testLine, 2);

    if (firstTwo = '..') and (lastTwo <> '\;') and (lastOne = ';') then
    begin
       classificationResult := pageCommand;
    end;

    if (firstTwo = '..') and (lastTwo <> '\;') and (lastOne <> ';') then
    begin
       classificationResult := incomplete;
    end;

    if (firstTwo = '.#') and (lastTwo <> '\;') and (lastOne = ';') then
    begin
       classificationResult := patternCommand;
    end;

    if (firstTwo = '.#') and (lastTwo <> '\;') and (lastOne <> ';') then
    begin
       classificationResult := incomplete;
    end;

    if (firstone = '.') and (firstTwo <> '..') and (firstTwo <> '.#') and (lastTwo <> '\;') and (lastOne = ';') then
    begin
       classificationResult := blockCommand;
    end;

    if (firstone = '.') and (firstTwo <> '..') and (firstTwo <> '.#') and (lastTwo <> '\;') and (lastOne <> ';') then
    begin
       classificationResult := incomplete;
    end;

    if (firstone <> '.') then
    begin
       classificationResult := renderTargetDiv;
    end;

  end;


  Result :=    classificationResult; //-------------------------------------------// RETURN
end;

function TDocumentParseEngine.get_newPageCommandID: Integer;
var
  currVal       : Integer;
begin
  currVal       := currPageCommandID;
  currPageCommandID := currPageCommandID + 1;

  Result := currVal;
end;

{ TDocument }

constructor TDocument.Create;
begin
  pageCommandSequence := Nil;
  patternCommands := Nil;
  blockCommands := Nil;

  documentTree_rootNode := Nil;
  rawInput      := Nil;
end;

end.

