unit uwsGetEasy2play;

interface

uses
  XMLIntf, DB, DateUtils;

const CKDOModeDeconnecte = 'Mode déconnecté';

type

  TEmetteurModeEnc = packed record
    CodeEmetteur : string;   // 36145, etc...
    NomEmetteur  : string;   // CADHOC etc...
    MEN_ID       : Integer;  // Mode d'encaissement Ginkoia
  end;
  TEmetteurModeEncArray = array of TEmetteurModeEnc;

  TwsStatut = packed record
    Error     : Boolean;
    NumError  : Integer;
    sMessage  : string;
    status    : Integer;
  public procedure Init;
  end;
  
  TwsAnnulTitre = packed record
    Error     : Boolean;
    NumError  : Integer;
    sMessage  : string;
    // ------------------
    CodeErreur : integer;
  public procedure Init;
  end;

  TwsTitreDetail = packed record
    Error     : Boolean;
    NumError  : Integer;
    sMessage  : string;
    // ------------------
    CodeErreur : integer;
	  titre      : string;
    emetteur   : string;
    montant    : double;
    dateValid  : string;
    numTitre   : string;
    ID         : string;
  public procedure Init;
  end;

  TCSHCHEQUEKDORec = record
	  ID       : Integer;
    CB       : string;
    DATE     : TDateTime;
    SESID    : integer;
    TKEID    : integer;
    ENCID    : integer;
    EMETTEUR : string;
    TITRE    : string;
    MONTANT  : double;
    SAISIE   : double;
   	procedure SetFields(AdataSet:TDataSet);
  end;
  TCSHCHEQUEKDOArray = array of TCSHCHEQUEKDORec;

  TCSHCHEQUETRTRec = record
	  ID       : Integer;
    CKDID    : Integer;
    DATE     : TDateTime;
    _TYPE    : Integer;
    ANNUL    : string;
    APPELWS  : integer;
    OKTRANS  : integer;
    RETTRANS : integer;
    NUMTRANS : string;
    MOTIF    : string;
    TRAITE   : integer;
   	procedure SetFields(AdataSet:TDataSet);
  end;
  TCSHCHEQUETRTArray = array of TCSHCHEQUETRTRec;


  TwsGetEasy2Play = class(TObject)
  private
    class var FURL        : string;     // URL de base  
    class var FGUID       : string;     // GUID
    class var FDATETICKET : TDateTime;  // YYYYMMDDHHMMSS
    class var FCABTITRE   : string;     // CodeBarre
    class var FNUMTICKET  : string;     // N° du Ticket nous c'est TKE_ID  
    class var FMagCaisse  : string;     // CodeMAG|Poste 
    class var FID         : string;     // ID reponse ou ID a passer dans l'URL pour l'annulation

  protected
    class function SeekForError(XmlDoc : IXMLDocument; out ErrorCode : integer) : boolean;
    class function ParseStatus(XmlDoc : IXMLDocument):TwsStatut;
    class function ParseTitreDetail(XmlDoc : IXMLDocument):TWsTitreDetail;
    class function ParseAnnulTitre(XmlDoc : IXMLDocument):TwsAnnulTitre;
  public
    class function GetStatusWS()    : TwsStatut;
    class function getTitreDetail() : TWsTitreDetail;
    class function setAnnulTitre()  : TwsAnnulTitre;
    class function setTitreForce()  : TWsTitreDetail;
    {-----------------------------------
    class function setTitreForce()  : IXMLDocument;
    ------------------------------------}

    class property URL        : string    read FURL        write FURL;
    class property GUID       : string    read FGUID       write FGUID;
    class property DATETICKET : TDateTime read FDATETICKET write FDATETICKET;
    class property CABTITRE   : string    read FCABTITRE   write FCABTITRE;
    class property NUMTICKET  : string    read FNUMTICKET  write FNUMTICKET;
    class property MAGCAISSE  : string    read FMAGCAISSE  write FMAGCAISSE;
    class property ID         : string    read FID         write FID;

  end;
  function CopyCHEQUEKDOArray(aOrigine:TCSHCHEQUEKDOArray):TCSHCHEQUEKDOArray;
  function GetErrorLib(aErrorCode:integer;aMessage:string):string;


implementation

uses
  Classes,
  SysUtils,
  IdURI,
  IdHTTP,
  IdSSLOpenSSL,
  XMLDoc,
  Dialogs,
  Variants,
  Iso8601Unit;

function GetErrorLib(aErrorCode:integer;aMessage:string):string;
begin
    result:=aMessage;
    Case aErrorCode of
      -5 : result:='Connexion Refusée : la connexion à la base a été refusée soit parce que le GUID est inconnu, soit car la base est temporairement indisponible';
     -10 : result:='Titre périmé : Le tritre scanné a été correctement identifié, masi celui-ci est périmé. Il ne peut pas être enregsitrée par le commerçant';
     -20 : result:='Titre déjà scanné dans une autre transaction : Ce titre est correctement identifié, cependant celui-ci a déjà été scanné.';
     -21 : result:='Titre falsifié. Ce titre a été correctement décodé, mais il fait partie des titres "blacklisté" chez l''émetteur.';
     -30 : result:='Titre Refusé par l''enseigne. Le code barre du titre a permis d''identifier le titre, cependant ce titre n''est pas accepté par l''enseigne.';
     -31 : result:='Emetteur refusé par l''enseigne.';
     -40 : result:='Montant incorrect. L''analyse du code barre a retourné un montant incorrect pour le type de titre.';
     -50 : result:='Magasin inconnu de l''enseigne';
     -90 : result:='Format de codebarre incorrect';
    end;
end;

function CopyCHEQUEKDOArray(aOrigine:TCSHCHEQUEKDOArray):TCSHCHEQUEKDOArray;
var i:Integer;
begin
     i:=Length(aOrigine);
     SetLength(Result,i);
     for I := 0 to Length(aOrigine) - 1 do
       begin
            Result[i]:=aOrigine[i];
       end;
end;



procedure TwsStatut.Init;
begin
    Error        := true;
    NumError     := -1;
    sMessage     := '';
    status       := 0;
end;


procedure TwsAnnulTitre.Init;
begin
    Error        := true;
    NumError     := -1;
    sMessage     := '';
    CodeErreur   := 0;       // 0 = erreur // 1=pas d'erreur

end;


procedure TwsTitreDetail.Init;
begin
    Error        := true;
    NumError     := -1;
    sMessage     := '';
    CodeErreur   := 0;       // 0 = erreur // 1=pas d'erreur

	  Titre        := '';
    EMETTEUR     := '';
    MONTANT      := 0;
    DATEVALID    := '';
    NumTitre     := '';
    ID           := '';
end;


procedure TCSHCHEQUEKDORec.SetFields(AdataSet:TDataSet);
begin
	  ID       := ADataSet.FieldByName('CKD_ID').AsInteger;
    CB       := ADataSet.FieldByName('CKD_CB').Asstring;
    DATE     := ADataSet.FieldByName('CKD_DATE').AsDateTime;
    SESID    := ADataSet.FieldByName('CKD_SESID').AsInteger;
    TKEID    := ADataSet.FieldByName('CKD_TKEID').AsInteger;
    ENCID    := ADataSet.FieldByName('CKD_ENCID').AsInteger;
    EMETTEUR := ADataSet.FieldByName('CKD_EMETTEUR').AsString;
    TITRE    := ADataSet.FieldByName('CKD_TITRE').Asstring;
    MONTANT  := ADataSet.FieldByName('CKD_MONTANT').AsFloat;
    SAISIE   := ADataSet.FieldByName('CKD_SAISIE').AsFloat;
end;


{
function FindNode(RootNode : IXmlNode; NodeName : string; CaseSensitive : boolean = false; From : integer = 0) : IXmlNode;
var
  i : integer;
begin
  Result := nil;

  if not Assigned(RootNode) then
    Exit;

  if CaseSensitive then
  begin
    for i := From to RootNode.ChildNodes.Count -1 do
    begin
      if RootNode.ChildNodes[i].NodeName = NodeName then
      begin
        Result := RootNode.ChildNodes[i];
        Break;
      end;
    end;
  end
  else
  begin
    NodeName := UpperCase(NodeName);
    for i := From to RootNode.ChildNodes.Count -1 do
    begin
      Showmessage(RootNode.ChildNodes[i].Text);
      if UpperCase(RootNode.ChildNodes[i].NodeName) = NodeName then
      begin
        Result := RootNode.ChildNodes[i];
        Break;
      end;
    end;
  end;
end;
}

{ TwsGetEasy2Play }
class function TwsGetEasy2Play.ParseStatus(XmlDoc : IXMLDocument):TWsStatut;
var
  RootNode, currentNode : IXMLNode;
begin
  Result.Init;
  if not Assigned(XmlDoc) then
  begin
    exit;
  end
  else
  begin
    //    FLastReponse := XmlDoc;

    RootNode := XmlDoc.DocumentElement;

    currentNode := RootNode.ChildNodes.FindNode('error');
    if Assigned(currentNode) then
    begin
       Result.Error    := true;
       Result.NumError := StrToIntDef(currentNode.NodeValue, -5);
    end;


    currentNode := RootNode.ChildNodes.FindNode('message');
    if Assigned(currentNode) then
    begin
       Result.sMessage := currentNode.NodeValue;
    end;

    currentNode := RootNode.ChildNodes.FindNode('status');
    if Assigned(currentNode) then
    begin
       Result.status := StrToIntDef(currentNode.NodeValue, 0);
    end;
  end;
end;


class function TwsGetEasy2Play.ParseAnnulTitre(XmlDoc : IXMLDocument):TwsAnnulTitre;
var
  RootNode, currentNode : IXMLNode;
begin
  Result.Init;
  if not Assigned(XmlDoc) then
  begin
    exit;
  end
  else
  begin
    // reponse dans ce style
    // <xml>
    // <codeErreur>1</codeErreur>
    // </xml>

    RootNode := XmlDoc.DocumentElement;

    currentNode := RootNode.ChildNodes.FindNode('error');
    if Assigned(currentNode) then
    begin
       Result.Error    := true;
       Result.NumError := StrToIntDef(currentNode.NodeValue,0);
    end;

    currentNode := RootNode.ChildNodes.FindNode('message');
    if Assigned(currentNode) then
    begin
       Result.sMessage := currentNode.NodeValue;
    end;


    currentNode := RootNode.ChildNodes.FindNode('codeErreur');
    if Assigned(currentNode) then
    begin
       Result.CodeErreur := StrToIntDef(currentNode.NodeValue,0);
    end;

    // Si finalement le CodeErreur=1 alors c'est pas une erreur
    Result.Error := not(Result.CodeErreur=1);
  end;
end;



class function TwsGetEasy2Play.ParseTitreDetail(XmlDoc : IXMLDocument):TwsTitreDetail;
var
  RootNode, currentNode : IXMLNode;

  tmp: string;
begin
  Result.Init;
  if not Assigned(XmlDoc) then
  begin
    exit;
  end
  else
  begin
    // FLastReponse := XmlDoc;
    // reponse dans ce style
    // <xml>
    // <codeErreur>1</codeErreur>
    // <titre>KADEOS HORISON</titre>
    // <emetteur>361442</emetteur>
    // <montant>1</montant>
    // <dateValid>31/05/2017</dateValid>
    // <numTitre>0049208621</numTitre>
    // <ID>57f655dd48d02</ID>
    // </xml>

    RootNode := XmlDoc.DocumentElement;

    currentNode := RootNode.ChildNodes.FindNode('error');
    if Assigned(currentNode) then
    begin
       Result.Error    := true;
       Result.NumError := StrToIntDef(currentNode.NodeValue,0);
    end;

    currentNode := RootNode.ChildNodes.FindNode('message');
    if Assigned(currentNode) then
    begin
       Result.sMessage := currentNode.NodeValue;
    end;


    currentNode := RootNode.ChildNodes.FindNode('codeErreur');
    if Assigned(currentNode) then
    begin
       Result.CodeErreur := StrToIntDef(currentNode.NodeValue,0);
    end;

    // Si finalement le CodeErreur=1 alors c'est pas une erreur
    Result.Error := not(Result.CodeErreur=1);


    currentNode := RootNode.ChildNodes.FindNode('titre');
    if Assigned(currentNode) then
    begin
       Result.Titre := currentNode.NodeValue;
    end;

    currentNode := RootNode.ChildNodes.FindNode('emetteur');
    if Assigned(currentNode) then
    begin
       Result.Emetteur := currentNode.NodeValue;
    end;

    currentNode := RootNode.ChildNodes.FindNode('montant');
    if Assigned(currentNode) then
    begin
//      tmp := currentNode.NodeValue;
//      tmp := tmp.Replace('.', ',');
//      Result.Montant := StrToFloat(tmp);
      Result.Montant := currentNode.NodeValue;
    end;

    currentNode := RootNode.ChildNodes.FindNode('dateValid');
    if Assigned(currentNode) then
    begin
       Result.dateValid := currentNode.NodeValue;
    end;

    currentNode := RootNode.ChildNodes.FindNode('numTitre');
    if Assigned(currentNode) then
    begin
       Result.numTitre := currentNode.NodeValue;
    end;

    currentNode := RootNode.ChildNodes.FindNode('ID');
    if Assigned(currentNode) then
    begin
       Result.ID := currentNode.NodeValue;
    end;



    {
    currentNode := RootNode.ChildNodes.FindNode('emetteur');
    if Assigned(currentNode) then
    begin
       Result.Emetteur := currentNode.NodeValue;
    end;
    FreeAndNil(currentNode);
    }    
  end;
end;



class function TwsGetEasy2Play.SeekForError(XmlDoc : IXMLDocument; out ErrorCode : integer) : boolean;
var
  RootNode, ErrorNode, DescNode : IXMLNode;
begin
  Result := true;
  ErrorCode := 0;

  if not Assigned(XmlDoc) then
  begin
    Result := true;
    ErrorCode := -1;
  end
  else
  begin
    RootNode := XmlDoc.DocumentElement;
    ErrorNode := RootNode.ChildNodes.FindNode('error');
    if Assigned(ErrorNode) then
    begin
       Result    := True;
       ErrorCode := StrToIntDef(ErrorNode.NodeValue, -5);
    end
    else
      begin
        Result := false;
      end;
  end;
end;

class function TwsGetEasy2Play.setAnnulTitre()  : TwsAnnulTitre;
var IdHttp : TIdHttp;
    IdIOHandler : TIdSSLIOHandlerSocketOpenSSL;
    ResStream : TMemoryStream;
    vError:Integer;
    vDocXML : TXMLDocument;
    vScriptParams : string;
begin
  Result.Init;
  if Trim(FURL) = '' then
    Exit;

  try
    IdHttp := TIdHttp.Create(nil);
    try
      IdIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      try
        if UpperCase(Copy(URL, 1, 5)) = 'HTTPS' then
        begin
          IdIoHandler.Destination := URL;
          IdIoHandler.SSLOptions.Method := sslvSSLv23;
          IdHTTP.IOHandler := IdIoHandler;
        end;

        ResStream := TMemoryStream.Create();
        try
          FDATETICKET := Now();
          vScriptParams :=
            Format('setannultitre?guid=%s&dateticket=%s&id=%s&magcaisse=%s',[
              FGUID,FormatDateTime('yyyymmddhhnnss',FDATETICKET),FID,FMagCaisse
            ]);

//          AddLogs(FURL + vScriptParams);
          IdHTTP.Get(FURL + vScriptParams , ResStream);

          vDocXML := TXmlDocument.Create(nil);
          ResStream.Seek(0, soFromBeginning);
          try
            vDocXML.LoadFromStream(ResStream);
            result := ParseAnnulTitre(vDocXML);

            If result.Error
              then
                begin
//                    infmess(GetErrorLib(result.NumError,result.sMEssage), '');
                end;
          finally
            // vDocXML.Free;
           end;
        finally
          FreeAndNil(ResStream);
        end;
      finally
          FreeAndNil(IdIOHandler);
      end;
    finally
      FreeAndNil(IdHttp);
    end;
  except
    on e : Exception do
    begin
      Result.Error    := true;
      Result.NumError := -99;
      Result.sMessage := e.ToString;
    end;
  end;
end;



class function TwsGetEasy2Play.setTitreForce: TWsTitreDetail;
var IdHttp : TIdHttp;
    IdIOHandler : TIdSSLIOHandlerSocketOpenSSL;
    ResStream : TMemoryStream;
    vError:Integer;
    vDocXML : TXMLDocument;
    vScriptParams : string;
    vURL : string;
begin
  Result.Init;
  if Trim(FURL) = '' then
    Exit;

  try
    IdHttp := TIdHttp.Create(nil);
    try
      IdIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      try
        if UpperCase(Copy(URL, 1, 5)) = 'HTTPS' then
        begin
          IdIoHandler.Destination := URL;
          IdIoHandler.SSLOptions.Method := sslvSSLv23;
          IdHTTP.IOHandler := IdIoHandler;
        end;

        ResStream := TMemoryStream.Create();
        try
          vScriptParams :=
            Format('settitreforce?guid=%s&dateticket=%s&cabtitre=%s&numticket=%s&magcaisse=%s',[
              FGUID,FormatDateTime('yyyymmddhhnnss',FDATETICKET),FCABTITRE,FNUMTICKET,FMagCaisse
            ]);

          vURL := TIDURI.URLEncode(FURL + vScriptParams);

          IdHTTP.Get(vURL, ResStream);

          vDocXML := TXmlDocument.Create(nil);
          ResStream.Seek(0, soFromBeginning);
          try
            vDocXML.LoadFromStream(ResStream);
            result := ParseTitreDetail(vDocXML);

            If result.Error
              then
                begin
                    //infmess(GetErrorLib(result.NumError,result.sMEssage), '');
                end;
          finally
            // vDocXML.Free;
           end;
        finally
          FreeAndNil(ResStream);
        end;
      finally
          FreeAndNil(IdIOHandler);
      end;
    finally
      FreeAndNil(IdHttp);
    end;
  except
    on e : Exception do
    begin
      Result.Error    := true;
      Result.NumError := -99;
      Result.sMessage := e.ToString;
    end;
  end;
end;

class function TwsGetEasy2Play.getTitreDetail() : TWsTitreDetail;
var IdHttp : TIdHttp;
    IdIOHandler : TIdSSLIOHandlerSocketOpenSSL;
    ResStream : TMemoryStream;
    vError:Integer;
    vDocXML : TXMLDocument;
    vScriptParams : string;
    vURL : string;
begin
  Result.Init;
  if Trim(FURL) = '' then
    Exit;

  try
    IdHttp := TIdHttp.Create(nil);
    try
      IdIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      try
        if UpperCase(Copy(URL, 1, 5)) = 'HTTPS' then
        begin
          IdIoHandler.Destination := URL;
          IdIoHandler.SSLOptions.Method := sslvSSLv23;
          IdHTTP.IOHandler := IdIoHandler;
        end;
        ResStream := TMemoryStream.Create();
        try
          FDATETICKET := Now();
          vScriptParams :=
            Format('gettitredetail?guid=%s&dateticket=%s&cabtitre=%s&numticket=%s&magcaisse=%s',[
              FGUID,FormatDateTime('yyyymmddhhnnss',FDATETICKET),FCABTITRE,FNUMTICKET,FMagCaisse
            ]);

          vURL := TIDURI.URLEncode(FURL + vScriptParams);
          IdHTTP.Get(vURL , ResStream);

          vDocXML := TXmlDocument.Create(nil);
          ResStream.Seek(0, soFromBeginning);
          try
            vDocXML.LoadFromStream(ResStream);
            result := ParseTitreDetail(vDocXML);

            If result.Error
              then
                begin
                    //infmess(GetErrorLib(result.NumError,result.sMEssage), '');
                end;
          finally
            // vDocXML.Free;
           end;
        finally
          FreeAndNil(ResStream);
        end;
      finally
          FreeAndNil(IdIOHandler);
      end;
    finally
      FreeAndNil(IdHttp);
    end;
  except
    on e : Exception do
    begin
      Result.Error    := true;
      Result.NumError := -99;
      Result.sMessage := e.ToString;
    end;
  end;
end;

class function TwsGetEasy2Play.GetStatusWS():TwsStatut;
var IdHttp : TIdHttp;
    IdIOHandler : TIdSSLIOHandlerSocketOpenSSL;
    ResStream : TMemoryStream;
    vError:Integer;
    vDocXML : TXMLDocument;
    vURL: string;
begin

  Result.Init;
  if Trim(FURL) = '' then
    Exit;

  try
    IdHttp := TIdHttp.Create(nil);
    try
      IdIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      try
        if UpperCase(Copy(URL, 1, 5)) = 'HTTPS' then
        begin
          IdIoHandler.Destination := URL;
          IdIoHandler.SSLOptions.Method := sslvSSLv23;
          IdHTTP.IOHandler := IdIoHandler;
        end;

        IdHttp.ConnectTimeout := 1000;

        ResStream := TMemoryStream.Create();
        try
          vURL := TIDURI.URLEncode(FURL + 'getstatutws?guid=' + FGUID);

//          AddLogs(postURL);
          IdHTTP.Get(vURL, ResStream);
          vDocXML := TXmlDocument.Create(nil);
          ResStream.Seek(0, soFromBeginning);
          try
            vDocXML.LoadFromStream(ResStream);
            Result := ParseStatus(vDocXML);
          finally
            // vDocXML.Free;
          end;
        finally
          FreeAndNil(ResStream);
        end;
      finally
          FreeAndNil(IdIOHandler);
      end;
    finally
      FreeAndNil(IdHttp);
    end;
  except
    on e : Exception do
    begin
      Result.Error    := true;
      Result.sMessage := E.Message;
      Result.status   := 0;
    end;
  end;
end;

{ TCSHCHEQUETRTRec }

procedure TCSHCHEQUETRTRec.SetFields(AdataSet: TDataSet);
begin
  ID       := ADataSet.FieldByName('CKT_ID').AsInteger;
  CKDID    := ADataSet.FieldByName('CKT_CKDID').AsInteger;
  DATE     := ADataSet.FieldByName('CKT_DATE').AsDateTime;
  _TYPE    := ADataSet.FieldByName('CKT_TYPE').AsInteger;
  ANNUL    := ADataSet.FieldByName('CKT_ANNUL').AsString;
  APPELWS  := ADataSet.FieldByName('CKT_APPELWS').AsInteger;
  OKTRANS  := ADataSet.FieldByName('CKT_OKTRANS').AsInteger;
  RETTRANS := ADataSet.FieldByName('CKT_RETTRANS').AsInteger;
  NUMTRANS := ADataSet.FieldByName('CKT_NUMTRANS').AsString;
  MOTIF    := ADataSet.FieldByName('CKT_MOTIF').AsString;
  TRAITE   := ADataSet.FieldByName('CKT_TRAITE').AsInteger;
end;

initialization
  TwsGetEasy2Play.FURL := '';
  TwsGetEasy2Play.FGUID := '';

end.