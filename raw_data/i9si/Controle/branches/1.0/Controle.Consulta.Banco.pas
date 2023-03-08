unit Controle.Consulta.Banco;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses, uniImageList,
  uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit, 
  uniGridExporters, uniCheckBox, uniLabel,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniBitBtn, 
  Vcl.Imaging.pngimage, uniImage, Vcl.Menus, uniMainMenu, uniSweetAlert;

type
  TControleConsultaBanco = class(TControleConsulta)
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaCODIGO: TWideStringField;
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaCPF_CNPJ: TWideStringField;
    CdsConsultaRAZAO_SOCIAL: TWideStringField;
    CdsConsultaNOME_FANTASIA: TWideStringField;
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

uses Controle.Cadastro.Banco, Controle.Main.Module;

procedure TControleConsultaBanco.Novo;
begin
  if ControleCadastroBanco.Novo() then
  begin
    ControleCadastroBanco.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaBanco.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'banco';
end;

// -------------------------------------------------------------------------- //
procedure TControleConsultaBanco.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroBanco.Create(Self);
  if ControleCadastroBanco.Abrir(Id) then
  begin
    ControleCadastroBanco.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
      CdsConsulta.Refresh;
    end);
  end;
end;

end.
