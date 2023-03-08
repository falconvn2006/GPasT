UNIT Inventoriste_frm;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Db,
  IBCustomDataSet,
  IBDatabase,
  IBQuery,
  ExtCtrls,
  StdCtrls,
  Buttons, Progbr3d, DBCtrls;

TYPE
  TFrm_Inventoriste = CLASS(TForm)
    Data: TIBDatabase;
    que_art: TIBQuery;
    IBTransaction1: TIBTransaction;
    LMDSpeedButton1: TSpeedButton;
    que_artART_NOM: TIBStringField;
    que_artARF_ID: TIntegerField;
    que_cb: TIBQuery;
    que_cbCBI_CB: TIBStringField;
    que_cbCOU_NOM: TIBStringField;
    que_cbTGF_NOM: TIBStringField;
    PrgB_Iec: ProgressBar3D;
    Label1: TLabel;
    Ed_Base: TEdit;
    Nbt_RechBase: TSpeedButton;
    OD: TOpenDialog;
    Nbt_loc: TSpeedButton;
    Que_cbloc: TIBQuery;
    Que_cblocCBI_CB: TIBStringField;
    Que_cblocNOM: TIBStringField;
    Nbt_Invart: TSpeedButton;
    Que_Mag: TIBQuery;
    Que_MagMAG_NOM: TStringField;
    Que_MagMAG_CODEADH: TStringField;
    Ds_Mag: TDataSource;
    PROCEDURE LMDSpeedButton1Click(Sender: TObject);
    PROCEDURE Nbt_RechBaseClick(Sender: TObject);
    PROCEDURE Nbt_locClick(Sender: TObject);
  PRIVATE
    { Déclarations privées }
    fichier: tstrings;
  PUBLIC
    { Déclarations publiques }
  END;

VAR
  Frm_Inventoriste: TFrm_Inventoriste;

IMPLEMENTATION
{$R *.DFM}

uses
  UMagasins;

PROCEDURE TFrm_Inventoriste.LMDSpeedButton1Click(Sender: TObject);
VAR
  s,chem: STRING;
  i: integer;
BEGIN
  Data.Close;
  Data.DatabaseName := ed_Base.text;
  Data.Open;
  ed_base.text := uppercase(ed_base.text);

  // si invart, afficher dialogue liste des magasins pour sélection d'une valeur MAG_CODEADH
  if TGraphicControl( Sender ).Tag = 1 then
  begin
    que_mag.Open;
    if FrmMagasins.ShowModal <> mrOK then Exit;
  end;

  screen.cursor := crsqlwait;
  i := pos('GINKOIA.', ed_base.text);
  chem := copy(ed_base.text, 1, i - 1);

  fichier := TStringList.Create;
  que_art.open;
  WHILE NOT que_art.eof DO
  BEGIN
    PrgB_Iec.maxvalue := que_art.recordcount;
    que_art.next;
  END;

  que_art.first;
  Prgb_Iec.progress := 0;
  WHILE NOT que_art.eof DO
  BEGIN
    PrgB_IEC.AddProgress(1);
    que_cb.close;
    que_cb.parambyname('arfid').asinteger := que_artARF_ID.asinteger;
    que_cb.open;
    WHILE NOT que_cb.eof DO
    BEGIN
      if TGraphicControl( Sender ).Tag = 1 then
      begin
        s := que_cbCBI_CB.asstring + '|' + Copy( que_artART_NOM.asstring + que_cbCOU_NOM.asstring, 1, 50 ) + '|' + 'A' + '|' + que_cbTGF_NOM.asstring;
      end else begin
        s := que_cbCBI_CB.asstring + #59 + que_artART_NOM.asstring + '(' + que_cbTGF_NOM.asstring + '/' + que_cbCOU_NOM.asstring + ')'
      end;
      fichier.Add( s );
      que_cb.next
    END;
    Application.processmessages;
    que_art.next;
  END;

  if TGraphicControl( Sender ).Tag = 1 then
  begin
    fichier.SaveToFile( chem + 'INVART' + Copy( que_magMAG_CODEADH.AsString, 1, 4 ) + '.00001');
  end else begin
    fichier.SaveToFile( chem + 'Inventoriste.txt' );
  end;
  screen.cursor := crdefault;
  MessageDlg('Traitement terminé', mtInformation, [mbOK], 0);

END;

PROCEDURE TFrm_Inventoriste.Nbt_locClick(Sender: TObject);
VAR
  chem: STRING;
  i: integer;
BEGIN
  screen.cursor := crsqlwait;
  Data.Close;
  Data.DatabaseName := ed_Base.text;
  Data.Open;
  ed_base.text := uppercase(ed_base.text);

  i := pos('GINKOIA.', ed_base.text);
  chem := copy(ed_base.text, 1, i - 1);

  fichier := TStringList.Create;
  que_cbloc.open;
  que_cbloc.FetchAll;
  PrgB_Iec.maxvalue := que_cbloc.recordcount;

  que_cbloc.first;
  Prgb_Iec.progress := 0;

  WHILE NOT que_cbloc.eof DO
  BEGIN
     PrgB_IEC.AddProgress(1);
    fichier.add(Que_cblocCBI_CB.asstring + #59 +
      Que_cblocNOM.asstring);

    Application.processmessages;
    que_cbloc.next;
  END;
  fichier.SaveToFile(chem + 'InventoristeLocation.txt');
  screen.cursor := crdefault;
  MessageDlg('Traitement terminé', mtInformation, [mbOK], 0);

END;

PROCEDURE TFrm_Inventoriste.Nbt_RechBaseClick(Sender: TObject);
BEGIN
  IF od.execute THEN
    ed_base.text := Od.filename;
END;

END.

