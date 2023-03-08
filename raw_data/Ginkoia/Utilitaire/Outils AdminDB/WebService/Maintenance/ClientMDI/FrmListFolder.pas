unit FrmListFolder;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, StdCtrls, Buttons, ExtCtrls, DB, DBCtrls, HTTPApp;

type
  TListFolderFrm = class(TCustomGinkoiaDlgFrm)
    LstBxFiles: TListBox;
    LstBxFolders: TListBox;
    Pan_1: TPanel;
    Lab_1: TLabel;
    pnlFolder: TPanel;
    pnlLames: TPanel;
    Lab_2: TLabel;
    Lab_3: TLabel;
    lblFolder: TLabel;
    DBLkupCmBxSRV: TDBLookupComboBox;
    DsSRV: TDataSource;
    procedure LstBxFoldersDblClick(Sender: TObject);
    procedure DBLkupCmBxSRVCloseUp(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lblFolderMouseEnter(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FIsExcludeLame: Boolean;
    FITEMPATHBROWSER: String;
    procedure LoadListFolder;
    function GetFileNameSelected: String;
    procedure SetIsExcludeLame(const Value: Boolean);
  public
    property AITEMPATHBROWSER: String read FITEMPATHBROWSER write FITEMPATHBROWSER;
    property IsExcludeLame: Boolean read FIsExcludeLame write SetIsExcludeLame;
    property FileNameSelected: String read GetFileNameSelected;
  end;

var
  ListFolderFrm: TListFolderFrm;

implementation

uses dmdClients, uConst, u_Parser;

{$R *.dfm}

procedure TListFolderFrm.DBLkupCmBxSRVCloseUp(Sender: TObject);
begin
  inherited;
  lblFolder.Caption:= '';
  LstBxFolders.Clear;
  LstBxFiles.Clear;
  LoadListFolder;
end;

procedure TListFolderFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  if (ModalResult = mrOk) and (Pos('.', FileNameSelected) = 0) then
    CanClose:= False;
end;

procedure TListFolderFrm.FormCreate(Sender: TObject);
begin
  inherited;
  FIsExcludeLame:= False;
end;

procedure TListFolderFrm.FormShow(Sender: TObject);
begin
  inherited;
  if FIsExcludeLame then
    LoadListFolder;
end;

function TListFolderFrm.GetFileNameSelected: String;
var
  Buffer, Buffer2: String;
begin
  Result:= '';

  if lblFolder.Caption = '' then
    Exit;

  Buffer:= ExcludeTrailingBackslash(lblFolder.Caption);

  if LstBxFolders.ItemIndex <> -1 then
    begin
      Buffer2:= LstBxFolders.Items.Strings[LstBxFolders.ItemIndex];
      if (Buffer[Length(Buffer)] <> '\') and (Buffer2[Length(Buffer2)] <> '\') then
        Buffer:= IncludeTrailingBackslash(Buffer);
      Buffer:= Buffer + LstBxFolders.Items.Strings[LstBxFolders.ItemIndex];
    end;

  if LstBxFiles.ItemIndex <> -1 then
    begin
      Buffer2:= LstBxFiles.Items.Strings[LstBxFiles.ItemIndex];
      if (Buffer[Length(Buffer)] <> '\') and (Buffer2[Length(Buffer2)] <> '\') then
        Buffer:= IncludeTrailingBackslash(Buffer);
      Buffer:= Buffer + LstBxFiles.Items.Strings[LstBxFiles.ItemIndex];
    end;

  if (DBLkupCmBxSRV.Text <> '') and (DBLkupCmBxSRV.Text <> 'LOCALHOST') then
    Buffer:= DBLkupCmBxSRV.Text + ':' + Buffer;

  if UpperCase(ExtractFileExt(Buffer)) = '.IB' then
    Result:= Buffer;
end;

procedure TListFolderFrm.lblFolderMouseEnter(Sender: TObject);
begin
  inherited;
  lblFolder.Hint:= lblFolder.caption;
end;

procedure TListFolderFrm.LoadListFolder;
var
  vSLFolder, vSLFile: TStringList;
  Buffer, vPathFiles, vLame: String;
begin
  inherited;
  vLame:= '';
  vSLFolder:= TStringList.Create;
  vSLFile:= TStringList.Create;
  try
    LstBxFiles.Clear;

    if (not VarIsNull(DBLkupCmBxSRV.KeyValue)) and (not FIsExcludeLame) then
      vLame:= DsSRV.DataSet.FieldByName('SERV_NOM').AsString;

    if LstBxFolders.ItemIndex <> -1 then
      Buffer:= LstBxFolders.Items.Strings[LstBxFolders.ItemIndex];

    if (lblFolder.Caption <> '') and (Buffer <> '') then
      begin
        if (Buffer[1] = '\') and (lblFolder.Caption[Length(lblFolder.Caption)] = '\') then
          lblFolder.Caption:= ExcludeTrailingBackslash(lblFolder.Caption);

        if (Buffer[1] <> '\') and (lblFolder.Caption[Length(lblFolder.Caption)] <> '\') then
          lblFolder.Caption:= lblFolder.Caption  + '\';
      end;

    dmClients.XmlToList('ListFolder?LAME=' + vLame +
                        '&FOLDER=' +  HTTPEncode(lblFolder.Caption + Buffer) +
                        '&ITEMPATHBROWSER=' + FITEMPATHBROWSER, cBlsResult, '', vSLFolder, Self, False);

    if vSLFolder.Count <> 0 then
      begin
        LstBxFolders.Items.Text:= vSLFolder.Text;
        lblFolder.Caption:= LstBxFolders.Items.Strings[0];
        LstBxFolders.Items.Strings[0]:= '\..';
      end;

    if lblFolder.Caption <> '' then
      begin
        vPathFiles:= lblFolder.Caption + Buffer;
        if vSLFolder.Count <> 0 then
          vPathFiles:= ExcludeTrailingBackslash(lblFolder.Caption);

        dmClients.XmlToList('ListFile?LAME=' + vLame +
                            '&FOLDER=' + HTTPEncode(vPathFiles), cBlsResult, '', vSLFile, Self, False);

        if vSLFile.Count <> 0 then
          LstBxFiles.Items.Text:= vSLFile.Text;
      end;

  finally
    FreeAndNil(vSLFolder);
    FreeAndNil(vSLFile);
  end;
end;

procedure TListFolderFrm.LstBxFoldersDblClick(Sender: TObject);
begin
  inherited;
  LoadListFolder;
end;

procedure TListFolderFrm.SetIsExcludeLame(const Value: Boolean);
begin
  FIsExcludeLame := Value;
  pnlLames.Visible:= not FIsExcludeLame;
end;

end.
