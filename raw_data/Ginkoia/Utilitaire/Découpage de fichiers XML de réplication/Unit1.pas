unit Unit1;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.FileCtrl, System.INIFiles, System.StrUtils, Xml.XMLDoc,
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Winapi.ShellAPI, System.IOUtils, uThreadProc, UnitLog;

type
  TProgression = record
    nPositionNoeuds, nNbNoeuds, nPosition: Integer;
    sNoeud, sEtape, sNbFichiers: String;
  end;

  TMainForm = class(TForm)
    PanelParametres: TPanel;
    EditFichierXML: TLabeledEdit;
    BtnOuvrirFichier: TBitBtn;
    EditRepertoireDest: TLabeledEdit;
    SpinEditTailleMax: TSpinEdit;
    BtnRepertoireDest: TBitBtn;
    Label1: TLabel;
    labSelectBase: TLabel;
    Panel: TPanel;
    BtnDecouper: TBitBtn;
    Panel1: TPanel;
    Label2: TLabel;
    ProgressBar: TProgressBar;
    FileOpenDialogFichier: TFileOpenDialog;
    FileOpenDialogRepertoire: TFileOpenDialog;
    LabelEtape: TLabel;
    LabelNbFichiers: TLabel;
    ProgressBarNoeuds: TProgressBar;
    LabelNoeud: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure BtnOuvrirFichierClick(Sender: TObject);
    procedure BtnRepertoireDestClick(Sender: TObject);
    procedure BtnDecouperClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    _bTraitement, _bAnnulerTraitement: Boolean;
    _Progression: TProgression;

    procedure ViderRepertoireDest;
    procedure Decouper;
    function XmlStrToInt(Value: OleVariant; DefaultInt: Integer): Integer;
    procedure MajProgression(const nPositionNoeuds, nNbNoeuds: Integer; const sNoeud: String; const nPosition: Integer; const sEtape, sNbFichiers: String);
    procedure AffProgression;
    procedure AjoutLog(const sLigne: String; const bNouveau: Boolean = False);

  public
    _SectionCritiqueLog: TRTLCriticalSection;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
var
  FichierINI: TIniFile;
begin
  // Chargement des paramètres.
  FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'DecoupageFichiersXMLReplication.ini');
  try
    SpinEditTailleMax.Value := FichierINI.ReadInteger('Paramètres', 'Taille max', 1);
    EditRepertoireDest.Text := FichierINI.ReadString('Paramètres', 'Répertoire de destination', '');
  finally
    FichierINI.Free;
  end;

  LabelNoeud.Caption := '';      LabelEtape.Caption := '';      LabelNbFichiers.Caption := '';
  InitializeCriticalSection(_SectionCritiqueLog);
  _bTraitement := False;
  AjoutLog('', True);
end;

procedure TMainForm.BtnOuvrirFichierClick(Sender: TObject);
begin
  // Si validation.
  if FileOpenDialogFichier.Execute then
    EditFichierXML.Text := FileOpenDialogFichier.FileName;
end;

procedure TMainForm.BtnRepertoireDestClick(Sender: TObject);
var
  sRepertoire: String;
begin
  // Si supérieur à Windows XP.
  if Win32MajorVersion >= 6 then
  begin
    //FileOpenDialogRepertoire.DefaultFolder := _sRepertoire;
    FileOpenDialogRepertoire.FileName := '';

    // Si validation.
    if FileOpenDialogRepertoire.Execute then
      EditRepertoireDest.Text := IncludeTrailingPathDelimiter(FileOpenDialogRepertoire.FileName);
  end
  else
  begin
    // Si validation.
    if SelectDirectory(' Sélectionner le répertoire de destination', '', sRepertoire, [sdNewFolder, sdShowEdit, sdShowShares, sdValidateDir]) then
      EditRepertoireDest.Text := IncludeTrailingPathDelimiter(sRepertoire);
  end;
end;

procedure TMainForm.ViderRepertoireDest;
{$REGION 'ViderRepertoireDest'}
  function SupprimerRepertoire(const sRepertoire: String): Boolean;
  var
    SHFileOpStruct: TSHFileOpStruct;
  begin
    Result := False;
    if System.SysUtils.DirectoryExists(sRepertoire) then
    begin
      ZeroMemory(@SHFileOpStruct, SizeOf(SHFileOpStruct));
      SHFileOpStruct.wFunc := FO_DELETE;
      SHFileOpStruct.fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
      SHFileOpStruct.pFrom := PChar(sRepertoire + #0);
      Result := (0 = ShFileOperation(SHFileOpStruct));
    end;
  end;
{$ENDREGION}
var
  sr: TSearchRec;
begin
  AjoutLog('Vide répertoire destination [' + EditRepertoireDest.Text + ']:');
  if FindFirst(IncludeTrailingPathDelimiter(EditRepertoireDest.Text) + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if(sr.Name <> '.') and (sr.Name <> '..') then
      begin
        // Si répertoire.
        if(sr.Attr and faDirectory) = faDirectory then
        begin
          if SupprimerRepertoire(IncludeTrailingPathDelimiter(EditRepertoireDest.Text) + sr.Name) then
            AjoutLog('   Répertoire [' + IncludeTrailingPathDelimiter(EditRepertoireDest.Text) + sr.Name + '] supprimé.')
          else
            raise Exception.Create('# Erreur :  la suppression du répertoire [' + IncludeTrailingPathDelimiter(EditRepertoireDest.Text) + sr.Name + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
        end
        else      // Si fichier.
        begin
          if DeleteFile(IncludeTrailingPathDelimiter(EditRepertoireDest.Text) + sr.Name) then
            AjoutLog('   Fichier [' + IncludeTrailingPathDelimiter(EditRepertoireDest.Text) + sr.Name + '] supprimé.')
          else
            raise Exception.Create('# Erreur :  la suppression du fichier [' + IncludeTrailingPathDelimiter(EditRepertoireDest.Text) + sr.Name + '] a échoué !' + #13#10 + SysErrorMessage(GetLastError));
        end;
      end;

      // Si traitement annulé.
      if _bAnnulerTraitement then
      begin
        AjoutLog('>> Traitement annulé par l''utilisateur.');
        Break;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;

  AjoutLog('');
end;

procedure TMainForm.BtnDecouperClick(Sender: TObject);
{$REGION 'BtnDecouperClick'}
  function BoiteDeDialogue: Integer;
  var
    nLargeurBouton: Integer;
  begin
    with CreateMessageDialog('Attention :  le répertoire de destination n''est pas vide !', mtwarning, mbYesNoCancel) do
    try
      nLargeurBouton := Canvas.TextWidth('Continuer sans le vider') + 15;
      TButton(FindComponent('yes')).Caption := '&Vider le répertoire';
      TButton(FindComponent('yes')).Width := nLargeurBouton;
      TButton(FindComponent('no')).Caption := '&Continuer sans le vider';
      TButton(FindComponent('no')).Width := nLargeurBouton;
      TButton(FindComponent('cancel')).Caption := '&Annuler';
      TButton(FindComponent('cancel')).Width := nLargeurBouton;
      ActiveControl := TButton(FindComponent('cancel'));

      Width := (nLargeurBouton * 3) + 50;
      TButton(FindComponent('no')).Left := (Width div 2) - (nLargeurBouton div 2);
      TButton(FindComponent('yes')).Left := TButton(FindComponent('no')).Left - 10 - nLargeurBouton;
      TButton(FindComponent('cancel')).Left := TButton(FindComponent('no')).Left + nLargeurBouton + 10;
      Position := poScreenCenter;
      Result := ShowModal;
    finally
      Free;
    end;
  end;

  function RepertoireDestVide: Boolean;
  var
    sr: TSearchRec;
  begin
    Result := True;
    if FindFirst(IncludeTrailingPathDelimiter(EditRepertoireDest.Text) + '*.*', faAnyFile, sr) = 0 then
    begin
      repeat
        if(sr.Name <> '.') and (sr.Name <> '..') then
        begin
          Result := False;
          Break;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  end;

  function GetTailleFichier(const sFichier: String): Int64;
  var
    sr: TSearchRec;
  begin
    Result := 0;
    if FindFirst(sFichier, faAnyFile, sr) = 0 then
    begin
      Result := sr.Size;
      FindClose(sr);
    end;
  end;
{$ENDREGION}
var
  bErreur: Boolean;
  cLecteur: Char;
  nTailleRestante, nTailleFichier: Int64;
begin
  // Si annulation traitement.
  if _bTraitement then
  begin
    _bAnnulerTraitement := True;
    BtnDecouper.Enabled := False;
    Exit;
  end;

  AjoutLog(DupeString('-', 150));
  AjoutLog('');

  if(EditFichierXML.Text = '') or (not FileExists(EditFichierXML.Text)) then
  begin
    Application.MessageBox('Attention :  il faut sélectionner un fichier XML !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
    BtnOuvrirFichierClick(Sender);
    Exit;
  end;

  if(EditRepertoireDest.Text = '') or (not System.SysUtils.DirectoryExists(EditRepertoireDest.Text)) then
  begin
    Application.MessageBox('Attention :  il faut sélectionner un répertoire de destination !', PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
    BtnRepertoireDestClick(Sender);
    Exit;
  end;

  PanelParametres.Enabled := False;
  _bTraitement := True;      _bAnnulerTraitement := False;
  BtnDecouper.Caption := '&Annuler';
  try
    // Si répertoire destination pas vide.
    if not RepertoireDestVide then
    begin
      bErreur := False;

      // Demande de confirmation.
      case BoiteDeDialogue of
        ID_YES:
          begin
            LabelEtape.Caption := 'Vide répertoire de destination ...';
            Application.ProcessMessages;

            // Vide répertoire destination.
            TThreadProc.RunInThread(
              procedure
              begin
                ViderRepertoireDest;
              end
            ).whenError(
              procedure(aException: Exception)
              begin
                AjoutLog(aException.Message);
                Application.MessageBox(PChar(aException.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
                bErreur := True;
              end
            ).RunAndWait;
          end;

        ID_CANCEL:
          Exit;
      end;

      if bErreur then
        Exit;
    end;
    if _bAnnulerTraitement then
      Exit;

    // Vérification de l'espace-disque destination.
    if Length(ExtractFileDrive(EditRepertoireDest.Text)) > 0 then
    begin
      cLecteur := ExtractFileDrive(EditRepertoireDest.Text)[1];
      nTailleRestante := DiskFree(Ord(cLecteur) - Ord('A') + 1);

      nTailleFichier := GetTailleFichier(EditFichierXML.Text);
      if nTailleRestante < (nTailleFichier * 2.5) then
      begin
        Application.MessageBox(PChar('Attention :  espace-disque destination insuffisant (' + IntTostr(nTailleRestante) + ') !'), PChar(Caption + ' - message'), MB_ICONEXCLAMATION + MB_OK);
        Exit;
      end;
    end;


    // Traitement.
    TThreadProc.RunInThread(
      procedure
      begin
        Decouper;
      end
    ).whenError(
      procedure(aException: Exception)
      begin
        AjoutLog(aException.Message);
        Application.MessageBox(PChar(aException.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
      end
    ).RunAndWait;
  finally
    ProgressBarNoeuds.Position := 0;
    LabelNoeud.Caption := '';
    ProgressBar.Position := 0;
    LabelEtape.Caption := '';      LabelNbFichiers.Caption := '';
    PanelParametres.Enabled := True;
    _bTraitement := False;
    BtnDecouper.Caption := '&Découper';
    BtnDecouper.Enabled := True;
  end;
end;

procedure TMainForm.Decouper;
{$REGION 'Decouper'}
  procedure GetSousNoeudRacine(const sXMLTemp: String; const nNumFichier: Integer; out sXMLDest: String; out XMLDest: IXMLDocument; out SousNoeudRacine: IXMLNode);
  begin
    sXMLDest := IncludeTrailingPathDelimiter(EditRepertoireDest.Text) + TPath.GetFileNameWithoutExtension(EditFichierXML.Text) + '.' + IntToStr(nNumFichier) + '.xml';

    // Copie du fichier de travail.
    if CopyFile(PChar(sXMLTemp), PChar(sXMLDest), False) then
      AjoutLog('Création fichier [' + sXMLDest + ']')
    else
      raise Exception.Create('# Erreur :  la copie du fichier [' + sXMLTemp + ' >> ' + sXMLDest + '] a échoué :  ' + SysErrorMessage(GetLastError));

    XMLDest := TXMLDocument.Create(nil);
    try
      XMLDest.LoadFromFile(sXMLDest);

      SousNoeudRacine := XMLDest.DocumentElement;      // Premier noeud <document>.
      if Assigned(SousNoeudRacine) then
      begin
        if SousNoeudRacine.HasChildNodes then
        begin
          SousNoeudRacine := SousNoeudRacine.ChildNodes.First;      // Deuxième noeud <document>.
          if not SousNoeudRacine.HasChildNodes then
            raise Exception.Create('# Erreur :  le sous-noeud racine <document> n''a pas d''enfants !');
        end
        else
          raise Exception.Create('# Erreur :  le noeud racine <document> n''a pas d''enfants !');
      end
      else
        raise Exception.Create('# Erreur :  pas de noeud racine trouvé !');
    except
      on E: Exception do
      begin
        raise Exception.Create('# Erreur :  le chargement du fichier [' + sXMLDest + '] a échoué :' + #13#10 + E.Message);
      end;
    end;
  end;

  procedure AjoutNoeudEtAttributs(NoeudDest, Noeud: IXMLNode; out NoeudTmp: IXMLNode);
  var
    i: Integer;
  begin
    // Ajout du noeud et de ses attributs.
    NoeudTmp := NoeudDest.AddChild(Noeud.NodeName);
    for i:=0 to Pred(Noeud.AttributeNodes.Count) do
      NoeudTmp.SetAttributeNS(Noeud.AttributeNodes[i].NodeName, Noeud.AttributeNodes[i].NamespaceURI, Noeud.AttributeNodes[i].NodeValue);
    AjoutLog('   <' + Noeud.NodeName + '>');
  end;

  procedure NouveauFichier(var XMLDest: IXMLDocument; var sXMLDest: String; out SousNoeudRacineDest, NoeudDest: IXMLNode; const sXMLTemp: String; var nNumFichier: Integer; var Noeud: IXMLNode);
  begin
    if Assigned(XMLDest) then
    begin
      // Enregistrement du fichier.
      XMLDest.SaveToFile(sXMLDest);
      AjoutLog('Enregistrement fichier [' + sXMLDest + ']  ' + FormatFloat(',##0.###', Length(XMLDest.XML.Text) / 1000) + ' Ko.');
      XMLDest := nil;
      SousNoeudRacineDest := nil;      NoeudDest := nil;
    end;

    // Nouveau fichier.
    Inc(nNumFichier);
    GetSousNoeudRacine(sXMLTemp, nNumFichier, sXMLDest, XMLDest, SousNoeudRacineDest);
    if Assigned(SousNoeudRacineDest) then
    begin
      // Ajout du noeud et de ses attributs.
      AjoutNoeudEtAttributs(SousNoeudRacineDest, Noeud, NoeudDest);
    end
    else
      raise Exception.Create('# Erreur :  la recherche du sous-noeud racine destination [' + IntToStr(nNumFichier) + '] a échoué !');
  end;
{$ENDREGION}
var
  sXMLTemp, sXMLDest: String;
  XMLTmp, XMLSource, XMLDest: IXMLDocument;
  NoeudRacine, Noeud, NoeudTmp, SousNoeudRacineDest, NoeudDest: IXMLNode;
  nTempPrec: Cardinal;
  nNbNoeudsAvecLignes, nNoeud, nNumFichier, i: Integer;
  Flux: TStringStream;
begin
  AjoutLog('Début.');
  MajProgression(0, 0, '', 0, 'Copie ...', '');

  sXMLTemp := IncludeTrailingPathDelimiter(TPath.GetTempPath) + TPath.GetFileNameWithoutExtension(EditFichierXML.Text) + '_TMP.xml';
  if CopyFile(PChar(EditFichierXML.Text), PChar(sXMLTemp), False) then
    AjoutLog('Copie du fichier [' + EditFichierXML.Text + ' >> ' + sXMLTemp + ']')
  else
    raise Exception.Create('# Erreur :  la copie du fichier [' + EditFichierXML.Text + ' >> ' + sXMLTemp + '] a échoué :  ' + SysErrorMessage(GetLastError));
  MajProgression(0, 0, '', 0, 'Génération XML de travail ...', '');
  nNbNoeudsAvecLignes := 0;

  // Génération du fichier XML de travail.
  XMLTmp := TXMLDocument.Create(nil);
  try
    try
      XMLTmp.LoadFromFile(sXMLTemp);
      NoeudRacine := XMLTmp.DocumentElement;      // Premier noeud <document>.
      if Assigned(NoeudRacine) then
      begin
        if LowerCase(NoeudRacine.NodeName) <> 'document' then
          raise Exception.Create('# Erreur :  le noeud racine n''est pas <document> !');

        if NoeudRacine.HasChildNodes then
        begin
          NoeudRacine := NoeudRacine.ChildNodes.First;      // Deuxième noeud <document>.
          if LowerCase(NoeudRacine.NodeName) <> 'document' then
            raise Exception.Create('# Erreur :  le sous-noeud racine n''est pas <document> !');

          if NoeudRacine.HasChildNodes then
          begin
            Noeud := NoeudRacine.ChildNodes.First;

            // Parcours des noeuds.
            while Assigned(Noeud) do
            begin
              if(Noeud.HasAttribute('LastRow') and Noeud.HasAttribute('RowCount')) then
              begin
                // Si noeuds avec des lignes.
                if XmlStrToInt(Noeud.Attributes['RowCount'], 0) > 0 then
                  Inc(nNbNoeudsAvecLignes);

                // Suppression des noeuds.
                NoeudTmp := Noeud;
                Noeud := Noeud.NextSibling;
                NoeudRacine.ChildNodes.Remove(NoeudTmp);
                Continue;
              end;

              // Si traitement annulé.
              if _bAnnulerTraitement then
              begin
                AjoutLog('>> Traitement annulé par l''utilisateur.');
                Exit;
              end;

              Noeud := Noeud.NextSibling;
            end;
          end
          else
            raise Exception.Create('# Erreur :  le sous-noeud racine <document> n''a pas d''enfants !');
        end
        else
          raise Exception.Create('# Erreur :  le noeud racine <document> n''a pas d''enfants !');

        // Si taille max trop petite.
        if Length(XMLTmp.XML.Text) >= (SpinEditTailleMax.Value * 1000) then
          raise Exception.Create('# Erreur :  la taille maximum (' + IntToStr(SpinEditTailleMax.Value * 1000) + ') est inférieure à la taille du fichier de travail (' + IntToStr(Length(XMLTmp.XML.Text)) + ') !');

        XMLTmp.SaveToFile(sXMLTemp);
      end
      else
        raise Exception.Create('# Erreur :  pas de noeud racine trouvé !');
    except
      on E: Exception do
      begin
        raise Exception.Create('# Erreur :  la génération du fichier XML de travail [' + sXMLTemp + '] a échoué :' + #13#10 + E.Message);
      end;
    end;
  finally
    XMLTmp := nil;
  end;
  AjoutLog('Génération du fichier XML de travail [' + sXMLTemp + '].');
  MajProgression(0, nNbNoeudsAvecLignes, '', 100, 'Traitement ...', '');
  nTempPrec := GetTickCount;
  AjoutLog('Début traitement ...');

  // Traitement.
  nNumFichier := 0;      XMLDest := nil;      SousNoeudRacineDest := nil;
  XMLSource := TXMLDocument.Create(nil);
  Flux := TStringStream.Create('', System.SysUtils.TUTF8Encoding.Create);
  try
    try
      XMLSource.LoadFromFile(EditFichierXML.Text);
      NoeudRacine := XMLSource.DocumentElement;      // Premier noeud <document>.
      if NoeudRacine.HasChildNodes then
      begin
        NoeudRacine := NoeudRacine.ChildNodes.First;      // Deuxième noeud <document>.
        if NoeudRacine.HasChildNodes then
        begin
          Noeud := NoeudRacine.ChildNodes.First;
          nNoeud := 0;

          // Parcours des noeuds.
          while Assigned(Noeud) do
          begin
            // Si noeuds avec des lignes.
            if(Noeud.HasAttribute('LastRow') and Noeud.HasAttribute('RowCount') and (XmlStrToInt(Noeud.Attributes['RowCount'], 0) > 0)) then
            begin
              // Nouveau fichier.
              NouveauFichier(XMLDest, sXMLDest, SousNoeudRacineDest, NoeudDest, sXMLTemp, nNumFichier, Noeud);

              // Parcours des noeuds enfants.
              for i:=0 to Pred(Noeud.ChildNodes.Count) do
              begin
                if(GetTickCount - nTempPrec) > 1000 then
                begin
                  MajProgression(nNoeud, nNbNoeudsAvecLignes, '<' + Noeud.NodeName + '>   [' + FormatFloat(',##0', nNoeud + 1) + ' / ' + FormatFloat(',##0', nNbNoeudsAvecLignes) + ']', ((i + 1) * 100 div Noeud.ChildNodes.Count), 'Ajout des noeuds enfants [' + FormatFloat(',##0', i + 1) + ' / ' + FormatFloat(',##0', Noeud.ChildNodes.Count) + '] ...', FormatFloat(',##0', nNumFichier) + IfThen(nNumFichier > 1, ' fichiers', ' fichier'));
                  nTempPrec := GetTickCount;
                end;

                // Ajout du noeud enfant courant.
                NoeudDest.ChildNodes.Add(Noeud.ChildNodes[i]);

                Flux.Clear;
                XMLDest.SaveToStream(Flux);      // Flux utile uniquement pour accélérer le calcul de la taille de l'XML.

                // Si taille max atteinte.
                if Flux.Size >= (SpinEditTailleMax.Value * 1024) then
                begin
                  // Nouveau fichier.
                  NouveauFichier(XMLDest, sXMLDest, SousNoeudRacineDest, NoeudDest, sXMLTemp, nNumFichier, Noeud);
                end;

                // Si traitement annulé.
                if _bAnnulerTraitement then
                begin
                  AjoutLog('>> Traitement annulé par l''utilisateur.');
                  Exit;
                end;
              end;

              Inc(nNoeud);
            end;

            // Si traitement annulé.
            if _bAnnulerTraitement then
            begin
              AjoutLog('>> Traitement annulé par l''utilisateur.');
              Exit;
            end;

            Noeud := Noeud.NextSibling;
          end;
          MajProgression(nNbNoeudsAvecLignes, nNbNoeudsAvecLignes, '', 100, 'Fin traitement ...', FormatFloat(',##0', nNumFichier) + IfThen(nNumFichier > 1, ' fichiers', ' fichier'));

          if XMLDest <> nil then
          begin
            // Enregistrement du dernier fichier.
            XMLDest.SaveToFile(sXMLDest);
            AjoutLog('Enregistrement fichier [' + sXMLDest + ']  ' + FormatFloat(',##0.###', Length(XMLDest.XML.Text) / 1000) + ' Ko.');
          end;
        end
        else
          raise Exception.Create('# Erreur :  le sous-noeud racine <document> n''a pas d''enfants !');
      end
      else
        raise Exception.Create('# Erreur :  le noeud racine <document> n''a pas d''enfants !');
    except
      on E: Exception do
      begin
        AjoutLog('Erreur :  le traitement a échoué :' + #13#10 + E.Message);
      end;
    end;
  finally
    Flux.Free;
    XMLSource := nil;
    XMLDest := nil;
  end;

  if not DeleteFile(sXMLTemp) then
    raise Exception.Create('# Erreur :  la suppression du fichier XML de travail [' + sXMLTemp + '] a échoué :  ' + SysErrorMessage(GetLastError));

  AjoutLog('Fin.');
end;

function TMainForm.XmlStrToInt(Value: OleVariant; DefaultInt: Integer): Integer;
begin
  try
    if(not VarIsNull(Value)) and (not VarIsType(Value, varUnknown)) then
      Result := StrToIntDef(Trim(Value), DefaultInt)
    else
      Result := DefaultInt;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TMainForm.MajProgression(const nPositionNoeuds, nNbNoeuds: Integer; const sNoeud: String; const nPosition: Integer; const sEtape, sNbFichiers: String);
begin
  _Progression.nPositionNoeuds := nPositionNoeuds;
  _Progression.nNbNoeuds := nNbNoeuds;
  _Progression.sNoeud := sNoeud;
  _Progression.nPosition := nPosition;
  _Progression.sEtape := sEtape;
  _Progression.sNbFichiers := sNbFichiers;
  TThread.Synchronize(nil, AffProgression);
end;

procedure TMainForm.AffProgression;
begin
  ProgressBarNoeuds.Position := _Progression.nPositionNoeuds;
  ProgressBarNoeuds.Max := _Progression.nNbNoeuds;
  LabelNoeud.Caption := _Progression.sNoeud;
  ProgressBar.Position := _Progression.nPosition;
  LabelEtape.Caption := _Progression.sEtape;
  LabelNbFichiers.Caption := _Progression.sNbFichiers;
  Application.ProcessMessages;
end;

procedure TMainForm.AjoutLog(const sLigne: String; const bNouveau: Boolean);
begin
  TLog.Create(ExtractFilePath(Application.ExeName) + 'DecoupageFichiersXMLReplication.log', sLigne, bNouveau).Start;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  FichierINI: TIniFile;
begin
  DeleteCriticalSection(_SectionCritiqueLog);

  FichierINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'DecoupageFichiersXMLReplication.ini');
  try
    FichierINI.WriteInteger('Paramètres', 'Taille max', SpinEditTailleMax.Value);
    FichierINI.WriteString('Paramètres', 'Répertoire de destination', EditRepertoireDest.Text);
  finally
    FichierINI.Free;
  end;
end;

end.

