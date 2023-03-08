unit Controle.Consulta.Filial;

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
  TControleConsultaFilial = class(TControleConsulta)
    CdsConsultaID: TFloatField;
    CdsConsultaCODIGO: TWideStringField;
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaCPF_CNPJ: TWideStringField;
    CdsConsultaRAZAO_SOCIAL: TWideStringField;
    CdsConsultaNOME_FANTASIA: TWideStringField;
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

uses Controle.Cadastro.Filial, Controle.Main.Module;


// -------------------------------------------------------------------------- //
procedure TControleConsultaFilial.Novo;
begin
  ControleMainModule.MensageiroSweetAlerta('Atenção','A inclusão de multiplas filiais não é permitida!');

 { if ControleCadastroFilial.Novo(CdsConsulta) then
  begin
    ControleCadastroFilial.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;}
end;

procedure TControleConsultaFilial.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'filial';
end;

// -------------------------------------------------------------------------- //
procedure TControleConsultaFilial.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastrofilial.Create(Self);
  if ControleCadastroFilial.Abrir(Id) then
  begin
    ControleCadastroFilial.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

end.
