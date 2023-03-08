unit Controle.Consulta.ChequesDepositados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Controle.Consulta,  frxClass,
  frxDBSet, frxExportBaseDialog, frxExportPDF, uniGridExporters, uniBasicGrid,
   Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniGUIClasses, uniImageList,
  uniCheckBox, uniLabel, uniPanel, uniDBGrid, Vcl.Imaging.pngimage, uniImage,
  uniBitBtn,  uniButton, uniEdit, uniMultiItem, uniComboBox,
   Vcl.Menus, uniMainMenu,
  uniSweetAlert;

type
  TControleConsultaChequesDepositados = class(TControleConsulta)
    CdsConsultaID: TFloatField;
    CdsConsultaDATA: TDateTimeField;
    CdsConsultaDESTINO: TWideStringField;
    UniEdit1: TUniEdit;
    UniComboBoxChequeDestino: TUniComboBox;
    DscChequeDestino: TDataSource;
    CdsChequeDestino: TClientDataSet;
    CdsChequeDestinoID: TFloatField;
    CdsChequeDestinoDESCRICAO: TWideStringField;
    DspChequeDestino: TDataSetProvider;
    QryChequeDestino: TADOQuery;
    procedure UniFrameCreate(Sender: TObject);
    procedure BotaoApagarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

var
  ControleConsultaChequesDepositados: TControleConsultaChequesDepositados;

implementation

{$R *.dfm}

uses Controle.Main.Module, Controle.Consulta.Modal.ChequeDepositados.Itens;

procedure TControleConsultaChequesDepositados.Novo;
begin
  ControleMainModule.MensageiroSweetAlerta('Atenção', 'Para incluir um novo lote cheques para baixa, você deve ir no menu "Cheques recebidos"!');
end;

procedure TControleConsultaChequesDepositados.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroBanco.Create(Self);
  if ControleConsultaModalChequeDepositadosItens.Abrir(Id) then
  begin
    ControleConsultaModalChequeDepositadosItens.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaChequesDepositados.BotaoApagarClick(Sender: TObject);
begin
//  inherited;
  ControleMainModule.MensageiroSweetAlerta('Atenção', 'Essa modalidade não permite exclusão');
end;

procedure TControleConsultaChequesDepositados.UniFrameCreate(Sender: TObject);
begin
  inherited;
  // Alimentando Cds
  With UniComboBoxChequeDestino do
  begin
    Clear;
    CdsChequeDestino.Open;
    CdsChequeDestino.First;
    while not CdsChequeDestino.eof do
    begin
      Items.Add(CdsChequeDestinoDescricao.AsString);
      CdsChequeDestino.Next;
    end;
  end
end;

end.
