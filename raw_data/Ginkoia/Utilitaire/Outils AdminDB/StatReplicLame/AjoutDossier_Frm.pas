unit AjoutDossier_Frm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  // Uses perso
  MonitorStat_Dm,
  // Fin uses P
  Dialogs,
  DB,
  StdCtrls,
  Mask,
  RzEdit,
  RzBtnEdt,
  RzDBEdit,
  RzDBBnEd,
  RzDBButtonEditRv,
  DBCtrls, RzShellDialogs;

type
  TFrm_AjoutDossier = class(TForm)
    Lab_NomDossier: TLabel;
    Lab_CheminMonitor: TLabel;
    Lab_CheminGinkoia: TLabel;
    Edit_NomDossier: TEdit;
    RzButtonEdit_CheminMonitor: TRzButtonEdit;
    RzButtonEdit_CheminGinkoia: TRzButtonEdit;
    Ds_ListeClients: TDataSource;
    Btn_Ok: TButton;
    Btn_Cancel: TButton;
    RzOD_RechercheBase: TRzOpenDialog;
    procedure FormShow(Sender: TObject);
    procedure Btn_OkClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure RzButtonEdit_CheminMonitorButtonClick(Sender: TObject);
    procedure RzButtonEdit_CheminGinkoiaButtonClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_AjoutDossier: TFrm_AjoutDossier;

function ExecuteFormModif(var ANom: string; var ACheminMonitor: string; var ACheminGinkoia: string): boolean;

implementation

{$R *.dfm}

function ExecuteFormModif(var ANom: string; var ACheminMonitor: string; var ACheminGinkoia: string): boolean;
begin
  Result := False;
  Frm_AjoutDossier := TFrm_AjoutDossier.Create(Nil);

  if ANom <> '' then
  begin
    Frm_AjoutDossier.Caption := 'Modification d''un dossier client';
    Frm_AjoutDossier.Btn_Ok.Caption := 'Modification';

  end else
  begin
    Frm_AjoutDossier.Caption := 'Ajout d''un client';
    Frm_AjoutDossier.Btn_Ok.Caption := 'Ajout';
  end;

  try
    Frm_AjoutDossier.Edit_NomDossier.Text := ANom;
    Frm_AjoutDossier.RzButtonEdit_CheminMonitor.Text := ACheminMonitor;
    Frm_AjoutDossier.RzButtonEdit_CheminGinkoia.Text := ACheminGinkoia;

    if Frm_AjoutDossier.ShowModal = mrOK THEN
    begin
      Result := True;

      ANom := Frm_AjoutDossier.Edit_NomDossier.Text;
      ACheminMonitor := Frm_AjoutDossier.RzButtonEdit_CheminMonitor.Text;
      ACheminGinkoia := Frm_AjoutDossier.RzButtonEdit_CheminGinkoia.Text;
    end
    else begin
      Result := False;
    end;

    //    Result := (Frm_AjoutDossier.ShowModal = mrOK);
  finally
    freeandnil(Frm_AjoutDossier);
  end;

end;

procedure TFrm_AjoutDossier.Btn_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_AjoutDossier.Btn_OkClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFrm_AjoutDossier.FormShow(Sender: TObject);
begin
  Edit_NomDossier.SetFocus;
end;


procedure TFrm_AjoutDossier.RzButtonEdit_CheminGinkoiaButtonClick(Sender: TObject);
begin
    Frm_AjoutDossier.RzOD_RechercheBase.Filter := '*.IB|*.ib';
    Frm_AjoutDossier.RzOD_RechercheBase.InitialDir := 'c:\';
    if RzOD_RechercheBase.Execute then
      RzButtonEdit_CheminGinkoia.Text := RzOD_RechercheBase.FileName;
end;

procedure TFrm_AjoutDossier.RzButtonEdit_CheminMonitorButtonClick(Sender: TObject);
begin
    Frm_AjoutDossier.RzOD_RechercheBase.Filter := '*.IB|*.ib';
    Frm_AjoutDossier.RzOD_RechercheBase.InitialDir := 'c:\';
    if RzOD_RechercheBase.Execute then
      RzButtonEdit_CheminMonitor.Text := RzOD_RechercheBase.FileName;
end;

end.

