// Translation of the C headers for Oracle's XML parser
// e-delos

unit OraXML;

interface

{$IFNDEF MSWINDOWS}
	{$IFDEF WIN32}
		{$DEFINE MSWINDOWS}
  {$ENDIF}
{$ENDIF}

uses
{$IFDEF MSWINDOWS}
  Windows;
{$ENDIF}
{$IFDEF LINUX}
	Libc;
{$ENDIF}

// Flag bits for xmlparse() and xmlparsebuf()
const
  XML_FLAG_VALIDATE = $1;
  XML_FLAG_DISCARD_WHITESPACE = $2;
  XML_FLAG_DTD_ONLY = $4;


const
  // Node types
  INVALID_NODE                   = 0;
  ELEMENT_NODE                   = 1;
  ATTRIBUTE_NODE                 = 2;
  TEXT_NODE                      = 3;
  CDATA_SECTION_NODE             = 4;
  ENTITY_REFERENCE_NODE          = 5;
  ENTITY_NODE                    = 6;
  PROCESSING_INSTRUCTION_NODE    = 7;
  COMMENT_NODE                   = 8;
  DOCUMENT_NODE                  = 9;
  DOCUMENT_TYPE_NODE             = 10;
  DOCUMENT_FRAGMENT_NODE         = 11;
  NOTATION_NODE                  = 12;

type
  Txmlctx = Pointer;
  Pxmlctx = ^Txmlctx;
  Txmldtd = Pointer;
  Pxmldtd = ^Txmldtd;
  Txmlnode = Pointer;
  Pxmlnode = ^Txmlnode;
  PPxmlnode = ^Pxmlnode;
  Txmlnodes = Pointer;
  Pxmlnodes = ^Txmlnodes;

  xmlntype = Integer;

  uword = Cardinal;
  Puword = ^uword;

type
  TMessageHandler = procedure (msgctx: Pointer; msg: PChar; errcode: uword);

  Txmlinit = function (err: Puword; encoding: PChar; msghdlr: TMessageHandler; msgctx: Pointer;
    saxcb: Pointer; saxcbctx: Pointer; memcb: Pointer; memcbctx: Pointer; lang: PChar): Pxmlctx; cdecl;
  Txmlparse = function (ctx: Pxmlctx; filename: PChar; encoding: PChar; flags: Integer): uword; cdecl;
  Txmlparsebuf = function (ctx: Pxmlctx; buffer: PChar; len: Integer; encoding: PChar; flags: Integer): uword; cdecl;
  Txmlterm = function (ctx: Pxmlctx): uword; cdecl;
  Txslprocess = function (docctx, xslctx, resctx: Pxmlctx; result: PPxmlnode): uword; cdecl;
  Txmlclean = procedure (ctx: Pxmlctx); cdecl;

  TcreateAttribute = function (ctx: Pxmlctx; name, value: PChar): Pxmlnode; cdecl;
  TcreateCDATASection = function (ctx: Pxmlctx; data: PChar): Pxmlnode; cdecl;
  TcreateComment = function (ctx: Pxmlctx; data: PChar): Pxmlnode; cdecl;
  TcreateDocument = function (ctx: Pxmlctx): Pxmlnode; cdecl;
  TcreateDocumentFragment = function (ctx: Pxmlctx): Pxmlnode; cdecl;
  TcreateElement = function (ctx: Pxmlctx; elname: PChar): Pxmlnode; cdecl;
  TcreateEntityReference = function (ctx: Pxmlctx; name: PChar): Pxmlnode; cdecl;
  TcreateTextNode = function (ctx: Pxmlctx; data: PChar): Pxmlnode; cdecl;
  TcreateProcessingInstruction = function (ctx: Pxmlctx; target, data: PChar): Pxmlnode; cdecl;

  TappendChild = function (ctx: Pxmlctx; parent, newnode: Pxmlnode): Pxmlnode; cdecl;
  TcloneNode = function (ctx: Pxmlctx; node: Pxmlnode; deep: Boolean): Pxmlnode; cdecl;
  TgetAttributes = function (node: Pxmlnode): Pxmlnodes; cdecl;
  TgetAttributeIndex = function (attrs: Pxmlnodes; index: Integer): Pxmlnode; cdecl;
  TgetAttrName = function (attr: Pxmlnode): PChar; cdecl;
  TgetDocType = function (Context: Pxmlctx): Pxmldtd; cdecl;
  TgetChildNode = function (nodes: Pxmlnodes; index: Integer): Pxmlnode; cdecl;
  TgetChildNodes = function (node: Pxmlnode): Pxmlnodes; cdecl;
  TgetDocument = function (ctx: Pxmlctx): Pxmlnode; cdecl;
  TgetDocumentElement = function (ctx: Pxmlctx): Pxmlnode; cdecl;
  TgetElementsByTagName = function (ctx: Pxmlctx; node: Pxmlnode; name: PChar): Pxmlnodes; cdecl;
  TgetFirstChild = function (node: Pxmlnode): Pxmlnode; cdecl;
  TgetLastChild = function (node: Pxmlnode): Pxmlnode; cdecl;
  TgetNamedItem = function (nodes: Pxmlnodes; name: PChar; index: PInteger): Pxmlnode; cdecl;
  TgetNextSibling = function (node: Pxmlnode): Pxmlnode; cdecl;
  TgetNodeMapLength = function (nodes: Pxmlnodes): Integer; cdecl;
  TgetNodeName = function (node: Pxmlnode): PChar; cdecl;
  TgetNodeType = function (node: Pxmlnode): xmlntype; cdecl;
  TgetNodeValue = function (node: Pxmlnode): PChar; cdecl;
  TgetOwnerDocument = function (node: Pxmlnode): Pxmlnode; cdecl;
  TgetParentNode = function (node: Pxmlnode): Pxmlnode; cdecl;
  TgetPreviousSibling = function (node: Pxmlnode): Pxmlnode; cdecl;
  ThasChildNodes = function (node: Pxmlnode): Boolean; cdecl;
  TinsertBefore = function (ctx: Pxmlctx; parent, newChild, refChild: Pxmlnode): Pxmlnode; cdecl;
  TnumAttributes = function (attrs: Pxmlnodes): Integer; cdecl;
  TnumChildNodes = function (nodes: Pxmlnodes): Integer; cdecl;
  TremoveChild = function (node: Pxmlnode): Pxmlnode; cdecl;
  TremoveNamedItem = function (nodes: Pxmlnodes; name: PChar): Pxmlnode; cdecl;
  TreplaceChild = function (ctx: Pxmlctx; newnode, oldnode: Pxmlnode): Pxmlnode; cdecl;
  TsetNamedItem = function (ctx: Pxmlctx; nodes: Pxmlnodes; node: Pxmlnode; old: PPxmlnode): Boolean; cdecl;
  TsetNodeValue = procedure (node: Pxmlnode; data: PChar); cdecl;

  TgetAttribute = function (node: Pxmlnode; name: PChar): PChar; cdecl;
  TsetAttribute = function (ctx: Pxmlctx; elem: Pxmlnode; name, value: PChar): Pxmlnode; cdecl;

  Tprintres = procedure (ctx: Pxmlctx; result: Pxmlnode);

var
  xmlinit: Txmlinit;
  xmlparse: Txmlparse;
  xmlparsebuf: Txmlparsebuf;
  xmlterm: Txmlterm;
  xslprocess: Txslprocess;
  xmlclean: Txmlclean;

  createCDATASection: TcreateCDATASection;
  createComment: TcreateComment;
  createDocument: TcreateDocument;
  createDocumentFragment: TcreateDocumentFragment;
  createElement: TcreateElement;
  createEntityReference: TcreateEntityReference;
  createTextNode: TcreateTextNode;
  createProcessingInstruction: TcreateProcessingInstruction;

  appendChild: TappendChild;
  cloneNode: TcloneNode;
  getAttributes: TgetAttributes;
  getAttributeIndex: TgetAttributeIndex;
  getAttrName: TgetAttrName;
  getDocType: TgetDocType;
  getChildNode: TgetChildNode;
  getChildNodes: TgetChildNodes;
  getDocument: TgetDocument;
  getDocumentElement: TgetDocumentElement;
  getElementsByTagName: TgetElementsByTagName;
  getFirstChild: TgetFirstChild;
  getLastChild: TgetLastChild;
  getNamedItem: TgetNamedItem;
  getNextSibling: TgetNextSibling;
  getNodeMapLength: TgetNodeMapLength;
  getNodeName: TgetNodeName;
  getNodeType: TgetNodeType;
  getNodeValue: TgetNodeValue;
  getOwnerDocument: TgetOwnerDocument;
  getParentNode: TgetParentNode;
  getPreviousSibling: TgetPreviousSibling;
  hasChildNodes: ThasChildNodes;
  insertBefore: TinsertBefore;
  numAttributes: TnumAttributes;
  numChildNodes: TnumChildNodes;

  removeChild: TremoveChild;
  removeNamedItem: TremoveNamedItem;
  replaceChild: TreplaceChild;
  setNamedItem: TsetNamedItem;
  setNodeValue: TsetNodeValue;

  getAttribute: TgetAttribute;
  setAttribute: TsetAttribute;

  printres: Tprintres;

procedure Initialize;
procedure XMLCheck(Err: uword; const Msg: string);
function FormatXML(node: Pxmlnode; Indent: Boolean): string;
function FormatXMLNode(node: Pxmlnode; level: Integer; Indent: Boolean; var InnerElements: Boolean): string;


implementation


uses
  SysUtils, XMLUtils, Classes;

procedure XMLCheck(Err: uword; const Msg: string);
begin
  if Err <> 0 then
    raise Exception.CreateFmt('XML Error: %s (Error Code: %d)', [Msg, Err]);
end;

function FormatXML(node: Pxmlnode; Indent: Boolean): string;
var
  InnerElements: Boolean;
begin
  Result := FormatXMLNode(node, 0, Indent, InnerElements);
end;

function FormatXMLNode(node: Pxmlnode; level: Integer; Indent: Boolean; var InnerElements: Boolean): string;

  function FormatXMLChildren(node: Pxmlnode; level: Integer; Indent: Boolean; var InnerElements: Boolean): string;
  var
    ChildNode: Pxmlnode;
    I: Integer;
    NodeCount: Integer;
    Nodes: Pxmlnodes;
  begin
    if (node = nil) or (not hasChildNodes(node)) then
    begin
      Result := '';
      Exit;
    end;

    Nodes := getChildNodes(node);
    NodeCount := numChildNodes(Nodes);
    for I := 0 to NodeCount-1 do
    begin
      ChildNode := getChildNode(nodes, I);
      Result := Result + FormatXMLNode(ChildNode, level, Indent, InnerElements);
    end;
  end;

  function GetAttrText: string;
	var
  	AttributeCount: Integer;
  	AttributeNodes: Pxmlnodes;
    AttributeNode: Pxmlnode;
    AttributeName: string;
    AttributeValue: string;
    I: Integer;
  begin
  	Result := '';
    AttributeNodes := getAttributes(node);
    AttributeCount := numAttributes(AttributeNodes);
    for I := 0 to AttributeCount-1 do
    begin
      AttributeNode := getAttributeIndex(AttributeNodes, I);
    	AttributeName := getAttrName(AttributeNode);
      AttributeValue := getAttribute(node, PChar(AttributeName));
      Result := Result + ' '+AttributeName+'="'+AttributeValue+'"';
    end;
  end;

var
	Attributes: string;
  Indentation, NewLine: string;
  NodeName: string;
  NodeType: Integer;
begin
  InnerElements := False;
  if node = nil then
  begin
    Result := '';
    Exit;
  end;

  if Indent then
  begin
    Indentation := StringOfChar(#9, level);
    NewLine := #13#10;
  end
  else
  begin
    Indentation := '';
    NewLine := '';
  end;

  NodeType := getNodeType(node);
  case NodeType of
    ELEMENT_NODE:
      begin
        NodeName := getNodeName(node);
        Result := FormatXMLChildren(node, level+1, Indent, InnerElements);
				Attributes := GetAttrText;
        
        if InnerElements then
          Result := Indentation+'<'+NodeName+Attributes+'>'+NewLine+Result+Indentation+'</'+NodeName+'>'+NewLine
        else if Result = '' then
          Result := Indentation+'<'+NodeName+Attributes+'/>'+NewLine
        else
          Result := Indentation+'<'+NodeName+Attributes+'>'+Result+'</'+NodeName+'>'+NewLine;
        InnerElements := True;
      end;
    DOCUMENT_NODE, DOCUMENT_FRAGMENT_NODE:
        Result := FormatXMLChildren(node, level, Indent, InnerElements);
    ATTRIBUTE_NODE:
      begin
        NodeName := getNodeName(node);
        Result := getAttribute(node, PChar(NodeName));
        Result := ' '+NodeName+'="'+Result+'"';
      end;
    TEXT_NODE:
      begin
        Result := getNodeValue(node);
      end;
    PROCESSING_INSTRUCTION_NODE:
      begin
        NodeName := getNodeName(node);
        Result := Indentation+'<?'+NodeName+'?>'+NewLine;
      end;
    else
        Result := getNodeValue(node);
  end;
end;


var
  Handle: HMODULE;

procedure Initialize;
const
{$IFDEF MSWINDOWS}
	SLibOraXML = 'oraxml8.dll';
{$ENDIF}
{$IFDEF LINUX}
	SLibOraXML = 'liboraxml.so';
{$ENDIF}
begin
  Handle := LoadLibrary(SLibOraXML);
  if Handle = 0 then
  begin
{$IFDEF MSWINDOWS}
		raise Exception.Create('Cannot LoadLibrary '+SLibOraXML+' - ErrorCode=' + IntToStr(GetLastError));
{$ENDIF}
{$IFDEF LINUX}
    raise Exception.Create('LoadLibrary - ' + dlerror());
{$ENDIF}
  end;
  xmlinit := GetProcAddress(Handle, 'xmlinit');
  xmlparse := GetProcAddress(Handle, 'xmlparse');
  xmlparsebuf := GetProcAddress(Handle, 'xmlparsebuf');
  xmlterm := GetProcAddress(Handle, 'xmlterm');
  xslprocess := GetProcAddress(Handle, 'xslprocess');
  xmlclean := GetProcAddress(Handle, 'xmlclean');

  createCDATASection := GetProcAddress(Handle, 'createCDATASection');
  createComment := GetProcAddress(Handle, 'createComment');
  createDocument := GetProcAddress(Handle, 'createDocument');
  createDocumentFragment := GetProcAddress(Handle, 'createDocumentFragment');
  createElement := GetProcAddress(Handle, 'createElement');
  createEntityReference := GetProcAddress(Handle, 'createEntityReference');
  createTextNode := GetProcAddress(Handle, 'createTextNode');
  createProcessingInstruction := GetProcAddress(Handle, 'createProcessingInstruction');

  appendChild := GetProcAddress(Handle, 'appendChild');
  cloneNode := GetProcAddress(Handle, 'cloneNode');
  getAttributes := GetProcAddress(Handle, 'getAttributes');
  getAttributeIndex := GetProcAddress(Handle, 'getAttributeIndex');
  getAttrName := GetProcAddress(Handle, 'getAttrName');

  getDocType := GetProcAddress(Handle, 'getDocType');
  getChildNode := GetProcAddress(Handle, 'getChildNode');
  getChildNodes := GetProcAddress(Handle, 'getChildNodes');
  getDocument := GetProcAddress(Handle, 'getDocument');
  getDocumentElement := GetProcAddress(Handle, 'getDocumentElement');
  getElementsByTagName := GetProcAddress(Handle, 'getElementsByTagName');
  getFirstChild := GetProcAddress(Handle, 'getFirstChild');
  getLastChild := GetProcAddress(Handle, 'getLastChild');
  getNamedItem := GetProcAddress(Handle, 'getNamedItem');
  getNextSibling := GetProcAddress(Handle, 'getNextSibling');
  getNodeMapLength := GetProcAddress(Handle, 'getNodeMapLength');
  getNodeName := GetProcAddress(Handle, 'getNodeName');
  getNodeType := GetProcAddress(Handle, 'getNodeType');
  getNodeValue := GetProcAddress(Handle, 'getNodeValue');
  getOwnerDocument := GetProcAddress(Handle, 'getOwnerDocument');
  getParentNode := GetProcAddress(Handle, 'getParentNode');
  getPreviousSibling := GetProcAddress(Handle, 'getPreviousSibling');
  hasChildNodes := GetProcAddress(Handle, 'hasChildNodes');
  insertBefore := GetProcAddress(Handle, 'insertBefore');
  numAttributes := GetProcAddress(Handle, 'numAttributes');
  numChildNodes := GetProcAddress(Handle, 'numChildNodes');
  removeChild := GetProcAddress(Handle, 'removeChild');
  removeNamedItem := GetProcAddress(Handle, 'removeNamedItem');
  replaceChild := GetProcAddress(Handle, 'replaceChild');
  setNamedItem := GetProcAddress(Handle, 'setNamedItem');
  setNodeValue := GetProcAddress(Handle, 'setNodeValue');

  getAttribute := GetProcAddress(Handle, 'getAttribute');
  setAttribute := GetProcAddress(Handle, 'setAttribute');
end;

procedure Finalize;
begin
  FreeLibrary(Handle);
end;

initialization
  Initialize;

finalization
  Finalize;

end.


