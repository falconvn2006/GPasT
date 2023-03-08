unit Controle.Consulta.Responsavel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit;

type
  TControleConsultaResponsavel = class(TControleConsulta)
    CdsConsultaID: TFloatField;
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaTIPO: TWideStringField;
    CdsConsultaCPF_CNPJ: TWideStringField;
    CdsConsultaRAZAO_SOCIAL: TWideStringField;
    CdsConsultaNOME_FANTASIA: TWideStringField;
    CdsConsultaDATA_NASCIMENTO: TDateTimeField;
    CdsConsultaRG_INSC_ESTADUAL: TWideStringField;
    CdsConsultaTELEFONE: TWideStringField;
    CdsConsultaCELULAR: TWideStringField;
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit4: TUniEdit;
    UniEdit5: TUniEdit;
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

uses
  Controle.Cadastro.Responsavel;

{ TControleConsultaResponsavel }

procedure TControleConsultaResponsavel.Abrir(Id: Integer);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroCliente.Create(Self);
  if ControleCadastroResponsavel.Abrir(Id) then
  begin
    ControleCadastroResponsavel.ConfiguraTipoPessoa;
    ControleCadastroResponsavel.ShowModal;
    CdsConsulta.Refresh;
  end;
end;

procedure TControleConsultaResponsavel.Novo;
begin
  inherited;
  if ControleCadastroResponsavel.Novo() then
  begin
    ControleCadastroResponsavel.ShowModal;
    CdsConsulta.Refresh;
  end;
end;

procedure TControleConsultaResponsavel.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'responsavel';
end;

end.
