//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

unit ParamSynchro_Frm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  AlgolStdFrm,
  ExtCtrls, Db, dxmdaset, IBCustomDataSet, IBQuery, DBCtrls, StdCtrls,
  RzLabel, RzPanelRv, RzPanel, LMDControl, LMDBaseControl,
  LMDBaseGraphicButton, LMDCustomSpeedButton, LMDSpeedButton, Buttons;

type
  TFrm_ParamSynchro = class(TAlgolStdFrm)
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TLMDSpeedButton;
    Nbt_Post: TLMDSpeedButton;
    RzPanelRv1: TRzPanelRv;
    Lab_CheminServeur: TRzLabel;
    Que_ParamSynchro: TIBQuery;
    Que_ParamSynchroPRM_STRING: TIBStringField;
    Que_ParamSynchroPRM_INTEGER: TIntegerField;
    IBQue_UpdateParamNb: TIBQuery;
    Que_ParamSynchroPRM_ID: TIntegerField;
    IBQue_UpdateK: TIBQuery;
    IBStringField2: TIBStringField;
    IntegerField2: TIntegerField;
    RzLabel1: TRzLabel;
    Que_Bases: TIBQuery;
    Que_ParamSynchroPRM_FLOAT: TFloatField;
    Chp_PathServeur: TEdit;
    Que_BasesBAS_ID: TIntegerField;
    Que_BasesBAS_NOM: TIBStringField;
    Que_BasesBAS_IDENT: TIBStringField;
    MemD_Base: TdxMemData;
    MemD_BaseBAS_ID: TIntegerField;
    MemD_BaseBAS_NOM: TStringField;
    MemD_BaseBAS_IDENT: TStringField;
    IBQue_Base: TIBQuery;
    IBQue_BaseBAS_ID: TIntegerField;
    IBQue_BaseBAS_NOM: TIBStringField;
    IBQue_BaseBAS_IDENT: TIBStringField;
    Chp_Activer: TCheckBox;
    Chp_NomServeur: TDBLookupComboBox;
    IBQue_UpdateParamServeur: TIBQuery;
    Ds_Bases: TDataSource;
    Ds_Base: TDataSource;
    Que_ParamServeur: TIBQuery;
    Que_ParamServeurPRM_ID: TIntegerField;
    Que_ParamServeurPRM_STRING: TIBStringField;
    Que_ParamServeurPRM_INTEGER: TIntegerField;
    Que_ParamServeurPRM_FLOAT: TFloatField;
    Nbt_PathServeur: TSpeedButton;
    OD_PathServeur: TOpenDialog;
    procedure Nbt_PostClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure AlgolMainFrmKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AlgolStdFrmCreate(Sender: TObject);
    procedure Pan_BtnEnter(Sender: TObject);
    procedure Pan_BtnExit(Sender: TObject);
    procedure Chp_PathServeurChange(Sender: TObject);
    procedure AlgolStdFrmShow(Sender: TObject);
    procedure Chp_ActiverClick(Sender: TObject);
    procedure updateParametres();
    procedure Nbt_PathServeurClick(Sender: TObject);
  private
    UserCanModify, UserVisuMags, modified: Boolean;
    prmid: Integer;
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published

  end;

function ExecuteParamSynchro(): Boolean;

implementation
{$R *.DFM}
uses
  StdUtils,
  GinkoiaResStr, LaunchV7_Dm;

var
  Frm_ParamSynchro: TFrm_ParamSynchro;
  numBase: Integer;

function ExecuteParamSynchro(): Boolean;
begin
  Result := False;
  Application.createform(TFrm_ParamSynchro, Frm_ParamSynchro);
  with Frm_ParamSynchro do
  begin
    try
      screen.Cursor := crSQLWait;
      //initialisation de données
      Que_ParamSynchro.close;
      Que_ParamSynchro.open;
      if Que_ParamSynchro.RecordCount = 1 then
      begin
        //afficher les résultats des requetes
        if Que_ParamSynchroPRM_INTEGER.asinteger = 0 then
        begin
          Chp_Activer.checked := false
        end
        else
        begin
          Chp_Activer.checked := true;
        end;
        //id du paramétre du note book à modifier
        prmid := Que_ParamSynchroPRM_ID.asInteger;
        Chp_PathServeur.text := Que_ParamSynchroPRM_String.asString;
        Que_Bases.close;
        IBQue_Base.Close;
        IBQue_Base.paramByname('ident').value := intToStr(Que_ParamSynchroPRM_FLOAT.asinteger);
        //la base actuelle
        IBQue_Base.Open;
        //liste des bases
        Que_Bases.open;
        //stocker dans un memdata pour contourner le probléme 'ReadOnly' des query
        MemD_Base.Append;
        MemD_BaseBAS_ID.asinteger := IBQue_BaseBAS_ID.asinteger;
        MemD_BaseBAS_NOM.asString := IBQue_BaseBAS_NOM.asString;
        MemD_BaseBAS_IDENT.asString := IBQue_BaseBAS_IDENT.asString;
        MemD_Base.Post;
        //si ident à 0 afficher l'enregistrement vide
        if (Que_ParamSynchroPrm_FLoat.asinteger = 0) then
        begin
          Que_Bases.First;
        end;
        if Showmodal = mrOk then
        begin
          updateParametres();
          Result := True;
        end;
      END;
    finally
      Que_ParamSynchro.close;
      Que_Bases.close;
      IBQue_Base.Close;
      screen.Cursor := crDefault;
      Free;
    end;
  end;
end;

procedure TFrm_ParamSynchro.AlgolStdFrmCreate(Sender: TObject);
begin
  Hint := Caption;
  Dm_LaunchV7.AffecteHintEtBmp(self);
  //initialiser la boite de dialogue fichier
  //repertoire par défaut
  OD_PathServeur.InitialDir := ExtractFilePath(Application.ExeName);
  //options
  OD_PathServeur.Options := [ofFileMustExist];
  //filtre
  OD_PathServeur.Filter := 'Fichiers ib (*.ib)|*.ib';
  OD_PathServeur.FilterIndex := 1;
end;

procedure TFrm_ParamSynchro.AlgolMainFrmKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_ESCAPE: Nbt_CancelClick(Sender);
    VK_F12: Nbt_PostClick(Sender);
    VK_RETURN: if Pan_Btn.Focused then Nbt_PostClick(Sender);
  end;
end;

procedure TFrm_ParamSynchro.Nbt_PostClick(Sender: TObject);
begin
  //si 'activer' vérifier que les infos sont toutes renseignées
  if chp_Activer.checked then
  begin
    //que le chemin est bien renseigné et qu'un serveur est attribué
    if (trim(chp_PathServeur.text) = '') or (trim(chp_NomServeur.text) = '') then
    begin
      MessageDlg('Tous les champs doivent être renseignés pour activer la synchronisation', mtWarning, [mbOk], 0);
    end
    else
    begin
      ModalResult := mrOk;
    end;
  end
  else
  begin
    ModalResult := mrOk;
  end;
end;

procedure TFrm_ParamSynchro.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_ParamSynchro.Pan_BtnEnter(Sender: TObject);
begin
  Nbt_Post.Font.style := [fsBold];
end;

procedure TFrm_ParamSynchro.Pan_BtnExit(Sender: TObject);
begin
  Nbt_Post.Font.style := [];
end;

procedure TFrm_ParamSynchro.Chp_PathServeurChange(Sender: TObject);
begin
  modified := true;
end;

procedure TFrm_ParamSynchro.AlgolStdFrmShow(Sender: TObject);
begin
  modified := false;
  Chp_NomServeur.SetFocus;
end;

procedure TFrm_ParamSynchro.Chp_ActiverClick(Sender: TObject);
begin
  modified := true;
end;

procedure TFrm_ParamSynchro.updateParametres;
var
  serveurIdent: Integer;
begin
  try
    //tester le changement du paramètre du serveur associer
    if (IBQue_BaseBAS_IDENT.asString <> Que_BasesBAS_IDENT.Asstring) then
      modified := true;
    //si modifications alors sauver:
    if modified then
    begin
      //mettre à jour les paramétres pour la base du portable
      //ouvrir une transaction
      IBQue_UpdateParamNb.Transaction.Active := true;
      IBQue_UpdateParamNb.paramByName('prmid').value := prmid;
      if Chp_Activer.checked then
        IBQue_UpdateParamNb.paramByName('actif').value := 1
      else
        IBQue_UpdateParamNb.paramByName('actif').value := 0;
      //sauver l'association à une base serveur
      IBQue_UpdateParamNb.paramByName('identServeur').value := Que_BasesBAS_IDENT.asinteger;
      serveurIdent := Que_BasesBAS_IDent.asinteger;
      IBQue_UpdateParamNb.paramByName('chemin').value := copy(Chp_PathServeur.text, 1, 255);
      IBQue_UpdateParamNb.ExecSQL;
      //mettre à jour K_version pour param base portable
      IBQue_UpdateK.paramByName('id').value := prmid;
      IBQue_UpdateK.ExecSql;
      IBQue_UpdateParamNb.Transaction.commit;
      //si synchronisation mettre à jour les paramétres pour la base du serveur
      if Chp_Activer.checked then
      begin
        //réouvrir une transaction
        IBQue_UpdateParamServeur.Transaction.Active := true;
        //activer le serveur choisi
        IBQue_UpdateParamServeur.paramByName('ident').value := serveurIdent;
        IBQue_UpdateParamServeur.paramByName('actif').value := 1;
        IBQue_UpdateParamServeur.ExecSQL;
        //récupèrer l'id du paramètre du serveur
        Que_ParamServeur.close;
        Que_ParamServeur.ParambyName('baseIdent').value := serveurIdent;
        Que_ParamServeur.open;
        //mettre à jour K_version pour param du serveur
        IBQue_UpdateK.paramByName('id').value := Que_ParamServeurPRM_ID.asinteger;
        IBQue_UpdateK.ExecSql;
        //commit
        IBQue_UpdateParamServeur.Transaction.commit;
      end
      else
      begin //todo
        //vérifier si dernier associé au précédent serveur
        //déactiver
        //update de  k_version
      end;
    end;
  finally
    IBQue_UpdateParamNb.close;
    IBQue_UpdateParamServeur.close;
    IBQue_UpdateK.close;
    Que_ParamServeur.close;
  end;
end;

procedure TFrm_ParamSynchro.Nbt_PathServeurClick(Sender: TObject);
begin
  //si un chemin est sélectionné
  if OD_PathServeur.Execute then
  begin
    //recopier son nom
    Chp_PathServeur.Text := OD_PathServeur.FileName;
  end;
end;

end.

