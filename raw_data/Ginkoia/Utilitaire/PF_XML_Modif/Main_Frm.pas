UNIT Main_Frm;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  RzShellDialogs,
  StdCtrls,
  Mask,
  RzEdit,
  RzBtnEdt,
  CheckLst,
  RzTabs,
  ExtCtrls,
  RzPanel,
  ImgList,
  RzButton,
  XMLCursor,
  StdXML_TLB,
  ActionRv;

TYPE
  TFrm_Main = CLASS(TForm)
    OD_Path: TRzSelectFolderDialog;
    Pan_Traitements: TRzPanel;
    Pan_Prov: TRzPanel;
    Ed_ProvName: TEdit;
    Ed_ProvXmlExtract: TEdit;
    Pan_ListeFolders: TRzPanel;
    Lab_Folders: TLabel;
    Lst_Folders: TCheckListBox;
    Pan_Top: TRzPanel;
    Pan_Left: TRzPanel;
    Pan_BaseFolder: TRzPanel;
    Lab_Path: TLabel;
    Ed_Path: TRzButtonEdit;
    Pan_XmlServices: TRzPanel;
    Lab_XmlModuleATraiter: TLabel;
    Lbx_XmlModule: TListBox;
    Ed_ModName: TEdit;
    Ed_ModXmlgram: TEdit;
    Lab_Modules: TLabel;
    Lab_Providers: TLabel;
    Lab_ModName: TLabel;
    Lab_ModXmlgram: TLabel;
    Lab_ProvName: TLabel;
    Lab_ProvXmlExtract: TLabel;
    Lab_ProvXmlBatch: TLabel;
    Ed_ProvXmlBatch: TEdit;
    Lab_ProvLastVersion: TLabel;
    Ed_ProvLastVersion: TEdit;
    Pan_Subscription: TRzPanel;
    Lab_TitreSub: TLabel;
    Lab_SubSubscription: TLabel;
    Lab_SubProv: TLabel;
    Lab_SubXMLServ: TLabel;
    Lab_SubLastV: TLabel;
    Ed_SubSubScription: TEdit;
    Ed_SubProvider: TEdit;
    Ed_SubBatch: TEdit;
    Ed_SubLastVersion: TEdit;
    Lab_SubSubscriber: TLabel;
    Ed_SubSubscriber: TEdit;
    Lim_Main: TImageList;
    Nbt_Prov: TRzBitBtn;
    Btn_ProvMaj: TRzBitBtn;
    Nbt_Mod: TRzBitBtn;
    Nbt_Sub: TRzBitBtn;
    Btn_MajSub: TRzBitBtn;
    Nbt_Quit: TRzBitBtn;
    Gax_All: TActionGroupRv;
    Lab_ProvLV: TLabel;
    Lab_SubLV: TLabel;
    Pan_LefTBot: TRzPanel;
    Pan_URL: TRzPanel;
    Lab_URL: TLabel;
    Ed_URLAv: TEdit;
    Lab_URLAv: TLabel;
    Lab_URLAp: TLabel;
    Ed_URLAp: TEdit;
    Nbt_URL: TRzBitBtn;
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Ed_PathButtonClick(Sender: TObject);
    PROCEDURE Ed_PathChange(Sender: TObject);
    PROCEDURE Ed_ModNameExit(Sender: TObject);
    PROCEDURE Btn_MajSubClick(Sender: TObject);
    PROCEDURE Btn_ProvMajClick(Sender: TObject);
    PROCEDURE Nbt_QuitClick(Sender: TObject);
    PROCEDURE Nbt_ModClick(Sender: TObject);
    PROCEDURE Nbt_ProvClick(Sender: TObject);
    PROCEDURE Nbt_SubClick(Sender: TObject);
    PROCEDURE Nbt_ToutAjouterClick(Sender: TObject);
    PROCEDURE Ed_SubSubScriptionExit(Sender: TObject);
    PROCEDURE Nbt_URLClick(Sender: TObject);
  PRIVATE
    PROCEDURE InitListeFolders;
    FUNCTION IsDossierEAI(APath: STRING): Boolean;
    PROCEDURE TraiterServices;
    PROCEDURE TraiterProviders; // voir pb en multi dossiers
    PROCEDURE TraiterSubscribers;
    PROCEDURE TraiterTout;
    PROCEDURE TraiterURL;
    { Déclarations privées }
  PUBLIC
    { Déclarations publiques }
  END;

VAR
  Frm_Main: TFrm_Main;

IMPLEMENTATION

{$R *.dfm}

PROCEDURE TFrm_Main.Btn_MajSubClick(Sender: TObject);
BEGIN
  Ed_SubSubScription.Text := UpperCase(Ed_SubSubScription.Text);
  Ed_SubProvider.Text := UpperCase(Ed_SubProvider.Text);
  Ed_SubSubscriber.Text := UpperCase(Ed_SubSubscriber.Text);

END;

PROCEDURE TFrm_Main.Btn_ProvMajClick(Sender: TObject);
BEGIN
  Ed_ProvName.Text := UpperCase(Ed_ProvName.Text);
END;

PROCEDURE TFrm_Main.Nbt_QuitClick(Sender: TObject);
BEGIN
  Close;
END;

PROCEDURE TFrm_Main.Nbt_SubClick(Sender: TObject);
BEGIN
  TraiterSubscribers;
END;

PROCEDURE TFrm_Main.Nbt_ToutAjouterClick(Sender: TObject);
BEGIN
  TraiterTout;
END;

PROCEDURE TFrm_Main.Nbt_URLClick(Sender: TObject);
BEGIN
  TraiterURL;
END;

PROCEDURE TFrm_Main.TraiterProviders;
VAR
  i: Integer;

  sPath: STRING;
  sFichXML: STRING;
  sTmp: STRING;
  sNomProv, sServiceExtractProv, sServiceBatchProv, sLastVerProv, sTmpLastVer: STRING;

  xmlDoc, xmlListeServ, xmlService: IXMLCursor;

  Group, Generator, MIN_ID, MAX_ID, URL, UserName, Password, Sender, Zip, Database, LAST_VERSION: STRING;

  bExisteDeja, bPremier, bOk: Boolean;
BEGIN
  Gax_All.Enabled := False;
  TRY
    sFichXML := 'DelosQPMAgent.Providers.xml';
    sNomProv := Ed_ProvName.Text;
    sServiceExtractProv := Ed_ProvXmlExtract.Text;
    sServiceBatchProv := Ed_ProvXmlBatch.Text;
    sLastVerProv := Ed_ProvLastVersion.Text;
    IF (sNomProv <> '') AND (sServiceExtractProv <> '') AND (sServiceBatchProv <> '') THEN
    BEGIN
      FOR I := 0 TO Lst_Folders.Count - 1 DO
      BEGIN
        // réinit apres chaque dossier
        bExisteDeja := False;
        sTmpLastVer := '';
        bPremier := True;
        IF Lst_Folders.Checked[I] THEN
        BEGIN
          sPath := IncludeTrailingPathDelimiter(Ed_Path.Text) + Lst_Folders.Items[I];
          sPath := IncludeTrailingPathDelimiter(sPath) + sFichXML;

          IF FileExists(sPath) THEN
          BEGIN
            CopyFile(PChar(sPath), PChar(ChangeFileExt(sPath, '.' + FormatDateTime('YYYYMMDDHHNNSS', Now) + '.sav')), False);
            xmlDoc := TXMLCursor.Create;
            TRY
              xmlDoc.Load(sPath);

              xmlListeServ := xmlDoc.Select('/Providers/Provider');

              WHILE NOT xmlListeServ.EOF DO
              BEGIN
                // Vérif s'il existe déjà ou non
                IF UpperCase(xmlListeServ.GetValue('Name')) = UpperCase(sNomProv) THEN
                BEGIN
                  bExisteDeja := True;

                  // Mise à jour du xmlgram dans ce cas
                  xmlListeServ.SetValue('XMLServiceExtract', sServiceExtractProv);
                  xmlListeServ.SetValue('XMLServiceBatch', sServiceBatchProv);
                  IF sLastVerProv <> '' THEN
                    xmlListeServ.SetValue('LAST_VERSION', sLastVerProv);

                  BREAK;
                END;
                IF bPremier THEN
                BEGIN
                  bPremier := False;

                  // Récup des infos
                  Group := xmlListeServ.GetValue('Group');
                  Generator := xmlListeServ.GetValue('Generator');
                  MIN_ID := xmlListeServ.GetValue('MIN_ID');
                  MAX_ID := xmlListeServ.GetValue('MAX_ID');
                  URL := xmlListeServ.GetValue('URL');
                  UserName := xmlListeServ.GetValue('UserName');
                  Password := xmlListeServ.GetValue('Password');
                  Sender := xmlListeServ.GetValue('Sender');
                  Zip := xmlListeServ.GetValue('Zip');
                  Database := xmlListeServ.GetValue('Database');
                END;

                TRY
                  IF sLastVerProv = '' THEN
                  BEGIN
                    LAST_VERSION := xmlListeServ.GetValue('LAST_VERSION');

                    IF LAST_VERSION = 'xx' THEN
                    BEGIN
                      sTmpLastVer := 'xx';
                      bOk := False;
                    END
                    ELSE BEGIN
                      bOk := False;
                      sTmp := xmlListeServ.GetValue('Name');
                      IF Pos('TRANSIMNUM_WEB', sTmp) = 0 THEN
                        IF Pos('GETMAGS_WEB', sTmp) = 0 THEN
                          IF Pos('WEBATIPIC', sTmp) = 0 THEN
                            IF Pos('BON_LOCATION', sTmp) = 0 THEN
                              bOk := True;

                    END;
                    IF bOk THEN
                    BEGIN
                      IF sTmpLastVer = '' THEN
                      BEGIN
                        sTmpLastVer := LAST_VERSION;
                      END
                      ELSE BEGIN
                        IF StrToInt(sTmpLastVer) > StrToInt(LAST_VERSION) THEN
                        BEGIN
                          sTmpLastVer := LAST_VERSION;
                        END;
                      END;
                    END;
                  END;
                FINALLY
                  xmlListeServ.Next;
                END;
              END;

              IF NOT bExisteDeja THEN
              BEGIN
                IF sLastVerProv = '' THEN
                  sLastVerProv := sTmpLastVer;

                xmlListeServ.First;

                // Ajout du service supplémentaire
                xmlService := xmlListeServ.InsertBefore('Provider', '');
                xmlService.SetValue('Name', sNomProv);
                xmlService.SetValue('Group', Group);
                xmlService.SetValue('Generator', Generator);
                xmlService.SetValue('MIN_ID', MIN_ID);
                xmlService.SetValue('MAX_ID', MAX_ID);
                xmlService.SetValue('LAST_VERSION', sLastVerProv);
                xmlService.SetValue('URL', URL);
                xmlService.SetValue('XMLServiceExtract', sServiceExtractProv);
                xmlService.SetValue('XMLServiceBatch', sServiceBatchProv);
                xmlService.SetValue('UserName', UserName);
                xmlService.SetValue('Password', Password);
                xmlService.SetValue('Sender', Sender);
                xmlService.SetValue('Zip', Zip);
                xmlService.SetValue('Database', Database);

              END;
              // Sauvegarde
              xmlDoc.Save(sPath);

            FINALLY
            END;
          END;
        END;
      END;
    END
    ELSE BEGIN
      ShowMessage('Veuillez renseigner tous les champs Provider');
    END;
  FINALLY
    Gax_All.Enabled := True;
  END;
END;

PROCEDURE TFrm_Main.TraiterServices;
VAR
  i: Integer;

  sPath: STRING;
  sFichXML: STRING;
  sNomServ, sXMLGramServ: STRING;

  xmlDoc, xmlListeServ, xmlService: IXMLCursor;

  bExisteDeja: Boolean;
BEGIN
  bExisteDeja := False;
  Gax_All.Enabled := False;
  TRY
    IF Lbx_XmlModule.ItemIndex >= 0 THEN
    BEGIN
      sFichXML := Lbx_XmlModule.Items[Lbx_XmlModule.ItemIndex];
      sNomServ := Ed_ModName.Text;
      sXMLGramServ := Ed_ModXmlgram.Text;

      IF (sNomServ <> '') AND (sXMLGramServ <> '') THEN
      BEGIN
        FOR I := 0 TO Lst_Folders.Count - 1 DO
        BEGIN
          // réinit apres chaque dossier
          bExisteDeja := False;
          IF Lst_Folders.Checked[I] THEN
          BEGIN
            sPath := IncludeTrailingPathDelimiter(Ed_Path.Text) + Lst_Folders.Items[I];
            sPath := IncludeTrailingPathDelimiter(sPath) + sFichXML;

            IF FileExists(sPath) THEN
            BEGIN
              CopyFile(PChar(sPath), PChar(ChangeFileExt(sPath, '.' + FormatDateTime('YYYYMMDDHHNNSS', Now) + '.sav' )), False);
              xmlDoc := TXMLCursor.Create;
              TRY
                xmlDoc.Load(sPath);

                xmlListeServ := xmlDoc.Select('/XMLServices/XMLService');

                WHILE NOT xmlListeServ.EOF DO
                BEGIN
                  // Vérif s'il existe déjà ou non
                  IF UpperCase(xmlListeServ.GetValue('Name')) = UpperCase(sNomServ) THEN
                  BEGIN
                    bExisteDeja := True;

                    // Mise à jour du xmlgram dans ce cas
                    xmlListeServ.SetValue('XMLGram', sXMLGramServ);
                    BREAK;
                  END;

                  xmlListeServ.Next;
                END;

                IF NOT bExisteDeja THEN
                BEGIN

                  xmlListeServ.First;

                  // Ajout du service supplémentaire
                  xmlService := xmlListeServ.InsertBefore('XMLService', '');
                  xmlService.SetValue('Name', sNomServ);
                  xmlService.SetValue('NextAction', '');
                  xmlService.SetValue('PreXSL', '');
                  xmlService.SetValue('Scope', 'Public');
                  xmlService.SetValue('XMLGram', sXMLGramServ);
                  xmlService.SetValue('XSL', '');
                END;
                // Sauvegarde
                xmlDoc.Save(sPath);

              FINALLY
              END;
            END;
          END;
        END;
      END
      ELSE BEGIN
        ShowMessage('Veuillez renseigner le nom du service, et son xmlgram');
      END;
    END
    ELSE BEGIN
      ShowMessage('Veuillez choisir un fichier XMLServices');
    END;
  FINALLY
    Gax_All.Enabled := True;
  END;
END;

PROCEDURE TFrm_Main.TraiterSubscribers;
VAR
  i: Integer;

  sPath: STRING;
  sFichXML: STRING;
  sTmp: STRING;
  sNomSubN, sNomSubR, sNomProv, sServiceBatchSub, sLastVerSub, sTmpLastVer: STRING;

  xmlDoc, xmlListeServ, xmlService: IXMLCursor;

  Sender, URL, UserName, Password, Zip, Database, GetCurrentVersion, Generator, Group, LAST_VERSION: STRING;

  bExisteDeja, bPremier, bOk: Boolean;
BEGIN
  bExisteDeja := False;
  sTmpLastVer := '';
  bPremier := True;
  Gax_All.Enabled := False;
  TRY
    sFichXML := 'DelosQPMAgent.Subscriptions.xml';
    sNomSubN := Ed_SubSubScription.Text;
    sNomSubR := Ed_SubSubscriber.Text;
    sNomProv := Ed_SubProvider.Text;
    sServiceBatchSub := Ed_SubBatch.Text;
    sLastVerSub := Ed_SubLastVersion.Text;

    IF (sNomSubN <> '') AND (sNomSubR <> '') AND (sNomProv <> '') AND (sServiceBatchSub <> '') THEN
    BEGIN
      FOR I := 0 TO Lst_Folders.Count - 1 DO
      BEGIN
        // réinit apres chaque dossier
        bExisteDeja := False;
        sTmpLastVer := '';
        bPremier := True;
        IF Lst_Folders.Checked[I] THEN
        BEGIN
          sPath := IncludeTrailingPathDelimiter(Ed_Path.Text) + Lst_Folders.Items[I];
          sPath := IncludeTrailingPathDelimiter(sPath) + sFichXML;

          IF FileExists(sPath) THEN
          BEGIN
            CopyFile(PChar(sPath), PChar(ChangeFileExt(sPath, '.' + FormatDateTime('YYYYMMDDHHNNSS', Now) + '.sav')), False);
            xmlDoc := TXMLCursor.Create;
            TRY
              xmlDoc.Load(sPath);

              xmlListeServ := xmlDoc.Select('/Subscriptions/Subscription');

              WHILE NOT xmlListeServ.EOF DO
              BEGIN
                // Vérif s'il existe déjà ou non
                IF UpperCase(xmlListeServ.GetValue('Subscription')) = UpperCase(sNomSubN) THEN
                BEGIN
                  bExisteDeja := True;

                  // Mise à jour du xmlgram dans ce cas
                  xmlListeServ.SetValue('Provider', sNomProv);
                  xmlListeServ.SetValue('Subscriber', sNomSubR);
                  xmlListeServ.SetValue('XMLServiceBatch', sServiceBatchSub);
                  IF sLastVerSub <> '' THEN
                    xmlListeServ.SetValue('LAST_VERSION', sLastVerSub);

                  BREAK;
                END;
                IF bPremier THEN
                BEGIN
                  bPremier := False;

                  // Récup des infos
                  Group := xmlListeServ.GetValue('Group');
                  Generator := xmlListeServ.GetValue('Generator');
                  URL := xmlListeServ.GetValue('URL');
                  UserName := xmlListeServ.GetValue('UserName');
                  Password := xmlListeServ.GetValue('Password');
                  Sender := xmlListeServ.GetValue('Sender');
                  Zip := xmlListeServ.GetValue('Zip');
                  Database := xmlListeServ.GetValue('Database');
                  GetCurrentVersion := xmlListeServ.GetValue('GetCurrentVersion');
                END;
                // , GETMAGS_WEB_,  ,
                LAST_VERSION := xmlListeServ.GetValue('LAST_VERSION');
                TRY
                  IF sLastVerSub = '' THEN
                  BEGIN
                    IF LAST_VERSION = 'xx' THEN
                    BEGIN
                      sTmpLastVer := 'xx';
                      bOk := False;
                    END
                    ELSE BEGIN
                      bOk := False;
                      sTmp := xmlListeServ.GetValue('Subscription');
                      IF Pos('TRANSIMNUM_WEB', sTmp) = 0 THEN
                        IF Pos('GETMAGS_WEB', sTmp) = 0 THEN
                          IF Pos('WEBATIPIC', sTmp) = 0 THEN
                            IF Pos('BON_LOCATION', sTmp) = 0 THEN
                              bOk := True;
                    END;

                    IF bOk THEN
                    BEGIN
                      IF sTmpLastVer = '' THEN
                      BEGIN
                        sTmpLastVer := LAST_VERSION;
                      END
                      ELSE BEGIN
                        IF StrToInt(sTmpLastVer) > StrToInt(LAST_VERSION) THEN
                        BEGIN
                          sTmpLastVer := LAST_VERSION;
                        END;
                      END;
                    END;
                  END;
                FINALLY
                  xmlListeServ.Next;
                END;
              END;

              IF NOT bExisteDeja THEN
              BEGIN
                IF sLastVerSub = '' THEN
                  sLastVerSub := sTmpLastVer;

                xmlListeServ.First;

                // Ajout du service supplémentaire
                xmlService := xmlListeServ.InsertBefore('Subscription', '');
                xmlService.SetValue('Subscription', sNomSubN);
                xmlService.SetValue('Provider', sNomProv);
                xmlService.SetValue('Subscriber', sNomSubR);
                xmlService.SetValue('Sender', Sender);
                xmlService.SetValue('LAST_VERSION', sLastVerSub);
                xmlService.SetValue('URL', URL);
                xmlService.SetValue('UserName', UserName);
                xmlService.SetValue('Password', Password);
                xmlService.SetValue('XMLServiceBatch', sServiceBatchSub);
                xmlService.SetValue('Zip', Zip);
                xmlService.SetValue('Database', Database);
                xmlService.SetValue('GetCurrentVersion', GetCurrentVersion);
                xmlService.SetValue('Generator', Generator);
                xmlService.SetValue('Group', Group);

              END;
              // Sauvegarde
              xmlDoc.Save(sPath);

            FINALLY
            END;
          END;
        END;
      END;
    END
    ELSE BEGIN
      ShowMessage('Veuillez renseigner tous les champs Subscriptions');
    END;
  FINALLY
    Gax_All.Enabled := True;
  END;
END;

PROCEDURE TFrm_Main.TraiterTout;
VAR
  sMsg: STRING;
BEGIN
  sMsg := 'Veuillez renseigner :';
  IF Lbx_XmlModule.ItemIndex < 0 THEN
    sMsg := sMsg + #13#10 + ' - Un fichier XMLServices';

  IF (Ed_ModName.Text = '') OR (Ed_ModXmlgram.Text = '') THEN
    sMsg := sMsg + #13#10 + ' - Le nom du service, et son xmlgram';

  IF (Ed_ProvName.Text = '') OR (Ed_ProvXmlExtract.Text = '') OR (Ed_ProvXmlBatch.Text = '') THEN
    sMsg := sMsg + #13#10 + ' - Tous les champs Providers';

  IF (Ed_SubSubScription.Text = '') OR (Ed_SubSubscriber.Text = '') OR (Ed_SubProvider.Text = '') OR (Ed_SubBatch.Text = '') THEN
    sMsg := sMsg + #13#10 + ' - Tous les champs Subscriptions';

END;

PROCEDURE TFrm_Main.TraiterURL;
VAR
  i: Integer;

  sPath: STRING;
  sFichXMLProv, sFichXMLSub: STRING;
  sTmp: STRING;

  xmlDoc, xmlListeServ: IXMLCursor;

  sURLAvant, sURLApres: STRING;
  sURLXml: STRING;
  iPosUrl: Integer;
BEGIN
  Gax_All.Enabled := False;
  TRY
    sFichXMLProv := 'DelosQPMAgent.Providers.xml';
    sFichXMLSub := 'DelosQPMAgent.Subscriptions.xml';
    sURLAvant := Ed_URLAv.Text;
    sURLApres := Ed_URLAp.Text;
    IF (sURLAvant <> '') AND (sURLApres <> '') THEN
    BEGIN
      FOR I := 0 TO Lst_Folders.Count - 1 DO
      BEGIN
        IF Lst_Folders.Checked[I] THEN
        BEGIN
          sPath := IncludeTrailingPathDelimiter(Ed_Path.Text) + Lst_Folders.Items[I];
          sPath := IncludeTrailingPathDelimiter(sPath) + sFichXMLProv;

          IF FileExists(sPath) THEN
          BEGIN
            CopyFile(PChar(sPath), PChar(ChangeFileExt(sPath, '.' + FormatDateTime('YYYYMMDDHHNNSS', Now) + '.sav')), False);
            xmlDoc := TXMLCursor.Create;
            TRY
              xmlDoc.Load(sPath);
              xmlListeServ := xmlDoc.Select('/Providers/Provider');
              WHILE NOT xmlListeServ.EOF DO
              BEGIN
                sURLXml := xmlListeServ.GetValue('URL');
                iPosUrl := Pos(sURLAvant, sURLXml);
                IF iPosUrl > 0 THEN
                BEGIN
                  sURLXml := StringReplace(sURLXml, sURLAvant, sURLApres, [rfIgnoreCase]);
                  xmlListeServ.SetValue('URL', sURLXml);
                END;

                xmlListeServ.Next;
              END;
              // Sauvegarde
              xmlDoc.Save(sPath);

            FINALLY
            END;
          END;

          sPath := IncludeTrailingPathDelimiter(Ed_Path.Text) + Lst_Folders.Items[I];
          sPath := IncludeTrailingPathDelimiter(sPath) + sFichXMLSub;
          IF FileExists(sPath) THEN
          BEGIN
            CopyFile(PChar(sPath), PChar(ChangeFileExt(sPath, '.' + FormatDateTime('YYYYMMDDHHNNSS', Now) + '.sav')), False);
            xmlDoc := TXMLCursor.Create;
            TRY
              xmlDoc.Load(sPath);
              xmlListeServ := xmlDoc.Select('/Subscriptions/Subscription');
              WHILE NOT xmlListeServ.EOF DO
              BEGIN
                sURLXml := xmlListeServ.GetValue('URL');
                iPosUrl := Pos(sURLAvant, sURLXml);
                IF iPosUrl > 0 THEN
                BEGIN
                  sURLXml := StringReplace(sURLXml, sURLAvant, sURLApres, [rfIgnoreCase]);
                  xmlListeServ.SetValue('URL', sURLXml);
                END;

                sURLXml := xmlListeServ.GetValue('GetCurrentVersion');
                iPosUrl := Pos(sURLAvant, sURLXml);
                IF iPosUrl > 0 THEN
                BEGIN
                  sURLXml := StringReplace(sURLXml, sURLAvant, sURLApres, [rfIgnoreCase]);
                  xmlListeServ.SetValue('GetCurrentVersion', sURLXml);
                END;

                xmlListeServ.Next;
              END;
              // Sauvegarde
              xmlDoc.Save(sPath);

            FINALLY
            END;
          END;

        END;
      END;
    END
    ELSE BEGIN
      ShowMessage('Veuillez renseigner tous les champs pour modifier l''URL');
    END;
  FINALLY
    Gax_All.Enabled := True;
  END;
END;

PROCEDURE TFrm_Main.Nbt_ModClick(Sender: TObject);
BEGIN
  TraiterServices;
END;

PROCEDURE TFrm_Main.Nbt_ProvClick(Sender: TObject);
BEGIN
  TraiterProviders;
END;

PROCEDURE TFrm_Main.Ed_ModNameExit(Sender: TObject);
BEGIN
  IF Ed_ModXmlgram.Text = '' THEN
    Ed_ModXmlgram.Text := Ed_ModName.Text + '.xmlgram';
END;

PROCEDURE TFrm_Main.Ed_PathButtonClick(Sender: TObject);
BEGIN
  //  Od_Path.BaseFolder := Ed_Path.Text;
  Od_Path.SelectedPathName := Ed_Path.Text;
  IF Od_Path.Execute THEN
    Ed_Path.Text := Od_Path.SelectedPathName;
END;

PROCEDURE TFrm_Main.Ed_PathChange(Sender: TObject);
BEGIN
  InitListeFolders;
END;

PROCEDURE TFrm_Main.Ed_SubSubScriptionExit(Sender: TObject);
BEGIN
  Ed_SubSubScription.Text := Ed_SubSubScription.Text;
  Ed_SubProvider.Text := Ed_SubSubScription.Text;
  Ed_SubSubscriber.Text := Copy(Ed_SubSubScription.Text, 1, Length(Ed_SubSubScription.Text) - 1);
  Ed_SubBatch.Text := StringReplace(Ed_SubSubScription.Text, '_', '', [rfReplaceAll]) + 'Batch';
END;

PROCEDURE TFrm_Main.FormCreate(Sender: TObject);
BEGIN
  Ed_Path.Text := ExtractFilePath(Application.ExeName);
END;

PROCEDURE TFrm_Main.InitListeFolders;
VAR
  myFile: TSearchRec;
  Found: Integer;
  sFolder: STRING;
BEGIN
  Lst_Folders.Clear;
  Lbx_XmlModule.Clear;
  sFolder := IncludeTrailingPathDelimiter(Ed_Path.Text);
  Found := FindFirst(sFolder + '*.', faDirectory, myFile);
  WHILE Found = 0 DO
  BEGIN
    IF (MyFile.Name <> '.') AND (MyFile.Name <> '..') THEN
    BEGIN
      Lst_Folders.Items.Add(MyFile.Name);
      // Vérif si dossier EAI et met à jour les listes
      IF IsDossierEAI(sFolder + MyFile.Name) THEN
      BEGIN
        Lst_Folders.Checked[Lst_Folders.Items.Count - 1] := True;
      END;
    END;
    Found := FindNext(myFile);
  END;
  FindClose(myFile);
END;

FUNCTION TFrm_Main.IsDossierEAI(APath: STRING): Boolean;
VAR
  theFile: TSearchRec;
  Found: Integer;
BEGIN
  Found := FindFirst(IncludeTrailingPathDelimiter(APath) + '*.XMLServices.xml', faAnyFile, theFile);
  Result := (Found = 0);

  WHILE Found = 0 DO
  BEGIN
    IF (theFile.Name <> '.') AND (theFile.Name <> '..') THEN
    BEGIN
      // Vérif si dossier EAI et met à jour les listes
      IF Lbx_XmlModule.Items.IndexOf(theFile.Name) = -1 THEN
      BEGIN
        Lbx_XmlModule.Items.Add(theFile.Name);
      END;
    END;
    Found := FindNext(theFile);
  END;
  FindClose(theFile);
END;

END.

