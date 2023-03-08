unit uBasetest;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types,
  Data.DB, FireDAC.Comp.Client, dialogs,
  System.IOutils, Vcl.ExtActns, Generics.Collections,
  System.IniFiles  ;

Type

  TbeforeAction = reference to procedure(Action: integer);
  TAfterAction = reference to procedure(Action: integer);

  TBaseTest = class
  public
    class var Source: string;
    class var Destination: string;
    class var error: string;
    class var BeforeAction: TbeforeAction;
    class var AfterAction: TAfterAction;

    Class function Copy: boolean; // action 1
    Class function Deperso: boolean; // action 2
    Class Function UpdateCaisse : boolean; // Action 3
    Class function RenamePwd: boolean; // action 4
    Class function RenameUtil: boolean; // action 5
    Class function ModifyTicket(sEntete: string): boolean; // action 6 ;
    Class function UpdateIni : boolean ; // mise à jour du fichier Ginkoia.ini
  end;

implementation

class function TBaseTest.Copy: boolean;
begin
  if Source.IsEmpty = true then
    exit(false);
  if Destination.IsEmpty = true then
    exit(false);
  Try
    if Assigned(BeforeAction) then
      BeforeAction(1);
    Tfile.Copy(Source, Destination, true);
    if Assigned(AfterAction) then
      AfterAction(1);
    result := true;
  Except
    On E: Exception do
    begin
      error := E.Message;
      result := false;
    end;
  End;
end;


class function TbaseTest.UpdateCaisse : boolean ;
var
  sTicket, sSql, sUsql: string;
  Data : TFDConnection;
  Qry  : TFDQuery;
  Usql : TFDQuery;
  Tran : TFDTransaction;

  caiid: integer;
  procedure Close;
  begin
    Tran.Destroy;
    Tran := nil;
    Qry.Close;
    Qry.Destroy;
    Qry := nil;
    USql.Destroy;
    USql := nil;
//    Data.CloseDataSets;
    Data.Close;
    Data.Destroy;
    Data := nil;
  end;

begin
  Try
    if Assigned(BeforeAction) then
      BeforeAction(3);
    Data := TFDConnection.Create(nil);
    Data.LoginPrompt := false;

    Tran := TFDTransaction.Create(Nil);
    Tran.Connection  := Data;
    Data.Transaction := Tran;

    USql := TFDQuery.Create(Nil);
    USql.Connection   := Data;
    USql.Transaction  := Tran;

    Qry := TFDQuery.Create(Nil);
    Qry.Connection   := Data;
    Qry.Transaction  := Tran;
//    Qry.UpdateObject := USql;

    sSql := 'SELECT * FROM CSHCAISSEPARAM WHERE CAI_ID >0';

    Data.Params.Clear();
    Data.DriverName := 'IB';
    Data.Params.Add('Server=127.0.0.1/3050');

    Data.Params.Values['user_name'] := 'sysdba';
    Data.Params.Values['password'] := 'masterkey';

    Data.Params.Add('Database=' + Destination);
    Data.Params.Add('Protocol=TCPIP');
    Data.Params.Add('DriverID=IB');

    try
      Data.Open;
      Tran.StartTransaction;
      Qry.SQL.Add(sSql);
      Qry.Open;
      Qry.First;

      if Qry.recordcount > 0 then
      begin
        While Qry.Eof = false do
        begin
            // ici inverser le prix de caisse
            caiid := Qry.FieldByName('CAI_ID').AsInteger;
            USql.SQL.Clear;
            sUsql := 'UPDATE CSHCAISSEPARAM SET CAI_PRIXENFRANC = 1' +
                     'CAI_JCBANDE = 1, CAI_GROSPIX = 1'+ ' WHERE CAI_ID=' + Inttostr(caiid);
            Usql.SQL.Add(sUsql);
            USql.ExecSQL;
          Qry.Next;
        end;
      end;

      Qry.Close;
      result := true;
      Close;
      if Assigned(AfterAction) then
        AfterAction(3);
    except
      ON E: Exception do
      begin
        Tran.Rollback;
        error := E.Message;
        result := false;
        Close;
        exit;
      end;
    end;
  Except
    ON E: Exception do
    begin
      Tran.Rollback;
      error := E.Message;
      result := false;
      Close;
      exit;
    end;
  End;

end;

class function TBaseTest.ModifyTicket(sEntete: string): boolean;
var
  sTicket, sSql, sUsql: string;
  Data : TFDConnection;
  Qry  : TFDQuery;
  Usql : TFDQuery;
  Tran : TFDTransaction;
  caiid: integer;
  procedure Close;
  begin
    Tran.Destroy;
    Tran := nil;
    Qry.Close;
    Qry.Destroy;
    Qry := nil;
    USql.Destroy;
    USql := nil;
    Data.Close;
    Data.Destroy;
    Data := nil;
  end;

begin
  Try
    if Assigned(BeforeAction) then
      BeforeAction(6);

    Data := TFDConnection.Create(nil);

    Data.LoginPrompt := false;
    Tran := TFDTransaction.Create(Nil);

    Tran.Connection  := Data;
    Data.Transaction := Tran;

    USql := TFDQuery.Create(Nil);
    USql.Connection   := Data;
    USql.Transaction  := Tran;

    Qry := TFDQuery.Create(Nil);
    Qry.Connection   := Data;
    Qry.Transaction  := Tran;

    sSql := 'SELECT * FROM CSHCAISSEPARAM WHERE CAI_ID >0';

    Data.Params.Clear();
    Data.DriverName := 'IB';
    Data.Params.Add('Server=127.0.0.1/3050');

    Data.Params.Values['user_name'] := 'sysdba';
    Data.Params.Values['password'] := 'masterkey';

    Data.Params.Add('Database=' + Destination);
    Data.Params.Add('Protocol=TCPIP');
    Data.Params.Add('DriverID=IB');

    try
      Data.Open;
      Tran.StartTransaction;
      Qry.SQL.Add(sSql);
      Qry.Open;
      Qry.First;
      if Qry.recordcount > 0 then
      begin
        While Qry.Eof = false do
        begin
          if Trim(Qry.FieldByName('CAI_PIED').AsString) <> '' then
          begin
            caiid := Qry.FieldByName('CAI_ID').AsInteger;
            USql.SQL.Clear;
            sUsql := 'UPDATE CSHCAISSEPARAM SET CAI_PIED = ' +
              QuotedStr(sEntete) + ' WHERE CAI_ID=' + Inttostr(caiid);
            USql.SQL.Add(sUsql);
            USql.ExecSQL
          end;
          Qry.Next;
        end;
      end;
      Qry.Close;
      result := true;
      Close;
      if Assigned(AfterAction) then
        AfterAction(6);
    except
      ON E: Exception do
      begin
        Tran.Rollback;
        error := E.Message;
        result := false;
        Close;
        exit;
      end;
    end;
  Except
    ON E: Exception do
    begin
      Tran.Rollback;
      error := E.Message;
      result := false;
      Close;
      exit;
    end;
  End;

end;

class function TBaseTest.RenameUtil;
var
  Data : TFDConnection;
  Qry  : TFDQuery;
  Usql : TFDQuery;
  Tran : TFDTransaction;

  sSql, sUsql, sUtil, sName: string;
  usrid: integer;
  procedure Close;
  begin
    Tran.Destroy;
    Tran := nil;
    Qry.Close;
    Qry.Destroy;
    Qry := nil;
    USql.Destroy;
    USql := nil;
    Data.Close;
    Data.Destroy;
    Data := nil;
  end;

begin

  Try
    if Assigned(BeforeAction) then
      BeforeAction(5);

    Data := TFDConnection.Create(nil);
    Data.LoginPrompt := false;
    Tran := TFDTransaction.Create(Nil);

    Tran.Connection  := Data;
    Data.Transaction := Tran;

    USql := TFDQuery.Create(Nil);
    USql.Connection   := Data;
    USql.Transaction  := Tran;

    Qry := TFDQuery.Create(Nil);
    Qry.Connection   := Data;
    Qry.Transaction  := Tran;

    sUtil := 'util';

    sSql := 'SELECT * FROM UILUSERS WHERE USR_USERNAME=' + QuotedStr(sUtil);

    Data.Params.Clear();
    Data.DriverName := 'IB';
    Data.Params.Add('Server=127.0.0.1/3050');

    Data.Params.Values['user_name'] := 'sysdba';
    Data.Params.Values['password'] := 'masterkey';

    Data.Params.Add('Database=' + Destination);
    Data.Params.Add('Protocol=TCPIP');
    Data.Params.Add('DriverID=IB');

    try
      Data.Open;
      Tran.StartTransaction;
      Qry.SQL.Add(sSql);
      Qry.Open;
      Qry.First;
      if Qry.recordcount > 0 then
      begin
        usrid := Qry.FieldByName('USR_ID').AsInteger;
        sName := 'test';
        USql.SQL.Clear;
        sUsql := 'UPDATE UILUSERS SET USR_USERNAME = ' + QuotedStr(sUtil) +
          ' WHERE USR_ID=' + Inttostr(usrid);
        USql.SQL.Add(sUsql);
        USql.ExecSQL;
      end;
      Qry.Close;
      result := true;
      Close;
      if Assigned(AfterAction) then
        AfterAction(5);
    except
      ON E: Exception do
      begin
        Tran.Rollback;
        error := E.Message;
        result := false;
        Close;
        exit;
      end;
    end;
  Except
    ON E: Exception do
    begin
      Tran.Rollback;
      error := E.Message;
      result := false;
      Close;
      exit;
    end;
  End;

end;

class function TBaseTest.RenamePwd: boolean;
var
  Data : TFDConnection;
  Qry  : TFDQuery;
  Usql : TFDQuery;
  Tran : TFDTransaction;

  sSql, sUsql, sPwd, sAlgol: string;
  usrid: integer;
  procedure Close;
  begin
    Tran.Destroy;
    Tran := nil;
    Qry.Close;
    Qry.Destroy;
    Qry := nil;
    USql.Destroy;
    USql := nil;
    Data.Close;
    Data.Destroy;
    Data := nil;
  end;

begin

  Try
    if Assigned(BeforeAction) then
      BeforeAction(4);
    Data := TFDConnection.Create(nil);
    Data.LoginPrompt := false;
    Tran := TFDTransaction.Create(Nil);

    Tran.Connection  := Data;
    Data.Transaction := Tran;

    USql := TFDQuery.Create(Nil);
    USql.Connection   := Data;
    USql.Transaction  := Tran;

    Qry := TFDQuery.Create(Nil);
    Qry.Connection   := Data;
    Qry.Transaction  := Tran;


    sSql := 'SELECT * FROM UILUSERS WHERE USR_ID > 0';

    Data.Params.Clear();
    Data.DriverName := 'IB';
    Data.Params.Add('Server=127.0.0.1/3050');

    Data.Params.Values['user_name'] := 'sysdba';
    Data.Params.Values['password'] := 'masterkey';

    Data.Params.Add('Database=' + Destination);
    Data.Params.Add('Protocol=TCPIP');
    Data.Params.Add('DriverID=IB');

    try
      Data.Open;
      Tran.StartTransaction;
      Qry.SQL.Add(sSql);
      Qry.Open;
      Qry.First;
      sPwd := 'test';
      sAlgol := 'algol';
      While Qry.Eof = false do
      begin
        if Qry.FieldByName('USR_USERNAME').AsString <> sAlgol then
        begin
          usrid := Qry.FieldByName('USR_ID').AsInteger;
          USql.SQL.Clear;
          sUsql := 'UPDATE UILUSERS SET USR_PASSWORD = ' + QuotedStr(sPwd) +
            ' WHERE USR_ID=' + Inttostr(usrid);
          USql.SQL.Add(sUsql);
          USql.SQL.Append(sUsql);
        end;
        Qry.Next;
      end;
      Qry.Close;
      result := true;
      Close;
      if Assigned(AfterAction) then
        AfterAction(4);
    except
      ON E: Exception do
      begin
        Tran.Rollback;
        error := E.Message;
        result := false;
        Close;
        exit;
      end;
    end;

  Except
    ON E: Exception do
    begin
      Tran.Rollback;
      error := E.Message;
      result := false;
      Close;
      exit;
    end;
  End;

end;

class function TBaseTest.Deperso: boolean;
var
  Data : TFDConnection;
  Qry  : TFDQuery;
  Usql : TFDQuery;
  Tran : TFDTransaction;

  sSql, sUsql, sMag: string;
  k, Magid, Socid: integer;
  procedure Close;
  begin
    Tran.Destroy;
    Tran := nil;
    Qry.Close;
    Qry.Destroy;
    Qry := nil;
    USql.Destroy;
    USql := nil;
    Data.Close;
    Data.Destroy;
    Data := nil;
  end;

begin
  Try
    if Assigned(BeforeAction) then
      BeforeAction(2);

    Data := TFDConnection.Create(nil);
    Data.LoginPrompt := false;
    Tran := TFDTransaction.Create(Nil);

    Tran.Connection  := Data;
    Data.Transaction := Tran;

    USql := TFDQuery.Create(Nil);
    USql.Connection   := Data;
    USql.Transaction  := Tran;

    Qry := TFDQuery.Create(Nil);
    Qry.Connection   := Data;
    Qry.Transaction  := Tran;

    Data.Params.Clear();
    Data.DriverName := 'IB';
    Data.Params.Add('Server=127.0.0.1/3050');

    Data.Params.Values['user_name'] := 'sysdba';
    Data.Params.Values['password'] := 'masterkey';

    Data.Params.Add('Database=' + Destination);
    Data.Params.Add('Protocol=TCPIP');
    Data.Params.Add('DriverID=IB');

    sSql := 'SELECT * FROM GENMAGASIN WHERE MAG_ID > 0';

    Data.Open;
    Tran.StartTransaction;
    Qry.SQL.Add(sSql);
    Qry.Open;
    Qry.First;
    k := 1;

    Try
      // magasins
      While Qry.Eof = false do
      begin
        Magid := Qry.FieldByName('MAG_ID').AsInteger;
        sMag := 'MAGASIN TEST ' + Inttostr(k);
        USql.SQL.Clear;
        sUsql := 'UPDATE GENMAGASIN SET MAG_NOM = ' + QuotedStr(sMag) +
          ', MAG_ENSEIGNE =' + QuotedStr(sMag) + ' WHERE MAG_ID =' +
          Inttostr(Magid);
        USql.SQL.Add(sUsql);
        USql.ExecSQL;
        Qry.Next;
        inc(k);
      end;

      Tran.Commit;
    Except
      ON E: Exception do
      begin
        Tran.Rollback;
        error := E.Message;
        result := false;
        Close;
        exit;
      end;
    END;
    Tran.StartTransaction;
    Qry.Close;
    Qry.SQL.Clear;
    sSql := 'SELECT * FROM GENSOCIETE WHERE SOC_ID > 0';
    Qry.SQL.Add(sSql);

    Tran.StartTransaction;
    Qry.Open;
    Qry.First;
    k := 1;
    Try
      // societes
      While Qry.Eof = false do
      begin
        Socid := Qry.FieldByName('SOC_ID').AsInteger;
        sMag := 'SOCIETE ' + Inttostr(k);
        USql.SQL.Clear;
        sUsql := 'UPDATE GENSOCIETE SET SOC_NOM = ' + QuotedStr(sMag) +
          ' WHERE SOC_ID =' + Inttostr(Socid);
        USql.SQL.Add(sUsql);
        //USql.ExecSQL(ukModify);
        USql.ExecSQL;
        Qry.Next;
        inc(k);
      end;
      Tran.Commit;
      result := true;
      Close;
    Except
      ON E: Exception do
      begin
        Tran.Rollback;
        error := E.Message;
        result := false;
        Close;
        exit;
      end;
    END;

    if Assigned(AfterAction) then
      AfterAction(2);
  Except
    On E: Exception do
    begin
      error := E.Message;
      result := false;
      Close;
      exit;
    end;
  End;
end;


Class function Tbasetest.UpdateIni : boolean ;
var sFile, sG, sC : string ;
begin
  // mise à jour du fichier Ginkoia ini en path1 et item1
  sFile := Tpath.GetDirectoryName(Source)   ;
  sFile := Tdirectory.GetParent(sFile)   ;
  sG := IncludeTrailingBackslash(sFile)+'Ginkoia.ini' ;
  With Tinifile.Create(sG) do
   Begin
     WriteString('DATABASE', 'PATH1', Destination) ;
     WriteString('NOMBASES', 'ITEM1', 'Base TEST');
     free ;
   End;
  sC := IncludeTrailingBackslash(sFile)+'Caisseginkoia.ini';
  With Tinifile.Create(sG) do
   Begin
     WriteString('DATABASE', 'PATH1', Destination) ;
     WriteString('NOMBASES', 'ITEM1', 'Base TEST');
     free ;
   End;
end;

end.
