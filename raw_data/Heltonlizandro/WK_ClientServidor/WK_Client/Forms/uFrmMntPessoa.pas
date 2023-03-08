unit uFrmMntPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmMntPadrao, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons,
  Vcl.Imaging.jpeg, Vcl.Mask, RxToolEdit, uTPessoa, uFrmPadrao,
  Datasnap.DBClient;

type
  TFrmMntPessoa = class(TFrmMntPadrao)
    Label1: TLabel;
    EdtCodigo: TEdit;
    Label5: TLabel;
    EdtNome: TEdit;
    Label2: TLabel;
    EdtSobrenome: TEdit;
    EdtCep: TMaskEdit;
    lbRgIe: TLabel;
    EdtDocumento: TEdit;
    lbCPF_CNPJ: TLabel;
    Label3: TLabel;
    EdtNatureza: TMaskEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    oPessoa : TPessoa;
    ListaDados : TStrings;

    procedure ChamaManutencao(sDataSet: TDataSet; sBotao : TBotao; ListaDadosFilho : TStrings = nil; sPaiMae : String = '');
    procedure PreencheDados; Override;
  protected
    function  ValidaCadastro: Boolean; Override;
    procedure SalvaCadastro; Override;

  end;

var
  FrmMntPessoa: TFrmMntPessoa;

implementation

uses uFrmPrincipal, F_Funcao;

{$R *.dfm}

{ TFrmMnTPessoa }

procedure TFrmMntPessoa.ChamaManutencao(sDataSet: TDataSet; sBotao: TBotao;
  ListaDadosFilho: TStrings; sPaiMae: String);
var
  FrmMnTPessoa : TFrmMnTPessoa;
begin
  try
    FrmMnTPessoa := TFrmMnTPessoa.Create(nil);
    with FrmMnTPessoa do
    begin
      dsDados.DataSet := sDataSet;
      Botao := sBotao;

      if ListaDadosFilho <> nil then
        ListaDados := ListaDadosFilho;

      PreencheDados;
      ShowModal;
    end;
  finally
    FreeAndNil(FrmMnTPessoa);
  end;
end;

procedure TFrmMntPessoa.FormCreate(Sender: TObject);
begin
  inherited;
  oPessoa := TPessoa.Create;
end;

procedure TFrmMntPessoa.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(oPessoa);
end;

procedure TFrmMntPessoa.PreencheDados;
begin
  if Botao = btAlterar then
  begin
    oPessoa.idpessoa := dsDados.DataSet.FieldByName('idpessoa').AsInteger;

    EdtCodigo   .Text := dsDados.DataSet.FieldByName('idpessoa').AsString;
    EdtNome     .Text := dsDados.DataSet.FieldByName('NMPRIMEIRO').AsString;
    EdtSobrenome.Text := dsDados.DataSet.FieldByName('NMSEGUNDO').AsString;
    EdtDocumento.Text := dsDados.DataSet.FieldByName('DSDOCUMENTO').AsString;
    EdtCep      .Text := dsDados.DataSet.FieldByName('DSCEP').AsString;
    EdtNatureza .Text := dsDados.DataSet.FieldByName('FLNATUREZA').AsString;

    MaxLengthZeroEsquerda(EdtCodigo);
  end
  else
  begin
    EdtCodigo.Text := '';
  end;
end;

procedure TFrmMntPessoa.SalvaCadastro;
var
  sValues, sCampos : String;
begin
  //Executa o padrão
  inherited;

  oPessoa.idpessoa    := StrToIntDef(Trim(EdtCodigo.Text),0);
  oPessoa.flnatureza  := StrToIntDef(Trim(EdtNatureza.Text),0);
  oPessoa.nmprimeiro  := Trim(EdtNome.Text);
  oPessoa.nmsegundo   := Trim(EdtSobrenome.Text);
  oPessoa.dsdocumento := Trim(EdtDocumento.Text);
  oPessoa.dscep       := Trim(EdtCep.Text);
  oPessoa.dtregistro  := now;

  case Botao of
    btInserir: oPessoa.Incluir();
    btAlterar: oPessoa.Alterar();
  end;
end;

function TFrmMntPessoa.ValidaCadastro: Boolean;
begin
  Result := True;

  if Trim(EdtNome.Text) = EmptyStr then
  begin
    TMens.Aviso('Obrigatório o Nome da Pessoa.');
    EdtNome.SetFocus;
    Result := False;
  end;

  if Trim(EdtCEP.Text).Length < 8 then
  begin
    TMens.Aviso('Obrigatório um CEP válido.');
    EdtCep.SetFocus;
    Result := False;
  end;

end;


end.
