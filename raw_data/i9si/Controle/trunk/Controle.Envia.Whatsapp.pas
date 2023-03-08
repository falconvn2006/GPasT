unit Controle.Envia.Whatsapp;

interface

uses
  Funcoes.client;


type
  TrecebeRetorno = class
  private
    FnRetorno: TRetornos;
    procedure SetnRetorno(const Value: TRetornos);
  published
    property nRetorno : TRetornos read FnRetorno write SetnRetorno;
  end;

type
  TBase64 = class
  private
    FArquivoBase64: string;
  published
    property ArquivoBase64: string read FArquivoBase64 write FArquivoBase64;
  end;

var
  ControleEnviaWhatsapp : Controle.Envia.Whatsapp;

implementation

uses
  Datasnap.DBClient;

{ TrecebeRetorno }
procedure TrecebeRetorno.SetnRetorno(const Value: TRetornos);
var
  CDSCloneTotais, CDSCloneItens : TClientDataSet;

begin
  CDSCloneTotais := TClientDataSet.create(nil);

  Try
    // FnRetorno := Value;
    // Alimentando os componentes visuais
    With ControleEnviaWhatsapp do
    begin
      if Value.rClientDataSetCabecalho <> nil then
      begin
        CDSCloneTotais.CloneCursor(Value.rClientDataSetCabecalho, false, false);
        CDSCloneTotais.Open;

        if Value.rClientDataSetItens <> nil then
        begin
          CDSCloneItens.CloneCursor(Value.rClientDataSetItens, false, false);
          CDSCloneItens.Open;

          DBGridDadosItens.DataSource    := DscCloneItens;
        end;
      end
      else
      begin
        DBGridDadosTotais.DataSource    := Value.rDatasource;
        DBGridDadosItens.DataSource     := nil;
        // Clonando o resultado para um clientdataset
        CDSClone.CloneCursor(Value.rClientDataSet, false, false);
        CDSClone.Open;
      end;

      if Value.rClientDataSetItens2 <> nil then
      begin
        CDSCloneItens2.CloneCursor(Value.rClientDataSetItens2, false, false);
        CDSCloneItens2.Open;
      end;

      MemoEnvioUrl.Text      := Value.rUrlEnvio;
      MemoEnvioJson.Text     := Value.rJsonEnvio;
      MemoRetorno.Text       := Value.rJsonRetorno;
    end;
  Finally
    // metodos para deixar free aqui
  End;
end;

end.
