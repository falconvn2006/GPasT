unit uPrimo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, DB, ADODB, Grids, DBGrids, StdCtrls, Mask, DBCtrls,
  ExtCtrls;

type
  TfPrimo = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DBNavigator2: TDBNavigator;
    procedure FormCreate(Sender: TObject);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  fPrimo: TfPrimo;

implementation

{$R *.dfm}




procedure TfPrimo.FormCreate(Sender: TObject);
var
  cheminBD, chaineCnx : string;
begin
cheminBD := 'C:\Program Files\Borland\Delphi7\Projects\AdoPrimo\Client.mdb';
chaineCnx:= 'Provider=Microsoft.Jet.OLEDB.4.0;' +
            'User ID=Admin;' +
            'Data Source=' + cheminBD + ';' +
            'Mode=Share Deny None;Extended Properties="";' +
            'Jet OLEDB:System database="";Jet OLEDB:Registry Path="";' +
            'Jet OLEDB:Database Password="";Jet OLEDB:Engine Type=5;' +
            'Jet OLEDB:Database Locking Mode=1;' +
            'Jet OLEDB:Global Partial Bulk Ops=2;' +
            'Jet OLEDB:Global Bulk Transactions=1;' +
            'Jet OLEDB:New Database Password="";' +
            'Jet OLEDB:Create System Database=False;' +
            'Jet OLEDB:Encrypt Database=False;' +
            'Jet OLEDB:Don''t Copy Locale on Compact=False;' +
            'Jet OLEDB:Compact Without Replica Repair=False;' +
            'Jet OLEDB:SFP=False';
ADOConnection1.ConnectionString := chaineCnx ;
ADOTable1.Active := True;
end;

end.
