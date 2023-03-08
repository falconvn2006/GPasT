unit Controle.Consulta.Fornecedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, uniGUIBaseClasses,
  uniImageList, uniToolBar, uniPanel, uniBasicGrid, uniDBGrid, uniEdit,
  uniButton, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client, Data.DB,
  FireDAC.Comp.DataSet, Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient,
   uniGridExporters, uniCheckBox, uniLabel, 
  frxClass, frxDBSet, frxExportBaseDialog, frxExportPDF, uniBitBtn, 
  Vcl.Imaging.pngimage, uniImage;

type
  TControleConsultaFornecedor = class(TControleConsulta)
    CdsConsultaID: TFloatField;
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaTIPO: TWideStringField;
    CdsConsultaCPF_CNPJ: TWideStringField;
    CdsConsultaRAZAO_SOCIAL: TWideStringField;
    CdsConsultaNOME_FANTASIA: TWideStringField;
    CdsConsultaDATA_NASCIMENTO: TDateTimeField;
    CdsConsultaRG_INSC_ESTADUAL: TWideStringField;
    CdsConsultaCODIGO_REGIME_TRIBUTARIO: TWideStringField;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit4: TUniEdit;
    UniEdit5: TUniEdit;
    UniEdit6: TUniEdit;
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

implementation

{$R *.dfm}


uses Controle.Cadastro.Fornecedor, Controle.Main.Module;

// -------------------------------------------------------------------------- //
procedure TControleConsultaFornecedor.Novo;
begin
  if ControleCadastroFornecedor.Novo() then
  begin
    ControleCadastroFornecedor.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaFornecedor.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'fornecedor';
end;

// -------------------------------------------------------------------------- //
procedure TControleConsultaFornecedor.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroCliente.Create(Self);
  if ControleCadastroFornecedor.Abrir(Id) then
  begin
    ControleCadastroFornecedor.ConfiguraTipoPessoa;
    ControleCadastroFornecedor.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;


end.
