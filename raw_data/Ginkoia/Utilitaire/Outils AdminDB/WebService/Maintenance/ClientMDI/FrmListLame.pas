unit FrmListLame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoiaDlg, StdCtrls, Buttons, ExtCtrls, IniFiles,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, DBClient, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid;

type
  TListLameFrm = class(TCustomGinkoiaDlgFrm)
    cxGridListLame: TcxGrid;
    cxGridDBTWListLame: TcxGridDBTableView;
    cxGridLevel4: TcxGridLevel;
    DsListLame: TDataSource;
    CDSListLame: TClientDataSet;
    CDSListLameNAME: TStringField;
    CDSListLameHOST: TStringField;
    CDSListLameURL: TStringField;
    cxGridDBTWListLameNAME: TcxGridDBColumn;
    cxGridDBTWListLameHOST: TcxGridDBColumn;
    cxGridDBTWListLameURL: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure cxGridDBTWListLameDblClick(Sender: TObject);
  private
    FOnDblClick: TNotifyEvent;
    FOnDataChange: TDataChangeEvent;
    procedure DoOnDblClick(Sender: TObject);
    procedure DoOnDataChange(Sender: TObject; Field: TField);
  public
    procedure LoadListLame;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnDataChange: TDataChangeEvent read FOnDataChange write FOnDataChange;
  end;

var
  ListLameFrm: TListLameFrm;

implementation

uses dmdClients;

{$R *.dfm}

procedure TListLameFrm.cxGridDBTWListLameDblClick(Sender: TObject);
begin
  inherited;
  DoOnDblClick(Sender);
  SpdBtnOk.Click;
end;

procedure TListLameFrm.DoOnDataChange(Sender: TObject; Field: TField);
begin
  if Assigned(FOnDataChange) then
    FOnDataChange(Sender, Field);
end;

procedure TListLameFrm.DoOnDblClick(Sender: TObject);
begin
 if Assigned(OnDblClick) then
   FOnDblClick(Sender);
end;

procedure TListLameFrm.FormCreate(Sender: TObject);
begin
  inherited;
  LoadListLame;
end;

procedure TListLameFrm.LoadListLame;
var
  i: integer;
  vIniFile: TIniFile;
  vSLAliasName, vSLUrl: TStrings;
  Buffer: String;
begin
  CDSListLame.EmptyDataSet;
  Buffer:= ChangeFileExt(Application.ExeName, '.ini');
  vSLAliasName:= TStringList.Create;
  vSLUrl:= TStringList.Create;
  vIniFile:= TIniFile.Create(Buffer);
  CDSListLame.DisableControls;
  try
    vIniFile.ReadSection('ALIASNAME', vSLAliasName);
    vIniFile.ReadSection('URL', vSLUrl);
    for i:= 0 to vSLAliasName.Count -1 do
      begin
        CDSListLame.Append;

        Buffer:= vIniFile.ReadString('ALIASNAME', vSLAliasName.Strings[i], '');
        if Trim(Buffer) <> '' then
          CDSListLame.FieldByName('NAME').AsString:= Buffer;

        Buffer:= vIniFile.ReadString('URL', vSLUrl.Strings[i], '');
        if Trim(Buffer) <> '' then
          begin
            CDSListLame.FieldByName('URL').AsString:= Buffer;
            CDSListLame.FieldByName('HOST').AsString:= TGnkParams.UrlToHost(Buffer);
          end;

        CDSListLame.Post;
      end;
  finally
    CDSListLame.EnableControls;
    CDSListLame.First;
    FreeAndNil(vIniFile);
    FreeAndNil(vSLAliasName);
    FreeAndNil(vSLUrl);
  end;
end;

end.
