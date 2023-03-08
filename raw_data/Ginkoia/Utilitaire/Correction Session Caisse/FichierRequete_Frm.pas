unit FichierRequete_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TFrm_FichierRequete = class(TForm)
    Memo1: TMemo;
    Pan_Bas: TPanel;
    Nbt_Quit: TBitBtn;
    btnEnregistrer: TBitBtn;
    btnCreer: TBitBtn;
    procedure btnCreerClick(Sender: TObject);
    procedure btnEnregistrerClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private
    { Déclarations privées }
    FFileName : string;
  public
    { Déclarations publiques }
    procedure InitEcr(AFicReq: string);
  end;

implementation

uses
  Main_Dm;

{$R *.dfm}

procedure TFrm_FichierRequete.btnCreerClick(Sender: TObject);
begin
  Memo1.Lines.SaveToFile(ReperBase + FFileName);
  btnEnregistrer.Enabled := False;
  btnCreer.Enabled := False;
end;

procedure TFrm_FichierRequete.btnEnregistrerClick(Sender: TObject);
begin
  Memo1.Lines.SaveToFile(ReperBase + FFileName);
  btnEnregistrer.Enabled := False;
  btnCreer.Enabled := False;
end;

procedure TFrm_FichierRequete.InitEcr(AFicReq: string);
begin
  FFileName := AFicReq;

  Memo1.Clear;
  if FileExists(ReperBase + AFicReq) then
    Memo1.Lines.LoadFromFile(ReperBase + FFileName)
  else
    btnCreer.Enabled := True;
  btnEnregistrer.Enabled := False;
end;

procedure TFrm_FichierRequete.Memo1Change(Sender: TObject);
begin
  btnEnregistrer.Enabled := True;
end;

end.
