unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Mask, Grids, DBGrids, DB, ADODB;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    eNis: TMaskEdit;
    StaticText2: TStaticText;
    eNamaSiswa: TMaskEdit;
    StaticText3: TStaticText;
    eTempatLahir: TMaskEdit;
    StaticText4: TStaticText;
    dateLahir: TDateTimePicker;
    StaticText5: TStaticText;
    eAlamat: TMaskEdit;
    RadioButton1: TRadioButton;
    StaticText6: TStaticText;
    RadioButton2: TRadioButton;
    DBGrid1: TDBGrid;
    btnTambah: TButton;
    btnSimpan: TButton;
    btnUbah: TButton;
    btnKeluar: TButton;
    ADOConnection1: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
