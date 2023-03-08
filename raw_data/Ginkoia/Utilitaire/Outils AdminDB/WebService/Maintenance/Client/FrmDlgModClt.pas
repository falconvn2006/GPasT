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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListViewModDispEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
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

uses dmdClients, uTool;

{$R *.dfm}

procedure TDlgModCltFrm.FormCreate(Sender: TObject);
begin
  inherited;
  UseUpdateKind:= True;
  DateTimePickerExpiration.Date:= EncodeDate(GetCurrentDateTime.wYear, 12, 31);
//  FMOD_ID:= -1;
end;

procedure TDlgModCltFrm.FormShow(Sender: TObject);
begin
  inherited;
  DsMagasin.DataSet:= FdmClient.CDS_SOCMAGPOS;
  DsModule.DataSet:= FdmClient.CDSModuleActif;
  if AAction = ukModify then
    begin
      dmClients.XmlToDataSet('ModuleGinkoia?MAG_ID=' + FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_ID_GINKOIA').AsString +
                             '&DOS_ID=' + FdmClient.CDS_SOCMAGPOS.FieldByName('DOS_ID').AsString +
                             '&ALL=1', FdmClient.CDSModuleDisponible);
      DateTimePickerExpiration.Date:= FdmClient.CDSModuleActif.FieldByName('MODMAG_DATE').AsDateTime;
      LoadModuleDispo;
      ListViewModDisp.Selected:= ListViewModDisp.Items.Item[0];
    end
  else
    if AAction = ukInsert then
      begin
        dmClients.XmlToDataSet('ModuleGinkoia?MAG_ID=' + FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_ID_GINKOIA').AsString +
                               '&DOS_ID=' + FdmClient.CDS_SOCMAGPOS.FieldByName('DOS_ID').AsString, FdmClient.CDSModuleDisponible);
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
    vLstItem.Caption:= FdmClient.CDSModuleDisponible.FieldByName('MOD_NOM').AsString;
    vLstItem.SubItems.Add(FdmClient.CDSModuleDisponible.FieldByName('MOD_ID').AsString);
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
          if FdmClient.CDSModuleDisponible.FieldByName('MOD_ID').AsInteger = FdmClient.CDSModuleActif.FieldByName('MOD_ID').AsInteger then
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
begin
  Result:= inherited PostValues;
  try
    try
      if AAction = ukModify then
        begin
          vLstItem:= ListViewModDisp.Items.Item[0];
          DsModule.DataSet.Edit;
        end
      else
        begin
          vLstItem:= ListViewModDisp.Selected;
          DsModule.DataSet.Insert;
        end;

      if vLstItem = nil then
        Raise Exception.Create('Vous devez choisir un module');

      FdmClient.CDSModuleActif.FieldByName('DOS_ID').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('DOS_ID').AsInteger;
      FdmClient.CDSModuleActif.FieldByName('MAG_ID').AsInteger:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_ID').AsInteger;
      FdmClient.CDSModuleActif.FieldByName('MAG_NOM').AsString:= FdmClient.CDS_SOCMAGPOS.FieldByName('MAG_NOM').AsString;
      FdmClient.CDSModuleActif.FieldByName('MOD_ID').AsInteger:= StrToInt(vLstItem.SubItems.Strings[0]);
      FdmClient.CDSModuleActif.FieldByName('MOD_NOM').AsString:= vLstItem.Caption;
      FdmClient.CDSModuleActif.FieldByName('MODMAG_DATE').AsDateTime:= DateTimePickerExpiration.Date;
      FdmClient.CDSModuleActif.FieldByName('UGG_ID').AsInteger:= StrToInt(vLstItem.SubItems.Strings[1]);
      FdmClient.CDSModuleActif.FieldByName('UGM_MAGID').AsInteger:= StrToInt(vLstItem.SubItems.Strings[2]);

      dmClients.PostRecordToXml('ModuleGinkoia', 'TModuleGinkoia', FdmClient.CDSModuleActif);
      FdmClient.CDSModuleActif.Post;
      Result:= True;
    except
      Raise;
    end;
  finally
    //-->
  end;
end;

end.
