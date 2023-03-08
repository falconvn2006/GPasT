unit Extract;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  LMDControl, LMDBaseControl, LMDBaseGraphicButton, LMDCustomSpeedButton,
  LMDSpeedButton, Db, dxmdaset, Grids, DBGrids, IBCustomDataSet, IBQuery,
  IBDatabase;

type
  TForm1 = class(TForm)
    CLT: TdxMemData;
    CLTCLIENT: TStringField;
    CLTBASE: TStringField;
    LMDSpeedButton1: TLMDSpeedButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    base: TIBDatabase;
    QCLT: TIBQuery;
    CLTNBRE: TIntegerField;
    tran: TIBTransaction;
    procedure LMDSpeedButton1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.LMDSpeedButton1Click(Sender: TObject);
begin
     clt.DelimiterChar:=';';
     clt.LoadFromTextFile(ExtractFilePath(application.exename)+'\magasins.csv');

     clt.first;
     WHILE not clt.eof do
     begin
        base.databasename:=CLTBASE.asstring;
        base.open;
        qclt.open;
        clt.edit;
        CLTNBRE.asinteger:=qclt.fieldbyname('clt').asinteger;
        clt.post;
        qclt.close;
        base.close;
        clt.next;
     END;
     clt.SavetoTextFile(ExtractFilePath(application.exename)+'\magasins.csv');

end;

end.
