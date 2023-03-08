unit uCommon;

interface

uses
  SysUtils, Classes, DB, DBClient, StrUtils, dialogs, Windows,
  //Ajout Mail
  IdMessage, IdSMTP, IdSSLOpenSSL, IdGlobal, IdExplicitTLSClientServerBase,
  IdLogFile,
  IdText;
  //Fin Mail

Var
  Compteur     : Integer=0;          //Compte le nombre de matériel traité
  NbLigne      : Integer;            //Nombre de ligne à traité

procedure CSV_To_ClientDataSet(FichCsv : String; CDS : TClientDataSet;Index:String);
function VerifFormatFile(aPath : string; aField : array of string; ARetirePtVirg: boolean):boolean;
function VerifFile(aPath : string; aField : array of string):boolean;

function ConvertStrToFloat(AStr: string; const ADefault: Double = 0.0): Double;
function ConvertStrToDate(AStr: string; const ADefault: TDatetime = 0.0): TDatetime;
  //arrondi à 2 decimal après la virgule
function ArrondiA2(v: Double): Double;
function GetValueImp(AChamp: string; ADefColonne: array of string; ALigneLecture: string; ARetirePtVirg: boolean): string;

procedure SendEmail(const Recipients: string; const Subject: string; const Body: string);

procedure CreerFile(aPathFile: string);

function OuiNon(sBool:Boolean):string;

implementation

procedure SendEmail(const Recipients: string; const Subject: string; const Body: string);
const
  MAIL_ACCOUNT  = 'dev@ginkoia.fr'; // Votre compte GMail
  MAIL_PASSWORD = 'Toru682674';     // Votre mot de passe GMail
  MAIL_HOST     = 'pod51015.outlook.com';
  MAIL_PORT     = 587;

var
  SMTP        : TIdSMTP;
  IdMessage   : TIdMessage;
  IdSSL       : TIdSSLIOHandlerSocketOpenSSL;
begin
  SMTP := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.Create(nil);
  IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  Try
    Try
      IdSSL.SSLOptions.Method    := sslvTLSv1;
      IdSSL.SSLOptions.Mode      := sslmUnassigned;

      IdMessage.Clear;
      IdMessage.ContentType := 'multipart/mixed';
      IdMessage.Subject := Format('%s - Transpo du %s ',[Subject, FormatDateTime('DD/MM/YYYY à hh:mm:ss',Now)]);
      IdMessage.Body.Text := Body;

      IdMessage.From.Text := MAIL_ACCOUNT;
      IdMessage.Recipients.EMailAddresses := Recipients;

      SMTP.IOHandler  := IdSSL;
      SMTP.UseTLS     := utUseExplicitTLS;
      SMTP.Host       := MAIL_HOST;
      SMTP.Username   := MAIL_ACCOUNT;
      SMTP.Password   := MAIL_PASSWORD;

      Try
        SMTP.Port := MAIL_PORT;
        SMTP.Connect;
      Except on E:Exception do
        begin
          try
            SMTP.Port := 25;
            SMTP.Connect;
          Except
          end;
        end;
      End;

      SMTP.Send(IdMessage);

    Except
    End;
  finally
    SMTP.Free;
    IdMessage.Free;
    IdSSL.Free;
    if SMTP.Connected then
      SMTP.Disconnect(True);
  End;
end;

procedure CreerFile(aPathFile: string);
var
  i : Integer;
begin
  if not FileExists(aPathFile) then
  begin
    i := FileCreate(aPathFile);
    if i <> -1 then
      FileClose(i);
  end;
end;

function ConvertStrToFloat(AStr: string; const ADefault: Double = 0.0): Double;
var
  sTmp: string;
begin
  Result := ADefault;
  sTmp := Trim(AStr);
  if sTmp='' then
    exit;

  if Pos(',', sTmp)>0 then
    sTmp[Pos(',', sTmp)] := FormatSettings.DecimalSeparator;
  if Pos('.', sTmp)>0 then
    sTmp[Pos('.', sTmp)] := FormatSettings.DecimalSeparator;

  Result := StrToFloatDef(sTmp, ADefault);
end;

function ConvertStrToDate(AStr: string; const ADefault: TDatetime = 0.0): TDatetime;
var
  sJour: string;
  sMois: string;
  sAn  : string;
  sTmp : string;
begin
  Result := ADefault;
  if Length(AStr)<8 then
    exit;

  sJour := Copy(AStr, 1, 2);
  sMois := Copy(AStr, 4, 2);
  sAn   := Copy(AStr, 7, Length(AStr));
  if Length(sAn)>4 then
    sAn := Copy(sAn, 1, 4);

  sTmp := sjour+FormatSettings.DateSeparator+sMois+FormatSettings.DateSeparator+sAn;

  Result := StrToDateDef(sTmp, ADefault);
end;

  //arrondi à 2 decimal après la virgule
function ArrondiA2(v: Double): Double;
var
  TpV: Currency;
  v1: integer;
  s: string;
  Ecart: integer;
begin
  TpV := v;
  s := inttostr(Trunc(TpV * 1000));
  Ecart := 0;
  try
    v1 := StrToInt(s[Length(s)]);
    if v1 >= 5 then
    begin
      if v < 0 then
        Ecart := -1
      else
        Ecart := 1;
    end;
  except
  end;
  Result := (Trunc(TpV * 100) + Ecart) / 100;
end;

Procedure CSV_To_ClientDataSet(FichCsv:String;CDS:TClientDataSet;Index:String);
//Transfert le contenu du CSV dans un clientdataset en prenant la ligne d'entête pour la création des champs
Var
  Donnees	  : TStringList;    // Charge le fichier csv
  InfoLigne : TStringList;    // Découpe la ligne en cours de traitement
  I,J       : Integer;        // Variable de boucle
  NbEnre   : integer;         // Nombre de ligne d'enregistrement
  Chaine    : String;         // Variable de traitement des lignes
  Dep       : integer;        // Depart d'affectation après ceux déjà créer
  CntField  : integer;        // nombre de champ à importer
Begin
  //Création des variables
  Donnees   := TStringList.Create;
  InfoLigne := TStringList.Create;
  try

    //Chargement du csv
    Donnees.LoadFromFile(FichCsv);

    //Initialisation de variable
    NbLigne   := Donnees.Count;
    Compteur  := 0;

    Dep := CDS.FieldDefs.Count;

    //Traitement de la ligne d'entête
    InfoLigne.Clear;
    InfoLigne.Delimiter := ';';
    InfoLigne.DelimitedText := Donnees.Strings[0];
    InfoLigne.StrictDelimiter := True;
    CntField := InfoLigne.Count;
    for I := 0 to InfoLigne.Count - 2 do
      Begin
        CDS.FieldDefs.Add(Trim(InfoLigne.Strings[I]),ftString,255);
      End;

    CDS.CreateDataSet;
    CDS.LogChanges := False;

    //Traitement des lignes de données
    CDS.Open;

    NbEnre := Donnees.Count-1;

    i := 1;
    while (i<=NbEnre) do
    begin
      InfoLigne.Clear;
      InfoLigne.Delimiter := ';';
      InfoLigne.QuoteChar := '''';
      Chaine  := LeftStr(QuotedStr(Donnees.Strings[I]),length(QuotedStr(Donnees.Strings[I]))-1);
      Chaine  := ReplaceStr(Chaine,';',''';''');
      Chaine  := Chaine + '''';

      InfoLigne.DelimitedText := Chaine;
      CDS.Insert;
      for J := 0 to (CntField - 2) do
        Begin
          CDS.Fields[J+Dep].AsString  := InfoLigne.Strings[J];
        End;
      CDS.Post;
      Inc(Compteur);
      Inc(i);
    end;

    CDS.AddIndex('idx', Index, []);
    CDS.IndexName := 'idx';

  finally
    //Suppression des variables en mémoire
    FreeAndNil(Donnees);
    FreeAndNil(InfoLigne);
  end;
End;

Function VerifFormatFile(aPath : string; aField : array of string; ARetirePtVirg: boolean):boolean;
const
  MaxChargement = 4096;
Var
  Donnees	  : TStringList;    // Charge le fichier csv
  InfoLigne : TStringList;    // Découpe la ligne en cours de traitement
  I         : Integer;        // Variable de boucle
  StreamMem : TMemoryStream;  // chargement en partie du fichier en memoire pour avoir l'entete
  StreamFil : TFileStream;    // fichier pour lecture
  Count     : Integer;
  sLigne    : string;
Begin
  //Création des variables
  Donnees   := TStringList.Create;
  InfoLigne := TStringList.Create;

  //Chargement du csv
  StreamFil := TFileStream.Create(aPath, fmOpenRead);
  StreamMem := TMemoryStream.Create;
  try
    // on charge une partie seulement
    // c'est juste pour avoir l'entete, 4096 octet suffisent bien
    if StreamFil.Size<MaxChargement then
      Count := Integer(StreamFil.Size)
    else
      Count := MaxChargement;

    StreamFil.Seek(0, soFromBeginning);
    StreamMem.CopyFrom(StreamFil, Count);
    StreamMem.Seek(0, soFromBeginning);
    Donnees.LoadFromStream(StreamMem);

    // si pas de lignes, le fichier est faux
    if Donnees.Count=0 then
    begin
      Result := false;
      exit;
    end;

    // retire le point-virgule si demander
    sLigne := Donnees[0];
    if ARetirePtVirg and (sLigne<>'') and (sLigne[Length(sLigne)]=';') then
      sLigne := Copy(sLigne, 1, Length(sLigne)-1);

    //Traitement de la ligne d'entête
    InfoLigne.Clear;
    InfoLigne.Delimiter := ';';
    InfoLigne.DelimitedText := sLigne;

    Result := True;
    for I := 0 to InfoLigne.Count - 1 do
    Begin
      if ((I = InfoLigne.Count) or (I = Length(aField))) or (UpperCase(InfoLigne.Strings[I]) <> UpperCase(aField[I])) then
      begin
        Result := False;
        Break;
      end;
    End;
  finally
    FreeAndNil(StreamFil);
    FreeAndNil(StreamMem);
  end;
End;

function VerifFile(aPath : string; aField : array of string):boolean;
var
  Nb_Field : Integer;

  i: Integer;
  sLigne: string;
  sLire: String;
  Stream: TFileStream;
  StrStream: TStringStream;
  SizeLu: Int64;
  SizeALire: Int64;
  TailleMax: Int64;

  function CountChar(const S : string) : integer;
  var
    N : integer;
  begin
    result := 0;
    N      := Posex(';',S,1);
    while N <> 0 do begin
      inc(result);
      N := Posex(';',S,N+1);
    end;
  end;

  function InStr(sSubStr: string): Boolean;
  var
    iPos: integer;
  begin
    Result := False;                                      // Décimal      Octal   Hex  Binaire   Caractère
    iPos := Pos(sSubStr, #10);      //Vérification caractère 010          012     0A   00001010  LF         (Line Feed)
    if iPos <> 0 Then
      Result := True
    else
    begin
      iPos := Pos(sSubStr, #00);    //Vérification caractère 000          000     00   00000000  NUL        (Null char.)
      if iPos <> 0 Then
        Result := True
      else
      begin
        iPos := Pos(sSubStr, #13);  //Vérification caractère 013          015     0D   00001101  CR         (Carriage Return)
        if iPos <> 0 Then
          Result := True;
      end;
    end;
  end;

  function TraitementDeLaLigne(ALigne, AFichier: string; ANumLigne: integer):Boolean;
  var
    vNbField : integer;
  begin
    Result := True;
    //Compter le nombre de ';'
    vNbField := CountChar(ALigne);
    if Nb_Field <> vNbField then
    begin
      ShowMessage('Fichier ' + AFichier + #13#10 + 'Erreur sur la ligne ' + IntToStr(ANumLigne) + ' : "' + ALigne + '". Le nombre de champs présents incorrect.' + #13#10 +
                  'Attendu = ' + IntToStr(Nb_Field) + '; Trouve = ' + IntTostr(vNbField));
      Result := False;
    end
    else
    begin
      //Vérifier la présence des caractères
      if InStr(ALigne) then
      begin
        ShowMessage('Fichier ' + AFichier + #13#10 + 'Erreur sur la ligne ' + IntToStr(ANumLigne) + ' : "' + ALigne + '". Présence de caractères incorrect.');
        Result := False;
      end;
    end;
  end;

begin
  Result := True;
  try
    sLire := '';
    TailleMax := 1024;

    Nb_Field := Length(aField);

    Stream := TFileStream.Create(aPath, fmOpenRead);
    StrStream := TStringStream.Create('');
    try
      i := 0;
      Stream.Seek(0, soFromBeginning);
      if Stream.Size-Stream.Position>TailleMax then
        SizeALire := TailleMax
      else
        SizeALire := Stream.Size-Stream.Position;
      Sizelu := StrStream.CopyFrom(Stream, SizeALire);
      sLire := StrStream.DataString;
      //iProgress := Sizelu;
      while (Sizelu=TailleMax) do
      begin
        while Pos(#13#10, sLire)>0 do
        begin
          inc(i);
          sLigne := Copy(sLire, 1, Pos(#13#10, sLire)-1);
          sLire := Copy(sLire, Pos(#13#10, sLire)+2, Length(sLire));
          // traitement de la ligne
          if (i>1)  then
          begin
            if not TraitementDeLaLigne(sLigne, aPath, i) then
            begin
              Result := False;
              Exit;
            end;
          end;
        end;
        if Stream.Size-Stream.Position>TailleMax then
          SizeALire := TailleMax
        else
          SizeALire := Stream.Size-Stream.Position;

        StrStream.Clear;
        Sizelu := StrStream.CopyFrom(Stream, SizeALire);
        sLire := sLire+StrStream.DataString;
      end;
      if sLire<>'' then
      begin
        while Pos(#13#10, sLire)>0 do
        begin
          inc(i);
          sLigne := Copy(sLire, 1, Pos(#13#10, sLire)-1);
          sLire := Copy(sLire, Pos(#13#10, sLire)+2, Length(sLire));
          // traitement de la ligne
          if i>1 then
          begin
            if not TraitementDeLaLigne(sLigne, aPath, i) then
            begin
              Result := False;
              Exit;
            end;
          end;
        end;
        if sLire<>'' then
        begin
          inc(i);
          sLigne := sLire;
          // traitement de la ligne
          if i>1 then
          begin
            if not TraitementDeLaLigne(sLigne, aPath, i) then
            begin
              Result := False;
              Exit;
            end;
          end;
        end;
      end;
    finally
      FreeAndNil(Stream);
      FreeAndNil(StrStream);
    end;
  finally

  end;
end;

function GetValueImp(AChamp: string; ADefColonne: array of string; ALigneLecture: string; ARetirePtVirg: boolean): string;
var
  i: integer;
  LPos: integer;
  sLigne: string;
begin
  Result := '';

  // Recherche position du champ
  LPos := -1;
  i := 0;
  while (LPos=-1) and (i<=High(ADefColonne)) do
  begin
    if UpperCase(AChamp)=UpperCase(ADefColonne[i]) then
      LPos := i;
    inc(i);
  end;
  if LPos=-1 then
    Raise Exception.Create('Champ: "'+AChamp+'" non trouvé');

  sLigne := ALigneLecture;
  if (ARetirePtVirg) and (sLigne<>'') and (sLigne[Length(sLigne)]=';') then
    sLigne := Copy(sLigne, 1, Length(sLigne)-1);

  if (sLigne<>'') and (sLigne[1]='"') then
  begin
    for i := 1 to LPos do
    begin
      if Pos('";"', sLigne)>0 then
        sLigne := Copy(sLigne, Pos('";"', sLigne)+2, Length(sLigne));
    end;
    if Pos('";"', sLigne)>0 then
      sLigne := Copy(sLigne, 1, Pos('";"', sLigne));
    sLigne := Copy(sLigne, 2, Length(sLigne)-2);
  end
  else
  begin
    for i := 1 to LPos do
    begin
      if Pos(';', sLigne)>0 then
        sLigne := Copy(sLigne, Pos(';', sLigne)+1, Length(sLigne));
    end;
    if Pos(';', sLigne)>0 then
      sLigne := Copy(sLigne, 1, Pos(';', sLigne)-1);
  end;

  //Optimisation SR-01/03/2013
  Result := StringReplace(StringReplace(StringReplace(sLigne, '""', '"', [rfReplaceAll, rfIgnoreCase]), '\l', #10, [rfReplaceAll, rfIgnoreCase]), '\n', #13#10, [rfReplaceAll, rfIgnoreCase]);
end;

function OuiNon(sBool:Boolean):string;
begin
  if sBool then
    Result := 'Oui'
  else
    Result := 'Non';
end;

end.
