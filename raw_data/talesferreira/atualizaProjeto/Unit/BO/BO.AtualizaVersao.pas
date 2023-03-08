unit BO.AtualizaVersao;

interface

Uses
  System.SysUtils, Winapi.Windows, Vcl.Forms, Vcl.Menus, Winapi.ShellAPI,
  Bib.Functions,
  Pattern.SingletonConecta;

Type
  TBoAtualizaVersao = class(TFunctions)
  Private
  Public
    /// <summary>Método que valida todas as regras de existência de arquivos e diretorios</summary>
    /// <returns><c>True</c> se todos os arquivos existirem corretamente <c>False</c> se falhar em alguma regra</returns>
    /// <exception cref="1">Caso não encontre o arquivo atualizado no diretório de compartilhamento</exception>
    /// <exception cref="2">Caso a versão origem seja igual a atualizada</exception>
    function arquivosDiretoriosSaoValidos: Boolean;
    /// <summary>Método que vai pegar o novo arquivo e criar um diretorio e salvar na pasta de atualização</summary>
    Procedure executaAtualizacaoDaVersao;
    constructor Create;
    destructor Destroy; override;
  end;

Var boArquivos:TBoAtualizaVersao;

implementation

{ TBoPrincipal }

procedure TBoAtualizaVersao.executaAtualizacaoDaVersao;
begin
  //1º - Criando o diretório da nova versão
  ForceDirectories(Instancia.caminhoGardaVersoes+Instancia.diretorioVersao);

  //2º - Copiando o arquivo novo para o diretório com a nova versão
  CopyFile(PChar(Instancia.caminhoVersaoAtualizada+Instancia.nomeArquivo), PChar(Instancia.caminhoGardaVersoes+Instancia.diretorioVersao+Instancia.nomeArquivo),False);

  //3º - Deletando o arquivo novo do diretório de atualização
  DeleteFile(PChar(Instancia.caminhoVersaoAtual+Instancia.nomeArquivo));

  //4º - Copiando o arquivo do diretório com a nova versão para o diretorio de atualização
  CopyFile(PChar(Instancia.caminhoVersaoAtualizada+Instancia.nomeArquivo), PChar(Instancia.caminhoVersaoAtual+Instancia.nomeArquivo),False);

  //5º - Atualiza o parâmetro versão no arquivo config.ini
  Instancia.atualizaValorVersaoArquivoINI(Instancia.versaoNovaArquivo);

  Msg('A atualização para versão "'+Instancia.versaoNovaArquivo+'" foi realizada com Sucesso!',OkInf);
end;

function TBoAtualizaVersao.arquivosDiretoriosSaoValidos: Boolean;
begin
  try
    //1º - Verifica se o arquivo "prjProjeletic.exe" se encontra no diretório com a versão a ser Atualizada
    if not FileExists(Instancia.caminhoVersaoAtualizada + Instancia.nomeArquivo) then
      raise Exception.Create('1º - Não encontrei o arquivo: '+Instancia.nomeArquivo+' para efetuar a atualização!');

    //2º - Verifica se a versão do arquivo "prjProjeletic.exe" é igual da versão corrente
    if Instancia.versaoAtualSistema = Instancia.versaoNovaArquivo then
      raise Exception.Create('2º - A versão disponível é: '+Instancia.versaoAtualSistema+' e já foi liberada!');

    //3º - Verificar se o diretório da versão a ser Atualizada existe
     if DirectoryExists(Instancia.caminhoGardaVersoes+Instancia.diretorioVersao) then
      raise Exception.Create('3º - A nova versão '+Instancia.versaoNovaArquivo+' já tem um diretorio criado!');

    //4º - Testar se a versão nova é maior que a última versão
    if not Instancia.versaoNovaEMaiorQueVersaoAtual then
      raise Exception.Create('4º - A nova versão nova '+Instancia.versaoNovaArquivo+' é menor ou igual a versão atual '+Instancia.versaoAtualSistema+'!');

    Result := True;
  except on E: Exception do
    Begin
      Msg(E.Message,OkErr);
      Result := False;
    end;
  end;
end;


constructor TBoAtualizaVersao.Create;
begin
//  inherited;
//  F_Arq        := TArquivo.Create;
end;

destructor TBoAtualizaVersao.Destroy;
begin
//  try
//    inherited;
//    If Assigned(F_Arq)        then FreeAndNil(F_Arq);
//  except
//    on e: exception do
//      raise Exception.Create(E.Message);
//  end;
end;
end.
