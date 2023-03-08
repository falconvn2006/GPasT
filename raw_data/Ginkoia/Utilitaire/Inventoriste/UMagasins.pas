unit UMagasins;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  Inventoriste_Frm, Grids, DBGrids, StdCtrls;

type
  TFrmMagasins = class(TForm)
    Btn_OK: TButton;
    Btn_Cancel: TButton;
    DBGrid1: TDBGrid;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FrmMagasins: TFrmMagasins;

implementation

{$R *.dfm}

end.
