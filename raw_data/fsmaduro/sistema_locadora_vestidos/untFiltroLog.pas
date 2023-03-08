unit untFiltroLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Mask, RxLookup, DB, IBCustomDataSet,
  IBQuery, ExtCtrls,  rxToolEdit;

type
  TfrmFiltroLog = class(TForm)
    Panel1: TPanel;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbUsuario: TRxDBLookupCombo;
    edtDtInicial: TDateEdit;
    edtDtFinal: TDateEdit;
    qryUSUARIO: TIBQuery;
    dtsUSUARIO: TDataSource;
    btn_ok: TSpeedButton;
    qryUSUARIOCODIGO: TIntegerField;
    qryUSUARIOUSERNAME: TIBStringField;
    btn_sair: TSpeedButton;
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_sairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFiltroLog: TfrmFiltroLog;

implementation

uses untRelLog, untDados;

{$R *.dfm}

procedure TfrmFiltroLog.btn_okClick(Sender: TObject);
var
  Filtro: string;
begin

  if cbUsuario.KeyValue > 0 then
    filtro := Filtro + ' and L.CODIGOUSUARIO = ' + qryUSUARIOCODIGO.Text;

  if edtDtInicial.Text <> '  /  /    ' then
  begin
    if edtDtFinal.Text <> '  /  /    ' then
      filtro := Filtro + ' and l.data between ' +#39+FormatDateTime('mm/dd/yyyy',edtDtInicial.Date)+#39+
                         ' and ' +#39+FormatDateTime('mm/dd/yyyy',edtDtFinal.Date)+#39
    else
      Filtro := Filtro + ' and l.data >= '+#39+FormatDateTime('mm/dd/yyyy',edtDtInicial.Date)+#39;
  end
  else if edtDtFinal.Text <> '  /  /    ' then
    Filtro := Filtro + ' and l.data <= '+#39+FormatDateTime('mm/dd/yyyy',edtDtFinal.Date)+#39;

  DADOS.qryRelLog.Close;
  DADOS.qryRelLog.SQL.Strings[DADOS.qryRelLog.SQL.Indexof('where 1=1')+1] := Filtro;
  DADOS.qryRelLog.Open;

  DADOS.rbiLog.Print;

end;

procedure TfrmFiltroLog.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFiltroLog.FormShow(Sender: TObject);
begin
  try
    qryUSUARIO.Close;
    qryUSUARIO.Open;
  except
    application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
  end;
end;

end.
