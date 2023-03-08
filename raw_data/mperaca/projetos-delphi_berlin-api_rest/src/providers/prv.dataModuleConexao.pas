unit prv.dataModuleConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef,
  FireDAC.Comp.UI, VCL.Dialogs, IniFiles, Horse;

type
  TProviderDataModuleConexao = class(TDataModule)
    FDConnectionApi: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    FIdEmpresa,FIdEmpresaAtividade,FIdEmpresaLocalidade: integer;
    FIdEmpresaPessoa,FIdEmpresaSetor,FIdEmpresaPlanoEstoque,FIdEmpresaNumerario,FIdEmpresaClassificacao: integer;
    FIdEmpresaOcorrencia,FIdEmpresaCondicao,FIdEmpresaProduto,FIdEmpresaFabricante,FIdEmpresaSituacaoTributaria: integer;
    FIdEmpresaAliquota,FIdEmpresaFormula,FIdEmpresaGrade,FIdEmpresaCor,FIdEmpresaCodigoFiscal,FIdEmpresaCobranca: integer;
    FIdEmpresaOperacao,FIdEmpresaValidacao,FIdEmpresaIndexador,FIdEmpresaDesconto,FIdEmpresaTipoLente: integer;
    FIdEmpresaIdentificador,FIdEmpresaHistoricoPadrao,FIdEmpresaPlanoContas,FIdEmpresaProdutoPreco,FIdEmpresaCategoria,FIdEmpresaTabelaPreco,FIdEmpresaFamilia: integer;

    function EstabeleceConexaoDB: boolean;
    function EncerraConexaoDB: boolean;
    procedure CarregaArquivoIni;
    { Public declarations }
  end;

var
  ProviderDataModuleConexao: TProviderDataModuleConexao;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TProviderDataModuleConexao }

function TProviderDataModuleConexao.EstabeleceConexaoDB: boolean;
var wret: boolean;
    warqini: TIniFile;
begin
  try
    warqini := TIniFile.Create(GetCurrentDir+'\conexao.ini');
    FDConnectionApi.Connected     := false;
    FDConnectionApi.Params.Clear;
    FDConnectionApi.Params.Add('DataBase='+warqini.ReadString('Conexão','DataBase',''));
    FDConnectionApi.Params.Add('User_Name=postgres');
    FDConnectionApi.Params.Add('Password=postgres');
    FDConnectionApi.Params.Add('Server='+warqini.ReadString('Conexão','HostName',''));
    FDConnectionApi.Params.Add('Port='+warqini.ReadString('Conexão','Porta',''));
    FDConnectionApi.Params.Add('DriverID=PG');
    FDConnectionApi.Params.Add('ApplicationName=TrabinAPI');
//    if warqini.ReadInteger('Conexão','Versão',8)>8 then
       FDConnectionApi.Params.Add('CharacterSet=LATIN1');
    FDPhysPgDriverLink1.VendorLib := GetCurrentDir+'\libpq74.dll';
    FDConnectionApi.LoginPrompt   := false;
    FDConnectionApi.Connected     := true;
    wret := FDConnectionApi.Connected;


  except
    On E: Exception do
    begin
      wret := false;
      THorse.Listen(9000,
        procedure (Horse: THorse)
        begin
           writeln(GetCurrentDir+'\libpq74.dll');
           writeln('Problema ao estabeler Conexão: '+warqini.ReadString('Conexão','DataBase','')+' Erro: '+E.Message);
        end
       );

//      messagedlg('Problema ao estabelecer conexão com banco de dados'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  Result := wret;
end;

procedure TProviderDataModuleConexao.CarregaArquivoIni;
var warqini: TIniFile;
    wquery: TFDQuery;
begin
  try
    warqini    := TIniFile.Create(GetCurrentDir+'\TrabinApi.ini');
    FIdEmpresa := warqini.ReadInteger('Geral','Empresa',0);
    if FIdEmpresa=0 then
      THorse.Listen(9000,
        procedure (Horse: THorse)
        begin
           writeln('Código da empresa não definido no arquivo TrabinApi.ini');
        end
       )
    else
       try
         EstabeleceConexaoDB;
         wquery := TFDQuery.Create(nil);
         with wquery do
         begin
           Connection := FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('select * from "Origem" where "CodigoEmpresaOrigem"=:xempresa ');
           ParamByName('xempresa').AsInteger := FIdEmpresa;
           Open;
           EnableControls;
         end;
         FIdEmpresaAtividade       := wquery.FieldByName('EmpresaAtividadeOrigem').AsInteger;
         FIdEmpresaLocalidade      := wquery.FieldByName('EmpresaLocalidadeOrigem').AsInteger;
         FIdEmpresaPessoa          := wquery.FieldByName('EmpresaPessoaOrigem').AsInteger;
         FIdEmpresaSetor           := wquery.FieldByName('EmpresaSetorOrigem').AsInteger;
         FIdEmpresaPlanoEstoque    := wquery.FieldByName('EmpresaPlanoEstoqueOrigem').AsInteger;
         FIdEmpresaNumerario       := wquery.FieldByName('EmpresaNumerarioOrigem').AsInteger;
         FIdEmpresaClassificacao   := wquery.FieldByName('EmpresaClassificacaoOrigem').AsInteger;
         FIdEmpresaOcorrencia      := wquery.FieldByName('EmpresaOcorrenciaOrigem').AsInteger;
         FIdEmpresaCondicao        := wquery.FieldByName('EmpresaCondicaoOrigem').AsInteger;
         FIdEmpresaProduto         := wquery.FieldByName('EmpresaProdutoOrigem').AsInteger;
         FIdEmpresaFabricante      := wquery.FieldByName('EmpresaFabricanteOrigem').AsInteger;
         FIdEmpresaSituacaoTributaria := wquery.FieldByName('EmpresaSituacaoTributariaOrigem').AsInteger;
         FIdEmpresaAliquota        := wquery.FieldByName('EmpresaAliquotaOrigem').AsInteger;
         FIdEmpresaFormula         := wquery.FieldByName('EmpresaFormulaOrigem').AsInteger;
         FIdEmpresaGrade           := wquery.FieldByName('EmpresaGradeOrigem').AsInteger;
         FIdEmpresaCor             := wquery.FieldByName('EmpresaCorOrigem').AsInteger;
         FIdEmpresaCodigoFiscal    := wquery.FieldByName('EmpresaCodigoFiscalOrigem').AsInteger;
         FIdEmpresaCobranca        := wquery.FieldByName('EmpresaCobrancaOrigem').AsInteger;
         FIdEmpresaOperacao        := wquery.FieldByName('EmpresaOperacaoOrigem').AsInteger;
         FIdEmpresaValidacao       := wquery.FieldByName('EmpresaValidacaoOrigem').AsInteger;
         FIdEmpresaIndexador       := wquery.FieldByName('EmpresaIndexadorOrigem').AsInteger;
         FIdEmpresaDesconto        := wquery.FieldByName('EmpresaDescontoOrigem').AsInteger;
         FIdEmpresaTipoLente       := wquery.FieldByName('EmpresaTipoLente').AsInteger;
         FIdEmpresaIdentificador   := wquery.FieldByName('EmpresaIdentificadorOrigem').AsInteger;
         FIdEmpresaHistoricoPadrao := wquery.FieldByName('EmpresaHistoricoPadraoOrigem').AsInteger;
         FIdEmpresaPlanoContas     := wquery.FieldByName('EmpresaPlanoContasOrigem').AsInteger;
         FIdEmpresaProdutoPreco    := wquery.FieldByName('EmpresaProdutoPrecoOrigem').AsInteger;
         FIdEmpresaCategoria       := wquery.FieldByName('EmpresaCategoriaOrigem').AsInteger;
         FIdEmpresaTabelaPreco     := wquery.FieldByName('EmpresaTabelaPrecoOrigem').AsInteger;
         FIdEmpresaFamilia         := wquery.FieldByName('EmpresaFamiliaOrigem').AsInteger;
       finally
         EncerraConexaoDB;
         FreeAndNil(wquery);
       end;

  except
    On E: Exception do
    begin
      THorse.Listen(9000,
        procedure (Horse: THorse)
        begin
           writeln('Problema ao carregar arquivo TrabinApi.ini: '+E.Message);
        end
       );
    end;
  end;

end;

procedure TProviderDataModuleConexao.DataModuleCreate(Sender: TObject);
begin
  CarregaArquivoIni;
end;

function TProviderDataModuleConexao.EncerraConexaoDB: boolean;
var wret: boolean;
begin
  try
    FDConnectionApi.Connected := false;
    wret                      := true;
  except
//    On E: Exception do
//    begin
      wret := false;
//      messagedlg('Problema ao estabelecer conexão com banco de dados'+slinebreak+E.Message,mterror,[mbok],0);
//    end;
  end;
  Result := wret;
end;

end.
