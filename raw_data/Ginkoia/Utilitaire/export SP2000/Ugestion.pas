unit Ugestion;

interface

uses
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   ExtCtrls, ComCtrls, StdCtrls, CheckLst, Buttons, Db, IBCustomDataSet,
   IBQuery, IBDatabase, IBSQL, Menus;

type
   TFrm_Gestion = class(TForm)
      PC: TPageControl;
      TS_GESTION: TTabSheet;
      Panel1: TPanel;
      Splitter1: TSplitter;
      Panel2: TPanel;
      data: TIBDatabase;
      tran: TIBTransaction;
      IBQue_BDE: TIBQuery;
      IBQue_BDEBDE_ID: TIntegerField;
      IBQue_BDEBDE_PATH: TIBStringField;
      IBQue_BDEBDE_NOM: TIBStringField;
      Clef: TIBQuery;
      Panel3: TPanel;
      LB_BASE: TListBox;
      Panel4: TPanel;
      Panel5: TPanel;
      Ed_PathBase: TEdit;
      Label1: TLabel;
      Label2: TLabel;
      Ed_NomBase: TEdit;
      CL_Magasin: TCheckListBox;
      Panel6: TPanel;
      OD: TOpenDialog;
      database: TIBDatabase;
      Tranbase: TIBTransaction;
      IBQue_Lesmagasins: TIBQuery;
      IBQue_LesmagasinsMAG_ID: TIntegerField;
      IBQue_LesmagasinsMAG_IDENT: TIBStringField;
      IBQue_LesmagasinsMAG_NOM: TIBStringField;
      IBQue_LesmagasinsMAG_SOCID: TIntegerField;
      IBQue_LesmagasinsMAG_ADRID: TIntegerField;
      IBQue_LesmagasinsMAG_TVTID: TIntegerField;
      IBQue_LesmagasinsMAG_TEL: TIBStringField;
      IBQue_LesmagasinsMAG_FAX: TIBStringField;
      IBQue_LesmagasinsMAG_EMAIL: TIBStringField;
      IBQue_LesmagasinsMAG_SIRET: TIBStringField;
      IBQue_LesmagasinsMAG_CODEADH: TIBStringField;
      IBQue_LesmagasinsMAG_NATURE: TIntegerField;
      IBQue_LesmagasinsMAG_TRANSFERT: TIntegerField;
      IBQue_LesmagasinsMAG_SS: TIntegerField;
      IBQue_LesmagasinsMAG_HUSKY: TIntegerField;
      IBQue_LesmagasinsMAG_IDENTCOURT: TIBStringField;
      IBQue_LesmagasinsMAG_COMENT: TIBStringField;
      IBQue_LesmagasinsMAG_ARRONDI: TIntegerField;
      IBQue_LesmagasinsMAG_GCLID: TIntegerField;
      IBQue_LesmagasinsMAG_ENSEIGNE: TIBStringField;
      IBQue_LesmagasinsMAG_FACID: TIntegerField;
      IBQue_LesmagasinsMAG_LIVID: TIntegerField;
      IBQue_LesmagasinsMAG_COULMAG: TIntegerField;
      IBQue_LesmagasinsMAG_MTAID: TIntegerField;
      IBQue_LesmagasinsMAG_CLTHABITUEL: TIntegerField;
      IBQue_LesmagasinsK_ID: TIntegerField;
      IBQue_LesmagasinsKRH_ID: TIntegerField;
      IBQue_LesmagasinsKTB_ID: TIntegerField;
      IBQue_LesmagasinsK_VERSION: TIntegerField;
      IBQue_LesmagasinsK_ENABLED: TIntegerField;
      IBQue_LesmagasinsKSE_OWNER_ID: TIntegerField;
      IBQue_LesmagasinsKSE_INSERT_ID: TIntegerField;
      IBQue_LesmagasinsK_INSERTED: TDateTimeField;
      IBQue_LesmagasinsKSE_DELETE_ID: TIntegerField;
      IBQue_LesmagasinsK_DELETED: TDateTimeField;
      IBQue_LesmagasinsKSE_UPDATE_ID: TIntegerField;
      IBQue_LesmagasinsK_UPDATED: TDateTimeField;
      IBQue_LesmagasinsKSE_LOCK_ID: TIntegerField;
      IBQue_LesmagasinsKMA_LOCK_ID: TIntegerField;
      IBQue_Magasin: TIBQuery;
      ClefCLEF: TIntegerField;
      IBQue_MagasinMAG_ID: TIntegerField;
      IBQue_MagasinMAG_BDEID: TIntegerField;
      IBQue_MagasinMAG_GINKOID: TIntegerField;
      IBQue_MagasinMAG_ENABLED: TIntegerField;
      IBQue_MagasinMAG_LASTEXP: TDateTimeField;
      Bt_Valider: TButton;
      IBQue_MagasinMAG_NOM: TIBStringField;
      sql: TIBSQL;
      Button2: TButton;
      menumod: TPopupMenu;
      Modifierladatedexport1: TMenuItem;
      req: TIBQuery;
    tran2: TIBTransaction;
    Label3: TLabel;
      procedure Button2Click(Sender: TObject);
      procedure CL_MagasinClickCheck(Sender: TObject);
      procedure LB_BASEClick(Sender: TObject);
      procedure FormActivate(Sender: TObject);
      procedure Bt_ValiderClick(Sender: TObject);
      procedure Modifierladatedexport1Click(Sender: TObject);
   private
    { Déclarations privées }
   public
    { Déclarations publiques }
   end;

var
   Frm_Gestion: TFrm_Gestion;

implementation
{$R *.DFM}

uses
   date_frm;

procedure TFrm_Gestion.Button2Click(Sender: TObject);
var
   Path: string;
   basid,
      magid: integer;
   i: integer;
   S: string;
   S1: string;
begin
   if od.Execute then
   begin
      Path := Od.filename;
      database.DatabaseName := PAth;
      try
         try
            database.Open;
         except
            if copy(Path, 1, 2) = '\\' then
            begin
               S := path;
               delete(S, 1, 2);
               i := pos('\', S);
               S[i] := ':';
               i := pos('\', S);
               insert(':', S, i);
               database.DatabaseName := S;
               try
                  database.Open;
                  Path := S;
               except
                  S := path;
                  delete(S, 1, 2);
                  S1 := Copy(S, 1, Pos('\', S) - 1);
                  Delete(S, 1, Pos('\', S) - 1);
                  Path := S1 + ':D:' + S;
                  database.DatabaseName := Path;
                  database.Open;
               end;
            end
            else
               raise;
         end;
         IBQue_Lesmagasins.open;
         S := Uppercase(ExcludeTrailingBackslash(ExtractFilePath(path)));
         if pos('\DATA', S) > 0 then
            delete(S, pos('\DATA', S), 5);
         while pos('\', S) > 0 do
            delete(S, 1, pos('\', S));
         while pos('/', S) > 0 do
            delete(S, 1, pos('/', S));

         Clef.open; basid := ClefCLEF.asinteger; clef.close;
         Sql.sql.text := 'INSERT INTO BASEDEDONNES (BDE_ID,BDE_PATH,BDE_NOM) VALUES (' +
            Inttostr(BasId) + ',' + QuotedStr(Path) + ',' + QuotedStr(S) + ')';
         Sql.ExecQuery;
         IBQue_BDE.Close; IBQue_BDE.Open;
         LB_BASE.items.addObject(S, pointer(BasId));
         LB_BASE.itemindex := LB_BASE.items.count-1 ;
         Ed_NomBase.text := S;
         CL_Magasin.items.clear;
         IBQue_Lesmagasins.first;
         while not (IBQue_Lesmagasins.eof) do
         begin
            Clef.open; magid := ClefCLEF.asinteger; clef.close;
            Sql.sql.text := 'INSERT INTO MAGASIN (MAG_ID,MAG_BDEID,MAG_GINKOID,MAG_ENABLED,MAG_LASTEXP,MAG_NOM) VALUES (' +
               Inttostr(magid) + ',' + Inttostr(basid) + ',' + Inttostr(IBQue_LesmagasinsMAG_ID.AsInteger) + ',' +
               '0,Null,' + QuotedStr(IBQue_LesmagasinsMAG_NOM.AsString) + ')';
            Sql.ExecQuery;
            CL_Magasin.items.AddObject(IBQue_LesmagasinsMAG_NOM.AsString + ' (' + IBQue_LesmagasinsMAG_CODEADH.asString + ')', Pointer(MagId));
            IBQue_Lesmagasins.next;
         end;
         IBQue_Magasin.close;
         Ed_PathBase.text := Path;
         IBQue_BDE.close ;
         IF tran.InTransaction THEN
         begin
              tran.commit ;
              tran.active := true ;
         END ;
         IBQue_BDE.open ;
         IBQue_BDE.LocateNext('BDE_NOM',QuotedStr(S),[]);
         LB_BASEClick(nil) ;
      except
      end;
      database.close;
   end;

end;

procedure TFrm_Gestion.CL_MagasinClickCheck(Sender: TObject);
begin
   Bt_Valider.enabled := true;
end;

procedure TFrm_Gestion.LB_BASEClick(Sender: TObject);
var
   bdeid: Integer;
   s: string;
begin
   if lb_base.ItemIndex > -1 then
   begin
      bdeid := Integer(lb_base.Items.Objects[lb_base.ItemIndex]);
      IBQue_BDE.first;
      while not IBQue_BDE.eof and (IBQue_BDEBDE_ID.Asinteger <> bdeid) do
         IBQue_BDE.Next;
      Ed_PathBase.text := IBQue_BDEBDE_PATH.AsString;
      Ed_NomBase.text := IBQue_BDEBDE_NOM.AsString;
      IBQue_Magasin.parambyname('BDEID').AsInteger := bdeid;
      IBQue_Magasin.Open;
      IBQue_Magasin.first;
      CL_Magasin.items.clear;
      while not (IBQue_Magasin.eof) do
      begin
         if IBQue_MagasinMAG_LASTEXP.isnull then
            CL_Magasin.items.AddObject(IBQue_MagasinMAG_NOM.AsString, pointer(IBQue_MagasinMAG_ID.Asinteger))
         else
         begin
            S := formatdatetime('dd/mm/yyyy', IBQue_MagasinMAG_LASTEXP.asdatetime);
            CL_Magasin.items.AddObject(IBQue_MagasinMAG_NOM.AsString + '  (' + S + ')', pointer(IBQue_MagasinMAG_ID.Asinteger))
         end;
         if IBQue_MagasinMAG_ENABLED.asInteger = 1 then
            CL_Magasin.Checked[CL_Magasin.Items.count - 1] := true;
         IBQue_Magasin.Next;
      end;
      IBQue_Magasin.close;
      Bt_Valider.enabled := false;
   end;
end;

procedure TFrm_Gestion.FormActivate(Sender: TObject);
begin
   data.DatabaseName := 'EXPSP2000.IB';
   data.Open;
   tran2.active := true ;
   LB_BASE.items.Clear;
   IBQue_BDE.Open;
   IBQue_BDE.first;
   while not (IBQue_BDE.Eof) do
   begin
      LB_BASE.items.addObject(IBQue_BDEBDE_NOM.AsString, pointer(IBQue_BDEBDE_ID.AsInteger));
      IBQue_BDE.Next;
   end;
end;

procedure TFrm_Gestion.Bt_ValiderClick(Sender: TObject);
var
   bdeid: Integer;
   magid: integer;
   i: integer;
begin
   Bt_Valider.enabled := false;
   if lb_base.ItemIndex > -1 then
   begin
      bdeid := Integer(lb_base.Items.Objects[lb_base.ItemIndex]);
      Sql.sql.text := 'UPDATE BASEDEDONNES set BDE_PATH=' + QuotedStr(Ed_PathBase.text) + ',' +
         'BDE_NOM = ' + QuotedStr(Ed_NomBase.text) + ' Where BDE_ID=' + Inttostr(bdeid);
      Sql.ExecQuery;
      IBQue_BDE.close; IBQue_BDE.open;
      for i := 0 to CL_Magasin.Items.Count - 1 do
      begin
         magid := integer(CL_Magasin.Items.Objects[i]);
         if CL_Magasin.Checked[i] then
            sql.sql.text := 'Update magasin set MAG_ENABLED=1 where mag_id=' + inttostr(magid)
         else
            sql.sql.text := 'Update magasin set MAG_ENABLED=0 where mag_id=' + inttostr(magid);
         Sql.ExecQuery;
      end;
      lb_base.Items[lb_base.ItemIndex] := Ed_NomBase.text;
   end;
end;

procedure TFrm_Gestion.Modifierladatedexport1Click(Sender: TObject);
var
   frm_date: Tfrm_date;
   magid: Integer;
   Ndate: TDateTime;
   s: string;
begin
   if (CL_Magasin.itemIndex > -1) then
   begin
      magid := integer(CL_Magasin.Items.Objects[CL_Magasin.itemIndex]);
      req.close;
      req.sql.text := 'select MAG_LASTEXP from MAGASIN Where MAG_ID = ' + inttostr(magid);
      req.open;
      application.createform(Tfrm_date, frm_date);
      if req.fields[0].isnull then
         frm_date.edit1.text := ''
      else
         frm_date.edit1.text := formatDateTime('dd/mm/yyyy', req.fields[0].AsDateTime);
      req.close;
      if frm_date.showmodal = mrok then
      begin
         if (trim(frm_date.edit1.text) = '') then
         begin
            Sql.sql.text := 'Update MAGASIN SET MAG_LASTEXP=NULL WHERE MAG_ID = ' + inttostr(magid);
            Sql.ExecQuery;
         end
         else
         begin
            try
               nDate := strtodate(frm_date.edit1.text);
               Sql.sql.text := 'Update MAGASIN SET MAG_LASTEXP=''' + formatDateTime('mm/dd/yyyy', nDate) + ''' WHERE MAG_ID = ' + inttostr(magid);
               Sql.ExecQuery;
            except
            end;
         end;
         req.sql.text := 'select MAG_LASTEXP,MAG_NOM  from MAGASIN Where MAG_ID = ' + inttostr(magid);
         req.open;
         if req.fields[0].isnull then
            CL_Magasin.items[CL_Magasin.itemIndex] := req.fields[1].AsString
         else
         begin
            S := formatdatetime('dd/mm/yyyy', req.fields[0].asdatetime);
            CL_Magasin.items[CL_Magasin.itemIndex] := req.fields[1].AsString + '  (' + S + ')';
         end;
         req.close;
         if tran2.intransaction then
         begin
            tran2.commit;
            tran2.active := true;
         end;
      end;
      frm_date.release;
   end;
end;

end.

