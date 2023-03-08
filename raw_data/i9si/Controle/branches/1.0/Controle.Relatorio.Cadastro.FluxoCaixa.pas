unit Controle.Relatorio.Cadastro.FluxoCaixa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Relatorio.Cadastro, uniDateTimePicker,
  uniGroupBox, uniBitBtn, uniEdit, uniCheckBox, uniGUIBaseClasses, uniImageList,
  Data.DB, Datasnap.Provider, Data.Win.ADODB, Datasnap.DBClient, uniButton,
  uniLabel, uniPanel, uniScrollBox;

type
  TControleRelatorioCadastroFluxoCaixa = class(TControleRelatorioCadastro)
    CheckBoxTodosClientes: TUniCheckBox;
    UniLabel2: TUniLabel;
    EditCliente: TUniEdit;
    BtPesquisaCliente: TUniBitBtn;
    GroupBoxSituacao: TUniGroupBox;
    CheckBoxAberto: TUniCheckBox;
    CheckBoxInadimplente: TUniCheckBox;
    UniLabel3: TUniLabel;
    DateTimePickerInicial: TUniDateTimePicker;
    UniLabel4: TUniLabel;
    DateTimePickerFinal: TUniDateTimePicker;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}



end.
