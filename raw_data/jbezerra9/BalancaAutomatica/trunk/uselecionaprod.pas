unit uselecionaprod;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils ,System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.FMTBcd, ACBrDeviceSerial,
  Data.DB, Data.SqlExpr, Datasnap.DBClient, Vcl.Buttons, ACBrBase, ACBrBAL, ACBrDevice, System.TypInfo;

Const
  InputBoxMessage = WM_USER + 200;

type
  TfSelecionaProd = class(TForm)
    pnlMeio: TPanel;
    sqlcon: TSQLQuery;
    sqlaux: TSQLQuery;
    pnlProdutos: TPanel;
    lbSelecione: TLabel;
    btAnterior: TButton;
    btProx: TButton;
    pnlConfig: TPanel;
    gbBalanca: TGroupBox;
    lbQtdBalanca: TLabel;
    rgUsaBalanca: TRadioGroup;
    gbConfigBalanca: TGroupBox;
    lbBalanca: TLabel;
    lbModelo: TLabel;
    lbPortaSerial: TLabel;
    lbBaudRate: TLabel;
    lbDataBits: TLabel;
    lbParity: TLabel;
    lbHandshaking: TLabel;
    lbStopBits: TLabel;
    lbTimeOut: TLabel;
    edTimeOut3: TEdit;
    edTimeOut2: TEdit;
    cbStopBits3: TComboBox;
    cbParity3: TComboBox;
    cbHandShaking3: TComboBox;
    cbDataBits3: TComboBox;
    cbBaudRate3: TComboBox;
    cbPortaSerial3: TComboBox;
    cbModelo3: TComboBox;
    cbHandShaking2: TComboBox;
    cbStopBits2: TComboBox;
    cbParity2: TComboBox;
    cbDataBits2: TComboBox;
    cbBaudRate2: TComboBox;
    cbPortaSerial2: TComboBox;
    cbModelo2: TComboBox;
    cbBalanca: TComboBox;
    Panel2: TPanel;
    cbModelo1: TComboBox;
    cbPortaSerial1: TComboBox;
    cbBaudRate1: TComboBox;
    cbDataBits1: TComboBox;
    cbHandShaking1: TComboBox;
    cbParity1: TComboBox;
    cbStopBits1: TComboBox;
    edTimeOut1: TEdit;
    Panel7: TPanel;
    btTestePeso: TButton;
    edTestePeso: TEdit;
    cbQtdBalanca: TComboBox;
    btConfig: TSpeedButton;
    brSalvar: TButton;
    btTestarValorUnitario: TButton;
    edValorUnitarioTeste: TEdit;
    lbValorUnitarioTeste: TLabel;
    edCompletarDig: TEdit;
    edQtdDigitos: TEdit;
    lbCompletarDig: TLabel;
    lbQtdDigitos: TLabel;
    edComandoFinal: TEdit;
    edComandoInicial: TEdit;
    lbComandoFinal: TLabel;
    lbComandoInicial: TLabel;
    ACBrBAL: TACBrBAL;
    cbEVrUnit: TCheckBox;
    btSair: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure btAnteriorClick(Sender: TObject);
    procedure btProxClick(Sender: TObject);
    procedure btConfigClick(Sender: TObject);
    procedure brSalvarClick(Sender: TObject);
    procedure rgUsaBalancaClick(Sender: TObject);
    procedure cbBalancaChange(Sender: TObject);
    procedure btTestarValorUnitarioClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure cbQtdBalancaChange(Sender: TObject);
    procedure btTestePesoClick(Sender: TObject);
    procedure ACBrBALLePeso(Peso: Double; Resposta: AnsiString);
    procedure edPrecoKGKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    ultBtnProd, ultBtnGrupEve: String;

    iQtdMesclar, iMesa, sNum, seqItemProdCombo, auxIDCombo, pagGrup, pagProd, TimeOut,
    ultPagGrup, ultPagProd, limitGrup, limitProd, nColunasProd, auxQtdMesc, skip: integer;
    procedure InputBoxSetPasswordChar(var Msg: TMessage); message InputBoxMessage;
  public
    { Public declarations }

    bt_Prod_DivVert  : Integer;
    bt_Prod_DivHorz  : Integer;
    bt_Prod_Heigth   : Integer;
    bt_Prod_Width    : Integer;
    bt_Prod_FontName,sCodprod : String;
    bt_Prod_FontSize : Integer;

    bt_Prod_MaxCaracteres : Integer;
    bt_Prod_InfoValor : Boolean;

    procedure CriaBotoesProdutos(sTipo : String);
    procedure ConfigComponenteBalanca;
    procedure CarregaBal;
    procedure ClickBtnProduto(Sender: TObject);
  end;

var
  fSelecionaProd: TfSelecionaProd;

const
    corBtnGrup        = clWindow;
    corBtnGrupClick   = $0000AA55;
    corBtnProd        = $00BCE3D6;
    corBtnProdClick   = $0000AA55;

implementation

{$R *.dfm}

uses uFuncoes, uModulo, uPrinc;

procedure TfSelecionaProd.CarregaBal;
begin
     cbQtdBalanca.ItemIndex := dm.FiniParam.ReadInteger('Caixa','QtdBalancas',1)-1;
     cbQtdBalancaChange(Self);

     cbEVrUnit.Checked        := dm.FiniParam.ReadBool(  'Balanca', 'EnviaVrUnit',    False);
     edComandoInicial.Text    := dm.FiniParam.ReadString('Balanca', 'ComandoInicial', '2');
     edComandoFinal.Text      := dm.FiniParam.ReadString('Balanca', 'ComandoFinal',   '3');
     edQtdDigitos.Text        := dm.FiniParam.ReadString('Balanca', 'QtdDigitos',     '6');
     edCompletarDig.Text      := dm.FiniParam.ReadString('Balanca', 'CompletarDig',   '0');

     cbModelo1.ItemIndex      := dm.FiniParam.ReadInteger('Balanca1','Modelo',2);
     cbPortaSerial1.ItemIndex := cbPortaSerial1.Items.IndexOf(
                                 dm.FiniParam.ReadString( 'Balanca1','Porta','COM1'));
     cbBaudRate1.ItemIndex    := cbBaudRate1.Items.IndexOf(
                                 dm.FiniParam.ReadString( 'Balanca1','BaudRate','2400'));
     cbDataBits1.ItemIndex    := cbDataBits1.Items.IndexOf(
                                 dm.FiniParam.ReadString('Balanca1','DataBits','8'));
     cbParity1.ItemIndex      := dm.FiniParam.ReadInteger('Balanca1','Paridade',0);
     cbStopBits1.ItemIndex    := dm.FiniParam.ReadInteger('Balanca1','StopBits',0);
     cbHandShaking1.ItemIndex := dm.FiniParam.ReadInteger('Balanca1','HandShaking',0);
     edTimeOut1.Text          := dm.FiniParam.ReadString( 'Balanca1','TimeOut','2000');


     cbModelo2.ItemIndex      := dm.FiniParam.ReadInteger('Balanca2','Modelo',2);
     cbPortaSerial2.ItemIndex := cbPortaSerial1.Items.IndexOf(
                                 dm.FiniParam.ReadString( 'Balanca2','Porta','COM1'));
     cbBaudRate2.ItemIndex    := cbBaudRate1.Items.IndexOf(
                                 dm.FiniParam.ReadString( 'Balanca2','BaudRate','2400'));
     cbDataBits2.ItemIndex    := cbDataBits1.Items.IndexOf(
                                 dm.FiniParam.ReadString('Balanca2','DataBits','8'));
     cbParity2.ItemIndex      := dm.FiniParam.ReadInteger('Balanca2','Paridade',0);
     cbStopBits2.ItemIndex    := dm.FiniParam.ReadInteger('Balanca2','StopBits',0);
     cbHandShaking2.ItemIndex := dm.FiniParam.ReadInteger('Balanca2','HandShaking',0);
     edTimeOut2.Text          := dm.FiniParam.ReadString( 'Balanca2','TimeOut','2000');


     cbModelo3.ItemIndex      := dm.FiniParam.ReadInteger('Balanca3','Modelo',2);
     cbPortaSerial3.ItemIndex := cbPortaSerial1.Items.IndexOf(
                                 dm.FiniParam.ReadString( 'Balanca3','Porta','COM1'));
     cbBaudRate3.ItemIndex    := cbBaudRate1.Items.IndexOf(
                                 dm.FiniParam.ReadString( 'Balanca3','BaudRate','2400'));
     cbDataBits3.ItemIndex    := cbDataBits1.Items.IndexOf(
                                 dm.FiniParam.ReadString('Balanca3','DataBits','8'));
     cbParity3.ItemIndex      := dm.FiniParam.ReadInteger('Balanca3','Paridade',0);
     cbStopBits3.ItemIndex    := dm.FiniParam.ReadInteger('Balanca3','StopBits',0);
     cbHandShaking3.ItemIndex := dm.FiniParam.ReadInteger('Balanca3','HandShaking',0);
     edTimeOut3.Text          := dm.FiniParam.ReadString( 'Balanca3','TimeOut','2000');
end;
procedure TFSelecionaProd.InputBoxSetPasswordChar(var Msg: TMessage);
var
     hInputForm, hEdit: HWND;
begin
     hInputForm := Screen.Forms[0].Handle;
     if (hInputForm <> 0) then
     begin
          hEdit := FindWindowEx(hInputForm, 0, 'TEdit', nil);
          SendMessage(hEdit, EM_SETPASSWORDCHAR, Ord('*'), 0);
     end;
end;

procedure TFSelecionaProd.CriaBotoesProdutos(sTipo : String);
var
     botao, botao2: TButton ;
     c, l: Integer; //coluna e linha
     x: Integer;
     iLeft, iTop: Integer; //Define a posição e distancia entre os botoes
begin
     limitGrup := 21;

     //Limpa os componentes do pnlProdutos
     while pnlProdutos.ComponentCount > 0 do
          pnlProdutos.Components[pnlProdutos.ComponentCount -1].Destroy;

     sqlcon.Close;
     sqlcon.SQL.Text := 'select '+
                        ' first ' + IntToStr(limitGrup) +
                        ' skip ' + IntToStr(skip) +
                        ' tbprod.codigo, tbprod.descricao, '+
                        ' count(tbprod.codigo) as qtd, ' +
                        ' tbprod.PVendaA ' +
                        ' from tbprod ' +
                        ' left join tbunmed on tbunmed.codigo = tbprod.unmed ' +
                        ' inner join tbgrupo on tbgrupo.codigo = tbprod.grupo ' +
                        ' and tbprod.disponivel = ' +  QuotedStr('S') +
                        ' and tbprod.pvendaa > 0 ' +
                        sTipo;

     sqlcon.SQL.Text := sqlcon.SQL.Text + ' group by tbprod.codigo, tbprod.descricao, '+
                                            'tbprod.PVendaA';

     sqlcon.SQL.Text := sqlcon.SQL.Text + ' order by tbprod.descricao';

     sqlcon.Open;

     ultPagGrup := sqlcon.RecordCount div limitGrup;

     btAnterior.Enabled := skip > 0;
     btProx.Enabled     := skip < ultPagGrup;

     nColunasProd := pnlProdutos.Width div bt_Prod_DivHorz;

     iLeft := bt_Prod_DivHorz - bt_Prod_Width;
     iTop  := bt_Prod_DivVert - bt_Prod_Heigth;

     c := 0;
     l := iTop;

     while sqlcon.Eof = False do
     begin
          inc(c);

          botao := TButton.Create(pnlProdutos);

          botao.Name := 'btProd' + sqlcon.FieldByName('codigo').AsString;

          botao.OnClick := ClickBtnProduto;

          botao.Caption := sqlcon.FieldByName('descricao').AsString;

          //Informa o valor do produto
          if bt_Prod_InfoValor then
               botao.Caption := botao.Caption + #13 +
                    FormatCurr('#,###,##0.00',sqlcon.FieldByName('pvendaa').AsFloat);

          botao.WordWrap := True; //Quebra de linha

          //deixa o botão dentro do pnlProdutos
          botao.Parent := pnlProdutos;

          //atribui o tamanho
          botao.Height := bt_Prod_Heigth;
          botao.Width  := bt_Prod_Width;

          botao.Tag        := 0;
          botao.Font.Color := clWindowText;


          botao.Font.Name := bt_Prod_FontName;
          botao.Font.Size := bt_Prod_FontSize;
          botao.Font.Style := [fsBold];

          //posiciona o botao dentro do pnlProdutos
          if c > 1 then
          begin
               if c > nColunasProd then
               begin
                    c := 1;
                    l := l + iTop + botao.Height;
                    botao.Left := iLeft;
               end
               else
               begin
                    x := botao2.Left + botao2.Width + iLeft;
                    botao.Left := x;
               end;
          end
          else
          begin
               x := iLeft;
               botao.Left := x;
          end;
          botao.Top := l;

          sqlcon.Next;
          botao2 := botao;

          Self.Refresh;
     end;
end;

procedure TfSelecionaProd.edPrecoKGKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#13,#8]) then
     Key := #0 ;
end;

procedure TFSelecionaProd.ConfigComponenteBalanca;
begin
     if cbBalanca.ItemIndex = 0 then
     begin
          try
                ACBrBAL.Modelo           := TACBrBALModelo( cbModelo1.itemindex );
                ACBrBAL.Device.HandShake := TACBrHandShake( cbHandShaking1.ItemIndex );
                ACBrBAL.Device.Parity    := TACBrSerialParity( cbParity1.ItemIndex );
                ACBrBAL.Device.Stop      := TACBrSerialStop( cbStopBits1.ItemIndex );
                ACBrBAL.Device.Data      := StrToInt( cbDataBits1.Text ) ;
                ACBrBAL.Device.Baud      := StrToInt( cbBaudRate1.Text );
                ACBrBAL.Device.Porta     := cbPortaSerial1.Text;

               try
                    TimeOut := StrToInt(edTimeOut1.Text);
               except
                    TimeOut := 2000;
               end;
          except
               Application.MessageBox(PChar(
                    'Verifique as configurações da Balanca1 nos parâmetros.'),
                    'Erro ao configurar balança.',MB_ICONERROR);
               Exit;
          end;
     end
     else if cbBalanca.ItemIndex = 1 then
     begin
          try
                ACBrBAL.Modelo           := TACBrBALModelo( cbModelo2.itemindex );
                ACBrBAL.Device.HandShake := TACBrHandShake( cbHandShaking2.ItemIndex );
                ACBrBAL.Device.Parity    := TACBrSerialParity( cbParity2.ItemIndex );
                ACBrBAL.Device.Stop      := TACBrSerialStop( cbStopBits2.ItemIndex );
                ACBrBAL.Device.Data      := StrToInt( cbDataBits2.Text ) ;
                ACBrBAL.Device.Baud      := StrToInt( cbBaudRate2.Text );
                ACBrBAL.Device.Porta     := cbPortaSerial2.Text;
               try
                    TimeOut := StrToInt(edTimeOut2.Text);
               except
                    TimeOut := 2000;
               end;
          except
               Application.MessageBox(PChar(
                    'Verifique as configurações da Balanca2 nos parâmetros.'),
                    'Erro ao configurar balança.',MB_ICONERROR);
               Exit;
          end;
     end
     else if cbBalanca.ItemIndex = 2 then
     begin
          try
                ACBrBAL.Modelo           := TACBrBALModelo( cbModelo3.itemindex );
                ACBrBAL.Device.HandShake := TACBrHandShake( cbHandShaking3.ItemIndex );
                ACBrBAL.Device.Parity    := TACBrSerialParity( cbParity3.ItemIndex );
                ACBrBAL.Device.Stop      := TACBrSerialStop( cbStopBits3.ItemIndex );
                ACBrBAL.Device.Data      := StrToInt( cbDataBits3.Text ) ;
                ACBrBAL.Device.Baud      := StrToInt( cbBaudRate3.Text );
                ACBrBAL.Device.Porta     := cbPortaSerial3.Text;
               try
                    TimeOut := StrToInt(edTimeOut3.Text);
               except
                    TimeOut := 2000;
               end;
          except
               Application.MessageBox(PChar(
                    'Verifique as configurações da Balanca3 nos parâmetros.'),
                    'Erro ao configurar balança.',MB_ICONERROR);
               Exit;
          end;
     end;
end;

procedure TfSelecionaProd.ACBrBALLePeso(Peso: Double; Resposta: AnsiString);
begin
   edTestePeso.Text := FormatFloat('###,##0.000', Peso);
end;

procedure TfSelecionaProd.brSalvarClick(Sender: TObject);
begin
     dm.FiniParam.WriteBool   ('Balanca', 'EnviaVrUnit',    cbEVrUnit.Checked);
     dm.FiniParam.WriteInteger('Balanca', 'ComandoInicial', StrToInt(edComandoInicial.Text));
     dm.FiniParam.WriteInteger('Balanca', 'ComandoFinal',   StrToInt(edComandoFinal.Text));
     dm.FiniParam.WriteInteger('Balanca', 'QtdDigitos',     StrToInt(edQtdDigitos.Text));
     dm.FiniParam.WriteString ('Balanca', 'CompletarDig',   edCompletarDig.Text);

     dm.FiniParam.WriteInteger('Balanca1', 'Modelo',      cbModelo1.ItemIndex);
     dm.FiniParam.WriteString( 'Balanca1', 'Porta',       cbPortaSerial1.Text);
     dm.FiniParam.WriteString( 'Balanca1', 'BaudRate',    cbBaudRate1.Text);
     dm.FiniParam.WriteString( 'Balanca1', 'DataBits',    cbDataBits1.Text);
     dm.FiniParam.WriteInteger('Balanca1', 'Paridade',    cbParity1.ItemIndex);
     dm.FiniParam.WriteInteger('Balanca1', 'StopBits',    cbStopBits1.ItemIndex);
     dm.FiniParam.WriteInteger('Balanca1', 'HandShaking', cbHandShaking1.ItemIndex);
     dm.FiniParam.WriteString( 'Balanca1', 'TimeOut',     edTimeOut1.Text);

     dm.FiniParam.WriteInteger('Balanca2', 'Modelo',      cbModelo2.ItemIndex);
     dm.FiniParam.WriteString( 'Balanca2', 'Porta',       cbPortaSerial2.Text);
     dm.FiniParam.WriteString( 'Balanca2', 'BaudRate',    cbBaudRate2.Text);
     dm.FiniParam.WriteString( 'Balanca2', 'DataBits',    cbDataBits2.Text);
     dm.FiniParam.WriteInteger('Balanca2', 'Paridade',    cbParity2.ItemIndex);
     dm.FiniParam.WriteInteger('Balanca2', 'StopBits',    cbStopBits2.ItemIndex);
     dm.FiniParam.WriteInteger('Balanca2', 'HandShaking', cbHandShaking2.ItemIndex);
     dm.FiniParam.WriteString( 'Balanca2', 'TimeOut',     edTimeOut2.Text);

     dm.FiniParam.WriteInteger('Balanca3', 'Modelo',      cbModelo3.ItemIndex);
     dm.FiniParam.WriteString( 'Balanca3', 'Porta',       cbPortaSerial3.Text);
     dm.FiniParam.WriteString( 'Balanca3', 'BaudRate',    cbBaudRate3.Text);
     dm.FiniParam.WriteString( 'Balanca3', 'DataBits',    cbDataBits3.Text);
     dm.FiniParam.WriteInteger('Balanca3', 'Paridade',    cbParity3.ItemIndex);
     dm.FiniParam.WriteInteger('Balanca3', 'StopBits',    cbStopBits3.ItemIndex);
     dm.FiniParam.WriteInteger('Balanca3', 'HandShaking', cbHandShaking3.ItemIndex);
     dm.FiniParam.WriteString( 'Balanca3', 'TimeOut',     edTimeOut3.Text);

     pnlConfig.Width := 39;
     pnlConfig.Color := $0010B0FE;
end;

procedure TfSelecionaProd.btAnteriorClick(Sender: TObject);
begin
    skip := skip - 21;
end;

procedure TfSelecionaProd.btConfigClick(Sender: TObject);
var sSenha : string;
    i : TACBrBALModelo;
begin
     sSenha := '';

     if pnlConfig.Width = 224 then
     begin
          pnlConfig.Width := 39;
          pnlConfig.Color := $0010B0FE;
          exit;
     end;

     PostMessage(Handle, InputBoxMessage, 0, 0);
     if InputQuery('Senha de acesso','Senha',sSenha) = False then
          Exit;

     if sSenha <> 'adm%bbi' then
     begin
          Application.MessageBox('Senha inválida.','Atenção',MB_ICONEXCLAMATION);
          Exit;
     end;

     if pnlConfig.Width < 224 then
     begin
          pnlConfig.Width := 224;
          pnlConfig.Color := $00F0F0F0;
          rgUsaBalanca.ItemIndex := 0;

         cbModelo1.Items.Clear ;
         for I := Low(TACBrBALModelo) to High(TACBrBALModelo) do
            cbModelo1.Items.Add( GetEnumName(TypeInfo(TACBrBALModelo), integer(I) ) ) ;

         cbModelo1.ItemIndex := 0;
         CarregaBal;
     end;
end;

procedure TfSelecionaProd.btProxClick(Sender: TObject);
begin
      skip := skip + 21;
end;

procedure TfSelecionaProd.btSairClick(Sender: TObject);
begin
    if Application.MessageBox('Deseja realmente sair?','Atençao', mb_yesno + mb_iconquestion) = idYes then
      Close;
    //Application.Terminate;
end;

procedure TfSelecionaProd.btTestarValorUnitarioClick(Sender: TObject);
var
     iComandoInicial, iComandoFinal, iQtdDigitos, x : Integer;
     sCompletaDig, sFormataDigito, sValorEnviar, sComando : String;
     cValor : Currency;
begin
     iComandoInicial := StrToInt(edComandoInicial.Text);
     iComandoFinal   := StrToInt(edComandoFinal.Text);

     iQtdDigitos  := StrToInt(edQtdDigitos.Text);
     sCompletaDig := edCompletarDig.Text;
     if Trim(sCompletaDig) = '' then
          sCompletaDig := ' ';
     for x := 1 to iQtdDigitos do
          sFormataDigito := sFormataDigito + sCompletaDig;

     sValorEnviar := edValorUnitarioTeste.Text;
     cValor       := StrToCurr(AnsiReplaceStr(sValorEnviar,'.',''));
     sValorEnviar := FormatCurr('#####0.00',cValor);
     sValorEnviar := AnsiReplaceStr(AnsiReplaceStr(sValorEnviar,',',''),'.','');
     sValorEnviar := RightStr(sFormataDigito + Trim(sValorEnviar), iQtdDigitos);

     sComando := char(iComandoInicial) + sValorEnviar + char(iComandoFinal);

     if ACBrBAL.Ativo then
          ACBrBAL.Desativar;

     ConfigComponenteBalanca;

     ACBrBAL.Ativar;

     ACBrBAL.Device.Limpar;
     ACBrBAL.Device.EnviaString(sComando);

     ACBrBAL.Desativar;
end;

procedure TfSelecionaProd.btTestePesoClick(Sender: TObject);
begin
     if ACBrBAL.Ativo then
        ACBrBAL.Desativar;

     ConfigComponenteBalanca;

     ACBrBAL.Ativar;
     ACBrBAL.LePeso( TimeOut );
     ACBrBAL.Desativar;
end;

procedure TfSelecionaProd.cbBalancaChange(Sender: TObject);
begin
     cbModelo1.Visible        := cbBalanca.ItemIndex = 0;
     cbPortaSerial1.Visible   := cbBalanca.ItemIndex = 0;
     cbBaudRate1.Visible      := cbBalanca.ItemIndex = 0;
     cbDataBits1.Visible      := cbBalanca.ItemIndex = 0;
     cbParity1.Visible        := cbBalanca.ItemIndex = 0;
     cbStopBits1.Visible      := cbBalanca.ItemIndex = 0;
     cbHandShaking1.Visible   := cbBalanca.ItemIndex = 0;
     edTimeOut1.Visible       := cbBalanca.ItemIndex = 0;

     cbModelo2.Visible        := cbBalanca.ItemIndex = 1;
     cbPortaSerial2.Visible   := cbBalanca.ItemIndex = 1;
     cbBaudRate2.Visible      := cbBalanca.ItemIndex = 1;
     cbDataBits2.Visible      := cbBalanca.ItemIndex = 1;
     cbParity2.Visible        := cbBalanca.ItemIndex = 1;
     cbStopBits2.Visible      := cbBalanca.ItemIndex = 1;
     cbHandShaking2.Visible   := cbBalanca.ItemIndex = 1;
     edTimeOut2.Visible       := cbBalanca.ItemIndex = 1;

     cbModelo3.Visible        := cbBalanca.ItemIndex = 2;
     cbPortaSerial3.Visible   := cbBalanca.ItemIndex = 2;
     cbBaudRate3.Visible      := cbBalanca.ItemIndex = 2;
     cbDataBits3.Visible      := cbBalanca.ItemIndex = 2;
     cbParity3.Visible        := cbBalanca.ItemIndex = 2;
     cbStopBits3.Visible      := cbBalanca.ItemIndex = 2;
     cbHandShaking3.Visible   := cbBalanca.ItemIndex = 2;
     edTimeOut3.Visible       := cbBalanca.ItemIndex = 2;
end;

procedure TfSelecionaProd.cbQtdBalancaChange(Sender: TObject);
var i : TACBrBALModelo;
    x : integer;
begin
     cbBalanca.Clear;
     for x := 1 to cbQtdBalanca.ItemIndex + 1 do
          cbBalanca.Items.Add('Balanca ' + IntToStr(x));
     cbBalanca.ItemIndex := 0;
     cbBalancaChange(Self);
end;

procedure TFSelecionaProd.ClickBtnProduto(Sender: TObject);
var sql : string;
begin
     if pnlProdutos.Tag = 1 then
          Exit;

     ultBtnProd := TButton(Sender).Name;

     if ultBtnProd <> '' then
     begin
          try (pnlProdutos.FindComponent(ultBtnProd) as TButton).Font.Color := clWindowText;
          except; end;
     end;

     ultBtnProd := TButton(Sender).Name;

     sql := 'select tbprod.descricao, tbprod.codigo, '+
            ' tbunmed.descricao as unmed,'+
            ' tbprod.PVendaA' +
            ' from tbprod'+
            ' left join tbunmed on tbprod.unmed = tbunmed.codigo';

     sql := sql + ' where tbprod.codigo = ' + QuotedStr(AnsiReplaceStr(ultBtnProd,'btProd',''));
     sql := sql + ' and tbunmed.descricao = ''KG''';

     sqlaux.Close;
     sqlaux.SQL.Text := sql;
     sqlaux.Open;

     dm.sCodProd := AnsiReplaceStr(ultBtnProd,'btProd','');

     try
          Application.CreateForm(TfPrinc, fPrinc);
          Fprinc.ShowModal;
     finally
          FreeAndNil(fprinc);
     end;
end;

procedure TfSelecionaProd.FormResize(Sender: TObject);
begin
    pnlConfig.Width := 39;
end;

procedure TfSelecionaProd.FormShow(Sender: TObject);
begin
    bt_Prod_DivVert  := 127;
    bt_Prod_DivHorz  := 105;
    bt_Prod_Heigth   := 120;
    bt_Prod_Width    := 100;

    bt_Prod_FontName := 'Arial';
    bt_Prod_FontSize := 10;

    bt_Prod_MaxCaracteres := 0;
    bt_Prod_InfoValor     := False;

    skip := 0;

    pnlConfig.Width := 39;
    pnlConfig.Color := $0010B0FE;

    CarregaBal;

    CriaBotoesProdutos('and tbunmed.descricao = '+ QuotedStr('KG'));
end;

procedure TfSelecionaProd.rgUsaBalancaClick(Sender: TObject);
begin
     lbQtdBalanca.Enabled   := rgUsaBalanca.ItemIndex = 0;
     cbQtdBalanca.Enabled   := rgUsaBalanca.ItemIndex = 0;

     lbBalanca.Enabled      := rgUsaBalanca.ItemIndex = 0;
     cbBalanca.Enabled      := rgUsaBalanca.ItemIndex = 0;

     lbModelo.Enabled       := rgUsaBalanca.ItemIndex = 0;
     lbPortaSerial.Enabled  := rgUsaBalanca.ItemIndex = 0;
     lbBaudRate.Enabled     := rgUsaBalanca.ItemIndex = 0;
     lbDataBits.Enabled     := rgUsaBalanca.ItemIndex = 0;
     lbParity.Enabled       := rgUsaBalanca.ItemIndex = 0;
     lbStopBits.Enabled     := rgUsaBalanca.ItemIndex = 0;
     lbHandshaking.Enabled  := rgUsaBalanca.ItemIndex = 0;
     lbTimeOut.Enabled      := rgUsaBalanca.ItemIndex = 0;

     cbModelo1.Enabled      := rgUsaBalanca.ItemIndex = 0;
     cbPortaSerial1.Enabled := rgUsaBalanca.ItemIndex = 0;
     cbBaudRate1.Enabled    := rgUsaBalanca.ItemIndex = 0;
     cbDataBits1.Enabled    := rgUsaBalanca.ItemIndex = 0;
     cbParity1.Enabled      := rgUsaBalanca.ItemIndex = 0;
     cbStopBits1.Enabled    := rgUsaBalanca.ItemIndex = 0;
     cbHandShaking1.Enabled := rgUsaBalanca.ItemIndex = 0;
     edTimeOut1.Enabled     := rgUsaBalanca.ItemIndex = 0;

     cbModelo2.Enabled      := rgUsaBalanca.ItemIndex = 0;
     cbPortaSerial2.Enabled := rgUsaBalanca.ItemIndex = 0;
     cbBaudRate2.Enabled    := rgUsaBalanca.ItemIndex = 0;
     cbDataBits2.Enabled    := rgUsaBalanca.ItemIndex = 0;
     cbParity2.Enabled      := rgUsaBalanca.ItemIndex = 0;
     cbStopBits2.Enabled    := rgUsaBalanca.ItemIndex = 0;
     cbHandShaking2.Enabled := rgUsaBalanca.ItemIndex = 0;
     edTimeOut2.Enabled     := rgUsaBalanca.ItemIndex = 0;

     cbModelo3.Enabled      := rgUsaBalanca.ItemIndex = 0;
     cbPortaSerial3.Enabled := rgUsaBalanca.ItemIndex = 0;
     cbBaudRate3.Enabled    := rgUsaBalanca.ItemIndex = 0;
     cbDataBits3.Enabled    := rgUsaBalanca.ItemIndex = 0;
     cbParity3.Enabled      := rgUsaBalanca.ItemIndex = 0;
     cbStopBits3.Enabled    := rgUsaBalanca.ItemIndex = 0;
     cbHandShaking3.Enabled := rgUsaBalanca.ItemIndex = 0;
     edTimeOut3.Enabled     := rgUsaBalanca.ItemIndex = 0;

     btTestePeso.Enabled    := rgUsaBalanca.ItemIndex = 0;
     edTestePeso.Enabled    := rgUsaBalanca.ItemIndex = 0;

     cbEVrUnit.Enabled               := rgUsaBalanca.ItemIndex = 0;

     lbComandoInicial.Enabled        := (rgUsaBalanca.ItemIndex = 0) and (cbEVrUnit.Checked);
     edComandoInicial.Enabled        := (rgUsaBalanca.ItemIndex = 0) and (cbEVrUnit.Checked);
     lbComandoFinal.Enabled          := (rgUsaBalanca.ItemIndex = 0) and (cbEVrUnit.Checked);
     edComandoFinal.Enabled          := (rgUsaBalanca.ItemIndex = 0) and (cbEVrUnit.Checked);
     lbQtdDigitos.Enabled            := (rgUsaBalanca.ItemIndex = 0) and (cbEVrUnit.Checked);
     edQtdDigitos.Enabled            := (rgUsaBalanca.ItemIndex = 0) and (cbEVrUnit.Checked);
     lbCompletarDig.Enabled          := (rgUsaBalanca.ItemIndex = 0) and (cbEVrUnit.Checked);
     edCompletarDig.Enabled          := (rgUsaBalanca.ItemIndex = 0) and (cbEVrUnit.Checked);
     lbValorUnitarioTeste.Enabled    := (rgUsaBalanca.ItemIndex = 0) and (cbEVrUnit.Checked);
     edValorUnitarioTeste.Enabled    := (rgUsaBalanca.ItemIndex = 0) and (cbEVrUnit.Checked);
     btTestarValorUnitario.Enabled   := (rgUsaBalanca.ItemIndex = 0) and (cbEVrUnit.Checked);
end;

procedure TfSelecionaProd.SpeedButton1Click(Sender: TObject);
begin
     try
          ACBrBAL.Desativar;
          Application.CreateForm(TfPrinc, fPrinc);
          Fprinc.ShowModal;
     finally
          FreeAndNil(fprinc);
     end;
end;

end.

