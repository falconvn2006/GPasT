unit Controle.Consulta.Usuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta, uniGUIBaseClasses,
  uniImageList, uniPanel, uniButton, uniBasicGrid, uniDBGrid, uniScreenMask,
  uniCheckBox, uniEdit, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  Data.DB, FireDAC.Comp.DataSet, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient,  uniGridExporters, uniLabel, 
  frxClass, frxDBSet, frxExportBaseDialog, frxExportPDF, uniBitBtn, 
  Vcl.Imaging.pngimage, uniImage, Vcl.Menus, uniMainMenu, uniSweetAlert;

type
  TControleConsultaUsuario = class(TControleConsulta)
    UniScreenMask1: TUniScreenMask;
    UniEdit1: TUniEdit;
    UniEdit3: TUniEdit;
    CdsConsultaID: TFloatField;
    CdsConsultaLOGIN: TWideStringField;
    CdsConsultaSENHA: TWideStringField;
    CdsConsultaATIVO: TWideStringField;
    CdsConsultaSCHEMA: TWideStringField;
    procedure UniFrameCreate(Sender: TObject);
  private
    procedure ApagarUsuario(Id: Integer);
    { Private declarations }
  public
    { Public declarations }
    procedure Novo; override;
    procedure Abrir(Id: Integer); override;
  end;

implementation

{$R *.dfm}

uses Controle.Main.Module, Controle.Cadastro.Usuario, Controle.Funcoes;

// -------------------------------------------------------------------------- //
procedure TControleConsultaUsuario.Novo;
begin
  if ControleCadastroUsuario.Novo() then
  begin
    ControleCadastroUsuario.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

// -------------------------------------------------------------------------- //
procedure TControleConsultaUsuario.Abrir(Id: Integer);
begin
  // Abre o formulário de cadastro para visualização e edição
  // := TControleCadastroCliente.Create(Self);
  if ControleCadastroUsuario.Abrir(Id) then
  begin
    ControleCadastroUsuario.ShowModal(procedure(Sender: TComponent; Result: Integer)
    begin
//      if Result = 1 then
        CdsConsulta.Refresh;
    end);
  end;
end;

procedure TControleConsultaUsuario.UniFrameCreate(Sender: TObject);
begin
  //inherited;

  Try
    CdsConsulta.Close;
    QryConsulta.Close;
    QryConsulta.Parameters.ParamByName('schema').Value := ControleMainModule.FSchema;
    QryConsulta.Parameters.ParamByName('login').Value        := '%%';
    QryConsulta.Parameters.ParamByName('ativo').Value        := '%%';
    CdsConsulta.Params.ParamByName('schema').Value       := ControleMainModule.FSchema;
    CdsConsulta.Params.ParamByName('login').Value        := '%%';
    CdsConsulta.Params.ParamByName('ativo').Value        := '%%';
    CdsConsulta.Open;
  except
   on e:exception do
     ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
  End;
end;

procedure TControleConsultaUsuario.ApagarUsuario(Id: Integer);
var
  Erro: String;
begin
  Erro := '';
  with ControleMainModule do
  begin
    // Inicia a transação
    ADOConnectionLogin.BeginTrans;
    QryAx1.Connection := ADOConnectionLogin;

    QryAx1.Parameters.Clear;
    QryAx1.SQL.Clear;
    QryAx1.SQL.Text :=
        'DELETE FROM usuario'
      + ' WHERE id = :id';
    QryAx1.Parameters.ParamByName('id').Value := Id;

    try
      // Tenta apagar o registro
      QryAx1.ExecSQL;
    except
      on E: Exception do
      begin
        Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
        ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
      end;
    end;

    if Erro = '' then
    begin
      // Confirma a transação
      ADOConnectionLogin.CommitTrans;
      QryAx1.Connection := ADOConnection;

      // Atualiza a lista
      BotaoAtualizar.Refresh;
    end
    else
    begin
      // Descarta a transação
      ADOConnectionLogin.RollbackTrans;
      QryAx1.Connection := ADOConnection;
    end;
  end;
end;

end.
