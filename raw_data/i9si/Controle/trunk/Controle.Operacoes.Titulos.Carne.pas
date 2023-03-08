unit Controle.Operacoes.Titulos.Carne;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Controle.Operacoes, Data.Win.ADODB,
  Datasnap.Provider, Data.DB, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniBitBtn, uniSpeedButton, uniLabel, uniButton, uniPanel,
  uniBasicGrid, uniDBGrid, uniPageControl, uniGroupBox;

type
  TControleOperacoesTitulosCarne = class(TControleOperacoes)
    UniPageControl1: TUniPageControl;
    UniTabSheet1: TUniTabSheet;
    UniTabSheet2: TUniTabSheet;
    UniGroupBox1: TUniGroupBox;
    GrdResultado: TUniDBGrid;
    UniGroupBox2: TUniGroupBox;
    UniDBGrid1: TUniDBGrid;
    UniPanel5: TUniPanel;
    UniButton1: TUniButton;
    UniButton2: TUniButton;
    UniLabel1: TUniLabel;
    procedure UniFormShow(Sender: TObject);
    procedure UniPageControl1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleOperacoesTitulosCarne: TControleOperacoesTitulosCarne;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication;

function ControleOperacoesTitulosCarne: TControleOperacoesTitulosCarne;
begin
  Result := TControleOperacoesTitulosCarne(ControleMainModule.GetFormInstance(TControleOperacoesTitulosCarne));
end;

procedure TControleOperacoesTitulosCarne.UniFormShow(Sender: TObject);
begin
  inherited;
  UniLabel1.Caption := 'Nessa aba você pode realizar operações  no TÍTULO que foi selecionado';
  UniPageControl1.ActivePageIndex := 0;
end;

procedure TControleOperacoesTitulosCarne.UniPageControl1Change(Sender: TObject);
begin
  inherited;
  if UniPageControl1.ActivePageIndex = 0 then
    UniLabel1.Caption := 'Nessa aba você pode realizar operações  no TÍTULO que foi selecionado'
  else if UniPageControl1.ActivePageIndex = 1 then
    UniLabel1.Caption := 'Nessa aba você pode editar o CARNÊ em que esta título que foi selecionado';
end;

end.
