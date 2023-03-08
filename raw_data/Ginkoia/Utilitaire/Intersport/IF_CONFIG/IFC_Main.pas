unit IFC_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, StdCtrls,
  ExtCtrls, CategoryButtons, ComCtrls, DBCtrls, IFC_DM, IFC_Type, cxCheckBox, uVersion;

type
  Tfrm_Main = class(TForm)
    Pan_Left: TPanel;
    Pan_Client: TPanel;
    Pan_ClientTop: TPanel;
    Pan_ClientBottom: TPanel;
    Gbx_InfoComp: TGroupBox;
    Gbx_ListeBase: TGroupBox;
    Pan_lstBases: TPanel;
    cxgBases: TcxGrid;
    cxgBasesDBTableView1: TcxGridDBTableView;
    cxgBasesLevel1: TcxGridLevel;
    Ds_DOSSIERS: TDataSource;
    cxgBasesDBTableView1DOS_ID: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_NOM: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_GROUPE: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_NUM: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_MAGID: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_MAGENSEIGNE: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_BASEPATH: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_VILLE: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_ACTIF: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_DTCREATION: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_DTMODIFICATION: TcxGridDBColumn;
    CategoryButtons1: TCategoryButtons;
    pb_progress: TProgressBar;
    Pan_ICLeft: TPanel;
    Lab_DTCReation: TLabel;
    Lab_DTModification: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    Pan_ICCLient: TPanel;
    DBMemo1: TDBMemo;
    Splitter1: TSplitter;
    cxgBasesDBTableView1DOS_ACTIFBI: TcxGridDBColumn;
    cxgBasesDBTableView1Column1: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_CODEGROUPEBI: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_LAST: TcxGridDBColumn;
    cxgBasesDBTableView1DOS_MESACHATS: TcxGridDBColumn;
    procedure DoParamsOnClick(Sender: TObject);
    procedure DoAddBaseOnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DoEditBaseOnclick(Sender: TObject);
    procedure cxgBasesDBTableView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure DoCompleteBaseOnClick(Sender: TObject);
    procedure DoActiveBaseOnclick(Sender: TObject);
    procedure CategoryButtons1CategoryCollapase(Sender: TObject;
      const Category: TButtonCategory);
    procedure DoDelBaseClick(Sender: TObject);
    procedure DoActiveBIClick(Sender: TObject);
    procedure DoActiveMesAchats(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frm_Main: Tfrm_Main;

implementation

uses IFC_CFGLignes;

{$R *.dfm}

procedure Tfrm_Main.DoAddBaseOnClick(Sender: TObject);
var
  DOS_ID : Integer;
begin
  DOS_ID := ShowForm(mAdd);
  if DOS_ID > -1  then
  begin
    Ds_DOSSIERS.DataSet.Refresh;
    Ds_DOSSIERS.DataSet.Locate('DOS_ID',DOS_ID,[]);
  end;
end;

procedure Tfrm_Main.DoEditBaseOnclick(Sender: TObject);
var
  DOS_ID : Integer;
begin
  DOS_ID := ShowForm(mEdit,Ds_DOSSIERS.DataSet.FieldByName('DOS_ID').AsInteger);
  if DOS_ID > -1  then
  begin
    Ds_DOSSIERS.DataSet.Refresh;
    Ds_DOSSIERS.DataSet.Locate('DOS_ID',DOS_ID,[]);
  end;
end;

procedure Tfrm_Main.DoActiveBaseOnclick(Sender: TObject);
var
  ID : Integer;
begin
  With DM_IFC do
  begin
//    With Que_DOSSIERS do
//    begin
//      if FieldByName('DOS_ACTIF').AsInteger = 0 then
//        if (Trim(FieldByName('DOS_GROUPE').AsString) = '') Or (Trim(FieldByName('DOS_NUM').AsString) = '') then
//        begin
//          ShowMessage('Le groupe et le numéro sont obligatoire pour pouvoir activer une base');
//          Exit;
//        end; // if
//    end; // with

    With Que_DbMTmp do
    begin
      IboDbMag.StartTransaction;
      try
        ID := Que_DOSSIERS.FieldByName('DOS_ID').AsInteger;
        Close;
        SQL.Clear;
        SQL.Add('Update DOSSIERS Set');
        SQL.Add(' DOS_ACTIF = :PDOSACTIF');
        SQL.Add('Where DOS_ID = :PDOSID');
        ParamCheck := True;
        if Que_DOSSIERS.FieldByName('DOS_ACTIF').AsInteger = 0 then
          ParamByName('PDOSACTIF').AsInteger := 1
        else
          ParamByName('PDOSACTIF').AsInteger := 0;
        ParamByName('PDOSID').AsInteger := ID;
        ExecSQL;

        IboDbMag.Commit;

        // Rechargement + Repositionnement
        Que_DOSSIERS.Refresh;
        Que_DOSSIERS.Locate('DOS_ID',ID,[]);
      Except on E:Exception do
        begin
          IboDbMag.Rollback;
          ShowMessage(E.Message);
        end;
      end;
    end; // with
  end; // with
end;

procedure Tfrm_Main.DoActiveBIClick(Sender: TObject);
var
  ID : Integer;
begin
  With DM_IFC do
    With Que_DbMTmp do
    begin
      IboDbMag.StartTransaction;
      try
        ID := Que_DOSSIERS.FieldByName('DOS_ID').AsInteger;
        Close;
        SQL.Clear;
        SQL.Add('Update DOSSIERS Set');
        SQL.Add(' DOS_ACTIFBI = :PDOSACTIFBI');
        SQL.Add('Where DOS_ID = :PDOSID');
        ParamCheck := True;
        if Que_DOSSIERS.FieldByName('DOS_ACTIFBI').AsInteger = 0 then
          ParamByName('PDOSACTIFBI').AsInteger := 1
        else
          ParamByName('PDOSACTIFBI').AsInteger := 0;
        ParamByName('PDOSID').AsInteger := ID;
        ExecSQL;

        IboDbMag.Commit;

        // Rechargement + Repositionnement
        Que_DOSSIERS.Refresh;
        Que_DOSSIERS.Locate('DOS_ID',ID,[]);
      Except on E:Exception do
        begin
          IboDbMag.Rollback;
          ShowMessage(E.Message);
        end;
      end;
    end; // with
end;

procedure Tfrm_Main.DoActiveMesAchats(Sender: TObject);
var
  ID : Integer;
  IDDOS : String;
begin
  With DM_IFC do
    With Que_DbMTmp do
    begin
      IboDbMag.StartTransaction;
      try
        // Récupération de ID MDC
        IDDOS := Que_DOSSIERS.FieldByName('DOS_IDMDC').AsString;
        if  Que_DOSSIERS.FieldByName('DOS_MESACHATS').AsInteger = 1 then
        begin
          if IDDOS[Length(IDDOS)] = '0' then
            IDDOS := Copy(IDDOS,1,Length(IDDOS) - 1);
        end
        else begin
          IDDOS := IDDOS + '0';
        end;


        ID := Que_DOSSIERS.FieldByName('DOS_ID').AsInteger;
        Close;
        SQL.Clear;
        SQL.Add('Update DOSSIERS Set');
        SQL.Add(' DOS_MESACHATS = :PDOSMESACHATS,');
        SQL.Add(' DOS_IDMDC = :PIDMDC');
        SQL.Add('Where DOS_ID = :PDOSID');
        ParamCheck := True;
        if Que_DOSSIERS.FieldByName('DOS_MESACHATS').AsInteger = 0 then
        begin
          ParamByName('PDOSMESACHATS').AsInteger := 1;
        end
        else begin
          ParamByName('PDOSMESACHATS').AsInteger := 0;
        end;
        ParamByName('PIDMDC').AsString := IDDOS;
        ParamByName('PDOSID').AsInteger := ID;
        ExecSQL;

        IboDbMag.Commit;

        // Rechargement + Repositionnement
        Que_DOSSIERS.Refresh;
        Que_DOSSIERS.Locate('DOS_ID',ID,[]);
      Except on E:Exception do
        begin
          IboDbMag.Rollback;
          ShowMessage(E.Message);
        end;
      end;
    end; // with
end;

procedure Tfrm_Main.DoCompleteBaseOnClick(Sender: TObject);
begin
  Try
    pb_progress.Visible := True;
    DM_IFC.DoCheckMag(pb_progress);
  Finally
    pb_progress.Visible := False;
  End;
end;

procedure Tfrm_Main.DoParamsOnClick(Sender: TObject);
begin
  If DM_IFC.ShowCFGParams = mrOk then
    DM_IFC.ConnectToDbMag(IniCfg.Database);
end;

procedure Tfrm_Main.DoDelBaseClick(Sender: TObject);
begin
  With DM_IFC do
  begin
    if MessageDlg('Etes vous sûr de vouloir supprimer le dossier ' + Que_DOSSIERS.FieldByName('DOS_NOM').AsString,mtConfirmation,[mbYes,mbNo],0) = mrYes then
    begin
      With Que_DbMTmp do
      begin
      IboDbMag.StartTransaction;
      Close;
      SQL.Clear;
      SQL.Add('Delete from DOSSIERS');
      SQL.Add('Where DOS_ID = :PDOSID');
      ParamCheck := True;
      ParamByName('PDOSID').AsInteger := Que_DOSSIERS.FieldByName('DOS_ID').AsInteger;
      ExecSQL;
      IboDbMag.Commit;
      Que_DOSSIERS.Refresh;
      end;
    end;
  end;
end;

procedure Tfrm_Main.CategoryButtons1CategoryCollapase(Sender: TObject;
  const Category: TButtonCategory);
begin
  Category.Collapsed := False;
end;

procedure Tfrm_Main.cxgBasesDBTableView1CellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  DoEditBaseOnclick(Self);
end;

procedure Tfrm_Main.FormCreate(Sender: TObject);
begin
  GAPPPATH := ExtractFilePath(Application.ExeName);

  IniCfg.LoadIni;

  DM_IFC := TDM_IFC.Create(Self);
  if DM_IFC.ConnectToDbMag(IniCfg.Database) then
    DM_IFC.UpdateIbDatabase;

  //Affichage de la version
  Caption := Caption + ' - Version: ' + GetNumVersionSoft;

end;

end.
