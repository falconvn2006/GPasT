unit uGridRegistro;

interface

uses
{(*}
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Data.DB,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  uCadastroRegistro,
  DM.Main,
  uRelCaixa,
  Controle.Caixa.Controller.Manager,
  Controle.Caixa.Controller.Manager.Interfaces,
  Manager.Types, Fnc_Utils;
{*)}

type
  TFrmGridRegistro = class(TForm)
    PanelMenu: TPanel;
    DTInicio: TDateTimePicker;
    LblPeriodo: TLabel;
    DTFim: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    DSGrid: TDataSource;
    CBTipo: TComboBox;
    PanelBackground: TPanel;
    PanelWrap: TPanel;
    PanelTop: TPanel;
    LblTitle: TLabel;
    BtnFechar: TSpeedButton;
    PanelBody: TPanel;
    DBGRegistros: TDBGrid;
    Panel3: TPanel;
    PanelFooter: TPanel;
    Label3: TLabel;
    Panel5: TPanel;
    ContainerDTInicio: TPanel;
    Panel2: TPanel;
    ContainerDTFim: TPanel;
    Panel4: TPanel;
    ContainerCBTipo: TPanel;
    Panel6: TPanel;
    ContainerBtnBuscar: TPanel;
    BtnBuscar: TSpeedButton;
    ContainerBtnRelatorio: TPanel;
    BtnRelatorio: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnBuscarClick(Sender: TObject);
    procedure BtnRelatorioClick(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGRegistrosDblClick(Sender: TObject);
    procedure DBGRegistrosDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    FControllerManager: iControllerManager;
    procedure PreencheCBTipo;
    procedure LoadRegistros(tTipoGrid: TtpCaixa = TODOS);
  public
    { Public declarations }
    pResult: Boolean;
    TypeRegistro: TtpCaixa;
  end;

var
  FrmGridRegistro: TFrmGridRegistro;

implementation

type
  TDBGDefault = class(TDBGrid);

{$R *.dfm}

procedure TFrmGridRegistro.BtnBuscarClick(Sender: TObject);
begin
  TypeRegistro := TConvert<TtpCaixa>.StrToEnum(CBTipo.Text);
  LoadRegistros(TypeRegistro);
end;

procedure TFrmGridRegistro.BtnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmGridRegistro.BtnRelatorioClick(Sender: TObject);
var
  RelCaixa: TFrmRelCaixa;
begin
  RelCaixa := TFrmRelCaixa.Create(nil);
  TypeRegistro := TConvert<TtpCaixa>.StrToEnum(CBTipo.Text);
  RelCaixa.PreviewType := TypeRegistro;
  RelCaixa.pDTInicio := DTInicio.DateTime;
  RelCaixa.pDTFim := DTFim.DateTime;
  RelCaixa.RelCaixa.Preview();

  TDBGDefault(DBGRegistros).DefaultRowHeight := 30;
  TDBGDefault(DBGRegistros).ClientHeight := (30 * TDBGDefault(DBGRegistros).RowCount) + 30;
end;

procedure TFrmGridRegistro.DBGRegistrosDblClick(Sender: TObject);
var
  pFormCad: TFrmCadastro;
begin
  if not DBGRegistros.DataSource.DataSet.IsEmpty then
  begin
    pFormCad := TFrmCadastro.Create(nil);
    pFormCad.idRegistro := DBGRegistros.DataSource.DataSet.FieldByName('ID').AsInteger;
    pFormCad.ShowModal;

    if pFormCad.pResult then
    begin
      LoadRegistros;
    end;

    pFormCad.Free;
  end;
end;

procedure TFrmGridRegistro.DBGRegistrosDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column.Title.Caption = 'TP. REGISTRO' then
    if Column.Field.AsBoolean then
      DBGRegistros.Canvas.TextRect(Rect, Rect.Left + 5, Rect.Top + 5, 'ENTRADA')
    else
      DBGRegistros.Canvas.TextRect(Rect, Rect.Left + 5, Rect.Top + 5, 'SAÍDA');
end;

procedure TFrmGridRegistro.LoadRegistros(tTipoGrid: TtpCaixa = TODOS);
begin
  FControllerManager.Caixa.FindAll.Where('DTENTRADA', tpFilterOperator.Between, FormatDateTime('yyyy-mm-dd', DTInicio.DateTime), FormatDateTime('yyyy-mm-dd', DTFim.DateTime));

  case tTipoGrid of
    TODOS:
      begin
      end;
    ENTRADA:
      FControllerManager.Caixa._And('ENTRADA', tpFilterOperator.Eq, '1');
    SAIDA:
      FControllerManager.Caixa._And('ENTRADA', tpFilterOperator.Eq, '0');
  end;

  DBGRegistros.DataSource := FControllerManager.Caixa.DataSource;
  TDBGDefault(DBGRegistros).DefaultRowHeight := 30;
  TDBGDefault(DBGRegistros).ClientHeight := (30 * TDBGDefault(DBGRegistros).RowCount) + 30;
end;

procedure TFrmGridRegistro.FormCreate(Sender: TObject);
var
  dateInicio: TDate;
begin
  FControllerManager := TControllerManager.New;
  PreencheCBTipo;
  CBTipo.ItemIndex := 0;

  dateInicio := StrToDate('01' + FormatDateTime('/mm/yyyy', Date));
  DTInicio.DateTime := dateInicio;
  DTFim.DateTime := Date;
end;

procedure TFrmGridRegistro.FormShow(Sender: TObject);
begin
  LoadRegistros;
end;

procedure TFrmGridRegistro.PreencheCBTipo;
var
  iCaixa: TConvert<TtpCaixa>;
begin
  CBTipo.Items.Clear;
  iCaixa.PopulateListEnum(CBTipo.Items);
end;

end.

