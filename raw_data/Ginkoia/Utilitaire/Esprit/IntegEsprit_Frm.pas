//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT IntegEsprit_Frm;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  AlgolStdFrm,
  LMDControl,
  LMDBaseControl,
  LMDBaseGraphicButton,
  LMDCustomSpeedButton,
  LMDSpeedButton,
  ExtCtrls,
  RzPanel,
  fcStatusBar,
  RzBorder,
  LMDCustomComponent,
  LMDWndProcComponent,
  LMDFormShadow,
  //    Psock,
  //    NMpop3,
  Db,
  IBODataset,
  StdCtrls,
  RzLabel,
  dxmdaset,
  IB_Components,
  ActionRv,
  ComCtrls,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdExplicitTLSClientServerBase,
  IdMessageClient,
  IdPOP3,
  IdMessage,
  IdAttachment,
  IdAttachmentFile;

TYPE
  TFrm_IntegEsprit = CLASS(TAlgolStdFrm)
    Que_Mail: TIBOQuery;
    Que_MailPRM_ID: TIntegerField;
    Que_MailPRM_CODE: TIntegerField;
    Que_MailPRM_INTEGER: TIntegerField;
    Que_MailPRM_FLOAT: TIBOFloatField;
    Que_MailPRM_STRING: TStringField;
    Que_MailPRM_TYPE: TIntegerField;
    Que_MailPRM_MAGID: TIntegerField;
    Que_MailPRM_INFO: TStringField;
    Que_MailPRM_POS: TIntegerField;
    memd: TdxMemData;
    memddatatype: TStringField;
    memdean: TStringField;
    memddescription: TStringField;
    memdPxVente: TStringField;
    memdStylenumber: TStringField;
    memdStylecolor: TStringField;
    memdStyleColorDescription: TStringField;
    memdtaille: TStringField;
    memdSaison: TStringField;
    memdDivision: TStringField;
    memdProductClass: TStringField;
    memdPxAchat: TStringField;
    memdsaisonYear: TStringField;
    memdISS: TStringField;
    memdSSP: TStringField;
    memdCmd: TStringField;
    memdNumberCMD: TStringField;
    memdorderNumber: TStringField;
    memdDateInvoice: TStringField;
    memdDateOrder: TStringField;
    memdCodeclient: TStringField;
    memddeliveryloc: TStringField;
    Que_Magasin: TIBOQuery;
    Que_NoPJ: TIBOQuery;
    Que_Param: TIBOQuery;
    IbC_Script: TIB_Cursor;
    Que_ArtArti: TIBOQuery;
    Que_ARTREFERENCE: TIBOQuery;
    Que_Taille: TIBOQuery;
    Que_TailleTrav: TIBOQuery;
    Que_Couleur: TIBOQuery;
    Que_CBEsprit: TIBOQuery;
    Que_CBGinkoia: TIBOQuery;
    Que_Tarclgfourn: TIBOQuery;
    Que_PXVente: TIBOQuery;
    Que_TVA: TIBOQuery;
    Que_ArtRef: TIBOQuery;
    MemD_TVA: TdxMemData;
    MemD_TVATXTVA: TStringField;
    MemD_TVAQuantite: TStringField;
    MemD_TVAPXAchat: TStringField;
    IbC_Que_UpdateCommande: TIB_Cursor;
    IbC_Art: TIB_Cursor;
    Grd_Close: TGroupDataRv;
    PB: TProgressBar;
    RzLabel2: TRzLabel;
    IdPOP3: TIdPOP3;
    IdMessage1: TIdMessage;
    Que_OrdreAff: TIBOQuery;
    Que_OrdreAffMAXORDREAFF: TIBOFloatField;
    PROCEDURE Nbt_PostClick(Sender: TObject);
    PROCEDURE Nbt_CancelClick(Sender: TObject);
    PROCEDURE AlgolStdFrmCreate(Sender: TObject);
    //        procedure popDecodeStart(var FileName: string);
    PROCEDURE GenerikAfterCancel(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel2(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost2(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete2(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord2(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord2(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel3(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost3(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete3(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord3(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord3(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel4(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost4(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete4(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord4(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord4(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel5(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost5(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete5(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord5(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord5(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel6(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost6(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete6(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord6(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord6(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel7(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost7(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete7(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord7(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord7(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel8(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost8(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete8(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord8(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord8(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel9(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost9(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete9(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord9(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord9(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel10(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost10(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete10(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord10(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord10(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel11(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost11(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete11(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord11(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord11(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel12(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost12(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete12(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord12(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord12(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel13(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost13(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete13(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord13(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord13(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel14(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost14(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete14(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord14(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord14(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel15(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost15(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete15(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord15(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord15(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel16(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost16(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete16(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord16(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord16(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel17(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost17(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete17(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord17(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord17(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel18(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost18(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete18(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord18(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord18(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel19(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost19(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete19(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord19(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord19(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel20(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost20(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete20(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord20(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord20(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel21(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost21(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete21(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord21(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord21(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE GenerikAfterCancel22(DataSet: TDataSet);
    PROCEDURE GenerikAfterPost22(DataSet: TDataSet);
    PROCEDURE GenerikBeforeDelete22(DataSet: TDataSet);
    PROCEDURE GenerikNewRecord22(DataSet: TDataSet);
    PROCEDURE GenerikUpdateRecord22(DataSet: TDataSet;
      UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
    PROCEDURE AlgolStdFrmCloseQuery(Sender: TObject;
      VAR CanClose: Boolean);

  PRIVATE
    UserCanModify, UserVisuMags: Boolean;
    piecejointe, NoMagasin: STRING;
    numcdefirst, numcdelast: STRING;
    nbcde: integer;

    sPath, sPathEsprit, sPathIntegre, sPathRapport: STRING;

    PROCEDURE traitement;
    FUNCTION TraitementPieceJointe(nompiece: STRING): boolean;
    FUNCTION CentineToEntier(Num: STRING): STRING;
    PROCEDURE ValideCommande(MemD_TVA: TdxMemData; CDE_ID, CDE_NUM: STRING);
    PROCEDURE ValidePieceJoint(CDE_ID, NomPJ: STRING);
    //        procedure RapportPJ(memD_Rapport: TdxMemData; NumComm, LigneComm, Erreur, Motif: string);
            { Private declarations }
  PROTECTED
    { Protected declarations }
  PUBLIC
    { Public declarations }
  PUBLISHED

  END;

FUNCTION ExecuteIntegEsprit: Boolean;

IMPLEMENTATION
{$R *.DFM}
USES
  StdUtils,
  GinkoiaStd,
  GinkoiaResStr,
  FileCtrl,
  DlgStd_Frm,
  GaugeMess_Frm,
  Main_Dm,
  IntegMail_Dm,
  upost;

FUNCTION ExecuteIntegEsprit: Boolean;

VAR
  Frm_IntegEsprit: TFrm_IntegEsprit;
BEGIN
  Result := False;
  Application.createform(TFrm_IntegEsprit, Frm_IntegEsprit);
  frm_IntegEsprit.height := 150;
  WITH Frm_IntegEsprit DO
  BEGIN
    TRY
      Traitement;

    FINALLY
      Free;
    END;
  END;
END;

PROCEDURE TFrm_IntegEsprit.AlgolStdFrmCreate(Sender: TObject);
BEGIN
  TRY
    screen.Cursor := crSQLWait;
    Hint := Caption;
    StdGinkoia.AffecteHintEtBmp(self);
    UserVisuMags := StdGinkoia.UserVisuMags;
    UserCanModify := StdGinkoia.UserCanModify('YES_PAR_DEFAUT');
  FINALLY
    screen.Cursor := crDefault;
  END;
END;

PROCEDURE TFrm_IntegEsprit.Nbt_PostClick(Sender: TObject);
BEGIN
  ModalResult := mrOk;
END;

PROCEDURE TFrm_IntegEsprit.Nbt_CancelClick(Sender: TObject);
BEGIN
  ModalResult := mrCancel;
END;

PROCEDURE TFrm_IntegEsprit.Traitement;
VAR
  port: STRING;
  i, j, k: integer;
  //    TempStringConnect, nompiece: string;
  nomrap: STRING;
  tls: tstringlist;
  sPath, sPathEsprit, sPathIntegre, sPathRapport: STRING;
  sFileName: STRING;
  iCheckMessages: Integer;
  sMessage: STRING;
BEGIN

  //*** test    TempStringConnect := ExtractFilePath(Application.ExeName) + 'CommandesEsprit';
  //*** test     nompiece := TempStringConnect;
  nbcde := 0;
  que_mail.open;
  que_mail.first;
  IF que_mail.locate('prm_code', 10001, []) THEN IdPOP3.Username := Que_MailPRM_STRING.asstring;
  IF que_mail.locate('prm_code', 10002, []) THEN IdPOP3.Password := Que_MailPRM_STRING.asstring;
  IF que_mail.locate('prm_code', 10003, []) THEN IdPOP3.Host := Que_MailPRM_STRING.asstring;
  IF que_mail.locate('prm_code', 10004, []) THEN IdPOP3.Port := StrToIntDef(Que_MailPRM_STRING.AsString, 110);
  que_mail.close;

  {    try
          if port = '' then
              IdPOP3.Port := 110
          else
              IdPOP3.Port := strtoint(port);
      except
          IdPOP3.Port := 110;
      end;    }

  sPath := ExtractFilePath(Application.ExeName);
  sPathEsprit := sPath + 'CommandesEsprit\';
  sPathIntegre := sPath + 'CommandesEsprit\Integre\';
  sPathRapport := sPath + 'CommandesEsprit\Rapport\';

  ForceDirectories(sPathEsprit);
  ForceDirectories(sPathIntegre);
  ForceDirectories(sPathRapport);

  WITH IdPop3 DO
  BEGIN
    ShowMessHP('Connection à la boite mail en cours', true, 0, 0, '');
    screen.Cursor := crSQLWait;
    TRY
      Connect;
    EXCEPT ON E: Exception DO
      BEGIN
        ShowCloseHP;
        StdGinKoia.DelayMess('La connection à la boite mail a échoué...', 3);
        Exit;
      END;
    END; // try
    ShowCloseHP;

    iCheckMessages := IdPop3.CheckMessages;
    // Mise à 0 des compteurs du nombre de rayon et de sous famille
    Dm_IntegMail.NbRayon := 0;
    Dm_IntegMail.NbSSFamille := 0;
    // Mise à 0 du composant Rapport
    Dm_IntegMail.MemD_SSFamille.Close;

    sMessage := '';
    TRY
      FOR i := 1 TO iCheckMessages DO
      BEGIN
        // Récupération du mail
        TRY
          Retrieve(i, IdMessage1);
        EXCEPT ON E: Exception DO
          BEGIN
            InfoMessHP('Problème de connexion à la boite @mail, veuillez relancer le traitement', True, 0, 0, 'Erreur Mail');
            //  + E.Message
            Exit;
          END;
        END;

        // Vérification du sujet du mail
        IF UpperCase(Trim(IdMessage1.Subject)) = UpperCase('Order data ASCII-Format') THEN
          IF IdMessage1.MessageParts.Count > 0 THEN
          BEGIN
            FOR k := 0 TO IdMessage1.MessageParts.Count - 1 DO
            BEGIN
              IF IdMessage1.MessageParts.Items[k] IS TIdAttachment THEN
              BEGIN
                // sauvegarde de la piece jointe dans sPathEsprit
                sFileName := TIdAttachment(IdMessage1.MessageParts.Items[k]).FileName;
                IF FileExists(sPathEsprit + sFileName) THEN
                  DeleteFile(sPathEsprit + sFileName);

                TIdAttachment(IdMessage1.MessageParts.Items[k]).SaveToFile(sPathEsprit + sFileName);
                IF TraitementPieceJointe(sPathEsprit + sFileName) THEN
                BEGIN
                  movefileex(pchar(sPathEsprit + sFileName), pchar(sPathIntegre + sFileName), MOVEFILE_REPLACE_EXISTING);
                END
                ELSE
                BEGIN
                  deletefile(sPathEsprit + sFileName);
                END;

                WITH Dm_IntegMail DO
                  IF memd_rapport.recordcount <> 0 THEN
                  BEGIN
                    //Sauvegarde du rapport
                    nomrap := datetimetostr(now);
                    j := pos('/', nomrap);
                    WHILE j <> 0 DO
                    BEGIN
                      System.delete(nomrap, j, 1);
                      j := pos('/', nomrap);
                    END;
                    j := pos(':', nomrap);
                    WHILE j <> 0 DO
                    BEGIN
                      System.delete(nomrap, j, 1);
                      j := pos(':', nomrap);
                    END;
                    nomrap := copy(nomrap, 5, 4) + copy(nomrap, 3, 2) + copy(nomrap, 1, 2) + copy(nomrap, 9, 7);
                    memd_rapport.DelimiterChar := #9;
                    memd_rapport.SaveToTextFile(sPathRapport + 'Rapp' + nomrap + '.txt');
                    tls := TStringList.Create;
                    TRY
                      tls.loadfromFile(sPathRapport + 'Rapp' + nomrap + '.txt');
                      sendmail('esprit@ginkoia.fr', 'esprit@ginkoia.fr', 'Rapport ' + NoMagasin + ' ' + sFileName, tls.text);
                    FINALLY
                      tls.Free;
                    END;
                    memd_rapport.close;
                    memd_rapport.open;
                  END;
              END;
            END; // for j
          END; // if
        PB.Position := i * 100 DIV iCheckMessages;
        Application.ProcessMessages;
      END; // for i
    FINALLY
      screen.Cursor := crdefault;
    END;
  END; //With

  //   pop.attachfilepath := ExtractFilePath(Application.ExeName) + 'CommandesEsprit';

 //    pb.max := POP.MailCount;
 //    for i := 1 to POP.MailCount do
 //
 //
 //    begin
 //        pb.Position := pb.Position + 1;
 //        POP.GetSummary(i);
 //        try
 //            if trim(POP.Summary.Subject) = 'Order data ASCII-Format' then
 //            begin
 //                POP.GetMailMessage(i);
 //                if TraitementPieceJointe(pop.attachfilepath + piecejointe) then
 //                    //*** test        IF TraitementPieceJointe(nompiece + '\EDC84340.TXT') THEN
 //                begin
 //                    movefileex(pchar(pop.attachfilepath + piecejointe), pchar(pop.attachfilepath + 'Integre\' + piecejointe), MOVEFILE_REPLACE_EXISTING);
 //                end
 //                else
 //                begin
 //                    deletefile(pop.attachfilepath + piecejointe);
 //                end;
 //
 //                //Gestion du rapport
 //                if memd_rapport.recordcount <> 0 then
 //                begin
 //                    //Sauvegarde du rapport
 //                    nomrap := datetimetostr(now);
 //                    j := pos('/', nomrap);
 //                    while j <> 0 do
 //                    begin
 //                        delete(nomrap, j, 1);
 //                        j := pos('/', nomrap);
 //                    end;
 //                    j := pos(':', nomrap);
 //                    while j <> 0 do
 //                    begin
 //                        delete(nomrap, j, 1);
 //                        j := pos(':', nomrap);
 //                    end;
 //                    nomrap := copy(nomrap, 5, 4) + copy(nomrap, 3, 2) + copy(nomrap, 1, 2) + copy(nomrap, 9, 7);
 //                    memd_rapport.DelimiterChar := #9;
 //                    memd_rapport.SaveToTextFile(pop.attachfilepath + 'Integre\Rapp' + nomrap + '.txt');
 //                    tls := tstringlist.create;
 //                    tls.loadfromFile(pop.attachfilepath + 'Integre\Rapp' + nomrap + '.txt');
 //                    sendmail('esprit@ginkoia.fr', 'esprit@ginkoia.fr', 'Rapport ' + NoMagasin + ' ' + piecejointe, tls.text);
 //                    tls.free;
 //                    memd_rapport.close;
 //                    memd_rapport.open;
 //                end;
 //            end
 //
 //        finally
 //        end;
 //    end;
 //    //CloseGaugeMessHP;
 //    pop.Disconnect;

  IF nbcde <> 0 THEN
  BEGIN
    IF nbcde = 1 THEN
      sMessage := 'Traitement terminé...' + #10 + #13 + #10 + #13 + '(' + '1 commande créée : ' + numcdefirst + ')'
    ELSE
      sMessage := 'Traitement terminé...' + #10 + #13 + #10 + #13 + '(' + inttostr(nbcde) + ' commandes créées : ' + numcdefirst + ' à ' + numcdelast + ')';

    IF Dm_IntegMail.NbRayon <> 0 THEN
      sMessage := sMessage + #13#10 + 'Nombre de nouveaux rayons créés : ' + IntToStr(Dm_IntegMail.NbRayon);
    IF Dm_IntegMail.NbSSFamille <> 0 THEN
      sMessage := sMessage + #13#10 + 'Nombre de nouvelles familles/sousfamilles créées : ' + IntToStr(Dm_IntegMail.NbSSFamille);

    InfoMessHP(sMessage, True, 0, 0, '');

    IF Dm_IntegMail.NbSSFamille <> 0 THEN
      Dm_IntegMail.LK_SSFamille.Execute;

  END
  ELSE
    InfoMessHP('Traitement terminé...' + #10 + #13 + #10 + #13 + '(Pas de nouvelle commande)', true, 0, 0, '');

  ModalResult := mrOk;

END;

{procedure TFrm_IntegEsprit.popDecodeStart(var FileName: string);
begin
    piecejointe := FileName;
end;    }

FUNCTION TFrm_IntegEsprit.TraitementPieceJointe(nompiece: STRING): boolean;
VAR
  F: TextFile;
  Stg: STRING;
  StrQuery: STRING;
  NbLigne: integer;
  inc: integer;

  NUMEROCOMMANDE1, NUMEROCOMMANDE2, CDE_ID: STRING;
  PIECEJOINTE: STRING;
  ART_ID, ARF_ID: STRING;
  ART_GTFID, ARF_CHRONO: STRING;
  TGF_ID, TTV_ID, COU_ID, CBI_ID, ART_CB, FOU_ID, CLG_ID, CLG_PXNEGO, PVT_PX: STRING;
  TX_TVA, CDL_ID, CDL_OFFSET, ARF_TVA, PVT_ID: STRING;

  TempsString, substr, S: STRING;
  TempStringConnect: STRING;
  TempInt: integer;
  ch1, ch2, ch3: STRING;
  Cmd, PxAchat, PxVente: STRING;
  numcde: STRING;

  iOrdreAff: Integer;
BEGIN

  s := nompiece;
  MemD_TVA.open;
  substr := ExtractFilePath(Application.ExeName) + 'CommandesEsprit\';
  IF pos(substr, s) = 0 THEN TempStringConnect := ''
  ELSE
    TempStringConnect := copy(s, pos(substr, s) + length(substr), length(s) - pos(substr, s) + length(substr));

  //------------------------------------------------
  //-- Piece Jointe deja traitée ?
  PIECEJOINTE := TempStringConnect;
  StrQuery := 'Select IMP_ID, IMP_KTBID, IMP_GINKOIA, IMP_REF, IMP_NUM, IMP_REFSTR from genimport join k on k_id=imp_id and k_enabled=1 Where imp_refstr= ''' + PIECEJOINTE + ''' and imp_num=12';
  Que_NoPJ.sql.clear;
  Que_NoPJ.sql.Add(StrQuery);
  Que_NoPJ.ExecSql;
  TempsString := Que_NoPJ.FieldByName('imp_id').AsString;
  IF TempsString = '' THEN
  BEGIN
    // Le mail n'a pas encore etait traité
  END
  ELSE
  BEGIN
    //InfoMessHP('Mail Deja Traité', false, 300, 300, 'Info');
    //RapportPJ(memD_Rapport, '0', 'Erreur', '0', 'Mail Deja Traité '+PIECEJOINTE);
    result := false;
    EXIT;
  END;

  //-----------------------------------------------------------
  //-- Chargement en dans un MemData du fichier texte.
  //-- Chargement de la Pj
  //-----------------------------------------------------------
  //-- Chargement en dans un MemData du fichier texte.
  memd.close;
  memd.open;
  AssignFile(F, nompiece);
  Reset(F);
  REPEAT //Repeter...
    Readln(F, Stg); //Lit une ligne du fichier texte jusqu'au prochain sut de ligne
    memd.append;
    memddatatype.asstring := copy(stg, 1, 1);
    memdean.asstring := copy(stg, 2, 13);
    memddescription.asstring := copy(stg, 15, 40);
    memdPxVente.asstring := copy(stg, 55, 7);
    memdStylenumber.asstring := copy(stg, 62, 6);
    memdStylecolor.asstring := copy(stg, 68, 3);
    memdStyleColorDescription.asstring := copy(stg, 71, 20);
    memdtaille.asstring := copy(stg, 91, 7);
    memdSaison.asstring := copy(stg, 98, 1);
    memdDivision.asstring := copy(stg, 99, 2);
    memdProductClass.asstring := copy(stg, 101, 3);
    memdPxAchat.asstring := copy(stg, 104, 7);
    memdsaisonYear.asstring := copy(stg, 111, 4);
    memdISS.asstring := copy(stg, 115, 2);
    memdSSP.asstring := copy(stg, 117, 2);
    memdCmd.asstring := copy(stg, 119, 6);
    memdNumberCMD.asstring := copy(stg, 125, 7);
    memdorderNumber.asstring := copy(stg, 132, 6);
    memdDateInvoice.asstring := copy(stg, 138, 8);
    memdDateOrder.asstring := copy(stg, 146, 8);
    memdCodeclient.asstring := copy(stg, 154, 5);
    NoMagasin := copy(stg, 154, 5); // Je recupere ici le numero de magasin au lieu de le prendre dans le corp du mail
    memddeliveryloc.asstring := copy(stg, 159, 4);
    memd.post;
  UNTIL EOF(F); // ...jusqu'à ce que la position en cours du pointeur se trouve en fin de fichier
  CloseFile(F);

  //------------------------------------------------------------
  // Verification de l'existance du magasin en base Ginkoia
  StrQuery := 'Select prm_magid from genparam join k on prm_id=k_id and k_enabled=1 Where prm_type=12 and prm_code=1 And prm_String= ''' + NoMagasin + '''';
  Que_Magasin.sql.clear;
  Que_Magasin.sql.Add(StrQuery);
  Que_Magasin.ExecSql;

  TempsString := Que_Magasin.fieldbyname('prm_magid').AsString;
  IF TempsString = '' THEN
  BEGIN
    //InfoMessHP('Magasin N''Existe PAS dans la Base Ginkoia', false, 300, 300, 'fred');
    //RapportPJ(memD_Rapport, '0', 'Erreur', '0', 'Magasin Existe PAS');
    // insérer un enregistrement dans Genimport
    Que_NoPJ.insert;
    Que_NoPJ.fieldbyname('Imp_ktbid').AsInteger := 0;
    Que_NoPJ.fieldbyname('Imp_ginkoia').AsInteger := 0;
    Que_NoPJ.fieldbyname('Imp_ref').AsInteger := 0;
    Que_NoPJ.fieldbyname('Imp_num').AsInteger := 12;
    Que_NoPJ.fieldbyname('Imp_refstr').asstring := PIECEJOINTE;
    Que_NoPJ.post;
    result := false;
    EXIT;
  END
  ELSE
  BEGIN
    // Magasin existe : on continu
  END;

  //-------------------------------------------------------------------------------
  // A partir d'ici les verifications sont finies.
  // On peut commencer les a traiter le fichiers Piece jointe.
  InitGaugeMessHP('Traitement d''un @mail en cours...', memd.recordcount + 1, true, 0, 0, '', false);

  // initialisation  des paramettres
  inc := 0;
  NUMEROCOMMANDE1 := ' ';
  NUMEROCOMMANDE2 := ' ';

  // Place le curseur sur la premiere ligne
  memd.first;
  WHILE NOT memd.eof DO
  BEGIN
    IncGaugeMessHP(1);
    NUMEROCOMMANDE2 := memdorderNumber.asstring;
    // la Commande a deja etait traitée et validée ?
    StrQuery := 'Select IMP_ID, IMP_KTBID, IMP_GINKOIA, IMP_REF, IMP_NUM, IMP_REFSTR from genimport join k on k_id=imp_id and k_enabled=1 Where imp_num=12 and imp_refstr=' + #39 + NUMEROCOMMANDE2 + #39;
    Que_NoPJ.sql.clear;
    Que_NoPJ.sql.Add(StrQuery);
    Que_NoPJ.ExecSql;
    IF Que_NoPJ.FieldByName('imp_id').AsString <> '' THEN
    BEGIN
      // la commande a deja etait traitée et validée.
      //   InfoMessHP('la commande existe deja', false, 300, 300, 'fred');
      Dm_IntegMail.RapportPJ(Dm_IntegMail.memD_Rapport, Que_NoPJ.FieldByName('imp_id').AsString, 'Erreur', '0', 'Commande existe deja ' + NUMEROCOMMANDE2);
      memd.next;
    END
    ELSE
    BEGIN
      IF NUMEROCOMMANDE1 <> NUMEROCOMMANDE2 THEN
      BEGIN
        IF NUMEROCOMMANDE1 <> ' ' THEN
        BEGIN
          // On valide commande
          ValideCommande(MemD_TVA, CDE_ID, NUMEROCOMMANDE1);
          Dm_IntegMail.RapportPJ(Dm_IntegMail.memD_Rapport, '0', 'OK', NUMEROCOMMANDE1 + ' ' + numcde, 'Commande Validée');
          MemD_TVA.close;
        END;
        // Creation d'une entete de commande
        ch1 := memdorderNumber.asstring;
        ch2 := memdCodeclient.asstring;
        ch3 := memdDateOrder.asstring;
        CDE_ID := Dm_IntegMail.Ecommande(ch1, ch2, ch3, numcde);
        IF numcdefirst = '' THEN
          numcdefirst := numcde
        ELSE
          numcdelast := numcde;
        nbcde := nbcde + 1;

      END;
      //------------
      // -Est - ce que ce modèle existe déjà ?
      que_artarti.close;
      que_artarti.parambyname('refmrk').asstring := memdStylenumber.asstring;
      que_artarti.parambyname('artnom').asstring := memddescription.asstring;
      que_artarti.open;
      ART_ID := Que_ArtArti.fieldbyname('art_id').AsString;
      ARF_ID := '';
      IF ART_ID = '' THEN
      BEGIN
        // ---- Creation du modele ArtArticle    ---- //
        ART_ID := Dm_IntegMail.ArtArticle(memdDivision.asstring, memdProductClass.asstring, memdISS.asstring, memddescription.asstring, memdsaisonYear.asstring, memdStylenumber.asstring, 'ESPRIT');
        // ---- Creation du modele ArtReference ---- //
        ARF_ID := Dm_IntegMail.ArtReference(memdDivision.asstring, memdProductClass.asstring, ART_ID);
      END;
      IF ARF_ID = '' THEN
      BEGIN
        // si Arf_ID ='' cela veux dire qu'il existe deja un modele ArtArticle
        // On recherche donc le Modele ArtRefernce  associe a ArtArticle
        Que_ARTREFERENCE.sql.clear;
        Que_ARTREFERENCE.sql.Add('select arf_id, ARF_ARTID , ARF_CATID , ARF_TVAID , ARF_TCTID , ARF_ICLID1');
        Que_ARTREFERENCE.sql.Add(', ARF_ICLID2 , ARF_ICLID3 , ARF_ICLID4 , ARF_ICLID5 , ARF_CREE , ARF_CHRONO , ARF_DIMENSION , ARF_DEPRECIATION,');
        Que_ARTREFERENCE.sql.Add('ARF_VIRTUEL , ARF_SERVICE , ARF_COEFT , ARF_STOCKI , ARF_VTFRAC , ARF_CDNMT , ARF_CDNMTQTE , ARF_UNITE');
        Que_ARTREFERENCE.sql.Add(', ARF_CDNMTOBLI , ARF_GUELT , ARF_CPFA , ARF_FIDELITE , ARF_ARCHIVER , ARF_FIDPOINT , ARF_DEPTAUX , ARF_DEPMOTIF ,ARF_CGTID ,');
        Que_ARTREFERENCE.sql.Add('ARF_GLTMONTANT , ARF_GLTPXV , ARF_GLTMARGE , ARF_MAGORG , ARF_CATALOG from');
        Que_ARTREFERENCE.sql.Add(' artreference join k on k_id=1 and k_enabled=1 where arf_artid =' + ART_ID);
        Que_ARTREFERENCE.ExecSql;
        ARF_ID := Que_ARTREFERENCE.fieldbyname('arf_id').AsString;
        IF ARF_ID = '' THEN ARF_ID := '0';
      END;

      // ---- TAILLE  ---- //
      // - Recherche ART_GTFID
      StrQuery := 'Select ART_GTFID, ART_ID from ArtArticle join k on k_id=art_id and k_enabled=1 where Art_ID=' + ART_ID;
      //        Que_ArtArti.sql.clear;
      //        Que_ArtArti.sql.Add(StrQuery);
      //        Que_ArtArti.ExecSql;
      ibc_art.close;
      ibc_art.parambyname('artid').asstring := art_id;
      ibc_art.open;
      ART_GTFID := ibc_art.fieldbyname('ART_GTFID').AsString;
      // - ID de la taille
      TempsString := memdtaille.asstring;
      StrQuery := 'Select tgf_id,TGF_GTFID,TGF_IDREF,TGF_TGFID,TGF_NOM,TGF_CORRES,TGF_ORDREAFF,TGF_STAT from plxtaillesgf join k on k_id=tgf_id and k_enabled=1 where tgf_nom= ''' + TempsString + ''' and tgf_gtfid= ' + ART_GTFID;
      Que_Taille.sql.clear;
      Que_Taille.sql.Add(StrQuery);
      Que_Taille.ExecSql;
      TGF_ID := Que_Taille.fieldbyname('tgf_id').AsString;
      IF TGF_ID = '' THEN
      BEGIN
        //récupèrer l'ordre d'affiche le plus grand dans la base pour déterminer la prochaine valeur
        Que_OrdreAff.close;
        Que_OrdreAff.ParamByName('gtfid').asString := ART_GTFID;
        Que_OrdreAff.Open;
        iOrdreAff := 1;
        //s'il existe une première taille
        IF Que_OrdreAff.RecordCount > 0 THEN
          iOrdreAff := Que_OrdreAffMAXORDREAFF.asInteger + 10;
        Que_OrdreAff.close;
        // libellé de taille n'existe pas : On le cree
        Que_Taille.insert;
        Que_Taille.fieldbyname('TGF_GTFID').asstring := ART_GTFID;
        Que_Taille.fieldbyname('TGF_IDREF').AsInteger := 0;
        Que_Taille.fieldbyname('TGF_TGFID').AsInteger := Que_Taille.fieldbyname('TGF_ID').AsInteger;
        Que_Taille.fieldbyname('TGF_NOM').asstring := memdtaille.asstring;
        Que_Taille.fieldbyname('TGF_CORRES').asstring := '';
        Que_Taille.fieldbyname('TGF_ORDREAFF').AsInteger := iOrdreAff;
        Que_Taille.fieldbyname('TGF_STAT').AsInteger := 0;
        Que_Taille.post;
        TGF_ID := Que_Taille.fieldbyname('tgf_id').AsString;
      END;

      // ---- TAILLE TRAVALLE ---- //
      TempsString := memdtaille.asstring;
      StrQuery := 'select ttv_id, TTV_ARTID, TTV_TGFID from plxtaillestrav join k on k_id=ttv_id and k_enabled=1 where ttv_artid=' + ART_ID + ' and ttv_tgfid=' + TGF_ID;
      Que_TailleTrav.sql.clear;
      Que_TailleTrav.sql.Add(StrQuery);
      Que_TailleTrav.ExecSql;
      TTV_ID := Que_TailleTrav.fieldbyname('ttv_id').AsString;
      IF TTV_ID = '' THEN
      BEGIN
        // si elle n'existe on pas on la cree
        Que_TailleTrav.insert;
        Que_TailleTrav.fieldbyname('TTV_ARTID').asstring := ART_ID;
        Que_TailleTrav.fieldbyname('TTV_TGFID').asstring := TGF_ID;
        Que_TailleTrav.post;
        TTV_ID := Que_TailleTrav.fieldbyname('TTV_ID').AsString;
      END;

      // ---- COULEUR  ---- //
      StrQuery := 'select cou_id, COU_ARTID, COU_IDREF, COU_GCSID, COU_CODE, COU_NOM  from plxcouleur join k on k_id=cou_id and k_enabled=1 where cou_code= ''' + memdStylecolor.asstring + '''and cou_artid= ' + ART_ID;
      Que_Couleur.sql.clear;
      Que_Couleur.sql.Add(StrQuery);
      Que_Couleur.ExecSql;
      COU_ID := Que_Couleur.fieldbyname('cou_id').AsString;
      IF COU_ID = '' THEN
      BEGIN
        // si elle n'existe on pas on la cree
        Que_Couleur.insert;
        Que_Couleur.fieldbyname('COU_ARTID').asstring := ART_ID;
        Que_Couleur.fieldbyname('COU_IDREF').AsInteger := 0;
        Que_Couleur.fieldbyname('COU_GCSID').AsInteger := 0;
        Que_Couleur.fieldbyname('COU_CODE').asstring := memdStylecolor.asstring;
        Que_Couleur.fieldbyname('COU_NOM').asstring := memdStyleColorDescription.asstring;
        Que_Couleur.post;
        COU_ID := Que_Couleur.fieldbyname('COU_ID').AsString;
      END;

      // ---- CODE BARRE ESPRIT --- //
      TempsString := memdtaille.asstring;
      StrQuery := 'select cbi_id, CBI_ARFID, CBI_TGFID, CBI_COUID, CBI_CB, CBI_TYPE, CBI_CLTID, CBI_ARLID, CBI_LOC from artcodebarre join k on k_id=cbi_id and k_enabled=1 where cbi_arfid= ' + ARF_ID + ' and cbi_couid= ' + COU_ID + ' and cbi_tgfid= ' + TGF_ID + ' and cbi_type=3 and cbi_cb= ' + memdean.asstring;
      Que_CBEsprit.sql.clear;
      Que_CBEsprit.sql.Add(StrQuery);
      Que_CBEsprit.ExecSql;
      CBI_ID := Que_CBEsprit.fieldbyname('CBI_ID').AsString;
      IF CBI_ID = '' THEN
      BEGIN
        // si elle n'existe on pas on la cree
        Que_CBEsprit.insert;
        Que_CBEsprit.fieldbyname('CBI_ARFID').asstring := ARF_ID;
        Que_CBEsprit.fieldbyname('CBI_TGFID').asstring := TGF_ID;
        Que_CBEsprit.fieldbyname('CBI_COUID').asstring := COU_ID;
        Que_CBEsprit.fieldbyname('CBI_CB').asstring := memdean.asstring;
        Que_CBEsprit.fieldbyname('CBI_TYPE').AsInteger := 3;
        Que_CBEsprit.fieldbyname('CBI_CLTID').AsInteger := 0;
        Que_CBEsprit.fieldbyname('CBI_ARLID').AsInteger := 0;
        Que_CBEsprit.fieldbyname('CBI_LOC').AsInteger := 0;
        Que_CBEsprit.post;
        CBI_ID := Que_CBEsprit.fieldbyname('CBI_ID').AsString;
      END;

      // ---- CODE BARRE GINKOIA --- //
      TempsString := memdtaille.asstring;
      StrQuery := 'select cbi_id, CBI_ARFID, CBI_TGFID, CBI_COUID, CBI_CB, CBI_TYPE, CBI_CLTID, CBI_ARLID, CBI_LOC from artcodebarre join k on k_id=cbi_id and k_enabled=1 where cbi_arfid= ' + ARF_ID + ' and cbi_couid= ' + COU_ID + ' and cbi_tgfid= ' + TGF_ID + ' and cbi_type=1 ';
      Que_CBGinkoia.sql.clear;
      Que_CBGinkoia.sql.Add(StrQuery);
      Que_CBGinkoia.ExecSql;
      CBI_ID := '';
      CBI_ID := Que_CBGinkoia.fieldbyname('CBI_ID').AsString;
      IF CBI_ID = '' THEN
      BEGIN
        // si elle n'existe on pas on la cree
        // ART_CB
        IbC_Script.Close;
        IbC_Script.SQL.Clear;
        IbC_Script.sql.Add('select NewNum from ART_CB');
        IbC_Script.open;
        ART_CB := IbC_Script.fieldbyname('NewNum').AsString;
        //insertion
        Que_CBGinkoia.insert;
        Que_CBGinkoia.fieldbyname('CBI_ARFID').asstring := ARF_ID;
        Que_CBGinkoia.fieldbyname('CBI_TGFID').asstring := TGF_ID;
        Que_CBGinkoia.fieldbyname('CBI_COUID').asstring := COU_ID;
        Que_CBGinkoia.fieldbyname('CBI_CB').asstring := ART_CB;
        Que_CBGinkoia.fieldbyname('CBI_TYPE').AsInteger := 1;
        Que_CBGinkoia.fieldbyname('CBI_CLTID').AsInteger := 0;
        Que_CBGinkoia.fieldbyname('CBI_ARLID').AsInteger := 0;
        Que_CBGinkoia.fieldbyname('CBI_LOC').AsInteger := 0;
        Que_CBGinkoia.post;
        CBI_ID := Que_CBGinkoia.fieldbyname('CBI_ID').AsString;
      END;

      // ---- PRIX ACHAT ---- //
      // - CDE_FOUID
      StrQuery := 'Select prm_integer, PRM_ID from genparam join k on prm_id=k_id and k_enabled=1 Where prm_type=12 and prm_code=4';
      Que_Param.sql.clear;
      Que_Param.sql.Add(StrQuery);
      Que_Param.ExecSql;
      FOU_ID := Que_Param.fieldbyname('prm_integer').AsString;
      // Recherche : CLG_PXNEGO
      StrQuery := 'select CLG_ID, CLG_ARTID, CLG_FOUID, CLG_TGFID, CLG_PX, CLG_PXNEGO, CLG_PXVI, CLG_RA1, CLG_RA2, CLG_RA3, CLG_TAXE, CLG_PRINCIPAL from tarclgfourn join k on k_id=clg_id and k_enabled=1 where clg_artid= ' + ART_ID + ' and clg_fouid= ' + FOU_ID + ' and clg_tgfid=0';
      Que_Tarclgfourn.sql.clear;
      Que_Tarclgfourn.sql.Add(StrQuery);
      Que_Tarclgfourn.ExecSql;
      CLG_PXNEGO := Que_Tarclgfourn.fieldbyname('CLG_PXNEGO').AsString;
      TempsString := memdPxAchat.asstring;
      TempsString := CentineToEntier(TempsString);
      IF CLG_PXNEGO <> TempsString THEN
      BEGIN
        IF CLG_PXNEGO = '' THEN
        BEGIN
          // si elle n'existe on pas on la cree
          Que_Tarclgfourn.insert;
          Que_Tarclgfourn.fieldbyname('CLG_ARTID').asstring := ART_ID;
          Que_Tarclgfourn.fieldbyname('CLG_FOUID').asstring := FOU_ID;
          Que_Tarclgfourn.fieldbyname('CLG_TGFID').AsInteger := 0; // prix de base pas de référence à une taille
          Que_Tarclgfourn.fieldbyname('CLG_PX').asstring := CentineToEntier(memdPxAchat.asstring);
          Que_Tarclgfourn.fieldbyname('CLG_PXNEGO').asstring := CentineToEntier(memdPxAchat.asstring);
          Que_Tarclgfourn.fieldbyname('CLG_PXVI').AsInteger := 0;
          Que_Tarclgfourn.fieldbyname('CLG_RA1').AsInteger := 0;
          Que_Tarclgfourn.fieldbyname('CLG_RA2').AsInteger := 0;
          Que_Tarclgfourn.fieldbyname('CLG_RA3').AsInteger := 0;
          Que_Tarclgfourn.fieldbyname('CLG_TAXE').AsInteger := 0;
          Que_Tarclgfourn.fieldbyname('CLG_PRINCIPAL').AsInteger := 1;
          Que_Tarclgfourn.post;
          CLG_ID := Que_Tarclgfourn.fieldbyname('CLG_ID').AsString;
        END
        ELSE
        BEGIN
          // l'enregistrement existe mais la valeur CLG_pxnego est différente de la colonne Px achat
          Que_Tarclgfourn.insert;
          Que_Tarclgfourn.fieldbyname('CLG_ARTID').asstring := ART_ID;
          Que_Tarclgfourn.fieldbyname('CLG_FOUID').asstring := FOU_ID;
          Que_Tarclgfourn.fieldbyname('CLG_TGFID').asstring := TGF_ID;
          Que_Tarclgfourn.fieldbyname('CLG_PX').asstring := CentineToEntier(memdPxAchat.asstring);
          Que_Tarclgfourn.fieldbyname('CLG_PXNEGO').asstring := CentineToEntier(memdPxAchat.asstring);
          Que_Tarclgfourn.fieldbyname('CLG_PXVI').AsInteger := 0;
          Que_Tarclgfourn.fieldbyname('CLG_RA1').AsInteger := 0;
          Que_Tarclgfourn.fieldbyname('CLG_RA2').AsInteger := 0;
          Que_Tarclgfourn.fieldbyname('CLG_RA3').AsInteger := 0;
          Que_Tarclgfourn.fieldbyname('CLG_TAXE').AsInteger := 0;
          Que_Tarclgfourn.fieldbyname('CLG_PRINCIPAL').AsInteger := 1;
          Que_Tarclgfourn.post;
          CLG_ID := Que_Tarclgfourn.fieldbyname('CLG_ID').AsString;
        END;
      END;

      // ---- PRIX DE VENTE ---- //
      StrQuery := 'select PVT_ID, PVT_TVTID, PVT_ARTID, PVT_TGFID, PVT_PX from tarprixvente join k on pvt_id=k_id and k_enabled=1 where PVT_artid= ' + ART_ID + ' and pvt_tvtid=0 and pvt_tgfid=0 ';
      Que_PXVente.sql.clear;
      Que_PXVente.sql.Add(StrQuery);
      Que_PXVente.ExecSql;
      PVT_PX := Que_PXVente.fieldbyname('pvt_px').AsString;
      TempsString := memdPxVente.asstring;
      TempsString := CentineToEntier(TempsString);
      IF PVT_PX <> TempsString THEN
      BEGIN
        IF PVT_PX = '' THEN
        BEGIN
          Que_PXVente.insert;
          Que_PXVente.fieldbyname('PVT_TVTID').asinteger := 0;
          Que_PXVente.fieldbyname('PVT_ARTID').asstring := ART_ID;
          Que_PXVente.fieldbyname('PVT_TGFID').asinteger := 0;
          Que_PXVente.fieldbyname('PVT_PX').asstring := CentineToEntier(memdPxVente.asstring);
          Que_PXVente.post;
          PVT_ID := Que_PXVente.fieldbyname('PVT_ID').AsString;
        END
        ELSE
        BEGIN
          // existe mais la valeur PVT_PX est différente de la colonne Px de vente
          Que_PXVente.insert;
          Que_PXVente.fieldbyname('PVT_TVTID').AsInteger := 0;
          Que_PXVente.fieldbyname('PVT_ARTID').asstring := ART_ID;
          Que_PXVente.fieldbyname('PVT_TGFID').asstring := TGF_ID;
          Que_PXVente.fieldbyname('PVT_PX').asstring := CentineToEntier(memdPxVente.asstring);
          Que_PXVente.post;
          PVT_ID := Que_PXVente.fieldbyname('PVT_ID').AsString;
        END;
      END;

      // ---- Creation LIGNE COMMANDE ---- //
      // Retard toleré
      StrQuery := 'Select prm_integer, prm_ID from genparam join k on prm_id=k_id and k_enabled=1 Where prm_type=12 and prm_code=7 ';
      Que_Param.sql.clear;
      Que_Param.sql.Add(StrQuery);
      Que_Param.ExecSql;
      CDL_OFFSET := Que_Param.fieldbyname('prm_integer').AsString;
      // Recupp TVA_ID :Que_ArtRef
      StrQuery := 'Select ARF_TVAID from ArtReference where ARF_ID= ' + ARF_ID;
      Que_ArtRef.sql.clear;
      Que_ArtRef.sql.Add(StrQuery);
      Que_ArtRef.ExecSql;
      ARF_TVA := Que_ArtRef.fieldbyname('ARF_TVAID').AsString;
      // Taux de TVA : Que_TVA
      StrQuery := 'select TVA_TAUX, TVA_ID from ARTTVA where TVA_ID =' + ARF_TVA;
      Que_TVA.sql.clear;
      Que_TVA.sql.Add(StrQuery);
      Que_TVA.ExecSql;
      TX_TVA := Que_TVA.fieldbyname('TVA_TAUX').AsString;

      // insertion d'une ligne de commande
      Cmd := memdCmd.asstring;
      PxAchat := CentineToEntier(memdPxAchat.asstring);
      PxVente := CentineToEntier(memdPxVente.asstring);
      CDL_ID := Dm_IntegMail.Lcommande(CDE_ID, ART_ID, TGF_ID, COU_ID, Cmd, PxAchat, TX_TVA, PxVente, CDL_OFFSET);

      // Memorisation des valeurs  TVA
      MemD_TVA.open;
      MemD_TVA.append;
      MemD_TVATXTVA.asstring := TX_TVA;
      MemD_TVAQuantite.asstring := memdCmd.asstring;
      MemD_TVAPXAchat.asstring := CentineToEntier(memdPxAchat.asstring);
      MemD_TVA.post;

      // incrementation
      NUMEROCOMMANDE1 := memdorderNumber.asstring;
      memd.next;
      NUMEROCOMMANDE2 := memdorderNumber.asstring;
      inc := inc + 1;
    END;
  END;
  // Validation de la derniere commande
  ValideCommande(MemD_TVA, CDE_ID, NUMEROCOMMANDE2);
  ValidePieceJoint(CDE_ID, PIECEJOINTE);
  MemD_TVA.close;
  Dm_IntegMail.RapportPJ(Dm_IntegMail.memD_Rapport, '0', 'OK', NUMEROCOMMANDE2 + ' ' + numcde, 'Commande Validée');
  result := true;
  CloseGaugeMessHP;
END;

FUNCTION TFrm_IntegEsprit.CentineToEntier(Num: STRING): STRING;
VAR
  PX1, PX2, PXX: STRING;
  inc, inc2: integer;
BEGIN
  // Fonction qui transforme un chiffre sur 7 caracteres
  // en chiffre du type XXXXX.YY ou le premier X <> 0
  IF num = '0000000' THEN
  BEGIN
    result := '0.00';
    EXIT;
  END;

  inc := 1;
  PX1 := copy(Num, 1, 5);
  PX2 := copy(Num, 6, 2);
  pxx := '';
  IF px1 <> '00000' THEN
  BEGIN
    WHILE ((PX1[inc] = '0') AND (inc < 6)) DO
    BEGIN
      inc := inc + 1;
    END;

    FOR inc2 := inc TO 5 DO
    BEGIN
      PXX := PXX + PX1[inc2];
    END;
  END;
  IF PXX = '' THEN
    PXX := '0';
  PXX := PXX + '.' + PX2;
  result := PXX;
END;

PROCEDURE TFrm_IntegEsprit.ValideCommande(MemD_TVA: TdxMemData; CDE_ID, CDE_NUM: STRING);
VAR
  Nb_Taux: integer;
  MontantHT, TVA_TAUX, Total: extended;
  MontantHT1, TVA_TAUX1, TolalTHT1, Total1: extended;
  MontantHT2, TVA_TAUX2, TolalTHT2, Total2: extended;
  MontantHT3, TVA_TAUX3, TolalTHT3, Total3: extended;
  MontantHT4, TVA_TAUX4, TolalTHT4, Total4: extended;
  MontantHT5, TVA_TAUX5, TolalTHT5, Total5: extended;
  CAS: boolean;
  tempString: STRING;
  tempInt: extended;
  StrQuery: STRING;
BEGIN
  // Initialisation des montants TVA
  MontantHT := 0;
  TVA_TAUX := 0;
  Total := 0;
  MontantHT1 := 0;
  TVA_TAUX1 := 0;
  Total1 := 0;
  ;
  MontantHT2 := 0;
  TVA_TAUX2 := 0;
  Total2 := 0;
  MontantHT3 := 0;
  TVA_TAUX3 := 0;
  Total3 := 0;
  MontantHT4 := 0;
  TVA_TAUX4 := 0;
  Total4 := 0;
  MontantHT5 := 0;
  TVA_TAUX5 := 0;
  Total5 := 0;
  Nb_Taux := 0;

  TolalTHT1 := 0;
  TolalTHT2 := 0;
  TolalTHT3 := 0;
  TolalTHT4 := 0;
  TolalTHT5 := 0;

  // -- Calcul Taux TVA
  MemD_TVA.first;
  WHILE NOT MemD_TVA.eof DO
  BEGIN
    CAS := true;

    TVA_TAUX := MemD_TVATXTVA.AsFloat;

    IF TVA_TAUX = TVA_TAUX1 THEN
    BEGIN
      MontantHT1 := MemD_TVAQuantite.AsFloat * MemD_TVAPXAchat.AsFloat;
      TolalTHT1 := TolalTHT1 + MontantHT1;
      Total1 := Total1 + MontantHT1 * TVA_TAUX1 / 100;
      CAS := false
    END;
    IF TVA_TAUX = TVA_TAUX2 THEN
    BEGIN
      MontantHT2 := MemD_TVAQuantite.AsFloat * MemD_TVAPXAchat.AsFloat;
      TolalTHT2 := TolalTHT2 + MontantHT2;
      Total2 := Total2 + MontantHT2 * TVA_TAUX2 / 100;
      CAS := false
    END;
    IF TVA_TAUX = TVA_TAUX3 THEN
    BEGIN
      MontantHT3 := MemD_TVAQuantite.AsFloat * MemD_TVAPXAchat.AsFloat;
      TolalTHT3 := TolalTHT3 + MontantHT3;
      Total3 := Total3 + MontantHT3 * TVA_TAUX1 / 100;
      CAS := false
    END;
    IF TVA_TAUX = TVA_TAUX4 THEN
    BEGIN
      MontantHT4 := MemD_TVAQuantite.AsFloat * MemD_TVAPXAchat.AsFloat;
      TolalTHT4 := TolalTHT4 + MontantHT4;
      Total4 := Total4 + MontantHT4 * TVA_TAUX4 / 100;
      CAS := false
    END;
    IF TVA_TAUX = TVA_TAUX5 THEN
    BEGIN
      MontantHT5 := MemD_TVAQuantite.AsFloat * MemD_TVAPXAchat.AsFloat;
      TolalTHT5 := TolalTHT5 + MontantHT5;
      Total5 := Total5 + MontantHT5 * TVA_TAUX5 / 100;
      CAS := false
    END;

    IF CAS THEN
    BEGIN
      Nb_Taux := Nb_Taux + 1;
      CASE Nb_Taux OF
        1: BEGIN
            TVA_TAUX1 := TVA_TAUX;
            MontantHT1 := MemD_TVAQuantite.AsFloat * MemD_TVAPXAchat.AsFloat;
            TolalTHT1 := TolalTHT1 + MontantHT1;
            Total1 := Total1 + MontantHT1 * TVA_TAUX1 / 100;
          END;
        2: BEGIN
            TVA_TAUX2 := TVA_TAUX;
            MontantHT2 := MemD_TVAQuantite.AsFloat * MemD_TVAPXAchat.AsFloat;
            TolalTHT2 := TolalTHT2 + MontantHT2;
            Total2 := Total2 + MontantHT2 * TVA_TAUX2 / 100;
          END;
        3: BEGIN
            TVA_TAUX3 := TVA_TAUX;
            MontantHT3 := MemD_TVAQuantite.AsFloat * MemD_TVAPXAchat.AsFloat;
            TolalTHT3 := TolalTHT3 + MontantHT3;
            Total3 := Total3 + MontantHT3 * TVA_TAUX3 / 100;
          END;
        4: BEGIN
            TVA_TAUX4 := TVA_TAUX;
            MontantHT4 := MemD_TVAQuantite.AsFloat * MemD_TVAPXAchat.AsFloat;
            TolalTHT4 := TolalTHT4 + MontantHT4;
            Total4 := Total4 + MontantHT4 * TVA_TAUX4 / 100;
          END;

        5: BEGIN
            TVA_TAUX5 := TVA_TAUX;
            MontantHT5 := MemD_TVAQuantite.AsFloat * MemD_TVAPXAchat.AsFloat;
            TolalTHT5 := TolalTHT5 + MontantHT5;
            Total5 := Total5 + MontantHT5 * TVA_TAUX5 / 100;
          END;
      END;

    END;

    MemD_TVA.next;

  END;

  // -- Mise a jour de l'Entete de Commande   CDE_ID     IbC_Que_UpdateCommande
  IF NOT IbC_Que_UpdateCommande.Prepared THEN
    IbC_Que_UpdateCommande.Prepare;
  IbC_Que_UpdateCommande.ParamByName('CDE_ID').AsString := CDE_ID;
  IbC_Que_UpdateCommande.ParamByName('TolalTHT1').AsString := FloatToStr(TolalTHT1);
  IbC_Que_UpdateCommande.ParamByName('TolalTHT2').AsString := FloatToStr(TolalTHT2);
  IbC_Que_UpdateCommande.ParamByName('TolalTHT3').AsString := FloatToStr(TolalTHT3);
  IbC_Que_UpdateCommande.ParamByName('TolalTHT4').AsString := FloatToStr(TolalTHT4);
  IbC_Que_UpdateCommande.ParamByName('TolalTHT5').AsString := FloatToStr(TolalTHT5);
  IbC_Que_UpdateCommande.ParamByName('TVA_TAUX1').AsString := FloatToStr(TVA_TAUX1);
  IbC_Que_UpdateCommande.ParamByName('TVA_TAUX2').AsString := FloatToStr(TVA_TAUX2);
  IbC_Que_UpdateCommande.ParamByName('TVA_TAUX3').AsString := FloatToStr(TVA_TAUX3);
  IbC_Que_UpdateCommande.ParamByName('TVA_TAUX4').AsString := FloatToStr(TVA_TAUX4);
  IbC_Que_UpdateCommande.ParamByName('TVA_TAUX5').AsString := FloatToStr(TVA_TAUX5);
  IbC_Que_UpdateCommande.ParamByName('Total1').AsString := FloatToStr(Total1);
  IbC_Que_UpdateCommande.ParamByName('Total2').AsString := FloatToStr(Total2);
  IbC_Que_UpdateCommande.ParamByName('Total3').AsString := FloatToStr(Total3);
  IbC_Que_UpdateCommande.ParamByName('Total4').AsString := FloatToStr(Total4);
  IbC_Que_UpdateCommande.ParamByName('Total5').AsString := FloatToStr(Total5);
  IbC_Que_UpdateCommande.Execute;

  // -- Validation de la commande
  Que_NoPJ.insert;
  Que_NoPJ.fieldbyname('IMP_KTBID').AsInteger := -11111435;
  Que_NoPJ.fieldbyname('IMP_GINKOIA').asstring := CDE_ID;
  Que_NoPJ.fieldbyname('IMP_REF').AsInteger := 0;
  Que_NoPJ.fieldbyname('IMP_NUM').AsInteger := 12;
  Que_NoPJ.fieldbyname('IMP_REFSTR').asstring := CDE_NUM;
  Que_NoPJ.post;
END;

PROCEDURE TFrm_IntegEsprit.ValidePieceJoint(CDE_ID, NomPJ: STRING);
BEGIN
  // -- Validation de la Piece Jointe
  Que_NoPJ.insert;
  Que_NoPJ.fieldbyname('IMP_KTBID').AsInteger := -11111435;
  Que_NoPJ.fieldbyname('IMP_GINKOIA').asstring := CDE_ID;
  Que_NoPJ.fieldbyname('IMP_REF').AsInteger := 0;
  Que_NoPJ.fieldbyname('IMP_NUM').AsInteger := 12;
  Que_NoPJ.fieldbyname('IMP_REFSTR').asstring := NomPJ;
  Que_NoPJ.post;
END;

{procedure TFrm_IntegEsprit.RapportPJ(memD_Rapport: TdxMemData; NumComm, LigneComm, Erreur, Motif: string);
begin
    // Creation d'un rapport de fonctionnement
    memD_Rapport.open;
    memD_Rapport.append;
    MemD_RapportNoCommande.asstring := NumComm;
    MemD_RapportLigneCommande.asstring := LigneComm;
    MemD_RapportErreur.asstring := Erreur;
    MemD_RapportMotif.asstring := Motif;
    memD_Rapport.post;
end; }

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel13(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost13(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete13(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord13(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord13(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel14(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost14(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete14(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord14(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord14(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel15(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost15(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete15(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord15(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord15(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel16(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost16(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete16(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord16(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord16(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel17(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost17(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete17(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord17(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord17(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel18(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost18(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete18(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord18(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord18(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel19(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost19(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete19(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord19(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord19(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel20(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost20(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete20(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord20(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord20(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel21(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost21(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete21(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord21(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord21(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel22(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost22(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete22(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord22(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord22(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel2(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost2(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete2(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord2(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord2(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel3(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost3(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete3(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord3(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord3(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel4(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost4(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete4(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord4(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord4(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel5(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost5(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete5(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord5(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord5(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel6(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost6(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete6(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord6(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord6(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel7(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost7(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete7(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord7(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord7(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel8(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost8(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete8(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord8(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord8(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel9(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost9(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete9(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord9(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord9(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel10(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost10(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete10(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord10(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord10(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel11(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost11(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete11(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord11(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord11(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterCancel12(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOCancelCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikAfterPost12(DataSet: TDataSet);
BEGIN
  Dm_Main.IBOUpDateCache(DataSet AS TIBOQuery);
END;

PROCEDURE TFrm_IntegEsprit.GenerikBeforeDelete12(DataSet: TDataSet);
BEGIN
  { A achever ...
      IF StdGinkoia.ID_EXISTE('KEYID', que_QueryKEY_ID.asInteger, []) THEN
      BEGIN
          StdGinKoia.DelayMess(ErrNoDeleteIntChk, 3);
          ABORT;
      END;
  }
END;

PROCEDURE TFrm_IntegEsprit.GenerikNewRecord12(DataSet: TDataSet);
BEGIN
  IF NOT Dm_Main.IBOMajPkKey((DataSet AS TIBODataSet),
    (DataSet AS TIBODataSet).KeyLinks.IndexNames[0]) THEN Abort;
END;

PROCEDURE TFrm_IntegEsprit.GenerikUpdateRecord12(DataSet: TDataSet;
  UpdateKind: TUpdateKind; VAR UpdateAction: TUpdateAction);
BEGIN
  Dm_Main.IBOUpdateRecord((DataSet AS TIBODataSet).KeyRelation,
    (DataSet AS TIBODataSet), UpdateKind, UpdateAction);
END;

PROCEDURE TFrm_IntegEsprit.AlgolStdFrmCloseQuery(Sender: TObject;
  VAR CanClose: Boolean);
BEGIN
  grd_close.close;
END;

END.

