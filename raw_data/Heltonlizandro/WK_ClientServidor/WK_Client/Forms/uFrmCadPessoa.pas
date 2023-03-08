unit uFrmCadPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmCadPadrao, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, ppDB, ppParameter, ppDesignLayer, ppBands,
  ppCtrls, ppVar, ppPrnabl, ppClass, ppCache, ppProd, ppReport, ppComm,
  ppRelatv, ppDBPipe, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, RxDBCtrl, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.StdCtrls, uTPessoa;

type
  TFrmCadPessoa = class(TFrmCadPadrao)
    Label1: TLabel;
    Label2: TLabel;
    EdtCodigo: TEdit;
    EdtNome: TEdit;
    procedure AtualizaDadosGrid(Sender : TObject); override;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ImgExcClick(Sender: TObject);
  private
    { Private declarations }
    oPessoa : TPessoa;
  public
    { Public declarations }
    procedure ChamaMnt; Override;
  end;

var
  FrmCadPessoa: TFrmCadPessoa;

implementation

{$R *.dfm}

uses uFrmPrincipal, uFrmMntPessoa;

{ TFrmCadPessoa }

procedure TFrmCadPessoa.AtualizaDadosGrid(Sender: TObject);
begin
  oPessoa.idpessoa   := StrToIntDef(EdtCodigo.Text,0);
  oPessoa.nmprimeiro := Trim(EdtNome.Text);
  oPessoa.CarregaDataSet(MemTable);
end;

procedure TFrmCadPessoa.ChamaMnt;
begin
  FrmMntPessoa.ChamaManutencao(dsDados.DataSet,Botao);
  inherited;
end;

procedure TFrmCadPessoa.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(oPessoa);
end;

procedure TFrmCadPessoa.ImgExcClick(Sender: TObject);
begin
  inherited;
  oPessoa.idpessoa := dsDados.DataSet.FieldByName('idpessoa').AsInteger;
  oPessoa.Excluir;
  AtualizaDadosGrid(Sender);
end;

procedure TFrmCadPessoa.FormCreate(Sender: TObject);
begin
  inherited;
  oPessoa := TPessoa.Create();
end;

end.
