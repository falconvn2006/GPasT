unit uFrmCadPadrao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.Grids, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, ppDesignLayer, ppParameter, ppDB,
  ppBands, ppCtrls, ppVar, ppPrnabl, ppClass, ppCache, ppProd, ppReport, ppComm,
  ppRelatv, ppDBPipe, Vcl.Menus, RxDBCtrl, Vcl.DBGrids;

type
  TFrmCadPadrao = class(TFrmPadrao)
    PanelBotoes: TPanel;
    PanelFiltro: TPanel;
    PanelGrid: TPanel;
    GridDados: TRxDBGrid;
    PanelAdd: TPanel;
    ImgAdd: TImage;
    PanelEdit: TPanel;
    PanelExc: TPanel;
    PanelSair: TPanel;
    ImgEdit: TImage;
    ImgExc: TImage;
    ImgSair: TImage;
    dsDados: TDataSource;
    PanelExportar: TPanel;
    ImgExportar: TImage;
    procedure ImgAddMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgAddMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgAddMouseLeave(Sender: TObject);
    procedure ImgEditMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgExcMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgSairMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgEditMouseLeave(Sender: TObject);
    procedure ImgExcMouseLeave(Sender: TObject);
    procedure ImgSairMouseLeave(Sender: TObject);
    procedure ImgEditMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgExcMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgSairMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImgAddClick(Sender: TObject);
    procedure ImgEditClick(Sender: TObject);
    procedure ImgExcClick(Sender: TObject);
    procedure GridDadosDblClick(Sender: TObject);
    procedure AtualizaDadosGrid(Sender : TObject); Virtual; Abstract;
    procedure GridDadosTitleClick(Column: TColumn);
    procedure ImgExportarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgExportarMouseLeave(Sender: TObject);
    procedure ImgExportarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgExportarClick(Sender: TObject);
  private
    { Private declarations }
  protected
    sTabSheetPadrao : TTabSheet;
  public
    { Public declarations }
    sPeriodoLetivo : String;
    procedure ChamaMnt; Virtual; Abstract;
    procedure ProcessaExportacao; Virtual;

  end;

var
  FrmCadPadrao: TFrmCadPadrao;

implementation

{$R *.dfm}

uses uFrmPrincipal, F_Funcao;

procedure TFrmCadPadrao.ImgExcClick(Sender: TObject);
begin
  inherited;
  if not dsDados.DataSet.IsEmpty then
  begin
    Botao := btExcluir;
  end
  else
    F_Funcao.TMens.Aviso('Não existem dados para Exclusão.', True);
end;

procedure TFrmCadPadrao.ImgExcMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  PanelExc.Color := $009F9F9F; //clAqua;
end;

procedure TFrmCadPadrao.ImgExcMouseLeave(Sender: TObject);
begin
  inherited;
  PanelExc.Color := clBtnFace; //clLime;
end;

procedure TFrmCadPadrao.ImgExcMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  PanelExc.Color := $00CDCDCD; //clGreen;
end;

procedure TFrmCadPadrao.ImgExportarClick(Sender: TObject);
begin
  inherited;
  if not dsDados.DataSet.IsEmpty then
  begin
    Botao := btBrowser;
  end
  else
    F_Funcao.TMens.Aviso('Não existem dados para Exportação.', True);

  //sPeriodoLetivo := FrmEscolaPeriodoLetivo.RetornaListaSelecionada;
  if Trim(sPeriodoLetivo) <> EmptyStr then
    ProcessaExportacao;
end;

procedure TFrmCadPadrao.ImgExportarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  PanelExportar.Color := $009F9F9F; //clAqua;
end;

procedure TFrmCadPadrao.ImgExportarMouseLeave(Sender: TObject);
begin
  inherited;
  PanelExportar.Color := clBtnFace; //clLime;
end;

procedure TFrmCadPadrao.ImgExportarMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  PanelExportar.Color := $00CDCDCD; //clGreen;
end;

procedure TFrmCadPadrao.ImgSairClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmCadPadrao.ImgSairMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  PanelSair.Color := $009F9F9F; //clAqua;
end;

procedure TFrmCadPadrao.ImgSairMouseLeave(Sender: TObject);
begin
  inherited;
  PanelSair.Color := clBtnFace; //clLime;
end;

procedure TFrmCadPadrao.ImgSairMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  PanelSair.Color := $00CDCDCD; //clGreen;
end;

procedure TFrmCadPadrao.ProcessaExportacao;
begin

end;

procedure TFrmCadPadrao.FormShow(Sender: TObject);
begin
  inherited;
  AtualizaDadosGrid(Sender);
end;

procedure TFrmCadPadrao.GridDadosDblClick(Sender: TObject);
begin
  inherited;
  ImgEditClick(ImgEdit);
end;

procedure TFrmCadPadrao.GridDadosTitleClick(Column: TColumn);
var
   i: Integer;
   sqlOrigem : String;
begin
  try
    with TFDQuery(GridDados.DataSource.DataSet) do // the DBGrid's query component (a [NexusDB] TnxQuery)
    begin
      sqlOrigem := SQL.Text;
      DisableControls;
      if Active then Close;

      if (Pos('order by', LowerCase(SQL.Text)) > 0) then
      begin
        if (Pos(' desc ',LowerCase(Copy(SQL.Text,Pos('order by', LowerCase(SQL.Text))-1))) > 0) then
          SQL.Text := Copy(SQL.Text,1,Pos('order by', LowerCase(SQL.Text))-1)+
                     'ORDER BY '+Column.FieldName //newOrderBySQL
        else
          SQL.Text := Copy(SQL.Text,1,Pos('order by', LowerCase(SQL.Text))-1)+
                     'ORDER BY '+Column.FieldName +' desc ';
      end
      else
        SQL.Text := SQL.Text + 'ORDER BY '+Column.FieldName;

      // re-add params here if necessary
      if not Active then Open;
      EnableControls;
    end;
  except
    TFDQuery(GridDados.DataSource.DataSet).SQL.Text := sqlOrigem;
    if not TFDQuery(GridDados.DataSource.DataSet).Active then
      TFDQuery(GridDados.DataSource.DataSet).Open;
    TFDQuery(GridDados.DataSource.DataSet).EnableControls;
  end;
end;

procedure TFrmCadPadrao.ImgAddClick(Sender: TObject);
//var
//  sBookMark : TBookmark;
begin
//  if not dsDados.DataSet.IsEmpty then
//    sBookMark := dsDados.DataSet.Bookmark;

  inherited;
  Botao := btInserir;
  ChamaMnt;

  AtualizaDadosGrid(Sender);

//  if not dsDados.DataSet.IsEmpty then
//    dsDados.DataSet.Bookmark := sBookMark;
end;

procedure TFrmCadPadrao.ImgAddMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  PanelAdd.Color := $009F9F9F; //clAqua;
end;

procedure TFrmCadPadrao.ImgAddMouseLeave(Sender: TObject);
begin
  inherited;
  PanelAdd.Color := clBtnFace; //clLime;
end;

procedure TFrmCadPadrao.ImgAddMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  PanelAdd.Color := $00CDCDCD; //clGreen;
end;

procedure TFrmCadPadrao.ImgEditClick(Sender: TObject);
//var
//  sBookMark : TBookMark;
begin
//  sBookMark := dsDados.DataSet.Bookmark;
  inherited;
  if not dsDados.DataSet.IsEmpty then
  begin
    Botao := btAlterar;
    ChamaMnt;

    AtualizaDadosGrid(Sender);

//    dsDados.DataSet.Bookmark := sBookMark;
  end
  else
    MessageDlg('Não existem dados para Alteração.'+#13+msgErroAdm,mtInformation, [mbOk],0);
end;

procedure TFrmCadPadrao.ImgEditMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  PanelEdit.Color := $009F9F9F; //clAqua;
end;

procedure TFrmCadPadrao.ImgEditMouseLeave(Sender: TObject);
begin
  inherited;
  PanelEdit.Color := clBtnFace; //clLime;
end;

procedure TFrmCadPadrao.ImgEditMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  PanelEdit.Color := $00CDCDCD; //clGreen;
end;

end.
