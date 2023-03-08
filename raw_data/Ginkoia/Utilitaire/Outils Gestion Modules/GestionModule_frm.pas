UNIT GestionModule_frm;

INTERFACE

USES
    ChxNomGroupe,
    ClipBrd,
    ChxPermissions,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, Buttons, ComCtrls, ExtCtrls, IBDatabase, Db, IBCustomDataSet,
    IBQuery, IBSQL, Menus, Winapi.ShellAPI;

TYPE
    TFrm_GestionModule = CLASS(TForm)
        OD: TOpenDialog;
        Panel1: TPanel;
        Btn_OuvrirBase: TButton;
        Ed_Base: TEdit;
        Nbt_RechBase: TSpeedButton;
        Label1: TLabel;
        Pgc_Groupes: TPageControl;
        TabSheet1: TTabSheet;
        TabSheet2: TTabSheet;
        Lbx_Groupes: TListBox;
        Label2: TLabel;
        Label3: TLabel;
        Lbx_Droits: TListBox;
        Button1: TButton;
        Button2: TButton;
        Data: TIBDatabase;
        tran: TIBTransaction;
        IBQue_ListPerm: TIBQuery;
        IBQue_ListPermPER_PERMISSION: TIBStringField;
        IBQue_ListGroupe: TIBQuery;
        IBQue_ListGroupeUGG_ID: TIntegerField;
        IBQue_ListGroupeUGG_NOM: TIBStringField;
        IBQue_ListGroupeUGG_COMMENT: TIBStringField;
        Mem_Com: TMemo;
        Sql: TIBSQL;
        IBQue_LeId: TIBQuery;
        IBQue_LeIdNEWKEY: TIntegerField;
        IBQue_LstPerm: TIBQuery;
        IBQue_LstPermUGG_COMMENT: TIBStringField;
        IBQue_LstPermUGL_ID: TIntegerField;
        IBQue_LstPermPER_PERMISSION: TIBStringField;
        IBQue_ListPermPER_ID: TIntegerField;
        TabSheet3: TTabSheet;
        Lbx_Mag: TListBox;
        Label4: TLabel;
        Lbx_GrpMag: TListBox;
        Label5: TLabel;
        IBQue_Magasins: TIBQuery;
        IBQue_MagasinsMAG_ID: TIntegerField;
        IBQue_MagasinsMAG_NOM: TIBStringField;
        IBQue_GrpMag: TIBQuery;
        IBQue_GrpMagUGM_ID: TIntegerField;
        IBQue_GrpMagUGG_NOM: TIBStringField;
        IBQue_GrpMagUGM_DATE: TDateTimeField;
        Button3: TButton;
        IBQue_AjouteGroupe: TIBQuery;
        IBQue_AjouteGroupel: TIBQuery;
        IBQue_AjouteGroupeID: TIntegerField;
        IBQue_AjouteGroupelID: TIntegerField;
        Button4: TButton;
        IBQue_AjLiaisonMag: TIBQuery;
        IntegerField1: TIntegerField;
        Label6: TLabel;
        ed_DateMax: TEdit;
        IBQue_SupGroupel: TIBQuery;
        Lbx_Util: TListBox;
        Button5: TButton;
        IBQue_LstNonAff: TIBQuery;
        IBQue_LstNonAffPER_PERMISSION: TIBStringField;
    PopupMenu1: TPopupMenu;
    Copytoclipboard1: TMenuItem;
        PROCEDURE Nbt_RechBaseClick(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormDestroy(Sender: TObject);
        PROCEDURE Lbx_GroupesClick(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
        PROCEDURE Btn_OuvrirBaseClick(Sender: TObject);
        PROCEDURE Lbx_DroitsKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE Lbx_MagClick(Sender: TObject);
        PROCEDURE Button3Click(Sender: TObject);
        PROCEDURE Lbx_GrpMagKeyDown(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE Button5Click(Sender: TObject);
    procedure Copytoclipboard1Click(Sender: TObject);
    PRIVATE
    { Déclarations privées }
      procedure MessageDropFiles(var msg : TWMDropFiles); message WM_DROPFILES;
    PUBLIC
    { Déclarations publiques }
        Lesgroupes: tstringlist;
        ListePermission: tstringlist;
        First: Boolean;
        Lesmodif: tstringlist;
        FUNCTION UnID: Integer;
    END;

VAR
    Frm_GestionModule: TFrm_GestionModule;

IMPLEMENTATION

{$R *.DFM}

uses
  System.StrUtils;

PROCEDURE TFrm_GestionModule.Nbt_RechBaseClick(Sender: TObject);
BEGIN
    IF od.execute THEN
        ed_base.text := Od.filename;
END;

PROCEDURE TFrm_GestionModule.FormCreate(Sender: TObject);
  procedure splitParam(aStr, aName : string ; var aResult : string);
  begin
    if (UpperCase(LeftStr(aStr, Length(aName))) = UpperCase(aName)) then
    begin
      aResult := copy(aStr, Length(aName)+1, Length(aStr) - Length(aName)) ;
    end;
  end;
var
  i : Integer;
  Param : string;
  vChemin : string;
BEGIN
    // Gestion du drag ans drop
    DragAcceptFiles(Handle, True);
    ListePermission := tstringlist.Create;
    Lesgroupes := tstringlist.Create;
    first := true;
    Lesmodif := tstringlist.Create;
    IF fileexists(ChangeFileExt(Application.exename, '.LOG')) THEN
        Lesmodif.Loadfromfile(ChangeFileExt(Application.exename, '.LOG'));

    vChemin := '';
    for i := 1 to ParamCount do
    begin
      Param := ParamStr(i);
      splitParam(Param, '/BASE=', vChemin);
    end;

    if vChemin <> '' then
    begin
      ed_base.text := vChemin;
      Btn_OuvrirBaseClick(nil);
    end;
END;

PROCEDURE TFrm_GestionModule.FormDestroy(Sender: TObject);
BEGIN
    Lesmodif.Savetofile(ChangeFileExt(Application.exename, '.LOG'));
    Lesmodif.free;
    ListePermission.Free;
    Lesgroupes.free;
END;

PROCEDURE TFrm_GestionModule.Lbx_GroupesClick(Sender: TObject);
VAR
    i: integer;
BEGIN
    IF Lbx_Groupes.ItemIndex >= 0 THEN
    BEGIN
        i := Integer(Lbx_Groupes.Items.Objects[Lbx_Groupes.ItemIndex]);
        IBQue_LstPerm.Close;
        IBQue_LstPerm.ParamByName('ID').AsInteger := I;
        IBQue_LstPerm.Open;
        IBQue_LstPerm.First;
        IF NOT IBQue_LstPerm.isempty THEN
            Mem_Com.Lines.text := IBQue_LstPermUGG_COMMENT.AsString;
        Lbx_Droits.Items.Clear;
        WHILE NOT IBQue_LstPerm.Eof DO
        BEGIN
            Lbx_Droits.Items.AddObject(IBQue_LstPermPER_PERMISSION.AsString, Pointer(IBQue_LstPermUGL_ID.AsInteger));
            IBQue_LstPerm.Next;
        END;
        IBQue_LstPerm.Close;
    END;
END;

PROCEDURE TFrm_GestionModule.Button1Click(Sender: TObject);
VAR
    Frm_Groupe: TFrm_Groupe;
BEGIN
    Application.CreateForm(TFrm_Groupe, Frm_Groupe);
    TRY
        IF (Frm_Groupe.ShowModal = MrOk) AND (trim(Frm_Groupe.Edit1.Text) <> '') THEN
        BEGIN
            IF Lesgroupes.IndexOf(Uppercase(trim(Frm_Groupe.Edit1.Text))) < 0 THEN
            BEGIN
                IF first THEN
                    Lesmodif.add(DateTimetostr(now));
                first := false;
                Lesmodif.add('EXECUTE PROCEDURE PR_GRPAJOUTE( ' +  QuotedStr(Uppercase(trim(Frm_Groupe.Edit1.Text))) + ',' + QuotedStr(Frm_Groupe.Memo1.Lines.Text) + ')');
                IBQue_AjouteGroupe.paramByName('NOM').AsString := Uppercase(trim(Frm_Groupe.Edit1.Text));
                IBQue_AjouteGroupe.paramByName('COMMENT').AsString := Frm_Groupe.Memo1.Lines.Text;
                IBQue_AjouteGroupe.Open;
                IBQue_AjouteGroupe.Close;
                IF tran.InTransaction THEN
                    tran.commit;
                tran.active := true;

                Lesgroupes.Clear;
                IBQue_ListGroupe.Open;
                IBQue_ListGroupe.First;
                WHILE NOT IBQue_ListGroupe.eof DO
                BEGIN
                    LesGroupes.AddObject(IBQue_ListGroupeUGG_NOM.AsString, Pointer(IBQue_ListGroupeUGG_ID.AsInteger));
                    IBQue_ListGroupe.next;
                END;
                IBQue_ListGroupe.Close;
                Lbx_Groupes.Items.Assign(LesGroupes);
            END;
        END;
    FINALLY
        Frm_Groupe.release;
    END;
END;

PROCEDURE TFrm_GestionModule.Button2Click(Sender: TObject);
VAR
    CxhPermission: TCxhPermission;
    i: integer;
BEGIN
    Application.CreateForm(TCxhPermission, CxhPermission);
    TRY
        IF CxhPermission.execute(' Choisir les permissions', ListePermission, Lbx_Droits.Items) = MrOk THEN
        BEGIN
            IF first THEN
                Lesmodif.add(DateTimetostr(now));
            first := false;

            FOR i := 0 TO CxhPermission.Selection.count - 1 DO
            BEGIN
                // LesDroits.add(Lbx_Groupes.items[Lbx_Groupes.ItemIndex] + ';' + CxhPermission.Selection[i]);
                Lesmodif.add('EXECUTE PROCEDURE PR_GRPLAJOUTE( ' + QuotedStr(LBX_Groupes.Items[LBX_Groupes.ItemIndex]) + ',' + QuotedStr(CxhPermission.Selection[i]) + ')');
                IBQue_AjouteGroupel.ParamByName('NOMPER').AsString := CxhPermission.Selection[i];
                IBQue_AjouteGroupel.ParamByName('NOMGRP').AsString := LBX_Groupes.Items[LBX_Groupes.ItemIndex];
                IBQue_AjouteGroupel.Open;
                IBQue_AjouteGroupel.Close;
            END;
            IF tran.InTransaction THEN
                tran.commit;
            tran.active := true;
            Lbx_GroupesClick(NIL);
        END
    FINALLY
        CxhPermission.release;
    END;
END;

PROCEDURE TFrm_GestionModule.Btn_OuvrirBaseClick(Sender: TObject);
BEGIN
    ListePermission.Clear;
    Data.Close;
    Data.DatabaseName := ed_Base.text;
    Data.Open;
    ListePermission.Clear ;
    IBQue_ListPerm.Open;
    IBQue_ListPerm.first;
    WHILE NOT IBQue_ListPerm.eof DO
    BEGIN
        ListePermission.AddObject(IBQue_ListPermPER_PERMISSION.AsString, Pointer(IBQue_ListPermPER_ID.AsInteger));
        IBQue_ListPerm.next;
    END;
    IBQue_ListPerm.close;
    IBQue_ListGroupe.Open;
    IBQue_ListGroupe.First;
    LesGroupes.Clear ;
    WHILE NOT IBQue_ListGroupe.eof DO
    BEGIN
        LesGroupes.AddObject(IBQue_ListGroupeUGG_NOM.AsString, Pointer(IBQue_ListGroupeUGG_ID.AsInteger));
        IBQue_ListGroupe.next;
    END;
    IBQue_ListGroupe.Close;
    Lbx_Groupes.Items.Assign(LesGroupes);

    Lbx_Mag.items.clear;
    IBQue_Magasins.Open;
    IBQue_Magasins.First;
    WHILE NOT IBQue_Magasins.eof DO
    BEGIN
        Lbx_Mag.items.AddObject(IBQue_MagasinsMAG_NOM.AsString, pointer(IBQue_MagasinsMAG_ID.AsInteger));
        IBQue_Magasins.next;
    END;
    IBQue_Magasins.close;
    tran.active := true;
END;

PROCEDURE TFrm_GestionModule.Lbx_DroitsKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
BEGIN
    IF (key = VK_delete) AND (Lbx_Droits.ItemIndex >= 0) THEN
    BEGIN
        IF Application.MessageBox('Etes vous sur de vouloir supprimer le droit ?', ' Suppression', Mb_YesNo OR MB_DEFBUTTON2) = MrYes THEN
        BEGIN
            IF first THEN
                Lesmodif.add(DateTimetostr(now));
            first := false;
            Lesmodif.add('EXECUTE PROCEDURE PR_GRPLSUPPRIME (' + QuotedStr(Lbx_Groupes.items[Lbx_Groupes.ItemIndex]) + ',' + QuotedStr(Lbx_Droits.items[Lbx_Droits.ItemIndex]) + ')');
            IBQue_SupGroupel.ParamByName('NOMGRP').AsString := Lbx_Groupes.items[Lbx_Groupes.ItemIndex];
            IBQue_SupGroupel.ParamByName('NOMPER').AsString := Lbx_Droits.items[Lbx_Droits.ItemIndex];
            IBQue_SupGroupel.ExecSQL;
            IF tran.InTransaction THEN
                tran.commit;
            tran.active := true;
            Lbx_GroupesClick(NIL);
        END;
    END
END;

FUNCTION TFrm_GestionModule.UnID: Integer;
BEGIN
    IBQue_LeId.Prepare;
    IBQue_LeId.open;
    result := IBQue_LeIdNEWKEY.Asinteger;
    IBQue_LeId.Close;
    IBQue_LeId.UnPrepare;
END;

PROCEDURE TFrm_GestionModule.Lbx_MagClick(Sender: TObject);
VAR
    magId: Integer;
BEGIN
    IF Lbx_mag.ItemIndex >= 0 THEN
    BEGIN
        MagId := Integer(Lbx_mag.Items.objects[Lbx_mag.ItemIndex]);
        IBQue_GrpMag.Close;
        IBQue_GrpMag.ParamByName('MAGID').AsInteger := MagId;
        IBQue_GrpMag.Open;
        IBQue_GrpMag.First;
        Lbx_GrpMag.Items.Clear;
        WHILE NOT IBQue_GrpMag.Eof DO
        BEGIN
            Lbx_GrpMag.Items.AddObject(IBQue_GrpMagUGG_NOM.AsString + ' -> ' + IBQue_GrpMagUGM_DATE.AsString, Pointer(IBQue_GrpMagUGM_ID.AsInteger));
            IBQue_GrpMag.Next;
        END;
        IBQue_GrpMag.Close;
    END;
END;

PROCEDURE TFrm_GestionModule.Button3Click(Sender: TObject);
VAR
    CxhPermission: TCxhPermission;
    magId: Integer;
    i: Integer;
BEGIN
    MagId := Integer(Lbx_mag.Items.objects[Lbx_mag.ItemIndex]);
    Application.CreateForm(TCxhPermission, CxhPermission);
    TRY
        IF CxhPermission.execute(' Choisir les groupes', Lbx_Groupes.Items, Lbx_GrpMag.Items) = MrOk THEN
        BEGIN
            FOR i := 0 TO CxhPermission.Selection.count - 1 DO
            BEGIN
                IBQue_AjLiaisonMag.ParamByName('IDMAG').AsINTEGER := MagId;
                IBQue_AjLiaisonMag.ParamByName('NOMGRP').AsString := CxhPermission.Selection[i];
                IF trim(ed_DateMax.Text) = '' THEN
                    IBQue_AjLiaisonMag.ParamByName('DATEFIN').Clear
                ELSE
                    IBQue_AjLiaisonMag.ParamByName('DATEFIN').AsDate := Strtodate(ed_DateMax.Text);
                IBQue_AjLiaisonMag.ExecSQL;
            END;
            IF tran.InTransaction THEN
                tran.commit;
            tran.active := true;
            Lbx_MagClick(NIL);
            ed_DateMax.text := '';
        END
    FINALLY
        CxhPermission.release;
    END;
END;

PROCEDURE TFrm_GestionModule.Lbx_GrpMagKeyDown(Sender: TObject;
    VAR Key: Word; Shift: TShiftState);
VAR
    i: integer;
BEGIN
    IF Lbx_GrpMag.ItemIndex >= 0 THEN
    BEGIN
        IF Application.MessageBox('Etes vous sur de vouloir supprimer le groupe ?', ' Suppression', Mb_YesNo OR MB_DEFBUTTON2) = MrYes THEN
        BEGIN
            i := Integer(Lbx_GrpMag.items.Objects[Lbx_GrpMag.ItemIndex]);
            Sql.Sql.Clear;
            Sql.Sql.Add('EXECUTE PROCEDURE PR_UPDATEK('+ Inttostr(i) +',1)');
            Sql.ExecQuery;
            IF tran.InTransaction THEN
                tran.commit;
            tran.active := true;
            Lbx_MagClick(NIL);
        END;
    END;
END;

PROCEDURE TFrm_GestionModule.Button5Click(Sender: TObject);
BEGIN
    Lbx_Util.items.clear;
    IBQue_LstNonAff.Open;
    IBQue_LstNonAff.First;
    WHILE NOT IBQue_LstNonAff.eof DO
    BEGIN
        Lbx_Util.items.add(IBQue_LstNonAffPER_PERMISSION.AsString);
        IBQue_LstNonAff.Next;
    END;
    IBQue_LstNonAff.close;
END;

procedure TFrm_GestionModule.Copytoclipboard1Click(Sender: TObject);
begin
  Clipboard.AsText := Lbx_Droits.Items.Text ;
end;

procedure TFrm_GestionModule.MessageDropFiles(var msg : TWMDropFiles);
const
  MAXFILENAME = 255;
var
  i, Count : integer;
  FileName : array [0..MAXFILENAME] of char;
  FileExt : string;
begin
  try
    // le nb de fichier
    Count := DragQueryFile(msg.Drop, $FFFFFFFF, FileName, MAXFILENAME);
    // Recuperation des fichier (nom)
    for i := 0 to Count -1 do
    begin
      DragQueryFile(msg.Drop, i, FileName, MAXFILENAME);
      FileExt := UpperCase(ExtractFileExt(FileName));
      if FileExt = '.IB' then
      begin
        ed_base.text := FileName;
        Btn_OuvrirBaseClick(nil);
        Break;
      end;
    end;
  finally
    DragFinish(msg.Drop);
  end;
end;

END.

