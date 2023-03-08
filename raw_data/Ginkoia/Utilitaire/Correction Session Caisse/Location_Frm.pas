unit Location_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, IBODataset, Grids, DBGrids, Menus,
  dxmdaset;

type
  Trm_Location = class(TForm)
    pnlTop: TPanel;
    Gbx_InfoSession: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edt_Num: TEdit;
    Edt_ID: TEdit;
    Edt_Ecart: TEdit;
    Nbt_cancel: TBitBtn;
    btnGLobalAction: TBitBtn;
    pnlEnteteLocation: TPanel;
    pnlLignesLOcation: TPanel;
    grpEneteLocation: TGroupBox;
    grpLignesLocation: TGroupBox;
    dsLocationEntete: TDataSource;
    dsLocationLigne: TDataSource;
    dbgLocationLigne: TDBGrid;
    pmGlobalAction: TPopupMenu;
    mniEntete: TMenuItem;
    mniLignes: TMenuItem;
    mniEnteteDetail: TMenuItem;
    mniLigneDetail: TMenuItem;
    mdtEntete: TdxMemData;
    mdtLigne: TdxMemData;
    lblTkeID: TLabel;
    edtTkeID: TEdit;
    lblLocNum: TLabel;
    edtLocNum: TEdit;
    Label15: TLabel;
    Label26: TLabel;
    Label25: TLabel;
    Edt_DiffEntArt: TEdit;
    Edt_DiffEntCsh: TEdit;
    Edt_EntTot: TEdit;
    lblLocID: TLabel;
    edtLocID: TEdit;
    mdtEnteteTKE_ID: TIntegerField;
    mdtEnteteLOC_ID: TIntegerField;
    mdtEnteteLOC_NUMERO: TStringField;
    mdtLigneLOA_ID: TIntegerField;
    mdtLigneLOA_PXBRUT: TFloatField;
    mdtLigneLOA_REMISE: TFloatField;
    mdtLigneLOA_PXNET: TFloatField;
    mdtLigneLOA_ASSUR: TFloatField;
    mdtLigneLOA_PXNN: TFloatField;
    mdtLigneLOA_DJPPRIX: TFloatField;
    mdtLigneLOA_DJPASSUR: TStringField;
    procedure btnGLobalActionClick(Sender: TObject);
    procedure mniEnteteDetailClick(Sender: TObject);
    procedure mniLigneDetailClick(Sender: TObject);
  private
    { Déclarations privées }
    SesNum : string;
    SesID : integer;
    TkeID : integer;
    LocID : Integer;
  public
    { Déclarations publiques }
    procedure InitEcr(ASesNum: string; ASesID: integer; AEcart: string; ATkeID: integer);
  end;

implementation

{$R *.dfm}

uses
  Detail_Frm, Main_Dm;

procedure Trm_Location.btnGLobalActionClick(Sender: TObject);
var
  pt : TPoint;
begin
  GetCursorPos(pt);
  pmGlobalAction.Popup(pt.X,pt.y);
end;

procedure Trm_Location.InitEcr(ASesNum: string; ASesID: integer; AEcart: string; ATkeID: integer);
begin
  Screen.Cursor := crHourGlass;
  try
    // svg des info
    SesNum := ASesNum;
    SesID := ASesID;
    TkeID := ATkeID;
    LocID := 0;

    // info session
    Edt_Num.Text := SesNum;
    Edt_ID.Text := IntToStr(SesID);
    Edt_Ecart.Text := AEcart;

    // info du ticket
    Dm_Main.Que_Div.Close();
    Dm_Main.Que_Div.SQL.Text := 'select * from cshticket where tke_id = ' + IntToStr(TkeID);
    try
      Dm_Main.Que_Div.Open();
      if not Dm_Main.Que_Div.Eof then
      begin
        // récup des info du ticket ...
// TODO - obpy : récup des info du ticket ...
        edtTkeID.Text := Dm_Main.Que_Div.FieldByName('tke_id').AsString;
        Edt_EntTot.Text := FloatToStr(Dm_Main.Que_Div.FieldByName('tke_totneta2').AsFloat);

        // info entete
        Dm_Main.Que_Div2.Close();
        Dm_Main.Que_Div2.SQL.Text := 'select * from locbonlocation where loc_tkeid = ' + IntToStr(TkeID);
        try
          Dm_Main.Que_Div2.Open();
          if not Dm_Main.Que_Div2.Eof then
          begin
            // récup des données de l'entete
            LocID := Dm_Main.Que_Div2.FieldByName('loc_id').AsInteger;
// TODO - obpy : récup des données de l'entete
            edtLocID.Text := Dm_Main.Que_Div2.FieldByName('loc_id').AsString;
            edtLocNum.Text := Dm_Main.Que_Div2.FieldByName('loc_numerounique').AsString;

//            mdtEntete.Close();
//            mdtEntete.Open();
//            mdtEntete.Append();
//            mdtEntete.FieldByName('tke_id').AsInteger := TkeID;
//            mdtEntete.FieldByName('loc_id').AsInteger := Dm_Main.Que_Div2.FieldByName('loc_id').AsInteger;
//            mdtEntete.FieldByName('loc_numero').AsString := Dm_Main.Que_Div2.FieldByName('loc_numerounique').AsString;
//            mdtEntete.Post();

            // ajout des lignes
            mdtLigne.Close();
            mdtLigne.Open();

            // infos Lignes
            Dm_Main.Que_Div3.Close();
            Dm_Main.Que_Div3.SQL.Text := 'select * from locbonlocationligne where loa_locid = ' + IntToStr(LocID);
            try
              Dm_Main.Que_Div3.Open();
              while not Dm_Main.Que_Div3.Eof do
              begin
                // récup des données des lignes
// TODO - obpy : récup des données des lignes
                mdtLigne.Append();
                mdtLigne.FieldByName('loa_id').AsInteger := Dm_Main.Que_Div3.FieldByName('loa_id').AsInteger;
                mdtLigne.FieldByName('loa_pxbrut').AsFloat := Dm_Main.Que_Div3.FieldByName('loa_pxbrut').AsFloat;
                mdtLigne.FieldByName('loa_remise').AsFloat := Dm_Main.Que_Div3.FieldByName('loa_remise').AsFloat;
                mdtLigne.FieldByName('loa_pxnet').AsFloat := Dm_Main.Que_Div3.FieldByName('loa_pxnet').AsFloat;
                mdtLigne.FieldByName('loa_assur').AsFloat := Dm_Main.Que_Div3.FieldByName('loa_assur').AsFloat;
                mdtLigne.FieldByName('loa_pxnn').AsFloat := Dm_Main.Que_Div3.FieldByName('loa_pxnn').AsFloat;
                mdtLigne.FieldByName('loa_djpprix').AsFloat := Dm_Main.Que_Div3.FieldByName('loa_djpprix').AsFloat;
                mdtLigne.FieldByName('loa_djpassur').AsFloat := Dm_Main.Que_Div3.FieldByName('loa_djpassur').AsFloat;
                mdtLigne.Post();

                Dm_Main.Que_Div3.Next();
              end;
            finally
              Dm_Main.Que_Div3.Close();
            end;
          end;
        finally
          Dm_Main.Que_Div2.Close();
        end;
      end;
    finally
      Dm_Main.Que_Div.Close();
    end;

    // affichage !
//    edtTkeID.Text := ;
//    edtLocID.Text := ;
//    edtLocNum.Text := ;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure Trm_Location.mniEnteteDetailClick(Sender: TObject);
var
  Frm_Detail : TFrm_Detail;
begin
  Frm_Detail := TFrm_Detail.Create(Self);
  try
    Frm_Detail.InitEcr('select locbonlocation.* from locbonlocation join k on k_id = loc_id and k_enabled = 1 where loc_id = ' + inttostr(LocID), 'locbonlocation', 'loc_id');
    Frm_Detail.ShowModal();
  finally
    FreeAndNil(Frm_Detail);
  end;
end;

procedure Trm_Location.mniLigneDetailClick(Sender: TObject);
var
  Frm_Detail : TFrm_Detail;
begin
  Frm_Detail := TFrm_Detail.Create(Self);
  try
    Frm_Detail.InitEcr('select locbonlocationligne.* from locbonlocationligne join k on k_id = loa_id and k_enabled = 1 where loa_locid = ' + inttostr(LocID), 'locbonlocationligne', 'loa_id');
    Frm_Detail.ShowModal();
  finally
    FreeAndNil(Frm_Detail);
  end;
end;

end.
