unit Controle.Consulta.Sugestao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta,  Data.DB,
  Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses,
  uniImageList, uniPanel, uniBasicGrid, uniDBGrid, uniButton, uniEdit,
  uniGridExporters, uniCheckBox, uniLabel,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniBitBtn, 
  Vcl.Imaging.pngimage, uniImage;

type
  TControleConsultaSugestao = class(TControleConsulta)
    UniEdit1: TUniEdit;
    QryConsultaID: TFloatField;
    QryConsultaTITULO: TWideStringField;
    QryConsultaDESCRICAO: TWideStringField;
    QryConsultaUSUARIO_ID: TFloatField;
    QryConsultaDATA: TDateTimeField;
    QryConsultaSUGESTAO_ID: TFloatField;
    CdsConsultaID: TFloatField;
    CdsConsultaTITULO: TWideStringField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaUSUARIO_ID: TFloatField;
    CdsConsultaDATA: TDateTimeField;
    CdsConsultaSUGESTAO_ID: TFloatField;
    QryConsultaRESPOSTA: TWideStringField;
    QryConsultaSTATUS: TWideStringField;
    CdsConsultaRESPOSTA: TWideStringField;
    CdsConsultaSTATUS: TWideStringField;
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
  Controle.Cadastro.Sugestao,
  Controle.Main.Module;


procedure TControleConsultaSugestao.Abrir(Id: Integer);
begin
  inherited;
  // Abre o formulário de cadastro para visualização e edição
  if ControleCadastroSugestao.Abrir(Id) then
  begin
    ControleCadastroSugestao.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaSugestao.Novo;
begin
  inherited;
  if ControleCadastroSugestao.Novo() then
  begin
    ControleCadastroSugestao.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaSugestao.UniFrameCreate(Sender: TObject);
begin
//  inherited;
  CdsConsulta.Close;
  CdsConsulta.Filtered := False;
  CdsConsulta.Filter := 'usuario_id = ' + QuotedStr(IntTostr(ControleMainModule.FUsuarioId));
  CdsConsulta.Filtered := True;
  CdsConsulta.Open;

  FNomeTabela := 'FONTE.sugestao';
end;

end.
