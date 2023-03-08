UNIT UBase_Date;

INTERFACE

USES
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    Db, IBCustomDataSet, IBQuery, IBDatabase, StdCtrls, Buttons;

TYPE
    TForm1 = CLASS(TForm)
        Edit1: TEdit;
        SpeedButton1: TSpeedButton;
        Od: TOpenDialog;
        Button1: TButton;
        Base: TIBDatabase;
        Tran: TIBTransaction;
        Que_listetable: TIBQuery;
        que_unetable: TIBQuery;
        Que_verif: TIBQuery;
        Que_selectK: TIBQuery;
        Que_listetableLATABLE: TIBStringField;
        Que_listetableLECHAMPS: TIBStringField;
        tran2: TIBTransaction;
        lb: TListBox;
        que_unetableCHAMPS: TIBStringField;
        que_unetableTIPE: TSmallintField;
        Que_Select: TIBQuery;
        PROCEDURE Button1Click(Sender: TObject);
    PRIVATE
    { Déclarations privées }
    PUBLIC
    { Déclarations publiques }
    END;

    TChamps = CLASS
        Nom: STRING;
        Quoted: Boolean;
        Valeur: STRING;
        CONSTRUCTOR Create(Champs: STRING; tipe: integer);
        FUNCTION LaValeur: STRING;
    END;
    TuneTable = CLASS
        nom: STRING;
        leschamps: Tlist;
        Champs: STRING;
        CONSTRUCTOR Create(table, Lechamps: STRING);
        PROCEDURE CrerLesChamps;
        FUNCTION Select: STRING;
        PROCEDURE Assigne(Query: TIBQuery);
        FUNCTION delete: STRING;
        FUNCTION Inserte: STRING;
        DESTRUCTOR destroy; OVERRIDE;
        FUNCTION ID : STRING ;
    END;

VAR
    Form1: TForm1;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TForm1.Button1Click(Sender: TObject);
VAR
    K: TuneTable;
    EnCours: TuneTable;
    tsl : tstringlist ;
BEGIN
    tsl := tstringlist.Create ;
    ShortDateFormat := 'MM/DD/YYYY';
    DecimalSeparator := '.';

    Base.close;
    Base.DatabaseName := edit1.text;
    Base.Open;

    que_unetable.Close;
    K := TUneTable.Create('K', '');

    Que_listetable.Open;
    Que_listetable.First;
    WHILE NOT (Que_listetable.eof) DO
    BEGIN
        IF (trim(Que_listetableLATABLE.AsString) <> 'K')
           And (Copy(trim(Que_listetableLATABLE.AsString),1,3) <> 'AGR')
           And (trim(Que_listetableLATABLE.AsString) <> 'TARACHATCOUR') THEN
        BEGIN
            Caption := trim(Que_listetableLATABLE.AsString);
            update;
            Que_verif.Close;
            Que_verif.Sql.Clear;
            Que_verif.Sql.Add('Select count(*)');
            Que_verif.Sql.Add('from ' + trim(Que_listetableLATABLE.AsString));
            Que_verif.Sql.Add('Where ' + Que_listetableLECHAMPS.AsString + ' > ''01/01/2005''');
            Que_verif.Open;
            IF Que_verif.fields[0].asinteger > 0 THEN
            BEGIN
                lb.items.add(Que_listetableLATABLE.AsString);
                EnCours := TUneTable.Create(Que_listetableLATABLE.AsString, Que_listetableLECHAMPS.AsString);
                Que_Select.Close;
                Que_Select.Sql.text := EnCours.Select;
                Que_Select.Open;
                Que_Select.first;
                WHILE NOT Que_Select.Eof DO
                BEGIN
                    Encours.Assigne (Que_Select);
                    Que_selectK.Close ;
                    Que_selectK.Params[0].AsString := Encours.ID ;
                    Que_selectK.Open ;
                    K.Assigne (Que_selectK) ;
                    Que_selectK.Close ;
                    tsl.Add (K.delete+';') ;
                    tsl.Add (Encours.delete+';') ;
                    tsl.Add (K.Inserte+';') ;
                    tsl.Add (Encours.Inserte+';') ;
                    Que_Select.next;
                END;
                Que_Select.close;
                Encours.free;
            END;
            Que_verif.Close;
        END;
        Que_listetable.next;
    END;
    K.Free;
    Que_listetable.Close;
    tsl.SaveToFile (Changefileext(Application.exename,'.txt')) ;
    tsl.free ;
END;

{ TChamps }

CONSTRUCTOR TChamps.Create(Champs: STRING; tipe: integer);
BEGIN
    Nom := trim(Champs);
    CASE tipe OF
        8, 10, 27 : Quoted := false
    ELSE
        quoted := true;
    END;
    Valeur := '';
END;

FUNCTION TChamps.LaValeur: STRING;
BEGIN
    result := Valeur;
    IF Quoted THEN
        result := QuotedStr(result);
END;

{ TuneTable }

PROCEDURE TuneTable.Assigne(Query: TIBQuery);
VAR
    i: integer;
    S: STRING;
    j, m, a: Integer;
BEGIN
    FOR i := 0 TO leschamps.count - 1 DO
    BEGIN
        IF TChamps(leschamps[i]).nom = Champs THEN
        BEGIN
            S := Query.FieldByName(TChamps(leschamps[i]).Nom).AsString;
            M := Strtoint(Copy(S, 1, 2));
            J := Strtoint(Copy(S, 4, 2));
            A := Strtoint(Copy(S, 7, 4));
            IF (M=12) and (A = 2005) THEN
                S := inttostr(M - 2) + '/' + inttostr(j) + '/' + Inttostr(A-1);
            TChamps(leschamps[i]).Valeur := S;
        END
        ELSE
            TChamps(leschamps[i]).Valeur := Query.FieldByName(TChamps(leschamps[i]).Nom).AsString;
    END;
END;

CONSTRUCTOR TuneTable.Create(table, Lechamps: STRING);
BEGIN
    nom := trim(table);
    leschamps := Tlist.Create;
    Champs := trim(Lechamps);
    CrerLesChamps;
END;

PROCEDURE TuneTable.CrerLesChamps;
VAR
    chp: TChamps;
BEGIN
    form1.que_unetable.Params[0].AsString := Nom;
    form1.que_unetable.Open;
    form1.que_unetable.First;
    WHILE NOT form1.que_unetable.Eof DO
    BEGIN
        Chp := TChamps.create(form1.que_unetableCHAMPS.AsString, form1.que_unetableTIPE.AsInteger);
        leschamps.Add(Chp);
        form1.que_unetable.next;
    END;
    form1.que_unetable.close;
END;

FUNCTION TuneTable.delete: STRING;
BEGIN
    result := 'DELETE FROM ' + nom + ' WHERE ' + TChamps(leschamps[0]).Nom + ' = ' + TChamps(leschamps[0]).LaValeur;
END;

DESTRUCTOR TuneTable.destroy;
VAR
    i: integer;
BEGIN
    FOR i := 0 TO leschamps.count - 1 DO
        TChamps(leschamps[i]).free;
    leschamps.free;
    INHERITED;
END;

function TuneTable.ID: STRING;
begin
  result := TChamps(leschamps[0]).LaValeur ;
end;

FUNCTION TuneTable.Inserte: STRING;
VAR
    i: integer;
BEGIN
    IF Uppercase(Nom) = 'K' THEN
    BEGIN
        result := 'INSERT INTO ' + Nom + ' (';
        FOR i := 0 TO leschamps.count - 2 DO
            result := result + TChamps(leschamps[i]).Nom + ', ';
        result := result + TChamps(leschamps[leschamps.count - 1]).Nom + ') VALUES (';
        FOR i := 0 TO leschamps.count - 2 DO
        BEGIN
            IF uppercase(TChamps(leschamps[i]).Nom) = 'K_VERSION' THEN
                result := result + 'GEN_ID(GENERAL_ID,1), '
            ELSE
                result := result + TChamps(leschamps[i]).LaValeur + ', ';
        END ;
        result := result + TChamps(leschamps[leschamps.count - 1]).LaValeur + ')';
    END
    ELSE
    BEGIN
        result := 'INSERT INTO ' + Nom + ' (';
        FOR i := 0 TO leschamps.count - 2 DO
            result := result + TChamps(leschamps[i]).Nom + ', ';
        result := result + TChamps(leschamps[leschamps.count - 1]).Nom + ') VALUES (';
        FOR i := 0 TO leschamps.count - 2 DO
            result := result + TChamps(leschamps[i]).LaValeur + ', ';
        result := result + TChamps(leschamps[leschamps.count - 1]).LaValeur + ')';
    END;
END;

FUNCTION TuneTable.Select: STRING;
VAR
    i: integer;
BEGIN
    result := 'Select ';
    FOR i := 0 TO leschamps.count - 2 DO
        result := result + TChamps(leschamps[i]).Nom + ', ';
    result := result + TChamps(leschamps[leschamps.count - 1]).Nom + ' FROM '+NOM+' WHERE ' + Champs + ' > ''01/01/2005''';
END;

END.

