unit Test_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, wwdbedit, IBDatabase, DB, dxmdaset, ExtCtrls,
  Progbr3d, IBQuery, IBCustomDataSet, IBTable, IBSQL;

type
  TForm1 = class(TForm)
    Btn_base: TButton;
    Chp_base: TwwDBEdit;
    ODBase: TOpenDialog;
    Ginkoia: TIBDatabase;
    tran: TIBTransaction;
    procedure Btn_baseClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation



{$R *.dfm}

procedure TForm1.Btn_baseClick(Sender: TObject);
begin
 if ODBase.Execute then
    begin
        chp_base.text:=ODbase.files[0];
        ginkoia.close;
        ginkoia.databasename:=ODbase.files[0];
        ginkoia.Open;
    end;

    end;

end.

