unit regul;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, dxmdaset, LMDControl, LMDBaseControl,
  LMDBaseGraphicButton, LMDCustomSpeedButton, LMDSpeedButton, ADODB;

type
  Tad = class(TForm)
    ado: TADOConnection;
    LMDSpeedButton1: TLMDSpeedButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    MemD: TdxMemData;
    MemDDATABASE: TStringField;
    MemDID: TStringField;
    QL: TADOQuery;
    MemD_E: TdxMemData;
    MemD_EDATABASE: TStringField;
    MemD_EID: TIntegerField;
    QE: TADOQuery;
    QC: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure LMDSpeedButton1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  ad: Tad;

implementation

{$R *.DFM}

procedure Tad.FormCreate(Sender: TObject);
begin
 ado.connected := true;
end;

procedure Tad.LMDSpeedButton1Click(Sender: TObject);
var ref:string;
begin
    memd.close;
    memd.DelimiterChar := ';';
    memd.LoadFromTextFile('C:\Developpement\Ginkoia\Utilitaire\CATMAN ADMIN\oxbow.csv');

    ref:='';
    memd.first;
    WHILE not memd.eof do
    begin
          IF ref=MemDDATABASE.asstring then
          begin
               memd.delete
          end
          else
          begin
               ref:=MemDDATABASE.asstring;
               memd.next;
          end
    END;

    //Liste épuré
    memd_e.open;
    memd.first;
    WHILE not memd.eof do
    begin
         ql.close;
         ql.parameters.parambyname('ref').value:=MemDDATABASE.asstring;
         ql.open;
         WHILE not ql.eof do
         begin
               memd_e.append;
               MemD_EDATABASE.asstring:=MemDDATABASE.asstring;
               MemD_EID.asinteger:=ql.fieldbyname('art_id').asinteger;
               memd_e.post;

               qe.close;
               qe.parameters.parambyname('artid').value:=ql.fieldbyname('art_id').asinteger;
               qe.ExecSQL;

               qc.close;
               qc.parameters.parambyname('artid').value:=ql.fieldbyname('art_id').asinteger;
               qc.ExecSQL;

               ql.next;

         END;
         memd.next;
    END;
    memd_e.DelimiterChar := ';';
    memd_e.SaveToTextFile('C:\Developpement\Ginkoia\Utilitaire\CATMAN ADMIN\oxbowID.csv');



end;

end.
