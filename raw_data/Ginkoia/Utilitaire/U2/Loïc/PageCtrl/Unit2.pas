unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxCntner, dxTL, dxDBCtrl, dxDBGrid, dxDBGridHP, AdvOfficePager,
  RzTabs, ExtCtrls, RzPanel, AdvOfficePagerStylers, StdCtrls, RzLabel, GinPanel,
  AdvEdit, DBAdvEd, LMDPNGImage, Mask, RzEdit, RzDBEdit, RzDBBnEd,
  RzDBButtonEditRv, AdvGlowButton;

type
  TForm2 = class(TForm)
    Pan_Fond: TGinPanel;
    Shape1: TShape;
    Lab_ToWeb: TRzLabel;
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzLabel4: TRzLabel;
    RzLabel5: TRzLabel;
    RzLabel6: TRzLabel;
    Shape2: TShape;
    Lab_nomTOcentrale: TRzLabel;
    Lab_NomToWeb: TRzLabel;
    Pan_Btn: TRzPanel;
    Nbt_Cancel: TRzLabel;
    Lab_OuAnnuler: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Chp_Chrono: TDBAdvEdit;
    Chp_CLT: TRzDBButtonEditRv;
    Chp_NOM: TDBAdvEdit;
    Chp_TCT: TRzDBButtonEditRv;
    Chp_ToWeb: TRzDBButtonEditRv;
    Chp_TVA: TRzDBButtonEditRv;
    procedure GinPanel1BtnCloseOnClick(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

uses Main_Frm;

{$R *.dfm}

procedure TForm2.GinPanel1BtnCloseOnClick(Sender: TObject);
begin
  Form2.Close;
end;

procedure TForm2.Nbt_CancelClick(Sender: TObject);
begin
 Close;
end;

end.
