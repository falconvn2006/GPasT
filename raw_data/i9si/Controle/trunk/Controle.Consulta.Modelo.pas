unit Controle.Consulta.Modelo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Consulta, Data.DB,
  Data.Win.ADODB, Datasnap.Provider, Datasnap.DBClient, uniGUIBaseClasses,
  uniGUIClasses, uniImageList, uniPanel, uniBasicGrid, uniDBGrid, uniButton,
  uniEdit,  uniGridExporters, uniCheckBox, uniLabel, frxClass,
  frxDBSet, frxExportBaseDialog, frxExportPDF,  uniBitBtn,
   Vcl.Imaging.pngimage, uniImage;

type
  TControleConsultaModelo = class(TControleConsulta)
    QryConsultaID: TFloatField;
    CdsConsultaID: TFloatField;
    UniEdit1: TUniEdit;
    QryConsultaDESCRICAO: TWideStringField;
    QryConsultaPOSSUI_ANEXO: TWideStringField;
    CdsConsultaDESCRICAO: TWideStringField;
    CdsConsultaPOSSUI_ANEXO: TWideStringField;
    procedure UniFrameCreate(Sender: TObject);
    procedure CdsConsultaPOSSUI_ANEXOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

var
  ControleConsultaModelo: TControleConsultaModelo;

implementation

{$R *.dfm}

uses Controle.Main.Module, Controle.Cadastro.Modelo, Controle.Server.Module;

// -------------------------------------------------------------------------- //
procedure TControleConsultaModelo.CdsConsultaPOSSUI_ANEXOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  inherited;
  if Sender.AsString = 'S' then
    Text := '<img src=./files/icones/documento.png height=22 align="center" />'
  else if Sender.AsString = 'N' then
    Text := '<img src=./files/icones/upload.png height=22 align="center" />';
end;

procedure TControleConsultaModelo.Novo;
begin
  if ControleCadastroModelo.Novo() then
  begin
    ControleCadastroModelo.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaModelo.UniFrameCreate(Sender: TObject);
begin
  inherited;
  FNomeTabela := 'modelo';
end;

// -------------------------------------------------------------------------- //
procedure TControleConsultaModelo.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroCliente.Create(Self);
  if ControleCadastroModelo.Abrir(Id) then
  begin
    ControleCadastroModelo.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;
// -------------------------------------------------------------------------- //


end.
