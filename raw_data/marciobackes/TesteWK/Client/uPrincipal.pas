unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.Json, REST.Utils,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  REST.Response.Adapter, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, Vcl.DBCtrls, System.Types, StrUtils;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    ButtonInserir: TButton;
    ButtonDeletar: TButton;
    Memo: TMemo;
    EditIdPessoa: TEdit;
    ComboBoxNatureza: TComboBox;
    EditPrimeiroNome: TEdit;
    EditSegundoNome: TEdit;
    EditDocumento: TMaskEdit;
    EditCep: TMaskEdit;
    ButtonUpdate: TButton;
    OpenDialog1: TOpenDialog;
    ButtonInserirLote: TButton;
    procedure ButtonInserirClick(Sender: TObject);
    procedure ButtonDeletarClick(Sender: TObject);
    procedure ComboBoxNaturezaChange(Sender: TObject);
    procedure ButtonUpdateClick(Sender: TObject);
    procedure ButtonInserirLoteClick(Sender: TObject);
  private
    { Private declarations }
    procedure LimparCampos;
    function CarregarArquivoLote: TJSONArray;
    procedure Validar;
    procedure Inserir;
    procedure Deletar;
    procedure Update;
    procedure InserirLote(AArray: TJSONArray);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ButtonDeletarClick(Sender: TObject);
begin
  Deletar;
end;

procedure TForm1.ButtonInserirClick(Sender: TObject);
begin
  Validar;
  Inserir;
end;

procedure TForm1.ButtonInserirLoteClick(Sender: TObject);
begin
  InserirLote(CarregarArquivoLote);
end;

procedure TForm1.ButtonUpdateClick(Sender: TObject);
begin
  Validar;
  Update;
end;

function TForm1.CarregarArquivoLote: TJSONArray;
const
  INDEX_ID = 0;
  INDEX_NATUREZA = 1;
  INDEX_DOCUMENTO = 2;
  INDEX_PRIMEIRO_NOME = 3;
  INDEX_SEGUNDO_NOME = 4;
  INDEX_CEP = 5;
var
  LCaminho: string;
  LArquivo: TStringList;
  LLinha: TStringDynArray;
  LJSONObject: TJSONObject;
  LIndex: Integer;
begin
  if OpenDialog1.Execute then
    LCaminho := OpenDialog1.FileName;

  Result := TJSONArray.Create;

  if not LCaminho.IsEmpty then
  begin
    LArquivo := TStringList.Create;
    try
      LArquivo.LoadFromFile(LCaminho);

      if LArquivo.Count > 0 then
      begin
        if LArquivo[0].Trim <> EmptyStr then
        begin
          LLinha := SplitString(LArquivo[0], ';');
          if (LLinha = nil) or (High(LLinha) + 1 < 6) then
            raise Exception.Create('Arquivo inválido. Layout esperado: IdPessoa;Natureza;Documento;PrimeiroNome;SegundoNome;Cep;')
          else
          begin
            for LIndex := 0 to Pred(LArquivo.Count) do
            begin
              if LArquivo[LIndex].Trim <> EmptyStr then
              begin
                LLinha := SplitString(LArquivo[LIndex], ';');
                if (LLinha = nil) or (High(LLinha) + 1 > 5) then
                begin
                  LJSONObject := TJSONObject.Create;
                  LJSONObject.AddPair('idpessoa', LLinha[INDEX_ID]);
                  LJSONObject.AddPair('flnatureza', LLinha[INDEX_NATUREZA]);
                  LJSONObject.AddPair('dsdocumento', LLinha[INDEX_DOCUMENTO].Replace('.', '').Replace('/', '').Replace('-', ''));
                  LJSONObject.AddPair('nmprimeiro', LLinha[INDEX_PRIMEIRO_NOME]);
                  LJSONObject.AddPair('nmsegundo', LLinha[INDEX_SEGUNDO_NOME]);
                  LJSONObject.AddPair('dscep', LLinha[INDEX_CEP].Replace('.', '').Replace('-', ''));

                  Result.AddElement(LJSONObject);
                end;
              end;
            end;
          end;
        end;
      end;
    finally
      LArquivo.Free;
    end;
  end;
end;

procedure TForm1.ComboBoxNaturezaChange(Sender: TObject);
begin
  if ComboBoxNatureza.ItemIndex = 0 then
    EditDocumento.EditMask := '999.999.999-99;0'
  else
    EditDocumento.EditMask := '99.999.999/9999-99;0'
end;

procedure TForm1.Deletar;
begin
  if EditIdPessoa.Text = EmptyStr then
    raise Exception.Create('Informe o campo ID Pessoa.');

  RESTClient.ResetToDefaults;
  RESTRequest.ResetToDefaults;
  RESTResponse.ResetToDefaults;
  RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient.BaseURL := Format('http://%s:%s/datasnap/rest', ['localhost', '8080']);
  RESTClient.ContentType := 'application/json';
  RESTRequest.Resource := 'TServerMethods/Pessoa/{id}';
  RESTClient.HandleRedirects := True;
  RESTClient.RaiseExceptionOn500 := False;
  RESTRequest.SynchronizedEvents := False;
  RESTRequest.Client := RESTClient;
  RESTRequest.Response := RESTResponse;
  RESTRequest.Method := TRESTRequestMethod.rmDELETE;
  RESTRequest.Params.AddItem('id',
        URIEncode(EditIdPessoa.Text),
        TRESTRequestParameterKind.pkURLSEGMENT, [],
        ctAPPLICATION_JSON);
  RESTRequest.Execute;

  Memo.Lines.Clear;
  Memo.Lines.Append(RESTRequestMethodToString(RESTRequest.Method));
  Memo.Lines.Append(RESTRequest.Params.ParameterByName('id').ToString);
  Memo.Lines.Append(RESTResponse.Content);

  LimparCampos;
end;

procedure TForm1.Inserir;
var
  LObject: TJSONObject;
begin
  RESTClient.ResetToDefaults;
  RESTRequest.ResetToDefaults;
  RESTResponse.ResetToDefaults;

  LObject := TJSONObject.Create;
  LObject.AddPair('idpessoa', EditIdPessoa.Text);
  LObject.AddPair('flnatureza', ComboBoxNatureza.ItemIndex.ToString);
  LObject.AddPair('dsdocumento', EditDocumento.Text);
  LObject.AddPair('nmprimeiro', EditPrimeiroNome.Text);
  LObject.AddPair('nmsegundo', EditSegundoNome.Text);
  LObject.AddPair('dscep', EditCEP.Text);

  RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient.BaseURL := Format('http://%s:%s/datasnap/rest', ['localhost', '8080']);
  RESTClient.ContentType := 'application/json';
  RESTRequest.Resource := 'TServerMethods/Pessoa';
  RESTClient.HandleRedirects := True;
  RESTClient.RaiseExceptionOn500 := False;
  RESTRequest.Client := RESTClient;
  RESTRequest.Method := TRESTRequestMethod.rmPut;
  RESTRequest.Body.Add(LObject.ToString, ContentTypeFromString('application/json'));
  RESTRequest.Execute;

  Memo.Lines.Clear;
  Memo.Lines.Append(RESTRequestMethodToString(RESTRequest.Method));
  Memo.Lines.Append(LObject.ToJSON);
  Memo.Lines.Append(RESTResponse.Content);

  LimparCampos;
end;

procedure TForm1.InserirLote(AArray: TJSONArray);
begin
  RESTClient.ResetToDefaults;
  RESTRequest.ResetToDefaults;
  RESTResponse.ResetToDefaults;

  RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient.BaseURL := Format('http://%s:%s/datasnap/rest', ['localhost', '8080']);
  RESTClient.ContentType := 'application/json';
  RESTRequest.Resource := 'TServerMethods/PessoaLote';
  RESTClient.HandleRedirects := True;
  RESTClient.RaiseExceptionOn500 := False;
  RESTRequest.Client := RESTClient;
  RESTRequest.Method := TRESTRequestMethod.rmPut;
  RESTRequest.Body.Add(AArray.ToString, ContentTypeFromString('application/json'));
  RESTRequest.Execute;

  Memo.Lines.Clear;
  Memo.Lines.Append(RESTRequestMethodToString(RESTRequest.Method));
  Memo.Lines.Append(AArray.ToJSON);
  Memo.Lines.Append(RESTResponse.Content);

  LimparCampos;
end;

procedure TForm1.LimparCampos;
begin
  EditIdPessoa.Clear;
  ComboBoxNatureza.ItemIndex := -1;
  EditPrimeiroNome.Clear;
  EditSegundoNome.Clear;
  EditDocumento.Clear;
  EditCep.Clear;
end;

procedure TForm1.Update;
var
  LObject: TJSONObject;
begin
  RESTClient.ResetToDefaults;
  RESTRequest.ResetToDefaults;
  RESTResponse.ResetToDefaults;

  LObject := TJSONObject.Create;
  LObject.AddPair('idpessoa', EditIdPessoa.Text);
  LObject.AddPair('flnatureza', ComboBoxNatureza.ItemIndex.ToString);
  LObject.AddPair('dsdocumento', EditDocumento.Text);
  LObject.AddPair('nmprimeiro', EditPrimeiroNome.Text);
  LObject.AddPair('nmsegundo', EditSegundoNome.Text);
  LObject.AddPair('dscep', EditCEP.Text);

  RESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient.AcceptCharset := 'UTF-8, *;q=0.8';
  RESTClient.BaseURL := Format('http://%s:%s/datasnap/rest', ['localhost', '8080']);
  RESTClient.ContentType := 'application/json';
  RESTRequest.Resource := 'TServerMethods/Pessoa';
  RESTClient.HandleRedirects := True;
  RESTClient.RaiseExceptionOn500 := False;
  RESTRequest.Client := RESTClient;
  RESTRequest.Method := TRESTRequestMethod.rmPOST;
  RESTRequest.Body.Add(LObject.ToString, ContentTypeFromString('application/json'));
  RESTRequest.Execute;

  Memo.Lines.Clear;
  Memo.Lines.Append(RESTRequestMethodToString(RESTRequest.Method));
  Memo.Lines.Append(LObject.ToJSON);
  Memo.Lines.Append(RESTResponse.Content);

  LimparCampos;
end;

procedure TForm1.Validar;
begin
  if EditIdPessoa.Text = EmptyStr then
    raise Exception.Create('Informe o id da pessoa.');
  if (Length(EditDocumento.Text) <> 11) and (Length(EditDocumento.Text) <> 14) then
    raise Exception.Create('Documento inválido.');
  if Length(EditCEP.Text) <> 8 then
    raise Exception.Create('CEP inválido.');
end;

end.
