unit Controle.Operacoes.Integracao.CalculoJuros;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Operacoes, Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniGUIBaseClasses,
  uniGUIClasses, uniImageList, uniBitBtn, uniSpeedButton, uniLabel, uniButton,
  uniPanel, uniEdit, uniDateTimePicker, uniBasicGrid, uniDBGrid;

type
  TControleOperacoesIntegracaoCalculoJuros = class(TControleOperacoes)
    UniDateTitulo: TUniDateTimePicker;
    UniEdtJurosMes: TUniFormattedNumberEdit;
    UniEdtMultaAtraso: TUniFormattedNumberEdit;
    UniEdtDiasAtraso: TUniFormattedNumberEdit;
    UniEdtValorOriginal: TUniFormattedNumberEdit;
    UniEdtDesconto: TUniFormattedNumberEdit;
    UniEdtValorAtualizado: TUniFormattedNumberEdit;
    UniEdtMultaAtrasoValor: TUniFormattedNumberEdit;
    UniEdtJurosMesValor: TUniFormattedNumberEdit;
    UniDateTituloOriginal: TUniDateTimePicker;
    procedure UniFormShow(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
    procedure UniFormAfterShow(Sender: TObject);
    procedure UniDateTituloChange(Sender: TObject);
    procedure UniEdtDescontoChange(Sender: TObject);
    procedure BotaoDescartarClick(Sender: TObject);
    procedure UniEdtMultaAtrasoChange(Sender: TObject);
    procedure UniEdtJurosMesChange(Sender: TObject);
    procedure UniEdtMultaAtrasoValorChange(Sender: TObject);
    procedure UniEdtJurosMesValorChange(Sender: TObject);
    procedure UniEdtMultaAtrasoValorEnter(Sender: TObject);
    procedure UniEdtJurosMesValorEnter(Sender: TObject);
  private
    procedure ExecutaCalculo;
    { Private declarations }
  public
    { Public declarations }
  end;


function ControleOperacoesIntegracaoCalculoJuros: TControleOperacoesIntegracaoCalculoJuros;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, System.Math;

function ControleOperacoesIntegracaoCalculoJuros: TControleOperacoesIntegracaoCalculoJuros;
begin
  Result := TControleOperacoesIntegracaoCalculoJuros(ControleMainModule.GetFormInstance(TControleOperacoesIntegracaoCalculoJuros));
end;

procedure TControleOperacoesIntegracaoCalculoJuros.BotaoDescartarClick(
  Sender: TObject);
begin
  inherited;
  close;
end;

procedure TControleOperacoesIntegracaoCalculoJuros.BotaoSalvarClick(
  Sender: TObject);
begin
  inherited;
  if UniDateTitulo.DateTime < Date then
  begin
    BotaoSalvar.ModalResult := mrNone;
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'A data não pode ser menor que a data atual');
  end
  else
    BotaoSalvar.ModalResult := mrOk;
end;

procedure TControleOperacoesIntegracaoCalculoJuros.UniDateTituloChange(
  Sender: TObject);
begin
  inherited;
  ExecutaCalculo;
end;

procedure TControleOperacoesIntegracaoCalculoJuros.UniEdtDescontoChange(
  Sender: TObject);
begin
  inherited;
  ExecutaCalculo;
end;

procedure TControleOperacoesIntegracaoCalculoJuros.UniEdtJurosMesChange(
  Sender: TObject);
begin
  inherited;
  ExecutaCalculo;
end;

procedure TControleOperacoesIntegracaoCalculoJuros.UniEdtJurosMesValorChange(
  Sender: TObject);
begin
  inherited;
  UniEdtValorAtualizado.Text := FloatToStr(StrToFloatDef(UniEdtMultaAtrasoValor.Text,0) + StrToFloatDef(UniEdtJurosMesValor.Text,0) + StrToFloatDef(UniEdtValorOriginal.Text,0) )
end;

procedure TControleOperacoesIntegracaoCalculoJuros.UniEdtJurosMesValorEnter(
  Sender: TObject);
begin
  inherited;
  UniEdtJurosMesValor.SelectAll;
end;

procedure TControleOperacoesIntegracaoCalculoJuros.UniEdtMultaAtrasoChange(
  Sender: TObject);
begin
  inherited;
  ExecutaCalculo;
end;

procedure TControleOperacoesIntegracaoCalculoJuros.UniEdtMultaAtrasoValorChange(
  Sender: TObject);
begin
  inherited;
  UniEdtValorAtualizado.Text := FloatToStr(StrToFloatDef(UniEdtMultaAtrasoValor.Text,0) + StrToFloatDef(UniEdtJurosMesValor.Text,0) + StrToFloatDef(UniEdtValorOriginal.Text,0) )
end;

procedure TControleOperacoesIntegracaoCalculoJuros.UniEdtMultaAtrasoValorEnter(
  Sender: TObject);
begin
  inherited;
  UniEdtMultaAtrasoValor.SelectAll;
end;

procedure TControleOperacoesIntegracaoCalculoJuros.UniFormAfterShow(
  Sender: TObject);
begin
  ExecutaCalculo;
end;

procedure TControleOperacoesIntegracaoCalculoJuros.UniFormShow(Sender: TObject);
begin
  inherited;
  UniDateTitulo.DateTime := Date;
end;

procedure TControleOperacoesIntegracaoCalculoJuros.ExecutaCalculo;
var
  Calcula : TCalJurosMulta;
begin
  if True then

  Calcula := ControleMainModule.CalculaJurosMulta(UniDateTitulo.DateTime,
                                                  StrToFloatDef(UniEdtValorOriginal.Text,2),
                                                  StrToFloatDef(UniEdtJurosMes.Text,2),
                                                  StrToFloatDef(UniEdtMultaAtraso.Text,2),
                                                  Round(StrToFloatDef(UniEdtDiasAtraso.Text,0)),
                                                  StrToFloatDef(UniEdtDesconto.Text,2));

  UniEdtMultaAtrasoValor.Value := Calcula.ValorMulta;
  UniEdtJurosMesValor.Value    := Calcula.ValorJuros;
  UniEdtValorAtualizado.Value  := Calcula.ValorAtualizado;
end;


end.
