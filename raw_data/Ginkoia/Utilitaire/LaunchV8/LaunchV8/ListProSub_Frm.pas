unit ListProSub_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, LaunchV7_Dm, DB, IBCustomDataSet, IBQuery, dxCntner, dxTL,
  dxDBCtrl, dxDBGrid, dxDBGridHP, dxDBTLCl, dxGrClms, StdCtrls, Mask, DBCtrls,
  RzPanel, RzLabel, Buttons, DBSBtn, IBUpdateSQL;

type
  TFrm_ListProSub = class(TForm)
    IBQue_ListProv: TIBQuery;
    DBG_Providers: TdxDBGridHP;
    Ds_ListProv: TDataSource;
    IBQue_ListProvPRO_ID: TIntegerField;
    IBQue_ListProvPRO_NOM: TIBStringField;
    IBQue_ListProvPRO_ORDRE: TIntegerField;
    IBQue_ListProvPRO_LOOP: TIntegerField;
    DBG_ProvidersPRO_ID: TdxDBGridMaskColumn;
    DBG_ProvidersPRO_NOM: TdxDBGridMaskColumn;
    DBG_ProvidersPRO_ORDRE: TdxDBGridMaskColumn;
    DBG_ProvidersPRO_LOOP: TdxDBGridCheckColumn;
    Chp_LoopProv: TDBCheckBox;
    Chp_NomProv: TDBEdit;
    Lab_NomProv: TLabel;
    Pan_Providers: TRzPanel;
    Pan_ProvBottom: TRzPanel;
    Pan_ProvFond: TRzPanel;
    Pan_ProvFondRight: TRzPanel;
    Pan_Bottom: TRzPanel;
    Pan_ProvTitle: TRzPanel;
    Lab_ProvTitle: TRzLabel;
    Pan_Subs: TRzPanel;
    Pan_SubsBottom: TRzPanel;
    Lab_Subs: TLabel;
    Chp_LoopSub: TDBCheckBox;
    Chp_NomSub: TDBEdit;
    Pan_SubsFond: TRzPanel;
    Pan_SubsFondRight: TRzPanel;
    DBG_Subs: TdxDBGridHP;
    Pan_SubSTitle: TRzPanel;
    Lab_SubsTitle: TRzLabel;
    Nbt_EditProv: TDBSpeedButton;
    Nbt_AppendProv: TDBSpeedButton;
    DBEdit1: TDBEdit;
    Ds_ListSubs: TDataSource;
    IBQue_ListSubs: TIBQuery;
    IBQue_ListSubsSUB_ID: TIntegerField;
    IBQue_ListSubsSUB_NOM: TIBStringField;
    IBQue_ListSubsSUB_ORDRE: TIntegerField;
    IBQue_ListSubsSUB_LOOP: TIntegerField;
    DBG_SubsSUB_ID: TdxDBGridMaskColumn;
    DBG_SubsSUB_NOM: TdxDBGridMaskColumn;
    DBG_SubsSUB_ORDRE: TdxDBGridMaskColumn;
    DBG_SubsSUB_LOOP: TdxDBGridMaskColumn;
    IBUpd_ListSubs: TIBUpdateSQL;
    Nbt_CancelSub: TDBSpeedButton;
    Nbt_PostSub: TDBSpeedButton;
    Nbt_AppendSub: TDBSpeedButton;
    Nbt_EditSub: TDBSpeedButton;
    Nbt_Insert: TDBSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_EditSubBeforeAction(Sender: TObject;
      var ActionIsDone: Boolean);
    procedure Nbt_PostSubBeforeAction(Sender: TObject;
      var ActionIsDone: Boolean);
    procedure Nbt_AppendSubBeforeAction(Sender: TObject;
      var ActionIsDone: Boolean);
    procedure Nbt_InsertBeforeAction(Sender: TObject;
      var ActionIsDone: Boolean);
    procedure Nbt_PostSubAfterAction(Sender: TObject; var Error: Boolean);
    procedure Nbt_CancelSubAfterAction(Sender: TObject; var Error: Boolean);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_ListProSub: TFrm_ListProSub;

implementation

{$R *.dfm}

procedure TFrm_ListProSub.FormCreate(Sender: TObject);
begin
  Dm_LaunchV7.AffecteHintEtBmp(Self);
  IBQue_ListProv.Open;
  IBQue_ListSubs.Open;
end;

procedure TFrm_ListProSub.Nbt_AppendSubBeforeAction(Sender: TObject;
  var ActionIsDone: Boolean);
begin
  DBG_Subs.Enabled := False;
end;

procedure TFrm_ListProSub.Nbt_CancelSubAfterAction(Sender: TObject;
  var Error: Boolean);
begin
  DBG_Subs.Enabled := True;
end;

procedure TFrm_ListProSub.Nbt_EditSubBeforeAction(Sender: TObject;
  var ActionIsDone: Boolean);
begin
  DBG_Subs.Enabled := False;
end;

procedure TFrm_ListProSub.Nbt_InsertBeforeAction(Sender: TObject;
  var ActionIsDone: Boolean);
begin
  DBG_Subs.Enabled := False;
end;

procedure TFrm_ListProSub.Nbt_PostSubAfterAction(Sender: TObject;
  var Error: Boolean);
begin
  DBG_Subs.Enabled := True;
end;

procedure TFrm_ListProSub.Nbt_PostSubBeforeAction(Sender: TObject;
  var ActionIsDone: Boolean);
begin
  if IBQue_ListSubs.State in [dsInsert] then
  begin
  
  end;
end;

end.
