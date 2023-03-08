unit Controle.Operacoes.Relatorio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Operacoes, Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniBitBtn, uniSpeedButton, uniLabel, uniButton, uniPanel,
  uniEdit, uniDateTimePicker, uniMultiItem, uniComboBox;

type
  TControleOperacoes1 = class(TControleOperacoes)
    UniDateTimePicker1: TUniDateTimePicker;
    UniDateTimePicker2: TUniDateTimePicker;
    UniEdit1: TUniEdit;
    UniLabel2: TUniLabel;
    UniButton1: TUniButton;
    UniLabel3: TUniLabel;
    UniLabel4: TUniLabel;
    UniComboBox1: TUniComboBox;
    UniLabel1: TUniLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleOperacoes1: TControleOperacoes1;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleOperacoes1: TControleOperacoes1;
begin
  Result := TControleOperacoes1(ControleMainModule.GetFormInstance(TControleOperacoes1));
end;

end.
