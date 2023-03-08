unit form_aguarde;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  RxLookup, Gauges, ExtCtrls;

type
  TfrmAguarde = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    lblMensagem: TLabel;
    Gauge: TGauge;
    lblProcesso: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    OK: Boolean;
    { Public declarations }
  end;

var
  frmAguarde: TfrmAguarde;

implementation


{$R *.dfm}

procedure TfrmAguarde.FormShow(Sender: TObject);
begin
  TOP := 175;
  LEFT := 185;
end;

end.
