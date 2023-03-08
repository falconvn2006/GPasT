unit Controle.Consulta.Representante;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, 
  uniGridExporters, uniCheckBox, uniLabel,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniBitBtn, Vcl.Menus, uniMainMenu,
  uniSweetAlert;

type
  TControleConsultaRepresentante = class(TControleConsulta)
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

uses Controle.Cadastro.Representante, Controle.Main.Module;

// -------------------------------------------------------------------------- //
procedure TControleConsultaRepresentante.Novo;
begin
  if ControleCadastroRepresentante.Novo() then
  begin
    ControleCadastroRepresentante.ShowModal;
    CdsConsulta.Refresh;
  end;
end;

procedure TControleConsultaRepresentante.UniFrameCreate(Sender: TObject);
begin
  if ControleMainModule.FRepresentante <> 0 then
  begin
    CdsConsulta.Filtered := False;
    Cdsconsulta.Filter := 'id = ' + QuotedStr(IntTostr(ControleMainModule.FRepresentante));
    CdsConsulta.Filtered := True;
  end;

  inherited;
  FNomeTabela := 'representante';
end;

// -------------------------------------------------------------------------- //
procedure TControleConsultaRepresentante.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroCliente.Create(Self);
  if ControleCadastroRepresentante.Abrir(Id) then
  begin
    ControleCadastroRepresentante.ConfiguraTipoPessoa;
    ControleCadastroRepresentante.ShowModal;
    CdsConsulta.Refresh;
  end;
end;

end.
