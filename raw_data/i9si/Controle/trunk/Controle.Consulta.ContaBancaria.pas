unit Controle.Consulta.ContaBancaria;

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
  TControleConsultaContaBancaria = class(TControleConsulta)
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaGERENCIANET_CLIENT_ID: TWideStringField;
    CdsConsultaGERENCIANET_CLIENT_SECRET: TWideStringField;
    CdsConsultaTIPOAMBIENTE: TWideStringField;
    CdsConsultaDESCRICAO: TWideStringField;
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
uses Controle.Cadastro.ContaBancaria, Controle.Main.Module;

{ TControleConsultaContaBancaria }

procedure TControleConsultaContaBancaria.Abrir(Id: Integer);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroBanco.Create(Self);
  if ControleCadastroContaBancaria.Abrir(Id) then
  begin
    ControleCadastroContaBancaria.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaContaBancaria.Novo;
begin
  inherited;
  if ControleCadastroContaBancaria.Novo() then
  begin
    ControleCadastroContaBancaria.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaContaBancaria.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'conta_bancaria';
end;

end.
