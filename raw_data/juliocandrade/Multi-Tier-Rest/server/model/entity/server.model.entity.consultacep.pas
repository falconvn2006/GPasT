unit server.model.entity.consultacep;

interface
type
  TModelConsultaCEP = class
  private
    FComplemento: String;
    FLogradouro: String;
    FCEP: String;
    FBairro: String;
    FUf: String;
    FLocalidade: String;
    FErro: Boolean;

    procedure Setbairro(const Value: String);
    procedure SetCEP(const Value: String);
    procedure Setcomplemento(const Value: String);
    procedure Setlocalidade(const Value: String);
    procedure SetLogradouro(const Value: String);
    procedure SetUf(const Value: String);
    procedure SetErro(const Value: Boolean);
  public
    property Erro : Boolean read FErro write SetErro;
    property CEP : String read FCEP write SetCEP;
    property Logradouro : String read FLogradouro write SetLogradouro;
    property Complemento : String read FComplemento write Setcomplemento;
    property Bairro : String read FBairro write Setbairro;
    property Localidade : String read FLocalidade write Setlocalidade;
    property Uf : String read FUf write SetUf;

  end;
implementation

{ TModelConsultaCEP }

procedure TModelConsultaCEP.Setbairro(const Value: String);
begin
  FBairro := Value;
end;

procedure TModelConsultaCEP.SetCEP(const Value: String);
begin
  FCEP := Value;
end;

procedure TModelConsultaCEP.Setcomplemento(const Value: String);
begin
  FComplemento := Value;
end;

procedure TModelConsultaCEP.SetErro(const Value: Boolean);
begin
  FErro := Value;
end;

procedure TModelConsultaCEP.Setlocalidade(const Value: String);
begin
  FLocalidade := Value;
end;

procedure TModelConsultaCEP.SetLogradouro(const Value: String);
begin
  FLogradouro := Value;
end;

procedure TModelConsultaCEP.SetUf(const Value: String);
begin
  FUf := Value;
end;

end.
