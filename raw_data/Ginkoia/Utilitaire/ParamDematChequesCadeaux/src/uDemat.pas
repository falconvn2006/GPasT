unit uDemat;

interface

Uses IniFiles, Classes,Forms, uGestionBDD, StdCtrls;

const CST_INFO  = ' - INFO   : %s ';
      CST_ERROR = ' - ERREUR : %s ';
Type
    TCentrale = record
     NOM : string;
    end;
    Tcentrales = array of TCentrale;

    TMagasin = record
      MAG_ID  : Integer;
      MAG_NOM : string;
      MAG_CENTRALE : string;
      MAG_CODETIERS : string;
      MAG_CODE      : string;
      MAG_DONE : integer; //  0: non, 1: oui
    end;
    TMagasins = array of TMagasin;

    TEmetteur = record
      CKE_CODE    : string;
      CKE_LIBELLE : string;
      MEN_NOM     : string;
    procedure Init;
    end;
    TEmetteurs = array of TEmetteur;

    TPoste = record
      POS_ID  : Integer;
      POS_NOM : string;
    end;
    TPostes = array of TPoste;

    TEncaissement = record
      NOM : string;
    end;
    TEncaissements = array of TEncaissement;

    TTitre = record
     CKI_CKECODE  : string;
     CKI_TYPECODE : string;
     CKI_LIBELLE  : string;
     UTILISABLE   : integer;
    procedure Init;
    end;
    TTitres = array of TTitre;

    TParamsCentrale = record
      Nom        : string;          // Nom de la centrale
      TROP_PERCU : string;
      Defaut     : string;
      URL        : string;
      GUID       : string;
      DELAI      : integer;
      Emetteurs  : TEmetteurs; // Avec le Mode d'encaissement ou vide
      Titres     : TTitres;   // Avec le Utilisable ou NON
    procedure Init(aNom:string);
    Procedure Destroy;
    end;

    TCaisseButton = record
      ID          : integer;
      Position    : Integer;
      NewPosition : Integer;
    end;
    TCaisseButtons = array of TCaisseButton;

    TParamsMag = TParamsCentrale;


function GetParamDirectory():string;

// Init indépendant des centrales
function GetCentrales(): TCentrales;
function GetEmetteurs(): TEmetteurs;
function GetTitres(): TTitres;

function GetEncaissements(): TEncaissements;
function LoadParametrageCentrale(aCentrale:string):TParamsCentrale;
function SaveParametrageCentrale(aParamCentrale:TParamsCentrale):boolean;

// depuis la base
function GetDBEmetteurs(Server, FileName, UserName, Password : string; Port : integer): TEmetteurs;
function GetDBMagasinDemat(Server, FileName, UserName, Password : string; Port : integer): TMagasins;
function GetDBEncaissements(Server, FileName, UserName, Password : string; Port : integer): TEncaissements;
function GetDBAllTitres(Server, FileName, UserName, Password : string; Port : integer): TTitres;
function GetDBTitresFromCODE(Server, FileName, UserName, Password : string; Port : integer;aCKECODE:string): TTitres;
function GetPostes(aQuery:TMyQuery;aMAGID:Integer):TPostes;
function SetParams(Server, FileName, UserName, Password : string; Port : integer;aParamsMag:TParamsMag;aMemo:TMemo;aMags:TMagasins):boolean;
function GetResultSQL(aQuery:TMyQuery;aSQL:string):Integer;
function SetEmetteurModeEnc(aQuery:TMyQuery;aMAGID:integer;aEmetteur:TEmetteur):Boolean;
function FindFreePos(aButtons:TCaisseButtons):integer;
//
function CreateBoutonsOngletEncaissement(aQuery:TMyQuery;asQuery: TMyQuery; aMAGID:Integer;aMemo:TMemo):boolean;
function CreateBoutonsOngletUtilitaires(aQuery:TMyQuery;asQuery: TMyQuery; aMAGID:Integer;aMemo:TMemo):boolean;

function CreateModeEnc(aQuery:TMyQuery;aMAGID:Integer;aMENNOM:string;aSOCID,aBQEID,aCFFID:integer;aMemo:TMemo; AIntersport: Boolean = False):integer;

implementation

uses
  Dialogs,SysUtils;


procedure TParamsCentrale.Init(aNom:string);
begin
  Self.Nom := aNom;
  Self.TROP_PERCU := '';
  Self.Defaut     := '';
  Self.URL        := '';
  Self.GUID       := '';
  Self.DELAI      := 0;
  SetLength(Self.Emetteurs,0);
  SetLength(Self.Titres,0);
end;

Procedure TParamsCentrale.Destroy;
begin
  SetLength(Self.Emetteurs,0);
  SetLength(Self.Titres,0);
end;

procedure TTitre.Init();
begin
   Self.Utilisable:=0;
end;

procedure TEmetteur.Init();
begin
   Self.MEN_NOM:='';
end;


function GetParamDirectory():string;
begin
    Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+'gtParamDematChequeCadeaux\';
end;

function SaveParametrageCentrale(aParamCentrale:TParamsCentrale):boolean;
var vFile : TFileName;
    i:integer;
    vDatas : TStringList;
    vIniFile : TIniFile;
begin
  result:=false;
  if aParamCentrale.Nom='' then exit;
  // Sauver dans le .ini le trop percu, l'url...
  vIniFile := TIniFile.Create(GetParamDirectory + ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini' ));
  try
   vIniFile.WriteString(aParamCentrale.Nom,'TROP_PERCU',aParamCentrale.TROP_PERCU);
   vIniFile.WriteString(aParamCentrale.Nom,'DEFAUT',aParamCentrale.Defaut);
   vIniFile.WriteString(aParamCentrale.Nom,'URL',aParamCentrale.URL);
   vIniFile.WriteString(aParamCentrale.Nom,'GUID',aParamCentrale.GUID);
   vIniFile.WriteInteger(aParamCentrale.Nom,'DELAI',aParamCentrale.DELAI);
  finally
   vIniFile.Free;
  end;

  vFile := GetParamDirectory +  aParamCentrale.Nom + '_emetteurs.csv';
  vDatas := TStringList.Create;
  try
    if FileExists(vFile) then
        begin
          DeleteFile(vFile);
        end;
      for i:=Low(aParamCentrale.Emetteurs) to High(aParamCentrale.Emetteurs) do
          begin
            vDatas.Add(Format('"%s","%s","%s"',[
                  aParamCentrale.Emetteurs[i].CKE_CODE,
                  aParamCentrale.Emetteurs[i].CKE_LIBELLE,
                  aParamCentrale.Emetteurs[i].MEN_NOM
                  ]));
          end;
      vDatas.SaveToFile(vFile);
    finally
      vDatas.Free;
    end;

  // Les titres
  vFile := GetParamDirectory +  aParamCentrale.Nom + '_titres.csv';
  vDatas := TStringList.Create;
  try
    if FileExists(vFile) then
        begin
          DeleteFile(vFile);
        end;
     for i:=Low(aParamCentrale.Titres) to High(aParamCentrale.Titres) do
          begin
            vDatas.Add(Format('"%s","%s","%s","%s"',[
                  aParamCentrale.Titres[i].CKI_CKECODE,
                  aParamCentrale.Titres[i].CKI_TYPECODE,
                  aParamCentrale.Titres[i].CKI_LIBELLE,
                  IntToStr(aParamCentrale.Titres[i].UTILISABLE)
                  ]));
          end;
      vDatas.SaveToFile(vFile);
    finally
      vDatas.Free;
    end;
  result:=true;
end;

function LoadParametrageCentrale(aCentrale:string):TParamsCentrale;
var i,j:integer;
    vDatas : TStringList;
    vrecord  : TStringList;
    vFile : TFileName;
    vIniFile : TIniFile;
begin
  Result.Init(aCentrale);
  // SetLength(Result.Emetteurs,0);  fait dans le Init
  // SetLength(Result.Titres,0);
  //  vIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini' ));
  vIniFile := TIniFile.Create(GetParamDirectory + ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini' ));
  try
    Result.TROP_PERCU := vIniFile.ReadString(aCentrale,'TROP_PERCU','');
    Result.Defaut     := vIniFile.ReadString(aCentrale,'DEFAUT','');
    Result.URL        := vIniFile.ReadString(aCentrale,'URL','');
    Result.GUID       := vIniFile.ReadString(aCentrale,'GUID','');
    Result.DELAI      := vIniFile.ReadInteger(aCentrale,'DELAI',15);
  finally
    vIniFile.Free;
  end;

  vDatas := TStringList.Create;
  vrecord  := TStringList.Create;
  try
     vFile := GetParamDirectory +  aCentrale + '_emetteurs.csv';
     if FileExists(vFile) then
      begin
         vDatas.LoadFromFile(vFile,TEncoding.UTF8);
         for i:=0 to vDatas.Count-1 do
           begin
              j:=Length(Result.Emetteurs);
              SetLength(Result.Emetteurs,j+1);
              vRecord.CommaText := vDatas.Strings[i];
              Result.Emetteurs[j].CKE_CODE    := vRecord[0];
              Result.Emetteurs[j].CKE_LIBELLE := vRecord[1];
              Result.Emetteurs[j].MEN_NOM     := vRecord[2];
           end;
      end;
     vFile := GetParamDirectory +  aCentrale + '_titres.csv';
     if FileExists(vFile) then
      begin
         vDatas.LoadFromFile(vFile,TEncoding.UTF8);
         for i:=0 to vDatas.Count-1 do
           begin
              j:=Length(Result.Titres);
              SetLength(Result.Titres,j+1);
              vRecord.CommaText := vDatas.Strings[i];
              Result.Titres[j].CKI_CKECODE  := vRecord[0];
              Result.Titres[j].CKI_TYPECODE := vRecord[1];
              Result.Titres[j].CKI_LIBELLE  := vRecord[2];
              Result.Titres[j].UTILISABLE   := StrToIntDef(vRecord[3],0)
           end;
      end;
  finally
    vDatas.Free;
    vrecord.Free;
  end;
end;

function GetCentrales(): TCentrales;
var i,j:integer;
//    vDatas : TStringList;
//    vrecord  : TStringList;
    vIniFile : TIniFile;
    vList : TStringList;
begin
  SetLength(Result,0);
//  vIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini' ));
  vIniFile := TIniFile.Create(GetParamDirectory + ChangeFileExt(ExtractFileName(ParamStr(0)), '.ini' ));
  vlist := TStringList.Create;
  try
    vIniFile.ReadSections(vList);
    for i :=0 to vList.Count-1 do
        begin
           j:=Length(Result);
           SetLength(Result,j+1);
           Result[j].NOM  := vList.Strings[i];
        end;

  finally
    FreeAndNil(vlist);
    vIniFile.Free;
  end;
  {
  vDatas := TStringList.Create;
  vrecord  := TStringList.Create;
  try
     vDatas.LoadFromFile(ExtractFilePath(ParamStr(0)) +  'centrales.csv',TEncoding.UTF8);
     try
        for i:=0 to vDatas.Count-1 do
          begin
               j:=Length(Result);
               SetLength(Result,j+1);
               vRecord.CommaText := vDatas.Strings[i];
               Result[j].NOM  := vRecord[0];
            end;
     finally
      //
     end;
  finally
    vDatas.Free;
    vrecord.Free;
  end;
  }
end;

{----
procedure ExtractFromRes(aRes:string;aFileName:string);
var  vFile : TFileName;
     ResScripts:TResourceStream;
begin
  try
    vFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+aFileName);
    If FileExists(vFile)
      then TFile.Delete(vFile);
    ResScripts := TResourceStream.Create(HInstance, aRes, RT_RCDATA);
    try
      ResScripts.SaveToFile(vFile);
      finally
      ResScripts.Free();
    end;
  finally
    CashScript.DisposeOf();
    Script.DisposeOf();
  end;
end;

----}


function GetEncaissements(): TEncaissements;
var i,j:integer;
    vDatas : TStringList;
    vrecord  : TStringList;
begin
  SetLength(Result,0);
  vDatas := TStringList.Create;
  vrecord  := TStringList.Create;
  try
     vDatas.LoadFromFile(GetParamDirectory +  'encaissements.csv',TEncoding.UTF8);
     try
        for i:=0 to vDatas.Count-1 do
          begin
               j:=Length(Result);
               SetLength(Result,j+1);
               vRecord.CommaText := vDatas.Strings[i];
               Result[j].NOM  := vRecord[0];
            end;
     finally
      //
     end;
  finally
    vDatas.Free;
    vrecord.Free;
  end;
end;




function GetTitres(): TTitres;
var i,j:integer;
    vDatas : TStringList;
    vrecord  : TStringList;
begin
  SetLength(Result,0);
  vDatas := TStringList.Create;
  vrecord  := TStringList.Create;
  try
     vDatas.LoadFromFile(GetParamDirectory +  'titres.csv',TEncoding.UTF8);
     try
        for i:=0 to vDatas.Count-1 do
          begin
               j:=Length(Result);
               SetLength(Result,j+1);
               vRecord.CommaText := vDatas.Strings[i];
               Result[j].CKI_CKECODE  := vRecord[0];
               Result[j].CKI_TYPECODE := vRecord[1];
               Result[j].CKI_LIBELLE  := vRecord[2];
            end;
     finally
      //
     end;
  finally
    vDatas.Free;
    vrecord.Free;
  end;
end;


function GetEmetteurs(): TEmetteurs;
var i,j:integer;
    vDatas : TStringList;
    vrecord  : TStringList;
begin
  SetLength(Result,0);
  vDatas := TStringList.Create;
  vrecord  := TStringList.Create;
  try
     vDatas.LoadFromFile(GetParamDirectory +  'emetteurs.csv',TEncoding.UTF8);
     try
        for i:=0 to vDatas.Count-1 do
          begin
               j:=Length(Result);
               SetLength(Result,j+1);
               vRecord.CommaText := vDatas.Strings[i];
               Result[j].CKE_CODE    := vRecord[0];
               Result[j].CKE_LIBELLE := vRecord[1];
            end;
     finally
      //
     end;
  finally
    vDatas.Free;
    vrecord.Free;
  end;
end;

{
function GetDBTitresFromCODE(Server, FileName, UserName, Password : string; Port : integer;aCKECODE:string): TTitres;
var Connexion : TMyConnection;
    vQuery : TMyQuery;
    i:integer;
begin
  SetLength(Result,0);
  try
    try
      Connexion := GetNewConnexion(Server, FileName, UserName, Password, Port, false);
      Connexion.Open();
      if Connexion.Connected then
      begin
        try
          vQuery := GetNewQuery(Connexion);
          vQuery.SQL.Clear;
          vQuery.SQL.Add('SELECT MEN_ID, MEN_NOM FROM CSHMODEENC)       ');
          vQuery.SQL.Add(' JOIN K ON (K_ID = MEN_ID AND K_ENABLED = 1)  ');
          vQuery.SQL.Add(' WHERE MEN_IDENT IN (''BEST'',''BON KYR.'',''CADHOC'',''CHQ CADO'',''HAVAS'',''KADEOS'', ''SHOP. PASS'',''TIR GRP'',''TK HORI'',''TK INF'') ');
          vQuery.SQL.Add(' AND MEN_MAGID=:MAGID AND MEN_NOM NOT LIKE ''NE PLUS UTILISER - %'' ');
          vQuery.ParamByName('CKECODE').AsString := aCKECODE;
          vQuery.Open();
        finally

        end;
      end;
    finally
    end;
end;
}


function GetDBTitresFromCODE(Server, FileName, UserName, Password : string; Port : integer;aCKECODE:string): TTitres;
var Connexion : TMyConnection;
    vQuery : TMyQuery;
    i:integer;
begin
  SetLength(Result,0);
  try
    try
      Connexion := GetNewConnexion(Server, FileName, UserName, Password, Port, false);
      Connexion.Open();
      if Connexion.Connected then
      begin
        try
          vQuery := GetNewQuery(Connexion);
          try
            vQuery.SQL.Clear;
            vQuery.SQL.Add('SELECT CKI_CKECODE, CKI_TYPECODE, CKI_LIBELLE FROM CSHEMETTEURTITRE');
            vQuery.SQL.Add(' WHERE CKI_CKECODE=:CKECODE');
            vQuery.ParamByName('CKECODE').AsString := aCKECODE;
            vQuery.Open();
            while not(vQuery.Eof) do
              begin
                i:=Length(Result);
                SetLength(Result,i+1);
                Result[i].CKI_CKECODE  := vQuery.FieldByName('CKI_CKECODE').asstring;
                Result[i].CKI_TYPECODE := vQuery.FieldByName('CKI_TYPECODE').asstring;
                Result[i].CKI_LIBELLE  := vQuery.FieldByName('CKI_LIBELLE').asstring;
                vQuery.Next;
              end;
          finally
            vQuery.Close();
          end;
        finally
          FreeAndNil(vQuery);
        end;
      end;
    finally
      FreeAndNil(Connexion);
    end;
  except
    on e : exception do
    begin
      // error := e.ClassName + ' - ' + e.Message;
    end;
  end;
end;


function GetDBAllTitres(Server, FileName, UserName, Password : string; Port : integer): TTitres;
var Connexion : TMyConnection;
    vQuery : TMyQuery;
    i:integer;
begin
  SetLength(Result,0);
  try
    try
      Connexion := GetNewConnexion(Server, FileName, UserName, Password, Port, false);
      Connexion.Open();
      if Connexion.Connected then
      begin
        try
          vQuery := GetNewQuery(Connexion);
          try
            vQuery.SQL.Clear;
            vQuery.SQL.Add('SELECT CKI_CKECODE, CKI_TYPECODE, CKI_LIBELLE FROM CSHEMETTEURTITRE');
            // Join K ?
            vQuery.SQL.Add(' WHERE CKI_ID<>0 ');
            vQuery.Open();
            while not(vQuery.Eof) do
              begin
                i:=Length(Result);
                SetLength(Result,i+1);
                Result[i].CKI_CKECODE  := vQuery.FieldByName('CKI_CKECODE').asstring;
                Result[i].CKI_TYPECODE := vQuery.FieldByName('CKI_TYPECODE').asstring;
                Result[i].CKI_LIBELLE  := vQuery.FieldByName('CKI_LIBELLE').asstring;
                vQuery.Next;
              end;
          finally
            vQuery.Close();
          end;
        finally
          FreeAndNil(vQuery);
        end;
      end;
    finally
      FreeAndNil(Connexion);
    end;
  except
    on e : exception do
    begin
      // error := e.ClassName + ' - ' + e.Message;
    end;
  end;
end;

function GetDBEncaissements(Server, FileName, UserName, Password : string; Port : integer): TEncaissements;
var Connexion : TMyConnection;
    vQuery : TMyQuery;
    i:integer;
begin
  SetLength(Result,0);
  try
    try
      Connexion := GetNewConnexion(Server, FileName, UserName, Password, Port, false);
      Connexion.Open();
      if Connexion.Connected then
      begin
        try
          // le Vide
          i:=Length(Result);
          SetLength(Result,i+1);
          Result[i].NOM := '';
          //
          vQuery := GetNewQuery(Connexion);
          try
            vQuery.SQL.Clear;
            vQuery.SQL.Add('SELECT DISTINCT CKE_CODE, CKE_LIBELLE FROM CSHEMETTEURENC');
            vQuery.SQL.Add(' WHERE CKE_ID<>0 ');
            vQuery.Open();
            while not(vQuery.Eof) do
              begin
                i:=Length(Result);
                SetLength(Result,i+1);
                Result[i].NOM := vQuery.FieldByName('CKE_LIBELLE').asstring + ' - ' + vQuery.FieldByName('CKE_CODE').asstring;
                vQuery.Next;
              end;
          finally
            vQuery.Close();
          end;
        finally
          FreeAndNil(vQuery);
        end;
      end;
    finally
      FreeAndNil(Connexion);
    end;
  except
    on e : exception do
    begin
      // error := e.ClassName + ' - ' + e.Message;
    end;
  end;
end;


function GetDBEmetteurs(Server, FileName, UserName, Password : string; Port : integer): TEmetteurs;
var Connexion : TMyConnection;
    vQuery : TMyQuery;
    i:integer;
begin
  SetLength(Result,0);
  try
    try
      Connexion := GetNewConnexion(Server, FileName, UserName, Password, Port, false);
      Connexion.Open();
      if Connexion.Connected then
      begin
        try
          vQuery := GetNewQuery(Connexion);
          try
            vQuery.SQL.Clear;
            vQuery.SQL.Add('SELECT DISTINCT CKE_CODE, CKE_LIBELLE FROM CSHEMETTEURENC');
            vQuery.SQL.Add(' WHERE CKE_ID<>0 ');
            vQuery.Open();
            while not(vQuery.Eof) do
              begin
                i:=Length(Result);
                SetLength(Result,i+1);
                Result[i].CKE_CODE    := vQuery.FieldByName('CKE_CODE').asstring;
                Result[i].CKE_LIBELLE := vQuery.FieldByName('CKE_LIBELLE').asstring;
                Result[i].MEN_NOM     := vQuery.FieldByName('CKE_LIBELLE').asstring + ' - ' + vQuery.FieldByName('CKE_CODE').asstring;
                vQuery.Next;
              end;
          finally
            vQuery.Close();
          end;
        finally
          FreeAndNil(vQuery);
        end;
      end;
    finally
      FreeAndNil(Connexion);
    end;
  except
    on e : exception do
    begin
      // error := e.ClassName + ' - ' + e.Message;
    end;
  end;
end;


function GetDBMagasinDemat(Server, FileName, UserName, Password : string; Port : integer): TMagasins;
var Connexion : TMyConnection;
    vQuery : TMyQuery;
    i,j:integer;
    vVersion : string;
    vCentrale : string;
    vEncaissements : TEncaissements;
begin
  SetLength(Result,0);
  try
    try
      Connexion := GetNewConnexion(Server, FileName, UserName, Password, Port, false);
      Connexion.Open();
      if Connexion.Connected then
      begin
        try
          vQuery := GetNewQuery(Connexion);
          try

            vQuery.SQL.Text := 'select bas_nompournous, max(bas_centrale) as bas_centrale, count(*) as nb from genbases join k on k_id = bas_id and k_enabled = 1 where bas_id != 0 group by bas_nompournous order by 3 desc rows 1;';
            vQuery.Open();
             if not(vQuery.Eof) then
             begin
               vCentrale := UpperCase(Trim(vQuery.FieldByName('bas_centrale').AsString));
             end;



            vQuery.SQL.Clear;
            vQuery.SQL.Add('SELECT MAG_ID, MAG_NOM, MAG_CODE FROM UILGRPGINKOIA    ');
            vQuery.SQL.Add('	JOIN UILGRPGINKOIAMAG ON UGG_ID=UGM_UGGID  ');
            vQuery.SQL.Add('  JOIN GENMAGASIN ON MAG_ID=UGM_MAGID        ');
            vQuery.SQL.Add('  WHERE UGG_NOM=''DEMATCHEQUECADEAU''        ');
            vQuery.Open();
            while not(vQuery.Eof) do
              begin
                i:=Length(Result);
                SetLength(Result,i+1);
                Result[i].MAG_ID   := vQuery.FieldByName('MAG_ID').asinteger;
                Result[i].MAG_NOM  := vQuery.FieldByName('MAG_NOM').asstring;
                Result[i].MAG_CODE := vQuery.FieldByName('MAG_CODE').asstring;
                Result[i].MAG_CENTRALE := vCentrale;
                result[i].MAG_DONE := 0;
                vQuery.Next;
              end;


            vEncaissements := GetEncaissements();

            vQuery.SQL.Clear;
            vQuery.SQL.Add('SELECT * FROM CSHMODEENC                 ');
            vQuery.SQL.Add('JOIN K ON K_ID=MEN_ID AND K_ENABLED=1    ');
            vQuery.SQL.Add('WHERE MEN_MAGID=:MAGID AND MEN_ID<>0     ');
            vQuery.SQL.Add('AND MEN_NOM=:MENNOM                      ');
            for I := Low(result) to High(Result) do
                begin
                    for j:= Low(vEncaissements) to High(vEncaissements) do
                        begin
                            if vEncaissements[j].NOM<>'' then
                              begin
                                vQuery.Close();
                                vQuery.ParamByName('MAGID').AsInteger := result[i].MAG_ID;
                                vQuery.ParamByName('MENNOM').AsString  := vEncaissements[j].NOM;
                                vQuery.Open();
                                if not(vQuery.IsEmpty)
                                  then
                                    begin
                                       result[i].MAG_DONE := 1;
                                       Break;
                                    end;
                              end;
                        end;
                end;


          // Recup de la version
          vQuery.Close();
          vQuery.SQL.Clear;
          vQuery.SQL.Text := 'select ver_version, ver_date from genversion order by ver_date desc rows 1;';
          vQuery.Open();
           if not(vQuery.Eof) then
            begin
              vVersion := Trim(vQuery.FieldByName('ver_version').AsString);
            end;
          // Différentes versions
          if vVersion<='18.1.0.9999' then
            begin
                vQuery.SQL.Clear;
                vQuery.SQL.Add('SELECT GENBASES.* FROM genmagasin        ');
                vQuery.SQL.Add('JOIN K ON K_ID=MAG_ID AND K_ENABLED=1    ');
                vQuery.SQL.Add('JOIN GENBASES ON BAS_ID=MAG_BASID        ');
                vQuery.SQL.Add('JOIN K ON K_ID=BAS_ID AND K_ENABLED=1    ');
                vQuery.SQL.Add('WHERE MAG_ID=:MAGID AND MAG_ID<>0        ');
                for I := Low(result) to High(Result) do
                    begin
                        vQuery.Close();
                        vQuery.ParamByName('MAGID').AsInteger := result[i].MAG_ID;
                        vQuery.Open();
                        if not(vQuery.IsEmpty) then
                          begin
                             result[i].MAG_CODETIERS := vQuery.FieldByName('BAS_CODETIERS').Asstring;
                          end;
                    end;
            end;
          if vVersion>'18.1.0.9999' then
            begin
                vQuery.SQL.Clear;
                vQuery.SQL.Add('SELECT GENMAGASIN.* FROM genmagasin        ');
                vQuery.SQL.Add('JOIN K ON K_ID=MAG_ID AND K_ENABLED=1    ');
                vQuery.SQL.Add('WHERE MAG_ID=:MAGID AND MAG_ID<>0        ');
                for I := Low(result) to High(Result) do
                    begin
                        vQuery.Close();
                        vQuery.ParamByName('MAGID').AsInteger := result[i].MAG_ID;
                        vQuery.Open();
                        if not(vQuery.IsEmpty) then
                          begin
                             result[i].MAG_CODETIERS := vQuery.FieldByName('MAG_CODETIERS').Asstring;
                          end;
                    end;
            end;

          finally
            vQuery.Close();
          end;
        finally
          FreeAndNil(vQuery);
        end;
      end;






    finally
      FreeAndNil(Connexion);
    end;
  except
    on e : exception do
    begin
      // error := e.ClassName + ' - ' + e.Message;
    end;
  end;
end;

function GetResultSQL(aQuery:TMyQuery;aSQL:string):Integer;
begin
  Result := 0;
  aQuery.close;
  aQuery.SQL.Clear;
  aQuery.SQL.Add(aSQL);
  aQuery.open;
  if not(aQuery.Eof)
    then Result := aQuery.Fields[0].AsInteger;
  aQuery.Close;
end;

function SetEmetteurTitreLink(aQuery:TMyQuery;aMAGID:integer;aTitre:TTitre):Boolean;
var vCKEID : integer;
    vCKIID : integer;
    vCKLID : Integer;
    vID    : integer;
    vActif : integer;
begin
    // Trouver CKI_ID = l'ID du Titre
    result := false;
    vCKEID := 0;
    vCKIID := 0;
    vCKLID := 0;
    vID    := 0;
    vActif := 0;
    try

      // si avant V17.3 il n'y a pas la table
      aQuery.Close;
      aQuery.SQL.Clear;
      aQuery.SQL.Add('SELECT RDB$RELATION_NAME  ');
      aQuery.SQL.Add('  FROM RDB$RELATIONS      ');
      aQuery.SQL.Add(' WHERE RDB$SYSTEM_FLAG=0  ');
      aQuery.SQL.Add('  AND RDB$RELATION_NAME=:ATABLE');
      aQuery.ParamByName('ATABLE').AsString := 'CSHEMETTEURTITRE';
      aQuery.Open;
      If (aQuery.IsEmpty) then exit;

      aQuery.Close;
      aQuery.SQL.Clear;
      aQuery.SQL.Add('SELECT CKE_ID FROM CSHEMETTEURENC              ');
      aQuery.SQL.Add(' JOIN K ON K_ID=CKE_ID AND K_ENABLED=1         ');
      aQuery.SQL.Add(' WHERE CKE_MAGID=:MAGID AND CKE_CODE=:CODE     ');
      aQuery.ParamByName('MAGID').AsInteger := aMAGID;
      aQuery.ParamByName('CODE').AsString  := aTitre.CKI_CKECODE;
      aQuery.Open;
      if not(aQuery.eof) then
         begin
            vCKEID := aQuery.FieldByName('CKE_ID').Asinteger;
         end;
      aQuery.Close;

      aQuery.Close;
      aQuery.SQL.Clear;
      aQuery.SQL.Add('SELECT CKI_ID FROM CSHEMETTEURTITRE              ');
      aQuery.SQL.Add(' JOIN K ON K_ID=CKI_ID AND K_ENABLED=1           ');
      aQuery.SQL.Add(' WHERE CKI_CKECODE=:CKECODE AND CKI_TYPECODE=:TYPECODE ');
      aQuery.ParamByName('CKECODE').AsString  := aTitre.CKI_CKECODE;
      aQuery.ParamByName('TYPECODE').AsString := aTitre.CKI_TYPECODE;
      aQuery.Open;
      if not(aQuery.eof) then
         begin
            vCKIID := aQuery.FieldByName('CKI_ID').Asinteger;
         end;
      aQuery.Close;

      aQuery.Close;
      aQuery.SQL.Clear;
      aQuery.SQL.Add('SELECT CKL_ID, K_ENABLED FROM CSHEMETTEURTITRELINK ');
      aQuery.SQL.Add(' JOIN K ON K_ID=CKL_ID                             ');  // Attention on prend meme le K_ENABLED=0 car c'est justement le flag coché / décoché
      aQuery.SQL.Add(' WHERE CKL_CKEID=:CKEID AND CKL_CKIID=:CKIID       ');
      aQuery.ParamByName('CKEID').AsInteger  := vCKEID;
      aQuery.ParamByName('CKIID').Asinteger  := vCKIID;
      aQuery.Open;
      if not(aQuery.eof) then
         begin
            vCKLID := aQuery.FieldByName('CKL_ID').Asinteger;
            vActif := aQuery.FieldByName('K_ENABLED').Asinteger;
         end;
      aQuery.Close;

      // --------------
      if (vCKLID=0)  // Création du CSHEMETTEURTITRELINK
        then
          begin
            //
           // Création du Mode d'encaissement
           aQuery.Close();
           aQuery.SQL.Clear;
           aQuery.SQL.Add('SELECT ID FROM PR_NEWK(:TABLE)');
           aQuery.ParamByName('TABLE').asstring := 'CSHEMETTEURTITRELINK';
           aQuery.Open();
           if aQuery.RecordCount=1 then
            begin
              vID:=aQuery.FieldByName('ID').Asinteger;
            end;
           aQuery.Close();
           aQuery.SQL.Clear;
           aQuery.SQL.Add('INSERT INTO CSHEMETTEURTITRELINK (CKL_ID,CKL_CKIID,CKL_CKEID) VALUES (:CKLID,:CKIID,:CKEID);');
           aQuery.ParamByName('CKLID').AsInteger := vID;
           aQuery.ParamByName('CKIID').AsInteger := vCKIID;
           aQuery.ParamByName('CKEID').AsInteger := vCKEID;
           aQuery.ExecSQL;

           // C'est cool c'est créé maintenant mais c'est peut-etre désactivé en fait...
           IF (aTitre.UTILISABLE=0)
            then
              begin
                aQuery.Close();
                aQuery.SQL.Clear;
                aQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,1);');  // On désactive
                aQuery.ParamByName('ID').AsInteger  := vID;
                aQuery.ExecSQL;
              end;
          end
        else     // Mise à jour du CSHEMETTEURTITRELINK
          begin
            aQuery.Close;
            aQuery.SQL.Clear;
            aQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,:MVT);');
            aQuery.ParamByName('ID').AsInteger  := vCKLID;
            // Rappel : 0=mvt, 1=désactive, 2=réactive
            // Si déjà actif et maintenant utlisable : on mouvemente(0)... ou pourrait rien faire
            if (vActif=1) and (aTitre.UTILISABLE=1)
              then aQuery.ParamByName('MVT').AsInteger := 0;

            // Si déjà actif et maintenant plus utlisable : on désactive(1)
            if (vActif=1) and (aTitre.UTILISABLE=0)
              then aQuery.ParamByName('MVT').AsInteger := 1;

            // Si déjà non actif et maintenant plus utlisable : on mouvement(0)... ou pourrait rien faire
            if (vActif=0) and (aTitre.UTILISABLE=0)
              then aQuery.ParamByName('MVT').AsInteger := 1;

            // Si déjà non actif et maintenant utlisable : on réactive (2)
            if (vActif=0) and (aTitre.UTILISABLE=1)
              then aQuery.ParamByName('MVT').AsInteger := 2;
            aQuery.ExecSQL;

          end;
      Result := True;
    except
      Result := false;
    end;
end;

function SetEmetteurModeEnc(aQuery:TMyQuery;aMAGID:integer;aEmetteur:TEmetteur):Boolean;
var vCKEID : integer;
    vMENID : Integer;
begin
  Result := false;
  try
    vCKEID := 0;
    vMENID := 0;
    aQuery.Close;
    aQuery.SQL.Clear;
    aQuery.SQL.Add('SELECT * FROM CSHEMETTEURENC                   ');
    aQuery.SQL.Add(' JOIN K ON K_ID=CKE_ID AND K_ENABLED=1         ');
    aQuery.SQL.Add(' WHERE CKE_MAGID=:MAGID AND CKE_CODE=:CODE     ');
    aQuery.ParamByName('MAGID').AsInteger := aMAGID;
    aQuery.ParamByName('CODE').AsString  := aEmetteur.CKE_CODE;
    aQuery.Open;
    if not(aQuery.eof) then
       begin
          vCKEID := aQuery.FieldByName('CKE_ID').Asinteger;
       end;
    aQuery.Close;

    if aEmetteur.MEN_NOM<>'' then
      begin
        vMENID := GetResultSQL(aQuery,'SELECT MEN_ID FROM CSHMODEENC WHERE MEN_NOM='+QuotedStr(aEmetteur.MEN_NOM)+' AND MEN_MAGID='+IntToStr(aMAGID));
      end;

    if vCKEID<>0 then
      begin
        aQuery.Close;
        aQuery.SQL.Clear;
        aQuery.SQL.Add('UPDATE CSHEMETTEURENC SET CKE_MENID=:MENID WHERE CKE_ID=:CKEID');
        aQuery.ParamByName('MENID').AsInteger := vMENID; // même si c'est 0 il faut le mettre
        aQuery.ParamByName('CKEID').AsInteger := vCKEID;
        aQuery.ExecSQL;

        aQuery.Close;
        aQuery.SQL.Clear;
        aQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0);');
        aQuery.ParamByName('ID').AsInteger := vCKEID;
        aQuery.ExecSQL;

        aQuery.Close;
      end;

    result:=true;

  except
    result:=false;
  end;
end;

function CreateModeEnc(aQuery:TMyQuery;aMAGID:Integer;aMENNOM:string;aSOCID,aBQEID,aCFFID:integer;aMemo:TMemo; AIntersport: Boolean = False):integer;
var vID     : Integer;
    iImpID  : Integer;
//    vSOCID  : integer;
//    vBQEID  : integer;
//    vCFFID  : integer;
begin
    result := 0;
    if (aMENNOM='')
      then
        begin
          aMemo.Lines.Add(Format(CST_INFO,['Mode Encaissement "'+aMENNOM+'" (vide) ==> 0']));
          exit;
        end;
    aQuery.Close;
    aQuery.SQL.Clear;
    aQuery.SQL.Add('SELECT * FROM CSHMODEENC                       ');
    aQuery.SQL.Add(' JOIN K ON K_ID=MEN_ID AND K_ENABLED=1         ');
    aQuery.SQL.Add(' WHERE MEN_MAGID=:MAGID AND MEN_NOM=:NOM       ');
    aQuery.ParamByName('MAGID').AsInteger := aMAGID;
    aQuery.ParamByName('NOM').AsString  := aMENNOM;
    aQuery.Open;
    if not(aQuery.eof) then
       begin
          Result := aQuery.FieldByName('MEN_ID').Asinteger;
          aMemo.Lines.Add(Format(CST_INFO,['Mode Encaissement "'+aMENNOM+'" déjà présent']));
       end;
    aQuery.Close;
    if (result=0) then
        begin
           // Création du Mode d'encaissement
           aQuery.SQL.Clear;
           aQuery.SQL.Add('SELECT ID FROM PR_NEWK(:TABLE)');
           aQuery.ParamByName('TABLE').asstring := 'CSHMODEENC';
           aQuery.Open();
           if aQuery.RecordCount=1 then
            begin
              vID:=aQuery.FieldByName('ID').Asinteger;
            end;
           aQuery.Close;
           aQuery.SQL.Clear;
           aQuery.SQL.Add('INSERT INTO CSHMODEENC (MEN_ID,MEN_MAGID,MEN_NOM,MEN_IDENT,MEN_COULEUR,                           ');
           aQuery.SQL.Add('  MEN_RACCOURCI,MEN_COMPTA,MEN_TXCHANGE,MEN_PRECISION,MEN_BQEID,MEN_CFFID,MEN_OUVTIROIR,          ');
           aQuery.SQL.Add('  MEN_MONTSUP,MEN_VERIF,MEN_FONDVARI,MEN_DETAIL,MEN_DATEECH,MEN_MONTREST,MEN_TYPEMOD,MEN_TYPETRF, ');
           aQuery.SQL.Add('  MEN_ISODEF,MEN_RAPIDO,MEN_ICONE,MEN_DOC,MEN_TPE,MEN_CFFCENTRAL,MEN_APPLICATION,MEN_REMISEOTO)   ');
           aQuery.SQL.Add(' VALUES (:MENID,:MAGID,:NOM,'''','''','''','''',0,0,:BQEID,:CFFID,1,0,1,0,0,0,0,5,1,'''',0,'''',0,0,:CFFID,0,0);');
           aQuery.ParamByName('MENID').AsInteger := vID;
           aQuery.ParamByName('MAGID').AsInteger := aMAGID;
           aQuery.ParamByName('NOM').Asstring    := aMENNOM;
           aQuery.ParamByName('BQEID').Asinteger := aBQEID;
           aQuery.ParamByName('CFFID').Asinteger := aCFFID;
           aQuery.ExecSQL;
           result := vID;
           aMemo.Lines.Add(Format(CST_INFO,['Création du Mode Encaissement "'+aMENNOM+'"']));
           
           //-------------------------------------------------------------------
           // Intersport : Création de l'équivalent FIDBOX = Espèces            
           //-------------------------------------------------------------------
           if AIntersport then                                  
              begin
                 aQuery.SQL.Clear;
                 aQuery.SQL.Add('SELECT ID FROM PR_NEWK(:TABLE)');
                 aQuery.ParamByName('TABLE').asstring := 'GENIMPORT';
                 aQuery.Open();
                 if aQuery.RecordCount = 1 then
                    begin
                       iImpID := aQuery.FieldByName('ID').Asinteger;
                    end;
                 aQuery.Close;
                 aQuery.SQL.Clear;
                 aQuery.SQL.Add('INSERT INTO GENIMPORT (IMP_ID, IMP_KTBID, IMP_GINKOIA, IMP_REF, IMP_NUM, IMP_REFSTR) ');
                 aQuery.SQL.Add('VALUES                (:IMPID, :IMPKTBID, :IMPGINKOIA, :IMPREF, :IMPNUM, :IMPREFSTR);');
                 aQuery.ParamByName('IMPID').AsInteger      := iImpID;
                 aQuery.ParamByName('IMPKTBID').AsInteger   := -11111418;       // l'ID de la table CSHMODEENC
                 aQuery.ParamByName('IMPGINKOIA').AsInteger := vID;             // CSHMODEENC.MEN_ID
                 aQuery.ParamByName('IMPREF').AsInteger     := 1;               // 1 - Espèces
                 aQuery.ParamByName('IMPNUM').AsInteger     := 11;
                 aQuery.ParamByName('IMPREFSTR').AsString   := 'Espèces';
                 aQuery.ExecSQL;
                 aMemo.Lines.Add(Format(CST_INFO,['Création de l''équivalent FIDBOX Intersport à "Espèces" pour le mode d''encaissement "' + aMENNOM + '"']));
              end;
           //-------------------------------------------------------------------
        end;                                                                    
end;

function GetPostes(aQuery:TMyQuery;aMAGID:Integer):TPostes;
var i:integer;
begin
     SetLength(Result,0);
     aQuery.Close;
     aQuery.SQL.Clear;
     aQuery.SQL.Add('SELECT DISTINCT BTN_POSID, POS_NOM ');
     aQuery.SQL.Add(' FROM CSHBOUTON                                            ');
     aQuery.SQL.Add(' JOIN K ON K_ID=BTN_ID AND K_ENABLED=1                     ');
     aQuery.SQL.Add(' JOIN GENPOSTE ON POS_ID=BTN_POSID AND POS_MAGID=:MAGID    ');
     aQuery.SQL.Add(' JOIN K ON K_ID=POS_ID AND K_ENABLED=1                     ');
     aQuery.SQL.Add(' WHERE BTN_POSID<>0                                        ');
     aQuery.ParamByName('MAGID').AsInteger := aMAGID;
     aQuery.Open();
     while not(aQuery.Eof) do
         begin
            i:=Length(Result);
            SetLength(Result,i+1);
            Result[i].POS_ID := aQuery.FieldByName('BTN_POSID').asinteger;
            Result[i].POS_NOM := aQuery.FieldByName('POS_NOM').asstring;
            aQuery.Next;
         end;
     aQuery.Close;
end;

function CreateBoutonsOngletEncaissement(aQuery:TMyQuery;asQuery: TMyQuery; aMAGID:Integer;aMemo:TMemo):boolean;
var vID     : Integer;
    vCurAff, i,j :integer;
    vDispoAff  : integer;
    v103_ID    : Integer;
    v103_AFF   : integer;
    vPostes    : TPostes;
    vPlace     : integer;
    vMaxPosButton : Integer;
    v29_Aff    : integer;
    v29_ID     : integer;
    vCaisseButtons : TCaisseButtons;
    vNewPos         : Integer;

begin
    result := false;
    aMemo.Lines.Add(' > Onglet Encaissement');
    vPostes := GetPostes(aQuery,aMAGID);
    // On boucle sur les postes
    for I := low(vPostes) to High(vPostes) do
      begin
        aMemo.Lines.Add('   > Poste : '+vPostes[i].POS_NOM);
        aQuery.Close;
        aQuery.SQL.Clear;
        aQuery.SQL.Add('SELECT BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_ORDREAFF  ');
        aQuery.SQL.Add(' FROM CSHBOUTON                                            ');
        aQuery.SQL.Add(' JOIN K ON K_ID=BTN_ID AND K_ENABLED=1                     ');
        aQuery.SQL.Add(' WHERE BTN_ONGLET=3 AND BTN_POSID=:POSID                   ');
        aQuery.SQL.Add(' ORDER BY  BTN_ORDREAFF                                    ');
        aQuery.ParamByName('POSID').AsInteger := vPostes[i].POS_ID;
        aQuery.Open;
        vPlace    := 1;  // variable de boucle
        vDispoAff := 0;  // 1ère place de Dispo
        v103_AFF  := 0;  // si <>0 c'est la place actuelle du '103'
        v103_ID   := 0;  // si <>0 c'est l'ID (BTN_ID) du bouton '103'
        vCurAff   := 0;
        v29_Aff   := 0;  // Si <>0 c'est la place actuelle du bouton 'suite'
        v29_ID    := 0;  // Si <>0 c'est l'ID (BTN_ID) du bouton 'suite'
        // Analyse déjà présent / 1 place de dispo...
        while not(aQuery.eof) do
          begin
             //---------------------------------------------------------------------
             vCurAff := aQuery.FieldByName('BTN_ORDREAFF').Asinteger;
             // vMaxPosButton c'est la position Max du plus haut bouton
             vMaxPosButton := vCurAff;
             if ((vPlace<vCurAff) and (vDispoAff=0))
               then vDispoAff := vPlace;
             //---------------------------------------------------------------------
             // Info du bouton Demat
             if (aQuery.FieldByName('BTN_TYPE').Asinteger=103)
               then
                  begin
                     // Position Actuelle du 103
                     v103_ID  := aQuery.FieldByName('BTN_ID').Asinteger;
                     v103_AFF := aQuery.FieldByName('BTN_ORDREAFF').Asinteger;
                  end;
             // Infos du Bouton Suite
             if (aQuery.FieldByName('BTN_TYPE').Asinteger=29)
               then
                  begin
                     // Position Actuelle du bouton Suite(29)
                     v29_ID  := aQuery.FieldByName('BTN_ID').Asinteger;
                     v29_AFF := aQuery.FieldByName('BTN_ORDREAFF').Asinteger;
                  end;
             inc(vPlace);
             aQuery.Next;
          end;
        aQuery.Close;

        // Si aucun trou et moins de 16
        if (vDispoAff=0) and (vMaxPosButton<16)
            then vDispoAff:=vMaxPosButton+1;

        // -----------------------------
        // Voici maintenant la Règle :
        // Si pas présent (alors v103_AFF=0 et v103_ID=0)
        // création du Bouton à la place la plus "petite" '15' (max)
        if (v103_ID=0) then
          begin
              // une place en dessous de 16
              if ((vDispoAff>0) and (vDispoAff<=16))   // en effet pas de place de dispo signifie vDispoAff=0
                then
                   begin
                      // On crée en Position vDispoAff
                      // Création du Bouton
                      aQuery.SQL.Clear;
                      aQuery.SQL.Add('SELECT ID FROM PR_NEWK(:TABLE)');
                      aQuery.ParamByName('TABLE').asstring := 'CSHBOUTON';
                      aQuery.Open();
                      if aQuery.RecordCount=1 then
                        begin
                          vID:=aQuery.FieldByName('ID').Asinteger;
                       end;
                      aQuery.Close;
                      aQuery.SQL.Clear;
                      aQuery.SQL.Add('INSERT INTO CSHBOUTON (BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_COULEUR, BTN_ICONE,   ');
                      aQuery.SQL.Add(' BTN_RACCOURCI, BTN_REMISE, BTN_REMAT, BTN_ARFID, BTN_MENID, BTN_ORDREAFF, BTN_ONGLET) ');
                      aQuery.SQL.Add(' VALUES (:ID,:POSID,103,:LIB,0,:ICONE,'''',0,0,0,0,:AFF,3); ');
                      aQuery.ParamByName('ID').Asinteger       := vID;
                      aQuery.ParamByName('POSID').Asinteger    := vPostes[i].POS_ID;
                      aQuery.ParamByName('LIB').Asstring       := 'Chèques'+#13+#10+'Cadeaux';
                      aQuery.ParamByName('ICONE').Asinteger    := 3;
                      aQuery.ParamByName('AFF').Asinteger      := vDispoAff;
                      aQuery.ExecSQL;
                   end;

              {$REGION 'SUITE DEJA EN 16'}
              // Si rien de dispo avant 16 et bouton suite déja présent en 16
              // on déplace pas le 16 (c'est déjà Suite) !!
              // décallé le 15 en 17, le 17 en 18, le 18 en 19 etc...
              If ((vDispoAff=0) or (vDispoAff>16)) and (v29_AFF=16) then
                  begin
                      aSQuery.SQL.Clear;
                      aSQuery.SQL.Clear;
                      aSQuery.SQL.Add('SELECT BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_ORDREAFF  ');
                      aSQuery.SQL.Add(' FROM CSHBOUTON                                            ');
                      aSQuery.SQL.Add(' JOIN K ON K_ID=BTN_ID AND K_ENABLED=1                     ');
                      aSQuery.SQL.Add(' WHERE BTN_ONGLET=3 AND BTN_POSID=:POSID                   ');
                      aSQuery.SQL.Add(' AND BTN_ORDREAFF>=15 and BTN_ORDREAFF<>16                 ');
                      aSQuery.SQL.Add(' ORDER BY BTN_ORDREAFF                                     ');
                      aSQuery.ParamByName('POSID').AsInteger := vPostes[i].POS_ID;
                      aSQuery.open();
                      while not(aSQuery.eof) do
                        begin
                           aQuery.Close;
                           aQuery.SQL.Clear;
                           aQuery.SQL.Add('UPDATE CSHBOUTON SET BTN_ORDREAFF=:ORDREAFF WHERE BTN_ID=:BTNID');
                           aQuery.ParamByName('BTNID').Asinteger    := aSQuery.FieldByName('BTN_ID').AsInteger;
                           if (aSQuery.FieldByName('BTN_ORDREAFF').AsInteger=15)
                             then aQuery.ParamByName('ORDREAFF').Asinteger := 17
                             else aQuery.ParamByName('ORDREAFF').Asinteger := aSQuery.FieldByName('BTN_ORDREAFF').AsInteger+1;
                           aQuery.ExecSQL;

                           //---------------------------------------------------
                           aQuery.Close;
                           aQuery.SQL.Clear;
                           aQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0);');
                           aQuery.ParamByName('ID').AsInteger := aSQuery.FieldByName('BTN_ID').AsInteger;
                           aQuery.ExecSQL;

                           //
                           aSQuery.Next;
                       end;
                      aSQuery.Close;

                      // On crée en Position "15"
                      // Création du Bouton
                      aQuery.SQL.Clear;
                      aQuery.SQL.Add('SELECT ID FROM PR_NEWK(:TABLE)');
                      aQuery.ParamByName('TABLE').asstring := 'CSHBOUTON';
                      aQuery.Open();
                      if aQuery.RecordCount=1 then
                        begin
                          vID:=aQuery.FieldByName('ID').Asinteger;
                       end;
                      aQuery.Close;
                      aQuery.SQL.Clear;
                      aQuery.SQL.Add('INSERT INTO CSHBOUTON (BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_COULEUR, BTN_ICONE,   ');
                      aQuery.SQL.Add(' BTN_RACCOURCI, BTN_REMISE, BTN_REMAT, BTN_ARFID, BTN_MENID, BTN_ORDREAFF, BTN_ONGLET) ');
                      aQuery.SQL.Add(' VALUES (:ID,:POSID,103,:LIB,0,:ICONE,'''',0,0,0,0,:AFF,3); ');
                      aQuery.ParamByName('ID').Asinteger       := vID;
                      aQuery.ParamByName('POSID').Asinteger    := vPostes[i].POS_ID;
                      aQuery.ParamByName('LIB').Asstring       := 'Chèques'+#13+#10+'Cadeaux';
                      aQuery.ParamByName('ICONE').Asinteger    := 3;
                      aQuery.ParamByName('AFF').Asinteger      := 15;
                      aQuery.ExecSQL;
                  end;
              {$ENDREGION 'SUITE DEJA EN 16'}

              {$REGION 'Pas DE BOUTON SUITE dans les 16 et PAS de Place'}
              // On tous les Boutons >=15 de 2 places vers le BAS
              // On Pose Demat en 15 et suite en 16
              If ((vDispoAff=0) or (vDispoAff>16)) and ((v29_ID=0) or (v29_AFF>16)) then
                begin
                   aSQuery.SQL.Clear;
                   aSQuery.SQL.Clear;
                   aSQuery.SQL.Add('SELECT BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_ORDREAFF  ');
                   aSQuery.SQL.Add(' FROM CSHBOUTON                                            ');
                   aSQuery.SQL.Add(' JOIN K ON K_ID=BTN_ID AND K_ENABLED=1                     ');
                   aSQuery.SQL.Add(' WHERE BTN_ONGLET=3 AND BTN_POSID=:POSID                   ');
                   aSQuery.SQL.Add(' AND BTN_ORDREAFF>=15                                      ');
                   aSQuery.SQL.Add(' ORDER BY BTN_ORDREAFF                                     ');
                   aSQuery.ParamByName('POSID').AsInteger := vPostes[i].POS_ID;
                   aSQuery.open();
                      while not(aSQuery.eof) do
                        begin
                           aQuery.Close;
                           aQuery.SQL.Clear;
                           aQuery.SQL.Add('UPDATE CSHBOUTON SET BTN_ORDREAFF=:ORDREAFF WHERE BTN_ID=:BTNID');
                           aQuery.ParamByName('BTNID').Asinteger    := aSQuery.FieldByName('BTN_ID').AsInteger;
                           aQuery.ParamByName('ORDREAFF').Asinteger := aSQuery.FieldByName('BTN_ORDREAFF').AsInteger+2;
                           aQuery.ExecSQL;
                           //---------------------------------------------------
                           aQuery.Close;
                           aQuery.SQL.Clear;
                           aQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0);');
                           aQuery.ParamByName('ID').AsInteger := aSQuery.FieldByName('BTN_ID').AsInteger;
                           aQuery.ExecSQL;
                           aSQuery.Next;
                       end;
                      aSQuery.Close;

                    // 15 et 16 sont dispo maintenant
                    // On crée en Position "15"
                    // Création du Bouton
                    aQuery.SQL.Clear;
                    aQuery.SQL.Add('SELECT ID FROM PR_NEWK(:TABLE)');
                    aQuery.ParamByName('TABLE').asstring := 'CSHBOUTON';
                    aQuery.Open();
                    if aQuery.RecordCount=1 then
                      begin
                        vID:=aQuery.FieldByName('ID').Asinteger;
                      end;
                    aQuery.Close;
                    aQuery.SQL.Clear;
                    aQuery.SQL.Add('INSERT INTO CSHBOUTON (BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_COULEUR, BTN_ICONE,   ');
                    aQuery.SQL.Add(' BTN_RACCOURCI, BTN_REMISE, BTN_REMAT, BTN_ARFID, BTN_MENID, BTN_ORDREAFF, BTN_ONGLET) ');
                    aQuery.SQL.Add(' VALUES (:ID,:POSID,103,:LIB,0,:ICONE,'''',0,0,0,0,:AFF,3); ');
                    aQuery.ParamByName('ID').Asinteger       := vID;
                    aQuery.ParamByName('POSID').Asinteger    := vPostes[i].POS_ID;
                    aQuery.ParamByName('LIB').Asstring       := 'Chèques'+#13+#10+'Cadeaux';
                    aQuery.ParamByName('ICONE').Asinteger    := 3;
                    aQuery.ParamByName('AFF').Asinteger      := 15;
                    aQuery.ExecSQL;

                    // On crée en Position "16" (Suite)
                    // Création du Bouton
                    aQuery.SQL.Clear;
                    aQuery.SQL.Add('SELECT ID FROM PR_NEWK(:TABLE)');
                    aQuery.ParamByName('TABLE').asstring := 'CSHBOUTON';
                    aQuery.Open();
                    if aQuery.RecordCount=1 then
                      begin
                        vID:=aQuery.FieldByName('ID').Asinteger;
                      end;
                    aQuery.Close;
                    aQuery.SQL.Clear;
                    aQuery.SQL.Add('INSERT INTO CSHBOUTON (BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_COULEUR, BTN_ICONE,   ');
                    aQuery.SQL.Add(' BTN_RACCOURCI, BTN_REMISE, BTN_REMAT, BTN_ARFID, BTN_MENID, BTN_ORDREAFF, BTN_ONGLET) ');
                    aQuery.SQL.Add(' VALUES (:ID,:POSID,29,:LIB,0,:ICONE,'''',0,0,0,0,:AFF,3); ');
                    aQuery.ParamByName('ID').Asinteger       := vID;
                    aQuery.ParamByName('POSID').Asinteger    := vPostes[i].POS_ID;
                    aQuery.ParamByName('LIB').Asstring       := 'Suite des'+#13+#10+'Boutons';
                    aQuery.ParamByName('ICONE').Asinteger    := 44;
                    aQuery.ParamByName('AFF').Asinteger      := 16;
                    aQuery.ExecSQL;

                end;
              {$ENDREGION 'Pas DE BOUTON SUITE dans les 16 et PAS de Place'}
          end
        else
           aMemo.Lines.Add('     Bouton déjà présent ');

        {$REGION 'REARRANGEMENT BOUTONS'}
        aMemo.Lines.Add('   > Réarrangement des boutons / Utilisation de places disponibles');
        aQuery.Close;
        aQuery.SQL.Clear;
        aQuery.SQL.Add('SELECT BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_ORDREAFF  ');
        aQuery.SQL.Add(' FROM CSHBOUTON                                            ');
        aQuery.SQL.Add(' JOIN K ON K_ID=BTN_ID AND K_ENABLED=1                     ');
        aQuery.SQL.Add(' WHERE BTN_ONGLET=3 AND BTN_POSID=:POSID                   ');
        aQuery.SQL.Add(' ORDER BY  BTN_ORDREAFF                                    ');
        aQuery.ParamByName('POSID').AsInteger := vPostes[i].POS_ID;
        aQuery.Open;
        SetLength(vCaisseButtons,0);
        while not(AQuery.eof) do
          begin
            // On liste les places dispo en dessous de 16
            // Mais on ne bouge pas les boutons en dessous de 16
            // en dessous de 16 : ils doivent garder la même place
            j:=Length(vCaisseButtons);
            SetLength(vCaisseButtons,j+1);
            vCaisseButtons[j].ID := aQuery.FieldByName('BTN_ID').AsInteger;
            vCaisseButtons[j].Position := aQuery.FieldByName('BTN_ORDREAFF').AsInteger;
            if vCaisseButtons[j].Position<=16
              then vCaisseButtons[j].NewPosition := vCaisseButtons[j].Position
              else vCaisseButtons[j].NewPosition := 0;
            aQuery.Next;
          end;
        // ==> PositionMini
        // Trouver
        for j := Low(vCaisseButtons) to High(vCaisseButtons) do
          begin
            If (vCaisseButtons[j].NewPosition=0)
              then
                begin
                    vNewPos := FindFreePos(vCaisseButtons);
                    vCaisseButtons[j].Newposition := vNewPos;
                end;
          end;


          // Maintenant le tableau Doit etre mieux
          for j := Low(vCaisseButtons) to High(vCaisseButtons) do
            begin
                // Sécutrité NewPosition '0'
                If (vCaisseButtons[j].Position<>vCaisseButtons[j].NewPosition) and (vCaisseButtons[j].NewPosition<>0)
                  then
                    begin
                        aQuery.Close;
                        aQuery.SQL.Clear;
                        aQuery.SQL.Add('UPDATE CSHBOUTON SET BTN_ORDREAFF=:ORDREAFF WHERE BTN_ID=:BTNID');
                        aQuery.ParamByName('BTNID').Asinteger    := vCaisseButtons[j].ID;
                        aQuery.ParamByName('ORDREAFF').Asinteger := vCaisseButtons[j].NewPosition;
                        aQuery.ExecSQL;

                        //---------------------------------------------------
                        aQuery.Close;
                        aQuery.SQL.Clear;
                        aQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0);');
                        aQuery.ParamByName('ID').AsInteger := vCaisseButtons[j].ID;
                        aQuery.ExecSQL;

                    end;
            end;
        {$ENDREGION 'REARRANGEMENT BOUTONS'}



        {$REGION 'SUPPRESSION BOUTON SUITE SI 16 ou MOINS'}
        // S'il y a moins de 16 boutons (en sens large) on peut supprimer le boutton '29'
        aQuery.Close;
        aQuery.SQL.Clear;
        aQuery.SQL.Add('SELECT BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_ORDREAFF  ');
        aQuery.SQL.Add(' FROM CSHBOUTON                                            ');
        aQuery.SQL.Add(' JOIN K ON K_ID=BTN_ID AND K_ENABLED=1                     ');
        aQuery.SQL.Add(' WHERE BTN_ONGLET=3 AND BTN_POSID=:POSID                   ');
        aQuery.SQL.Add(' ORDER BY  BTN_ORDREAFF                                    ');
        aQuery.ParamByName('POSID').AsInteger := vPostes[i].POS_ID;
        aQuery.Open;
        v29_ID    := 0;  // Si <>0 c'est l'ID (BTN_ID) du bouton 'suite'
        j         := 0;
        while not(AQuery.eof) do
          begin
             if (aQuery.FieldByName('BTN_TYPE').Asinteger=29)
               then
                  begin
                     // Position Actuelle du bouton Suite(29)
                     v29_ID  := aQuery.FieldByName('BTN_ID').Asinteger;
                  end;
             inc(j);
             aQuery.Next;
          end;
        if (j<=16) and (v29_ID<>0)
          then
            begin
              aMemo.Lines.Add(Format(' > Suppression du Bouton Suite car seulement %d boutons',[j]));
              aQuery.Close;
              aQuery.SQL.Clear;
              aQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,1);');
              aQuery.ParamByName('ID').AsInteger := v29_ID;
              aQuery.ExecSQL;
            end;
        {$ENDREGION 'SUPPRESSION BOUTON SUITE SI 16 ou MOINS'}



        {$REGION 'RECOMPACTAGE BOUTONS'}
        // s'il y a moins de 16 boutons il peut encore y avoir des trous
        // du coup on va simuler le réarrangement de l'ecran du paramtrage des boutons
        // il faut aussi voir si on a encore besoin du Bouton "Suite" (29)
        aMemo.Lines.Add('   > Compactage des Boutons');
        aQuery.Close;
        aQuery.SQL.Clear;
        aQuery.SQL.Add('SELECT BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_ORDREAFF  ');
        aQuery.SQL.Add(' FROM CSHBOUTON                                            ');
        aQuery.SQL.Add(' JOIN K ON K_ID=BTN_ID AND K_ENABLED=1                     ');
        aQuery.SQL.Add(' WHERE BTN_ONGLET=3 AND BTN_POSID=:POSID                   ');
        aQuery.SQL.Add(' ORDER BY  BTN_ORDREAFF                                    ');
        aQuery.ParamByName('POSID').AsInteger := vPostes[i].POS_ID;
        aQuery.Open;
        SetLength(vCaisseButtons,0);
        while not(AQuery.eof) do
          begin
            j:=Length(vCaisseButtons);
            SetLength(vCaisseButtons,j+1);
            vCaisseButtons[j].ID := aQuery.FieldByName('BTN_ID').AsInteger;
            vCaisseButtons[j].Position := aQuery.FieldByName('BTN_ORDREAFF').AsInteger;
            vCaisseButtons[j].NewPosition := j+1;
            aQuery.Next;
          end;

        for j := Low(vCaisseButtons) to High(vCaisseButtons) do
            begin
                // Sécutrité NewPosition '0'
                If (vCaisseButtons[j].Position<>vCaisseButtons[j].NewPosition)
                  then
                    begin
                        aQuery.Close;
                        aQuery.SQL.Clear;
                        aQuery.SQL.Add('UPDATE CSHBOUTON SET BTN_ORDREAFF=:ORDREAFF WHERE BTN_ID=:BTNID');
                        aQuery.ParamByName('BTNID').Asinteger    := vCaisseButtons[j].ID;
                        aQuery.ParamByName('ORDREAFF').Asinteger := vCaisseButtons[j].NewPosition;
                        aQuery.ExecSQL;

                        //---------------------------------------------------
                        aQuery.Close;
                        aQuery.SQL.Clear;
                        aQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0);');
                        aQuery.ParamByName('ID').AsInteger := vCaisseButtons[j].ID;
                        aQuery.ExecSQL;

                    end;
            end;


        {$ENDREGION 'RECOMPACTAGE BOUTONS'}





      end;
end;

function FindFreePos(aButtons:TCaisseButtons):integer;
var i,j:integer;
    vIsFree:Boolean;
begin
    Result   := 0;
    for i:=1 to High(aButtons)+1 do
      begin
          vIsFree:=True;
          for j := Low(aButtons) to High(aButtons) do
              begin
                 if (aButtons[j].NewPosition=i)
                   then
                     begin
                         vIsFree:=false;
                         Break;
                     end;
              end;
          if vIsFree
            then
               begin
                  result := i;
                  break;
               end;
      end;
end;

function CreateBoutonsOngletUtilitaires(aQuery:TMyQuery;asQuery: TMyQuery; aMAGID:Integer;aMemo:TMemo):boolean;
var vID     : Integer;
    vCurAff, i :integer;
    vDispoAff  : integer;
    v104_ID    : Integer;
    v104_AFF   : integer;
    vPostes    : TPostes;
    vPlace     : integer;
    vMaxPosButton : Integer;
    v29_Aff    : integer;
    v29_ID     : integer;

begin
    result := false;
    aMemo.Lines.Add(' > Onglet Utilitaires');
    vPostes := GetPostes(aQuery,aMAGID);

    // On boucle sur les postes
    for I := low(vPostes) to High(vPostes) do
      begin
        aMemo.Lines.Add('   > Poste : '+vPostes[i].POS_NOM);
        aQuery.Close;
        aQuery.SQL.Clear;
        aQuery.SQL.Add('SELECT BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_ORDREAFF  ');
        aQuery.SQL.Add(' FROM CSHBOUTON                                            ');
        aQuery.SQL.Add(' JOIN K ON K_ID=BTN_ID AND K_ENABLED=1                     ');
        aQuery.SQL.Add(' WHERE BTN_ONGLET=4 AND BTN_POSID=:POSID                   ');
        aQuery.SQL.Add(' ORDER BY  BTN_ORDREAFF                                    ');
        aQuery.ParamByName('POSID').AsInteger := vPostes[i].POS_ID;
        aQuery.Open;
        vPlace    := 1;  // variable de boucle
        vDispoAff := 0;  // 1ère place de Dispo
        v104_AFF  := 0;  // si <>0 c'est la place actuelle du '103'
        v104_ID   := 0;  // si <>0 c'est l'ID (BTN_ID) du bouton '103'
        vCurAff   := 0;
        v29_Aff   := 0;  // Si <>0 c'est la place actuelle du bouton 'suite'
        v29_ID    := 0;  // Si <>0 c'est l'ID (BTN_ID) du bouton 'suite'
        // Analyse déjà présent / 1 place de dispo...
        while not(aQuery.eof) do
          begin
             //---------------------------------------------------------------------
             vCurAff := aQuery.FieldByName('BTN_ORDREAFF').Asinteger;
             // vMaxPosButton c'est la position Max du plus haut bouton
             vMaxPosButton := vCurAff;
             if ((vPlace<vCurAff) and (vDispoAff=0))
               then vDispoAff := vPlace;
             //---------------------------------------------------------------------
             // Info du bouton Demat
             if (aQuery.FieldByName('BTN_TYPE').Asinteger=104)
               then
                  begin
                     // Position Actuelle du 103
                     v104_ID  := aQuery.FieldByName('BTN_ID').Asinteger;
                     v104_AFF := aQuery.FieldByName('BTN_ORDREAFF').Asinteger;
                  end;
             // Infos du Bouton Suite
             if (aQuery.FieldByName('BTN_TYPE').Asinteger=29)
               then
                  begin
                     // Position Actuelle du bouton Suite(29)
                     v29_ID  := aQuery.FieldByName('BTN_ID').Asinteger;
                     v29_AFF := aQuery.FieldByName('BTN_ORDREAFF').Asinteger;
                  end;
             inc(vPlace);
             aQuery.Next;
          end;
        aQuery.Close;

        // Si aucun trou et moins de 16
        if (vDispoAff=0) and (vMaxPosButton<16)
            then vDispoAff:=vMaxPosButton+1;

        // -----------------------------
        // Voici maintenant la Règle :
        // Si pas présent (alors v104_AFF=0 et v104_ID=0)
        // création du Bouton à la place la plus "petite" '15' (max)
        if (v104_ID=0) then
          begin
              // une place en dessous de 16
              if ((vDispoAff>0) and (vDispoAff<=16))   // en effet pas de place de dispo signifie vDispoAff=0
                then
                   begin
                      // On crée en Position vDispoAff
                      // Création du Bouton
                      aQuery.SQL.Clear;
                      aQuery.SQL.Add('SELECT ID FROM PR_NEWK(:TABLE)');
                      aQuery.ParamByName('TABLE').asstring := 'CSHBOUTON';
                      aQuery.Open();
                      if aQuery.RecordCount=1 then
                        begin
                          vID:=aQuery.FieldByName('ID').Asinteger;
                       end;
                      aQuery.Close;
                      aQuery.SQL.Clear;
                      aQuery.SQL.Add('INSERT INTO CSHBOUTON (BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_COULEUR, BTN_ICONE,   ');
                      aQuery.SQL.Add(' BTN_RACCOURCI, BTN_REMISE, BTN_REMAT, BTN_ARFID, BTN_MENID, BTN_ORDREAFF, BTN_ONGLET) ');
                      aQuery.SQL.Add(' VALUES (:ID,:POSID,104,:LIB,0,:ICONE,'''',0,0,0,0,:AFF,4); ');
                      aQuery.ParamByName('ID').Asinteger       := vID;
                      aQuery.ParamByName('POSID').Asinteger    := vPostes[i].POS_ID;
                      aQuery.ParamByName('LIB').Asstring       := 'Liste CHQ'+#13+#10+'cadeaux';
                      aQuery.ParamByName('ICONE').Asinteger    := 3;
                      aQuery.ParamByName('AFF').Asinteger      := vDispoAff;
                      aQuery.ExecSQL;
                   end;

              {$REGION 'SUITE DEJA EN 16'}
              // Si rien de dispo avant 16 et bouton suite déja présent en 16
              // on déplace pas le 16 (c'est déjà Suite) !!
              // décallé le 15 en 17, le 17 en 18, le 18 en 19 etc...
              If ((vDispoAff=0) or (vDispoAff>16)) and (v29_AFF=16) then
                  begin
                      aSQuery.SQL.Clear;
                      aSQuery.SQL.Clear;
                      aSQuery.SQL.Add('SELECT BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_ORDREAFF  ');
                      aSQuery.SQL.Add(' FROM CSHBOUTON                                            ');
                      aSQuery.SQL.Add(' JOIN K ON K_ID=BTN_ID AND K_ENABLED=1                     ');
                      aSQuery.SQL.Add(' WHERE BTN_ONGLET=4 AND BTN_POSID=:POSID                   ');
                      aSQuery.SQL.Add(' AND BTN_ORDREAFF>=15 and BTN_ORDREAFF<>16                 ');
                      aSQuery.SQL.Add(' ORDER BY BTN_ORDREAFF                                     ');
                      aSQuery.ParamByName('POSID').AsInteger := vPostes[i].POS_ID;
                      aSQuery.open();
                      while not(aSQuery.eof) do
                        begin
                           aQuery.Close;
                           aQuery.SQL.Clear;
                           aQuery.SQL.Add('UPDATE CSHBOUTON SET BTN_ORDREAFF=:ORDREAFF WHERE BTN_ID=:BTNID');
                           aQuery.ParamByName('BTNID').Asinteger    := aSQuery.FieldByName('BTN_ID').AsInteger;
                           if (aSQuery.FieldByName('BTN_ORDREAFF').AsInteger=15)
                             then aQuery.ParamByName('ORDREAFF').Asinteger := 17
                             else aQuery.ParamByName('ORDREAFF').Asinteger := aSQuery.FieldByName('BTN_ORDREAFF').AsInteger+1;
                           aQuery.ExecSQL;

                           //---------------------------------------------------
                           aQuery.Close;
                           aQuery.SQL.Clear;
                           aQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0);');
                           aQuery.ParamByName('ID').AsInteger := aSQuery.FieldByName('BTN_ID').AsInteger;
                           aQuery.ExecSQL;

                           //
                           aSQuery.Next;
                       end;
                      aSQuery.Close;

                      // On crée en Position "15"
                      // Création du Bouton
                      aQuery.SQL.Clear;
                      aQuery.SQL.Add('SELECT ID FROM PR_NEWK(:TABLE)');
                      aQuery.ParamByName('TABLE').asstring := 'CSHBOUTON';
                      aQuery.Open();
                      if aQuery.RecordCount=1 then
                        begin
                          vID:=aQuery.FieldByName('ID').Asinteger;
                       end;
                      aQuery.Close;
                      aQuery.SQL.Clear;
                      aQuery.SQL.Add('INSERT INTO CSHBOUTON (BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_COULEUR, BTN_ICONE,   ');
                      aQuery.SQL.Add(' BTN_RACCOURCI, BTN_REMISE, BTN_REMAT, BTN_ARFID, BTN_MENID, BTN_ORDREAFF, BTN_ONGLET) ');
                      aQuery.SQL.Add(' VALUES (:ID,:POSID,104,:LIB,0,:ICONE,'''',0,0,0,0,:AFF,4); ');
                      aQuery.ParamByName('ID').Asinteger       := vID;
                      aQuery.ParamByName('POSID').Asinteger    := vPostes[i].POS_ID;
                      aQuery.ParamByName('LIB').Asstring       := 'Liste CHQ'+#13+#10+'cadeaux';
                      aQuery.ParamByName('ICONE').Asinteger    := 3;
                      aQuery.ParamByName('AFF').Asinteger      := 15;
                      aQuery.ExecSQL;
                  end;
              {$ENDREGION 'SUITE DEJA EN 16'}

              {$REGION 'Pas DE BOUTON SUITE dans les 16 et PAS de Place'}
              // On pousse les Boutons >=15 de 2 places vers le BAS
              // On Pose Demat en 15 et suite en 16
              If ((vDispoAff=0) or (vDispoAff>16)) and ((v29_ID=0) or (v29_AFF>16)) then
                begin
                   aSQuery.SQL.Clear;
                   aSQuery.SQL.Clear;
                   aSQuery.SQL.Add('SELECT BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_ORDREAFF  ');
                   aSQuery.SQL.Add(' FROM CSHBOUTON                                            ');
                   aSQuery.SQL.Add(' JOIN K ON K_ID=BTN_ID AND K_ENABLED=1                     ');
                   aSQuery.SQL.Add(' WHERE BTN_ONGLET=4 AND BTN_POSID=:POSID                   ');
                   aSQuery.SQL.Add(' AND BTN_ORDREAFF>=15                                      ');
                   aSQuery.SQL.Add(' ORDER BY BTN_ORDREAFF                                     ');
                   aSQuery.ParamByName('POSID').AsInteger := vPostes[i].POS_ID;
                   aSQuery.open();
                      while not(aSQuery.eof) do
                        begin
                           aQuery.Close;
                           aQuery.SQL.Clear;
                           aQuery.SQL.Add('UPDATE CSHBOUTON SET BTN_ORDREAFF=:ORDREAFF WHERE BTN_ID=:BTNID');
                           aQuery.ParamByName('BTNID').Asinteger    := aSQuery.FieldByName('BTN_ID').AsInteger;
                           aQuery.ParamByName('ORDREAFF').Asinteger := aSQuery.FieldByName('BTN_ORDREAFF').AsInteger+2;
                           aQuery.ExecSQL;
                           //---------------------------------------------------
                           aQuery.Close;
                           aQuery.SQL.Clear;
                           aQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0);');
                           aQuery.ParamByName('ID').AsInteger := aSQuery.FieldByName('BTN_ID').AsInteger;
                           aQuery.ExecSQL;
                           aSQuery.Next;
                       end;
                      aSQuery.Close;

                    // 15 et 16 sont dispo maintenant
                    // On crée en Position "15"
                    // Création du Bouton
                    aQuery.SQL.Clear;
                    aQuery.SQL.Add('SELECT ID FROM PR_NEWK(:TABLE)');
                    aQuery.ParamByName('TABLE').asstring := 'CSHBOUTON';
                    aQuery.Open();
                    if aQuery.RecordCount=1 then
                      begin
                        vID:=aQuery.FieldByName('ID').Asinteger;
                      end;
                    aQuery.Close;
                    aQuery.SQL.Clear;
                    aQuery.SQL.Add('INSERT INTO CSHBOUTON (BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_COULEUR, BTN_ICONE,   ');
                    aQuery.SQL.Add(' BTN_RACCOURCI, BTN_REMISE, BTN_REMAT, BTN_ARFID, BTN_MENID, BTN_ORDREAFF, BTN_ONGLET) ');
                    aQuery.SQL.Add(' VALUES (:ID,:POSID,104,:LIB,0,:ICONE,'''',0,0,0,0,:AFF,4); ');
                    aQuery.ParamByName('ID').Asinteger       := vID;
                    aQuery.ParamByName('POSID').Asinteger    := vPostes[i].POS_ID;
                    aQuery.ParamByName('LIB').Asstring       := 'Liste CHQ'+#13+#10+'cadeaux';
                    aQuery.ParamByName('ICONE').Asinteger    := 3;
                    aQuery.ParamByName('AFF').Asinteger      := 15;
                    aQuery.ExecSQL;

                    // On crée en Position "16" (Suite)
                    // Création du Bouton
                    aQuery.SQL.Clear;
                    aQuery.SQL.Add('SELECT ID FROM PR_NEWK(:TABLE)');
                    aQuery.ParamByName('TABLE').asstring := 'CSHBOUTON';
                    aQuery.Open();
                    if aQuery.RecordCount=1 then
                      begin
                        vID:=aQuery.FieldByName('ID').Asinteger;
                      end;
                    aQuery.Close;
                    aQuery.SQL.Clear;
                    aQuery.SQL.Add('INSERT INTO CSHBOUTON (BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_COULEUR, BTN_ICONE,   ');
                    aQuery.SQL.Add(' BTN_RACCOURCI, BTN_REMISE, BTN_REMAT, BTN_ARFID, BTN_MENID, BTN_ORDREAFF, BTN_ONGLET) ');
                    aQuery.SQL.Add(' VALUES (:ID,:POSID,29,:LIB,0,:ICONE,'''',0,0,0,0,:AFF,4); ');
                    aQuery.ParamByName('ID').Asinteger       := vID;
                    aQuery.ParamByName('POSID').Asinteger    := vPostes[i].POS_ID;
                    aQuery.ParamByName('LIB').Asstring       := 'Suite des'+#13+#10+'Boutons';
                    aQuery.ParamByName('ICONE').Asinteger    := 44;
                    aQuery.ParamByName('AFF').Asinteger      := 16;
                    aQuery.ExecSQL;

                   //
                end;
              {$ENDREGION 'Pas DE BOUTON SUITE dans les 16 et PAS de Place'}
          end
        else
        aMemo.Lines.Add('   Bouton déjà présent');
      end;
end;

function SetParams(Server, FileName, UserName, Password : string; Port: integer;aParamsMag:TParamsMag;aMemo:TMemo;aMags:TMagasins):Boolean;
var vCon : TMyConnection;
    vTrn : TMyTransaction;
    vQuery,vS1Query,vS2Query : TMyQuery;
    i,j :integer;
    vMenNOM : string;
    vMags   : TMagasins;
    vEncs : TEncaissements;
    vID     : integer;
    vMENID  : integer;
    vSOCID  : integer;
    vBQEID  : integer;
    vCFFID  : integer;
    vLog    : string;
    bIntersport: Boolean;
    iModuleIntersport: Integer;
    vDO_NOTDELETE : string;

begin
  result := false;
  // Tous les Magasins de la demat
  vMags  := aMags; // GetDBMagasinDemat(Server,FileName,UserName,Password,Port);





  vEncs  := GetEncaissements;
  try
    try
      vCon := GetNewConnexion(Server, FileName, UserName, Password, Port, false);
      vTrn := GetNewTransaction(vCon,false);
      vCon.Open();
      if vCon.Connected then
      begin
        try
          vQuery  := GetNewQuery(vCon,vTrn);
          vS1Query := GetNewQuery(vCon,vTrn);
          vS2Query := GetNewQuery(vCon,vTrn);
          vTrn.StartTransaction;
          try
            // -----------------------------------------------------------------------------------
            // Vérification d'appartenance du magasin à la centrale Intersport                    
            // La dématérialisation fonctionnant pour une centrale, si au moins un magasin
            // est reconnu "Intersport", alors tous les magasins seront traités comme "Intersport"
            // -----------------------------------------------------------------------------------
            bIntersport := False;
            i := Low(vMags);
            while (not bIntersport) and (i <= High(vMags))  do
            begin
              iModuleIntersport := GetResultSQL(vQuery, 'SELECT COUNT(*) FROM UILGRPGINKOIAMAG ' + 
                                                          'JOIN K KUGM ON (KUGM.K_ID = UGM_ID AND KUGM.K_ENABLED = 1) ' + 
                                                          'JOIN UILGRPGINKOIA ON (UGG_ID = UGM_UGGID) ' + 
                                                          'JOIN K KUGG ON (KUGG.K_ID = UGG_ID AND KUGG.K_ENABLED = 1) ' +
                                                         'WHERE UPPER(UGG_NOM) LIKE ''%INTERSPORT%'' AND UGM_MAGID = ' + IntToStr(vMags[i].MAG_ID));
              if (iModuleIntersport > 0) then
              begin
                // Pourquoi mettre le MAGNOM dans le Log ? ==> Non ca passpour tous les mags choisis et ISF
                // aMemo.Lines.Add(Format(CST_INFO, ['Attribution forcée de l''équivalent FIDBOX Intersport activée pour ' + vMags[i].MAG_NOM]));
                aMemo.Lines.Add(Format(CST_INFO, ['Attribution forcée de l''équivalent FIDBOX Intersport']));
                bIntersport := True;
              end;
              Inc(i);
            end;
            // -----------------------------------------------------------------------------------
                     
            for i := Low(vMags) to High(vMags) do
              begin
                aMemo.Lines.Add('Magasin : '+vMags[i].MAG_Nom);
                vSOCID := GetResultSQL(vQuery,'SELECT MAG_SOCID FROM GENMAGASIN where MAG_ID='+IntTOStr(vMags[i].MAG_ID));
                vBQEID := GetResultSQL(vQuery,'select max(BQE_ID) from CSHBANQUE join K on (K_ID = BQE_ID AND K_ENABLED = 1) where BQE_ID<>0 and BQE_SOCID='+IntTOStr(vSOCID));
                vCFFID := GetResultSQL(vQuery,'select max(CFF_ID) from CSHCOFFRE join K on (K_ID = CFF_ID and K_ENABLED = 1) where CFF_MAGID='+IntTOStr(vMags[i].MAG_ID));
                vLog := '';
                {$REGION 'DEFAUT'}
                // Nouvelle methode externe
                vMENID := CreateModeEnc(vQuery,vMags[i].MAG_ID,aParamsMag.Defaut,vSOCID,vBQEID,vCFFID,aMemo);
                vID := 0;
                // Association du Mode d'encaissement
                vQuery.SQL.Clear;
                vQuery.SQL.Add('SELECT * FROM GENPARAM                         ');
                vQuery.SQL.Add(' JOIN K ON K_ID=PRM_ID AND K_ENABLED=1         ');
                vQuery.SQL.Add(' WHERE PRM_CODE=133 AND PRM_TYPE=3 AND PRM_MAGID=:MAGID ');
                vQuery.ParamByName('MAGID').AsInteger := vMags[i].MAG_ID;
                vQuery.Open;
                if vQuery.RecordCount=1 then
                  begin
                      vID:=vQuery.FieldByName('PRM_ID').Asinteger;
                  end;
                vQuery.Close;
                if vID<>0 then
                  begin
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add('UPDATE GENPARAM SET PRM_INTEGER=:MENID WHERE PRM_ID=:PRMID');
                    vQuery.ParamByName('MENID').AsInteger := vMENID;
                    vQuery.ParamByName('PRMID').AsInteger := vID;
                    vQuery.ExecSQL;

                    vQuery.Close;
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0)');
                    vQuery.ParamByName('ID').AsInteger := vID;
                    vQuery.ExecSQL;
                    aMemo.Lines.Add(Format(CST_INFO,['mise à jour du Paramètre "Encaissement pas défaut" (TYPE=133/CODE=3)']));
                  end
                else
                  aMemo.Lines.Add(Format(CST_ERROR,['pas de paramètre "Encaissement pas défaut" (TYPE=133/CODE=3)']));

                vQuery.Close;
                {$ENDREGION 'DEFAUT'}

                {$REGION 'TROP_PERCU'}
                vMENID := CreateModeEnc(vQuery,vMags[i].MAG_ID, aParamsMag.TROP_PERCU,vSOCID,vBQEID,vCFFID,aMemo);
                vID := 0;
                // Association du Mode d'encaissement
                vQuery.SQL.Clear;
                vQuery.SQL.Add('SELECT * FROM GENPARAM                         ');
                vQuery.SQL.Add(' JOIN K ON K_ID=PRM_ID AND K_ENABLED=1         ');
                vQuery.SQL.Add(' WHERE PRM_CODE=135 AND PRM_TYPE=3 AND PRM_MAGID=:MAGID ');
                vQuery.ParamByName('MAGID').AsInteger := vMags[i].MAG_ID;
                vQuery.Open;
                if vQuery.RecordCount=1 then
                  begin
                      vID:=vQuery.FieldByName('PRM_ID').Asinteger;
                  end;
                vQuery.Close;
                if vID<>0 then
                  begin
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add('UPDATE GENPARAM SET PRM_INTEGER=:MENID WHERE PRM_ID=:PRMID');
                    vQuery.ParamByName('MENID').AsInteger := vMENID;
                    vQuery.ParamByName('PRMID').AsInteger := vID;
                    vQuery.ExecSQL;

                    vQuery.Close;
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0)');
                    vQuery.ParamByName('ID').AsInteger := vID;
                    vQuery.ExecSQL;
                    aMemo.Lines.Add(Format(CST_INFO,['mise à jour du Paramètre "Mode d''encais. du trop perçu" (TYPE=135/CODE=3)']));
                  end
                else
                   aMemo.Lines.Add(Format(CST_ERROR,['pas de paramètre "Mode d''encais. du trop perçu" (TYPE=135/CODE=3)']));

                vQuery.Close;
                {$ENDREGION 'TROP_PERCU'}

                {$REGION 'URL'}
                vID := 0;
                vQuery.close;
                vQuery.SQL.Clear;
                vQuery.SQL.Add('SELECT * FROM GENPARAM                         ');
                vQuery.SQL.Add(' JOIN K ON K_ID=PRM_ID AND K_ENABLED=1         ');
                vQuery.SQL.Add(' WHERE PRM_CODE=131 AND PRM_TYPE=3 AND PRM_MAGID=:MAGID ');
                vQuery.ParamByName('MAGID').AsInteger := vMags[i].MAG_ID;
                vQuery.Open;
                if vQuery.RecordCount=1 then
                  begin
                      vID:=vQuery.FieldByName('PRM_ID').Asinteger;
                  end;
                vQuery.Close;
                if vID<>0 then
                  begin
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add('UPDATE GENPARAM SET PRM_STRING=:URL WHERE PRM_ID=:PRMID');
                    vQuery.ParamByName('URL').AsString   := aParamsMag.URL;
                    vQuery.ParamByName('PRMID').AsInteger := vID;
                    vQuery.ExecSQL;

                    vQuery.Close;
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0)');
                    vQuery.ParamByName('ID').AsInteger := vID;
                    vQuery.ExecSQL;
                    aMemo.Lines.Add(Format(CST_INFO,['mise à jour du Paramètre "URL d''accès au web service" (TYPE=131/CODE=3)']));
                  end
                  else
                    aMemo.Lines.Add(Format(CST_ERROR,['pas de Paramètre "URL d''accès au web service" (TYPE=131/CODE=3)]']));
                vQuery.Close;
                {$ENDREGION 'URL'}

                {$REGION 'GUID'}
                vID := 0;
                vQuery.SQL.Clear;
                vQuery.SQL.Add('SELECT * FROM GENPARAM                         ');
                vQuery.SQL.Add(' JOIN K ON K_ID=PRM_ID AND K_ENABLED=1         ');
                vQuery.SQL.Add(' WHERE PRM_CODE=132 AND PRM_TYPE=3 AND PRM_MAGID=:MAGID ');
                vQuery.ParamByName('MAGID').AsInteger := vMags[i].MAG_ID;
                vQuery.Open;
                if vQuery.RecordCount=1 then
                  begin
                      vID:=vQuery.FieldByName('PRM_ID').Asinteger;
                  end;
                vQuery.Close;
                if vID<>0 then
                  begin
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add('UPDATE GENPARAM SET PRM_STRING=:GUID WHERE PRM_ID=:PRMID');
                    vQuery.ParamByName('GUID').AsString   := aParamsMag.GUID;
                    vQuery.ParamByName('PRMID').AsInteger := vID;
                    vQuery.ExecSQL;

                    vQuery.Close;
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0)');
                    vQuery.ParamByName('ID').AsInteger := vID;
                    vQuery.ExecSQL;
                    aMemo.Lines.Add(Format(CST_INFO,['mise à jour du Paramètre "GUID" (TYPE=132/CODE=3)']));
                  end
                  else
                    aMemo.Lines.Add(Format(CST_ERROR,['pas de Paramètre "GUID" (TYPE=132/CODE=3)']));

                vQuery.Close;
                {$ENDREGION 'GUID'}

                {$REGION 'DELAI'}
                vID := 0;
                vQuery.SQL.Clear;
                vQuery.SQL.Add('SELECT * FROM GENPARAM                         ');
                vQuery.SQL.Add(' JOIN K ON K_ID=PRM_ID AND K_ENABLED=1         ');
                vQuery.SQL.Add(' WHERE PRM_CODE=134 AND PRM_TYPE=3 AND PRM_MAGID=:MAGID ');
                vQuery.ParamByName('MAGID').AsInteger := vMags[i].MAG_ID;
                vQuery.Open;
                if vQuery.RecordCount=1 then
                  begin
                      vID:=vQuery.FieldByName('PRM_ID').Asinteger;
                  end;
                vQuery.Close;
                if vID<>0 then
                  begin
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add('UPDATE GENPARAM SET PRM_INTEGER=:DELAI WHERE PRM_ID=:PRMID');
                    vQuery.ParamByName('DELAI').AsInteger := aParamsMag.DELAI;
                    vQuery.ParamByName('PRMID').AsInteger := vID;
                    vQuery.ExecSQL;

                    vQuery.Close;
                    vQuery.SQL.Clear;
                    vQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0)');
                    vQuery.ParamByName('ID').AsInteger := vID;
                    vQuery.ExecSQL;

                    aMemo.Lines.Add(Format(CST_INFO,['mise à jour du Paramètre "DELAI" (TYPE=134/CODE=3)']));

                  end
                  else
                    aMemo.Lines.Add(Format(CST_INFO,['pas de Paramètre "DELAI" (TYPE=134/CODE=3)']));
                vQuery.Close;
                {$ENDREGION 'DELAI'}

                {$REGION 'Désactivation des anciens Modes d'encaissement'}

                vS1Query.Close;
                vS1Query.SQL.Clear;
                vS1Query.SQL.Add('SELECT MEN_ID, MEN_NOM FROM CSHMODEENC          ');
                vS1Query.SQL.Add(' JOIN K ON (K_ID = MEN_ID AND K_ENABLED = 1)    ');
                vS1Query.SQL.Add(' WHERE MEN_IDENT IN (''BEST'',''BON KYR.'',''CADHOC'', ');
                vS1Query.SQL.Add(' ''CHQ CADO'',''HAVAS'',''KADEOS'', ''SHOP. PASS'',''TIR GRP'',''TK HORI'',''TK INF'') ');
                vS1Query.SQL.Add('  AND MEN_MAGID=:MAGID ');
                // Suie au mail d'anthony, il ne faut pas supprimer le bouton "HAVAS" chez ISF
                // Création de la chaine de ne pas supprimer "les mode d'encaissements"  et des boutons du coup...
                // qui ne sont pas parametrer dans la config (le MEN_NOM est à vide)
                // attention il faut faire correspondre le NOM (parametrage) et le MEN_IDENT (base)
                for j := Low(aParamsMag.Emetteurs) to High(aParamsMag.Emetteurs) do
                  begin
                    If aParamsMag.Emetteurs[j].MEN_NOM=''
                      then
                         begin
                             if (aParamsMag.Emetteurs[j].CKE_LIBELLE='BEST ESSENTIEL')
                                then vS1Query.SQL.Add(' AND MEN_IDENT<>''BEST'' ');

                             if (aParamsMag.Emetteurs[j].CKE_LIBELLE='TIR GROUPE LIBERTE')
                                then vS1Query.SQL.Add(' AND MEN_IDENT<>''TIR GRP'' ');

                             if (aParamsMag.Emetteurs[j].CKE_LIBELLE='SHOPPING PASS')
                                then vS1Query.SQL.Add(' AND MEN_IDENT<>''SHOP. PASS'' ');

                             if (aParamsMag.Emetteurs[j].CKE_LIBELLE='CADO CHEQUE')
                                then vS1Query.SQL.Add(' AND MEN_IDENT<>''CHQ CADO'' ');

                             if (aParamsMag.Emetteurs[j].CKE_LIBELLE='KADEOS')
                                then vS1Query.SQL.Add(' AND MEN_IDENT NOT IN (''KADEOS'',''TK HORI'',''TK INF'') ');

                             if (aParamsMag.Emetteurs[j].CKE_LIBELLE='KYRIELLE')
                                then vS1Query.SQL.Add(' AND MEN_IDENT<>''BON KYR.'' ');

                             if (aParamsMag.Emetteurs[j].CKE_LIBELLE='CADHOC')
                                then vS1Query.SQL.Add(' AND MEN_IDENT<>''CADHOC'' ');

                             if (aParamsMag.Emetteurs[j].CKE_LIBELLE='HAVAS')
                                then vS1Query.SQL.Add(' AND MEN_IDENT<>''HAVAS'' ');

                         end;
                  end;
                //  AND MEN_NOM NOT LIKE ''NE PLUS UTILISER - %'' ');
                vS1Query.ParamByName('MAGID').AsInteger := vMags[i].MAG_ID;
                vS1Query.open;
                while not(vS1Query.Eof) do
                  begin
                     vMENID  := vS1Query.FieldByName('MEN_ID').Asinteger;
                     // si ils sont déjà en "NE PLUS UTLISER on fait rien au debut on désactive juste les boutons
                     // Ca arrive quand on réinit les boutons en caisse
                     if Pos('NE PLUS UTILISER - ',vS1Query.FieldByName('MEN_NOM').AsString)=0
                      then
                        begin
                           // ajout du "NE PLUS UTLISER"
                           vMenNOM := 'NE PLUS UTILISER - ' +vS1Query.FieldByName('MEN_NOM').AsString;
                           vMenNOM := Copy(vMenNOM, 1, 64);
                           vQuery.Close;
                           vQuery.SQL.Clear;
                           vQuery.SQL.Add('UPDATE CSHMODEENC SET MEN_NOM=:NOM WHERE MEN_ID=:MENID');
                           vQuery.ParamByName('NOM').AsString  := vMenNOM;
                           vQuery.ParamByName('MENID').AsInteger := vMENID;
                           vQuery.ExecSQL;

                           vQuery.Close;
                           vQuery.SQL.Clear;
                           vQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0);');  //  reste actif
                           vQuery.ParamByName('ID').AsInteger := vMENID;
                           vQuery.ExecSQL;
                        end;

                     // Suppression des boutons liés
                     vS2Query.Close;
                     vS2Query.SQL.Clear;
                     vS2Query.SQL.Add('SELECT BTN_ID FROM CSHBOUTON            ');
                     vS2Query.SQL.Add('  JOIN K ON K_ID=BTN_ID AND K_ENABLED=1 ');
                     vS2Query.SQL.Add('  JOIN GENPOSTE ON POS_ID=BTN_POSID AND POS_MAGID=:MAGID ');
                     vS2Query.SQL.Add('  JOIN K ON K_ID=POS_ID AND K_ENABLED=1 ');
                     vS2Query.SQL.Add('  WHERE BTN_MENID=:MENID                ');
                     vS2Query.ParamByName('MENID').AsInteger := vMENID;
                     vS2Query.ParamByName('MAGID').AsInteger := vMags[i].MAG_ID;
                     vS2Query.open;
                     While not(vS2Query.eof)  do
                       begin
                         vQuery.Close;
                         vQuery.SQL.Clear;
                         vQuery.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:BTNID,1);');  // désactive
                         vQuery.ParamByName('BTNID').AsInteger := vS2Query.FieldByName('BTN_ID').asinteger;
                         vQuery.ExecSQL;
                         vS2Query.next;
                       end;
                      vS1Query.Next;
                  end;
                {$ENDREGION 'Désactivation des anciens Modes d'encaissement'}

                {$REGION 'Création de tous les Modes d''encaissement'}
                // création du tableau "modes d'encaissement" (uniquement ceux défini par la centrale)
                // c'est donc un parcours de aParamsMag.Emetteurs
                For j := Low(aParamsMag.Emetteurs) to High(aParamsMag.Emetteurs) do
                  begin
                      // Sauf le vide oui le 1er est a vide pour pouvoir mettre "vide" dans la combobox
                      if aParamsMag.Emetteurs[j].MEN_NOM<>''
                        then
                          begin
						 	CreateModeEnc(vQuery,vMags[i].MAG_ID,aParamsMag.Emetteurs[j].MEN_NOM,vSOCID,vBQEID,vCFFID,aMemo, bIntersport);
                          end;
                  end;
                {$ENDREGION 'Création de tous les Modes d''encaissement'}

                // Update de CSHEMTTEURENC en fonction du Tableau de la centrale
                {$REGION 'Mise à jour de CSHEMETTEURENC'}
                for j := Low(aParamsMag.Emetteurs) to High(aParamsMag.Emetteurs) do
                  begin
                    // faire une méthode externe
                    // On lui balance l'emetteur... il update
                    // TODO in Le MAG , l'emetteur concerné, il a aussi le Mode d'encaissement sous forme Texte
                    SetEmetteurModeEnc(vQuery,vMags[i].MAG_ID,aParamsMag.Emetteurs[j]);
                  end;
                {$ENDREGION 'Mise à jour de CSHEMETTEURENC'}

                {$REGION 'Mise à jour de CSHEMETEURENCLINK'}
                for j := Low(aParamsMag.Titres) to High(aParamsMag.Titres) do
                  begin
                    // faire une méthode externe
                    // On lui balance l'emetteur... il update
                    // TODO in Le MAG , l'emetteur concerné, il a aussi le Mode d'encaissement sous forme Texte
                    SetEmetteurTitreLink(vQuery,vMags[i].MAG_ID,aParamsMag.Titres[j]);
                  end;
                {$ENDREGION 'Mise à jour de CSHEMETEURENCLINK'}

                // Création des Boutons sur les caisses si présents on ne crée rien
                CreateBoutonsOngletEncaissement(vQuery,vS1Query,vMags[i].MAG_ID,aMemo);

                CreateBoutonsOngletUtilitaires(vQuery,vS1Query,vMags[i].MAG_ID,aMemo);

              end;
            vTrn.Commit;
            result:=true;
          finally
            vQuery.Close();
            vS1Query.Close();
            vS2Query.Close();
          end;
        finally
          FreeAndNil(vQuery);
          FreeAndNil(vS1Query);
          FreeAndNil(vS2Query);
        end;
      end;
    finally
      FreeAndNil(vTrn);
      FreeAndNil(vCon);
    end;
  except
    on e : exception do
    begin
      result:=false;
      aMemo.Lines.Add('ERREUR : ' + e.ClassName + ' - ' + e.Message);
    end;
  end;
end;



end.
