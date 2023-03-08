unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, dxmdaset, StdCtrls, IBCustomDataSet, IBQuery,
  IBDatabase;

type
  TForm1 = class(TForm)
    base: TIBDatabase;
    IBT: TIBTransaction;
    Qcb: TIBQuery;
    Button1: TButton;
    M: TdxMemData;
    Mcode: TStringField;
    Mrtail: TIntegerField;
    Mbarre: TStringField;
    DBGrid2: TDBGrid;
    DataSource1: TDataSource;
    Mcbanamag: TStringField;
    ODI: TOpenDialog;
    QCBREF: TIBQuery;
    QArtcb: TIBQuery;
    QK: TIBQuery;
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var cb:string;
begin
 base.close;
 if not ODI.Execute then  EXIT;
 base.databasename:=ODI.files[0];
      



 base.open;
 m.DelimiterChar:=';';
 m.LoadFromTextFile(extractFilePath(application.exename)+'barfou.csv');
 //MessageDlg(inttostr(m.recordcount), mtWarning, [], 0);

 M.first;
 WHILE not M.eof do
 begin

     //Recherche si cb existant
     qcbref.close;
     qcbref.parambyname('cb').asstring:=Mbarre.asstring;
     qcbref.open;
     if not qcbref.eof then
     begin

        //Code article
        cb:=inttostr(9000000000+strtoint(MCODE.asstring));

        //Taille
        IF MrTAIL.asinteger<10 then
            cb:=cb+'0'+inttostr(MrTAIL.asinteger)
        else
            cb:=cb+inttostr(MrTAIL.asinteger);

        //Recherche du CD
        qcb.close;
        qcb.parambyname('cb').asstring:=cb;
        qcb.open;

        //Insert K
        Qk.close;
        Qk.open;


        //Insert cb
        qartcb.close;
        qartcb.parambyname('id').asinteger:=qk.fieldbyname('id').asinteger;
        qartcb.parambyname('arfid').asinteger:=qcbref.fieldbyname('cbi_arfid').asinteger;
        qartcb.parambyname('tgfid').asinteger:=qcbref.fieldbyname('cbi_tgfid').asinteger;
        qartcb.parambyname('couid').asinteger:=qcbref.fieldbyname('cbi_couid').asinteger;
        qartcb.parambyname('cb').asstring:=cb+qcb.fieldbyname('result').asstring;
        qartcb.ExecSQL;
        ibt.commit;



     end;

     m.next;
 END;
 //m.SaveToTextFile('C:\Developpement\Ginkoia\UTILITAIRE\CB Winmag-Anamag\barfou.txt');
end;

end.
