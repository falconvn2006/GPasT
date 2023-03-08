unit ClienteModel;

interface

uses
  EnderecoModel, EnderecoIntegracaoModel;

type
  TPessoa = class

  private
    FNmPrimeiro: String;
    FDtRegistro: TDateTime;
    FNmSegundo: String;
    FDsDocumento: String;
    FIdPessoa: Integer;
    FFlNatureza: Integer;
    FEnderecoIntegracao: TEnderecoIntegracao;
    FEndereco: TEndereco;
    procedure setDsDocumento(const Value: String);
    procedure setDtRegistro(const Value: TDateTime);
    procedure setFlNatureza(const Value: Integer);
    procedure setIdPessoa(const Value: Integer);
    procedure setNmPrimeiro(const Value: String);
    procedure setNmSegundo(const Value: String);

  public
    property IdPessoa           : Integer             read FIdPessoa            write setIdPessoa;
    property FlNatureza         : Integer             read FFlNatureza          write setFlNatureza;
    property DsDocumento        : String              read FDsDocumento         write setDsDocumento;
    property NmPrimeiro         : String              read FNmPrimeiro          write setNmPrimeiro;
    property NmSegundo          : String              read FNmSegundo           write setNmSegundo;
    property DtRegistro         : TDateTime           read FDtRegistro          write setDtRegistro;
    property Endereco           : TEndereco           read FEndereco            write FEndereco;
    property EnderecoIntegracao : TEnderecoIntegracao read FEnderecoIntegracao  write FEnderecoIntegracao;

    constructor Create; overload;
end;

implementation

{ TPessoa }
constructor TPessoa.Create;
begin
  FEndereco           := TEndereco.Create;
  FEnderecoIntegracao := TEnderecoIntegracao.Create;
end;

procedure TPessoa.setDsDocumento(const Value: String);
begin
  FDsDocumento := Value;
end;

procedure TPessoa.setDtRegistro(const Value: TDateTime);
begin
  FDtRegistro := Value;
end;

procedure TPessoa.setFlNatureza(const Value: Integer);
begin
  FFlNatureza := Value;
end;

procedure TPessoa.setIdPessoa(const Value: Integer);
begin
  FIdPessoa := Value;
end;

procedure TPessoa.setNmPrimeiro(const Value: String);
begin
  FNmPrimeiro := Value;
end;

procedure TPessoa.setNmSegundo(const Value: String);
begin
  FNmSegundo := Value;
end;

end.
