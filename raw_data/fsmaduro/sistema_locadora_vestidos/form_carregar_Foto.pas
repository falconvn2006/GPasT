unit form_carregar_Foto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, IBCustomDataSet, IBQuery, dxGDIPlusClasses, ExtCtrls,
  LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit,
  LMDCustomEdit, LMDCustomBrowseEdit, LMDCustomFileEdit, LMDFileOpenEdit,
  StdCtrls, wwdblook, Buttons;

type TOperacao = (toGravar, toExcluir, toNenhum);

type
  Tcarregar_Foto = class(TForm)
    Panel_btns_cad: TPanel;
    btn_gravar: TSpeedButton;
    btn_sair: TSpeedButton;
    btn_excluir: TSpeedButton;
    Image1: TImage;
    dtsTipoFoto: TDataSource;
    qryTipoFoto: TIBQuery;
    Panel1: TPanel;
    Label12: TLabel;
    cmbTipoFoto: TwwDBLookupCombo;
    SpeedButton7: TSpeedButton;
    edtUrlFoto: TLMDFileOpenEdit;
    Label1: TLabel;
    SpeedButton6: TSpeedButton;
    SpeedButton3: TSpeedButton;
    qryTipoFotoCODIGO: TIntegerField;
    qryTipoFotoDESCRICAO: TIBStringField;
    qryTipoFotoUSARNAARARA: TIntegerField;
    procedure edtUrlFotoBrowse(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_sairClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure cmbTipoFotoExit(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    { Private declarations }
  public
    _UrlBaseFoto: String;
    _UrlFoto: String;
    _TipoFoto, _CodigoProduto: Integer;
    _Operacao : TOperacao;
    UrlPadrao : String;
    { Public declarations }
  end;

var
  carregar_Foto: Tcarregar_Foto;

implementation

uses form_cadastro_Tipo_Foto, untDados, funcao, versao;

{$R *.dfm}

//BOTÃO HELP
procedure Tcarregar_Foto.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tcarregar_Foto.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0;
    ControleVersao.ShowAlteracoes(self.Name);
  end
  else
    inherited;
end;
//FIM BOTÃO HELP

procedure Tcarregar_Foto.btn_excluirClick(Sender: TObject);
begin
  _UrlFoto := '';
  _TipoFoto := 0;
  _Operacao := toExcluir;
  Close;
end;

procedure Tcarregar_Foto.btn_gravarClick(Sender: TObject);
begin
  if cmbTipoFoto.LookupValue = '' then
  begin
    application.MessageBox('Tipo de Foto Obrigatório!','CARREGAR FOTO',MB_OK+MB_ICONERROR);
    Abort;
  end;

  _UrlFoto := edtUrlFoto.Filename;
  _TipoFoto := StrToIntDef(cmbTipoFoto.LookupValue,0);
  _Operacao := toGravar;
  Close;
end;

procedure Tcarregar_Foto.btn_sairClick(Sender: TObject);
begin
  _Operacao := toNenhum;
  Close;
end;

procedure Tcarregar_Foto.cmbTipoFotoExit(Sender: TObject);
begin

  Dados.Geral.Close;
  Dados.Geral.SQL.Text := 'SELECT * FROM TABPRODUTOFOTOS '+
                          ' WHERE CODIGOPRODUTO =0'+intToStr(_CodigoProduto)+
                          '   AND ID =0'+qryTipoFotoCODIGO.Text;
  Dados.Geral.Open;

  if Trim(Dados.Geral.FieldByName('URLFOTO').AsString) <> '' then
  begin
    edtUrlFoto.Filename := Trim(Dados.Geral.FieldByName('URLFOTO').AsString);
    if FileExists(UrlPadrao+Trim(Dados.Geral.FieldByName('URLFOTO').AsString)) then
      Image1.Picture.LoadFromFile(UrlPadrao+Trim(Dados.Geral.FieldByName('URLFOTO').AsString))
    else
      Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'imagens\logo.png');
  end
  else
      Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'imagens\logo.png');

end;

procedure Tcarregar_Foto.edtUrlFotoBrowse(Sender: TObject);
begin
  if FileExists(edtUrlFoto.Filename) then
    Image1.Picture.LoadFromFile(edtUrlFoto.Filename)
  else
    Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'imagens\logo.png');
end;

procedure Tcarregar_Foto.FormShow(Sender: TObject);
begin
  _Operacao := toNenhum;

  qryTipoFoto.Close;
  qryTipoFoto.Open;

  UrlPadrao := Dados.ValidaURL(tuProduto);

  if _UrlFoto <> '' then
  begin
    edtUrlFoto.Filename := _UrlFoto;
    if FileExists(UrlPadrao+_UrlFoto) then
      Image1.Picture.LoadFromFile(UrlPadrao+_UrlFoto)
    else
      Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'imagens\logo.png');
  end
  else
      Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'imagens\logo.png');

  if _TipoFoto > 0 then
    cmbTipoFoto.LookupValue := IntTostr(_TipoFoto);
end;

procedure Tcarregar_Foto.SpeedButton3Click(Sender: TObject);
begin
  qryTipoFoto.Next;
  cmbTipoFoto.LookupValue := qryTipoFotoCODIGO.Text;
  cmbTipoFotoExit(cmbTipoFoto);
end;

procedure Tcarregar_Foto.SpeedButton6Click(Sender: TObject);
begin
  qryTipoFoto.Prior;
  cmbTipoFoto.LookupValue := qryTipoFotoCODIGO.Text;
  cmbTipoFotoExit(cmbTipoFoto);
end;

procedure Tcarregar_Foto.SpeedButton7Click(Sender: TObject);
begin
  If Application.FindComponent('cadastro_Tipo_Foto') = Nil then
         Application.CreateForm(Tcadastro_Tipo_Foto, cadastro_Tipo_Foto);

  cadastro_Tipo_Foto.ShowModal;

  qryTipoFoto.Close;
  qryTipoFoto.Open;
end;

end.
