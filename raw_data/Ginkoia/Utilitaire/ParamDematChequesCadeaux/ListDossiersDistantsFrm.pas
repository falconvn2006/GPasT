unit ListDossiersDistantsFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls,ExtCtrls,
  ComCtrls, Buttons, Math, DB, Grids, DBGrids,
  IdHTTP, IdURI,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxDBData,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, dxmdaset, uJson;

Const C_UrlSa = 'http://tools.ginkoia.net/';

type
  TDossier = class(TPersistent)
  private
    FNom: string;
    FId: Int64;
    FDatabase: string;
  public
  published
    property Id : Int64         read FId          write FId ;
    property Nom: string        read FNom         write FNom ;
    property Database: string   read FDatabase    write FDatabase ;
  end;

  TDossiers = array of TDossier ;

  TResultDossiers = class(TPersistent)
    private
      FErrNo : integer;
      FError : string;
      FResult : TDossiers ;
    public
      destructor Destroy ; override ;
    published
      property ErrNo : integer read FErrNo write FErrNo;
      property Error : string read FError write FError;
      property Result : TDossiers read FResult write FResult;
  end;

  TLame = class(TPersistent)
  private
    FNom: string;
    FId: Int64;
    FHost : string;
  public
  published
    property Id : Int64         read FId          write FId ;
    property Nom: string        read FNom         write FNom ;
    property Host: string       read FHost        write FHost;
  end;

  TLames = array of TLame ;

  TResultLames = class(TPersistent)
    private
      FErrNo : integer;
      FError : string;
      FResult : TLames ;
    public
      destructor Destroy ; override ;
    published
      property ErrNo : integer read FErrNo write FErrNo;
      property Error : string read FError write FError;
      property Result : TLames read FResult write FResult;
  end;



  TFrm_ListeDossiersDistants = class(TForm)
    dsDossiers: TDataSource;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    sb_status: TStatusBar;
    mdDossiers: TdxMemData;
    cbLames: TComboBox;
    mdDossiersLAME: TStringField;
    mdDossiersCHEMIN: TStringField;
    Label1: TLabel;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1RecId: TcxGridDBColumn;
    cxGrid1DBTableView1LAME: TcxGridDBColumn;
    cxGrid1DBTableView1CHEMIN: TcxGridDBColumn;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    mdDossiersDOSSIER: TStringField;
    cxGrid1DBTableView1DOSSIER: TcxGridDBColumn;
    procedure RecupClick(Sender: TObject);
//    procedure BdownloadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxGrid1DBTableView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
//    FUrl   : string;
    FLame   : string;
    FChemin : string;
    procedure getBaseLame(aLameName : string) ;
    procedure getLames() ;
    { Déclarations privées }
  public
    property Lame   : string    read FLame    write FLame;
    property Chemin : string    read FChemin  write FChemin;
    { Déclarations publiques }
  end;

var
  Frm_ListeDossiersDistants: TFrm_ListeDossiersDistants;

implementation

{$R *.dfm}

{ TResultDossiers }

destructor TResultDossiers.Destroy;
var
  vDossier : TDossier ;
begin
  for vDossier in FResult do
  begin
    if Assigned(vDossier)
      then vDossier.Free ;
  end;

  setLength(FResult, 0) ;

  inherited;
end;

{ TResultLames }

destructor TResultLames.Destroy;
var
  vLame : TLame ;
begin
  for vLame in FResult do
  begin
    if Assigned(vLame)
      then vLame.Free ;
  end;

  setLength(FResult, 0) ;

  inherited;
end;


{
function ProgressCallback(sender: Pointer; total: boolean; value: int64): HRESULT; stdcall;
 begin
   if total
    then
        begin
//            Frm_SplittagesDistants.ProgressBar1.Max := 1000;
//            Frm_SplittagesDistants.SizeItem    := value;
        end
    else
        begin
//          if (Frm_SplittagesDistants.SizeItem)<>0
//            then Frm_SplittagesDistants.ProgressBar1.Position := Round(value*1000/Frm_SplittagesDistants.SizeItem)
//            else Frm_SplittagesDistants.ProgressBar1.Position := 0;
        end;
   Application.ProcessMessages;
   Result := S_OK;
 end;
}



procedure TFrm_ListeDossiersDistants.RecupClick(Sender: TObject);
begin
//    GetDossiersDistants;
end;

procedure TFrm_ListeDossiersDistants.BitBtn1Click(Sender: TObject);
begin
   TBitBtn(Sender).Enabled:=false;
   getBaseLame(cbLames.Text) ;
   TBitBtn(Sender).Enabled:=true;
end;

procedure TFrm_ListeDossiersDistants.cxGrid1DBTableView1CellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  Lame   := mdDossiers.FieldByName('Lame').AsString;
  Chemin := mdDossiers.FieldByName('chemin').AsString;
  ModalResult:=mrOk;
end;

procedure TFrm_ListeDossiersDistants.FormCreate(Sender: TObject);
begin
  FLame  := '';
  getLames();
end;

procedure TFrm_ListeDossiersDistants.FormShow(Sender: TObject);
begin
//  GetDossiersDistants;

end;

procedure TFrm_ListeDossiersDistants.getLames() ;
var
  vResult : TResultLames ;
  vHttp : TidHTTP ;
  vJson : string ;
  i:integer;
begin
  try
     cbLames.Items.BeginUpdate;
     cbLames.Items.Clear;
     mdDossiers.Close();
     vHttp := TidHTTP.Create ;
      try
        vHttp.ConnectTimeout := 2000 ;
        vHttp.Request.ContentType := 'application/json' ;

        vJson := vHttp.Get(C_UrlSa + 'api/ginkoia/tools/getServeurs.php');
        if vHttp.ResponseCode = 200 then
        begin
          vResult := TResultLames.Create ;
          try
            TJSON.JSONToObject(vJson, vResult) ;
            if vResult.FErrNo = 0 then
            begin
              // syncBasesFromDossiers(vResult.Result) ;
              for I := Low(vResult.Result) to High(vResult.Result) do
                begin
                     cbLames.Items.Add(vResult.Result[i].Nom);
                end;
            end else begin
//mdDossiers.FieldByName('Chemin').asstring := vResult.database
              // Log.Log('getBaseLame', 'Log', 'Erreur API : '+IntToStr(vResult.FErrNo)+' : ' + vResult.FError, logError, true, 0, ltLocal);
            end;
          finally
            vResult.Free;
          end;
        end else begin
//          Log.Log('getBaseLame', 'Log', 'Erreur HTTP : ' + vHttp.ResponseText, logError, true, 0, ltLocal);
        end;

      finally
        vHttp.Free ;
        cbLames.Items.EndUpdate;
      end;
  except
    on E:Exception do
    begin

    end;
  end;
end;




procedure TFrm_ListeDossiersDistants.getBaseLame(aLameName : string) ;
var
  vResult : TResultDossiers ;
  vHttp : TidHTTP ;
  vJson : string ;
  i:integer;
begin
  try
     mdDossiers.DisableControls;
     mdDossiers.Close();
     vHttp := TidHTTP.Create ;
      try
        vHttp.ConnectTimeout := 2000 ;
        vHttp.Request.ContentType := 'application/json' ;

        vJson := vHttp.Get(C_UrlSa + 'api/ginkoia/tools/getDossiersByLame.php?lame=' + TIdURI.ParamsEncode(aLameName));
        if vHttp.ResponseCode = 200 then
        begin
          vResult := TResultDossiers.Create ;
          try
            TJSON.JSONToObject(vJson, vResult) ;
            if vResult.FErrNo = 0 then
            begin
              // syncBasesFromDossiers(vResult.Result) ;
              mdDossiers.open();
              for I := Low(vResult.Result) to High(vResult.Result) do
                begin
                  mdDossiers.Append;
                  mdDossiers.FieldByName('Lame').asstring   := aLameName;
                  mdDossiers.FieldByName('Dossier').asstring   := vResult.Result[i].Nom;
                  mdDossiers.FieldByName('Chemin').asstring := vResult.Result[i].database;
                  mdDossiers.Post;
                end;
            end else begin
//mdDossiers.FieldByName('Chemin').asstring := vResult.database
              // Log.Log('getBaseLame', 'Log', 'Erreur API : '+IntToStr(vResult.FErrNo)+' : ' + vResult.FError, logError, true, 0, ltLocal);
            end;
          finally
            vResult.Free;
          end;
        end else begin
//          Log.Log('getBaseLame', 'Log', 'Erreur HTTP : ' + vHttp.ResponseText, logError, true, 0, ltLocal);
        end;

      finally
        vHttp.Free ;
        mdDossiers.EnableControls;
      end;
  except
    on E:Exception do
    begin

    end;
  end;
end;




end.
