unit Form_Detail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.ComCtrls, uTileCustom, Vcl.ImgList, uTile, uHistorical;

type
  TDetailForm = class(TForm)
    Pan_Header: TPanel;
    Img_AppIcon: TImage;
    Lab_AppCaption: TLabel;
    Btn_Close: TImage;
    ImageList1: TImageList;
    Splitter1: TSplitter;
    Panel1: TPanel;
    ListV_RawDatas: TListView;
    Panel2: TPanel;
    Lab_MasterCount: TLabel;
    Panel3: TPanel;
    ListView1: TListView;
    Panel4: TPanel;
    Lab_DetailCount: TLabel;
    Lab_MasterUpdated: TLabel;
    CheckBox2: TCheckBox;
    Lab_DetailPageCount: TLabel;
    procedure Btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListV_RawDatasChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ListV_RawDatasColumnClick(Sender: TObject; Column: TListColumn);
    { events }
    procedure OnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OnColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListV_RawDatasClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OnCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure CheckBox2Click(Sender: TObject);
  private
    { Déclarations privées }
    FTile: TTileCustom;
    FDetail: TArray< TTileDetail >;
    FHistorical: THistorical;
    SortedColumn: Integer;
    SortedListView: TListView;
    Descending: Boolean;
    procedure SortColumn(Sender: TObject; const Index: Integer = -1 );
  public
    { Déclarations publiques }
    procedure OnDetailChange(const Tile: TTileCustom; const Response: TResponse);
    procedure UpdateRawDatas;
    property Tile: TTileCustom read FTile write FTile;
  end;

var
  DetailForm: TDetailForm;

implementation

uses
  System.Math, uTypes, Form_Main, System.DateUtils, System.StrUtils;

{$R *.dfm}

procedure TDetailForm.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TDetailForm.CheckBox2Click(Sender: TObject);
begin
  FTile.Enabled := CheckBox2.Checked;
end;

procedure TDetailForm.FormCreate(Sender: TObject);
var
  ListColumn: TListColumn;
begin
  if Assigned( Vcl.Forms.Application.MainForm ) then
    case Vcl.Forms.Application.MainForm.WindowState of
      TWindowState.wsNormal: BoundsRect := Vcl.Forms.Application.MainForm.BoundsRect;
      TWindowState.wsMinimized, Twindowstate.wsMaximized: WindowState := Vcl.Forms.Application.MainForm.WindowState;
    end;

  SortedColumn := 0;
  SortedListView := nil;
  Descending := False;
end;

procedure TDetailForm.FormDestroy(Sender: TObject);
begin
  FHistorical.Free;
end;

procedure TDetailForm.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  Lab_DetailCount.Caption := Format( 'Count: %d', [ ListView1.GetCount ] );
end;

procedure TDetailForm.ListV_RawDatasChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  ListItem: TListItem;
  Value: THistoricalDetail;
begin
  if not ( Assigned( Sender ) or ( Sender is TListView )) then
    Exit;
  if TListView( Sender ).SelCount < 1 then
    Exit;


  if Assigned( FHistorical ) then
    FHistorical.Free;

  FHistorical := THistorical.Get( MainForm.Uid, ListV_RawDatas.Items[ ListV_RawDatas.Selected.Index ].Caption );
  try
    if not Assigned( FHistorical ) then
      Exit;

    Lab_DetailPageCount.Caption := IfThen(
      Length( FHistorical.Values ) = 0,
      '0',
      IfThen(
        FHistorical.Count div Length( FHistorical.Values ) = 1,
        '1',
        Format( '1..%d', [ FHistorical.Count div Length( FHistorical.Values ) ] )
      )
    );
    ListView1.Items.BeginUpdate;
    ListView1.Clear;
    try
      for Value in FHistorical.Values do begin
        ListItem := ListView1.Items.Insert( 0 );
        ListItem.ImageIndex := -1;
        ListItem.Caption := Value.FDate;
        ListItem.SubItems.Add( Value.FVal );
        ListItem.SubItems.Add( Value.FLvl );
      end;
      Descending := False;
      SortColumn( ListView1, 0 );
    finally
      ListView1.Items.EndUpdate;
    end;
  finally
//    FHistorical.Free;
  end;


  Lab_MasterCount.Caption := Format( 'Count: %d', [ ListV_RawDatas.GetCount ] );
end;

procedure TDetailForm.ListV_RawDatasClick(Sender: TObject);
var
  ListItem: TListItem;
  Value: THistoricalDetail;
begin
//  if not ( Assigned( Sender ) or ( Sender is TListView )) then
//    Exit;
//  if TListView( Sender ).SelCount < 1 then
//    Exit;
//
//
//  if Assigned( FHistorical ) then
//    FHistorical.Free;
//
//  FHistorical := THistorical.Get( MainForm.Uid, ListV_RawDatas.Items[ ListV_RawDatas.Selected.Index ].Caption );
//  try
//    if not Assigned( FHistorical ) then
//      Exit;
//
//    Lab_DetailPageCount.Caption := IfThen(
//      Length( FHistorical.Values ) = 0,
//      '0',
//      IfThen(
//        FHistorical.Count div Length( FHistorical.Values ) = 1,
//        '1',
//        Format( '1..%d', [ FHistorical.Count div Length( FHistorical.Values ) ] )
//      )
//    );
//    ListView1.Items.BeginUpdate;
//    ListView1.Clear;
//    try
//      for Value in FHistorical.Values do begin
//        ListItem := ListView1.Items.Insert( 0 );
//        ListItem.ImageIndex := -1;
//        ListItem.Caption := Value.FDate;
//        ListItem.SubItems.Add( Value.FVal );
//        ListItem.SubItems.Add( Value.FLvl );
//      end;
//      Descending := False;
//      SortColumn( ListView1, 0 );
//    finally
//      ListView1.Items.EndUpdate;
//    end;
//  finally
////    FHistorical.Free;
//  end;
end;

procedure TDetailForm.ListV_RawDatasColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  SortColumn( Sender, Column.Index );
end;

procedure TDetailForm.OnCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if not( Sender is TListView ) then
    Exit;

  if SortedColumn < 0 then
    Exit;

  case SortedColumn of
    0: if Sender = ListV_RawDatas then
         Compare := CompareValue( Item1.Caption.ToInteger, Item2.Caption.ToInteger ) { logid is integer }
       else
         Compare := CompareDateTime( StrToDateTime( Item1.Caption ), StrToDateTime( Item2.Caption ) ); { date is datetime }
    else begin
      if CompareText( Item1.SubItems[ SortedColumn - 1 ], Item2.SubItems[ SortedColumn  - 1 ] ) > 0 then
         Compare := 1
      else
        if CompareText( Item1.SubItems[ SortedColumn - 1 ], Item2.SubItems[ SortedColumn  - 1 ] ) < 0 then
          Compare := -1
        else
          Compare := 0;
    end;
  end;

  if Descending then
    Compare := - Compare;
end;

procedure TDetailForm.OnColumnClick(Sender: TObject; Column: TListColumn);
begin
  SortColumn( Sender, Column.Index );
end;

procedure TDetailForm.OnDetailChange(const Tile: TTileCustom;
  const Response: TResponse);
begin
  Lab_MasterUpdated.Caption := DateTimeToStr( Now );
  FDetail := TResponseDetail( Response ).FValues;
  UpdateRawDatas;
end;

procedure TDetailForm.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Close;
  end;
end;

procedure TDetailForm.SortColumn(Sender: TObject; const Index: Integer);
var
  i: Integer;
begin
  { guard clause }
  if not ( Sender is TListView ) then
    Exit;

  TListView( Sender ).Items.BeginUpdate;
  TListView( Sender ).Columns.BeginUpdate;
  try
    { clear }
    TListView( Sender ).SortType := TSortType.stNone;
    for i := 0 to TListView( Sender ).Columns.Count - 1 do
      TListView( Sender ).Columns[ i ].ImageIndex := -1;
    { guard clause }
    if Index < 0 then
      Exit;
    { sort }
    if ( Index = SortedColumn) and ( SortedListView = TListView( Sender ) ) then
      Descending := not Descending
    else begin
      SortedColumn := Index;
      Descending := True;
    end;
    TListView( Sender ).SortType := TSortType.stText;
    if Descending then
      TListView( Sender ).Columns[ Index ].ImageIndex := 1
    else
      TListView( Sender ).Columns[ Index ].ImageIndex := 0;

    SortedListView := TListView( Sender );

  finally
    TListView( Sender ).Columns.EndUpdate;
    TListView( Sender ).Items.EndUpdate;
  end;
end;

procedure TDetailForm.UpdateRawDatas;
var
  TileDetail: TTileDetail;
  ListItem: TListItem;
  i: Integer;
begin
  ListV_RawDatas.Hide;
  ListV_RawDatas.Items.BeginUpdate;
  try
    ListV_RawDatas.Items.Clear;
    for TileDetail in FDetail do begin
      ListItem := ListV_RawDatas.Items.Insert( 0 );
      ListItem.ImageIndex := -1;
      ListItem.Caption := TileDetail.Logid;
      ListItem.SubItems.Add( TileDetail.Hostname );
      ListItem.SubItems.Add( TileDetail.Application );
      ListItem.SubItems.Add( TileDetail.Instance );
      ListItem.SubItems.Add( TileDetail.Server );
      ListItem.SubItems.Add( TileDetail.Module );
      ListItem.SubItems.Add( TileDetail.Dossier );
      ListItem.SubItems.Add( TileDetail.Reference );
      ListItem.SubItems.Add( TileDetail.Key );
      ListItem.SubItems.Add( TileDetail.Value );
      ListItem.SubItems.Add( TileColorToString( TileDetail.Color ) );
    end;
    Descending := False;
    SortColumn( ListV_RawDatas, SortedColumn );
  finally
    ListV_RawDatas.Items.EndUpdate;
    ListV_RawDatas.Show;
  end;
end;

end.

{
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  RttiProperty: TRttiProperty;
begin
  RttiType := RttiContext.GetType( TTileDetail );
  ListV_Detail.Columns.BeginUpdate;
  for RttiProperty in RttiType.GetProperties do begin
    ListColumn := ListV_Detail.Columns.Add;
    ListColumn.Caption := RttiProperty.Name;
    ListColumn.AutoSize := True;
    ListColumn.Width := 100;
  end;
  ListV_Detail.Columns.EndUpdate;
}