unit Controle.Consulta.GrupoTributario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Consulta,  frxClass,
  frxDBSet, frxExportBaseDialog, frxExportPDF, uniGridExporters, uniBasicGrid,
   Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniGUIClasses, uniImageList,
  uniCheckBox, uniLabel, uniPanel, uniDBGrid, Vcl.Imaging.pngimage, uniImage,
  uniBitBtn,  uniButton, uniEdit, Vcl.Menus, uniMainMenu, uniSweetAlert;

type
  TControleConsultaGrupoTributario = class(TControleConsulta)
    QryConsultaID: TFloatField;
    QryConsultaDESCRICAO: TWideStringField;
    CdsConsultaID: TFloatField;
    CdsConsultaDESCRICAO: TWideStringField;
    UniEdit1: TUniEdit;
    procedure UniFrameCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

var
  ControleConsultaGrupoTributario: TControleConsultaGrupoTributario;

implementation

{$R *.dfm}

uses Controle.Cadastro.GrupoTributario;

procedure TControleConsultaGrupoTributario.Novo;
begin
  if ControleCadastroGrupoTributario.Novo() then
  begin
    ControleCadastroGrupoTributario.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaGrupoTributario.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'grupo_tributos';
end;

// -------------------------------------------------------------------------- //
procedure TControleConsultaGrupoTributario.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroBanco.Create(Self);
  if ControleCadastroGrupoTributario.Abrir(Id) then
  begin
    ControleCadastroGrupoTributario.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
      CdsConsulta.Refresh;
    end);
  end;
end;


end.
