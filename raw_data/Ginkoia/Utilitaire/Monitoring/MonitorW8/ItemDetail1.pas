unit ItemDetail1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, System.Actions, Vcl.ActnList,
  Vcl.Styles, Vcl.Themes, Vcl.Touch.GestureMgr, Vcl.Grids, Vcl.DBGrids,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,
  cxImageComboBox, Vcl.ImgList;

type
  TDetailForm = class(TForm)
    Panel1: TPanel;
    TitleLabel: TLabel;
    Image1: TImage;
    AppBar: TPanel;
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    Action1: TAction;
    CloseButton: TImage;
    GridPanel1: TGridPanel;
    ScrollBox2: TScrollBox;
    DataSource1: TDataSource;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDQuery1log_id: TLargeintField;
    FDQuery1log_date: TDateTimeField;
    FDQuery1log_update: TSQLTimeStampField;
    FDQuery1log_remoteip: TStringField;
    FDQuery1log_host: TStringField;
    FDQuery1log_app: TStringField;
    FDQuery1log_inst: TStringField;
    FDQuery1log_srv: TStringField;
    FDQuery1log_mdl: TStringField;
    FDQuery1log_dos: TStringField;
    FDQuery1log_ref: TStringField;
    FDQuery1log_key: TStringField;
    FDQuery1log_val: TStringField;
    FDQuery1log_nb: TSmallintField;
    FDQuery1log_lvl: TSmallintField;
    FDQuery1log_hdl: TLargeintField;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDQuery2: TFDQuery;
    DataSource2: TDataSource;
    FDQuery2val_id: TLargeintField;
    FDQuery2val_logid: TLargeintField;
    FDQuery2val_remoteip: TStringField;
    FDQuery2val_date: TDateTimeField;
    FDQuery2val_val: TStringField;
    FDQuery2val_nb: TIntegerField;
    FDQuery2val_lvl: TIntegerField;
    FDQuery2val_ovl: TLargeintField;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1log_id: TcxGridDBColumn;
    cxGrid1DBTableView1log_date: TcxGridDBColumn;
    cxGrid1DBTableView1log_update: TcxGridDBColumn;
    cxGrid1DBTableView1log_remoteip: TcxGridDBColumn;
    cxGrid1DBTableView1log_host: TcxGridDBColumn;
    cxGrid1DBTableView1log_app: TcxGridDBColumn;
    cxGrid1DBTableView1log_inst: TcxGridDBColumn;
    cxGrid1DBTableView1log_srv: TcxGridDBColumn;
    cxGrid1DBTableView1log_mdl: TcxGridDBColumn;
    cxGrid1DBTableView1log_dos: TcxGridDBColumn;
    cxGrid1DBTableView1log_ref: TcxGridDBColumn;
    cxGrid1DBTableView1log_key: TcxGridDBColumn;
    cxGrid1DBTableView1log_val: TcxGridDBColumn;
    cxGrid1DBTableView1log_nb: TcxGridDBColumn;
    cxGrid1DBTableView1log_lvl: TcxGridDBColumn;
    cxGrid1DBTableView1log_hdl: TcxGridDBColumn;
    cxGrid2: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxGridDBTableView1val_id: TcxGridDBColumn;
    cxGridDBTableView1val_logid: TcxGridDBColumn;
    cxGridDBTableView1val_remoteip: TcxGridDBColumn;
    cxGridDBTableView1val_date: TcxGridDBColumn;
    cxGridDBTableView1val_val: TcxGridDBColumn;
    cxGridDBTableView1val_nb: TcxGridDBColumn;
    cxGridDBTableView1val_lvl: TcxGridDBColumn;
    cxGridDBTableView1val_ovl: TcxGridDBColumn;
    Splitter1: TSplitter;
    cxImageList1: TcxImageList;
    cxStyle2: TcxStyle;
    procedure BackToMainForm(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure DBAdvGrid1CanSort(Sender: TObject; ACol: Integer;
      var DoSort: Boolean);
  private
    { Déclarations privées }
    procedure AppBarResize;
    procedure AppBarShow(mode: integer);
  public

    { Déclarations publiques }
  end;

var
  DetailForm: TDetailForm = nil;

implementation

{$R *.dfm}

uses GroupedItems1;

procedure TDetailForm.Action1Execute(Sender: TObject);
begin
  AppBarShow(-1);
end;

const
  AppBarHeight = 75;

procedure TDetailForm.AppBarResize;
begin
  AppBar.SetBounds(0, AppBar.Parent.Height - AppBarHeight,
    AppBar.Parent.Width, AppBarHeight);
end;

procedure TDetailForm.AppBarShow(mode: integer);
begin
  if mode = -1 then // Basculer
    mode := integer(not AppBar.Visible );

  if mode = 0 then
    AppBar.Visible := False
  else
  begin
    AppBar.Visible := True;
    AppBar.BringToFront;
  end;
end;

procedure TDetailForm.FormCreate(Sender: TObject);
var
  LStyle: TCustomStyleServices;
  MemoColor, MemoFontColor: TColor;
begin
  // Définir la couleur d'arrière-plan des mémos sur la couleur de la fiche, depuis le style actif.
  LStyle := TStyleManager.ActiveStyle;

  // Remplir l'image
end;

procedure TDetailForm.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  AppBarShow(0);
end;

procedure TDetailForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    AppBarShow(-1)
  else
    AppBarShow(0);
end;

procedure TDetailForm.FormResize(Sender: TObject);
begin
  AppBarResize;
end;

procedure TDetailForm.FormShow(Sender: TObject);
var
  GroupElements: TStringList;
  memoStr: String;
begin
  AppBarShow(0);
end;

procedure TDetailForm.BackToMainForm(Sender: TObject);
begin
  Hide;
  GridForm.BringToFront;
end;

procedure TDetailForm.DBAdvGrid1CanSort(Sender: TObject; ACol: Integer;
  var DoSort: Boolean);
begin
    dosort := acol > 0;
end;

end.
