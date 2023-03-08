unit udtoPessoa;

interface

uses
  System.Generics.Collections, FireDAC.Comp.Client, SysUtils;

type
  TDtoPessoa = class;
  TDtoPessoas = class;
  TDtoPessoa = class(TObject)
  private
    Fnmprimeiro: System.String;
    Fdtregistro: System.TDate;
    Fnmsegundo: System.String;
    Fdsdocumento: System.String;
    Fidpessoa: System.Integer;
    Fflnatureza: System.Integer;
    Fdscep: System.String;
    { private declarations }
    procedure InternalClear();
    procedure Setdsdocumento(const Value: System.String);
    procedure Setdtregistro(const Value: System.TDate);
    procedure Setflnatureza(const Value: System.Integer);
    procedure Setidpessoa(const Value: System.Integer);
    procedure Setnmprimeiro(const Value: System.String);
    procedure Setnmsegundo(const Value: System.String);
    procedure Setdscep(const Value: System.String);
  public
    constructor Create();
    procedure Clear; inline;
    property idpessoa: System.Integer read Fidpessoa write Setidpessoa;
    property flnatureza: System.Integer read Fflnatureza write Setflnatureza;
    property dsdocumento: System.String read Fdsdocumento write Setdsdocumento;
    property nmprimeiro: System.String read Fnmprimeiro write Setnmprimeiro;
    property nmsegundo: System.String  read Fnmsegundo write Setnmsegundo;
    property dtregistro: System.TDate  read Fdtregistro write Setdtregistro;
    property dscep: System.String  read Fdscep write Setdscep;
  end;
  TDtoPessoas = class(TObjectList<TDtoPessoa>)
  end;

implementation
{ TDtoPessoa }

procedure TDtoPessoa.Clear;
begin
  Self.InternalClear();
end;

constructor TDtoPessoa.Create();
begin
  Self.InternalClear();
end;


procedure TDtoPessoa.InternalClear;
begin
  Fidpessoa := 0;
  Fnmprimeiro := EmptyStr;
  Fdtregistro := 0;
  Fnmsegundo := EmptyStr;
  Fdsdocumento := EmptyStr;
  Fflnatureza := 0;
  Fdscep := EmptyStr;
end;


procedure TDtoPessoa.Setdscep(const Value: System.String);
begin
  Fdscep := Value;
end;

procedure TDtoPessoa.Setdsdocumento(const Value: System.String);
begin
  Fdsdocumento := Value;
end;

procedure TDtoPessoa.Setdtregistro(const Value: System.TDate);
begin
  Fdtregistro := Value;
end;

procedure TDtoPessoa.Setflnatureza(const Value: System.Integer);
begin
  Fflnatureza := Value;
end;

procedure TDtoPessoa.Setidpessoa(const Value: System.Integer);
begin
  Fidpessoa := Value;
end;

procedure TDtoPessoa.Setnmprimeiro(const Value: System.String);
begin
  Fnmprimeiro := Value;
end;

procedure TDtoPessoa.Setnmsegundo(const Value: System.String);
begin
  Fnmsegundo := Value;
end;

end.
