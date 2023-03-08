unit Controle.Cadastro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniGUIBaseClasses, uniImageList, uniButton,
  uniPanel, db, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Datasnap.DBClient, Datasnap.Provider, Data.Win.ADODB, uniEdit, uniDBEdit,
  uniWinUtils, Vcl.StdCtrls, uniSpeedButton, ACBrBase, ACBrSocket, ACBrCEP,
  uniPageControl, uniLabel, uniCheckBox, uniDBCheckBox,
  uniRadioGroup, uniDBRadioGroup, uniGroupBox, uniMultiItem, uniComboBox,
  UniDbComboBox, UniDbMemo, uniBitBtn, uniHTMLMemo, uniImage, uniSweetAlert;

type
  TControleCadastro = class(TUniForm)
    UniPanel1: TUniPanel;
    BotaoEditar: TUniButton;
    BotaoSalvar: TUniButton;
    BotaoDescartar: TUniButton;
    UniPanel2: TUniPanel;
    UniPanel6: TUniPanel;
    UniImageList1: TUniImageList;
    QryCadastro: TADOQuery;
    DspCadastro: TDataSetProvider;
    CdsCadastro: TClientDataSet;
    DscCadastro: TDataSource;
    UniPanel21: TUniPanel;
    UniImageList2: TUniImageList;
    ACBrCEP: TACBrCEP;
    UniPanelCaption: TUniPanel;
    UniLabelCaption: TUniLabel;
    UniSpeedCaptionClose: TUniSpeedButton;
    UniImageCaptionClose: TUniImageList;
    UniImageListUniPageControl: TUniImageList;
    UniImageCaptionMaximizar: TUniSpeedButton;
    UniSweetAlertaFechaFormulario: TUniSweetAlert;
    procedure BotaoEditarClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
    procedure BotaoDescartarClick(Sender: TObject);
    procedure DscCadastroStateChange(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniSpeedCaptionCloseClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniImageCaptionMaximizarClick(Sender: TObject);
    procedure UniSpeedButton3Click(Sender: TObject);
    procedure UniSweetAlertaFechaFormularioConfirm(Sender: TObject);
  private
    procedure SelecionaCampoDBFormattedNumber(Sender: TObject);
    procedure SelecionaCampoDBEdit(Sender: TObject);
    procedure SelecionaCampoEdit(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    CadastroId: Integer;
    { Public declarations }

    function Novo(): Boolean; virtual; abstract;
    function NovoTreeView(Id: Integer): Boolean; virtual; abstract;
    function Abrir(Id: Integer): Boolean; virtual; abstract;
    function Editar(Id: Integer): Boolean; virtual; abstract;
    function Salvar: Boolean; virtual;
    function Descartar: Boolean; virtual; abstract;
    function Atualizar: Boolean; virtual; abstract;
    procedure VerificaCEP(Botao: TUniSpeedButton;
                                        DbEdtNome: TUniDBEdit;
                                        DbEditFoco: TUniDBEdit);
end;

implementation

uses
  uniGUIApplication, Controle.Main.Module, Controle.Funcoes, System.TypInfo,
  uniDBVerticalTreeGrid,   Controle.Main;

{$R *.dfm}

{ TControleCadastro }

procedure TControleCadastro.BotaoDescartarClick(Sender: TObject);
begin
  // Descarta a alterações que não foram salvas
  Descartar;
end;

procedure TControleCadastro.BotaoEditarClick(Sender: TObject);
begin
  Editar(QryCadastro.FieldByName('id').AsInteger);
end;

procedure TControleCadastro.BotaoSalvarClick(Sender: TObject);
begin
  // Tenta salvar os dados
  Try
    Salvar
  Finally
    // Causou um choque com o sistema de cadastro de avaliações
    if Self.Tag = 0 then
    begin
      if CdsCadastro.State in [dsBrowse] then
        Close;
    end
    else // força o fechamento
    if Self.Tag = 1 then
    begin
      Close;
    end;

    // FIX-ME - esse código tem que ir para um parametro, alguns clientes nao querem que a tela feche automaticamente
  End;
end;

procedure TControleCadastro.DscCadastroStateChange(Sender: TObject);
var
  I: Integer;
begin
  BotaoEditar.Enabled    := (Sender as TDataSource).State in [dsBrowse];
  BotaoSalvar.Enabled    := (Sender as TDataSource).State in [dsEdit, dsInsert];
  BotaoDescartar.Enabled := BotaoSalvar.Enabled;

  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TUniSpeedButton then
    begin
      if TUniButton(Components[I]).Tag <> 5 then
        TUniSpeedButton(Components[I]).Enabled  := BotaoSalvar.Enabled;
    end;
  end;

  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TUniButton then
    begin
      if TUniButton(Components[I]).Tag <> 5 then
      begin
        if TUniButton(Components[I]).Name <> 'BotaoDescartar' then
          if TUniButton(Components[I]).Name <> 'BotaoEditar' then
            if TUniButton(Components[I]).Name <> 'BotaoSalvar' then
              if TUniButton(Components[I]).Name <> 'BotaoNovo' then
                TUniButton(Components[I]).Enabled  := BotaoSalvar.Enabled;
      end;
    end;
  end;

  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TUniDbEdit then
      if TUniDbEdit(Components[I]).Tag <> 5 then
        TUniDbEdit(Components[I]).ReadOnly  := BotaoEditar.Enabled;

    if Components[I] is TuniDBCheckBox then
    begin
      if TuniDBCheckBox(Components[I]).Tag <> 5 then
        TuniDBCheckBox(Components[I]).ReadOnly  := BotaoEditar.Enabled;
    end;

    if Components[I] is TUniDbComboBox then
    begin
      TUniDbComboBox(Components[I]).ReadOnly  := BotaoEditar.Enabled;
      if TUniDbComboBox(Components[I]).ReadOnly = False then
        TUniDbComboBox(Components[I]).Style := csDropDownList
      else
        TUniDbComboBox(Components[I]).Style := csDropDown;
    end;

    if Components[I] is TuniCheckBox then
      TuniCheckBox(Components[I]).ReadOnly  := BotaoEditar.Enabled;

    if Components[I] is TUniComboBox then
      TUniComboBox(Components[I]).ReadOnly  := BotaoEditar.Enabled;

    if Components[I] is TUniDbMemo then
      if TUniDbEdit(Components[I]).Tag <> 5 then
        TUniDbMemo(Components[I]).ReadOnly  := BotaoEditar.Enabled;

    if Components[I] is TUniDBRadioGroup then
      TUniDBRadioGroup(Components[I]).ReadOnly  := BotaoEditar.Enabled;

    if Components[I] is TUniHTMLMemo then
      TUniHTMLMemo(Components[I]).ReadOnly  := BotaoEditar.Enabled;

    if Components[I] is TUniDBVerticalTreeGrid then
      TUniDBVerticalTreeGrid(Components[I]).Enabled  := BotaoSalvar.Enabled;

    if Components[I] is TUniCheckBox then
      TUniCheckBox(Components[I]).Enabled  := BotaoSalvar.Enabled;

{    if Components[I] is TUniGroupBox then
      if TUniGroupBox(Components[I]).Tag <> 5 then
        TUniGroupBox(Components[I]).Enabled  := BotaoSalvar.Enabled;

{    if Components[I] is TUniDBFormattedNumberEdit then
      if TUniDBFormattedNumberEdit(Components[I]).Tag <> 5 then
        TUniDBFormattedNumberEdit(Components[I]).Enabled  := BotaoSalvar.Enabled;}

    if Components[I] is TUniDBFormattedNumberEdit then
    begin
      TUniDBFormattedNumberEdit(Components[I]).OnEnter  := SelecionaCampoDBFormattedNumber;
      TUniDBFormattedNumberEdit(Components[I]).DecimalPrecision := 2;
      TUniDBFormattedNumberEdit(Components[I]).DecimalSeparator := ',';
    end;

    if Components[I] is TUniDbEdit then
        TUniDbEdit(Components[I]).OnEnter  := SelecionaCampoDBEdit;

    if Components[I] is TUniEdit then
        TUniDbEdit(Components[I]).OnEnter  := SelecionaCampoEdit;
  end;
end;

procedure TControleCadastro.SelecionaCampoDBFormattedNumber(Sender: TObject);
begin
  TUniDBFormattedNumberEdit(Sender).SelectAll;
end;

procedure TControleCadastro.SelecionaCampoDBEdit(Sender: TObject);
begin
  TUniDbEdit(Sender).SelectAll;
end;

procedure TControleCadastro.SelecionaCampoEdit(Sender: TObject);
begin
  TUniEdit(Sender).SelectAll;
end;

function TControleCadastro.Salvar: Boolean;
begin
  // Inserindo o login do usuario em tabela temporaria,
  // Utilzado para auditoria
//  ControleMainModule.Insere_Tabela_Temp_Login();
end;

procedure TControleCadastro.UniFormCreate(Sender: TObject);
begin
  self.BorderStyle := bsNone;
end;

procedure TControleCadastro.UniFormShow(Sender: TObject);
var
  I: Integer;
begin
  UniLabelCaption.Text := Self.Caption;

  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TUniDBEdit then
    begin
      if TUniDBEdit(Components[I]).Tag = 0 then
        TUniDBEdit(Components[I]).CharCase := ecUpperCase
      else if TUniDBEdit(Components[I]).Tag = 1 then
        TUniDBEdit(Components[I]).CharCase := ecLowerCase
      else if TUniDBEdit(Components[I]).Tag = 2 then
        TUniDBEdit(Components[I]).CharCase := ecNormal;

      // Código para clicar automaticamente em botao
     { if TUniDBEdit(Components[I]).Hint <> '' then
      begin
        // procurando botao
         for J := 0 to ComponentCount - 1 do
         begin
           if TUniButton(Components[I]).Name =  TUniDBEdit(Components[I]).Hint then
           begin
             TUniDBEdit(Components[I]).OnClick := teste(J);
           end;
         end;
      end;}
    end;

    if Components[I] is TUniEdit then
    begin
      if TUniEdit(Components[I]).Tag = 0 then
        TUniEdit(Components[I]).CharCase := ecUpperCase
      else if TUniEdit(Components[I]).Tag = 1 then
        TUniEdit(Components[I]).CharCase := ecLowerCase;// Usado para email por exemplo
    end;
  end;
end;

procedure TControleCadastro.UniImageCaptionMaximizarClick(Sender: TObject);
begin
  WindowState := wsMaximized;
  UniImageCaptionMaximizar.Visible := False;
end;

procedure TControleCadastro.UniSpeedButton3Click(Sender: TObject);
begin
  WindowState := wsNormal;
end;

procedure TControleCadastro.UniSpeedCaptionCloseClick(Sender: TObject);
begin
  if CdsCadastro.State in [dsInsert, dsEdit] then
  begin
    if Self.Tag <> 5 then
    begin
      UniSweetAlertaFechaFormulario.Show; // O código fica no evento do componente!
    end
    else
      Close;
  end
  else
    Close;
end;

procedure TControleCadastro.UniSweetAlertaFechaFormularioConfirm(
  Sender: TObject);
begin
  Close;
end;

procedure TControleCadastro.VerificaCEP(Botao: TUniSpeedButton;
                                        DbEdtNome: TUniDBEdit;
                                        DbEditFoco: TUniDBEdit);
var
  CidadeId: Integer;
  Tipo, CodigoIbge, Cidade, Uf_: String;
  Erro, Cep: String;
begin
  inherited;

  // Não executa se o botão estiver desabilitado
  if not Botao.Enabled then
    Exit;

  Tipo := 'geral';

  Cep  := ControleFuncoes.RemoveMascara(Trim(DbEdtNome.Text));

  // Verifica se o cep foi informado
  if Cep = '' then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Informe o CEP que deseja consultar!' );
    Exit;
  end;

  // Verifica se o cep é válido
  if Length(Cep) <> 8 then
  begin
    ControleMainModule.MensageiroSweetAlerta('Atenção', 'Informe o CEP com 8 digitos!');
    Exit;
  end;

  try
     ACBrCEP.BuscarPorCEP(DbEdtNome.Text);

     if ACBrCEP.Enderecos.Count < 1 then
       ControleMainModule.MensageiroSweetAlerta('Atenção', 'Nenhum endereço encontrado')
     else
     begin
       with ACBrCEP.Enderecos[0] do
       begin
         // Coloca o dataset em modo de edição se ainda não estiver
         CdsCadastro.Edit;

         if Tipo <> '' then
         begin
           // Redefine o logradouro
           if Logradouro <> '' then
             CdsCadastro[Tipo + '_logradouro'] := Trim(Logradouro)
           else
             CdsCadastro[Tipo + '_logradouro'] := '';

           // Redefine o complemento
           if Complemento <> '' then
             CdsCadastro[Tipo + '_complemento'] := Trim(Complemento)
           else
             CdsCadastro[Tipo + '_complemento'] := '';

           // Redefine o bairro
           if Bairro <> '' then
             CdsCadastro[Tipo + '_bairro'] := Trim(Bairro)
           else
             CdsCadastro[Tipo + '_bairro'] := '';
         end
         else
         begin
           // Redefine o logradouro
           if Logradouro <> '' then
             CdsCadastro['logradouro'] := Trim(Logradouro)
           else
             CdsCadastro['logradouro'] := '';

           // Redefine o complemento
           if Complemento <> '' then
             CdsCadastro['complemento'] := Trim(Complemento)
           else
             CdsCadastro['complemento'] := '';

           // Redefine o bairro
           if Bairro <> '' then
             CdsCadastro['bairro'] := Trim(Bairro)
           else
             CdsCadastro['bairro'] := '';
         end;

         // Pega o código ibge
         if IBGE_Municipio <> '' then
           CodigoIbge := Trim(IBGE_Municipio);

         // Pega a cidade
         if Municipio <> '' then
           Cidade := Trim(Municipio);

         // Pega a uf
         if UF <> '' then
           Uf_ := Trim(UF);

         with ControleMainModule do
         begin
            CidadeId := 0;

            // Tenta localizar a cidade pelo código ibge
            CdsAx1.Close;
            QryAx1.Parameters.Clear;
            QryAx1.SQL.Clear;
            QryAx1.SQL.Text :=
                'SELECT cid.id,'
              + '       cid.nome,'
              + '       est.uf'
              + '  FROM fonte.cidade cid'
              + '  LEFT OUTER JOIN fonte.estado est'
              + '    ON est.id = cid.estado_id'
              + ' WHERE cid.codigo_ibge = :codigo_ibge';
            QryAx1.Parameters.ParamByName('codigo_ibge').Value := CodigoIbge;
            CdsAx1.Open;

            if (CodigoIbge <> '') and (CdsAx1.FieldByName('id').AsInteger <> 0) then
            begin
              CidadeId := CdsAx1.FieldByName('id').AsInteger;
              Cidade   := CdsAx1.FieldByName('nome').AsString;
              Uf       := CdsAx1.FieldByName('uf').AsString;
            end
            else
            begin
              // Tenta localizar a cidade pelo nome e uf
              CdsAx1.Close;
              QryAx1.Parameters.Clear;
              QryAx1.SQL.Clear;
              QryAx1.SQL.Text :=
                  'SELECT cid.id,'
                + '       cid.nome,'
                + '       est.uf'
                + '  FROM fonte.cidade cid'
                + ' INNER JOIN fonte.estado est'
                + '    ON est.id = cid.estado_id'
                + ' WHERE UPPER(TRIM(cid.nome)) = UPPER(:nome)'
                + '   AND UPPER(TRIM(est.uf))   = UPPER(:uf)';
              QryAx1.Parameters.ParamByName('nome').Value := Cidade;
              QryAx1.Parameters.ParamByName('uf').Value   := Uf;
              CdsAx1.Open;

              if (Cidade <> '') and (CdsAx1.FieldByName('id').AsInteger <> 0) then
              begin
                CidadeId := CdsAx1.FieldByName('id').AsInteger;
                Cidade   := CdsAx1.FieldByName('nome').AsString;
                Uf       := CdsAx1.FieldByName('uf').AsString;
              end;
            end;

            // Cadastra a cidade retornada pelo VIACEP se ainda não estiver cadastrada.
            if (CidadeId = 0) and (Cidade <> '') and (Uf <> '') then
            begin
              // Inicia a transação
              ADOConnection.BeginTrans;

              CidadeId := GeraId('cidade');

              // Insere a nova cidade
              CdsAx1.Close;
              QryAx1.Parameters.Clear;
              QryAx1.SQL.Clear;
              QryAx1.SQL.Text :=
                  'INSERT INTO fonte.cidade ('
                + '       id,'
                + '       nome,'
                + '       estado_id,'
                + '       codigo_ibge)'
                + 'VALUES ('
                + '       :id,'
                + '       :nome,'
                + '       (SELECT id'
                + '          FROM fonte.estado'
                + '         WHERE UPPER(uf) = UPPER(:uf)'
                + '           AND ROWNUM = 1),'
                + '       :codigo_ibge)';
              QryAx1.Parameters.ParamByName('id').Value          := CidadeId;
              QryAx1.Parameters.ParamByName('nome').Value        := Cidade;
              QryAx1.Parameters.ParamByName('uf').Value          := Uf;
              QryAx1.Parameters.ParamByName('codigo_ibge').Value := CodigoIbge;

              try
                // Tenta salvar os dados
                QryAx1.ExecSQL;
                // Confirma a transação
                ADOConnection.CommitTrans;
              except
                on E: Exception do
                begin
                  Erro := ControleFuncoes.RetiraAspaSimples(E.Message);
                  ControleMainModule.MensageiroSweetAlerta('Atenção', Erro);
                  // Descarta a transação
                  ADOConnection.RollbackTrans;
                end;
              end;
            end;

            if (Erro = '') and (CidadeId > 0) then
            begin
              if Tipo <> '' then
              begin
                // Redefine a cidade
                CdsCadastro[Tipo + '_cidade_id'] := CidadeId;
                CdsCadastro[Tipo + '_cidade']    := Cidade + ' / ' + Uf;
              end
              else
              begin
                // Redefine a cidade
                CdsCadastro['cidade_id'] := CidadeId;
                CdsCadastro['cidade']    := Cidade + ' / ' + Uf;
              end;
            end;

            DbEditFoco.SetFocus;
         end;
       end;
     end ;
  except
     On E : Exception do
     begin
       ControleMainModule.MensageiroSweetAlerta('Atenção', ControleFuncoes.RetiraAspaSimples(E.Message));
     end ;
  end ;
end;

end.
