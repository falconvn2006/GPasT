unit ModifDetail_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, StdCtrls, GinkoiaStyle_Dm, AdvGlowButton, RzLabel,
  ExtCtrls, RzPanel;

type
  TFrm_ModifDetail = class(TAlgolDialogForm)
    Lab_FicCsv: TLabel;
    EFicCsv: TEdit;
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Chk_GrantGinkoia: TCheckBox;
    Chk_GrantRepl: TCheckBox;
    Chk_OkDrop: TCheckBox;
    Lab_RecupParam: TLabel;
    Chk_RecupParam: TCheckBox;
    Chk_Actif: TCheckBox;
    procedure Nbt_CancelClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure Lab_RecupParamClick(Sender: TObject);
    procedure Chk_RecupParamClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_ModifDetail: TFrm_ModifDetail;

implementation

uses
  Main_Dm;

{$R *.dfm}

procedure TFrm_ModifDetail.AlgolDialogFormCreate(Sender: TObject);
begin
  EFicCsv.Text := Dm_Main.cds_Proc.FieldByName('FicCsv').AsString;
  Chk_RecupParam.Checked := Dm_Main.cds_Proc.FieldByName('RecupParam').AsBoolean;

  if Dm_Main.cds_Proc.FieldByName('OkGrantGinkoia').AsInteger = 1 then
    Chk_GrantGinkoia.Checked := true
  else
    Chk_GrantGinkoia.Checked := false;
  if Dm_Main.cds_Proc.FieldByName('OkGrantRepl').AsInteger = 1 then
    Chk_GrantRepl.Checked := true
  else
    Chk_GrantRepl.Checked := false;
  if Dm_Main.cds_Proc.FieldByName('OkDropAfterExport').AsInteger = 1 then
    Chk_OkDrop.Checked := true
  else
    Chk_OkDrop.Checked := false;

  Chk_Actif.Checked := Dm_Main.cds_Proc.FieldByName('Actif').AsBoolean;
end;

procedure TFrm_ModifDetail.Chk_RecupParamClick(Sender: TObject);
begin
  Lab_FicCsv.Enabled := not(Chk_RecupParam.Checked);
  EFicCsv.Enabled := not(Chk_RecupParam.Checked);
end;

procedure TFrm_ModifDetail.Lab_RecupParamClick(Sender: TObject);
begin
  Chk_RecupParam.Checked := not(Chk_RecupParam.Checked);
end;

procedure TFrm_ModifDetail.Nbt_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_ModifDetail.Nbt_PostClick(Sender: TObject);
var
  sFic: string;
begin
  sFic := EFicCsv.Text;
  if sFic<>'' then
  begin
    if Pos('.', sFic)=0 then
      sFic := sFic+'.csv';
  end;

  Dm_Main.cds_Proc.Edit;
  Dm_Main.cds_Proc.FieldByName('RecupParam').AsBoolean := Chk_RecupParam.Checked;
  if Chk_RecupParam.Checked then
    Dm_Main.cds_Proc.FieldByName('FicCsv').AsString := sfic
  else
    Dm_Main.cds_Proc.FieldByName('FicCsv').AsString := sfic;

  if Chk_GrantGinkoia.Checked then
    Dm_Main.cds_Proc.FieldByName('OkGrantGinkoia').AsInteger := 1
  else
    Dm_Main.cds_Proc.FieldByName('OkGrantGinkoia').AsInteger := 0;

  if Chk_GrantRepl.Checked then
    Dm_Main.cds_Proc.FieldByName('OkGrantRepl').AsInteger := 1
  else
    Dm_Main.cds_Proc.FieldByName('OkGrantRepl').AsInteger := 0;

  if Chk_OkDrop.Checked then
    Dm_Main.cds_Proc.FieldByName('OkDropAfterExport').AsInteger := 1
  else
    Dm_Main.cds_Proc.FieldByName('OkDropAfterExport').AsInteger := 0;
  Dm_Main.cds_Proc.FieldByName('Actif').AsBoolean := Chk_Actif.Checked;
  Dm_Main.cds_Proc.Post;

  ModalResult := mrOk;
end;

end.
