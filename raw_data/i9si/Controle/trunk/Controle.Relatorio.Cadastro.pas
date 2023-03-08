unit Controle.Relatorio.Cadastro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, uniLabel, uniButton, uniGUIBaseClasses, uniPanel,
  Data.DB, Datasnap.Provider, Data.Win.ADODB, Datasnap.DBClient, uniImageList,
  frxClass, frxExportBaseDialog, frxExportPDF, frxDBSet, Controle.Server.Module,
  uniScrollBox;

type
  TControleRelatorioCadastro = class(TUniFrame)
    UniPanel1: TUniPanel;
    UniLabel1: TUniLabel;
    UniPanel2: TUniPanel;
    UniPanel3: TUniPanel;
    UniPanel4: TUniPanel;
    BtImprimir: TUniButton;
    CdsConsulta: TClientDataSet;
    QryConsulta: TADOQuery;
    DspConsulta: TDataSetProvider;
    DscConsulta: TDataSource;
    UniImageList1: TUniImageList;
    UniScrollBox1: TUniScrollBox;
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

 uses
    Controle.Main.Module, Controle.Impressao.Documento;

procedure TControleRelatorioCadastro.UniFrameCreate(Sender: TObject);
begin
//  CdsConsulta.Open;
end;

end.
