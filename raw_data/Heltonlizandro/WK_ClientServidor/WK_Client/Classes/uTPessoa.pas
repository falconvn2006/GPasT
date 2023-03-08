unit uTPessoa;

interface

uses
  Windows, Messages, System.SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmCadPadrao, Provider, DBClient, DB, FireDAC.Comp.Client,
  Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, JPEG, RESTRequest4D,
  System.Generics.Collections, System.JSON;

type
  TPessoa = class
  private
    Fnmprimeiro: string;
    Fdtregistro: TDate;
    Fnmsegundo: string;
    Fdscep: string;
    Fdsdocumento: string;
    Fidpessoa: Integer;
    Fflnatureza: Integer;

    procedure Setdscep(const Value: string);
    procedure Setdsdocumento(const Value: string);
    procedure Setdtregistro(const Value: TDate);
    procedure Setflnatureza(const Value: Integer);
    procedure Setidpessoa(const Value: Integer);
    procedure Setnmprimeiro(const Value: string);
    procedure Setnmsegundo(const Value: string);
  public
    property idpessoa   : Integer read Fidpessoa    write Setidpessoa;
    property flnatureza : Integer read Fflnatureza  write Setflnatureza;
    property dsdocumento: string  read Fdsdocumento write Setdsdocumento;
    property nmprimeiro : string  read Fnmprimeiro  write Setnmprimeiro;
    property nmsegundo  : string  read Fnmsegundo   write Setnmsegundo;
    property dtregistro : TDate   read Fdtregistro  write Setdtregistro;
    property dscep      : string  read Fdscep       write Setdscep;

    procedure CarregaDataSet(MemTable: TFDMemTable);
    procedure Incluir();
    procedure Alterar();
    procedure Excluir;

  end;

implementation

uses uFrmPrincipal, F_Funcao;

{ TPessoa }

procedure TPessoa.Alterar();
var
  Resp : IResponse;
  sBody : string;
begin
  sBody := '{' +
           '"idpessoa": '+IntToStr(Fidpessoa)+',' +
           '"flnatureza": '+IntToStr(Fflnatureza)+',' +
           '"dsdocumento": "'+Fdsdocumento+'",' +
           '"nmprimeiro": "'+Fnmprimeiro+'",' +
           '"nmsegundo": "'+Fnmsegundo+'",' +
           '"dtregistro": "'+FormatDateTime('yyyy-mm-dd', dtregistro)+'",' +
           '"dscep": "'+Fdscep+'"' +
           '}';

  try
    Resp := TRequest.New.BaseURL('localhost:9000/pessoa')
            .AddBody(sBody)
            .Accept('application/json')
            .Put;

    if Resp.StatusCode = 200 then
      MessageDlg('Dados Alterados com Sucesso.', mtInformation, [mbOk],0);
  except
    MessageDlg('Erro ao Alterar os Dados'+#13+'Entre em contato com o Administrador do Sistema', mtInformation, [mbOk],0);
  end;
end;

procedure TPessoa.CarregaDataSet(MemTable: TFDMemTable);
var
  Resp : IResponse;
  jsonRaiz : TJSONObject;
  sComplemento : string;
begin
  sComplemento := EmptyStr;

  if nmprimeiro <> EmptyStr then
    sComplemento := '/'+nmprimeiro;

  Resp := TRequest.New.BaseURL('localhost:9000/pessoa/nome')
          .Resource(sComplemento)
          .Accept('application/json')
          .DataSetAdapter(MemTable) //FrmPrincipal.CdsNotas
          .Get;
end;

procedure TPessoa.Excluir;
var
  sair : word;
begin
  try
    sair := MessageDlg('Confirma a Exclusão do Registro Selecionado?', mtConfirmation, mbOKCancel,0);
    if sair = 1 then
    begin
      //Excluindo os telefones do cliente



      MessageDlg('Dados Excluidos com Sucesso.', mtInformation, [mbOk],0);
    end;
  except
    MessageDlg('Não é possível a exclusão dos Dados.'+#13+'Entre em contato com o Administrador do Sistema', mtInformation, [mbOk],0);
  end;
end;

procedure TPessoa.Incluir;
var
  Resp : IResponse;
  sBody : string;
begin
  sBody := '{' +
           '"flnatureza": '+IntToStr(Fflnatureza)+',' +
           '"dsdocumento": "'+Fdsdocumento+'",' +
           '"nmprimeiro": "'+Fnmprimeiro+'",' +
           '"nmsegundo": "'+Fnmsegundo+'",' +
           '"dtregistro": "'+FormatDateTime('yyyy-mm-dd', dtregistro)+'",' +
           '"dscep": "'+Fdscep+'"' +
           '}';

  try
    Resp := TRequest.New.BaseURL('localhost:9000/pessoa')
            .AddBody(sBody)
            .Accept('application/json')
            .Post;

    if Resp.StatusCode = 201 then
      MessageDlg('Dados Inseridos com Sucesso.', mtInformation, [mbOk],0);
  except
    MessageDlg('Erro ao Alterar os Dados'+#13+'Entre em contato com o Administrador do Sistema', mtInformation, [mbOk],0);
  end;
end;

procedure TPessoa.Setdscep(const Value: string);
begin
  Fdscep := Value;
end;

procedure TPessoa.Setdsdocumento(const Value: string);
begin
  Fdsdocumento := Value;
end;

procedure TPessoa.Setdtregistro(const Value: TDate);
begin
  Fdtregistro := Value;
end;

procedure TPessoa.Setflnatureza(const Value: Integer);
begin
  Fflnatureza := Value;
end;

procedure TPessoa.Setidpessoa(const Value: Integer);
begin
  Fidpessoa := Value;
end;

procedure TPessoa.Setnmprimeiro(const Value: string);
begin
  Fnmprimeiro := Value;
end;

procedure TPessoa.Setnmsegundo(const Value: string);
begin
  Fnmsegundo := Value;
end;

end.
