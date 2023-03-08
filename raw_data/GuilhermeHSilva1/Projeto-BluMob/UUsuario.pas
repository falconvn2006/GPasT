unit UUsuario;

interface

uses
  UUtil.banco;

  type
    TUsuario = class
      private
        FCPF: String;
        Fid: Integer;
        FNome: String;
        FEmail: String;

      function GetCPF: String;
      function getId: Integer;
      function GetNome: String;
    function getEmail: String;

      public
        property Id: Integer read getId;
        property CPF: String read GetCPF;
        property Nome: String read GetNome;
        property Email: String read getEmail;
        constructor Create;

    end;

implementation

uses
  System.SysUtils;

{ TUsuario }

constructor TUsuario.Create;
begin
  FCPF :=  TUtilbanco.ExecutarConsulta('SELECT CPF FROM USUARIO');
  FNOME := TUtilbanco.ExecutarConsulta('SELECT NOME FROM USUARIO');
end;

function TUsuario.GetCPF: String;
begin
  result := FCPF;
end;

function TUsuario.getEmail: String;
begin
  result := FEmail;
end;

function TUsuario.getId: Integer;
begin
  result := FId;
end;

function TUsuario.GetNome: String;
begin
  result := FNome;
end;

end.
