unit uFrmParams;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TFrm_Params = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    teNODE: TEdit;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    DateTimePicker1: TDateTimePicker;
    Label3: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_Params: TFrm_Params;

implementation

{$R *.dfm}

end.
