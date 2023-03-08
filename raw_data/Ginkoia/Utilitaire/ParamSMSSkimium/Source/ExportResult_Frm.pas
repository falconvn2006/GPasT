unit ExportResult_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TFrm_ExportResult = class(TForm)
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Chk_Etat1: TCheckBox;
    Chk_Etat2: TCheckBox;
    Chk_Etat3: TCheckBox;
    Chk_Etat6: TCheckBox;
    Chk_Etat7: TCheckBox;
    Chk_Etat4: TCheckBox;
    Nbt_Ok: TBitBtn;
    Nbt_Cancel: TBitBtn;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_ExportResult: TFrm_ExportResult;

implementation

{$R *.dfm}

end.
