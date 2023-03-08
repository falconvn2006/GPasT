unit Controle.Relatorio.ContasPagarObservacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Relatorio.Cadastro.ContasPagar, frxClass,
  frxDBSet, uniGUIBaseClasses, uniImageList, Data.DB, Datasnap.Provider,
  Data.Win.ADODB, Datasnap.DBClient, uniButton, uniGroupBox, uniEdit,
  uniCheckBox, uniBitBtn, uniLabel, uniPanel, uniScrollBox;

type
  TControleRelatorioContasPagarObservacao = class(TControleRelatorioCadastroContasPagar)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
