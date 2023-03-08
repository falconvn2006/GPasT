unit Controle.Operacoes.ConferenciaAssinatura;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Operacoes, Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniBitBtn, uniSpeedButton, uniLabel, uniButton, uniPanel,
  uniImage;

type
  TControleOperacoesConferenciaAssinatura = class(TControleOperacoes)
    UniPanel5: TUniPanel;
    UniPanel6: TUniPanel;
    UniPanel7: TUniPanel;
    UniPanel8: TUniPanel;
    UniLabel1: TUniLabel;
    ImgFotoCliente: TUniImage;
    UniPanel9: TUniPanel;
    UniPanel10: TUniPanel;
    UniPanel11: TUniPanel;
    ImgAssinaturaCadastro: TUniImage;
    UniPanel12: TUniPanel;
    UniLabel2: TUniLabel;
    UniPanel13: TUniPanel;
    ImgAssinaturaTitulo: TUniImage;
    UniPanel14: TUniPanel;
    UniLabel3: TUniLabel;
    CdsCadastroFOTO_CAMINHO: TWideStringField;
    CdsCadastroASSINATURA_CADASTRO: TWideStringField;
    CdsCadastroASSINATURA_TITULO: TWideStringField;
  private

    { Private declarations }
  public
    { Public declarations }
    function abrir(IdDoCliente : integer):boolean;
  end;

function ControleOperacoesConferenciaAssinatura: TControleOperacoesConferenciaAssinatura;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleOperacoesConferenciaAssinatura: TControleOperacoesConferenciaAssinatura;
begin
  Result := TControleOperacoesConferenciaAssinatura(ControleMainModule.GetFormInstance(TControleOperacoesConferenciaAssinatura));
end;

function TControleOperacoesConferenciaAssinatura.abrir(IdDoCliente : integer):boolean;
var
  TrocaExtensao : string;
begin
  Result:= False;

  CdsCadastro.Close;
  QryCadastro.Parameters.ParamByName('IdCliente').Value := IdDoCliente;
  CdsCadastro.Open;

  if CdsCadastroFOTO_CAMINHO.AsString <>'' then
  begin
    if FileExists(CdsCadastroFOTO_CAMINHO.AsString) then
    begin
      ImgFotoCliente.Url := '';
      ImgFotoCliente.Picture.LoadFromFile(CdsCadastroFOTO_CAMINHO.AsString);
    end;
  end;

  if CdsCadastroASSINATURA_CADASTRO.AsString <>'' then
  begin
    if FileExists(CdsCadastroASSINATURA_CADASTRO.AsString) then
    begin
      ImgAssinaturaCadastro.Url := '';
      ImgAssinaturaCadastro.Picture.LoadFromFile(CdsCadastroASSINATURA_CADASTRO.AsString);
      Result:= True;
    end;
  end;

  if Result = True then
  begin
    if CdsCadastroASSINATURA_TITULO.AsString <>'' then
    begin
      TrocaExtensao := ChangeFileExt(CdsCadastroASSINATURA_TITULO.AsString,'.jpg');

      if FileExists(TrocaExtensao) then
      begin
        ImgAssinaturaTitulo.Url := '';
        ImgAssinaturaTitulo.Picture.LoadFromFile(TrocaExtensao);
      end
      else
        Result:= False;
    end;
  end;
end;

end.
