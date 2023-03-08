unit GSDataUserActionSelect_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels, StrUtils,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue, cxGroupBox,
  ComCtrls, CommCtrl, StdCtrls, Buttons, DB, Generics.Collections, IBODataset,
  DBClient, Types;

type
  TMag = record
    FMagID: Integer;
    FMagEnseigne: String;
  end;

  TCustomerFile = record
    FCustomerFileID: Integer;
    FCustomerFileName: String;
    FCustomerFilePath: String;
    FMags: TList<TMag>;
  end;

  Tfrm_UserActionSelect = class(TForm)
    pan_Background: TPanel;
    pan_Bottom: TPanel;
    pan_Right: TPanel;
    pan_Main: TPanel;
    lbl_Infos: TLabel;
    Btn_Valider: TBitBtn;
    Btn_Annuler: TBitBtn;
    lv_ListeItems: TListView;
    cx_Processing: TcxGroupBox;
    cx_Files: TcxGroupBox;
    cx_Actions: TcxGroupBox;
    cbx_ActionExport: TCheckBox;
    rbtn_CustomStoreSelection: TRadioButton;
    rbtn_SelectEveryStore: TRadioButton;
    cxListItems: TcxGroupBox;
    procedure Btn_AnnulerClick(Sender: TObject);
    procedure Btn_ValiderClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCustomerFileIDs: TList<Integer>;
    FCustomerFileNames: TList<String>;
    FCustomerFilePaths: TList<String>;
    FMagIDs: TList<Integer>;
    FMagNames: TList<String>;
    FFileIDs: TList<Integer>;
    FFicIDs: TList<Integer>;
    FFicNames: TList<String>;
    FUserChoices: TList<TCustomerFile>;

    procedure FillingListView(AListOfMagsByCustomerFiles: TList<TCustomerFile>);
    procedure FillingListViewContent;
    procedure FillingListOfFiles;
    procedure FillingListViewHeaders;
    procedure CBX_FilesClick(Sender: TObject);
    function GetFicIDs(ASelectedFiles: TClientDataSet): TList<Integer>;
    function GetFicNames(ASelectedFiles: TClientDataSet): TList<String>;

  public
    constructor Create(AParentFrm : TForm; ACaption : string; AListOfMagsByCustomerFiles: TList<TCustomerFile>; ASelectedFiles: TClientDataSet);
    destructor Destroy;

    property FileIDs: TList<Integer> read FFileIDs;
    property UserChoices: TList<TCustomerFile> read FUserChoices;

  end;

var
  frm_UserActionSelect: Tfrm_UserActionSelect;

implementation

{$R *.dfm}

{ Tfrm_UserActionSelect }

procedure Tfrm_UserActionSelect.FillingListViewContent;
var
  vItem: TListItem;
  i, j : integer;
begin
  try
    if lv_ListeItems.Columns.Count > 0 then
    begin
      try
        try
          for i := 0 to Pred(FCustomerFileIDs.Count) do
          begin
            // ajout de l'item
            vItem := lv_ListeItems.Items.Add();
            vItem.Caption := FCustomerFileNames[i];
            for j := 1 to Pred(lv_ListeItems.Columns.Count) do
              vItem.SubItems.Add(FMagNames[i]);
            vItem.Data := Pointer(i);
          end;
        finally
        end;
      finally
      end;
      if (lv_ListeItems.Items.Count > 1) and (lv_ListeItems.Columns.Count = 1) then
      begin
        lv_ListeItems.SortType := stNone;
        lv_ListeItems.SortType := stBoth;
      end;

      // sélection par défaut !
      if lv_ListeItems.Items.Count > 0 then
        lv_ListeItems.ItemIndex := 0;
    end;
  finally
  end;
end;

procedure Tfrm_UserActionSelect.FillingListView(AListOfMagsByCustomerFiles: TList<TCustomerFile>);
var
  i, j: Integer;
begin
  FCustomerFileIDs.Clear;
  FCustomerFileNames.Clear;
  FCustomerFilePaths.Clear;
  FMagIDs.Clear;
  FMagNames.Clear;

  for i := 0 to Pred(AListOfMagsByCustomerFiles.Count) do
  begin
    for j := 0 to Pred(AListOfMagsByCustomerFiles[i].FMags.Count) do
    begin
      FCustomerFileIDs.Add(AListOfMagsByCustomerFiles[i].FCustomerFileID);
      FCustomerFileNames.Add(AListOfMagsByCustomerFiles[i].FCustomerFileName);
      FCustomerFilePaths.Add(AListOfMagsByCustomerFiles[i].FCustomerFilePath);
      FMagIDs.Add(AListOfMagsByCustomerFiles[i].FMags[j].FMagID);
      FMagNames.Add(AListOfMagsByCustomerFiles[i].FMags[j].FMagEnseigne);
    end;
  end;

  FillingListViewHeaders;
  FillingListViewContent;
end;

procedure Tfrm_UserActionSelect.FillingListViewHeaders;
var
  i: Integer;
  vHeaders: TStringList;
  vColonne: TListColumn;
begin
  vHeaders := TStringList.Create;
  try
    vHeaders.Add('Dossiers');
    vHeaders.Add('Magasins');

    for i := 0 to Pred(vHeaders.Count) do
    begin
      vColonne := lv_ListeItems.Columns.Add();
      vColonne.Caption := vHeaders[i];
      vColonne.AutoSize := True;
      lv_ListeItems.Columns[i].Width := LVSCW_AUTOSIZE;
    end;
  finally
    FreeAndNil(vHeaders);
  end;
end;

procedure Tfrm_UserActionSelect.FormShow(Sender: TObject);
begin
  rbtn_CustomStoreSelection.Checked := True;
end;

function Tfrm_UserActionSelect.GetFicIDs(ASelectedFiles: TClientDataSet): TList<Integer>;
begin
  Result := TList<Integer>.Create;

  ASelectedFiles.First;
  while not ASelectedFiles.Eof do
  begin
    Result.Add(ASelectedFiles.FieldByName('FIC_ID').AsInteger);
    ASelectedFiles.Next;
  end;
end;

function Tfrm_UserActionSelect.GetFicNames(ASelectedFiles: TClientDataSet): TList<String>;
begin
  Result := TList<String>.Create;

  ASelectedFiles.First;
  while not ASelectedFiles.Eof do
  begin
    Result.Add(ASelectedFiles.FieldByName('FIC_LIBELLE').AsString);
    ASelectedFiles.Next;
  end;
end;

procedure Tfrm_UserActionSelect.Btn_AnnulerClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure Tfrm_UserActionSelect.Btn_ValiderClick(Sender: TObject);
  function GetIndexCustomerFileID(const AUserChoices: TList<TCustomerFile>; const ASearchID: Integer): Integer;
  var
    i: Integer;
  begin
    Result := -1;

    for i := 0 to Pred(AUserChoices.Count) do
    begin
      if AUserChoices[i].FCustomerFileID = ASearchID then
      begin
        Result := i;
        Break;
      end;
    end;
  end;
var
  i, vCFIndex: Integer;
  vCustomerFile: TCustomerFile;
  vMag: TMag;
begin
  if FFileIDs.Count = 0 then
  begin
    MessageDlg('Au moins un fichier doit être sélectionné.', mtInformation, [mbOK], 0);
    Exit;
  end;

  if not Assigned(FUserChoices) then
    FUserChoices := TList<TCustomerFile>.Create;
  FUserChoices.Clear;
  if rbtn_SelectEveryStore.Checked then
  begin
    for i := 0 to Pred(lv_ListeItems.Items.Count) do
    begin
      vCustomerFile.FCustomerFileID := FCustomerFileIDs[Integer(lv_ListeItems.Items[i].Data)];
      vCustomerFile.FCustomerFileName := FCustomerFileNames[Integer(lv_ListeItems.Items[i].Data)];
      vCustomerFile.FCustomerFilePath := FCustomerFilePaths[Integer(lv_ListeItems.Items[i].Data)];
      if Assigned(vCustomerFile.FMags) then
        vCustomerFile.FMags := nil;
      vCustomerFile.FMags := TList<TMag>.Create;

      vMag.FMagID := FMagIDs[Integer(lv_ListeItems.Items[i].Data)];
      vMag.FMagEnseigne := FMagNames[Integer(lv_ListeItems.Items[i].Data)];

      vCFIndex := GetIndexCustomerFileID(FUserChoices, vCustomerFile.FCustomerFileID);
      if vCFIndex <> -1 then
      begin
        FUserChoices[vCFIndex].FMags.Add(vMag);
      end
      else
      begin
        vCustomerFile.FMags.Add(vMag);
        FUserChoices.Add(vCustomerFile);
      end;
    end;
  end
  else
  begin
    for i := 0 to Pred(lv_ListeItems.Items.Count) do
    begin
      if lv_ListeItems.Items[i].Selected then
      begin
        vCustomerFile.FCustomerFileID := FCustomerFileIDs[Integer(lv_ListeItems.Items[i].Data)];
        vCustomerFile.FCustomerFileName := FCustomerFileNames[Integer(lv_ListeItems.Items[i].Data)];
        vCustomerFile.FCustomerFilePath := FCustomerFilePaths[Integer(lv_ListeItems.Items[i].Data)];
        if Assigned(vCustomerFile.FMags) then
          vCustomerFile.FMags := nil;
        vCustomerFile.FMags := TList<TMag>.Create;

        vMag.FMagID := FMagIDs[Integer(lv_ListeItems.Items[i].Data)];
        vMag.FMagEnseigne := FMagNames[Integer(lv_ListeItems.Items[i].Data)];

        vCFIndex := GetIndexCustomerFileID(FUserChoices, vCustomerFile.FCustomerFileID);
        if vCFIndex <> -1 then
        begin
          FUserChoices[vCFIndex].FMags.Add(vMag);
        end
        else
        begin
          vCustomerFile.FMags.Add(vMag);
          FUserChoices.Add(vCustomerFile);
        end;
      end;
    end;
    if FUserChoices.Count = 0 then
    begin
      MessageDlg('Au moins un dossier/magasin doit être sélectionné.', mtInformation, [mbOK], 0);
      Exit;
    end;
  end;

  Close;
  ModalResult := mrOk;
end;

procedure Tfrm_UserActionSelect.CBX_FilesClick(Sender: TObject);
var
  vItem: TCheckBox;
  vIndex: Integer;
begin
  if (Sender is TCheckBox) then
  begin
    vItem := TCheckBox(Sender);

    vIndex := FFileIDs.IndexOf(vItem.Tag);
    if (vIndex >= 0) then
    begin
      if not vItem.Checked then
        FFileIDs.Delete(vIndex);
    end
    else
    begin
      if vItem.Checked then
        FFileIDs.Add(vItem.Tag);
    end;
  end;
end;

constructor Tfrm_UserActionSelect.Create(AParentFrm: TForm; ACaption: string; AListOfMagsByCustomerFiles: TList<TCustomerFile>; ASelectedFiles: TClientDataSet);
begin
  inherited Create(AParentFrm);
  Caption := ACaption;

  FCustomerFileIDs := TList<Integer>.Create;
  FCustomerFileNames := TList<String>.Create;
  FCustomerFilePaths := TList<String>.Create;
  FMagIDs := TList<Integer>.Create;
  FMagNames := TList<String>.Create;
  FFileIDs := TList<Integer>.Create;

  FillingListView(AListOfMagsByCustomerFiles);
  FFicIDs := GetFicIDs(ASelectedFiles);
  FFicNames := GetFicNames(ASelectedFiles);
  FillingListOfFiles;
end;

destructor Tfrm_UserActionSelect.Destroy;
begin
  if Assigned(FFileIDs) then
    FreeAndNil(FFileIDs);
end;

procedure Tfrm_UserActionSelect.FillingListOfFiles;
var
  i: Integer;
  vItem: TCheckBox;
begin
  for i := 0 to Pred(FFicIDs.Count) do
  begin
    // ajout de l'item
    if Assigned(vItem) then
      vItem := nil;
    vItem := TCheckBox.Create(Self);
    vItem.Parent := cx_Files;
    vItem.OnClick := CBX_FilesClick;
    vItem.AlignWithMargins := True;
    vItem.Margins.Left := 5;
    vItem.Margins.Right := 5;
    vItem.Align := alTop;
    vItem.Caption := FFicNames[i];
    vItem.Tag := FFicIDs[i];
    if FFicNames[i] = 'XICKET' then
      vItem.Checked := True;
  end;
end;

end.
