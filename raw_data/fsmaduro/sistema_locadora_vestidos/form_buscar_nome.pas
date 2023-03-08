unit form_buscar_nome;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  RxLookup;

type
  Tbuscar_nome = class(TForm)
    btn_ok: TSpeedButton;
    btn_sair: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    edtmatricula: TEdit;
    Label3: TLabel;
    RxDBLookupCombo3: TRxDBLookupCombo;
    dtsAlunos: TDataSource;
    qryAlunos: TIBQuery;
    IBStringField3: TIBStringField;
    qryAlunosREFERENCIA: TIBStringField;
    qryAlunosPORREFERENCIA: TIntegerField;
    procedure btn_sairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtmatriculaChange(Sender: TObject);
    procedure edtmatriculaKeyPress(Sender: TObject; var Key: Char);
    procedure RxDBLookupCombo3KeyPress(Sender: TObject; var Key: Char);
    procedure btn_okClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    ok: Boolean;
    FormChamado : Tform;
    { Public declarations }
  end;

var
  buscar_nome: Tbuscar_nome;

implementation

//uses form_contribuica;


{$R *.dfm}

procedure Tbuscar_nome.btn_sairClick(Sender: TObject);
begin
 // historico.Close;
  ok := False;
  close;
end;

procedure Tbuscar_nome.FormShow(Sender: TObject);
begin
  TOP := 175;
  LEFT := 185;
  try
    edtmatricula.Clear;
    RxDBLookupCombo3.KeyValue := -1;
    qryAlunos.Close;
    qryAlunos.Open;
  except
    application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure Tbuscar_nome.edtmatriculaChange(Sender: TObject);
var
  valor: String;
begin
  if edtmatricula.Text <> '' then
  BEGIN
    valor := IntToStr(StrToInt(edtmatricula.Text));
    //qryAlunos.Locate('CODIGO',STRTOINT(edtmatricula.Text),[]);
    RxDBLookupCombo3.KeyValue := valor;//STRTOINT(edtmatricula.Text);
  END;
end;

procedure Tbuscar_nome.edtmatriculaKeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    btn_ok.Click
  else if key = #27 then
    btn_sair.Click;

  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure Tbuscar_nome.RxDBLookupCombo3KeyPress(Sender: TObject;
  var Key: Char);
begin
  if key = #13 then
    btn_ok.Click
  else if key = #27 then
    btn_sair.Click;
end;

procedure Tbuscar_nome.btn_okClick(Sender: TObject);
begin
  if RxDBLookupCombo3.KeyValue > -1 then
  begin
    ok := True;

//    if FormChamado = contribuicao_dizimo then
//    begin
//      contribuicao_dizimo.Referencia :=  RxDBLookupCombo3.KeyValue;
//      contribuicao_dizimo.PorReferencia :=  qryAlunosPORREFERENCIA.Value = 1;
//    end;
   { historico.CodigoAluno := RxDBLookupCombo3.KeyValue;
    historico.Idioma := ComboBox1.Text;

    try
      historico.qryDadosHistorico.Close;
      historico.qryDadosHistorico.Open;
    except
      application.MessageBox('Erro ao abrir consulta com banco de dados','ERRO',mb_OK+MB_ICONERROR);
    end;}

    close;
  end;
end;

procedure Tbuscar_nome.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qryAlunos.Close;
end;

end.
