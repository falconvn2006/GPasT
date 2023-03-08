unit GSData_RapportClass;

interface
uses GSData_TErreur, GSData_Types, Generics.Collections, SysUtils, Classes,
     IdSmtp, IdMessage, IdSSL, IdSSLOpenSSL, IdExplicitTLSClientServerBase,
     IdEmailAddress, IdText, IdMessageParts, IdAttachmentFile;


type
  TRapportErreur = record
    Erreur : TErreur;
  Public
    Function DoHtlm : String;
  end;

  TRapportClass = Class
  Private
    FErreurList: TList<TErreur>;
    FArticleRapport : TList<TRapportErreur>;
    FRapportFile : String;
    FIDSMTP: TIdSMTP;
    FMAGCODEADH: String;
    FListeNumEXPCAF: String;
    FListeNumCESMAG: String;
  Protected
  Public
    constructor Create;
    destructor Destroy;override;

    Procedure CreateHtml;
    procedure SendMail;
  Published
    property Erreurs : TList<TErreur> read FErreurList Write FErreurList;
    property IDSmtp : TIdSMTP read FIDSMTP write FIDSMTP;
    property MAG_CODEADH : String read FMAGCODEADH write FMAGCODEADH;
    property ListeNumEXPCAF : String read FListeNumEXPCAF write FListeNumEXPCAF;
    property ListeNumCESMAG : String read FListeNumCESMAG write FListeNumCESMAG;
  End;

implementation

{ TRapportClass }

constructor TRapportClass.Create;
begin
  FArticleRapport := TList<TRapportErreur>.Create;
end;

destructor TRapportClass.Destroy;
begin
  FArticleRapport.Free;
  inherited;
end;

//--------------------------------------------------------------> CreateHtml

procedure TRapportClass.CreateHtml;
var
  vArticleErreur, vRapportErreur     : TRapportErreur;
  vMarqueErreur, vMultiColisErreur   : TRapportErreur;
  vNomenclatureErreur, vOpeComErreur : TRapportErreur;
  vPackageErreur, vPrixDeVenteErreur , vGetFtpErreur,
  vCommandeErreur, vReceptionErreur  : TRapportErreur;
  vErreur      : TErreur;
  vTextRapport : String;
  vStrlMail    : TStringList;
  sErr : string ;
begin
  if not Assigned(FErreurList) then
    raise Exception.Create('Aucune liste d''erreurs n''a été associées');

  {$REGION ' Assignation des erreurs '}
  // Assignation des erreurs dans des listes séparés
  for vErreur in FErreurList do
  begin
    case vErreur.TypeErreur of
      teArticle, teArticleInteg:
        begin
          vArticleErreur.Erreur := vErreur;
          FArticleRapport.Add(vArticleErreur);
        end;
      teMarque:
        begin
          vMarqueErreur.Erreur := vErreur;
          FArticleRapport.Add(vMarqueErreur);
        end;
      teMultiColis:
        begin
          vMultiColisErreur.Erreur := vErreur;
          FArticleRapport.Add(vMultiColisErreur);
        end;
      teNomenclature:
        begin
          vNomenclatureErreur.Erreur := vErreur;
          FArticleRapport.Add(vNomenclatureErreur);
        end;
      teOpeCom:
        begin
          vOpeComErreur.Erreur := vErreur;
          FArticleRapport.Add(vOpeComErreur);
        end;
      tePackage:
        begin
          vPackageErreur.Erreur := vErreur;
          FArticleRapport.Add(vPackageErreur);
        end;
      tePrixDeVente:
        begin
          vPrixDeVenteErreur.Erreur := vErreur;
          FArticleRapport.Add(vPrixDeVenteErreur);
        end;
      teCommande:
        begin
          vCommandeErreur.Erreur := vErreur;
          FArticleRapport.Add(vCommandeErreur);
        end;
      teReception :
        begin
          vReceptionErreur.Erreur := vErreur;
          FArticleRapport.Add(vReceptionErreur);
        end;
      teGetFtp :
        begin
          vGetFtpErreur.Erreur := vErreur;
          FArticleRapport.Add(vGetFtpErreur);
        end;
      teGetFtpWarning :
        begin
          vGetFtpErreur.Erreur := vErreur;
          FArticleRapport.Add(vGetFtpErreur);
        end;
    end;
  end;
  {$ENDREGION ' Assignation des erreurs '}

  vStrlMail := TStringList.Create;
  try
    // Chargement du fichier base
    vStrlMail.LoadFromFile(GAPPFILE + 'Mail.html');

  {$REGION '  >>> Ecriture dans le fichier HTML <<<  '}

    {$REGION ' Ecriture des articles '}
    vTextRapport := '';
    for vRapportErreur in FArticleRapport do
      if vRapportErreur.Erreur.TypeErreur in [teArticle, teArticleInteg] then
        vTextRapport := vTextRapport + vRapportErreur.DoHtlm;

    vStrlMail.Text := StringReplace(vStrlMail.Text,'@ARTICLEERREURS@', vTextRapport,[]);
    {$ENDREGION}

    {$REGION ' Ecriture des marques '}
    vTextRapport := '';
    for vRapportErreur in FArticleRapport do
      if vRapportErreur.Erreur.TypeErreur = teMarque then
        vTextRapport := vTextRapport + vRapportErreur.DoHtlm;

    vStrlMail.Text := StringReplace(vStrlMail.Text,'@MARQUEERREURS@', vTextRapport,[]);
    {$ENDREGION}

    {$REGION ' Ecriture des multi-colis '}
    vTextRapport := '';
    for vRapportErreur in FArticleRapport do
      if vRapportErreur.Erreur.TypeErreur = teMultiColis then
        vTextRapport := vTextRapport + vRapportErreur.DoHtlm;

    vStrlMail.Text := StringReplace(vStrlMail.Text,'@MULTICOLISERREURS@', vTextRapport,[]);
    {$ENDREGION}

    {$REGION ' Ecriture des nomenclatures '}
    vTextRapport := '';
    for vRapportErreur in FArticleRapport do
      if vRapportErreur.Erreur.TypeErreur = teNomenclature then
        vTextRapport := vTextRapport + vRapportErreur.DoHtlm;

    vStrlMail.Text := StringReplace(vStrlMail.Text,'@NOMENCLATUREERREURS@', vTextRapport,[]);
    {$ENDREGION}

    {$REGION ' Ecriture des opecom '}
    vTextRapport := '';
    for vRapportErreur in FArticleRapport do
      if vRapportErreur.Erreur.TypeErreur = teOpeCom then
        vTextRapport := vTextRapport + vRapportErreur.DoHtlm;

    vStrlMail.Text := StringReplace(vStrlMail.Text,'@OPECOMERREURS@', vTextRapport,[]);
    {$ENDREGION}

    {$REGION ' Ecriture des packages '}
    vTextRapport := '';
    for vRapportErreur in FArticleRapport do
      if vRapportErreur.Erreur.TypeErreur = tePackage then
        vTextRapport := vTextRapport + vRapportErreur.DoHtlm;

    vStrlMail.Text := StringReplace(vStrlMail.Text,'@PACKAGEERREURS@', vTextRapport,[]);
    {$ENDREGION}

    {$REGION ' Ecriture des prix de vente '}
    vTextRapport := '';
    for vRapportErreur in FArticleRapport do
      if vRapportErreur.Erreur.TypeErreur = tePrixDeVente then
        vTextRapport := vTextRapport + vRapportErreur.DoHtlm;

    vStrlMail.Text := StringReplace(vStrlMail.Text,'@PRIXDEVENTEERREURS@', vTextRapport,[]);
    {$ENDREGION}

    {$REGION 'Ecriture des commandes'}
    vTextRapport := '';
    for vRapportErreur in FArticleRapport do
      if vRapportErreur.Erreur.TypeErreur = teCommande then
        vTextRapport := vTextRapport + vRapportErreur.DoHtlm;

    vStrlMail.Text := StringReplace(vStrlMail.Text,'@COMMANDE@', vTextRapport,[]);
    {$ENDREGION}

    {$REGION 'Ecriture des réceptions'}
    vTextRapport := '';
    for vRapportErreur in FArticleRapport do
      if vRapportErreur.Erreur.TypeErreur = teReception then
        vTextRapport := vTextRapport + vRapportErreur.DoHtlm;

    vStrlMail.Text := StringReplace(vStrlMail.Text,'@RECEPTION@', vTextRapport,[]);
    {$ENDREGION}

    {$REGION 'Ecritures des erreurs FTP'}
    vTextRapport := '';
    for vRapportErreur in FArticleRapport do
      if (vRapportErreur.Erreur.TypeErreur = teGetFtp) or (vRapportErreur.Erreur.TypeErreur = teGetFtpWarning) then
        vTextRapport := vTextRapport + vRapportErreur.DoHtlm;

    vStrlMail.Text := StringReplace(vStrlMail.Text,'@FTPERREUR@', vTextRapport,[]);
    {$ENDREGION}
  {$ENDREGION ' >>> Ecriture dans le fichier HTML <<<'}

    if FListeNumEXPCAF <> '' then
      vStrlMail.Text := StringReplace(vStrlMail.Text,'@LISTENUMEXPCAF@', '<p>Numéros EXPCAF : '+FListeNumEXPCAF+'</p>',[rfReplaceAll])
    else
      vStrlMail.Text := StringReplace(vStrlMail.Text,'@LISTENUMEXPCAF@', '<!--@LISTENUMEXPCAF@-->',[rfReplaceAll]);

    if FListeNumCESMAG <> '' then
      vStrlMail.Text := StringReplace(vStrlMail.Text,'@LISTENUMCESMAG@', '<p>Numéros CESMAG : '+FListeNumCESMAG+'</p>',[rfReplaceAll])
    else
      vStrlMail.Text := StringReplace(vStrlMail.Text,'@LISTENUMCESMAG@', '<!--@LISTENUMCESMAG@-->',[rfReplaceAll]);

    // sauvegarde du rapport

    vStrlMail.Text := StringReplace(vStrlMail.Text,'@DATE@', FormatDateTime('DD/MM/YYYY', now),[rfReplaceAll]);
    vStrlMail.Text := StringReplace(vStrlMail.Text,'@HEURE@', FormatDateTime('HH:MM:SS', now),[rfReplaceAll]);

    sErr := 'OK' ;
    if FErreurList.Count > 0
      then sErr := IntToStr(FErreurList.Count)+'ERR' ;

    FRapportFile := GAPPRAPPORT + FormatDateTime('YYYY\MM\DD\',Now);
    DoDir(FRapportFile);
    FRapportFile := FRapportFile + 'RAP-' + FMAGCODEADH + '-' + FormatDateTime('YYYYMMDDhhmmsszzz',Now) + '-' + sErr + '.html';

    vStrlMail.SaveToFile(FRapportFile);

  finally
    vStrlMail.Clear;
    vStrlMail.Free;
  end;
end;

//------------------------------------------------------------------> DoHtlm

function TRapportErreur.DoHtlm: String;
begin
  case Erreur.TypeErreur of
    teArticle :
      Result := Format('<tr><td>%s</td><td>%s</td><td>%s</td><td>%d</td></tr>',
                [Erreur.NomFichier,Erreur.RefErreur,Erreur.Text,Erreur.NumeroLigne]);
    teArticleInteg :
      Result := Format('<tr><td></td><td>%s</td><td>%s</td><td></td></tr>',
                [Erreur.RefErreur,Erreur.Text]);
    teMarque :
      Result := Format('<tr><td>%s</td><td>%s</td><td>%s</td><td>%d</td></tr>',
                [Erreur.NomFichier,Erreur.RefErreur,Erreur.Text,Erreur.NumeroLigne]);
    teMultiColis :
      Result := Format('<tr><td>%s</td><td>%s</td><td>%s</td><td>%d</td></tr>',
                [Erreur.NomFichier,Erreur.RefErreur,Erreur.Text,Erreur.NumeroLigne]);
    teNomenclature :
      Result := Format('<tr><td>%s</td><td>%s</td><td>%s</td><td>%d</td></tr>',
                [Erreur.NomFichier,Erreur.RefErreur,Erreur.Text,Erreur.NumeroLigne]);
    teOpeCom :
      Result := Format('<tr><td>%s</td><td>%s</td><td>%s</td><td>%d</td></tr>',
                [Erreur.NomFichier,Erreur.RefErreur,Erreur.Text,Erreur.NumeroLigne]);
    tePackage :
      Result := Format('<tr><td>%s</td><td>%s</td><td>%s</td><td>%d</td></tr>',
                [Erreur.NomFichier,Erreur.RefErreur,Erreur.Text,Erreur.NumeroLigne]);
    tePrixDeVente :
      Result := Format('<tr><td>%s</td><td>%s</td><td>%s</td><td>%d</td></tr>',
                [Erreur.NomFichier,Erreur.RefErreur,Erreur.Text,Erreur.NumeroLigne]);
    teCommande :
      Result := Format('<tr><td>%s</td><td>%s</td><td>%s</td><td>%d</td></tr>',
                [Erreur.NomFichier,Erreur.RefErreur,Erreur.Text,Erreur.NumeroLigne]);
    teReception :
      Result := Format('<tr><td>%s</td><td>%s</td><td>%s</td><td>%d</td></tr>',
                [Erreur.NomFichier,Erreur.RefErreur,Erreur.Text,Erreur.NumeroLigne]);
    teGetFtp :
      Result := Format('<tr><td>%s</td><td>%s</td><td>%s</td><td>%d</td></tr>',
                [Erreur.NomFichier,Erreur.RefErreur,Erreur.Text,Erreur.NumeroLigne]);
    teGetFtpWarning :
      Result := Format('<tr><td>%s</td><td>%s</td><td>%s</td><td>%d</td></tr>',
                [Erreur.NomFichier,Erreur.RefErreur,Erreur.Text,Erreur.NumeroLigne]);
  end;
end;

//----------------------------------------------------------------> SendMail

procedure TRapportClass.SendMail;
var
  SSL : TIdSSLIOHandlerSocketOpenSSL;
  IdMess : TIdMessage;
  EmailTo     : TIdEMailAddressItem;

  i : Integer;
begin
  if Trim(IniStruct.Others.MailList.Text) = '' then
    Exit;

  IdMess := TIdMessage.Create(Nil);
  Try
    FIDSmtp.Host     := IniStruct.Mail.Host;
//    FIDSmtp.Username := IniStruct.Mail.UserName;
//    FIDSmtp.Password := IniStruct.Mail.Password;
    FIDSmtp.Port     := IniStruct.Mail.Port;

    if IniStruct.Mail.SSL then
    begin
      SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      FIDSMTP.IOHandler := SSL;
      FIDSMTP.UseTLS := utUseRequireTLS;
    end
    else
    begin
      FIDSMTP.UseTLS := utNoTLSSupport;
    end;

    // 2016-07-12 : Prise en compte de l'absence de login/password pour FL.
    if (Trim(IniStruct.Mail.UserName) = '')
    or (Trim(IniStruct.Mail.Password) = '') then
      FIDSmtp.AuthType := satNone
    else
    begin
      FIDSmtp.AuthType := satDefault;
      FIDSmtp.Username := IniStruct.Mail.UserName;
      FIDSmtp.Password := IniStruct.Mail.Password;
    end;

    IdMess.ContentType := 'multipart/mixed';
    IdMess.Body.LoadFromFile(FRapportFile); //Text := 'Vous trouverez ci joint le fichier de logs de la session d''intégration du ' + FormatDateTime('DD/MM/YYYY hh:mm:ss',Now);
    IdMess.CharSet := 'utf-8';
    if Pos('ERR',FRapportFile) > 0 then
      IdMess.Subject := FMAGCODEADH + ' - Rapport d''erreur du ' + FormatDateTime('DD/MM/YYYY hh:mm:ss',Now)
    else
      IdMess.Subject := FMAGCODEADH + ' - Rapport d''intégration du ' + FormatDateTime('DD/MM/YYYY hh:mm:ss',Now);
    IdMess.From.Address := IniStruct.Mail.UserName;

    for i := 0 to IniStruct.Others.MailList.Count -1 do
    begin
      EMailTo := IdMess.Recipients.Add;
      EMailTo.Address := IniStruct.Others.MailList[i];
    end;

    With  TIdText.Create(IdMess.MessageParts) do
    begin
      ContentType := 'text/html';
      CharSet := 'utf-8';
      Body.Text := UTF8Encode(IdMess.Body.Text);
    end;


    // Commenté car comportement anormal lors de l'envoi du mail
    //With TIdAttachmentFile.Create(IdMess.MessageParts, GAPPFILE + 'logo-GK.png') do
    //begin
    //  ContentType := 'image/gif';
    //  FileIsTempFile := false;
    //  ContentDisposition := 'inline';
    //  ExtraHeaders.Values['content-id'] := 'logo-IF.gif';
    //  DisplayName := 'logo-GK.png';
    //end;

    if IdMess.Recipients.Count > 0 then
    Try
      FIDSmtp.Connect;
      try
        FIDSmtp.Send(IdMess);
      finally
        FIDSmtp.Disconnect(False);
      end;
    Except on E:Exception do
      raise Exception.Create('SendMail -> ' + E.Message);
    End;
  Finally
    if Assigned(EMailTo) then
      FreeAndNil(EMailTo);
    if Assigned(IdMess) then
      IdMess.Free;
    if Assigned(SSL) then
      SSL.Free;
  End;
end;

end.
