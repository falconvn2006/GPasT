unit Catmarque_dm;

interface

uses
  SysUtils, Classes, DB, ADODB, OleServer, OutlookXP;

type
  Tdm_CatMarque = class(TDataModule)
    ado: TADOConnection;
    Qmag: TADOQuery;
    Qmagmag_id: TAutoIncField;
    Qmagmag_actif: TIntegerField;
    Qmagmag_dateactivation: TDateTimeField;
    Qmagmag_code: TStringField;
    Qmagmag_nom: TStringField;
    Qmagmag_ville: TStringField;
    Qmagmag_cheminbase: TStringField;
    Qmagmag_dosid: TIntegerField;
    Qmagdos_nom: TStringField;
    Qmagmag_senderid: TIntegerField;
    QUni: TADOQuery;
    QUniuni_nom: TStringField;
    QUniuni_id: TIntegerField;
    Qcol: TADOQuery;
    Qcolcol_id: TAutoIncField;
    Qcolcol_nom: TStringField;
    ds_uni: TDataSource;
    Qdos: TADOQuery;
    QdosDOS_ID: TAutoIncField;
    QdosDOS_NOM: TStringField;
    QdosDOS_COMMENT: TStringField;
    QdosDOS_ENABLED: TIntegerField;
    QdosDOS_GUID: TStringField;
    QdosDOS_UNIID: TIntegerField;
    Tmag: TADOTable;
    TmagMAG_ID: TAutoIncField;
    TmagMAG_DOSID: TIntegerField;
    TmagMAG_REGID: TIntegerField;
    TmagMAG_TYMID: TIntegerField;
    TmagMAG_CODE: TStringField;
    TmagMAG_NOM: TStringField;
    TmagMAG_DIRECTEUR: TStringField;
    TmagMAG_VILLE: TStringField;
    TmagMAG_LEARDERSHIP: TIntegerField;
    TmagMAG_ENABLED: TIntegerField;
    TmagMAG_CHEMINBASE: TStringField;
    TmagMAG_DATEACTIVATION: TDateTimeField;
    TmagMAG_ACTIF: TIntegerField;
    TmagMAG_X: TSmallintField;
    TmagMAG_Y: TSmallintField;
    TmagMAG_INDICGENERAL: TWordField;
    TmagMAG_SENDERID: TIntegerField;
    TmagMAG_RAPPINTEG: TIntegerField;
    TmagMAG_CATMAN: TIntegerField;
    Qreg: TADOQuery;
    QregREG_ID: TAutoIncField;
    QregREG_NOM: TStringField;
    OutlookBarPane1: TOutlookBarPane;
    OutlookBarPane2: TOutlookBarPane;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  dm_CatMarque: Tdm_CatMarque;

implementation

{$R *.dfm}

procedure Tdm_CatMarque.DataModuleCreate(Sender: TObject);
begin
ado.Connected:=true;
  qmag.Open;
  quni.open;
  qcol.Open;
  qcol.first;
  qdos.open;
  tmag.Open;
  qreg.Open;
end;

end.
