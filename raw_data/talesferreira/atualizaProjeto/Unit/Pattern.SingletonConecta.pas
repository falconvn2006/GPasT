unit Pattern.SingletonConecta;

interface

Uses Winapi.Windows, System.SysUtils, Vcl.Forms, IniFiles, Bib.Functions;

Type
  //Exemplo de Record Helper
  TConfiguracoesHelper = record helper for String
    function EMaiorQueVersaoVigente: Boolean;
    function adicionaDiretorio: String;
  end;

  TConfiguracoes = class
  private
    arquivoINI: TInifile;
    FcaminhoVersaoAtual: String;
    FcaminhoVersaoAtualizada: String;
    FcaminhoGardaVersoes: String;
    FnomeArquivo: String;
    FversaoAtualSistema: String;
    FdiretorioVersao: String;
    FversaoNovaArquivo: String;
    FversaoNovaEMaiorQueVersaoAtual: Boolean;
  public
    class function ObterInstancia: TConfiguracoes;
    class function NewInstance: TObject; override;
    Procedure atualizaValorVersaoArquivoINI(versao: String);
    Property caminhoVersaoAtual: String Read FcaminhoVersaoAtual Write FcaminhoVersaoAtual;
    Property caminhoVersaoAtualizada: String Read FcaminhoVersaoAtualizada Write FcaminhoVersaoAtualizada;
    Property caminhoGardaVersoes: String Read FcaminhoGardaVersoes Write FcaminhoGardaVersoes;
    Property nomeArquivo: String Read FnomeArquivo Write FnomeArquivo;
    property versaoAtualSistema: String read FversaoAtualSistema write FversaoAtualSistema;
    property diretorioVersao: String read FdiretorioVersao write FdiretorioVersao;
    property versaoNovaArquivo: String read FversaoNovaArquivo write FversaoNovaArquivo;
    property versaoNovaEMaiorQueVersaoAtual: Boolean read FversaoNovaEMaiorQueVersaoAtual write FversaoNovaEMaiorQueVersaoAtual;
  end;


var
  Instancia: TConfiguracoes;

implementation

{ TConfiguracoes }

Procedure TConfiguracoes.atualizaValorVersaoArquivoINI(versao: String);
begin
  Instancia.ArquivoINI := TInifile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
  Instancia.ArquivoINI.WriteString('PARÂMETROS PRINCIPAIS', 'versaoAtualSistema', versao);
  Instancia.ArquivoINI.Free;
end;

class function TConfiguracoes.NewInstance: TObject;
begin
  if not Assigned(Instancia) then
  Begin
    // chama a função "NewInstance" da herança (TObject)
    Instancia := TConfiguracoes(inherited NewInstance);
    Try
      Instancia.ArquivoINI := TInifile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
      Instancia.FcaminhoVersaoAtual := Instancia.ArquivoINI.ReadString('PARÂMETROS PRINCIPAIS', 'caminhoVersaoAtual', '');
      Instancia.FcaminhoVersaoAtualizada := Instancia.ArquivoINI.ReadString('PARÂMETROS PRINCIPAIS', 'caminhoVersaoAtualizada', '');
      Instancia.FcaminhoGardaVersoes := Instancia.ArquivoINI.ReadString('PARÂMETROS PRINCIPAIS', 'caminhoGardaVersoes', '');
      Instancia.FnomeArquivo := Instancia.ArquivoINI.ReadString('PARÂMETROS PRINCIPAIS', 'nomeArquivo', '');
      Instancia.FversaoAtualSistema := Instancia.ArquivoINI.ReadString('PARÂMETROS PRINCIPAIS', 'versaoAtualSistema', '');
      Instancia.FversaoNovaArquivo := Fnc.identificaVersaoArquivo(Instancia.FcaminhoVersaoAtualizada+Instancia.FnomeArquivo);
      Instancia.FdiretorioVersao := Instancia.FversaoNovaArquivo.adicionaDiretorio;
      Instancia.FversaoNovaEMaiorQueVersaoAtual := Instancia.FversaoNovaArquivo.EMaiorQueVersaoVigente;
      Instancia.ArquivoINI.Free;
    Except
      Fnc.Msg('Arquivo config.ini está com falha!',Fnc.OkErr);
      Instancia.ArquivoINI.Free;
      Application.Terminate;
    End;
  End;
  result := Instancia;
end;

class function TConfiguracoes.ObterInstancia: TConfiguracoes;
begin
  Result := TConfiguracoes.Create;
end;

{ TConfiguracoesHelper }

function TConfiguracoesHelper.adicionaDiretorio: String;
begin
  Result := '\V'+Self;
end;

function TConfiguracoesHelper.EMaiorQueVersaoVigente: Boolean;
Var nova, atual: Integer;
begin
  nova := StrToInt(StringReplace(Trim(Self), '.', '',[rfReplaceAll, rfIgnoreCase]));
  atual := StrToInt(StringReplace(Instancia.FversaoAtualSistema, '.', '',[rfReplaceAll, rfIgnoreCase]));
  Result := nova > atual;
end;

end.
