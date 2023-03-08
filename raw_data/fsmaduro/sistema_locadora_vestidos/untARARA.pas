unit untARARA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, wwdbdatetimepicker, StdCtrls, Mask, DBCtrls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, cxButtonEdit,
  cxCheckBox, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid, Menus,
  cxLookAndFeelPainters, cxButtons, DBTables, rxMemTable, cxImage, ExtCtrls,
  dxmdaset, RxMemDS, cxBlobEdit, cxGridCardView, cxGridDBCardView,
  cxEditRepositoryItems, DBCGrids, dxGDIPlusClasses, Buttons, IBCustomDataSet,
  IBQuery, OleCtrls, SHDocVw, MSHTML, ActiveX, ComCtrls, cxLookAndFeels,
  dxSkinBlack, dxSkinBlue,  dxSkinCaramel, dxSkinCoffee,
   dxSkinDarkSide,
   dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinPumpkin,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
   dxSkinValentine, 
  dxSkinXmas2008Blue;

type
  TUrl = record
     Acao: string;
     Rotina: string;
     Chave: string;
  end;
  TfrmARARA = class(TForm)
    pnlImagem: TPanel;
    Image1: TImage;
    Edit2: TEdit;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    qryArara: TIBQuery;
    dtsArara: TDataSource;
    qryAraraDetalhe: TIBQuery;
    dtsAraraDetalhe: TDataSource;
    qryAraraCODIGO: TIntegerField;
    qryAraraCODIGOAGENDA: TIntegerField;
    qryAraraCODIGOPERFIL: TIntegerField;
    qryAraraPERFIL: TIBStringField;
    qryAraraDATA: TDateField;
    qryAraraHORA: TTimeField;
    qryAraraDetalheCODIGOPRODUTO: TIntegerField;
    qryAraraDetalheDESCRICAO: TIBStringField;
    qryAraraDetalheURLFOTO: TMemoField;
    qryAraraDATAREGISTRO: TDateField;
    qryAraraDATAFIM: TDateField;
    qryAraraHORAFIM: TTimeField;
    PopupMenu1: TPopupMenu;
    Configuraes1: TMenuItem;
    Panel2: TPanel;
    lblCodigo: TLabel;
    Label1: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtCodigo: TDBEdit;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    DBEdit5: TDBEdit;
    wwDBDateTimePicker2: TwwDBDateTimePicker;
    DBEdit1: TDBEdit;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    wwDBDateTimePicker3: TwwDBDateTimePicker;
    Panel3: TPanel;
    cxButton4: TcxButton;
    cxButton6: TcxButton;
    cxButton3: TcxButton;
    cxButton5: TcxButton;
    cxButton7: TcxButton;
    wbListagem: TWebBrowser;
    Panel4: TPanel;
    lbSelecionados: TListBox;
    Panel5: TPanel;
    cxButton8: TcxButton;
    qryAraraDetalheREFERENCIA: TIBStringField;
    qryAraraDetalheVALORALUGUEL1: TIBBCDField;
    chbSemFoto: TCheckBox;
    splZoom: TSplitter;
    chbCompativeis: TCheckBox;
    Image2: TImage;
    procedure FormShow(Sender: TObject);
    procedure ImageClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure qryAraraDetalheAfterOpen(DataSet: TDataSet);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure cxButton6Click(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure qryAraraBeforeOpen(DataSet: TDataSet);
    procedure cxButton2Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure cxButton7Click(Sender: TObject);
    procedure wbListagemBeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure FormCreate(Sender: TObject);
    procedure cxButton8Click(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    vUrlFoto : String;
    procedure CarregarProdutos();
    procedure ApuraSelecionados();
    procedure CarregaConfiguracoes();
    function CriaTextoHTML():string;
    function ProcessaURL(url:String):TUrl;
    Procedure ExibirCodigoHTML(iWeb: TWebBrowser; i_Codigo: string);
    procedure SelecionarItem(lStrItem: String);

    { Private declarations }
  public
    ProdutosSelecionados: array of integer;
    vCodigo: Integer;
    { Public declarations }
  end;

var
  frmARARA: TfrmARARA;

implementation

uses
  untDados, untConsultaProdutos, untDtmRelatorios, funcao, versao;

Const
  cCaption = 'ARARA';
  
{$R *.dfm}

//BOTÃO HELP
procedure TfrmARARA.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmARARA.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0;
    ControleVersao.ShowAlteracoes(self.Name);
  end
  else
    inherited;
end;
//FIM BOTÃO HELP

procedure TfrmARARA.ApuraSelecionados();
var
  i: integer;
begin
  SetLength(ProdutosSelecionados,0);
  for i := 0 to lbSelecionados.Count - 1 do
  begin
    SetLength(ProdutosSelecionados,length(ProdutosSelecionados)+1);
    ProdutosSelecionados[length(ProdutosSelecionados)-1] := StrToIntDef(Copy(lbSelecionados.Items[i],1,pos(' -',lbSelecionados.Items[i]) - 1),0);
  end;
end;

function TfrmARARA.ProcessaURL(url:String):TUrl;
var
   lUrl: string;
begin
   lUrl := UpperCase(url);
   result.Acao   := Copy(lUrl,1,Pos(':',url) - 1);
   lUrl := Copy(lUrl,Pos(':',lUrl) + 1 ,Length(lUrl));
   result.Rotina := Copy(lUrl,1 ,Pos('?',lUrl) - 1);
   lUrl := Copy(lUrl,Pos('?',lUrl) + 1 ,Length(lUrl));
   result.Chave  := lUrl;
end;

function TfrmARARA.CriaTextoHTML():string;
const Espaco='&nbsp;';
var lURLFoto: String;
begin
   try

      Result :=   '<html><body>'+
                  '<b> '+
                  '<table style="font-family: arial, verdana; font-size: 12px;'+
                  'font-weight: bold; color: #801919;">'+
                  '<tr BGCOLOR="#D2D2D2" ALIGN="center"><td COLSPAN="4">Itens da Arara</td>'+
                  '<td>Foto</td></tr>';

      qryAraraDetalhe.First;
      while not qryAraraDetalhe.Eof do
         begin

         if qryAraraDetalhe.FieldByName('URLFOTO').AsString = '' then
           lURLFoto := ExtractFilePath(Application.ExeName)+'imagens\logo.png'
         else
           if FileExists(vUrlFoto+qryAraraDetalhe.FieldByName('URLFOTO').AsString) then
              lURLFoto := vUrlFoto+qryAraraDetalhe.FieldByName('URLFOTO').AsString
           else
              lURLFoto := ExtractFilePath(Application.ExeName)+'imagens\logo.png';

         Result := Result+
            '<tr BGCOLOR="#CCFFFF" valign="top"><td COLSPAN=5 HEIGHT="10"></td></tr>';

         Result := Result+
            '<tr BGCOLOR="#D2D2D2" valign="top">'+
            '<td BGCOLOR="#D2D2D2">Código:</td>'+
            '<td BGCOLOR="#FFFF99" ALIGN="center">'+qryAraraDetalhe.FieldByName('CODIGOPRODUTO').AsString+'</td>'+
            '<td BGCOLOR="#D2D2D2">Referencia:</td>'+
            '<td BGCOLOR="#FFFF99" ALIGN="center">'+qryAraraDetalhe.FieldByName('REFERENCIA').AsString+'</td>'+
            '<td BGCOLOR="#FFFF99" ROWSPAN="4" ALIGN="center"><img src="'+lURLFoto+'" height="150" width="150"></td></tr>'+

            '<tr BGCOLOR="#D2D2D2" valign="top" HEIGHT="80">'+
            '<td BGCOLOR="#D2D2D2">Descrição:</td>'+
            '<td BGCOLOR="#FFFF99" COLSPAN="3">'+qryAraraDetalhe.FieldByName('DESCRICAO').AsString+'</td></tr>'+

            '<tr BGCOLOR="#D2D2D2" valign="top" HEIGHT="10">'+
            '<td BGCOLOR="#D2D2D2">Valor:</td>'+
            '<td BGCOLOR="#FFFF99" ALIGN="center" COLSPAN="3">'+FormatFloat('R$ #,##0.00',qryAraraDetalhe.FieldByName('VALORALUGUEL1').AsFloat)+'</td></tr>'+

            '<tr BGCOLOR="#FFFF99" valign="top" HEIGHT="10" ALIGN="center">'+
            '<td BGCOLOR="#FFFF99" COLSPAN="2"><a href="acao:selecionar?'+qryAraraDetalhe.FieldByName('CODIGOPRODUTO').AsString+' - '+qryAraraDetalhe.FieldByName('DESCRICAO').AsString+'">SELECIONAR PRODUTO</a></td>'+
            '<td BGCOLOR="#FFFF99" COLSPAN="2"><a href="acao:VERFOTO?'+lURLFoto+'">VER FOTO</a></td></tr>';

         qryAraraDetalhe.Next;
         end;

      Result := Result+'</table></body></html>';
   except
      on e: exception do
         ShowMessage('Error 55224:'+E.Message);
   end;
end;


procedure TfrmARARA.CarregarProdutos();
var
  vHtml : String;
begin

  vHTML := CriaTextoHTML();
  ExibirCodigoHTML(wbListagem, vHTML);

end;

Procedure TfrmARARA.ExibirCodigoHTML(iWeb: TWebBrowser; i_Codigo: string);
var
   V            : Variant;
   HTMLDocument : IHTMLDocument2;
begin
   try
      // Carrega Safe Array
      HTMLDocument := iWeb.Document as IHTMLDocument2;
      V            := VarArrayCreate([0,0], varVariant);
      V[0]         := i_Codigo;

      // Escreve código HTML no documento do Browser
      try
         HTMLDocument.Write(PSafeArray(TVarData(V).VArray));
         HTMLDocument.Close();
      except
         raise Exception.Create('Não foi exibido as implementações no sistema, verifique a versão do "internet explorer"');
      end;

   except
      On E: Exception do
        ShowMessage('Error 62504:'+E.Message);
   end;
end;


procedure TfrmARARA.Configuraes1Click(Sender: TObject);
begin
  dados.ShowConfig(frmARARA);
  CarregaConfiguracoes()
end;

procedure TfrmARARA.cxButton1Click(Sender: TObject);
var
  QtdProdutos, i : Integer;
  lFrmConsultaProduto: TfrmConsultaProdutos;
begin
  lFrmConsultaProduto := TfrmConsultaProdutos.Create(Self);
  Try

    lFrmConsultaProduto._porArara := True;
    lFrmConsultaProduto._CompativeisPedido := chbCompativeis.Checked;
    lFrmConsultaProduto._porCadastro := False;

    lFrmConsultaProduto._CodigoAgenda := qryAraraCODIGOAGENDA.AsInteger;
    lFrmConsultaProduto._IdPed  := qryAraraCODIGOPERFIL.AsInteger;

    lFrmConsultaProduto.ShowModal;

    QtdProdutos := Length(lFrmConsultaProduto.ProdutosSelecionados);

    for i := 0 to QtdProdutos - 1 do
    begin

      dados.Geral.Close;
      dados.Geral.sql.Text := 'Select * from TABARARADETALHE where CODIGOARARA = '+IntToStr(qryAraraCODIGO.asInteger)+
                              ' AND CODIGOPRODUTO = ' +intToStr(lFrmConsultaProduto.ProdutosSelecionados[i]);
      dados.Geral.Open;

      if dados.Geral.isEmpty then
      begin
        dados.Geral.Close;
        dados.Geral.sql.Text := 'Insert into TABARARADETALHE (CODIGOARARA, CODIGOPRODUTO) values ('+IntToStr(qryAraraCODIGO.asInteger)+
                                ',' +intToStr(lFrmConsultaProduto.ProdutosSelecionados[i])+')';
        dados.Geral.ExecSql;
        dados.Geral.Transaction.CommitRetaining;
      end;

    end;

    qryAraraDetalhe.Close;
    qryAraraDetalhe.Open;
  Finally
    FreeAndNil(lFrmConsultaProduto);
  End;

end;

procedure TfrmARARA.cxButton2Click(Sender: TObject);
begin
  frmDtmRelatorios.ImprimirArara(qryAraraCODIGO.AsInteger, chbSemFoto.Checked);
end;

procedure TfrmARARA.cxButton3Click(Sender: TObject);
begin
  SetLength(ProdutosSelecionados,0);
  close;
end;

procedure TfrmARARA.cxButton4Click(Sender: TObject);
var
  i: integer;
begin
  if not Application.MessageBox('Deseja Realmente Remover Produtos da Arara?','Gravar',MB_YESNO+MB_ICONQUESTION) = idyes then
    Exit;

  ApuraSelecionados();

  for i := 0 to length(ProdutosSelecionados) - 1 do
  begin
    dados.Geral.SQL.Text := 'delete from TABARARADETALHE where CODIGOARARA = '+IntToStr(qryAraraCODIGO.AsInteger)+
                            ' and CODIGOPRODUTO = '+IntToStr(ProdutosSelecionados[i]);
    dados.Geral.ExecSQL();
    dados.Geral.Transaction.CommitRetaining();
  end;

  qryAraraDetalhe.close;
  qryAraraDetalhe.open;

  lbSelecionados.Clear;
end;

procedure TfrmARARA.cxButton5Click(Sender: TObject);
//var
//  i: Integer;
begin
  lbSelecionados.Clear;
  qryAraraDetalhe.First;
  while not qryAraraDetalhe.eof do
  begin
     lbSelecionados.Items.Add(qryAraraDetalheCODIGOPRODUTO.text+' - '+qryAraraDetalheDESCRICAO.Text);
     qryAraraDetalhe.next;
  end;
end;

procedure TfrmARARA.cxButton6Click(Sender: TObject);
begin
  ApuraSelecionados();
  Close;
end;

procedure TfrmARARA.cxButton7Click(Sender: TObject);
begin
  lbSelecionados.Clear;
end;

procedure TfrmARARA.cxButton8Click(Sender: TObject);
begin
   lbSelecionados.DeleteSelected;
end;

procedure TfrmARARA.CarregaConfiguracoes();
begin
  chbCompativeis.Checked := Dados.Config(frmARARA,'PRODUTOSCOMPATIVEIS','Apenas Produtos Compatíveis com o Pedido de Agendamento',
                                    'Apresentar Apenas Produtos Compatíveis com as Preferencias e Tamanhos contidos no Pedido de Agendamento?',
                                    0,tcCheck).vcBoolean;

end;

procedure TfrmARARA.FormCreate(Sender: TObject);
begin
  wbListagem.Navigate('about:blank');

  CarregarImagem(Image1,'topo_painel.png');
  Caption := CaptionTela(cCaption);
end;

procedure TfrmARARA.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try
    CarregaConfiguracoes();

    vUrlFoto := Dados.ValidaURL(tuProduto);

    qryArara.Close;
    qryArara.Open;

    qryAraraDetalhe.Close;
    qryAraraDetalhe.Open;
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;

end;

procedure TfrmARARA.ImageClick(Sender: TObject);
begin
  Image1.Picture := (sender as TImage).Picture;
  pnlImagem.Visible := True;
  splZoom.Visible := True;
end;

procedure TfrmARARA.qryAraraBeforeOpen(DataSet: TDataSet);
begin
  qryArara.Params[0].AsInteger := vCodigo;
end;

procedure TfrmARARA.qryAraraDetalheAfterOpen(DataSet: TDataSet);
begin
  CarregarProdutos();
end;

procedure TfrmARARA.SpeedButton1Click(Sender: TObject);
begin
  pnlImagem.Visible := False;
  splZoom.Visible := False;
end;

procedure TfrmARARA.wbListagemBeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
   lUrl : TUrl;
begin
   lUrl := ProcessaURL(URL);

   if (lUrl.Acao = '') and (lUrl.Rotina = '') then
      Exit;

   if lUrl.Acao = 'ACAO' then
   begin
     Try
       if lUrl.Rotina = 'SELECIONAR' then
       begin
         SelecionarItem(StringReplace(lUrl.Chave,'%20',' ',[rfReplaceAll]))
       end
       else if lUrl.Rotina = 'VERFOTO' then
       begin
         Image1.Picture.LoadFromFile(StringReplace(lUrl.Chave,'%20',' ',[rfReplaceAll]));
         pnlImagem.Visible := True;
         splZoom.Visible := True;
       end;
     finally
       Cancel := True;
     end;
     end;


end;

procedure TfrmArara.SelecionarItem(lStrItem: String);
var
  lStrCodigo: String;
  i : integer;
  lAchou: Boolean;
begin
  lAchou := False;
  lStrCodigo := Copy(lStrItem,1,Pos(' -',lStrItem) - 1);
  for i := 0 to lbSelecionados.Count - 1 do
    if Copy(lbSelecionados.Items[i],1,Pos(' -',lbSelecionados.Items[i]) - 1) = lStrCodigo then
    begin
    lAchou := True;
    Break;
    end;

  if not lAchou then
    lbSelecionados.Items.Add(lStrItem);
end;

end.
