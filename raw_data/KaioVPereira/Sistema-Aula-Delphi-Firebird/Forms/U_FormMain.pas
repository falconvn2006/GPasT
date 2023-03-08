unit U_FormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client, Data.DB,
  FireDAC.Comp.DataSet;

type
  Tfrm_Principal = class(TForm)
    pn_cabecalho: TPanel;
    btn_novo: TBitBtn;
    btn_gravar: TBitBtn;
    btn_cancelar: TBitBtn;
    btn_excluir: TBitBtn;
    fd_QueryCadastro: TFDQuery;
    fd_UpdCadastros: TFDUpdateSQL;
    fd_transaction: TFDTransaction;
    btn_sair: TBitBtn;
    ds_cadastros: TDataSource;
    procedure btn_novoClick(Sender: TObject);
    procedure btn_gravarClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_sairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Principal: Tfrm_Principal;

implementation

{$R *.dfm}

uses U_Dados;

procedure Tfrm_Principal.btn_novoClick(Sender: TObject);
begin
  if not (fd_QueryCadastro.State in [dsEdit, dsInsert]) then
  begin
    fd_QueryCadastro.Insert;
  end;

end;

procedure Tfrm_Principal.btn_gravarClick(Sender: TObject);
begin
  if fd_QueryCadastro.State in [dsEdit, dsInsert] then
  begin
    fd_transaction.StartTransaction;
    fd_QueryCadastro.Post;
    fd_transaction.CommitRetaining;
  end;
end;

procedure Tfrm_Principal.btn_sairClick(Sender: TObject);
begin
    Self.Close;
end;

procedure Tfrm_Principal.FormCreate(Sender: TObject);
begin
  fd_QueryCadastro.Open()
end;

procedure Tfrm_Principal.btn_cancelarClick(Sender: TObject);
  begin
    if fd_QueryCadastro.State in [dsEdit, dsInsert] then
      begin
        fd_QueryCadastro.Cancel;
        fd_transaction.RollbackRetaining;
      end;
  end;

procedure Tfrm_Principal.btn_excluirClick(Sender: TObject);
  begin
    fd_QueryCadastro.Edit;
    fd_QueryCadastro.FieldByName('DT_EXCLUIDO').AsDateTime := Date;
    fd_transaction.StartTransaction;
    fd_QueryCadastro.Post;
    fd_transaction.CommitRetaining;
  end;
end.
