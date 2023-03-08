unit ModifCodeAdh_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, AdvGlowButton, ExtCtrls, RzPanel, DB, IBODataset, StdCtrls,
  Mask, RzEdit, RzDBEdit;

type
  TFrm_ModifCodeAdh = class(TForm)
    Pan_Bottom: TRzPanel;
    btn_Quitter: TAdvGlowButton;
    btn_Modif: TAdvGlowButton;
    btn_Valid: TAdvGlowButton;
    btn_Annul: TAdvGlowButton;
    Ds_CodeMag: TDataSource;
    btn_Prior: TAdvGlowButton;
    btn_Next: TAdvGlowButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RzDBEdit1: TRzDBEdit;
    EDB_Nom: TRzDBEdit;
    EDB_Enseigne: TRzDBEdit;
    EDB_CodeAdh: TRzDBEdit;

    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btn_PriorClick(Sender: TObject);
    procedure btn_NextClick(Sender: TObject);
    procedure btn_ModifClick(Sender: TObject);
    procedure btn_ValidClick(Sender: TObject);
    procedure btn_AnnulClick(Sender: TObject);
    procedure btn_QuitterClick(Sender: TObject);
    procedure Ds_CodeMagDataChange(Sender: TObject; Field: TField);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure EDB_NomDblClick(Sender: TObject);
    procedure EDB_EnseigneDblClick(Sender: TObject);
    procedure EDB_CodeAdhDblClick(Sender: TObject);

  private
    bBaseOrigine: boolean;
    FInEdit: boolean;

    procedure CMDialogKey(var M: TCMDialogKey);   message CM_DIALOGKEY;
    procedure SetInEdit(const Value: boolean);
    procedure SetNavigBtn;
    procedure SetEnabledBtn;
    property InEdit: boolean read FInEdit write SetInEdit;

  public
    procedure SetModif(ABaseOrigine: boolean);
    procedure AutoEdit;
  end;

var
  Frm_ModifCodeAdh: TFrm_ModifCodeAdh;

implementation

uses
  GinkoiaStyle_Dm, Main_Dm;

{$R *.dfm}

{ TFrm_ModifCodeAdh }

procedure TFrm_ModifCodeAdh.SetNavigBtn;
begin
  btn_Prior.Enabled := not(InEdit) and (Ds_CodeMag.DataSet.Active) and not(Ds_CodeMag.DataSet.Bof);
  btn_Next.Enabled := not(InEdit) and (Ds_CodeMag.DataSet.Active)  and not(Ds_CodeMag.DataSet.Eof);
end;

procedure TFrm_ModifCodeAdh.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not(InEdit) or not(Ds_CodeMag.DataSet.Active);
end;

procedure TFrm_ModifCodeAdh.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_PRIOR: btn_Prior.Click;
    VK_NEXT: btn_Next.Click;
    VK_F2: btn_Modif.Click;
    VK_F9: btn_Valid.Click;
  end;
end;

procedure TFrm_ModifCodeAdh.FormShow(Sender: TObject);
begin
  btn_Modif.Visible := False;
  AutoEdit;
end;

procedure TFrm_ModifCodeAdh.SetEnabledBtn;
begin
  btn_Modif.Enabled := not(InEdit) and (Ds_CodeMag.DataSet.Active);
  btn_Valid.Enabled := (InEdit) and (Ds_CodeMag.DataSet.Active);
  btn_Annul.Enabled := (InEdit) and (Ds_CodeMag.DataSet.Active);
  btn_Quitter.Enabled := not(InEdit) and (Ds_CodeMag.DataSet.Active);
  SetNavigBtn;
end;

procedure TFrm_ModifCodeAdh.AutoEdit;
begin
  //Auto Edition
  Ds_CodeMag.DataSet.Edit;
  EDB_CodeAdh.SetFocus;
  EDB_CodeAdh.SelectAll;
end;

procedure TFrm_ModifCodeAdh.btn_AnnulClick(Sender: TObject);
begin
  Ds_CodeMag.DataSet.Cancel;
  Close;
end;

procedure TFrm_ModifCodeAdh.btn_ModifClick(Sender: TObject);
begin
//  Ds_CodeMag.DataSet.Edit;
//  EDB_CodeAdh.SetFocus;
//  EDB_CodeAdh.SelectAll;
end;

procedure TFrm_ModifCodeAdh.btn_NextClick(Sender: TObject);
begin
  Ds_CodeMag.DataSet.Next;
  EDB_CodeAdh.SetFocus;
  EDB_CodeAdh.SelectAll;

  //repasse on mode Edit
  AutoEdit;
end;

procedure TFrm_ModifCodeAdh.btn_PriorClick(Sender: TObject);
begin
  Ds_CodeMag.DataSet.Prior;
  EDB_CodeAdh.SetFocus;
  EDB_CodeAdh.SelectAll;

  //repasse on mode Edit
  AutoEdit;
end;

procedure TFrm_ModifCodeAdh.btn_QuitterClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_ModifCodeAdh.btn_ValidClick(Sender: TObject);
begin
  Ds_CodeMag.DataSet.Post;
end;

procedure TFrm_ModifCodeAdh.CMDialogKey(var M: TCMDialogKey);
begin
  if (m.CharCode=VK_ESCAPE) and InEdit then
  begin
    m.Result := 1;
    Ds_CodeMag.DataSet.Cancel;
    exit;
  end;
  inherited;
end;

procedure TFrm_ModifCodeAdh.Ds_CodeMagDataChange(Sender: TObject;
  Field: TField);
begin
  SetNavigBtn;
  InEdit := (Ds_CodeMag.DataSet.State = dsEdit);
end;

procedure TFrm_ModifCodeAdh.EDB_CodeAdhDblClick(Sender: TObject);
begin
  //repasse on mode Edit
  AutoEdit;
end;

procedure TFrm_ModifCodeAdh.EDB_EnseigneDblClick(Sender: TObject);
begin
  //repasse on mode Edit
  AutoEdit;
end;

procedure TFrm_ModifCodeAdh.EDB_NomDblClick(Sender: TObject);
begin
  //repasse on mode Edit
  AutoEdit;
end;

procedure TFrm_ModifCodeAdh.SetInEdit(const Value: boolean);
begin
  if FInEdit<>Value then
  begin
    FInEdit := Value;
    SetEnabledBtn;
  end;
end;

procedure TFrm_ModifCodeAdh.SetModif(ABaseOrigine: boolean);
begin
  bBaseOrigine := ABaseOrigine;
  if bBaseOrigine then
  begin
    Caption := 'Base ORIGINE - Modifier le code adhérent';
    Ds_CodeMag.DataSet := Dm_Main.Que_OriMag;
    EDB_Nom.ReadOnly := true;
    EDB_Enseigne.ReadOnly := true;
  end
  else
  begin
    Caption := 'Base DESTINATION - Modifier le code adhérent';
    Ds_CodeMag.DataSet := Dm_Main.Que_DstMag;
    EDB_Nom.ReadOnly := false;
    EDB_Enseigne.ReadOnly := false;
    EDB_Nom.TabStop := true;
    EDB_Enseigne.TabStop := true;
    EDB_Nom.Color := clWindow;
    EDB_Enseigne.Color := clWindow;
  end;
  InEdit := false;
  SetEnabledBtn;
end;

end.

