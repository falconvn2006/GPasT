
{****************************************************************************}
{                                                                            }
{ XMLComponents Library                                                      }
{                                                                            }
{ Copyright (c) 1999,2002 e-delos.com / XMLComponents. All rights reserved.  }
{ See license before use.                                                    }
{                                                                            }
{ http://xmlcomponents.com                                                   }
{ http://xmlrad.com                                                          }
{                                                                            }
{****************************************************************************}

UNIT XMLCursor;

INTERFACE

{$IFNDEF MSWINDOWS}
{$IFDEF WIN32}
{$DEFINE MSWINDOWS}
{$ENDIF}
{$ENDIF}

USES Sysutils, Classes, ComObj,
    StdXML_TLB, MSXML2_TLB;

TYPE
    IXMLCursorInternal = INTERFACE
        ['{D9329CA1-C252-11D4-8896-0060087D03E0}']
        FUNCTION Get_CurrentNodeList: IXMLDOMNodeList;
    END;
    TXMLCursor = CLASS(TAutoIntfObject, IXMLCursor, IXMLCursorInternal)
    PRIVATE
        FCurrentNode: IXMLDOMNode;
        FCurrentNodeList: IXMLDOMNodeList;
        FEOF: Boolean;
        FPosition: Integer;
        FXMLDOMDocument: IXMLDOMDocument;
//    function  ElementContainer: IXMLDOMNode;
    PROTECTED
        PROCEDURE Assign(CONST CursorSource: TXMLCursor);
    PROTECTED
        FUNCTION Get_CurrentNodeList: IXMLDOMNodeList;
    PROTECTED
   { IXMLCursor }
        FUNCTION Get_CurrentNode: IXMLDOMNode;
        FUNCTION AppendChild(CONST ElementName: WideString; CONST Value: WideString): IXMLCursor; SAFECALL;
        PROCEDURE AppendXMLCursor(CONST XMLCursor: IXMLCursor); SAFECALL;
        FUNCTION ContainerXML: WideString; SAFECALL;
        FUNCTION Count: Integer; SAFECALL;
        PROCEDURE Delete; SAFECALL;
        FUNCTION Document: IXMLCursor; SAFECALL;
        FUNCTION EOF: WordBool; SAFECALL;
        PROCEDURE First; SAFECALL;
        FUNCTION GetName: WideString; SAFECALL;
        FUNCTION GetValue(CONST XPath: WideString): WideString; SAFECALL;
        FUNCTION Get_Values(CONST Name: WideString): WideString; SAFECALL;
        FUNCTION InsertBefore(CONST ElementName, Value: WideString): IXMLCursor; SAFECALL;
        FUNCTION InsertAfter(CONST ElementName, Value: WideString): IXMLCursor; SAFECALL;
        PROCEDURE Last; SAFECALL;
        PROCEDURE Load(CONST FileName: WideString); SAFECALL;
        PROCEDURE LoadXML(CONST SourceXML: WideString); SAFECALL;
        PROCEDURE MoveTo(Index: Integer); SAFECALL;
        PROCEDURE Next; SAFECALL;
        FUNCTION RecNo: Integer; SAFECALL;
        PROCEDURE ReplaceWithXMLCursor(CONST XMLCursor: IXMLCursor); SAFECALL;
        PROCEDURE Save(CONST FileName: WideString); SAFECALL;
        FUNCTION Select(CONST XPath: WideString): IXMLCursor; SAFECALL;
        PROCEDURE SetAttributeValue(CONST AttributeName, Value: WideString); SAFECALL;
        PROCEDURE SetCValue(CONST ElementName, Value: WideString); SAFECALL;
        PROCEDURE SetValue(CONST ElementName, Value: WideString); SAFECALL;
        PROCEDURE Set_Values(CONST Name: WideString; CONST Value: WideString); SAFECALL;
        FUNCTION XML: WideString; SAFECALL;
        FUNCTION XMLDOMDocument: IUnknown; SAFECALL; // !!! Do not use this function for multi-platform applications
        FUNCTION XMLDOMNode: IUnknown; SAFECALL; // !!! Do not use this function for multi-platform applications
    PUBLIC
        CONSTRUCTOR Create; VIRTUAL;
        DESTRUCTOR Destroy; OVERRIDE;
    END;

    TXSLProc = CLASS(TAutoIntfObject, IXSLProc)
    PROTECTED
        FFileName: STRING;
        FFiles: TStrings;
        FUpToDate: Boolean;
        FXSLTemplate: IXSLTemplate;
        FXSLProcessor: IXSLProcessor;
    PROTECTED
   // IXSLProc
        FUNCTION IsUpToDate: WordBool; SAFECALL;
        PROCEDURE Load(CONST AFileName: WideString); SAFECALL;
        FUNCTION Process(CONST Document: IXMLCursor): WideString; SAFECALL;
    PUBLIC
        CONSTRUCTOR Create; VIRTUAL;
        DESTRUCTOR Destroy; OVERRIDE;
    END;

IMPLEMENTATION

USES
    Windows, ActiveX;

FUNCTION DirectoryExists(CONST Name: STRING): Boolean;
VAR
    Code: Integer;
BEGIN
    Code := Integer(GetFileAttributes(PChar(Name)));
    Result := (Code <> -1) AND (FILE_ATTRIBUTE_DIRECTORY AND Code <> 0);
END;

PROCEDURE ForceDirectories(Dir: STRING);
BEGIN
    IF Length(Dir) = 0 THEN
        RAISE Exception.Create('Cannot Create Directory');
    IF (AnsiLastChar(Dir) <> NIL) AND (AnsiLastChar(Dir)^ = '\') THEN
        Delete(Dir, Length(Dir), 1);
    IF (Length(Dir) < 3) OR DirectoryExists(Dir)
        OR (ExtractFilePath(Dir) = Dir) THEN Exit; // avoid 'xyz:\' problem.
    ForceDirectories(ExtractFilePath(Dir));
    CreateDir(Dir);
END;

FUNCTION GetStdXMLTypeLib: ITypeLib;
{$IFDEF MSWINDOWS}
CONST
    StdXMLTypeLib: ITypeLib = NIL;
{$ENDIF}
RESOURCESTRING
    StdXMLTLB = 'StdXML.tlb';
VAR
    AppFileName: STRING;
    StdXMLTLBPath: STRING;
BEGIN
{$IFDEF MSWINDOWS}
    IF StdXMLTypeLib = NIL THEN
    BEGIN
   // Check if StdXML.tlb is in the application directory
        SetLength(AppFileName, MAX_PATH);
        SetLength(AppFileName, GetModuleFileName(hInstance, PChar(AppFileName), MAX_PATH));
        StdXMLTLBPath := ExtractFilePath(AppFileName) + StdXMLTLB;
        IF NOT FileExists(StdXMLTLBPath) THEN
            StdXMLTLBPath := StdXMLTLB;
        OleCheck(LoadTypeLib(PWideChar(WideString(StdXMLTLB)), StdXMLTypeLib));
    END;
    Result := StdXMLTypeLib;
{$ENDIF}
END;

FUNCTION TranslateChar(CONST Str: STRING; FromChar, ToChar: Char): STRING;
VAR
    I: Integer;
BEGIN
    Result := Str;
    FOR I := 1 TO Length(Result) DO
        IF Result[I] = FromChar THEN
            Result[I] := ToChar;
END;

FUNCTION UnixPathToDosPath(CONST Path: STRING): STRING;
BEGIN
    Result := TranslateChar(Path, '/', '\');
END;

PROCEDURE ReportDOMParseError(Error: IXMLDOMParseError);
RESOURCESTRING
    SErrorMsg = 'Error %d on line %d, char %d in "%s"'#13#10 +
        '%s'#13#10 +
        '%s';
BEGIN
    IF Error.errorCode <> 0 THEN
        RAISE Exception.Create(Format(SErrorMsg, [Error.errorCode, Error.line,
            Error.linePos, Error.url, Error.srcText, Error.reason]));
END;

PROCEDURE reraise(Message: STRING);
VAR
    E, NewE: Exception;
BEGIN
    E := ExceptObject AS Exception;
    NewE := E.ClassType.Create AS Exception;
    NewE.Message := Message + #13#10 + E.Message;
    RAISE NewE;
END;

{ TXMLCursor }

CONSTRUCTOR TXMLCursor.Create;
BEGIN
    TRY
        INHERITED Create(GetStdXMLTypeLib, IXMLCursor);
        FPosition := -1;
        FEOF := True;
    EXCEPT
        reraise('TXMLCursor.Create');
    END;
END;

DESTRUCTOR TXMLCursor.Destroy;
BEGIN
    FCurrentNode := NIL;
    FCurrentNodeList := NIL;
//  if (FXMLDOMDocument <> nil) and (FXMLDOMDocument.documentElement = FCurrentNode) then
    FXMLDOMDocument := NIL;
    INHERITED;
END;

FUNCTION TXMLCursor.AppendChild(CONST ElementName, Value: WideString): IXMLCursor;
VAR
    Element: IXMLDOMElement;
    NewCursor: TXMLCursor;
    NodeList: IXMLDOMNodeList;
BEGIN
    Result := NIL;
    IF FXMLDOMDocument = NIL THEN
    BEGIN
        FXMLDOMDocument := CoFreeThreadedDOMDocument.Create;
        Element := FXMLDOMDocument.createElement(ElementName);
        FXMLDOMDocument.appendChild(Element);
        IF Value <> '' THEN
            Element.text := Value;
        FCurrentNodeList := FXMLDOMDocument.childNodes;
        NodeList := FCurrentNodeList;
        First;
    END ELSE BEGIN
        IF FCurrentNode = NIL THEN
            Exit;
        Element := FXMLDOMDocument.createElement(ElementName);
        FCurrentNode.appendChild(Element);
        IF Value <> '' THEN
            Element.text := Value;
        NodeList := FCurrentNode.childNodes;
    END;
    NewCursor := TXMLCursor.Create;
    NewCursor.FXMLDOMDocument := FXMLDOMDocument;
//  NewCursor.FCurrentNodeList := FCurrentNode.childNodes; // FCurrentNode.selectNodes(ElementName); // !!! Need optimization // !!! Buggy in the case of Document is nil
    NewCursor.FCurrentNodeList := NodeList;
    NewCursor.Last;
    Result := NewCursor;
END;

PROCEDURE TXMLCursor.AppendXMLCursor(CONST XMLCursor: IXMLCursor);
VAR
    Container: IXMLDOMNode;
    I: Integer;
    Node: IXMLDOMNode;
    NodeList: IXMLDOMNodeList;
    XMLCursorInternal: IXMLCursorInternal;
BEGIN
    IF XMLCursor = NIL THEN
        Exit;
    IF XMLCursor.QueryInterface(IXMLCursorInternal, XMLCursorInternal) <> S_OK THEN
        Exit;
    IF XMLCursorInternal = NIL THEN
        Exit;
    NodeList := XMLCursorInternal.Get_CurrentNodeList;
    IF NodeList = NIL THEN
        Exit;
    IF NodeList.length = 0 THEN
        Exit;
    IF FXMLDOMDocument = NIL THEN
    BEGIN
//    raise Exception.Create('TXMLCursor.AppendXMLCursor - FXMLDOMDocument = nil'); // !!! should handle this case
    // In this case XMLCursor should have only one element
        IF NodeList.length > 1 THEN
            RAISE Exception.Create('TXMLCursor.AppendXMLCursor - Cannot add XMLCursor to current since it has more than one element.');
        FXMLDOMDocument := CoFreeThreadedDOMDocument.Create;
        FXMLDOMDocument.appendChild(NodeList.item[0].cloneNode(True));
        Exit;
    END;
    IF FCurrentNode = NIL THEN
        Exit;
    Container := FCurrentNode;
    FOR I := 0 TO NodeList.length - 1 DO
    BEGIN
        Node := NodeList.item[I].cloneNode(True);
        Container.appendChild(Node);
    END;
END;

PROCEDURE TXMLCursor.Assign(CONST CursorSource: TXMLCursor);
BEGIN
    FCurrentNode := CursorSource.FCurrentNode;
    FCurrentNodeList := CursorSource.FCurrentNodeList;
    FPosition := CursorSource.FPosition;
    FXMLDOMDocument := CursorSource.FXMLDOMDocument;
END;

FUNCTION TXMLCursor.ContainerXML: WideString;
BEGIN
    Result := '';
    IF FCurrentNode = NIL THEN
        Exit;
    IF FCurrentNode.parentNode = NIL THEN
        Result := XML
    ELSE
        Result := FCurrentNode.parentNode.xml;
END;

FUNCTION TXMLCursor.Count: Integer;
BEGIN
    Result := 0;
    IF FCurrentNodeList = NIL THEN
        Exit;
    Result := FCurrentNodeList.length;
END;

PROCEDURE TXMLCursor.Delete;
VAR
    ParentNode: IXMLDOMNode;
BEGIN
    IF FCurrentNode = NIL THEN
        Exit;
    ParentNode := FCurrentNode.parentNode;
    IF ParentNode = NIL THEN
        Exit;
    ParentNode.removeChild(FCurrentNode);
    IF FCurrentNodeList = NIL THEN
    BEGIN
        FPosition := -1;
        FCurrentNode := NIL;
        FEOF := True;
        Exit;
    END;
    IF FPosition >= FCurrentNodeList.length THEN
        FPosition := FCurrentNodeList.length - 1;
    FCurrentNode := FCurrentNodeList.item[FPosition];
END;

FUNCTION TXMLCursor.Document: IXMLCursor;
VAR
    NewCursor: TXMLCursor;
BEGIN
    Result := NIL;
    IF FXMLDOMDocument = NIL THEN
        Exit;
    NewCursor := TXMLCursor.Create;
    NewCursor.FXMLDOMDocument := FXMLDOMDocument;
    NewCursor.FCurrentNodeList := FXMLDOMDocument.childNodes;
    NewCursor.First;
    Result := NewCursor;
END;

{
function TXMLCursor.ElementContainer: IXMLDOMNode;
begin
  if FCurrentNode = nil then
    Result := nil
  else
    Result := FCurrentNode.parentNode;
end;
}

FUNCTION TXMLCursor.EOF: WordBool;
BEGIN
    Result := FEOF OR (FPosition = -1);
END;

PROCEDURE TXMLCursor.First;
BEGIN
    MoveTo(0);
END;

FUNCTION TXMLCursor.Get_CurrentNodeList: IXMLDOMNodeList;
BEGIN
    Result := FCurrentNodeList;
END;

FUNCTION TXMLCursor.GetName: WideString;
BEGIN
    Result := '';
    IF FCurrentNode = NIL THEN
        Exit;
    Result := FCurrentNode.nodeName;
END;

FUNCTION TXMLCursor.GetValue(CONST XPath: WideString): WideString;
VAR
    Node: IXMLDOMNode;
    XML: STRING;
BEGIN
    Result := '';
    IF FCurrentNode = NIL THEN
        Exit;
    XML := FCurrentNode.XML;
    Node := FCurrentNode.selectSingleNode(XPath);
    IF Node = NIL THEN
        Exit;
    Result := Node.text;
END;

FUNCTION TXMLCursor.Get_Values(CONST Name: WideString): WideString;
BEGIN
    Result := GetValue(Name);
END;

FUNCTION TXMLCursor.InsertBefore(CONST ElementName, Value: WideString): IXMLCursor;
VAR
    NewCursor: TXMLCursor;
    Element: IXMLDOMElement;
    Node, ParentNode: IXMLDOMNode;
    Position: Integer;
BEGIN
    Result := NIL;
    IF FXMLDOMDocument = NIL THEN
    BEGIN
        Result := AppendChild(ElementName, Value);
        Exit;
    END;
    IF FCurrentNode = NIL THEN
        Exit;
    ParentNode := FCurrentNode.parentNode;
    IF ParentNode = NIL THEN
        Exit;
    Element := FXMLDOMDocument.createElement(ElementName);
    ParentNode.insertBefore(Element, FCurrentNode);
    IF Value <> '' THEN
        Element.text := Value;
    NewCursor := TXMLCursor.Create;
    NewCursor.FXMLDOMDocument := FXMLDOMDocument;
    NewCursor.FCurrentNodeList := ParentNode.childNodes;
    Node := FCurrentNode;
  // retrieve the absolute position of FCurrentNode in parentNode.childNodes
    Position := 0;
    WHILE True DO
    BEGIN
        Node := Node.previousSibling;
        IF Node = NIL THEN
            Break;
        Inc(Position);
    END;
    IF Position > 0 THEN // except when creation of the document
        Dec(Position);
    NewCursor.MoveTo(Position);
    Result := NewCursor;
END;

FUNCTION TXMLCursor.InsertAfter(CONST ElementName, Value: WideString): IXMLCursor;
VAR
    NewCursor: TXMLCursor;
    Element: IXMLDOMElement;
    Node, ParentNode: IXMLDOMNode;
    Position: Integer;
BEGIN
    Result := NIL;
    IF FXMLDOMDocument = NIL THEN
    BEGIN
        Result := AppendChild(ElementName, Value);
        Exit;
    END;
    IF FCurrentNode = NIL THEN
        Exit;
    ParentNode := FCurrentNode.parentNode;
    IF ParentNode = NIL THEN
        Exit;
    Element := FXMLDOMDocument.createElement(ElementName);
    Node := FCurrentNode.nextSibling;
    IF Node = NIL THEN
        ParentNode.appendChild(Element)
    ELSE
        ParentNode.insertBefore(Element, Node);
    IF Value <> '' THEN
        Element.text := Value;
    NewCursor := TXMLCursor.Create;
    NewCursor.FXMLDOMDocument := FXMLDOMDocument;
    NewCursor.FCurrentNodeList := ParentNode.childNodes;
    Node := FCurrentNode;
  // retrieve the absolute position of FCurrentNode in parentNode.childNodes
    Position := 0;
    WHILE True DO
    BEGIN
        Node := Node.previousSibling;
        Inc(Position);
        IF Node = NIL THEN
            Break;
    END;
    NewCursor.MoveTo(Position);
    Result := NewCursor;
END;

PROCEDURE TXMLCursor.Last;
BEGIN
    MoveTo(Count - 1);
END;

PROCEDURE TXMLCursor.Load(CONST FileName: WideString);
BEGIN
    IF FXMLDOMDocument = NIL THEN
        FXMLDOMDocument := CoFreeThreadedDOMDocument.Create;
    IF NOT FXMLDOMDocument.load(FileName) THEN
        ReportDOMParseError(FXMLDOMDocument.parseError);
    IF FXMLDOMDocument.documentElement = NIL THEN
        FCurrentNodeList := NIL
    ELSE
        FCurrentNodeList := FXMLDOMDocument.selectNodes(FXMLDOMDocument.documentElement.nodeName);
    First; // To be sure to be on the document element
END;

PROCEDURE TXMLCursor.LoadXML(CONST SourceXML: WideString);
BEGIN
    IF FXMLDOMDocument = NIL THEN
        FXMLDOMDocument := CoFreeThreadedDOMDocument.Create;
    IF NOT FXMLDOMDocument.loadXML(SourceXML) THEN
        ReportDOMParseError(FXMLDOMDocument.parseError);
    IF FXMLDOMDocument.documentElement = NIL THEN
        FCurrentNodeList := NIL
    ELSE
        FCurrentNodeList := FXMLDOMDocument.selectNodes(FXMLDOMDocument.documentElement.nodeName);
    First;
END;

PROCEDURE TXMLCursor.MoveTo(Index: Integer);
VAR
    VCount: Integer;
BEGIN
    FPosition := -1;
    FEOF := True;
    FCurrentNode := NIL;
    IF FCurrentNodeList = NIL THEN
        Exit;
    VCount := Count;
    IF VCount = 0 THEN
        Exit;
    IF (Index < 0) OR (Index >= VCount) THEN
        RAISE Exception.Create('TXMLCursor.MoveTo - Index out of range: ' + IntToStr(Index) + '/' + IntToStr(VCount));
    IF FCurrentNodeList = NIL THEN
        Exit;
    FPosition := Index;
    FEOF := False;
    FCurrentNode := FCurrentNodeList.item[FPosition];
END;

PROCEDURE TXMLCursor.Next;
BEGIN
    IF (Count - 1 = FPosition) OR (FCurrentNodeList = NIL) THEN
    BEGIN
        FEOF := True;
        Exit;
    END;
    Inc(FPosition);
    FCurrentNode := FCurrentNodeList.item[FPosition];
END;

FUNCTION TXMLCursor.RecNo: Integer;
BEGIN
    Result := FPosition;
END;

PROCEDURE TXMLCursor.ReplaceWithXMLCursor(CONST XMLCursor: IXMLCursor);
VAR
    ClonedNode: IXMLDOMNode;
    Count: Integer;
    I: Integer;
    NodeList: IXMLDOMNodeList;
    ParentNode: IXMLDOMNode;
    XMLCursorInternal: IXMLCursorInternal;
BEGIN
    IF FXMLDOMDocument = NIL THEN
        RAISE Exception.Create('TXMLCursor.ReplaceWithXMLCursor - FXMLDOMDocument = nil');
    IF FCurrentNode = NIL THEN
        Exit;
    ParentNode := FCurrentNode.parentNode;
    IF ParentNode = NIL THEN
        Exit;
    IF XMLCursor = NIL THEN
        Exit;
    IF XMLCursor.QueryInterface(IXMLCursorInternal, XMLCursorInternal) <> S_OK THEN
        Exit;
    IF XMLCursorInternal = NIL THEN
        Exit;
    NodeList := XMLCursorInternal.Get_CurrentNodeList;
    Count := NodeList.length;
    FOR I := 0 TO Count - 1 DO
    BEGIN
        ClonedNode := NodeList.item[I].cloneNode(true);
        ParentNode.insertBefore(ClonedNode, FCurrentNode);
    END;
    FCurrentNodeList := ParentNode.childNodes;
    ParentNode.removeChild(FCurrentNode);
    FCurrentNode := NIL;
    First; // Reset FPosition
END;

PROCEDURE TXMLCursor.Save(CONST FileName: WideString);
VAR
    Path: STRING;
BEGIN
    IF FXMLDOMDocument <> NIL THEN
    BEGIN
        Path := ExtractFilePath(FileName);
        IF Path <> '' THEN
            ForceDirectories(Path);
        FXMLDOMDocument.Save(FileName);
    END;
END;

FUNCTION TXMLCursor.Select(CONST XPath: WideString): IXMLCursor;
VAR
    NodeList: IXMLDOMNodeList;
    XMLCursor: TXMLCursor;
BEGIN
    XMLCursor := TXMLCursor.Create;
    Result := XMLCursor;
    IF FCurrentNode = NIL THEN
    BEGIN
        XMLCursor.First;
        Exit;
    END;
    IF XPath = '*' THEN
    BEGIN
        NodeList := FCurrentNode.childNodes;
    END ELSE BEGIN
        NodeList := FCurrentNode.selectNodes(XPath);
    END;
    XMLCursor.FXMLDOMDocument := FXMLDOMDocument;
    XMLCursor.FCurrentNodeList := NodeList;
    XMLCursor.First;
END;

PROCEDURE TXMLCursor.SetAttributeValue(CONST AttributeName, Value: WideString);
VAR
    Element: IXMLDOMElement;
BEGIN
    IF FCurrentNode = NIL THEN
        Exit;
    Element := FCurrentNode AS IXMLDOMElement;
    Element.setAttribute(AttributeName, Value);
END;

PROCEDURE TXMLCursor.SetValue(CONST ElementName, Value: WideString);
VAR
    AttributeName: STRING;
    Node: IXMLDOMNode;
BEGIN
    IF FCurrentNode = NIL THEN
        Exit;
    IF Pos('@', ElementName) = 1 THEN
    BEGIN
        AttributeName := ElementName;
        System.Delete(AttributeName, 1, 1);
        SetAttributeValue(AttributeName, Value);
        Exit;
    END;
    Node := FCurrentNode.selectSingleNode(ElementName);
    IF Node = NIL THEN
    BEGIN
        Node := FXMLDOMDocument.createElement(ElementName);
        FCurrentNode.appendChild(Node);
    END;
  // ??? Should be a CData Section to handle special characters ???
    Node.text := Value;
END;

PROCEDURE TXMLCursor.Set_Values(CONST Name: WideString; CONST Value: WideString);
BEGIN
    SetValue(Name, Value);
END;

PROCEDURE TXMLCursor.SetCValue(CONST ElementName, Value: WideString);
VAR
    Node: IXMLDOMNode;
    CDATA: IXMLDOMNode;
BEGIN
    IF FCurrentNode = NIL THEN
        Exit;
    Node := FCurrentNode.selectSingleNode(ElementName);
    IF Node = NIL THEN
    BEGIN
        Node := FXMLDOMDocument.createElement(ElementName);
        FCurrentNode.appendChild(Node);
    END;
    CDATA := Node.Get_firstChild;
    IF CDATA = NIL THEN
    BEGIN
   // Should protect CDATA against ]]>
        CDATA := FXMLDOMDocument.createCDATASection(Value);
        Node.appendChild(CDATA);
        Exit;
    END ELSE BEGIN
   // Should protect CDATA against ]]>
        CDATA.text := Value;
    END;
END;

FUNCTION TXMLCursor.XML: WideString;
BEGIN
    Result := '';
    IF FCurrentNode = NIL THEN
        Exit;
    IF (FCurrentNode.parentNode = NIL) OR (FCurrentNode.parentNode.parentNode = NIL) THEN
        Result := FXMLDOMDocument.xml
    ELSE
        Result := FCurrentNode.xml;
END;

FUNCTION TXMLCursor.XMLDOMDocument: IUnknown;
BEGIN
    Result := FXMLDOMDocument;
END;

// !!! Do not use this function for multi-platform applications

FUNCTION TXMLCursor.XMLDOMNode: IUnknown;
BEGIN
    Result := FCurrentNode;
END;

////////////////////////////////////////////////////////////////////////////////
// TXSLProc
////////////////////////////////////////////////////////////////////////////////

CONSTRUCTOR TXSLProc.Create;
BEGIN
    TRY
        INHERITED Create(GetStdXMLTypeLib, IXSLProc);
        FFiles := TStringList.Create;
    EXCEPT
        reraise('TXSLProc.Create');
    END;
END;

DESTRUCTOR TXSLProc.Destroy;
BEGIN
    FFiles.Free;
    FXSLProcessor := NIL;
    FXSLTemplate := NIL;
    INHERITED;
END;

FUNCTION TXSLProc.IsUpToDate: WordBool;
VAR
    CurrentAge, PreviousAge: Integer;
    I: Integer;
BEGIN
    Result := FUpToDate;
    IF Result = False THEN
        Exit;
    TRY
        FOR I := 0 TO FFiles.Count - 1 DO
        BEGIN
            CurrentAge := FileAge(FFiles[I]);
            PreviousAge := Integer(FFiles.Objects[I]);
            Result := CurrentAge = PreviousAge;
            IF Result = False THEN
                Exit;
        END;
    EXCEPT ON E: Exception DO
            RAISE Exception.Create('TXSLProc.IsUpToDate - FileName=' + FFileName + #13#10 + E.Message);
    END;
END;

PROCEDURE TXSLProc.Load(CONST AFileName: WideString);
RESOURCESTRING
    SEmptyXSLDocument = 'XSL document ''%s'' is empty.';

  // adds the list of imported files to watch to FilesToWatch
    PROCEDURE ProcessImports(Source: IXMLDOMDocument);
    VAR
        ChildCount: Integer;
        ChildNode: IXMLDOMNode;
        ChildNodes: IXMLDOMNodeList;
        CurrentAge: Integer;
        HrefNode: IXMLDOMNode;
        I: Integer;
        ImportedDocument: IXMLDOMDocument;
        ImportFileName: STRING;
    BEGIN
        TRY
            ChildNodes := Source.documentElement.childNodes;
            ChildCount := ChildNodes.length;

            FOR I := 0 TO ChildCount - 1 DO
            BEGIN
                ChildNode := ChildNodes.item[I];
                IF (ChildNode.nodeName <> 'xsl:import') AND
                    (ChildNode.nodeName <> 'xsl:include') THEN
                    Continue;

                HrefNode := ChildNode.attributes.getNamedItem('href');
                IF HrefNode = NIL THEN
                    RAISE Exception.Create('href attribute missing on xsl:import/xsl:include');
                ImportFileName := HrefNode.text;
                IF ImportFileName = '' THEN
                    RAISE Exception.Create('href attribute empty on xsl:import / xsl:include');
                IF ImportFileName[1] <> '/' THEN
                    ImportFileName := ExtractFilePath(AFileName) + ImportFileName;
                ImportFileName := UnixPathToDosPath(ImportFileName);
                ImportedDocument := CoFreeThreadedDOMDocument.Create;
                ImportedDocument.Load(ImportFileName);
                IF ImportedDocument.documentElement = NIL THEN
                    RAISE Exception.CreateFmt(SEmptyXSLDocument, [ImportFileName]);
                CurrentAge := FileAge(ImportFileName);
                FFiles.AddObject(ImportFileName, pointer(CurrentAge));
                ProcessImports(ImportedDocument);
            END;
        EXCEPT ON E: Exception DO
                RAISE Exception.Create('TXSLProc.Load.ProcessImports - XSL processing - ' + ImportFileName + #13#10 + E.Message);
        END;
    END;

VAR
    CurrentAge: Integer;
    XSLDocument: IXMLDOMDocument;
BEGIN
    TRY
        FFileName := AFileName;
        XSLDocument := CoFreeThreadedDOMDocument.Create;
        XSLDocument.load(AFileName);
        IF XSLDocument.documentElement = NIL THEN
            RAISE Exception.CreateFmt(SEmptyXSLDocument, [AFileName]);
    // imports/includes xmldom_msxml
        CurrentAge := FileAge(AFileName);
        FFiles.AddObject(AFileName, Pointer(CurrentAge));
        ProcessImports(XSLDocument);
        FXSLTemplate := CoXSLTemplate.Create;
        FXSLTemplate.stylesheet := XSLDocument;
        FUpToDate := True;
    EXCEPT ON E: Exception DO
            RAISE Exception.Create('TXSLProc.Load - ' + FFileName + #13#10 + E.Message);
    END;
END;

FUNCTION TXSLProc.Process(CONST Document: IXMLCursor): WideString;
VAR
    SResult: WideString;

    PROCEDURE PurgeResult;
    CONST
        SUTF16 = '<META http-equiv="Content-Type" content="text/html; charset=UTF-16">';
    VAR
        Index: Integer;
    BEGIN
        Index := Pos(SUTF16, SResult);
        IF Index = 0 THEN
            Exit;
        Delete(SResult, Index, Length(SUTF16));
    END;

BEGIN
    TRY
        IF FXSLProcessor = NIL THEN
            FXSLProcessor := FXSLTemplate.createProcessor;
        FXSLProcessor.input := IXMLDOMdocument(Document.XMLDOMDocument);
        FXSLProcessor.transform;
        SResult := FXSLProcessor.output;
        PurgeResult;
        Result := SResult;
    EXCEPT
        ON E: Exception DO
        BEGIN
            FUpToDate := False;
            RAISE Exception.Create('TXSLProc.Process - XSL processing - ' + FFileName + #13#10 + E.Message);
        END;
    END;
END;

FUNCTION TXMLCursor.Get_CurrentNode: IXMLDOMNode;
BEGIN
    result := FCurrentNode;
END;

END.

