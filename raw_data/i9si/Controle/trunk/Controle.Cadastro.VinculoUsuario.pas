unit Controle.Cadastro.VinculoUsuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Cadastro, Data.DB, Datasnap.DBClient,
  Datasnap.Provider, Data.Win.ADODB, uniGUIBaseClasses, uniImageList, uniButton,
  uniPanel, uniMultiItem, uniComboBox, uniDBComboBox, uniDBLookupComboBox,
  uniLabel;

type
  TControleCadastroVinculoUsuario = class(TControleCadastro)
    UniLabel1: TUniLabel;
    UniDBLookupComboBox1: TUniDBLookupComboBox;
    UniLabel3: TUniLabel;
    UniDBLookupComboBox2: TUniDBLookupComboBox;
    DscUsuario: TDataSource;
    ClientDataSet1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    ADOQuery1: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleCadastroVinculoUsuario: TControleCadastroVinculoUsuario;

implementation

{$R *.dfm}

uses
  MainModule, uniGUIApplication;

function ControleCadastroVinculoUsuario: TControleCadastroVinculoUsuario;
begin
  Result := TControleCadastroVinculoUsuario(UniMainModule.GetFormInstance(TControleCadastroVinculoUsuario));
end;

end.
