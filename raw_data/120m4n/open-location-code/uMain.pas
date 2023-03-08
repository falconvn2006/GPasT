unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfMain = class(TForm)
    btnCalculate: TButton;
    lblLat: TLabel;
    lblLon: TLabel;
    edtCodigoPLus: TEdit;
    Label1: TLabel;
    edtLatitude: TEdit;
    edtLongitude: TEdit;
    Label2: TLabel;
    edtLen: TEdit;
    btnDecode: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Label3: TLabel;
    Edit1: TEdit;
    edtOutLatitude: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtOutLongitude: TEdit;
    edtInCodePlus: TEdit;
    Label6: TLabel;
    procedure btnCalculateClick(Sender: TObject);
    procedure btnDecodeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}

uses OpenLocationCode, CodeArea;

procedure TfMain.btnCalculateClick(Sender: TObject);
var
  olc : TOpenLocationCode;
  code : string;
begin

  try
    olc := TOpenLocationCode.Create();
    edtCodigoPLus.Text := olc.encode(StrToFloatDef(edtLatitude.Text,0),
                              StrToFloatDef(edtLongitude.Text,0), StrToIntDef(edtLen.Text, 10));
  finally
    olc.Free;
  end;
end;

procedure TfMain.btnDecodeClick(Sender: TObject);
var
  olc : TOpenLocationCode;
  _tmp : TCodeArea;
  _stemp : string;
begin
  _stemp := 'codeLength: %2.0f'+ #13#10 +
'latitudeCenter: %3.6f '+ #13#10 +
'longitudeCenter: %3.6f '+ #13#10 +
'latitudeHi: %3.6f '+ #13#10 +
'longitudeHi: %3.6f '+ #13#10 +
'latitudeLo: %3.6f '+ #13#10 +
'longitudeLo: %3.6f ';
  try
    olc := TOpenLocationCode.Create();
    _tmp := olc.decode(edtInCodePlus.Text);
//    ShowMessage(Format(_stemp,
//    [_tmp.codeLength,
//    _tmp.latitudeCenter,
//    _tmp.longitudeCenter,
//    _tmp.latitudeHi,
//    _tmp.longitudeHi,
//    _tmp.latitudeLo,
//    _tmp.longitudeLo]));

    edtOutLatitude.Text := FloatToStr(_tmp.latitudeCenter) ;

    edtOutLongitude.Text := FloatToStr(_tmp.longitudeCenter)
  finally
    olc.Free;
  end;
end;

end.
