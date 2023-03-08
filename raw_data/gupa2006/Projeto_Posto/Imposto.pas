unit Imposto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, JvExMask,
  JvToolEdit, JvBaseEdits, Conexao, Data.DB, Data.Win.ADODB;

type
  TfrmImposto = class(TForm)
    btSalvar: TButton;
    btSair: TButton;
    edtImposto: TJvCalcEdit;
    Label2: TLabel;
    qryImposto: TADOQuery;
    qrySalvar: TADOQuery;
    procedure btSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmImposto: TfrmImposto;

implementation

{$R *.dfm}

procedure TfrmImposto.btSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImposto.btSalvarClick(Sender: TObject);
var
  Imposto : String;
begin
  Imposto := StringReplace(StringReplace(edtImposto.Text, '.', '', [rfReplaceAll]),',','.',[rfReplaceAll]);
  qrySalvar.Close;
  qrySalvar.SQL.Text := '';
  qrySalvar.SQL.Text := 'Update Imposto Set Percentual = ' + Imposto;
  qrySalvar.ExecSQL;
  MessageDlg('Imposto atualizado!', mtInformation,[mbOk], 0, mbOk);
  close;
end;

procedure TfrmImposto.FormShow(Sender: TObject);
begin
  qryImposto.Close;
  qryImposto.Open;
  edtImposto.Text := qryImposto.FieldByName('Percentual').AsString;
end;

end.
