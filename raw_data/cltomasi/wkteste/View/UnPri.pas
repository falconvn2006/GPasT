unit UnPri;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Datasnap.DBClient, MemDS,
  VirtualDataSet, Datasnap.Provider;

type
  TFrmPrincipal = class(TForm)
    Panel1: TPanel;
    PALE: TPanel;
    Panel2: TPanel;
    dgPesquisa: TDBGrid;
    Label1: TLabel;
    edPesquisa: TEdit;
    btnPesquisa: TBitBtn;
    BtnInserir: TBitBtn;
    BtnAlterar: TBitBtn;
    BtnExcluir: TBitBtn;
    btnSair: TBitBtn;
    DsLista: TDataSource;
    cdLista: TClientDataSet;
    cdListaidPessoa: TIntegerField;
    cdListaNomePrimeiro: TStringField;
    cdListaNomeSegundo: TStringField;
    cdListadtRegistro: TDateTimeField;
    procedure btnPesquisaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnInserirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;


implementation

uses
  Pessoa, ControllerPessoa, UnCadastro;


{$R *.dfm}

procedure TFrmPrincipal.BtnAlterarClick(Sender: TObject);
begin
  Application.CreateForm(TFrmCadastro, FrmCadastro);
  try
    FrmCadastro.idPessoa := cdlistaidpessoa.AsInteger;
    FrmCadastro.showmodal;
    if FrmCadastro.modalresult = mrOk then
      btnPesquisaClick(Self);
  finally
    FrmCadastro.free;
  end;
end;

procedure TFrmPrincipal.BtnExcluirClick(Sender: TObject);
var
  cPessoa : TControlePessoa;
begin
  if cdLista.IsEmpty then exit;
  
  cPessoa := TControlePessoa.Create;
  try
    If MessageDlg('Você tem certeza que deseja excluir o registro?',mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      cPessoa.ExcluirPessoa(cdListaidPessoa.AsInteger);
      btnPesquisaClick(nil);
    end;
  finally
    cPessoa.free;
  end;
end;

procedure TFrmPrincipal.BtnInserirClick(Sender: TObject);
begin
  Application.CreateForm(TFrmCadastro, FrmCadastro);
  try
    FrmCadastro.idPessoa := 0;
    FrmCadastro.showmodal;
    if FrmCadastro.modalresult = mrOk then
      btnPesquisaClick(Self);
  finally
     FrmCadastro.free;
  end;
end;

procedure TFrmPrincipal.btnPesquisaClick(Sender: TObject);
var cPessoa : TControlePessoa;
  lPessoa : TListaPessoa;
  x : integer;
begin
  cPessoa := TControlePessoa.create;
  lPessoa :=  TListaPessoa.Create;
  try

    cdLista.close;
    cdLista.Open;
    cdLista.EmptyDataSet;
    cPessoa.ListarPessoa(edPesquisa.Text, lPessoa);
    for x := 0 to lPessoa.Count - 1 do
    begin
      cdLista.Append;
      cdListaidPessoa.AsInteger := TPessoa(lpessoa[x]).IdPessoa;
      cdListaNomePrimeiro.AsString := TPessoa(lpessoa[x]).NmPrimeiro;
      cdListaNomeSegundo.AsString := TPessoa(lpessoa[x]).NmSegundo;
      cdListadtRegistro.AsDateTime := TPessoa(lpessoa[x]).DtRegistro;
      cdLista.post;
    end;
    cdLista.First;

  finally
    cPessoa.free;
  end;
end;

procedure TFrmPrincipal.btnSairClick(Sender: TObject);
begin
  close;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  cdLista.CreateDataSet;

end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  btnPesquisaClick(nil);
end;

end.
