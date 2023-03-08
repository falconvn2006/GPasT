unit Test_Frm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
//Uses Perso
  MonitorStat_Dm,
//Fin Uses Perso
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  DB,
  StdCtrls, RzDBButtonEditRv, Mask, RzEdit, RzDBEdit, RzDBBnEd, DBCtrls;

type
  TFrm_Test = class(TForm)
    Lab_Nom: TLabel;
    Lab_CheminMonitor: TLabel;
    Lab_CheminGinkoia: TLabel;
    Ds_RemplirPage: TDataSource;
    Edit_Nom: TEdit;
    RzDBButtonEdit1: TRzDBButtonEdit;
    RzDBButtonEdit2: TRzDBButtonEdit;
    Chp_monitor: TRzDBButtonEditRv;
    Chp_ginkoia: TRzDBButtonEditRv;
    Btn_ajout: TButton;
    Btn_annuler: TButton;
    DBEdit1: TDBEdit;
    procedure Btn_ajoutClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Test: TFrm_Test;


function ExecuteCreation (var Anom :string; var Amonitor: string; var Aginkoia:string) : Boolean;

implementation

{$R *.dfm}

function ExecuteCreation (var Anom :string; var Amonitor: string; var Aginkoia:string) : Boolean;
begin
  Result := False;
  Frm_Test :=  TFrm_Test.Create(nil);

  try
   Frm_Test.Edit_Nom.Text := Anom;
   Frm_Test.RzDBButtonEdit1.Text := Amonitor;
   Frm_Test.RzDBButtonEdit2.Text := Aginkoia;

    if Frm_Test.ShowModal = mrOk then
    begin
      Anom := Frm_Test.Edit_Nom.Text;
      Amonitor := Frm_Test.RzDBButtonEdit1.Text;
      Aginkoia := Frm_Test.RzDBButtonEdit2.Text;

      Result := True;
    end;
  finally
    Frm_Test.Free;
  end;
end;

procedure TFrm_Test.Btn_ajoutClick(Sender: TObject);
begin
    ModalResult := mrOk;
end;

end.

