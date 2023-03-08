unit EnderecoModel;

interface

type
  TEndereco = class

    private
      FIdEndereco: Integer;
      FDsCep: String;
      FIdPessoa: Integer;
      procedure setDsCep(const Value: String);
      procedure setIdEndereco(const Value: Integer);
      procedure setIdPessoa(const Value: Integer);

    public
      property IdEndereco : Integer read FIdEndereco write setIdEndereco;
      property IdPessoa   : Integer read FIdPessoa   write setIdPessoa;
      property DsCep      : String  read FDsCep      write setDsCep;
  end;

implementation

{ TEndereco }

procedure TEndereco.setDsCep(const Value: String);
begin
  FDsCep := Value;
end;

procedure TEndereco.setIdEndereco(const Value: Integer);
begin
  FIdEndereco := Value;
end;

procedure TEndereco.setIdPessoa(const Value: Integer);
begin
  FIdPessoa := Value;
end;

end.
