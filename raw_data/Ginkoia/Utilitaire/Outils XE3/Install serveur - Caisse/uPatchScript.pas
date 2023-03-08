unit uPatchScript;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.Types, System.IOutils,
  Data.DB, dialogs, FireDAC.Comp.Client,
  Vcl.ExtActns, Generics.Collections;

Type
  TpatchScript = class
    private
    class var Data: TFDConnection;
    Qry: TFDQuery;
//    SQL: TIBSQL;
    Tran: TFDTransaction;

    public

    class var DirGinkoia : string ;
    class var Dirbase : string ;
    class var Lame : string ;

    class procedure OpenBase ;
    class procedure CloseBase ;
    class function ConnectTo : boolean ;

  {*    class procedure Script ;
    class procedure Patch ;   * }
  end;

implementation

class procedure TpatchScript.Openbase;
begin
  Data := TFDConnection.Create(nil) ;
//  Data.SQLDialect := 3;
//  Data.LoginPrompt := false;
  Data.DriverName := 'IB';
  Data.Params.Clear();
  Data.Params.Add('Server=localhost');
  Data.Params.Add('Protocol=TCPIP');
  Data.Params.Add('DriverID=IB');
  Tran := TFDTransaction.Create(Nil);
  Tran.Connection := Data;
//  Data.DefaultTransaction := Tran;
//  SQL := TIBSQL.Create(Nil);
//  Sql.Database := Data;
//  Sql.Transaction := Tran;
  Qry := TFDQuery.Create(Nil);
  Qry.Connection := Data;
  Qry.Transaction := Tran;
end;

Class procedure TpatchScript.CloseBase;
begin
  Tran.Commit;
  Tran.Destroy ;
  Tran := nil ;
//  Sql.Close ;
//  Sql.Destroy ;
//  Sql := nil ;
  Qry.Close ;
  Qry.Destroy ;
  Qry := nil ;
  Data.Close ;
  Data.Destroy ;
  Data := nil ;
end;

Class function TpatchScript.ConnectTo : boolean;
var Aquoi : string ;
begin
 Aquoi := IncludeTrailingBackslash(DirBase)+'Ginkoia.IB' ;

 Data.Close ;
// data.Params.Values['user_name'] := 'sysdba' ;
// data.Params.Values['password'] := 'masterkey' ;
  data.Params.Add('Database=' +  Aquoi);
  data.Params.Add('User_Name=sysdba');
  data.Params.Add('Password=masterkey');
 Try
   Data.Open ;
   Tran.StartTransaction;
   result := true ;                            
  Except
    On E: Exception do
     begin
//       Error  := E.Message ;
       ShowMessage(E.Message);
       result := false ;
     end;
  End;
end;




end.
