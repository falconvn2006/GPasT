unit uTThreadEndereco;

interface

uses
  System.Classes, Model.Banco, FireDAC.Comp.Client;

type
  TThreadEndereco = class(TThread)
  private

  protected
    dmBanco : TdmBanco;
    procedure Execute; override;
  public
    constructor Create;
    procedure  Sincronizar();
    destructor Destroy; override;
  end;

implementation

{ TThreadEndereco }

uses Model.Pessoa, Modelo.Endereco, Controller.Pessoa;

constructor TThreadEndereco.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;

  dmBanco := TdmBanco.Create(nil);
  dmBanco.Banco.Connected := True;
end;

destructor TThreadEndereco.Destroy;
begin
  dmBanco.Banco.Connected := False;
  inherited;
end;

procedure TThreadEndereco.Execute;
var
  qry : TFDQuery;
begin
  inherited;

  While True do
  begin
    Sleep(5000); //Aguarda Cinco segudos
    Self.Sincronizar();
  end;
end;

procedure TThreadEndereco.Sincronizar();
var
  endereco : TEnderecoIntegracao;
  serro : string;
begin
  try
    endereco := TEnderecoIntegracao.Create;
    endereco.AtualizaEndereco();
  except
    endereco.Free;
  end;
end;

end.
