unit GIBMain_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CategoryButtons, ExtCtrls, RzPanel, ComCtrls, ActnList,
  ImgList, GIB_DM, GIB_Type, StdActns, DB, Grids, DBGrids, Buttons, DbClient;

type
  Tfrm_GCBMain = class(TForm)
    Pan_Client: TRzPanel;
    CategoryButtons1: TCategoryButtons;
    Gbx_Base: TGroupBox;
    Gbx_Progress: TGroupBox;
    Pan_ProgressTop: TRzPanel;
    Pan_ProgressClient: TRzPanel;
    Lab_Etat: TLabel;
    Lab_Total: TLabel;
    mmLogs: TMemo;
    Lab_Source: TLabel;
    Lab_Destination: TLabel;
    pg_Total: TProgressBar;
    Lab_SourceDir: TLabel;
    Lab_DestinationDir: TLabel;
    Lab_EtatText: TLabel;
    ActLst_Main: TActionList;
    Lim_Main: TImageList;
    Ax_DoSelectSource: TAction;
    Ax_DoSelectDestination: TAction;
    Ax_DoExecProcess: TAction;
    OD_DbFile: TOpenDialog;
    Nbt_FillCbo: TBitBtn;
    ComboBox1: TComboBox;
    Ds_: TDataSource;
    DBGrid1: TDBGrid;
    Splitter1: TSplitter;
    procedure CategoryButtons1CategoryCollapase(Sender: TObject;
      const Category: TButtonCategory);
    procedure Ax_DoSelectSourceExecute(Sender: TObject);
    procedure Ax_DoSelectDestinationExecute(Sender: TObject);
    procedure Ax_DoExecProcessExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Nbt_FillCboClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Déclarations privées }
    function CheckData : Boolean;
  public
    { Déclarations publiques }
  end;

var
  frm_GCBMain: Tfrm_GCBMain;

implementation

{$R *.dfm}

procedure Tfrm_GCBMain.Ax_DoExecProcessExecute(Sender: TObject);
begin
  If CheckData then
  begin
    DM_GIB.DoExecuteProcess(Lab_SourceDir.Caption);
  end
  else
end;

procedure Tfrm_GCBMain.Ax_DoSelectDestinationExecute(Sender: TObject);
begin
  OD_DbFile.Title := 'Sélectionner la base de données destination';
  if OD_DbFile.Execute then
  begin
    Lab_DestinationDir.Caption := OD_DbFile.FileName;
    Lab_DestinationDir.Hint := OD_DbFile.FileName;
  end;

end;

procedure Tfrm_GCBMain.Ax_DoSelectSourceExecute(Sender: TObject);
var
  bf : TBrowseForFolder;
begin
  bf := TBrowseForFolder.Create(Self);
  try
    bf.Caption := 'Sélectionner le répertoire source';
    bf.BrowseOptions := [bifNoTranslateTargets,bifNewDialogStyle];
    if Lab_SourceDir.Caption <> '...' then
      bf.Folder := Lab_SourceDir.Caption;

    if bf.Execute then
      Lab_SourceDir.Caption := bf.Folder;
  finally
    bf.Free;
  end;
end;

procedure Tfrm_GCBMain.CategoryButtons1CategoryCollapase(Sender: TObject;
  const Category: TButtonCategory);
begin
  Category.Collapsed := False;
end;

function Tfrm_GCBMain.CheckData: Boolean;
begin
  Result := False;
  if (trim(Lab_SourceDir.Caption) = '') or (Lab_SourceDir.Caption = '...') then
  begin
    ShowMessage('Veuillez sélectionner unrépertoire source');
    Exit;
  end;

  if (trim(Lab_DestinationDir.Caption) = '') or (Lab_DestinationDir.Caption = '...') then
  begin
    ShowMessage('Veuillez sélectionner une base de données destination');
    Exit;
  end;

  With DM_GIB do
  begin
    if not ConnectToDb(IBODDestination,Lab_DestinationDir.Caption) then
      Exit;
  end;

  Result := True;
end;

procedure Tfrm_GCBMain.ComboBox1Change(Sender: TObject);
begin
  ds_.DataSet := TClientDataset(combobox1.Items.Objects[combobox1.ItemIndex]);
end;

procedure Tfrm_GCBMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DM_GIB.Free;
end;

procedure Tfrm_GCBMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not InProgress;
end;

procedure Tfrm_GCBMain.FormCreate(Sender: TObject);
begin
  DM_GIB := TDM_GIB.Create(Self);
  DM_GIB.LabelEtat := Lab_EtatText;
  DM_GIB.ProgressBar := pg_Total;
  DM_GIB.Memo := mmLogs;

  InProgress := False;
end;

procedure Tfrm_GCBMain.Nbt_FillCboClick(Sender: TObject);
var
  i: Integer;
begin
  ComboBox1.Clear;
  With DM_GIB do
  begin
    for i := 0 to ComponentCount -1 do
      if Components[i] Is TClientDataset then
        ComboBox1.AddItem(Components[i].Name,TclientDataset(Components[i]));
  end;
end;

end.
