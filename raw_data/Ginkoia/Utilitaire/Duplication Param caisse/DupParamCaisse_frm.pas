UNIT DupParamCaisse_frm;

INTERFACE

USES
  Windows, ImgList, Controls, Menus, DB, StdActns, Classes, ActnList,
  IBDatabase, wwDialog, wwidlg, wwLookupDialogRv, IBCustomDataSet, IBQuery,
  Dialogs, StdCtrls, CheckLst, ExtCtrls, Buttons, Forms;

TYPE
  TFrm_DupParamCaisse = CLASS(TForm)
    OD: TOpenDialog;
    Data: TIBDatabase;
    que_origine: TIBQuery;
    LK_Origine: TwwLookupDialogRV;
    que_dest: TIBQuery;
    LK_Dest: TwwLookupDialogRV;
    que_destPOS_NOM: TIBStringField;
    que_destPOS_ID: TIntegerField;
    ibqTmpQuery: TIBQuery;
    ibqKProcedures: TIBQuery;
    ibtCopie: TIBTransaction;
    que_btn: TIBQuery;
    que_btnBTN_ID: TIntegerField;
    que_btnBTN_POSID: TIntegerField;
    que_btnBTN_TYPE: TIntegerField;
    que_btnBTN_LIB: TIBStringField;
    que_btnBTN_COULEUR: TIntegerField;
    que_btnBTN_ICONE: TIBStringField;
    que_btnBTN_RACCOURCI: TIBStringField;
    que_btnBTN_REMISE: TFloatField;
    que_btnBTN_REMAT: TIntegerField;
    que_btnBTN_ARFID: TIntegerField;
    que_btnBTN_MENID: TIntegerField;
    que_btnBTN_ORDREAFF: TIntegerField;
    que_btnBTN_ONGLET: TIntegerField;
    que_destPOS_MAGID: TIntegerField;
    ibqCSHCaisseParam: TIBQuery;
    ibqOrigineCaisseParam: TIBQuery;
    ibqOrigineCaisseParamCAI_ID: TIntegerField;
    ibqOrigineCaisseParamCAI_CAISSIER: TIntegerField;
    ibqOrigineCaisseParamCAI_VENDEUR: TIntegerField;
    ibqOrigineCaisseParamCAI_COMMENTREMISE: TIntegerField;
    ibqOrigineCaisseParamCAI_AFFICHEUR: TIntegerField;
    ibqOrigineCaisseParamCAI_JCBANDE: TIntegerField;
    ibqOrigineCaisseParamCAI_IMPCHEQUE: TIntegerField;
    ibqOrigineCaisseParamCAI_IMPFACTURETTE: TIntegerField;
    ibqOrigineCaisseParamCAI_IMPBC: TIntegerField;
    ibqOrigineCaisseParamCAI_TIROIR: TIntegerField;
    ibqOrigineCaisseParamCAI_ENTETE: TIBStringField;
    ibqOrigineCaisseParamCAI_PIED: TIBStringField;
    ibqOrigineCaisseParamCAI_NBLIGNEMASSICOT: TIntegerField;
    ibqOrigineCaisseParamCAI_GROSPRIX: TIntegerField;
    ibqOrigineCaisseParamCAI_DOCMGHAUTE: TIntegerField;
    ibqOrigineCaisseParamCAI_DOCMGBAS: TIntegerField;
    ibqOrigineCaisseParamCAI_DOCENTETE: TIntegerField;
    ibqOrigineCaisseParamCAI_POSID: TIntegerField;
    ibqOrigineCaisseParamCAI_DOCDEFAUT: TIntegerField;
    ibqOrigineCaisseParamCAI_DIV1: TIntegerField;
    ibqOrigineCaisseParamCAI_DIV2: TIntegerField;
    ibqOrigineCaisseParamCAI_LIBCHEQUE: TIBStringField;
    ibqOrigineCaisseParamCAI_COLCODE: TIntegerField;
    ibqOrigineCaisseParamCAI_CAISSIERUNIQUE: TIntegerField;
    ibqOrigineCaisseParamCAI_IMPTICKET: TIntegerField;
    ibqOrigineCaisseParamCAI_DIV3: TIntegerField;
    ibqOrigineCaisseParamCAI_DIV4: TIntegerField;
    ibqOrigineCaisseParamCAI_VERSION: TIntegerField;
    ibqOrigineCaisseParamCAI_ARRONDI: TIntegerField;
    ibqOrigineCaisseParamCAI_REAJUSTCOMPTE: TIntegerField;
    ibqOrigineCaisseParamCAI_LOC: TIntegerField;
    ibqOrigineCaisseParamCAI_ONGLET: TIntegerField;
    ibqOrigineCaisseParamCAI_DEVISAUTO: TIntegerField;
    ibqOrigineCaisseParamCAI_FACTAUTO: TIntegerField;
    ibqOrigineCaisseParamCAI_NBJHISTOCOMPTE: TIntegerField;
    ibqOrigineCaisseParamCAI_TPE: TIntegerField;
    ibqOrigineCaisseParamCAI_SERVEURTPE: TIBStringField;
    ibqOrigineCaisseParamCAI_SKIMAN: TIntegerField;
    ibqOrigineCaisseParamCAI_PACKOTO: TIntegerField;
    ibqOrigineCaisseParamCAI_DOCLOCLASER: TIntegerField;
    ibqOrigineCaisseParamCAI_LOCLASERDEVIS: TIntegerField;
    ibqOrigineCaisseParamCAI_LOCLASERFACT: TIntegerField;
    ibqOrigineCaisseParamCAI_CAUTION: TIntegerField;
    ibqOrigineCaisseParamCAI_CONSULTATION: TIntegerField;
    ibqOrigineCaisseParamCAI_PRIXENFRANC: TIntegerField;
    ibqOrigineCaisseParamCAI_LOGO: TIBStringField;
    ibqOrigineCaisseParamCAI_NBLLOGO: TIntegerField;
    ibqOrigineCaisseParamCAI_LOGOFACTURETTE: TIntegerField;
    ibqOrigineCaisseParamCAI_PASSWORDC: TIntegerField;
    ibqOrigineCaisseParamCAI_DBLDL: TIntegerField;
    ibqOrigineCaisseParamCAI_TICKETDEPOSANT: TIntegerField;
    ibqOrigineCaisseParamCAI_NBDOCDV: TIntegerField;
    ibqOrigineCaisseParamCAI_MOTID: TIntegerField;
    BotomPanel: TPanel;
    btnExit: TButton;
    ClientPanel: TPanel;
    SpeedButton3: TSpeedButton;
    GridPanel1: TGridPanel;
    lblDataBase: TLabel;
    edtDataBase: TEdit;
    btnSearchBase: TSpeedButton;
    lblMagasin: TLabel;
    edtMagasin: TEdit;
    btnMagasin: TSpeedButton;
    Label2: TLabel;
    edtOrigine: TEdit;
    btnSearchOrigine: TSpeedButton;
    Lab_: TLabel;
    ibqMagasin: TIBQuery;
    lkdMagasin: TwwLookupDialogRV;
    ibqMagasinMAG_ID: TIntegerField;
    ibqMagasinMAG_IDENT: TIBStringField;
    ibqMagasinMAG_NOM: TIBStringField;
    ibqMagasinMAG_SOCID: TIntegerField;
    ibqMagasinMAG_ADRID: TIntegerField;
    ibqMagasinMAG_TVTID: TIntegerField;
    ibqMagasinMAG_TEL: TIBStringField;
    ibqMagasinMAG_FAX: TIBStringField;
    ibqMagasinMAG_EMAIL: TIBStringField;
    ibqMagasinMAG_SIRET: TIBStringField;
    ibqMagasinMAG_CODEADH: TIBStringField;
    ibqMagasinMAG_NATURE: TIntegerField;
    ibqMagasinMAG_TRANSFERT: TIntegerField;
    ibqMagasinMAG_SS: TIntegerField;
    ibqMagasinMAG_HUSKY: TIntegerField;
    ibqMagasinMAG_IDENTCOURT: TIBStringField;
    ibqMagasinMAG_COMENT: TIBStringField;
    ibqMagasinMAG_ARRONDI: TIntegerField;
    ibqMagasinMAG_GCLID: TIntegerField;
    ibqMagasinMAG_ENSEIGNE: TIBStringField;
    ibqMagasinMAG_FACID: TIntegerField;
    ibqMagasinMAG_LIVID: TIntegerField;
    ibqMagasinMAG_COULMAG: TIntegerField;
    ibqMagasinMAG_MTAID: TIntegerField;
    ibqMagasinMAG_CLTHABITUEL: TIntegerField;
    ibqMagasinMAG_CENTRALE: TIBStringField;
    ibqMagasinMAG_CODEC: TIntegerField;
    ibqMagasinMAG_MGPID: TIntegerField;
    ibqMagasinMAG_CODCOMPTA: TIBStringField;
    ibqMagasinMAG_ENTREPOT: TIntegerField;
    ibqMagasinMAG_MIGRATIONISF: TDateTimeField;
    ibqMagasinMAG_BASID: TIntegerField;
    ibqMagasinK_ID: TIntegerField;
    ibqMagasinKTB_ID: TIntegerField;
    ibqMagasinK_ENABLED: TIntegerField;
    ibqMagasinKSE_OWNER_ID: TIntegerField;
    ibqMagasinKSE_INSERT_ID: TIntegerField;
    ibqMagasinK_INSERTED: TDateTimeField;
    ibqMagasinKSE_DELETE_ID: TIntegerField;
    ibqMagasinK_DELETED: TDateTimeField;
    ibqMagasinKSE_UPDATE_ID: TIntegerField;
    ibqMagasinK_UPDATED: TDateTimeField;
    ActionList: TActionList;
    actSearchMagasin: TAction;
    actSearchOrigine: TAction;
    dsDestinationPosteList: TDataSource;
    que_originePOS_ID: TIntegerField;
    que_originePOS_NOM: TIBStringField;
    que_originePOS_MAGID: TIntegerField;
    WindowClose1: TWindowClose;
    actCopie: TAction;
    PopupMenu1: TPopupMenu;
    actSelectAll: TAction;
    actUnselectAll: TAction;
    actSelectAll1: TMenuItem;
    actUnselectAll1: TMenuItem;
    btnListDest: TButton;
    ImageList: TImageList;
    clbDestinations: TCheckListBox;
    actSearchDatabase: TAction;
    SelectPanel: TPanel;
    btnSelectAll: TSpeedButton;
    btnUnselectAll: TSpeedButton;
    ibtSelect: TIBTransaction;
    ibqBaseGuid: TIBQuery;
    procedure actSearchMagasinExecute(Sender: TObject);
    procedure actSearchOrigineExecute(Sender: TObject);
    procedure actCopieExecute(Sender: TObject);
    procedure actCopieUpdate(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actUnselectAllExecute(Sender: TObject);
    procedure actSelectAllUpdate(Sender: TObject);
    procedure actUnselectAllUpdate(Sender: TObject);
    procedure WindowClose1Execute(Sender: TObject);
    procedure WindowClose1Update(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actSearchMagasinUpdate(Sender: TObject);
    procedure actSearchOrigineUpdate(Sender: TObject);
    procedure dxDBGrid1Column2Change(Sender: TObject);
    procedure actSearchDatabaseExecute(Sender: TObject);
  PRIVATE
  { Déclarations privées }
    FLastMAgId: integer;
    FLastOriginePosteId: integer;

    procedure InitLogs;

    procedure Refresh;

    procedure ClearMagasin;
    procedure ClearOrigine;
    procedure RefreshDestinationList;

    procedure LoadDefaultDataBase;

    function UpdateK(AId: integer; AType: integer): boolean;
    function NewK(ATableName: string): integer;

    function Copie(AFromId: integer; AToId: integer): boolean;
    function CopieCSHCaisseParam(ADestPosId: integer): boolean;
    function CopieCSHBOUTON(ADestPosId: integer): boolean;
    function CopieGenDossier(ADestPosId: integer): boolean;

    function getCheckDestinationsCount: integer;

    function getInsertIntoCSHCaisseParamSQLText: string;
    function getUpdateCSHCaisseParamSQLText: string;

    function GetBaseGUID: String;
  PUBLIC
  { Déclarations publiques }
  END;

VAR
  Frm_DupParamCaisse: TFrm_DupParamCaisse;

IMPLEMENTATION

uses
  Variants, registry, SysUtils, uLog;

{$R *.DFM}

procedure TFrm_DupParamCaisse.actSearchOrigineExecute(Sender: TObject);
begin
  que_origine.Close;
  que_origine.Params.ParamByName('MAGID').AsInteger := ibqMagasinMAG_ID.AsInteger;
  que_origine.Open;
  IF LK_Origine.execute THEN
  begin
    FLastOriginePosteId := que_originePOS_ID.asinteger;

    //Vérification que le poste d'origine à des CSHCAISSEPARAM
    ibqOrigineCaisseParam.close;
    ibqOrigineCaisseParam.parambyname('posid').asinteger := que_originePOS_ID.asinteger;
    ibqOrigineCaisseParam.open;
    IF ibqOrigineCaisseParam.IsEmpty THEN
    BEGIN
      case MessageDlg(Format('Paramètres de caisse inextants sur le poste "%s".' + #10#13 +
           'Voulez-vous continuez ?', [que_originePOS_NOM.AsString]), mtConfirmation, [mbYes, mbNo], 0) of
        IDYES: ;
        IDNO:
        begin
          ClearOrigine;
          EXIT;
        end;
      end;
    END;
    ibqOrigineCaisseParam.close;

    //Vérification que le poste d'origine à des CSHBOUTON
    que_btn.close;
    que_btn.parambyname('posid').asinteger := que_originePOS_ID.asinteger;
    que_btn.open;
    if que_btn.IsEmpty then
    begin
      case MessageDlg(Format('Paramétrage des boutons de caisse inextants sur le poste "%s".' + #10#13 +
           'Voulez-vous continuez ?', [que_originePOS_NOM.AsString]), mtConfirmation, [mbYes, mbNo], 0) of
        IDYES: ;
        IDNO:
        begin
          ClearOrigine;
          EXIT;
        end;
      end;
    end;
    que_btn.Close;

    edtOrigine.text := que_originePOS_NOM.asstring;
    RefreshDestinationList;
  end
  ELSE
    ClearOrigine;
end;

procedure TFrm_DupParamCaisse.actSearchOrigineUpdate(Sender: TObject);
begin
  actSearchOrigine.Enabled := edtMagasin.Text <> '';
end;

procedure TFrm_DupParamCaisse.actSelectAllExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to clbDestinations.Count - 1 do
    clbDestinations.Checked[i] := True;        
end;

procedure TFrm_DupParamCaisse.actSelectAllUpdate(Sender: TObject);
begin
  actSelectAll.Enabled := clbDestinations.Count > 0;
end;

procedure TFrm_DupParamCaisse.actUnselectAllExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to clbDestinations.Count - 1 do
    clbDestinations.Checked[i] := False;
end;

procedure TFrm_DupParamCaisse.actUnselectAllUpdate(Sender: TObject);
begin
  actUnselectAll.Enabled := clbDestinations.Count > 0;
end;

function TFrm_DupParamCaisse.NewK(ATableName: string): integer;
begin
  ibqKProcedures.Close;
  try
    ibqKProcedures.SQL.Clear;
    ibqKProcedures.SQL.Text := 'SELECT ID FROM PR_NEWK(:TABLENAME)';
    ibqKProcedures.Prepare;
    ibqKProcedures.Params.ParamByName('TABLENAME').AsString := ATableName;

    ibqKProcedures.Open;
    Result := ibqKProcedures.FieldByName('ID').AsInteger;
  finally
    ibqKProcedures.Close;
  end;
end;

procedure TFrm_DupParamCaisse.Refresh;
begin
  if ibtSelect.InTransaction then
    ibtSelect.Rollback;

  ClearMagasin;
  ClearOrigine;

  ibqMagasin.Open;
  ibqMagasin.Locate('MAG_ID', VarArrayOf([FLastMAgId]), []);
  edtMagasin.text := ibqMagasinMAG_NOM.AsString;

  que_origine.Open;
  que_origine.LocateNext('POS_ID', VarArrayOf([FLastOriginePosteId]), []);
  edtOrigine.text := que_originePOS_NOM.asstring;

  RefreshDestinationList;
end;

procedure TFrm_DupParamCaisse.RefreshDestinationList;
begin
  que_dest.Close;
  que_dest.Params.ParamByName('MAGID').AsInteger := ibqMagasinMAG_ID.AsInteger;
  que_dest.Params.ParamByName('ORIGINEPOSID').AsInteger := que_originePOS_ID.AsInteger;
  que_dest.Open;

  clbDestinations.Items.Clear;
  while not que_dest.eof do
  begin
    clbDestinations.Items.AddObject(que_destPOS_NOM.AsString, TObject(que_destPOS_ID.AsInteger));
    que_dest.Next;
  end;
end;

procedure TFrm_DupParamCaisse.ClearMagasin;
begin
  ibqMagasin.Close;
  edtMagasin.Clear;

  ClearOrigine;
end;

procedure TFrm_DupParamCaisse.ClearOrigine;
begin
  edtOrigine.Clear;
  que_dest.Close;
  clbDestinations.Items.Clear;
end;

function TFrm_DupParamCaisse.Copie(AFromId, AToId: integer): boolean;
begin
  CopieCSHCaisseParam(AToId);
  CopieGenDossier(AToId);
  CopieCSHBOUTON(AToId);
end;

function TFrm_DupParamCaisse.CopieCSHBOUTON(ADestPosId: integer): boolean;
begin
  //Suppression de tous les btn du poste destination (K_ENABLED -> 0)
  que_btn.close;
  que_btn.parambyname('posid').asinteger := ADestPosId;
  que_btn.open;
  WHILE NOT que_btn.eof DO
  BEGIN
    UpdateK(que_btnBTN_ID.AsInteger, 1);
    que_btn.next;
  END;

  //Creation des nouveaux boutons
  ibqTmpQuery.Close;
  try
    ibqTmpQuery.SQL.Clear;
    ibqTmpQuery.sql.add('insert into cshbouton');
    ibqTmpQuery.sql.add('(BTN_ID, BTN_POSID, BTN_TYPE, BTN_LIB, BTN_COULEUR, BTN_ICONE, BTN_RACCOURCI, ');
    ibqTmpQuery.sql.add('BTN_REMISE, BTN_REMAT, BTN_ARFID, BTN_MENID, BTN_ORDREAFF, BTN_ONGLET)');
    ibqTmpQuery.sql.add('values');
    ibqTmpQuery.sql.add('(:BTN_ID, :BTN_POSID, :BTN_TYPE, :BTN_LIB, :BTN_COULEUR, :BTN_ICONE, ');
    ibqTmpQuery.sql.add(':BTN_RACCOURCI, :BTN_REMISE, :BTN_REMAT, :BTN_ARFID, :BTN_MENID, :BTN_ORDREAFF,');
    ibqTmpQuery.sql.add(':BTN_ONGLET)');

    que_btn.close;
    que_btn.parambyname('posid').asinteger := que_originePOS_ID.asinteger;
    que_btn.open;
    WHILE NOT que_btn.eof DO
    BEGIN
      ibqTmpQuery.parambyname('BTN_id').asinteger := NewK('CSHBOUTON');
      ibqTmpQuery.parambyname('BTN_POSID').asinteger := que_destPOS_ID.asinteger;

      ibqTmpQuery.parambyname('BTN_TYPE').asinteger := que_btnBTN_TYPE.asinteger;
      ibqTmpQuery.parambyname('BTN_LIB').asstring := que_btnBTN_LIB.asstring;
      ibqTmpQuery.parambyname('BTN_COULEUR').asinteger := que_btnBTN_COULEUR.asinteger;
      ibqTmpQuery.parambyname('BTN_ICONE').asstring := que_btnBTN_ICONE.asstring;
      ibqTmpQuery.parambyname('BTN_RACCOURCI').asstring := que_btnBTN_RACCOURCI.asstring;
      ibqTmpQuery.parambyname('BTN_REMISE').asfloat := que_btnBTN_REMISE.asfloat;
      ibqTmpQuery.parambyname('BTN_REMAT').asinteger := que_btnBTN_REMAT.asinteger;
      ibqTmpQuery.parambyname('BTN_ARFID').asinteger := que_btnBTN_ARFID.asinteger;
      ibqTmpQuery.parambyname('BTN_MENID').asinteger := que_btnBTN_MENID.asinteger;
      ibqTmpQuery.parambyname('BTN_ORDREAFF').asinteger := que_btnBTN_ORDREAFF.asinteger;
      ibqTmpQuery.parambyname('BTN_ONGLET').asinteger := que_btnBTN_ONGLET.asinteger;

      ibqTmpQuery.ExecSQL;

      que_btn.next;
    END;
  finally
    ibqTmpQuery.Close;
  end;
end;

function TFrm_DupParamCaisse.CopieCSHCaisseParam(ADestPosId: integer): boolean;
begin
  try
    ibqTmpQuery.Close;
    ibqTmpQuery.SQL.Clear;

    // On regarde si le poste de destination à déjà un enregistrement actif (K_ENABLED = 1) sur CSHCAISSEPARAM
    ibqCSHCaisseParam.Close;
    ibqCSHCaisseParam.ParamByName('POSID').AsInteger := ADestPosId;
    ibqCSHCaisseParam.Open;

    if ibqCSHCaisseParam.IsEmpty then // Création d'un nouveau CSHCAISSEPARAM
    begin
      ibqTmpQuery.SQL.Text := getInsertIntoCSHCaisseParamSQLText;
      ibqTmpQuery.ParamByName('CAI_ID').AsInteger := NewK('CSHCAISSEPARAM');
    end
    else // Modification du CSHCAISSEPARAM existant
    begin
      ibqTmpQuery.SQL.Text := getUpdateCSHCaisseParamSQLText;
      UpdateK(ibqCSHCaisseParam.FieldByName('CAI_ID').AsInteger, 0);
    end;

    ibqTmpQuery.Prepare;
    ibqTmpQuery.parambyname('CAI_POSID').asinteger := ADestPosId;

    // On se positionne sur le CSHCAISSEPARAM du poste d'orgine
    ibqOrigineCaisseParam.close;
    ibqOrigineCaisseParam.parambyname('posid').asinteger := que_originePOS_ID.asinteger;
    ibqOrigineCaisseParam.open;

    ibqTmpQuery.parambyname('CAI_CAISSIER').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_CAISSIER').asinteger;
    ibqTmpQuery.parambyname('CAI_VENDEUR').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_VENDEUR').asinteger;
    ibqTmpQuery.parambyname('CAI_COMMENTREMISE').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_COMMENTREMISE').asinteger;
    ibqTmpQuery.parambyname('CAI_AFFICHEUR').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_AFFICHEUR').asinteger;
    ibqTmpQuery.parambyname('CAI_JCBANDE').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_JCBANDE').asinteger;
    ibqTmpQuery.parambyname('CAI_IMPCHEQUE').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_IMPCHEQUE').asinteger;
    ibqTmpQuery.parambyname('CAI_IMPFACTURETTE').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_IMPFACTURETTE').asinteger;
    ibqTmpQuery.parambyname('CAI_IMPBC').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_IMPBC').asinteger;
    ibqTmpQuery.parambyname('CAI_TIROIR').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_TIROIR').asinteger;
    ibqTmpQuery.parambyname('CAI_ENTETE').asstring := ibqOrigineCaisseParam.fieldbyname('CAI_ENTETE').asstring;
    ibqTmpQuery.parambyname('CAI_PIED').asstring := ibqOrigineCaisseParam.fieldbyname('CAI_PIED').asstring;
    ibqTmpQuery.parambyname('CAI_NBLIGNEMASSICOT').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_NBLIGNEMASSICOT').asinteger;
    ibqTmpQuery.parambyname('CAI_GROSPRIX').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_GROSPRIX').asinteger;
    ibqTmpQuery.parambyname('CAI_DOCMGHAUTE').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_DOCMGHAUTE').asinteger;
    ibqTmpQuery.parambyname('CAI_DOCMGBAS').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_DOCMGBAS').asinteger;
    ibqTmpQuery.parambyname('CAI_DOCENTETE').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_DOCENTETE').asinteger;
    ibqTmpQuery.parambyname('CAI_DOCDEFAUT').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_DOCDEFAUT').asinteger;
    ibqTmpQuery.parambyname('CAI_DIV1').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_DIV1').asinteger;
    ibqTmpQuery.parambyname('CAI_DIV2').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_DIV2').asinteger;
    ibqTmpQuery.parambyname('CAI_LIBCHEQUE').asstring := ibqOrigineCaisseParam.fieldbyname('CAI_LIBCHEQUE').asstring;
    ibqTmpQuery.parambyname('CAI_COLCODE').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_COLCODE').asinteger;
    ibqTmpQuery.parambyname('CAI_CAISSIERUNIQUE').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_CAISSIERUNIQUE').asinteger;
    ibqTmpQuery.parambyname('CAI_IMPTICKET').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_IMPTICKET').asinteger;
    ibqTmpQuery.parambyname('CAI_DIV3').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_DIV3').asinteger;
    ibqTmpQuery.parambyname('CAI_DIV4').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_DIV4').asinteger;
    ibqTmpQuery.parambyname('CAI_VERSION').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_VERSION').asinteger;
    ibqTmpQuery.parambyname('CAI_ARRONDI').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_ARRONDI').asinteger;
    ibqTmpQuery.parambyname('CAI_REAJUSTCOMPTE').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_REAJUSTCOMPTE').asinteger;
    ibqTmpQuery.parambyname('CAI_LOC').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_LOC').asinteger;
    ibqTmpQuery.parambyname('CAI_ONGLET').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_ONGLET').asinteger;
    ibqTmpQuery.parambyname('CAI_DEVISAUTO').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_DEVISAUTO').asinteger;
    ibqTmpQuery.parambyname('CAI_FACTAUTO').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_FACTAUTO').asinteger;
    ibqTmpQuery.parambyname('CAI_NBJHISTOCOMPTE').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_NBJHISTOCOMPTE').asinteger;
    ibqTmpQuery.parambyname('CAI_TPE').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_TPE').asinteger;
    ibqTmpQuery.parambyname('CAI_SERVEURTPE').asstring := ibqOrigineCaisseParam.fieldbyname('CAI_SERVEURTPE').asstring;
    ibqTmpQuery.parambyname('CAI_SKIMAN').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_SKIMAN').asinteger;
    ibqTmpQuery.parambyname('CAI_PACKOTO').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_PACKOTO').asinteger;
    ibqTmpQuery.parambyname('CAI_DOCLOCLASER').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_DOCLOCLASER').asinteger;
    ibqTmpQuery.parambyname('CAI_LOCLASERDEVIS').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_LOCLASERDEVIS').asinteger;
    ibqTmpQuery.parambyname('CAI_LOCLASERFACT').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_LOCLASERFACT').asinteger;
    ibqTmpQuery.parambyname('CAI_CAUTION').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_CAUTION').asinteger;
    ibqTmpQuery.parambyname('CAI_CONSULTATION').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_CONSULTATION').asinteger;
    ibqTmpQuery.parambyname('CAI_PRIXENFRANC').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_PRIXENFRANC').asinteger;
    ibqTmpQuery.parambyname('CAI_LOGO').asstring := ibqOrigineCaisseParam.fieldbyname('CAI_LOGO').asstring;
    ibqTmpQuery.parambyname('CAI_NBLLOGO').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_NBLLOGO').asinteger;
    ibqTmpQuery.parambyname('CAI_LOGOFACTURETTE').asinteger := ibqOrigineCaisseParam.fieldbyname('CAI_LOGOFACTURETTE').asinteger;
    ibqTmpQuery.parambyname('CAI_PASSWORDC').AsInteger := ibqOrigineCaisseParam.fieldbyname('CAI_PASSWORDC').asinteger;
    ibqTmpQuery.parambyname('CAI_DBLDL').AsInteger := ibqOrigineCaisseParam.fieldbyname('CAI_DBLDL').asinteger;
    ibqTmpQuery.parambyname('CAI_TICKETDEPOSANT').AsInteger := ibqOrigineCaisseParam.fieldbyname('CAI_TICKETDEPOSANT').asinteger;
    ibqTmpQuery.parambyname('CAI_NBDOCDV').AsInteger := ibqOrigineCaisseParam.fieldbyname('CAI_NBDOCDV').asinteger;
    ibqTmpQuery.parambyname('CAI_MOTID').AsInteger := ibqOrigineCaisseParam.fieldbyname('CAI_MOTID').asinteger;

    ibqTmpQuery.ExecSQL;

  finally
    ibqTmpQuery.Close;
  end;
end;

function TFrm_DupParamCaisse.CopieGenDossier(ADestPosId: integer): boolean;

  function CopieGenDossierValue(ADestPosId: integer;
    ADosNom: string; ADosFloat: Double): boolean;
  var
    selectQuery: TIBQuery;
    updateQuery: TIBQuery;
  begin
    updateQuery := TIBQuery.Create(self);
    updateQuery.Database := Data;
    updateQuery.Transaction := ibtCopie;

    selectQuery := TIBQuery.Create(self);
    selectQuery.Database := Data;
    selectQuery.Transaction := ibtCopie;

    selectQuery.Close;
    selectQuery.SQL.Clear;
    selectQuery.SQL.Text :=
      'SELECT * ' +
      'FROM ' +
      '  GENDOSSIER JOIN K ON K.K_ID = GENDOSSIER.DOS_ID AND K.K_ENABLED = 1 ' +
      'WHERE ' +
      '  DOS_STRING = :POSID ' +
      '  AND DOS_FLOAT = :DOSFLOAT';

    try
      selectQuery.Params.ParamByName('POSID').AsString := IntToStr(ADestPosId);
      selectQuery.Params.ParamByName('DOSFLOAT').AsFloat := ADosFloat;
      selectQuery.Open;
      if not selectQuery.IsEmpty then
      begin
        updateQuery.Close;
        updateQuery.SQL.Clear;
        updateQuery.SQL.Text :=
          'UPDATE ' +
          '  GENDOSSIER ' +
          'SET ' +
          '  DOS_NOM = :DOSNOM ' +
          'WHERE ' +
          '  DOS_STRING = :POSID AND DOS_FLOAT = :DOSFLOAT';
        updateQuery.Prepare;
        updateQuery.Params.ParamByName('DOSNOM').AsString := ADosNom;
        updateQuery.Params.ParamByName('POSID').AsString := IntToStr(ADestPosId);
        updateQuery.Params.ParamByName('DOSFLOAT').AsFloat := ADosFloat;
        updateQuery.ExecSQL;

        UpdateK(selectQuery.FieldByName('DOS_ID').AsInteger, 0);
      end
      else
      begin
        updateQuery.Close;
        updateQuery.SQL.Clear;
        updateQuery.SQL.Text :=
          'INSERT INTO ' +
          '  GENDOSSIER (' +
          '    DOS_ID, DOS_NOM, DOS_STRING, DOS_FLOAT, DOS_CODE ' +
          '  ) ' +
          '  VALUES(:DOSID, :DOSNOM, :DOSSTRING, :DOSFLOAT, :DOSCODE) ';
        updateQuery.Params.ParamByName('DOSID').AsInteger := NewK('GENDOSSIER');
        updateQuery.Params.ParamByName('DOSNOM').AsString := ADosNom;
        updateQuery.Params.ParamByName('DOSSTRING').AsString := IntToStr(ADestPosId);
        updateQuery.Params.ParamByName('DOSFLOAT').AsFloat := ADosFloat;
        updateQuery.Params.ParamByName('DOSCODE').AsString := '';
        updateQuery.ExecSQL;
      end;

    finally
      selectQuery.Close;
      selectQuery.Free;

      updateQuery.Close;
      updateQuery.Free;
    end;
  end;

begin
  ibqTmpQuery.Close;
  ibqTmpQuery.SQL.Clear;
  ibqTmpQuery.SQL.Text :=
    'SELECT * ' +
    'FROM ' +
    '  GENDOSSIER JOIN K ON K.K_ID = GENDOSSIER.DOS_ID AND K.K_ENABLED = 1 ' +
    'WHERE ' +
    '  DOS_STRING = :POSID ' +
    '  AND DOS_FLOAT IN (1, 2, 3, 4)';

  try
    ibqTmpQuery.Params.ParamByName('POSID').AsString := que_originePOS_ID.AsString;
    ibqTmpQuery.Open;
    while not ibqTmpQuery.Eof do
    begin
      CopieGenDossierValue(ADestPosId, ibqTmpQuery.FieldByName('DOS_NOM').AsString,
        ibqTmpQuery.FieldByName('DOS_FLOAT').AsFloat);
      ibqTmpQuery.Next;
    end;
  finally
    ibqTmpQuery.Close;
  end;
end;

procedure TFrm_DupParamCaisse.dxDBGrid1Column2Change(Sender: TObject);
begin
  ShowMessage('change');
end;

procedure TFrm_DupParamCaisse.FormCreate(Sender: TObject);
begin
  LoadDefaultDataBase;
  InitLogs;
end;

function TFrm_DupParamCaisse.GetBaseGUID: String;
begin
  ibqBaseGuid.Close;
  ibqBaseGuid.Open;

  Result := ibqBaseGuid.FieldByName('BAS_GUID').AsString;

  ibqBaseGuid.Close;     
end;

function TFrm_DupParamCaisse.getCheckDestinationsCount: integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to clbDestinations.Count - 1 do
  begin
    if clbDestinations.Checked[i] then
    begin
      inc(result);
    end;
  end;
end;

function TFrm_DupParamCaisse.getInsertIntoCSHCaisseParamSQLText: string;
begin
  Result := 'INSERT INTO CSHCAISSEPARAM (' +
        ' CAI_ID,' +
        ' CAI_CAISSIER,' +      
        ' CAI_VENDEUR,' +
        ' CAI_COMMENTREMISE,' +
        ' CAI_AFFICHEUR,' +
        ' CAI_JCBANDE,' +
        ' CAI_IMPCHEQUE,' +
        ' CAI_IMPFACTURETTE,' +
        ' CAI_IMPBC,' +
        ' CAI_TIROIR,' +
        ' CAI_ENTETE,' +
        ' CAI_PIED,' +
        ' CAI_NBLIGNEMASSICOT,' +
        ' CAI_GROSPRIX,' +
        ' CAI_DOCMGHAUTE,' +
        ' CAI_DOCMGBAS,' +
        ' CAI_DOCENTETE,' +
        ' CAI_POSID,' +
        ' CAI_DOCDEFAUT,' +
        ' CAI_DIV1,' +
        ' CAI_DIV2,' +
        ' CAI_LIBCHEQUE,' +
        ' CAI_COLCODE,' +
        ' CAI_CAISSIERUNIQUE,' +
        ' CAI_IMPTICKET,' +
        ' CAI_DIV3,' +
        ' CAI_DIV4,' +
        ' CAI_VERSION,' +
        ' CAI_ARRONDI, ' +
        ' CAI_REAJUSTCOMPTE,' +
        ' CAI_LOC,' +
        ' CAI_ONGLET,' +
        ' CAI_DEVISAUTO,' +
        ' CAI_FACTAUTO,' +
        ' CAI_NBJHISTOCOMPTE,' +
        ' CAI_TPE,' +
        ' CAI_SERVEURTPE,' +
        ' CAI_SKIMAN,' +
        ' CAI_PACKOTO,' +
        ' CAI_DOCLOCLASER,' +
        ' CAI_LOCLASERDEVIS, ' +
        ' CAI_LOCLASERFACT,' +
        ' CAI_CAUTION,' +
        ' CAI_CONSULTATION,' +
        ' CAI_PRIXENFRANC,' +
        ' CAI_LOGO,' +
        ' CAI_NBLLOGO,' +
        ' CAI_LOGOFACTURETTE,' +
        ' CAI_PASSWORDC,' +
        ' CAI_DBLDL,' +
        ' CAI_TICKETDEPOSANT,' +
        ' CAI_NBDOCDV,' +
        ' CAI_MOTID' +
        ') ' +
        'VALUES (' +
        ' :CAI_ID,' +
        ' :CAI_CAISSIER,' +      
        ' :CAI_VENDEUR,' +
        ' :CAI_COMMENTREMISE,' +
        ' :CAI_AFFICHEUR,' +
        ' :CAI_JCBANDE,' +
        ' :CAI_IMPCHEQUE,' +
        ' :CAI_IMPFACTURETTE,' +
        ' :CAI_IMPBC,' +
        ' :CAI_TIROIR,' +
        ' :CAI_ENTETE,' +
        ' :CAI_PIED,' +
        ' :CAI_NBLIGNEMASSICOT,' +
        ' :CAI_GROSPRIX,' +
        ' :CAI_DOCMGHAUTE,' +
        ' :CAI_DOCMGBAS,' +
        ' :CAI_DOCENTETE,' +
        ' :CAI_POSID,' +
        ' :CAI_DOCDEFAUT,' +
        ' :CAI_DIV1,' +
        ' :CAI_DIV2,' +
        ' :CAI_LIBCHEQUE,' +
        ' :CAI_COLCODE,' +
        ' :CAI_CAISSIERUNIQUE,' +
        ' :CAI_IMPTICKET,' +
        ' :CAI_DIV3,' +
        ' :CAI_DIV4,' +
        ' :CAI_VERSION,' +
        ' :CAI_ARRONDI, ' +
        ' :CAI_REAJUSTCOMPTE,' +
        ' :CAI_LOC,' +
        ' :CAI_ONGLET,' +
        ' :CAI_DEVISAUTO,' +
        ' :CAI_FACTAUTO,' +
        ' :CAI_NBJHISTOCOMPTE,' +
        ' :CAI_TPE,' +
        ' :CAI_SERVEURTPE,' +
        ' :CAI_SKIMAN,' +
        ' :CAI_PACKOTO,' +
        ' :CAI_DOCLOCLASER,' +
        ' :CAI_LOCLASERDEVIS, ' +      
        ' :CAI_LOCLASERFACT,' +
        ' :CAI_CAUTION,' +
        ' :CAI_CONSULTATION,' +
        ' :CAI_PRIXENFRANC,' +
        ' :CAI_LOGO,' +
        ' :CAI_NBLLOGO,' +
        ' :CAI_LOGOFACTURETTE,' +
        ' :CAI_PASSWORDC,' +
        ' :CAI_DBLDL,' +
        ' :CAI_TICKETDEPOSANT,' +
        ' :CAI_NBDOCDV,' +
        ' :CAI_MOTID' +
        ')';
end;

function TFrm_DupParamCaisse.getUpdateCSHCaisseParamSQLText: string;
begin
  Result := 
        'UPDATE CSHCAISSEPARAM SET' +
        ' CAI_CAISSIER = :CAI_CAISSIER, ' +  
        ' CAI_VENDEUR = :CAI_VENDEUR,' +
        ' CAI_COMMENTREMISE = :CAI_COMMENTREMISE,' +
        ' CAI_AFFICHEUR = :CAI_AFFICHEUR,' +
        ' CAI_JCBANDE = :CAI_JCBANDE,' +
        ' CAI_IMPCHEQUE = :CAI_IMPCHEQUE,' +
        ' CAI_IMPFACTURETTE = :CAI_IMPFACTURETTE,' +
        ' CAI_IMPBC = :CAI_IMPBC,' +
        ' CAI_TIROIR = :CAI_TIROIR,' +
        ' CAI_ENTETE = :CAI_ENTETE,' +
        ' CAI_PIED = :CAI_PIED,' +
        ' CAI_NBLIGNEMASSICOT = :CAI_NBLIGNEMASSICOT,' +
        ' CAI_GROSPRIX = :CAI_GROSPRIX,' +
        ' CAI_DOCMGHAUTE = :CAI_DOCMGHAUTE,' +
        ' CAI_DOCMGBAS = :CAI_DOCMGBAS,' +
        ' CAI_DOCENTETE = :CAI_DOCENTETE,' +
        ' CAI_DOCDEFAUT = :CAI_DOCDEFAUT,' +
        ' CAI_DIV1 = :CAI_DIV1,' +
        ' CAI_DIV2 = :CAI_DIV2,' +
        ' CAI_LIBCHEQUE = :CAI_LIBCHEQUE,' +
        ' CAI_COLCODE = :CAI_COLCODE,' +
        ' CAI_CAISSIERUNIQUE = :CAI_CAISSIERUNIQUE,' +
        ' CAI_IMPTICKET = :CAI_IMPTICKET,' +
        ' CAI_DIV3 = :CAI_DIV3,' +
        ' CAI_DIV4 = :CAI_DIV4,' +
        ' CAI_VERSION = :CAI_VERSION,' +
        ' CAI_ARRONDI = :CAI_ARRONDI, ' +
        ' CAI_REAJUSTCOMPTE = :CAI_REAJUSTCOMPTE,' +
        ' CAI_LOC = :CAI_LOC,' +
        ' CAI_ONGLET = :CAI_ONGLET,' +
        ' CAI_DEVISAUTO = :CAI_DEVISAUTO ,' +
        ' CAI_FACTAUTO = :CAI_FACTAUTO,' +
        ' CAI_NBJHISTOCOMPTE = :CAI_NBJHISTOCOMPTE,' +
        ' CAI_TPE = :CAI_TPE,' +
        ' CAI_SERVEURTPE = :CAI_SERVEURTPE,' +
        ' CAI_SKIMAN = :CAI_SKIMAN,' +
        ' CAI_PACKOTO = :CAI_PACKOTO,' +
        ' CAI_DOCLOCLASER = :CAI_DOCLOCLASER,' +
        ' CAI_LOCLASERDEVIS = :CAI_LOCLASERDEVIS,' +      
        ' CAI_LOCLASERFACT = :CAI_LOCLASERFACT,' +
        ' CAI_CAUTION = :CAI_CAUTION,' +
        ' CAI_CONSULTATION = :CAI_CONSULTATION,' +
        ' CAI_PRIXENFRANC = :CAI_PRIXENFRANC,' +
        ' CAI_LOGO = :CAI_LOGO,' +
        ' CAI_NBLLOGO = :CAI_NBLLOGO,' +
        ' CAI_LOGOFACTURETTE = :CAI_LOGOFACTURETTE,' +
        ' CAI_PASSWORDC = :CAI_PASSWORDC,' +
        ' CAI_DBLDL = :CAI_DBLDL,' +
        ' CAI_TICKETDEPOSANT = :CAI_TICKETDEPOSANT,' +
        ' CAI_NBDOCDV = :CAI_NBDOCDV,' +
        ' CAI_MOTID = :CAI_MOTID ' +
        'WHERE ' +
        ' CAI_POSID = :CAI_POSID';
end;

procedure TFrm_DupParamCaisse.InitLogs;
begin
  log.readIni;
  log.App := 'DupParamCaisse';
  log.Ref := GetBaseGuid;
  log.Open;
  log.SaveIni;
end;

procedure TFrm_DupParamCaisse.LoadDefaultDataBase;
var
  reg: TRegistry;
begin
  try
    reg := TRegistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;

    if reg.KeyExists('\SOFTWARE\Algol\Ginkoia') then
    begin
      if reg.OpenKeyReadOnly('\SOFTWARE\Algol\Ginkoia') then
      begin
        edtDataBase.text := reg.ReadString('Base0');
        Data.Close;
        Data.DatabaseName := reg.ReadString('Base0');
        Data.Open;
      end;
    end;
  finally
    reg.CloseKey;
    reg.Free;
  end;
end;

procedure TFrm_DupParamCaisse.actCopieExecute(Sender: TObject);
var
  i: integer;
  result: integer;
  keepasking: boolean; // A False dans le cas "Oui pour tous" cliqué lors de la demande de confirmation de traitement
  executecopy: boolean;

  dlgbutons: TMsgDlgButtons;

  index: integer;
  despostlist: array of integer;
  sPostId: string; // Pour logger les postes copiés
begin
  //Récupération des postes cochés dans la liste.
  index := 0;
  SetLength(despostlist, index);
  for i := 0 to clbDestinations.Count - 1 do
  begin
    if clbDestinations.Checked[i] then
    begin
      inc(index);
      SetLength(despostlist, index);
      despostlist[index - 1] := Integer(clbDestinations.Items.Objects[i]);
    end;
  end;

  dlgbutons := [];

  // Suivant le nombres de postes cochés à la confirmation de traitement la liste des boutons change
  if length(despostlist) = 1 then
    dlgbutons := [mbYes, mbCancel]
  else
    dlgbutons := [mbYes, mbYesToAll, mbNo, mbCancel];

  try
    sPostId := '';
    ibtCopie.StartTransaction;
    keepasking := True;
    for i := 0 to length(despostlist) - 1 do
    begin
      que_dest.Locate('POS_ID', VarArrayOf([despostlist[i]]), []);
      if keepasking then
      begin
        result :=  MessageDlg(Format('Vous allez copier le paramétrage du "%s" vers "%s"'
            + #10#13 + 'Voulez-vous continuer ?', [que_originePOS_NOM.AsString,
            que_dest.FieldByName('POS_NOM').AsString]),
            mtConfirmation, dlgbutons, 0);
        case result of
          IDYES: executecopy := True;
          IDNO: executeCopy := False;
          IDCANCEL:
          begin
            executecopy := False;
            ibtCopie.Rollback;
            Exit;
          end;
          IDTRYAGAIN:
          begin
            executecopy := True;
            keepasking := False;
          end;
        end;
      end
      else
        executecopy := True;

      if executecopy then
      try
        Screen.Cursor := crSQLWait;
        sPostId := Format('%s %s', [sPostId, que_dest.FieldByName('POS_NOM').AsString]);
        Copie( que_originePOS_ID.AsInteger, que_dest.FieldByName('POS_ID').AsInteger );
      finally
        Screen.Cursor := crDefault;
      end;
    end;

    ibtCopie.Commit;

    ShowMessage('Copie effectuée');
    log.Log('DupParamCaisse', log.Ref, ibqMagasinMAG_ID.AsString,
      'Copy', Format('Depuis %s : vers %s', [que_originePOS_NOM.AsString, sPostId]),
      logInfo, False, 0, ltBoth);

    Refresh;
  except
    ibtCopie.Rollback;
    Raise;
  end;

  RefreshDestinationList;
end;

procedure TFrm_DupParamCaisse.actCopieUpdate(Sender: TObject);
begin
  actCopie.Enabled := getCheckDestinationsCount > 0;
end;

procedure TFrm_DupParamCaisse.actSearchDatabaseExecute(Sender: TObject);
begin
  IF od.execute THEN
    edtDataBase.text := Od.filename;
  Data.Close;
  Data.DatabaseName := edtDataBase.text;
  Data.Open;

  ClearMagasin;
end;

procedure TFrm_DupParamCaisse.actSearchMagasinExecute(Sender: TObject);
begin
  if ibtSelect.InTransaction then
    ibtSelect.Rollback;
    

  ClearMagasin;
  IF lkdMagasin.execute THEN
  begin
    FLastMAgId := ibqMagasinMAG_ID.AsInteger;
    edtMagasin.text := ibqMagasinMAG_NOM.AsString;
  end;
end;

procedure TFrm_DupParamCaisse.actSearchMagasinUpdate(Sender: TObject);
begin
  actSearchMagasin.Enabled := Data.Connected;
end;

function TFrm_DupParamCaisse.UpdateK(AId: integer; AType: integer): boolean;
begin
  Result := False;

  ibqKProcedures.Close;
  try
    ibqKProcedures.SQL.Clear;
    ibqKProcedures.SQL.Text := 'EXECUTE PROCEDURE PR_UPDATEK(:ID, :TYPE)';
    ibqKProcedures.Prepare;
    ibqKProcedures.Params.ParamByName('ID').AsInteger := AId;
    ibqKProcedures.Params.ParamByName('TYPE').AsInteger := AType;

    ibqKProcedures.ExecSQL;

    Result := True;
  finally
    ibqKProcedures.Close;
  end;
end;

procedure TFrm_DupParamCaisse.WindowClose1Execute(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrm_DupParamCaisse.WindowClose1Update(Sender: TObject);
begin
  WindowClose1.Enabled := True;
end;

END.

