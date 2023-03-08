unit adh_frm;

interface

uses
  ChxMag_frm,
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, Db, IBCustomDataSet, IBQuery, IBDatabase;

type
  Tfrm_adh = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    ed_code: TEdit;
    Label2: TLabel;
    ed_nom: TEdit;
    Label3: TLabel;
    ed_base: TEdit;
    SpeedButton1: TSpeedButton;
    od: TOpenDialog;
    data: TIBDatabase;
    tran: TIBTransaction;
    qry: TIBQuery;
    procedure SpeedButton1Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    magid:integer ;
  end;

var
  frm_adh: Tfrm_adh;

implementation

{$R *.DFM}

procedure Tfrm_adh.SpeedButton1Click(Sender: TObject);
begin
  IF od.execute then
    ed_base.Text := od.FileName ;
end;

procedure Tfrm_adh.OKBtnClick(Sender: TObject);
Var
  i : integer ;
begin
  data.close ;
  data.DatabaseName := ed_base.text ;
  data.open ;
  qry.open ;
  application.createform(Tfrm_ChxMag,frm_ChxMag) ;
  qry.first ;
  WHILE not qry.eof do
  begin
    i := qry.fieldbyname('MAG_ID').AsInteger ;
    frm_ChxMag.Lb_Mag.items.AddObject(qry.fieldbyname('MAG_NOM').aSString,Pointer(i)) ;
    qry.next ;
  END ;
  frm_ChxMag.Lb_Mag.itemindex := 0 ;
  IF frm_ChxMag.ShowModal=mrok then
  begin
    magid := Integer(frm_ChxMag.Lb_Mag.items.objects[frm_ChxMag.Lb_Mag.itemindex]) ;
    modalresult := mrok ;
  END ;
end;

end.
