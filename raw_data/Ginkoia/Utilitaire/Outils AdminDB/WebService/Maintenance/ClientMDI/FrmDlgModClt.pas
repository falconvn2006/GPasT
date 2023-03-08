unit FrmDlgModClt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, StdCtrls, Buttons, ExtCtrls, DB, Mask, DBCtrls,
  dmdClient, ComCtrls, Grids, DBGrids;

type
  TDlgModCltFrm = class(TCustomGinkoiaDlgFrm)
    Lab_1: TLabel;
    DsModule: TDataSource;
    DBText1: TDBText;
    DateTimePickerExpiration: TDateTimePicker;
    Lab_2: TLabel;
    ListViewModDisp: TListView;
    DsMagasin: TDataSource;
    Stat_Module: TStatusBar;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListViewModDispEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure Stat_ModuleDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
  private
    FdmClient: TdmClient;
    procedure LoadModuleDispo;
  protected
    function PostValues: Boolean; override;
  public
    property AdmClient: TdmClient read FdmClient write FdmClient;
  end;

var
  DlgModCltFrm: TDlgModCltFrm;

implementation

uses
  dmdClients,
  uTool,
  FrmMain;

{$R *.dfm}

procedure TDlgModCltFrm.FormCreate(Sender: TObject);
var
  ProgressBarStyle: integer;
begin
  inherited;
  UseUpdateKind:= True;
  DateTimePickerExpiration.Date:= EncodeDate(2100, 01, 01);
//  FMOD_ID:= -1;

  //enable status bar 2nd Panel custom drawing
  Stat_Module.Panels[0].Style := psOwnerDraw;

  //place the progress bar into the status bar
  ProgressBar1.Parent := Stat_Module;

  //remove progress bar border
  ProgressBarStyle := GetWindowLong(ProgressBar1.Handle,
                                    GWL_EXSTYLE);
  ProgressBarStyle := ProgressBarStyle
                      - WS_EX_STATICEDGE;
  SetWindowLong(ProgressBar1.Handle,
                GWL_EXSTYLE,
                ProgressBarStyle);
end;

procedure TDlgModCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  DsMagasin.DataSet:= FdmClient.CDS_MAG;
  DsModule.DataSet:= FdmClient.CDSModuleActif;
  if AAction = ukModify then
    begin
      dmClients.XmlToDataSet('ModuleGinkoia?MAGA_MAGID_GINKOIA=' + FdmClient.CDS_MAG.FieldByName('MAGA_MAGID_GINKOIA').AsString +
                             '&DOSS_ID=' + FdmClient.CDS_MAG.FieldByName('DOSS_ID').AsString +
                             '&ALL=1', FdmClient.CDSModuleDisponible);
      DateTimePickerExpiration.Date:= FdmClient.CDSModuleActif.FieldByName('MMAG_EXPDATE').AsDateTime;
      LoadModuleDispo;
      ListViewModDisp.Selected:= ListViewModDisp.Items.Item[0];
    end
  else
    if AAction = ukInsert then
      begin
        dmClients.XmlToDataSet('ModuleGinkoia?MAGA_MAGID_GINKOIA=' + FdmClient.CDS_MAG.FieldByName('MAGA_MAGID_GINKOIA').AsString +
                               '&DOSS_ID=' + FdmClient.CDS_MAG.FieldByName('DOSS_ID').AsString, FdmClient.CDSModuleDisponible);
        LoadModuleDispo;
      end;
end;

procedure TDlgModCltFrm.ListViewModDispEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  inherited;
  AllowEdit:= False;
end;

procedure TDlgModCltFrm.LoadModuleDispo;
var
  vLstItem: TListItem;

  procedure AddToListeView;
  begin
    vLstItem:= ListViewModDisp.Items.Add;
    vLstItem.Caption:= FdmClient.CDSModuleDisponible.FieldByName('MODU_NOM').AsString;
    vLstItem.SubItems.Add(FdmClient.CDSModuleDisponible.FieldByName('MODU_ID').AsString);
    vLstItem.SubItems.Add(FdmClient.CDSModuleDisponible.FieldByName('UGG_ID').AsString);
    vLstItem.SubItems.Add(FdmClient.CDSModuleDisponible.FieldByName('UGM_MAGID').AsString);
  end;

begin
  ListViewModDisp.Clear;
  FdmClient.CDSModuleDisponible.First;
  while not FdmClient.CDSModuleDisponible.Eof do
    begin
      if AAction = ukModify then
        begin
          if FdmClient.CDSModuleDisponible.FieldByName('MODU_ID').AsInteger = FdmClient.CDSModuleActif.FieldByName('MODU_ID').AsInteger then
            begin
              AddToListeView;
              Break;
            end;
        end
      else
        AddToListeView;

      FdmClient.CDSModuleDisponible.Next;
    end;
end;

function TDlgModCltFrm.PostValues: Boolean;
var
  vLstItem: TListItem;
  I: Integer;

begin
  Result:= inherited PostValues;
  try
    try
      if AAction = ukModify then
      begin
        vLstItem:= ListViewModDisp.Items.Item[0];
        DsModule.DataSet.Edit;

        if vLstItem = nil then
          Raise Exception.Create('Vous devez choisir un module');

        FdmClient.CDSModuleActif.FieldByName('DOSS_ID').AsInteger:= FdmClient.CDS_MAG.FieldByName('DOSS_ID').AsInteger;
        FdmClient.CDSModuleActif.FieldByName('MAGA_ID').AsInteger:= FdmClient.CDS_MAG.FieldByName('MAGA_ID').AsInteger;
        FdmClient.CDSModuleActif.FieldByName('MAGA_NOM').AsString:= FdmClient.CDS_MAG.FieldByName('MAGA_NOM').AsString;
        FdmClient.CDSModuleActif.FieldByName('MODU_ID').AsInteger:= StrToInt(vLstItem.SubItems.Strings[0]);
        FdmClient.CDSModuleActif.FieldByName('MODU_NOM').AsString:= vLstItem.Caption;
        FdmClient.CDSModuleActif.FieldByName('MMAG_EXPDATE').AsDateTime:= DateTimePickerExpiration.Date;
        FdmClient.CDSModuleActif.FieldByName('UGG_ID').AsInteger:= StrToInt(vLstItem.SubItems.Strings[1]);
        FdmClient.CDSModuleActif.FieldByName('UGM_MAGID').AsInteger:= StrToInt(vLstItem.SubItems.Strings[2]);

        dmClients.PostRecordToXml('ModuleGinkoia', 'TModuleGinkoia', FdmClient.CDSModuleActif);
        FdmClient.CDSModuleActif.Post;

      end
      else
      begin
        vLstItem:= ListViewModDisp.Selected;

        if vLstItem = nil then
          Raise Exception.Create('Vous devez choisir un module');

        ProgressBar1.Position := 0;
        ProgressBar1.Max := ListViewModDisp.Items.Count - 1;

        for I := 0 to ListViewModDisp.Items.Count - 1 do    //SR : Correction pour la multi séléction
        begin
          ProgressBar1.Position := I;
          Application.ProcessMessages;

          if ListViewModDisp.Items.Item[I].Selected then
          begin
            DsModule.DataSet.Insert;

            vLstItem := ListViewModDisp.Items.Item[I];
            FdmClient.CDSModuleActif.FieldByName('DOSS_ID').AsInteger:= FdmClient.CDS_MAG.FieldByName('DOSS_ID').AsInteger;
            FdmClient.CDSModuleActif.FieldByName('MAGA_ID').AsInteger:= FdmClient.CDS_MAG.FieldByName('MAGA_ID').AsInteger;
            FdmClient.CDSModuleActif.FieldByName('MAGA_NOM').AsString:= FdmClient.CDS_MAG.FieldByName('MAGA_NOM').AsString;
            FdmClient.CDSModuleActif.FieldByName('MODU_ID').AsInteger:= StrToInt(vLstItem.SubItems.Strings[0]);
            FdmClient.CDSModuleActif.FieldByName('MODU_NOM').AsString:= vLstItem.Caption;
            FdmClient.CDSModuleActif.FieldByName('MMAG_EXPDATE').AsDateTime:= DateTimePickerExpiration.Date;
            FdmClient.CDSModuleActif.FieldByName('UGG_ID').AsInteger:= StrToInt(vLstItem.SubItems.Strings[1]);
            FdmClient.CDSModuleActif.FieldByName('UGM_MAGID').AsInteger:= StrToInt(vLstItem.SubItems.Strings[2]);

            dmClients.PostRecordToXml('ModuleGinkoia', 'TModuleGinkoia', FdmClient.CDSModuleActif);
            FdmClient.CDSModuleActif.Post;
          end;
        end;
      end;
      Result:= True;
    except
      Raise;
    end;
  finally
    //-->
  end;
end;

procedure TDlgModCltFrm.Stat_ModuleDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
 if Panel = StatusBar.Panels[0] then
  with ProgressBar1 do begin
    Top := Rect.Top;
    Left := Rect.Left;
    Width := Rect.Right - Rect.Left;
    Height := Rect.Bottom - Rect.Top;
  end;
end;

end.
