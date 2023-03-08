{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q+,R+,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
UNIT UXmlAuto;

INTERFACE

USES
//    FileUtil,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Buttons, StdCtrls, CheckLst, Db, IBCustomDataSet, IBQuery, IBDatabase;

TYPE
    TUneTable = CLASS
        Table: STRING;
        Nom: STRING;
        LesChamps: TstringList;
        LesTypes: TstringList;
        Dependance: TstringList;
        Plan: STRING;
        Repliquer: Boolean;
        PK: STRING;
        KTB_ID: STRING;
        CONSTRUCTOR create;
        PROCEDURE savetostream(ts: tstream);
        PROCEDURE LoadFromstream(ts: tstream);
        DESTRUCTOR destroy; OVERRIDE;
        FUNCTION ExtractTbl: STRING;
        FUNCTION ExtractK: STRING;
        FUNCTION InsertTbl: STRING;
        FUNCTION InsertK: STRING;
        FUNCTION LesParams: STRING;
    END;

    TunModule = CLASS
        List: TStringList;
        Nom: STRING;
        PROCEDURE savetostream(ts: tstream);
        PROCEDURE LoadFromstream(ts: tstream);
        CONSTRUCTOR create;
        DESTRUCTOR destroy; OVERRIDE;
        FUNCTION BatchServ(complet: boolean): STRING;
        FUNCTION Batch(complet: boolean): STRING;
        FUNCTION Extract(complet: boolean): STRING;
    END;

    TForm1 = CLASS(TForm)
        Data: TIBDatabase;
        Tran: TIBTransaction;
        IBQue_LstTable: TIBQuery;
        IBQue_LstTableNOM: TIBStringField;
        Lst_Tables: TCheckListBox;
        Edit1: TEdit;
        SpeedButton1: TSpeedButton;
        OD: TOpenDialog;
        Button1: TButton;
        IbQue_LstChamps: TIBQuery;
        Lab_NbChp: TLabel;
        IBQue_PK: TIBQuery;
        Lab_PK: TLabel;
        IBQue_Depend: TIBQuery;
        Lb_Dep: TListBox;
        Ed_Nom: TEdit;
        Button2: TButton;
        IBQue_Index: TIBQuery;
        Mem_Extract: TMemo;
        Memo1: TMemo;
        Lb_Module: TListBox;
        Lb_LstTbl: TListBox;
        Button3: TButton;
        Ed_NomMod: TEdit;
        Button4: TButton;
        SpeedButton2: TSpeedButton;
        SpeedButton3: TSpeedButton;
        SpeedButton4: TSpeedButton;
        SpeedButton5: TSpeedButton;
        Button5: TButton;
        Cb_Complet: TCheckBox;
    IbQue_LstChampsNOM: TIBStringField;
    IbQue_LstChampsTIPE: TIBStringField;
    IBQue_PKNOM: TIBStringField;
    IBQue_DependNOM: TIBStringField;
    IBQue_IndexNOM: TIBStringField;
    IBQue_PKKTB_ID: TIntegerField;
        PROCEDURE SpeedButton1Click(Sender: TObject);
        PROCEDURE Button1Click(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE FormDestroy(Sender: TObject);
        PROCEDURE Lst_TablesClickCheck(Sender: TObject);
        PROCEDURE Lst_TablesClick(Sender: TObject);
        PROCEDURE Ed_NomExit(Sender: TObject);
        PROCEDURE Button2Click(Sender: TObject);
        PROCEDURE Button3Click(Sender: TObject);
        PROCEDURE Lb_ModuleClick(Sender: TObject);
        PROCEDURE Ed_NomModExit(Sender: TObject);
        PROCEDURE Lb_LstTblDragDrop(Sender, Source: TObject; X, Y: Integer);
        PROCEDURE Lb_LstTblDragOver(Sender, Source: TObject; X, Y: Integer;
            State: TDragState; VAR Accept: Boolean);
        PROCEDURE Button4Click(Sender: TObject);
        PROCEDURE SpeedButton2Click(Sender: TObject);
        PROCEDURE SpeedButton3Click(Sender: TObject);
        PROCEDURE SpeedButton4Click(Sender: TObject);
        PROCEDURE SpeedButton5Click(Sender: TObject);
        PROCEDURE Button5Click(Sender: TObject);
        PROCEDURE Lb_LstTblKeyUp(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
        PROCEDURE Lb_ModuleKeyUp(Sender: TObject; VAR Key: Word;
            Shift: TShiftState);
    PRIVATE
    { Déclarations privées }
        LesTables: Tlist;
        LesModules: Tlist;
        PROCEDURE ClearTbl;
        PROCEDURE ClearMod;
        FUNCTION ChercheTable(Tbl: STRING): TUneTable;
        PROCEDURE TblLoadFromStream(Ts: Tstream);
        PROCEDURE TblSaveToStream(Ts: Tstream);

        PROCEDURE ModLoadFromStream(Ts: Tstream);
        PROCEDURE ModSaveToStream(Ts: Tstream);

        PROCEDURE load;
        PROCEDURE Save;
    PUBLIC
    { Déclarations publiques }
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION

FUNCTION readString(ts: Tstream): STRING;
VAR
    i: integer;
    s: STRING;
BEGIN
    ts.read(i, sizeof(i));
    setlength(S, i);
    IF i > 0 THEN
        ts.read(pointer(S)^, i);
    result := s;
END;

PROCEDURE WriteString(S: STRING; Ts: Tstream);
VAR
    i: integer;
BEGIN
    i := length(s);
    ts.write(i, sizeof(i));
    IF i > 0 THEN
        ts.write(Pointer(S)^, i);
END;

PROCEDURE ReadStrings(tsl: TStrings; Ts: Tstream);
VAR
    i: integer;
BEGIN
    tsl.clear;
    ts.read(i, sizeof(i));
    IF i > 0 THEN
    BEGIN
        FOR i := 0 TO i - 1 DO
            tsl.add(readstring(ts));
    END;
END;

PROCEDURE WriteStrings(tsl: TStrings; Ts: Tstream);
VAR
    i: integer;
BEGIN
    i := tsl.count;
    ts.write(i, sizeof(i));
    IF i > 0 THEN
    BEGIN
        FOR i := 0 TO tsl.count - 1 DO
            writeString(trim(tsl[i]), ts);
    END;
END;

{$R *.DFM}

PROCEDURE TForm1.SpeedButton1Click(Sender: TObject);
BEGIN
    IF od.Execute THEN
        edit1.text := od.filename;
END;

PROCEDURE TForm1.Button1Click(Sender: TObject);
VAR
    tbl: TUneTable;
    i: integer;
    pass: STRING;
BEGIN
    data.close;
    data.databasename := edit1.text;
    data.Open;
    IBQue_LstTable.Open;
    WHILE NOT IBQue_LstTable.Eof DO
    BEGIN
        pass := trim(IBQue_LstTableNOM.asstring);
        Tbl := ChercheTable(pass);
        IF Tbl = NIL THEN
        BEGIN
            tbl := TUneTable.create;
            LesTables.add(tbl);
            tbl.Table := Uppercase(Pass);
            tbl.Nom := '';
            tbl.Plan := '';
            tbl.Repliquer := true;
            i := Lst_Tables.items.addObject(pass, tbl);
            Lst_Tables.Checked[i] := true;
        END;
        //
        // Mise à jour des champs
        tbl.LesChamps.Clear;
        tbl.LesTypes.Clear;
        IbQue_LstChamps.ParamByName('TABLE').AsString := Tbl.Table;
        IbQue_LstChamps.Open;
        WHILE NOT IbQue_LstChamps.Eof DO
        BEGIN
            Pass := trim(IbQue_LstChampsNom.AsString);
            IF tbl.LesChamps.indexof(pass) < 0 THEN
            BEGIN
                tbl.LesChamps.Add(pass);
                IF pos('_KEY', IbQue_LstChampsTIPE.AsString) > 0 THEN
                    tbl.LesTypes.Add('INTEGER')
                ELSE IF pos('_INTEGER', IbQue_LstChampsTIPE.AsString) > 0 THEN
                    tbl.LesTypes.Add('INTEGER')
                ELSE IF pos('_FLOAT', IbQue_LstChampsTIPE.AsString) > 0 THEN
                    tbl.LesTypes.Add('FLOAT')
                ELSE IF pos('_DOUBLE', IbQue_LstChampsTIPE.AsString) > 0 THEN
                    tbl.LesTypes.Add('FLOAT')
                ELSE IF pos('_DATE', IbQue_LstChampsTIPE.AsString) > 0 THEN
                    tbl.LesTypes.Add('DATE')
                ELSE
                    tbl.LesTypes.Add('');
            END;
            IbQue_LstChamps.next;
        END;
        IbQue_LstChamps.close;
        //

        IBQue_PK.ParamByName('TABLE').AsString := Tbl.Table;
        IBQue_PK.Open;
        Pass := trim(IBQue_PKNom.AsString);
        tbl.pk := Pass;
        IBQue_PK.Close;
        IF trim(tbl.Nom) = '' THEN
            tbl.nom := Copy(tbl.pk, 1, pos('_', tbl.pk) - 1);

        IBQue_Depend.ParamByName('TABLE').AsString := Tbl.Table;
        IBQue_Depend.Open;
        tbl.Dependance.clear;
        WHILE NOT IBQue_Depend.Eof DO
        BEGIN
            Pass := trim(IBQue_DependNom.AsString);
            tbl.Dependance.Add(Uppercase(pass));
            IBQue_Depend.next;
        END;
        IBQue_Depend.Close;

        IBQue_Index.ParamByName('TABLE').AsString := Tbl.Table;
        IBQue_Index.ParamByName('PK').AsString := Tbl.PK;
        IBQue_Index.Open;
        Pass := trim(IBQue_IndexNom.AsString);
        tbl.Plan := Pass;
        IBQue_Index.Close;

        IBQue_LstTable.next;
    END;
    IBQue_LstTable.close;
END;

PROCEDURE TForm1.FormCreate(Sender: TObject);
BEGIN
    edit1.text := data.databasename;
    LesTables := Tlist.Create;
    LesModules := Tlist.Create;
    Load;
END;

{ TUneTable }

CONSTRUCTOR TUneTable.create;
BEGIN
    INHERITED;
    LesChamps := TstringList.Create;
    LesTypes := TstringList.Create;
    Dependance := TstringList.Create;
    pk := '';
    ktb_id := '' ;
END;

DESTRUCTOR TUneTable.destroy;
BEGIN
    LesChamps.free;
    Dependance.free;
    LesTypes.free;
    INHERITED;
END;

FUNCTION TUneTable.ExtractK: STRING;
BEGIN
    IF KTB_ID='' then
    begin
      form1.IBQue_PK.close ;
      form1.IBQue_PK.ParamByName('TABLE').AsString := Table;
      form1.IBQue_PK.Open ;
      KTB_ID := form1.IBQue_PKKTB_ID.AsString ;
      form1.IBQue_PK.close ;
    END ;
    result := 'SELECT K_ID, KRH_ID, KTB_ID, K_VERSION, K_ENABLED, KSE_OWNER_ID,' + #13#10 +
        'KSE_INSERT_ID, K_INSERTED, KSE_DELETE_ID, K_DELETED, KSE_UPDATE_ID,' + #13#10 +
        'K_UPDATED, KSE_LOCK_ID, KMA_LOCK_ID, K_LID ' + #13#10;
    result := result + 'FROM K ' + #13#10;
    result := result + 'WHERE K_VERSION>:LAST_VERSION' + #13#10;
    result := result + 'AND K_VERSION<:CURRENT_VERSION' + #13#10;
    result := result + 'AND KTB_ID = '+KTB_ID;
END;

FUNCTION TUneTable.ExtractTbl: STRING;
VAR
    i: integer;
BEGIN
    IF KTB_ID='' then
    begin
      form1.IBQue_PK.close ;
      form1.IBQue_PK.ParamByName('TABLE').AsString := trim(Table);
      form1.IBQue_PK.Open ;
      KTB_ID := form1.IBQue_PKKTB_ID.AsString ;
      form1.IBQue_PK.close ;
    END ;
    result := 'SELECT ' + #13#10;
    FOR i := 0 TO LesChamps.Count - 2 DO
        result := result + trim(LesChamps[i]) + ',' + #13#10;
    result := result + trim(LesChamps[LesChamps.Count - 1]) + #13#10;
    result := result + 'FROM ' + trim(Table) + ' JOIN K ON (K_ID=' + trim(PK) + ')' + #13#10;
    result := result + 'WHERE K_VERSION>:LAST_VERSION' + #13#10;
    result := result + 'AND K_VERSION<:CURRENT_VERSION' + #13#10;
    result := result + 'AND KTB_ID = '+KTB_ID;
END;

FUNCTION TUneTable.InsertK: STRING;
BEGIN
    result := 'INSERT INTO K (K_ID, KRH_ID, KTB_ID, K_VERSION, K_ENABLED, KSE_OWNER_ID, KSE_INSERT_ID, K_INSERTED,'#13#10 +
        'KSE_DELETE_ID, K_DELETED, KSE_UPDATE_ID, K_UPDATED, KSE_LOCK_ID, KMA_LOCK_ID, K_LID)'#13#10 +
        'VALUES (:K_ID, :KRH_ID, :KTB_ID, :K_VERSION, :K_ENABLED, :KSE_OWNER_ID, :KSE_INSERT_ID, :K_INSERTED,'#13#10 +
        ':KSE_DELETE_ID, :K_DELETED, :KSE_UPDATE_ID, :K_UPDATED, :KSE_LOCK_ID, :KMA_LOCK_ID, :K_LID)';
END;

FUNCTION TUneTable.InsertTbl: STRING;
VAR
    i: integer;
BEGIN
    result := 'INSERT INTO ' + table + '(' + LesChamps[0];
    FOR i := 1 TO LesChamps.Count - 1 DO
        result := result + ', ' + LesChamps[i];
    result := result + ')'#13#10;
    result := result + 'VALUES (:' + LesChamps[0];
    FOR i := 1 TO LesChamps.Count - 1 DO
        result := result + ', :' + LesChamps[i];
    result := result + ')';
END;

FUNCTION TUneTable.LesParams: STRING;
VAR
    i: integer;
BEGIN
    result := '          <Params>' + #13#10;
    FOR i := 0 TO LesTypes.count - 1 DO
    BEGIN
        IF trim(LesTypes[i]) <> '' THEN
        BEGIN
            result := result + '            <Param>' + #13#10;
            result := result + '              <Name>' + LesChamps[i] + '</Name>' + #13#10;
            result := result + '              <Type>' + LesTypes[i] + '</Type>' + #13#10;
            result := result + '            </Param>' + #13#10;
        END;
    END;
    result := result + '          </Params>' + #13#10;
END;

PROCEDURE TUneTable.LoadFromstream(ts: tstream);
VAR
    tms: tmemorystream;
    i: integer;
BEGIN
    tms := tmemorystream.Create;
    TRY
        ts.Read(i, sizeof(i));
        tms.CopyFrom(ts, i);
        tms.Seek(soFromBeginning, 0);
        table := readstring(tms);
        Nom := readstring(tms);
        plan := readstring(tms);
        tms.Read(Repliquer, Sizeof(Repliquer));
        Repliquer := true;
        Readstrings(LesChamps, tms);
        Readstrings(Dependance, tms);
        Readstrings(LesTypes, tms);
        pk := readstring(tms);
    FINALLY
        tms.free;
    END;
END;

PROCEDURE TUneTable.savetostream(ts: tstream);
VAR
    tms: tmemorystream;
    i: integer;
BEGIN
    tms := tmemorystream.Create;
    TRY
        writestring(trim(table), tms);
        writestring(trim(Nom), tms);
        writestring(trim(Plan), tms);
        tms.Write(Repliquer, Sizeof(Repliquer));
        writestrings(LesChamps, tms);
        writestrings(Dependance, tms);
        writestrings(LesTypes, tms);
        writestring(PK, tms);
        i := tms.Size;
        ts.write(i, sizeof(i));
        ts.CopyFrom(tms, 0);
    FINALLY
        tms.free;
    END;
END;

{ TunModule }

FUNCTION TunModule.BatchServ(complet: boolean): STRING;
VAR
    i: integer;
    tbl: tunetable;
    s: STRING;
BEGIN
    result := '<?xml version="1.0" encoding="iso-8859-1"?>'#13#10;
    result := result + '<xmlgram name="' + Nom + 'Batch">'#13#10;
    IF NOT complet THEN
    BEGIN
        result := result + '  <Match Name="MatchK">'#13#10;
        result := result + '      <FillContext>True</FillContext>'#13#10;
        result := result + '      <Select>KS/K</Select>'#13#10;
        result := result + '      <DBBatch Name="DeleteK">'#13#10;
        result := result + '        <DataSource>Database</DataSource>'#13#10;
        result := result + '        <Params>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '        </Params>'#13#10;
        result := result + '        <Statement>'#13#10;
        result := result + '          <![CDATA[DELETE FROM K WHERE K_ID = :K_ID]]>'#13#10;
        result := result + '        </Statement>'#13#10;
        result := result + '      </DBBatch>'#13#10;
        result := result + '      <DBExtract Name="VERSION">'#13#10;
        result := result + '        <DataSource>Database</DataSource>'#13#10;
        result := result + '        <Kind>Single</Kind>'#13#10;
        result := result + '        <Filter/>'#13#10;
        result := result + '        <Fields/>'#13#10;
        result := result + '        <MaxRows>1</MaxRows>'#13#10;
        result := result + '        <Params/>'#13#10;
        result := result + '        <Statement>'#13#10;
        result := result + '          <![CDATA[SELECT NEWKEY AS LEK_VERSION FROM PROC_NEWVERKEY]]>'#13#10;
        result := result + '        </Statement>'#13#10;
        result := result + '      </DBExtract>'#13#10;
        result := result + '      <Assign Name="AssignK">'#13#10;
        result := result + '        <Fields>'#13#10;
        result := result + '          <Field>'#13#10;
        result := result + '            <Name>LEK_VERSION</Name>'#13#10;
        result := result + '            <Source>CONTEXT</Source>'#13#10;
        result := result + '            <Destination>INPUT</Destination>'#13#10;
        result := result + '          </Field>'#13#10;
        result := result + '        </Fields>'#13#10;
        result := result + '      </Assign>'#13#10;
        result := result + '      <DBBatch Name="InsertK">'#13#10;
        result := result + '        <DataSource>Database</DataSource>'#13#10;
        result := result + '        <Params>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KRH_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KTB_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>LEK_VERSION</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_ENABLED</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KSE_OWNER_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KSE_INSERT_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_INSERTED</Name>'#13#10;
        result := result + '            <Type>DATE</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KSE_DELETE_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_DELETED</Name>'#13#10;
        result := result + '            <Type>DATE</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KSE_UPDATE_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_UPDATED</Name>'#13#10;
        result := result + '            <Type>DATE</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KSE_LOCK_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KMA_LOCK_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_LID</Name>'#13#10;
        result := result + '            <Type>FLOAT</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '        </Params>'#13#10;
        result := result + '        <Statement>'#13#10;
        result := result + '          <![CDATA['#13#10;
        result := result + ' INSERT INTO K (K_ID, KRH_ID, KTB_ID, K_VERSION, K_ENABLED, KSE_OWNER_ID, KSE_INSERT_ID, K_INSERTED,'#13#10 +
            'KSE_DELETE_ID, K_DELETED, KSE_UPDATE_ID, K_UPDATED, KSE_LOCK_ID, KMA_LOCK_ID, K_LID)'#13#10 +
            'VALUES (:K_ID, :KRH_ID, :KTB_ID, :LEK_VERSION, :K_ENABLED, :KSE_OWNER_ID, :KSE_INSERT_ID, :K_INSERTED,'#13#10 +
            ':KSE_DELETE_ID, :K_DELETED, :KSE_UPDATE_ID, :K_UPDATED, :KSE_LOCK_ID, :KMA_LOCK_ID, :K_LID)]]>'#13#10;
        result := result + '        </Statement>'#13#10;
        result := result + '      </DBBatch>'#13#10;
        result := result + '  </Match>'#13#10;
    END;
    FOR i := 0 TO List.Count - 1 DO
    BEGIN
        tbl := form1.ChercheTable(List[i]);
        S := Copy(tbl.PK, 1, pos('_', tbl.PK) - 1);
        IF Complet THEN
        BEGIN
            result := result + '  <Match Name="MatchK_' + S + '">'#13#10;
            result := result + '      <FillContext>True</FillContext>'#13#10;
            result := result + '      <Select>K_' + S + 'S/K_' + S + '</Select>'#13#10;
            result := result + '      <DBBatch Name="DeleteK_' + S + '">'#13#10;
            result := result + '        <DataSource>Database</DataSource>'#13#10;
            result := result + '        <Params>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '        </Params>'#13#10;
            result := result + '        <Statement>'#13#10;
            result := result + '          <![CDATA[DELETE FROM K WHERE K_ID = :K_ID]]>'#13#10;
            result := result + '        </Statement>'#13#10;
            result := result + '      </DBBatch>'#13#10;
            result := result + '      <DBExtract Name="VERSION">'#13#10;
            result := result + '        <DataSource>Database</DataSource>'#13#10;
            result := result + '        <Kind>Single</Kind>'#13#10;
            result := result + '        <Filter/>'#13#10;
            result := result + '        <Fields/>'#13#10;
            result := result + '        <MaxRows>1</MaxRows>'#13#10;
            result := result + '        <Params/>'#13#10;
            result := result + '        <Statement>'#13#10;
            result := result + '          <![CDATA[SELECT NEWKEY AS LEK_VERSION FROM PROC_NEWVERKEY]]>'#13#10;
            result := result + '        </Statement>'#13#10;
            result := result + '      </DBExtract>'#13#10;
            result := result + '      <Assign Name="AssignK_' + S + '">'#13#10;
            result := result + '        <Fields>'#13#10;
            result := result + '          <Field>'#13#10;
            result := result + '            <Name>LEK_VERSION</Name>'#13#10;
            result := result + '            <Source>CONTEXT</Source>'#13#10;
            result := result + '            <Destination>INPUT</Destination>'#13#10;
            result := result + '          </Field>'#13#10;
            result := result + '        </Fields>'#13#10;
            result := result + '      </Assign>'#13#10;
            result := result + '      <DBBatch Name="InsertK_' + S + '">'#13#10;
            result := result + '        <DataSource>Database</DataSource>'#13#10;
            result := result + '        <Params>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KRH_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KTB_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>LEK_VERSION</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_ENABLED</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KSE_OWNER_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KSE_INSERT_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_INSERTED</Name>'#13#10;
            result := result + '            <Type>DATE</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KSE_DELETE_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_DELETED</Name>'#13#10;
            result := result + '            <Type>DATE</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KSE_UPDATE_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_UPDATED</Name>'#13#10;
            result := result + '            <Type>DATE</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KSE_LOCK_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KMA_LOCK_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_LID</Name>'#13#10;
            result := result + '            <Type>FLOAT</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '        </Params>'#13#10;
            result := result + '        <Statement>'#13#10;
            result := result + '          <![CDATA['#13#10;
            result := result + ' INSERT INTO K (K_ID, KRH_ID, KTB_ID, K_VERSION, K_ENABLED, KSE_OWNER_ID, KSE_INSERT_ID, K_INSERTED,'#13#10 +
                'KSE_DELETE_ID, K_DELETED, KSE_UPDATE_ID, K_UPDATED, KSE_LOCK_ID, KMA_LOCK_ID, K_LID)'#13#10 +
                'VALUES (:K_ID, :KRH_ID, :KTB_ID, :LEK_VERSION, :K_ENABLED, :KSE_OWNER_ID, :KSE_INSERT_ID, :K_INSERTED,'#13#10 +
                ':KSE_DELETE_ID, :K_DELETED, :KSE_UPDATE_ID, :K_UPDATED, :KSE_LOCK_ID, :KMA_LOCK_ID, :K_LID)]]>'#13#10;
            result := result + '        </Statement>'#13#10;
            result := result + '      </DBBatch>'#13#10;
            result := result + '  </Match>'#13#10;
        END;
        result := result + '  <Match Name="Match' + S + '">'#13#10;
        result := result + '      <FillContext>True</FillContext>'#13#10;
        result := result + '      <Select>' + S + 'S/' + S + '</Select>'#13#10;
        result := result + '      <DBBatch Name="Delete' + S + '">'#13#10;
        result := result + '        <DataSource>Database</DataSource>'#13#10;
        result := result + '        <Params>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>' + tbl.PK + '</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '        </Params>'#13#10;
        result := result + '        <Statement>'#13#10;
        result := result + '          <![CDATA[DELETE FROM ' + tbl.Table + ' WHERE ' + tbl.PK + ' = :' + tbl.PK + ']]>'#13#10;
        result := result + '        </Statement>'#13#10;
        result := result + '      </DBBatch>'#13#10;
        result := result + '      <DBBatch Name="Insert' + S + '">'#13#10;
        result := result + '        <DataSource>Database</DataSource>'#13#10;
        result := result + tbl.LesParams;
        result := result + '        <Statement>'#13#10;
        result := result + '          <![CDATA[' + tbl.InsertTbl + ']]>'#13#10;
        result := result + '        </Statement>'#13#10;
        result := result + '      </DBBatch>'#13#10;
        result := result + '  </Match>'#13#10;
    END;
    result := result + '</xmlgram>'#13#10;
END;

FUNCTION TunModule.Batch(complet: boolean): STRING;
VAR
    i: integer;
    tbl: tunetable;
    s: STRING;
BEGIN
    result := '<?xml version="1.0" encoding="iso-8859-1"?>'#13#10;
    result := result + '<xmlgram name="' + Nom + 'Batch">'#13#10;
    IF NOT complet THEN
    BEGIN
        result := result + '  <Match Name="MatchK">'#13#10;
        result := result + '      <FillContext>True</FillContext>'#13#10;
        result := result + '      <Select>KS/K</Select>'#13#10;
        result := result + '      <DBBatch Name="DeleteK">'#13#10;
        result := result + '        <DataSource>Database</DataSource>'#13#10;
        result := result + '        <Params>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '        </Params>'#13#10;
        result := result + '        <Statement>'#13#10;
        result := result + '          <![CDATA[DELETE FROM K WHERE K_ID = :K_ID]]>'#13#10;
        result := result + '        </Statement>'#13#10;
        result := result + '      </DBBatch>'#13#10;
        result := result + '      <DBBatch Name="InsertK">'#13#10;
        result := result + '        <DataSource>Database</DataSource>'#13#10;
        result := result + '        <Params>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KRH_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KTB_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_VERSION</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_ENABLED</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KSE_OWNER_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KSE_INSERT_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_INSERTED</Name>'#13#10;
        result := result + '            <Type>DATE</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KSE_DELETE_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_DELETED</Name>'#13#10;
        result := result + '            <Type>DATE</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KSE_UPDATE_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_UPDATED</Name>'#13#10;
        result := result + '            <Type>DATE</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KSE_LOCK_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>KMA_LOCK_ID</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>K_LID</Name>'#13#10;
        result := result + '            <Type>FLOAT</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '        </Params>'#13#10;
        result := result + '        <Statement>'#13#10;
        result := result + '          <![CDATA['#13#10;
        result := result + ' INSERT INTO K (K_ID, KRH_ID, KTB_ID, K_VERSION, K_ENABLED, KSE_OWNER_ID, KSE_INSERT_ID, K_INSERTED,'#13#10 +
            'KSE_DELETE_ID, K_DELETED, KSE_UPDATE_ID, K_UPDATED, KSE_LOCK_ID, KMA_LOCK_ID, K_LID)'#13#10 +
            'VALUES (:K_ID, :KRH_ID, :KTB_ID, :K_VERSION, :K_ENABLED, :KSE_OWNER_ID, :KSE_INSERT_ID, :K_INSERTED,'#13#10 +
            ':KSE_DELETE_ID, :K_DELETED, :KSE_UPDATE_ID, :K_UPDATED, :KSE_LOCK_ID, :KMA_LOCK_ID, :K_LID)]]>'#13#10;
        result := result + '        </Statement>'#13#10;
        result := result + '      </DBBatch>'#13#10;
        result := result + '  </Match>'#13#10;
    END;
    FOR i := 0 TO List.Count - 1 DO
    BEGIN
        tbl := form1.ChercheTable(List[i]);
        S := Copy(tbl.PK, 1, pos('_', tbl.PK) - 1);
        IF complet THEN
        BEGIN
            result := result + '  <Match Name="MatchK_' + S + '">'#13#10;
            result := result + '      <FillContext>True</FillContext>'#13#10;
            result := result + '      <Select>K_' + S + 'S/K_' + S + '</Select>'#13#10;
            result := result + '      <DBBatch Name="DeleteK_' + S + '">'#13#10;
            result := result + '        <DataSource>Database</DataSource>'#13#10;
            result := result + '        <Params>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '        </Params>'#13#10;
            result := result + '        <Statement>'#13#10;
            result := result + '          <![CDATA[DELETE FROM K WHERE K_ID = :K_ID]]>'#13#10;
            result := result + '        </Statement>'#13#10;
            result := result + '      </DBBatch>'#13#10;
            result := result + '      <DBBatch Name="InsertK_' + S + '">'#13#10;
            result := result + '        <DataSource>Database</DataSource>'#13#10;
            result := result + '        <Params>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KRH_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KTB_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_VERSION</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_ENABLED</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KSE_OWNER_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KSE_INSERT_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_INSERTED</Name>'#13#10;
            result := result + '            <Type>DATE</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KSE_DELETE_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_DELETED</Name>'#13#10;
            result := result + '            <Type>DATE</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KSE_UPDATE_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_UPDATED</Name>'#13#10;
            result := result + '            <Type>DATE</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KSE_LOCK_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>KMA_LOCK_ID</Name>'#13#10;
            result := result + '            <Type>INTEGER</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '          <Param>'#13#10;
            result := result + '            <Name>K_LID</Name>'#13#10;
            result := result + '            <Type>FLOAT</Type>'#13#10;
            result := result + '          </Param>'#13#10;
            result := result + '        </Params>'#13#10;
            result := result + '        <Statement>'#13#10;
            result := result + '          <![CDATA['#13#10;
            result := result + ' INSERT INTO K (K_ID, KRH_ID, KTB_ID, K_VERSION, K_ENABLED, KSE_OWNER_ID, KSE_INSERT_ID, K_INSERTED,'#13#10 +
                'KSE_DELETE_ID, K_DELETED, KSE_UPDATE_ID, K_UPDATED, KSE_LOCK_ID, KMA_LOCK_ID, K_LID)'#13#10 +
                'VALUES (:K_ID, :KRH_ID, :KTB_ID, :K_VERSION, :K_ENABLED, :KSE_OWNER_ID, :KSE_INSERT_ID, :K_INSERTED,'#13#10 +
                ':KSE_DELETE_ID, :K_DELETED, :KSE_UPDATE_ID, :K_UPDATED, :KSE_LOCK_ID, :KMA_LOCK_ID, :K_LID)]]>'#13#10;
            result := result + '        </Statement>'#13#10;
            result := result + '      </DBBatch>'#13#10;
            result := result + '  </Match>'#13#10;
        END;
        result := result + '  <Match Name="Match' + S + '">'#13#10;
        result := result + '      <FillContext>True</FillContext>'#13#10;
        result := result + '      <Select>' + S + 'S/' + S + '</Select>'#13#10;
        result := result + '      <DBBatch Name="Delete' + S + '">'#13#10;
        result := result + '        <DataSource>Database</DataSource>'#13#10;
        result := result + '        <Params>'#13#10;
        result := result + '          <Param>'#13#10;
        result := result + '            <Name>' + tbl.PK + '</Name>'#13#10;
        result := result + '            <Type>INTEGER</Type>'#13#10;
        result := result + '          </Param>'#13#10;
        result := result + '        </Params>'#13#10;
        result := result + '        <Statement>'#13#10;
        result := result + '          <![CDATA[DELETE FROM ' + tbl.Table + ' WHERE ' + tbl.PK + ' = :' + tbl.PK + ']]>'#13#10;
        result := result + '        </Statement>'#13#10;
        result := result + '      </DBBatch>'#13#10;
        result := result + '      <DBBatch Name="Insert' + S + '">'#13#10;
        result := result + '        <DataSource>Database</DataSource>'#13#10;
        result := result + tbl.LesParams;
        result := result + '        <Statement>'#13#10;
        result := result + '          <![CDATA[' + tbl.InsertTbl + ']]>'#13#10;
        result := result + '        </Statement>'#13#10;
        result := result + '      </DBBatch>'#13#10;
        result := result + '  </Match>'#13#10;
    END;
    result := result + '</xmlgram>'#13#10;
END;

CONSTRUCTOR TunModule.create;
BEGIN
    INHERITED create;
    List := TStringList.Create;
END;

DESTRUCTOR TunModule.destroy;
BEGIN
    List.free;
    INHERITED;
END;

PROCEDURE TForm1.FormDestroy(Sender: TObject);
VAR
    i: integer;
BEGIN
    Save;
    FOR i := 0 TO LesTables.Count - 1 DO
        TUneTable(LesTables[i]).Free;
    LesTables.free;

    FOR i := 0 TO LesModules.Count - 1 DO
        TunModule(LesModules[i]).free;
    LesModules.free;
END;

FUNCTION TForm1.ChercheTable(Tbl: STRING): TUneTable;
VAR
    i: integer;
BEGIN
    result := NIL;
    tbl := uppercase(tbl);
    FOR i := 0 TO LesTables.Count - 1 DO
        IF TUneTable(LesTables[i]).Table = tbl THEN
        BEGIN
            result := TUneTable(LesTables[i]);
            EXIT;
        END;
END;

PROCEDURE TForm1.TblLoadFromStream(Ts: Tstream);
VAR
    i: integer;
    tms: tmemorystream;
    tb: tunetable;
BEGIN
    ClearTbl;
    tms := tmemorystream.create;
    TRY
        ts.read(i, sizeof(i));
        tms.copyfrom(ts, i);
        tms.Seek(soFromBeginning, 0);
        tms.read(i, sizeof(i));
        FOR i := 0 TO i - 1 DO
        BEGIN
            tb := tunetable.create;
            LesTables.add(tb);
            tb.LoadFromstream(tms);
        END;
    FINALLY
        tms.free;
    END;
END;

PROCEDURE TForm1.TblSaveToStream(Ts: Tstream);
VAR
    i: integer;
    tms: tmemorystream;
BEGIN
    tms := tmemorystream.create;
    TRY
        i := lestables.count;
        tms.write(i, sizeof(i));
        FOR i := 0 TO lestables.count - 1 DO
            TUneTable(LesTables[i]).savetostream(tms);
        i := tms.size;
        ts.Write(i, sizeof(i));
        ts.copyfrom(tms, 0);
    FINALLY
        tms.free;
    END;
END;

PROCEDURE TForm1.ClearTbl;
VAR
    i: integer;
BEGIN
    FOR i := 0 TO LesTables.Count - 1 DO
        TUneTable(LesTables[i]).Free;
    LesTables.clear;
END;

PROCEDURE TForm1.load;
VAR
    tfs: tfilestream;
    i: integer;
BEGIN
    IF fileexists(changefileext(application.exename, '.tbl')) THEN
    BEGIN
        tfs := tfilestream.Create(changefileext(application.exename, '.tbl'), fmOpenRead);
        TRY
            TblLoadFromStream(tfs);
            IF tfs.Position < tfs.size THEN
                ModLoadFromStream(tfs);
        FINALLY
            tfs.free;
        END;
    END;
    Lst_Tables.items.clear;
    FOR i := 0 TO LesTables.Count - 1 DO
    BEGIN
        Lst_Tables.items.AddObject(tunetable(lestables[i]).Table, tunetable(lestables[i]));
        Lst_Tables.Checked[Lst_Tables.items.Count - 1] := tunetable(lestables[i]).Repliquer;
    END;

END;

PROCEDURE TForm1.Save;
VAR
    tfs: tfilestream;
BEGIN
    IF fileexists(changefileext(application.exename, '.tbl')) THEN
    BEGIN
        deletefile(changefileext(application.exename, '.~tbl'));
        RenameFile(changefileext(application.exename, '.tbl'), changefileext(application.exename, '.~tbl'));
    END;
    tfs := tfilestream.Create(changefileext(application.exename, '.tbl'), fmCreate);
    TRY
        TblSaveToStream(tfs);
        ModSaveToStream(tfs);
    FINALLY
        tfs.free;
    END;
END;

PROCEDURE TForm1.Lst_TablesClickCheck(Sender: TObject);
BEGIN
    IF lst_tables.ItemIndex > -1 THEN
    BEGIN
        tunetable(lst_tables.items.Objects[lst_tables.ItemIndex]).Repliquer :=
            lst_tables.Checked[lst_tables.ItemIndex];
    END;
END;

PROCEDURE TForm1.Lst_TablesClick(Sender: TObject);
VAR
    tbl: TuneTable;
BEGIN
    IF lst_tables.ItemIndex > -1 THEN
    BEGIN
        tbl := tunetable(lst_tables.items.Objects[lst_tables.ItemIndex]);
        Lab_NbChp.Caption := inttostr(tbl.LesChamps.count) + ' champs';
        Lab_PK.Caption := tbl.PK;
        Lb_Dep.items.Assign(tbl.Dependance);
        Ed_Nom.text := Tbl.nom;
        Mem_Extract.Lines.Text := tbl.ExtractTbl + #10#13#10#13 + tbl.ExtractK;
    END;
END;

PROCEDURE TForm1.Ed_NomExit(Sender: TObject);
BEGIN
    IF lst_tables.ItemIndex > -1 THEN
    BEGIN
        tunetable(lst_tables.items.Objects[lst_tables.ItemIndex]).nom :=
            Uppercase(Ed_Nom.text);
    END;
END;

FUNCTION TblSort(Item1, Item2: Pointer): Integer;
BEGIN
    IF Tunetable(item1).Table < Tunetable(item2).table THEN
        result := -1
    ELSE
        IF Tunetable(item1).Table > Tunetable(item2).table THEN
            result := 1
        ELSE
            result := 0;
END;

PROCEDURE TForm1.Button2Click(Sender: TObject);
VAR
    i: integer;
    j: integer;
    s: STRING;
    ok: boolean;
    toto: boolean;
BEGIN
    LesTables.Sort(TblSort);
    EXIT;
    i := 0;
    WHILE i < LesTables.count DO
    BEGIN
        IF TuneTable(lestables[i]).Dependance.count = 0 THEN
            inc(i)
        ELSE
            BREAK;
    END;

    WHILE i < LesTables.count DO
    BEGIN
        IF TuneTable(lestables[i]).Dependance.count = 0 THEN
            lestables.Move(i, 0)
        ELSE
            Inc(i);
    END;

    REPEAT
        toto := true;
        WHILE i < LesTables.count DO
        BEGIN
            S := TuneTable(lestables[i]).Table;
            ok := true;
            FOR j := LesTables.count - 1 DOWNTO i DO
            BEGIN
                IF TuneTable(lestables[i]).Dependance.IndexOf(TuneTable(lestables[j]).Table) > -1 THEN
                BEGIN
                    lestables.Move(i, j);
                    IF Abs(i - j) > 2 THEN
                    BEGIN
                        ok := false;
                        toto := false;
                    END;
                    BREAK;
                END;
            END;
            IF ok THEN
                inc(i);
        END;
    UNTIL toto;
    Lst_Tables.items.clear;
    FOR i := 0 TO LesTables.Count - 1 DO
    BEGIN
        Lst_Tables.items.AddObject(tunetable(lestables[i]).Table, tunetable(lestables[i]));
        Lst_Tables.Checked[Lst_Tables.items.Count - 1] := tunetable(lestables[i]).Repliquer;
    END;
END;

PROCEDURE TForm1.Button3Click(Sender: TObject);
VAR
    tm: TunModule;
BEGIN
    tm := TunModule.Create;
    tm.Nom := 'Nouveau';
    Lb_Module.items.AddObject(tm.Nom, tm);
    LesModules.add(tm);
    Lb_Module.itemIndex := Lb_Module.items.Count - 1;
    Ed_NomMod.Text := tm.nom;
    Lb_ModuleClick(NIL);
END;

PROCEDURE TForm1.Lb_ModuleClick(Sender: TObject);
BEGIN
    IF lb_module.itemindex > -1 THEN
    BEGIN
        Ed_NomMod.Text := TunModule(lb_module.items.Objects[lb_module.itemindex]).Nom;
        Lb_LstTbl.items.Assign(TunModule(lb_module.items.Objects[lb_module.itemindex]).List);

    END;
END;

PROCEDURE TForm1.Ed_NomModExit(Sender: TObject);
BEGIN
    IF lb_module.itemindex > -1 THEN
    BEGIN
        TunModule(lb_module.items.Objects[lb_module.itemindex]).Nom := Ed_NomMod.Text;
        lb_module.items[lb_module.itemindex] := Ed_NomMod.Text;
    END;
END;

PROCEDURE TForm1.Lb_LstTblDragDrop(Sender, Source: TObject; X, Y: Integer);
BEGIN
    IF lb_module.itemindex > -1 THEN
    BEGIN
        IF source = Lst_Tables THEN
        BEGIN
            IF (Lst_Tables.itemIndex > -1) AND (Lst_Tables.Checked[Lst_Tables.itemIndex]) THEN
            BEGIN
                Lb_LstTbl.Items.Add(TuneTable(Lst_Tables.items.Objects[Lst_Tables.itemIndex]).Table);
                TunModule(lb_module.items.Objects[lb_module.itemindex]).List.add(TuneTable(Lst_Tables.items.Objects[Lst_Tables.itemIndex]).Table);
                TuneTable(Lst_Tables.items.Objects[Lst_Tables.itemIndex]).Repliquer := false;
                Lst_Tables.Checked[Lst_Tables.itemIndex] := false;
            END;
        END;
    END;
END;

FUNCTION TunModule.Extract(complet: boolean): STRING;
VAR
    i: integer;
    tbl: tunetable;
    s: STRING;
BEGIN
    result := '<?xml version="1.0" encoding="iso-8859-1"?>'#13#10;
    result := result + '<xmlgram name="' + Nom + 'Extract">'#13#10;
    result := result + '  <DBExtract Name="VERSION">'#13#10;
    result := result + '    <DataSource>Database</DataSource>'#13#10;
    result := result + '    <Kind>Single</Kind>'#13#10;
    result := result + '    <Filter/>'#13#10;
    result := result + '    <Fields/>'#13#10;
    result := result + '    <MaxRows>1</MaxRows>'#13#10;
    result := result + '    <Params/>'#13#10;
    result := result + '    <Statement>'#13#10;
    result := result + '      <![CDATA[SELECT NEWKEY AS CURRENT_VERSION FROM PROC_NEWVERKEY]]>'#13#10;
    result := result + '    </Statement>'#13#10;
    result := result + '  </DBExtract>'#13#10;
    result := result + '  <Assign Name="Header">'#13#10;
    result := result + '    <Fields>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>Operation</Name>'#13#10;
    result := result + '        <Value>BatchRequest</Value>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>Database</Name>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>CallBatch</Name>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>Sender</Name>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>Provider</Name>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>Subscription</Name>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>MIN_ID</Name>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>MAX_ID</Name>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>LAST_VERSION</Name>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>CURRENT_VERSION</Name>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>XMLServiceExtract</Name>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>URL</Name>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '      <Field>'#13#10;
    result := result + '        <Name>XMLServiceBatch</Name>'#13#10;
    result := result + '      </Field>'#13#10;
    result := result + '    </Fields>'#13#10;
    result := result + '  </Assign>'#13#10;
    FOR i := 0 TO List.Count - 1 DO
    BEGIN
        tbl := form1.ChercheTable(List[i]);
        S := Copy(tbl.PK, 1, pos('_', tbl.PK) - 1);
        IF Complet THEN
            result := result + '  <DBExtract Name="K_' + S + '">'#13#10
        ELSE
            result := result + '  <DBExtract Name="K">'#13#10;
        result := result + '    <DataSource>Database</DataSource>'#13#10;
        result := result + '    <Kind>Multiple</Kind>'#13#10;
        result := result + '    <Filter/>'#13#10;
        result := result + '    <Fields/>'#13#10;
        result := result + '    <MaxRows>-1</MaxRows>'#13#10;
        result := result + '    <Params>'#13#10;
        result := result + '      <Param>'#13#10;
        result := result + '        <Name>LAST_VERSION</Name>'#13#10;
        result := result + '        <Type>INTEGER</Type>'#13#10;
        result := result + '      </Param>'#13#10;
        result := result + '      <Param>'#13#10;
        result := result + '        <Name>CURRENT_VERSION</Name>'#13#10;
        result := result + '        <Type>INTEGER</Type>'#13#10;
        result := result + '      </Param>'#13#10;
        result := result + '    </Params>'#13#10;
        result := result + '    <Statement>'#13#10;
        result := result + '      <![CDATA[' + tbl.ExtractK + ']]>'#13#10;
        result := result + '    </Statement>'#13#10;
        result := result + '  </DBExtract>'#13#10;

        result := result + '  <DBExtract Name="' + S + '">'#13#10;
        result := result + '    <DataSource>Database</DataSource>'#13#10;
        result := result + '    <Kind>Multiple</Kind>'#13#10;
        result := result + '    <Filter/>'#13#10;
        result := result + '    <Fields/>'#13#10;
        result := result + '    <MaxRows>-1</MaxRows>'#13#10;
        result := result + '    <Params>'#13#10;
        result := result + '      <Param>'#13#10;
        result := result + '        <Name>LAST_VERSION</Name>'#13#10;
        result := result + '        <Type>INTEGER</Type>'#13#10;
        result := result + '      </Param>'#13#10;
        result := result + '      <Param>'#13#10;
        result := result + '        <Name>CURRENT_VERSION</Name>'#13#10;
        result := result + '        <Type>INTEGER</Type>'#13#10;
        result := result + '      </Param>'#13#10;
        result := result + '    </Params>'#13#10;
        result := result + '    <Statement>'#13#10;
        result := result + '      <![CDATA[' + tbl.ExtractTbl + ']]>'#13#10;
        result := result + '    </Statement>'#13#10;
        result := result + '  </DBExtract>'#13#10;

    END;
    result := result + '</xmlgram>'#13#10;
END;

PROCEDURE TunModule.LoadFromstream(ts: tstream);
VAR
    tms: tmemorystream;
    i: integer;
BEGIN
    tms := tmemorystream.Create;
    TRY
        ts.Read(i, sizeof(i));
        IF i > 0 THEN
        BEGIN
            tms.CopyFrom(ts, i);
            tms.Seek(soFromBeginning, 0);
            Nom := readstring(tms);
            Readstrings(List, tms);
        END;
    FINALLY
        tms.free;
    END;
END;

PROCEDURE TunModule.savetostream(ts: tstream);
VAR
    tms: tmemorystream;
    i: integer;
BEGIN
    tms := tmemorystream.Create;
    TRY
        Writestring(Nom, tms);
        WriteStrings(List, tms);
        i := tms.size;
        ts.write(i, sizeof(i));
        ts.CopyFrom(tms, 0);
    FINALLY
        tms.free;
    END;
END;

PROCEDURE TForm1.ModLoadFromStream(Ts: Tstream);
VAR
    i, j: integer;
    tms: tmemorystream;
    tb: TunModule;
BEGIN
    ClearMod;
    tms := tmemorystream.create;
    TRY
        ts.read(i, sizeof(i));
        tms.copyfrom(ts, i);
        tms.Seek(soFromBeginning, 0);
        tms.read(i, sizeof(i));
        FOR i := 0 TO i - 1 DO
        BEGIN
            tb := TunModule.create;
            LesModules.add(tb);
            tb.LoadFromstream(tms);
            FOR j := 0 TO tb.list.count - 1 DO
                ChercheTable(tb.list[j]).Repliquer := false;
        END;
    FINALLY
        tms.free;
    END;
    Lb_Module.items.clear;
    FOR i := 0 TO LesModules.Count - 1 DO
    BEGIN
        Lb_Module.items.AddObject(TunModule(LesModules[i]).Nom, TunModule(LesModules[i]));
    END;
END;

PROCEDURE TForm1.ModSaveToStream(Ts: Tstream);
VAR
    i: integer;
    tms: tmemorystream;
BEGIN
    tms := tmemorystream.create;
    TRY
        i := LesModules.count;
        tms.write(i, sizeof(i));
        FOR i := 0 TO LesModules.count - 1 DO
            TunModule(LesModules[i]).savetostream(tms);
        i := tms.size;
        ts.Write(i, sizeof(i));
        ts.copyfrom(tms, 0);
    FINALLY
        tms.free;
    END;
END;

PROCEDURE TForm1.ClearMod;
VAR
    i: integer;
BEGIN
    FOR i := 0 TO LesModules.Count - 1 DO
        TunModule(LesModules[i]).Free;
    LesModules.clear;
END;

PROCEDURE TForm1.Lb_LstTblDragOver(Sender, Source: TObject; X, Y: Integer;
    State: TDragState; VAR Accept: Boolean);
BEGIN
    IF lb_module.itemindex > -1 THEN
    BEGIN
        IF (sender = Lst_Tables) AND (Lst_Tables.itemIndex > -1) THEN
        BEGIN
            accept := Lst_Tables.Checked[Lst_Tables.itemIndex];
        END;
    END;
END;

PROCEDURE TForm1.Button4Click(Sender: TObject);
VAR
    tsl: tstringlist;
    tum: TunModule;
BEGIN
    ForceDirectories(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Serveur');
    ForceDirectories(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Client');
    IF lb_module.itemindex > -1 THEN
    BEGIN
        tum := TunModule(lb_module.items.Objects[lb_module.itemindex]);
        tsl := tstringlist.create;
        TRY
            tsl.text := tum.Extract(Cb_Complet.Checked);
            tsl.SaveToFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Client\' + tum.Nom + 'Extract.xmlgram');
            tsl.SaveToFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Serveur\' + tum.Nom + 'Extract.xmlgram');
            tsl.text := tum.Batch(Cb_Complet.Checked);
            tsl.SaveToFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Client\' + tum.Nom + 'Batch.xmlgram');
            tsl.text := tum.BatchServ(Cb_Complet.Checked);
            tsl.SaveToFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Serveur\' + tum.Nom + 'Batch.xmlgram');
        FINALLY
            tsl.free;
        END;
    END;
END;

PROCEDURE TForm1.SpeedButton2Click(Sender: TObject);
VAR
    i: integer;
BEGIN
    IF lb_module.itemindex > 0 THEN
    BEGIN
        i := LesModules.IndexOf(lb_module.items.Objects[lb_module.itemindex]);
        LesModules.exchange(i, i - 1);
        lb_module.items.Exchange(lb_module.itemindex, lb_module.itemindex - 1);
    END;
END;

PROCEDURE TForm1.SpeedButton3Click(Sender: TObject);
VAR
    i: integer;
BEGIN
    IF lb_module.itemindex < lb_module.items.Count - 1 THEN
    BEGIN
        i := LesModules.IndexOf(lb_module.items.Objects[lb_module.itemindex]);
        LesModules.exchange(i, i + 1);
        lb_module.items.Exchange(lb_module.itemindex, lb_module.itemindex + 1);
    END;
END;

PROCEDURE TForm1.SpeedButton4Click(Sender: TObject);
VAR
    tm: TunModule;
BEGIN
    IF Lb_LstTbl.itemindex > 0 THEN
    BEGIN
        tm := TUnModule(lb_module.items.Objects[lb_module.itemindex]);
        tm.List.exchange(Lb_LstTbl.itemindex, Lb_LstTbl.itemindex - 1);
        Lb_LstTbl.items.exchange(Lb_LstTbl.itemindex, Lb_LstTbl.itemindex - 1);
    END;
END;

PROCEDURE TForm1.SpeedButton5Click(Sender: TObject);
VAR
    tm: TunModule;
BEGIN
    IF Lb_LstTbl.itemindex < Lb_LstTbl.items.Count - 1 THEN
    BEGIN
        tm := TUnModule(lb_module.items.Objects[lb_module.itemindex]);
        tm.List.exchange(Lb_LstTbl.itemindex, Lb_LstTbl.itemindex + 1);
        Lb_LstTbl.items.Exchange(Lb_LstTbl.itemindex, Lb_LstTbl.itemindex + 1);
    END;
END;

PROCEDURE TForm1.Button5Click(Sender: TObject);
VAR
    i: integer;
    tsl: tstringlist;
BEGIN
    ForceDirectories(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Serveur');
    ForceDirectories(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Client');
    tsl := tstringlist.create;
    TRY
        FOR i := 0 TO LesModules.count - 1 DO
        BEGIN
            tsl.text := TunModule(LesModules[i]).Extract(Cb_Complet.Checked);
            tsl.SaveToFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Client\' + TunModule(LesModules[i]).Nom + 'Extract.xmlgram');
            tsl.SaveToFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Serveur\' + TunModule(LesModules[i]).Nom + 'Extract.xmlgram');
            tsl.text := TunModule(LesModules[i]).Batch(Cb_Complet.Checked);
            tsl.SaveToFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Client\' + TunModule(LesModules[i]).Nom + 'Batch.xmlgram');
            tsl.text := TunModule(LesModules[i]).BatchServ(Cb_Complet.Checked);
            tsl.SaveToFile(IncludeTrailingBackslash(extractfilePath(application.exename)) + 'Serveur\' + TunModule(LesModules[i]).Nom + 'Batch.xmlgram');
        END;
    FINALLY
        tsl.free;
    END;
END;

PROCEDURE TForm1.Lb_LstTblKeyUp(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
VAR
    tm: TunModule;
    TT: TUneTable;
    i: integer;
BEGIN
    IF (Lb_LstTbl.itemindex <> -1) AND (key = vk_delete) THEN
    BEGIN
        i := Lb_LstTbl.itemindex;
        tm := TUnModule(lb_module.items.Objects[lb_module.itemindex]);
        tt := ChercheTable(tm.List[i]);
        tm.List.delete(i);
        Lb_LstTbl.items.delete(i);
        tt.Repliquer := true;
        i := Lst_Tables.Items.IndexOfObject(tt);
        Lst_Tables.Checked[i] := True;
    END;
END;

PROCEDURE TForm1.Lb_ModuleKeyUp(Sender: TObject; VAR Key: Word;
    Shift: TShiftState);
VAR
    tm: TunModule;
    TT: TUneTable;
    i, j: Integer;
BEGIN
    IF (lb_module.itemindex > -1) AND (key = vk_delete) THEN
    BEGIN
        i := lb_module.itemindex;
        IF application.messageBox(Pchar('Etes-vous sur de supprimer ' + lb_module.items[i]), ' Attention ', Mb_YesNo) = MrYes THEN
        BEGIN
            tm := TUnModule(lb_module.items.Objects[i]);
            lb_module.Items.Delete(i);
            LesModules.Delete(i);
            FOR i := 0 TO tm.List.count - 1 DO
            BEGIN
                tt := ChercheTable(tm.List[i]);
                tt.Repliquer := true;
                j := Lst_Tables.Items.IndexOfObject(tt);
                Lst_Tables.Checked[j] := True;
            END;
            tm.free;
        END;
    END;
END;

END.

