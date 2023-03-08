//------------------------------------------------------------------------------
// Nom de l'unité :
// Rôle           :
// Auteur         :
// Historique     :
// jj/mm/aaaa - Auteur - v 1.0.0 : Création
//------------------------------------------------------------------------------

UNIT Uprinc;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls,
    Forms, Dialogs, AlgolStdFrm, IB_Components, Db, IBDataset, StdCtrls,
    Buttons, LMDControl, LMDBaseControl, LMDBaseGraphicControl,
    LMDGraphicControl, LMDBaseMeter, LMDCustomProgressFill, LMDProgressFill;

TYPE
    TFrmBase = CLASS(TAlgolStdFrm)
        LesTables1: TIBOQuery;
        Con1: TIB_Connection;
        Tran1: TIB_Transaction;
        Tran2: TIB_Transaction;
        Con2: TIB_Connection;
        Edit1: TEdit;
        Edit2: TEdit;
        Label1: TLabel;
        Label2: TLabel;
        SpeedButton1: TSpeedButton;
        SpeedButton2: TSpeedButton;
        Od: TOpenDialog;
        Button1: TButton;
        LesTables2: TIBOQuery;
        LesTables1TABLES: TStringField;
        LesTables2TABLES: TStringField;
        Memo1: TMemo;
        IdTable: TIBOQuery;
        IdTableID: TStringField;
        Pr1: TLMDProgressFill;
        Pr2: TLMDProgressFill;
        Label3: TLabel;
        NbEnr1: TIBOQuery;
        NbEnr2: TIBOQuery;
            Index: TIBOQuery;
        ibc: TIBOQuery;
        Button2: TButton;
        PROCEDURE SpeedButton1Click(Sender: TObject);
        PROCEDURE SpeedButton2Click(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
    PRIVATE
    { Private declarations }
    PROTECTED
    { Protected declarations }
    PUBLIC
    { Public declarations }
    PUBLISHED
    { Published declarations }
    END;

VAR
    FrmBase: TFrmBase;

IMPLEMENTATION
{$R *.DFM}

PROCEDURE TFrmBase.SpeedButton1Click(Sender: TObject);
BEGIN
    IF od.execute THEN
        edit1.text := od.filename;
END;

PROCEDURE TFrmBase.SpeedButton2Click(Sender: TObject);
BEGIN
    IF od.execute THEN
        edit2.text := od.filename;
END;

PROCEDURE TFrmBase.Button1Click(Sender: TObject);
VAR
    k: integer;
    i: integer;
    j: Integer;
    LeNbr: Integer;
    debut, fin: INT64;
    Coef: Double;
    inds: STRING;
    nbfield: integer;

    f: textfile;
BEGIN
    AssignFile(F, 'c:\Difference.txt');

    Memo1.lines.clear;
    Memo1.lines.Add('Début de la comparaison ' + TimeToStr(Now));
    TRY
        Con1.databaseName := edit1.text;
        Con2.databaseName := edit2.text;
        Con1.Connected := false; Con1.Connected := true;
        Con2.Connected := false; Con2.Connected := true;
        LesTables1.Open; LesTables2.Open;
        Memo1.lines.Add('Nombre de tables ' + inttostr(LesTables1.recordcount) + '/' + inttostr(LesTables2.recordcount) + ' -> ' + TimeToStr(Now));
        IF LesTables1.recordcount <> LesTables2.recordcount THEN
        BEGIN
            Memo1.lines.Add('Pas le même nombre de table Arret');
            exit;
        END;
        Pr1.MaxValue := LesTables1.RecordCount;
        I := 0;
        WHILE NOT LesTables1.Eof DO
        BEGIN
            Memo1.lines.Add('Tables ' + LesTables1TABLES.AsString + ' -> ' + TimeToStr(Now));
            Inc(i);
            Pr1.UserValue := I; Pr1.Update;
            Label3.Caption := LesTables1TABLES.AsString; Label3.Update;
            Pr2.UserValue := 0;
            IdTable.Sql.Clear;
            IdTable.Sql.Add('select Rdb$FIELD_NAME ID');
            IdTable.Sql.Add('from rdb$relation_fields');
            IdTable.Sql.Add('where rdb$relation_name = ''' + LesTables1TABLES.AsString + '''');
            IdTable.Sql.Add('  And Rdb$Field_Position=0');
            IdTable.Open;

            NbEnr1.Sql.Text := 'SELECT Count(*), MAX(' + IdTableID.AsString + ') FROM ' + LesTables1TABLES.AsString;
            nbEnr2.Sql.Text := 'SELECT Count(*), MAX(' + IdTableID.AsString + ') FROM ' + LesTables1TABLES.AsString;
            NbEnr1.Open; NbEnr2.Open;
            IF NbEnr1.Fields[0].AsInteger <> NbEnr2.Fields[0].AsInteger THEN
            BEGIN
                Memo1.lines.Add('Pas le même nombre d''enregistrement : Arret  (' + NbEnr1.Fields[0].AsString + '/' + NbEnr2.Fields[0].AsString + ')');
                exit;
            END;
            J := 0;
            Pr2.MaxValue := NbEnr1.Fields[0].Asinteger;
            Label3.Caption := LesTables1TABLES.AsString + '(' + NbEnr1.Fields[0].AsString + ')'; Label3.Update;
            LeNbr := NbEnr1.Fields[0].AsInteger;
            Debut := 0; Fin := NbEnr1.Fields[1].AsInteger;
            IF LeNbr > 0 THEN
                coef := Fin / LeNbr
            ELSE
                coef := 1;
            IF Coef < 1 THEN
                Coef := 1;
            Index.sql.clear;
            Index.sql.Add('select RDB$INDICES.rdb$index_name');
            Index.sql.Add('from rdb$index_segments Join RDB$INDICES');
            Index.sql.Add('  on (rdb$index_segments.rdb$index_name = RDB$INDICES.rdb$index_name)');
            Index.sql.Add('where rdb$field_name = ''' + IdTableID.AsString + '''');
            Index.sql.Add('  And RDB$RELATION_NAME = ''' + LesTables1TABLES.AsString + '''');
            Index.sql.Add('  AND ((RDB$INDEX_INACTIVE=0) or (RDB$INDEX_INACTIVE is null))');
            Index.Open;
            IF index.IsEmpty THEN
                inds := ''
            ELSE
                inds := 'PLAN SORT (' + LesTables1TABLES.AsString + ' INDEX (' + Index.fields[0].asString + '), K INDEX (K_1))';

            REPEAT
                NbEnr1.Sql.Text := 'SELECT MIN(' + IdTableID.AsString + ') FROM ' + LesTables1TABLES.AsString +
                    ' WHERE ' + IdTableID.AsString + '>=' + Inttostr(Debut);
                NbEnr1.Open;
                Debut := NbEnr1.Fields[0].AsInteger;
                NbEnr1.Close;
                NbEnr2.Close;
                IF Fin - Debut > 5000 * Coef THEN
                BEGIN
                    NbEnr1.Sql.Text := 'SELECT * FROM ' + LesTables1TABLES.AsString + ' JOIN K ON (K_ID = ' + IdTableID.AsString + ' AND K_ENABLED=1) ' +
                        ' WHERE ' + IdTableID.AsString + ' BETWEEN ' + Inttostr(DEBUT) + ' And ' + Inttostr(DEBUT + trunc(5000 * coef));
                    NbEnr1.Sql.Add(inds);
                    NbEnr1.Sql.Add(' ORDER BY ' + IdTableID.AsString);
                    nbEnr2.Sql.Text := 'SELECT * FROM ' + LesTables1TABLES.AsString + ' JOIN K ON (K_ID = ' + IdTableID.AsString + ' AND K_ENABLED=1) ' +
                        ' WHERE ' + IdTableID.AsString + ' BETWEEN ' + Inttostr(DEBUT) + ' And ' + Inttostr(DEBUT + trunc(5000 * coef));
                    NbEnr2.Sql.Add(inds);
                    NbEnr2.Sql.Add(' ORDER BY ' + IdTableID.AsString);
                END
                ELSE
                BEGIN
                    NbEnr1.Sql.Text := 'SELECT * FROM ' + LesTables1TABLES.AsString + ' JOIN K ON (K_ID = ' + IdTableID.AsString + ' AND K_ENABLED=1) ' +
                        ' WHERE ' + IdTableID.AsString + ' BETWEEN ' + Inttostr(DEBUT) + ' And ' + Inttostr(Fin);
                    NbEnr1.Sql.Add(inds);
                    NbEnr1.Sql.Add(' ORDER BY ' + IdTableID.AsString);
                    nbEnr2.Sql.Text := 'SELECT * FROM ' + LesTables1TABLES.AsString + ' JOIN K ON (K_ID = ' + IdTableID.AsString + ' AND K_ENABLED=1) ' +
                        ' WHERE ' + IdTableID.AsString + ' BETWEEN ' + Inttostr(DEBUT) + ' And ' + Inttostr(Fin);
                    NbEnr2.Sql.Add(inds);
                    NbEnr2.Sql.Add(' ORDER BY ' + IdTableID.AsString);
                    Debut := fin + 1;
                END;
                NbEnr1.Open; NbEnr2.Open;
                IF NbEnr1.Fields.count <> nbEnr2.Fields.count THEN
                BEGIN
                    Memo1.lines.Add('Pas le même nombre de champs  : Arret  ');
                    exit;
                END;

                ibc.close;
                ibc.sql.text := 'SELECT * FROM ' + LesTables1TABLES.AsString;
                ibc.open;
                nbfield := ibc.Fields.count;

                WHILE NOT NbEnr1.Eof DO
                BEGIN
                    Inc(J); Pr2.UserValue := J; Pr2.Update;

                    //FOR k := 0 TO NbEnr1.fields.count - 1 DO
                    FOR k := 0 TO NbField - 1 DO

                        IF NbEnr1.fields[k].asString <> nbEnr2.fields[k].asString THEN
                        BEGIN
                            Memo1.lines.Add(inttostr(k) + ' Arret  : Différence pour l''enregistrement ' + NbEnr1.fields[0].AsString);
                            IF fileExists('c:\Difference.txt') THEN
                                Append(f)
                            ELSE
                                rewrite(f);
                            writeln(f, 'Base 1  Champ ' + inttostr(k) + ' ID : ' + NbEnr1.fields[0].AsString + ' / ' + NbEnr1.fields[k].asString);
                            writeln(f, 'Base 2  Champ ' + inttostr(k) + ' ID : ' + NbEnr2.fields[0].AsString + ' / ' + NbEnr2.fields[k].asString);
                            Closefile(f);
                        END;
                    NbEnr1.next; nbEnr2.next;
                END;
                Pr2.UserValue := J; Pr2.Update;
                NbEnr1.Close; nbEnr2.Close;
                debut := debut + trunc(5000 * coef) + 1;
                Update;
            UNTIL Debut >= Fin;
            IdTable.Close;
            LesTables1.Next;
        END;
    FINALLY
        Memo1.lines.Add('Fin de la comparaison ' + TimeToStr(Now));
        Con1.Connected := false;
        Con2.Connected := false;
    END;
END;

PROCEDURE TFrmBase.Button2Click(Sender: TObject);

    PROCEDURE compare(table,Ordre: STRING);
    VAR
        i: integer;
        ok:boolean ;
    BEGIN
        Memo1.lines.Add('Comparaison de '+Table) ;
        NbEnr1.Sql.Clear;
        NbEnr1.Sql.Add('Select Count(*) from ' + table);
        NbEnr2.Sql.Clear;
        NbEnr2.Sql.Add('Select Count(*) from ' + table);
        NbEnr1.Open; NbEnr2.Open;
        IF NbEnr1.Fields[0].AsInteger <> NbEnr2.Fields[0].AsInteger THEN
            Memo1.lines.Add(Table + ' -> Pas le même nombre d''enregistrement')
        ELSE
        BEGIN
            NbEnr1.Close; NbEnr2.Close;

            NbEnr1.Sql.Clear;
            NbEnr1.Sql.Add('Select * from ' + Table+' '+Ordre);

            NbEnr2.Sql.Clear;
            NbEnr2.Sql.Add('Select * from ' + Table+' '+Ordre);

            NbEnr2.Open;
            NbEnr1.Open;
            ok := false ;
            WHILE NOT NbEnr1.eof DO
            BEGIN
                FOR i := 1 TO nbenr1.fields.count - 1 DO
                    IF nbenr1.fields[i].asString <> nbenr2.fields[i].asString THEN
                    BEGIN
                      Memo1.lines.Add(Table + ' -> différence dans la table '+Table) ;
                      ok := true ;
                      Break ;
                    END;
                if ok then
                  break ;
                NbEnr2.Next;
                NbEnr1.Next;
            END;
        END;
        NbEnr1.Close; NbEnr2.Close;
    END;

BEGIN
 //
    Memo1.lines.clear;
    Memo1.lines.Add('Début de la comparaison ' + TimeToStr(Now));
    TRY
        Con1.Connected := false;
        Con2.Connected := false;
        Con1.databaseName := edit1.text;
        Con2.databaseName := edit2.text;
        Con1.Connected := true;
        Con2.Connected := true;

        compare('AGRHISTOPUMP', 'ORDER BY HPP_JOUR,HPP_MOIS,HPP_ANNEE,HPP_ARTID,HPP_SOCID,HPP_TGFID');
        compare('AGRHISTOSTOCK', 'ORDER BY HST_JOUR,HST_MOIS,HST_ANNEE,HST_ARTID,HST_MAGID,HST_TGFID,HST_COUID') ;
        // compare('AGRHISTOVENTE');
        compare('AGRPUMPCOUR',  'ORDER BY PPC_ARTID, PPC_SOCID, PPC_TGFID') ;
        compare('AGRRAL', 'ORDER BY RAL_CDLID');
        compare('AGRSTOCKCOUR', 'ORDER BY STC_ARTID, STC_MAGID, STC_TGFID, STC_COUID');
        // compare('AGRHISTOVENTE');
        compare('TARACHATCOUR', 'ORDER BY PAC_ARTID, PAC_TGFID') ;

    FINALLY
        Memo1.lines.Add('Fin de la comparaison ' + TimeToStr(Now));
        Con1.Connected := false;
        Con2.Connected := false;
    END;
END;

END.

