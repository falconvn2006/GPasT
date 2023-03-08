unit Services.Usuario;

interface

uses
  System.SysUtils, System.Classes, Providers.Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.JSON, Horse,
  FireDAC.VCLUI.Wait;

type
  TServiceUsuario = class(TProvidersCadastro)
    vQryPesquisaid: TLargeintField;
    vQryPesquisanome: TWideStringField;
    vQryPesquisalogin: TWideStringField;
    vQryPesquisastatus: TSmallintField;
    vQryPesquisatelefone: TWideStringField;
    vQryPesquisasexo: TSmallintField;
    vQryCadastroid: TLargeintField;
    vQryCadastronome: TWideStringField;
    vQryCadastrologin: TWideStringField;
    vQryCadastrosenha: TWideStringField;
    vQryCadastrostatus: TSmallintField;
    vQryCadastrotelefone: TWideStringField;
    vQryCadastrosexo: TSmallintField;
    vQryCadastrofoto: TBlobField;
    procedure vQryCadastroBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    function Append(const AJson: TJSONObject): boolean; override;
    function Update(const AJson: TJSONObject): boolean; override;
    function GetById(const AId: string): TFDQuery; override;
    function ListAll(const AParams: THorseCoreParam): TFDQuery; override;
    function SalvarFotoUsuario(const AFoto: TStream): boolean;
    function ObterFotoUsuario: TStream;
  end;

var
  ServiceUsuario: TServiceUsuario;

implementation

uses
  BCrypt;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TServiceUsuario }

function TServiceUsuario.Append(const AJson: TJSONObject): boolean;
begin
  Result := inherited Append(AJson);
  vQryCadastrosenha.Visible := False;
end;

function TServiceUsuario.GetById(const AId: string): TFDQuery;
begin
  Result := inherited GetById(AId);
  vQryCadastrosenha.Visible := False;
end;

function TServiceUsuario.ListAll(const AParams: THorseCoreParam): TFDQuery;
begin
 if AParams.ContainsKey('id') then
  begin
    vQryPesquisa.SQL.Add('and id = :id');
    vQryPesquisa.ParamByName('id').AsLargeInt := AParams.Items['id'].ToInt64;
    vQryRecords.SQL.Add('and id = :id');
    vQryRecords.ParamByName('id').AsLargeInt := AParams.Items['id'].ToInt64;
  end;

  if AParams.ContainsKey('nome') then
  begin
    vQryPesquisa.SQL.Add('and lower(nome) like :nome');
    vQryPesquisa.ParamByName('nome').AsString := '%' + AParams.Items['nome']
      .ToLower + '%';

    vQryRecords.SQL.Add('and lower(nome) like :nome');
    vQryRecords.ParamByName('nome').AsString := '%' + AParams.Items['nome']
      .ToLower + '%';
  end;

  if AParams.ContainsKey('login') then
  begin
    vQryPesquisa.SQL.Add('and login = :login');
    vQryPesquisa.ParamByName('login').AsString := AParams.Items['login'];

    vQryRecords.SQL.Add('and login = :login');
    vQryRecords.ParamByName('login').AsString := AParams.Items['login'];
  end;

  vQryCadastro.SQL.Add(' order by id ');
  Result := inherited ListAll(AParams);
end;

function TServiceUsuario.ObterFotoUsuario: TStream;
begin
  Result := nil;
  if vQryCadastrofoto.IsNull then
    Exit;

  Result := TMemoryStream.Create;
  vQryCadastrofoto.SaveToStream(Result);
end;

function TServiceUsuario.SalvarFotoUsuario(const AFoto: TStream): boolean;
begin
  vQryCadastro.Edit;
  vQryCadastrofoto.LoadFromStream(AFoto);
  vQryCadastro.Post;
  Result := vQryCadastro.ApplyUpdates(0) = 0;
end;

function TServiceUsuario.Update(const AJson: TJSONObject): boolean;
begin
  vQryCadastrosenha.Visible := True;
  Result := inherited Update(AJson);
end;

procedure TServiceUsuario.vQryCadastroBeforePost(DataSet: TDataSet);
begin
  inherited;
  if (vQryCadastrosenha.OldValue <> vQryCadastrosenha.NewValue) and
     (not vQryCadastrosenha.AsString.Trim.IsEmpty)
  then
    vQryCadastrosenha.AsString := TBCrypt.GenerateHash(vQryCadastrosenha.AsString);
end;

end.
