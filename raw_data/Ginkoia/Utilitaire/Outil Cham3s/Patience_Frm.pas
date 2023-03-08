unit Patience_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, ExtCtrls, RzPanel;

type
  TFrm_Patience = class(TForm)
    Pan_fenetre: TRzPanel;
    Pan_titre: TRzPanel;
    Lab_patience: TRzLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    class procedure executeFRM_Patience;
    class procedure closeFRM_Patience;
  end;

var
  Frm_Patience: TFrm_Patience;

implementation

Uses
  Main_Frm;

{$R *.dfm}

{ TFrm_Patience }

class procedure TFrm_Patience.closeFRM_Patience;
begin
  //evenement qui ferme la fenetre
  Frm_Patience.FreeOnRelease;
end;

class procedure TFrm_Patience.executeFRM_Patience;
Var
  Frm_PatienceForm : TForm;
begin
  //procedure d'execution de la fenetre
  Application.CreateForm(TFrm_Patience, Frm_PatienceForm);
  Frm_PatienceForm.Show;
end;

procedure TFrm_Patience.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //fermeture de la fenetre liberation de l memoire
  Frm_Patience.Release;
end;

procedure TFrm_Patience.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Self.Release;
end;

procedure TFrm_Patience.FormShow(Sender: TObject);
begin
  //lors de l'affichage de la fenetre
//  Frm_Patience.Top := (Frm_Main.Top - Height) div 2;
//  Frm_Patience.Left:= (Frm_Main.Left - Width) div 2;
end;

end.
