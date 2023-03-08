unit Controle.Consulta.Vendedor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, 
  uniGridExporters, uniCheckBox, uniLabel,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniBitBtn, 
  Vcl.Imaging.pngimage, uniImage;

type
  TControleConsultaVendedor = class(TControleConsulta)
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit4: TUniEdit;
    UniEdit5: TUniEdit;
    UniEdit6: TUniEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaTIPO: TWideStringField;
    CdsConsultaCPF_CNPJ: TWideStringField;
    CdsConsultaRAZAO_SOCIAL: TWideStringField;
    CdsConsultaNOME_FANTASIA: TWideStringField;
    CdsConsultaDATA_NASCIMENTO: TDateTimeField;
    CdsConsultaRG_INSC_ESTADUAL: TWideStringField;
    CdsConsultaCODIGO_REGIME_TRIBUTARIO: TWideStringField;
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

uses Controle.Cadastro.Vendedor, Controle.Main.Module;

// -------------------------------------------------------------------------- //
procedure TControleConsultaVendedor.Novo;
begin
  if ControleCadastroVendedor.Novo() then
  begin
    ControleCadastroVendedor.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaVendedor.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'vendedor';
end;

// -------------------------------------------------------------------------- //
procedure TControleConsultaVendedor.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroCliente.Create(Self);
  if ControleCadastroVendedor.Abrir(Id) then
  begin
    ControleCadastroVendedor.ConfiguraTipoPessoa;
    ControleCadastroVendedor.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;


end.
