unit Controle.Consulta.TituloCategoria;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniGridExporters, uniBasicGrid,
   Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniImageList, uniCheckBox, uniLabel,
  uniPanel, uniDBGrid, Vcl.Imaging.pngimage, uniImage, uniBitBtn, 
  uniButton, uniEdit, uniMultiItem, uniComboBox;

type
  TControleConsultaTituloCategoria = class(TControleConsulta)
    UniEdit1: TUniEdit;
    QryConsultaID: TFloatField;
    QryConsultaDESCRICAO: TWideStringField;
    QryConsultaTIPO_TITULO: TWideStringField;
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaTIPO_TITULO: TWideStringField;
    UniComboBox1: TUniComboBox;
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

implementation

uses
  Controle.Cadastro.TituloCategoria;

{$R *.dfm}


procedure TControleConsultaTituloCategoria.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'titulo_categoria';
end;

procedure TControleConsultaTituloCategoria.Abrir(Id: Integer);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  if ControleCadastroTituloCategoria.Abrir(Id) then
  begin
    ControleCadastroTituloCategoria.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaTituloCategoria.Novo;
begin
  inherited;
  if ControleCadastroTituloCategoria.Novo() then
  begin
    ControleCadastroTituloCategoria.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;


end.
