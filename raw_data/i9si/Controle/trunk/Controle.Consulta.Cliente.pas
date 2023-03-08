unit Controle.Consulta.Cliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.Client, Data.DB, FireDAC.Comp.DataSet, uniGUIBaseClasses,
  uniImageList, uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit,
  uniScreenMask, Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient, uniMemo,
  uniLabel,  uniGridExporters, uniCheckBox, 
  frxClass, frxDBSet, frxExportBaseDialog, frxExportPDF, uniBitBtn, 
  Vcl.Imaging.pngimage, uniImage, Vcl.Menus, uniMainMenu, uniSweetAlert;

type
  TControleConsultaCliente = class(TControleConsulta)
    UniEdit1: TUniEdit;
    UniEdit2: TUniEdit;
    UniEdit3: TUniEdit;
    UniEdit4: TUniEdit;
    UniEdit5: TUniEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaTIPO: TWideStringField;
    CdsConsultaCPF_CNPJ: TWideStringField;
    CdsConsultaRAZAO_SOCIAL: TWideStringField;
    CdsConsultaNOME_FANTASIA: TWideStringField;
    CdsConsultaDATA_NASCIMENTO: TDateTimeField;
    CdsConsultaRG_INSC_ESTADUAL: TWideStringField;
    CdsConsultaCODIGO_REGIME_TRIBUTARIO: TWideStringField;
    CdsConsultaTELEFONE: TWideStringField;
    CdsConsultaCELULAR: TWideStringField;
    CdsConsultaEMAIL: TWideStringField;
    UniEdit6: TUniEdit;
    UniEdit7: TUniEdit;
    CdsConsultaENDERECO: TWideStringField;
    procedure UniFrameCreate(Sender: TObject);
    procedure UniPanel2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;


implementation

{$R *.dfm}

uses Controle.Cadastro.Cliente;


// -------------------------------------------------------------------------- //
procedure TControleConsultaCliente.Novo;
begin
  if ControleCadastroCliente.Novo() then
  begin
    ControleCadastroCliente.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaCliente.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'cliente';
end;

procedure TControleConsultaCliente.UniPanel2Click(Sender: TObject);
begin
  inherited;

end;

// -------------------------------------------------------------------------- //
procedure TControleConsultaCliente.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroCliente.Create(Self);
  if ControleCadastroCliente.Abrir(Id) then
  begin
    ControleCadastroCliente.ConfiguraTipoPessoa;
    ControleCadastroCliente.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;


end.
