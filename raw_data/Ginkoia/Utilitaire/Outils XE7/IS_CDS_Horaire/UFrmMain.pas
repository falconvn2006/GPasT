unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList, Vcl.ExtCtrls, Vcl.StdCtrls, UFrmHeure,
  FireDAC.Comp.Client, FireDac.Dapt, FireDac.Stan.Def, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.UI.Intf,
  FireDAC.Stan.Pool, FireDAC.Phys, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Phys.IB, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,winapi.ShellApi,
  System.ImageList, Vcl.Grids;
  

type
  TFrmMain = class(TForm)
    pnl_Top: TPanel;
    lbl_Base: TLabel;
    bed_Base: TButtonedEdit;
    btn_Ouvrir: TButton;
    pnl_Left: TPanel;
    Label3: TLabel;
    pnl_Client: TPanel;
    led_Base: TLabeledEdit;
    led_Magasin: TLabeledEdit;
    led_Caisse: TLabeledEdit;
    btn_Changer: TButton;
    led_Heure: TLabeledEdit;
    btn_Quitter: TButton;
    il_Image: TImageList;
    GridPanel1: TGridPanel;
    sg_caisse: TStringGrid;
    procedure btn_ChangeDateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bed_BaseRightButtonClick(Sender: TObject);
    procedure btn_OuvrirClick(Sender: TObject);
    procedure btn_QuitterClick(Sender: TObject);
    procedure bed_BaseChange(Sender: TObject);
    procedure EffaceStringGrid;
    procedure RemplirStringGrid;
    procedure sg_caisseClick(Sender: TObject);
    procedure sg_caisseDblClick(Sender: TObject);
  private
    FQuery: TFDQuery;
    FQueryWrite: TFDQuery;
    FQueryK: TFDQuery;
    FDataBase: TFDConnection;
    procedure WMDROPFILES(var msg : TWMDropFiles) ; message WM_DROPFILES;
  public
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.bed_BaseChange(Sender: TObject);
begin
  if bed_Base.Text<>'' then
    btn_Ouvrir.Enabled := true
      else
        btn_Ouvrir.Enabled := false;
end;

procedure TFrmMain.bed_BaseRightButtonClick(Sender: TObject);
var
  lOpenDialog: TOpenDialog;
begin
  lOpenDialog := TOpenDialog.Create(nil);
  lOpenDialog.Title := 'Sélectionner la base de données';
  lOpenDialog.Filter := 'Base de données|*.ib|Tous les fichiers|*.*';
  if lOpenDialog.Execute then
  begin
    bed_Base.Text := lOpenDialog.FileName;
  end;
  lOpenDialog.Free;
  btn_OuvrirClick(self);
end;

procedure TFrmMain.btn_ChangeDateClick(Sender: TObject);
var
  lIndex: integer;
  lEntier: integer;
  lHeure: double;
  lMin, lHour, lSecondes, lMili: word;
begin
  FrmHeure.dtp_Heure.Time := FQuery.FieldByName('PRM_FLOAT').AsFloat;
  if FrmHeure.ShowModal = mrOk then
  begin
    try
      // on remet les secondes a 0
      DecodeTime(FrmHeure.dtp_Heure.Time,lhour,lMin,lSecondes,lMili);
      FrmHeure.dtp_Heure.Time := EncodeTime(lhour,lMin,0,0);
      //on supprime la date
      lEntier := Trunc(FrmHeure.dtp_Heure.Time);
      lHeure := FrmHeure.dtp_Heure.Time - lEntier;
      FQueryWrite.Close;
      FQueryWrite.ParamByName('ID').AsInteger := FQuery.FieldByName('PRM_ID').AsInteger;
      FQueryWrite.ParamByName('TIME').AsFloat := lHeure;
      FQueryWrite.ExecSQL;
      FQueryK.Close;
      FQueryK.ParamByName('ID').AsInteger := FQuery.FieldByName('PRM_ID').AsInteger;
      FQueryK.ExecSQL;
      FQuery.Close;
      FQuery.Open;
      RemplirStringGrid;
      sg_caisseClick(self);
    except
      on E:Exception do
        MessageDlg('Une erreur s''est produite'#13+E.Message,mtError,[mbOK],0);
    end;
  end;
end;

procedure TFrmMain.EffaceStringGrid;
var
  i,y:integer;
begin
  for i := 1 to sg_caisse.ColCount do
    for y := 0 to sg_caisse.RowCount do
      sg_caisse.Cells[y,i]:='';
end;
procedure TFrmMain.RemplirStringGrid;
var
  i,y:integer;
begin
  try
    FQuery.Open;
    btn_Ouvrir.Enabled := false;
    sg_caisse.RowCount   := FQuery.RecordCount +2;
    EffaceStringGrid;
    i:=0;
    while not FQuery.Eof do
    begin
      inc(i);
      sg_caisse.Cells[0,i]:=FQuery.FieldByName('PRM_STRING').AsString;
      sg_caisse.Cells[1,i]:=FQuery.FieldByName('MAG_NOM').AsString;
      sg_caisse.Cells[2,i]:=FormatDateTime('H'' h ''mm'' min''',FloatToDateTime( FQuery.FieldByName('PRM_FLOAT').AsFloat ) );
      FQuery.Next;
    end;
  except
    on E:Exception do
      MessageDlg('Erreur à l''ouverture du Query'#13+E.Message,mtError,[mbOK],0);
  end;
end;
procedure TFrmMain.btn_OuvrirClick(Sender: TObject);
var
  i:integer;
begin
  if not FileExists(bed_Base.Text) then
  begin
    MessageDlg('Erreur : le fichier n''existe pas',mtError,[mbOK],0);
    exit;
  end;

  try
    FQuery.Close;
    FDataBase.Open('DriverID=IB;Database='+bed_Base.Text+';User_Name=SYSDBA;Password=masterkey;Protocol=TCPIP;server=localhost;port=3050');
    RemplirStringGrid;

  except
    on E:Exception do
      MessageDlg('Erreur à l''ouverture de la base de données'#13+E.Message,mtError,[mbOK],0);
  end;
end;

procedure TFrmMain.btn_QuitterClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Handle,true);

  FDataBase := TFDConnection.Create(nil);
  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FDataBase;
  FQuery.SQL.Add('SELECT BAS_NOM, MAG_NOM, PRM_FLOAT, PRM_STRING, PRM_INTEGER, PRM_ID');
  FQuery.SQL.Add('FROM GENBASES JOIN K ON K_ID = BAS_ID AND K_ENABLED = 1');
  FQuery.SQL.Add('JOIN GENMAGASIN ON BAS_MAGID = MAG_ID');
  FQuery.SQL.Add('JOIN GENPARAM ON PRM_POS = BAS_ID AND PRM_CODE=50 AND PRM_TYPE=11');
  FQuery.SQL.Add('WHERE BAS_NOM LIKE ''%-SEC''');
  FQueryWrite := TFDQuery.Create(nil);
  FQueryWrite.Connection := FDataBase;
  FQueryWrite.SQL.Add('UPDATE GENPARAM SET PRM_FLOAT=:TIME WHERE PRM_ID=:ID');
  FQueryK := TFDQuery.Create(nil);
  FQueryK.Connection := FDataBase;
  FQueryK.SQL.Add('EXECUTE PROCEDURE PR_UPDATEK(:ID,0)');

  sg_caisse.FixedCols   := 0;
  sg_caisse.FixedRows   := 1;
  sg_caisse.ColCount    := 3;
  sg_caisse.RowCount    := 1;
  sg_caisse.Cells[0,0]  := 'Nom';
  sg_caisse.Cells[1,0]  := 'Magasin';
  sg_caisse.Cells[2,0]  := 'Heure Synchro.';
  sg_caisse.ColWidths[0]:= 170;
  sg_caisse.ColWidths[1]:= 70;
  sg_caisse.ColWidths[2]:= 80;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  FQuery.Free;
  FQueryWrite.Free;
  FQueryK.Free;
  FDataBase.Free;
end;


procedure TFrmMain.sg_caisseClick(Sender: TObject);
begin
  if sg_caisse.Row>0 then
  begin
    try
      btn_Changer.enabled := true;

      FQuery.Locate('PRM_STRING',sg_caisse.Cells[0,sg_caisse.Row]);
      led_Base.Text := FQuery.FieldByName('PRM_STRING').AsString;
      led_Magasin.Text := FQuery.FieldByName('MAG_NOM').AsString;
      led_Caisse.Text := FQuery.FieldByName('BAS_NOM').AsString;
      led_Heure.Text := FormatDateTime('H'' h ''mm'' min''',FloatToDateTime(FQuery.FieldByName('PRM_FLOAT').AsFloat));
    except
      on E:Exception do
        MessageDlg('Erreur'#13+E.Message,mtError,[mbOK],0);
    end;
  end;
end;

procedure TFrmMain.sg_caisseDblClick(Sender: TObject);
begin
  sg_caisseClick(self);
  btn_ChangeDateClick(self);
end;

procedure TFrmMain.WMDROPFILES(var msg: TWMDropFiles);
const
  MAXFILENAME = 255;
var
  cnt, fileCount : integer;
  fileName : array [0..MAXFILENAME] of char;
begin
  // how many files dropped?
  fileCount := DragQueryFile(msg.Drop, $FFFFFFFF, fileName, MAXFILENAME) ;
  // query for file names
  for cnt := 0 to -1 + fileCount do
  begin
    DragQueryFile(msg.Drop, cnt, fileName, MAXFILENAME) ;
    //do something with the file(s)
    bed_Base.Text := fileName;
  end;
 //release memory
 DragFinish(msg.Drop) ;
end;

(*PanelImageDrop*)


end.
