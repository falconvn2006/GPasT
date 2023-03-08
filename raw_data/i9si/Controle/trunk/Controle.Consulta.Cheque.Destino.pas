unit Controle.Consulta.Cheque.Destino;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniGridExporters, uniBasicGrid,
   Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniImageList, uniCheckBox, uniLabel,
  uniPanel, uniDBGrid, Vcl.Imaging.pngimage, uniImage, uniBitBtn, 
  uniButton, uniEdit, Vcl.Menus, uniMainMenu, uniSweetAlert;

type
  TControleConsultaChequeDestino = class(TControleConsulta)
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

implementation

uses
  Controle.Cadastro.Cheque.Destino;

{$R *.dfm}

procedure TControleConsultaChequeDestino.Novo;
begin
  if ControleCadastroChequeDestino.Novo() then
  begin
    ControleCadastroChequeDestino.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaChequeDestino.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroBanco.Create(Self);
  if ControleCadastroChequeDestino.Abrir(Id) then
  begin
    ControleCadastroChequeDestino.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaChequeDestino.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'cheque_destino';
end;

end.
