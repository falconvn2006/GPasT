unit Parametre_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, LMDCustomButton, LMDButton, ExtCtrls;

type
  TFrm_Parametre = class(TForm)
    RzLabel1: TRzLabel;
    EJour: TEdit;
    RzLabel2: TRzLabel;
    Bevel1: TBevel;
    Nbt_Ok: TLMDButton;
    Nbt_Cancel: TLMDButton;
    procedure FormCreate(Sender: TObject);
    procedure EJourKeyPress(Sender: TObject; var Key: Char);
    procedure Nbt_OkClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Parametre: TFrm_Parametre;

implementation

uses
  Main_Dm;

{$R *.dfm}

procedure TFrm_Parametre.EJourKeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(Key)>=32) and (Pos(Key,'0123456789')=0) then
    Key:=#7;
end;

procedure TFrm_Parametre.FormCreate(Sender: TObject);
begin
  EJour.Text:=inttostr(Dm_Main.NbJourGardeRapport);
end;

procedure TFrm_Parametre.Nbt_OkClick(Sender: TObject);
var
  v: integer;
begin
  v:=StrToIntDef(EJour.Text,0);
  if (v<=0) then
  begin
    MessageDlg('Nombre de jour invalide !',mterror,[mbok],0);
    ModalResult := mrnone;
    EJour.SetFocus;
    EJour.SelectAll;
    exit;
  end;
  Dm_Main.NbJourGardeRapport := v;
end;

end.
