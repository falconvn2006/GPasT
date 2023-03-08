unit ProgressBar_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  // Début Uses Perso
  uNetwork,
  Caisse_Frm,
  CaisseSecours_Frm,
  Server_Frm,
  // Fin Uses Perso
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFrm_ProgressBar = class(TForm)
    Pb_Network: TProgressBar;
    Lbl_Network: TLabel;
    Btn_Ok: TButton;
    Btn_Cancel: TButton;
    timerStart: TTimer;
    procedure Btn_OkClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure timerStartTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure AutoOk(Sender: TObject);
  end;

var
  Frm_ProgressBar: TFrm_ProgressBar;

implementation

{$R *.dfm}

procedure TFrm_ProgressBar.AutoOk(Sender: TObject);
begin
  // Auto Ok
  Btn_OkClick(Sender);
end;

procedure TFrm_ProgressBar.Btn_CancelClick(Sender: TObject);
begin
  modalResult := mrCancel;
end;

procedure TFrm_ProgressBar.Btn_OkClick(Sender: TObject);
begin
  Btn_Ok.Visible := False;
  Btn_Cancel.Visible := False;

  if Assigned(Frm_Caisse) then
  begin
    EnumNetwork(Frm_Caisse.EnumNetworkProc, Pb_Network, RESOURCE_GLOBALNET, RESOURCETYPE_ANY);
    Pb_Network.Position := 0;
    ShowMessage('Recherche sur le réseau terminée');
    modalResult := mrOk;
    Self.FreeOnRelease;
    Self.Close;
    // Exit;
  end;

  if Assigned(Frm_CaisseSecours) then
  begin
    EnumNetwork(Frm_CaisseSecours.EnumNetworkProc, Pb_Network, RESOURCE_GLOBALNET, RESOURCETYPE_ANY);
    Pb_Network.Position := 0;
    ShowMessage('Recherche sur le réseau terminée');
    modalResult := mrOk;
    Self.FreeOnRelease;
    Self.Close;
    // Exit;
  end;

  if Assigned(Frm_Serveur) then
  begin
    EnumNetwork(Frm_Serveur.EnumNetworkProc, Pb_Network, RESOURCE_GLOBALNET, RESOURCETYPE_ANY);
    Pb_Network.Position := 0;
    ShowMessage('Recherche sur le réseau terminée');
    modalResult := mrOk;
    Self.FreeOnRelease;
    Self.Close;
    // Exit;
  end;

end;

procedure TFrm_ProgressBar.FormShow(Sender: TObject);
begin
  //Btn_OkClick(Sender);
end;

procedure TFrm_ProgressBar.timerStartTimer(Sender: TObject);
begin
  timerStart.Enabled := False;
  // lancement avec timer car sinon la form n'est pas visible
  Btn_OkClick(Sender);
end;

end.
