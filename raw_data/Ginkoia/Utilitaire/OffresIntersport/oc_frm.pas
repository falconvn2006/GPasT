unit oc_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IBDatabase, DB, StdCtrls, Mask, wwdbedit, dxmdaset, IBCustomDataSet,
  IBTable, IBQuery;

type
  TFrm_MainOffre = class(TForm)
    Chp_base: TwwDBEdit;
    ODBase: TOpenDialog;
    Ginkoia: TIBDatabase;
    tran: TIBTransaction;
    Btn_trait: TButton;
    Btn_base: TButton;
    MemD_oc: TdxMemData;
    MemD_ocID: TWordField;
    MemD_ocOC: TStringField;
    T_OC: TIBTable;
    T_type: TIBTable;
    Qry: TIBQuery;
    T_OCOCC_ID: TIntegerField;
    T_OCOCC_NOM: TIBStringField;
    T_OCOCC_IDCENTRALE: TIBStringField;
    T_OCOCC_MTYID: TIntegerField;
    T_typeMTY_ID: TIntegerField;
    T_typeMTY_NOM: TIBStringField;
    T_typeMTY_CLTIDPRO: TIntegerField;
    T_typeMTY_MULTI: TIntegerField;
    Qry_up: TIBQuery;
    procedure Btn_baseClick(Sender: TObject);
    procedure Btn_traitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_MainOffre: TFrm_MainOffre;

implementation
uses
  uVersion;
{$R *.dfm}

procedure TFrm_MainOffre.Btn_baseClick(Sender: TObject);
begin
  IF ODBase.Execute THEN
  BEGIN
    chp_base.text := ODbase.files[0];
    ginkoia.close;
    ginkoia.databasename := ODbase.files[0];
    ginkoia.Open;
  END;
end;

procedure TFrm_MainOffre.Btn_traitClick(Sender: TObject);
var
  id: integer;
begin
  memd_oc.DelimiterChar:=';';
  memd_oc.LoadFromTextFile(ExtractFilePath(application.exename)+'OffresIntersport.csv');

  T_type.open;
  if not t_type.Locate('MTY_NOM', 'RESERVATION INTERSPORT', [])then
  begin
    showmessage('Impossible version trop ancienne...');
    application.Terminate;
  end;

  T_OC.Open;

  // Ouverture ficghier CSV
  memd_oc.First;
  while not memd_oc.eof do
  begin
    if t_oc.Locate('OCC_IDCENTRALE;OCC_MTYID',
     VarArrayOf([MemD_ocID.asstring, T_typeMTY_ID.asinteger]), []) then
    begin //Existe modif du libelle
      t_oc.edit;
      T_OCOCC_NOM.AsString := MemD_ocOC.asstring;
      t_oc.Post;

      qry_up.close;
      qry_up.parambyname('ID').asinteger := T_OCOCC_ID.asinteger;
      qry_up.ExecSQL;
    end
    else
    begin //Existe pas creation
      qry.close;
      qry.sql.text := 'SELECT ID FROM PR_NEWK (''LOCCENTRALEOC'')';
      qry.Open;
      id := qry.Fields[0].Asinteger;

      t_oc.Insert;
      T_OCOCC_ID.asinteger := id;
      T_OCOCC_NOM.AsString := MemD_ocOC.asstring;
      T_OCOCC_IDCENTRALE.AsString := MemD_ocID.asstring;
      T_OCOCC_MTYID.asinteger := T_typeMTY_ID.asinteger;
      t_oc.Post;
    end;

    // Lzecture ligne CSV suivante
    memd_oc.Next;

  end; //While not EOF
  tran.commit;
  showmessage('Traitement terminé');

end;

procedure TFrm_MainOffre.FormShow(Sender: TObject);
begin
  Caption := Format('Mise à jour des offres Intersport (Module réservation) Version %s',[GetNumVersionSoft]);
end;

end.
