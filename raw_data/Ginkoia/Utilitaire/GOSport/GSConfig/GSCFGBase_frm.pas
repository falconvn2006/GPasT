unit GSCFGBase_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, DBCtrls, Mask,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, GSCFGMain_DM;

type
  TForm2 = class(TForm)
    Pan_Bottom: TPanel;
    Nbt_Cancel: TBitBtn;
    Nbt_Post: TBitBtn;
    GRDP_Top: TGridPanel;
    Pan_Client: TPanel;
    Gbx_Informations: TGroupBox;
    Lab_Dossier: TLabel;
    Lab_DB: TLabel;
    Lab_IDGS: TLabel;
    edt_Dossier: TEdit;
    edt_DB: TEdit;
    edt_IDGS: TEdit;
    Nbt_DBLan: TBitBtn;
    Nbt_DBDir: TBitBtn;
    Gbx_ParametreGeneraux: TGroupBox;
    Lab_Domaine: TLabel;
    Lab_Axe: TLabel;
    Lab_TVA: TLabel;
    Lab_Garantie: TLabel;
    Lab_TypeComptable: TLabel;
    Gbx_Commentaires: TGroupBox;
    DBMemo1: TDBMemo;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBLookupComboBox3: TDBLookupComboBox;
    DBLookupComboBox4: TDBLookupComboBox;
    DBLookupComboBox5: TDBLookupComboBox;
    Ds_: TDataSource;
    Gbx_Magasin: TGroupBox;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1DBTableView1MAG_NOM: TcxGridDBColumn;
    cxGrid1DBTableView1VIL_NOM: TcxGridDBColumn;
    cxGrid1DBTableView1PRM_STRING: TcxGridDBColumn;
    cxGrid1DBTableView1USR_NOM: TcxGridDBColumn;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1DBTableView1TYPE_MAG: TcxGridDBColumn;
    Lab_Fournisseur: TLabel;
    DBLookupComboBox6: TDBLookupComboBox;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}



end.
