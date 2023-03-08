unit untConsultaProdutos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxCheckBox, Menus, cxLookAndFeelPainters, StdCtrls,
  cxButtons, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid,
  dxGDIPlusClasses, IBCustomDataSet, IBQuery, cxButtonEdit, DBTables, rxMemTable, cxVariants, untDados,
  OleCtrls, SHDocVw, ComCtrls, ActiveX, MSHTML, wwdbdatetimepicker, Buttons,
  Provider, DBClient;

type
  TUrl = record
     Acao: string;
     Rotina: string;
     Chave: string;
  end;
  TfrmConsultaProdutos = class(TForm)
    pnlTitulo: TPanel;
    pnlSelecionados: TPanel;
    Panel5: TPanel;
    Panel1: TPanel;
    cxButton5: TcxButton;
    cxButton2: TcxButton;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    qryConsulta: TIBQuery;
    dtsConsulta: TDataSource;
    qryConsultaCODIGO: TIntegerField;
    qryConsultaDESCRICAO: TIBStringField;
    qryConsultaDATAAQUISICAO: TDateField;
    qryConsultaDETALHE: TIBStringField;
    qryProdutoFoto: TIBQuery;
    qryProdutoFotoCODIGOPRODUTO: TIntegerField;
    qryProdutoFotoID: TIntegerField;
    qryProdutoFotoCODIGOTIPOFOTO: TIntegerField;
    qryProdutoFotoURLFOTO: TMemoField;
    qryProdutoFotoDESCRICAO: TIBStringField;
    pnlZoom: TPanel;
    imgZoom: TImage;
    mmSelecionados: TMemoryTable;
    mmSelecionadosCODIGO: TIntegerField;
    mmSelecionadosNOME: TStringField;
    mmSelecionadosSELECTED: TBooleanField;
    dtsSelecionados: TDataSource;
    cxGridDBTableView1CODIGO: TcxGridDBColumn;
    cxGridDBTableView1NOME: TcxGridDBColumn;
    cxGridDBTableView1SELECTED: TcxGridDBColumn;
    qryConsultaPREFERENCIA: TMemoField;
    qryConsultaREFERENCIA: TIBStringField;
    qryConsultaTAMANHOS: TIBStringField;
    cxButton1: TcxButton;
    qryConsultaPRODUTOBLOQUEADO: TIntegerField;
    qryConsultaVALORALUGUEL1: TIBBCDField;
    cxButton3: TcxButton;
    PopupMenu1: TPopupMenu;
    ImprimirLista1: TMenuItem;
    ExportarLista1: TMenuItem;
    pnlBtnProdutos: TPanel;
    cxButton4: TcxButton;
    cxButton6: TcxButton;
    Splitter1: TSplitter;
    panel: TPanel;
    PageControl1: TPageControl;
    tsGrid: TTabSheet;
    TabSheet2: TTabSheet;
    grdPainel: TcxGrid;
    grdPainelDBTableView1: TcxGridDBTableView;
    grdPainelDBTableView1CODIGO: TcxGridDBColumn;
    grdPainelDBTableView1Column3: TcxGridDBColumn;
    grdPainelDBTableView1Column1: TcxGridDBColumn;
    grdPainelDBTableView1DATAAQUISICAO: TcxGridDBColumn;
    grdPainelDBTableView1DESCRICAO: TcxGridDBColumn;
    grdPainelDBTableView1Column2: TcxGridDBColumn;
    grdPainelDBTableView1TAMANHOS: TcxGridDBColumn;
    grdPainelDBTableView1Column5: TcxGridDBColumn;
    grdPainelDBTableView1BLOQUEADO: TcxGridDBColumn;
    grdPainelDBTableView1HISTORICO: TcxGridDBColumn;
    grdPainelLevel1: TcxGridLevel;
    wbListagem: TWebBrowser;
    pnlFiltro: TPanel;
    cxButton7: TcxButton;
    cxButton8: TcxButton;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edtFiltro_Codigo: TEdit;
    edtFiltro_Referencia: TEdit;
    edtFiltro_Valor: TEdit;
    edtFiltro_Descricao: TEdit;
    edtFiltro_Preferencias: TEdit;
    edtFiltro_Manequim: TEdit;
    pnlFotos: TPanel;
    ScrollBox1: TScrollBox;
    imgFoto1: TImage;
    lblFoto1: TLabel;
    imgFoto2: TImage;
    lblFoto2: TLabel;
    imgFoto4: TImage;
    lblFoto4: TLabel;
    imgFoto3: TImage;
    lblFoto3: TLabel;
    imgFoto5: TImage;
    lblFoto5: TLabel;
    lblFoto6: TLabel;
    imgFoto6: TImage;
    lblFoto7: TLabel;
    imgFoto7: TImage;
    lblFoto8: TLabel;
    imgFoto8: TImage;
    lblFoto9: TLabel;
    imgFoto9: TImage;
    lblFoto10: TLabel;
    imgFoto10: TImage;
    Edit1: TEdit;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    cdsSelecionados: TClientDataSet;
    cdsSelecionadosCODIGO: TIntegerField;
    cdsSelecionadosNOME: TStringField;
    cdsSelecionadosSELECTED: TBooleanField;
    DataSetProvider1: TDataSetProvider;
    pnlRegistros: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure grdPainelDBTableView1Column1PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure imgFoto1Click(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure qryConsultaBeforeOpen(DataSet: TDataSet);
    procedure cxButton1Click(Sender: TObject);
    procedure grdPainelDBTableView1CODIGOPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure grdPainelDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure grdPainelDBTableView1Column6PropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxButton3Click(Sender: TObject);
    procedure ImprimirLista1Click(Sender: TObject);
    procedure ExportarLista1Click(Sender: TObject);
    procedure edtIncrementalChange(Sender: TObject);
    procedure grdPainelDBTableView1KeyPress(Sender: TObject; var Key: Char);
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure wbListagemBeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure cxButton8Click(Sender: TObject);
    procedure cxButton7Click(Sender: TObject);
    procedure wbListagemEnter(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure PageControl1Enter(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    vDataEvento, vDataAgenda: TDate;
    vID, vIDEvento : Integer;
    vCodigoPerfil: Integer;
    vCodigoPedido: Integer;
    vUrlFoto: String;

    vHTML: String;

    mPosHtml: Integer;
    mFilter : String;
    mCampoBloqueado: String;
    SoContar: Boolean;

    procedure CarregarFotos(iCodigo: Integer);
    procedure SelecionarProduto(iCodigo: Integer);
    function CriaTextoHTML():string;
    Procedure ExibirCodigoHTML(iWeb: TWebBrowser; i_Codigo: string);
    function ProcessaURL(url:String):TUrl;
    { Private declarations }
  public
    ProdutosSelecionados: Array of Integer;
    _porArara, _porPedido, _porCadastro, _CompativeisPedido: Boolean;
    _CodigoAgenda, _CodigoPedido, _IdPed: Integer;
    CodigoSelecionado: Integer;
    { Public declarations }
  end;

var
  frmConsultaProdutos: TfrmConsultaProdutos;

implementation

uses form_cadastro_produto, untAcompanhaHistoricoProduto, funcao, versao;

{$R *.dfm}

//BOTÃO HELP
procedure TfrmConsultaProdutos.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmConsultaProdutos.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

function TfrmConsultaProdutos.ProcessaURL(url:String):TUrl;
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


function TfrmConsultaProdutos.CriaTextoHTML():string;
const Espaco='&nbsp;';
var lURLFoto: String;
 vDataSet: TDataSet;
begin
   try

      vDataSet := qryConsulta;

      Result :=   '<html><body>'+
                  '<b> '+
                  '<table style="font-family: arial, verdana; font-size: 12px;'+
                  'font-weight: bold; color: #801919;">'+
                  '<tr BGCOLOR="#D2D2D2" ALIGN="center">'+
                  '<td WIDTH="100" HEIGHT="20"><a href="acao:atualizar?">ATUALIZAR</a></td>'+
                  '<td WIDTH="100" HEIGHT="20"><a href="acao:filtrar?">FILTRAR</a></td></tr></table></p>'+
                  '<table style="font-family: arial, verdana; font-size: 12px;'+
                  'font-weight: bold; color: #801919;">'+
                  '<tr BGCOLOR="#D2D2D2" ALIGN="center"><td COLSPAN="4">Dados dos Produtos</td>'+
                  '<td>Foto</td></tr>'+#13#10;

      vDataSet.First;
      while not vDataSet.Eof do
         begin

         Dados.Geral.Close;
         Dados.Geral.SQL.Text := 'Select First 1 pf.urlfoto'+
            '  from tabprodutofotos pf  '+
            '  left join tabtipofoto tf on pf.codigotipofoto = tf.codigo '+
            ' where pf.codigoproduto = '+vDataSet.FieldByName('CODIGO').AsString+
            '   and tf.usarnaarara = 1 '+
            ' order by pf.id';
         Dados.Geral.Open;
         if Dados.Geral.FieldByName('urlfoto').AsString = '' then
           lURLFoto := ExtractFilePath(Application.ExeName)+'imagens\logo.png'
         else
           if FileExists(vUrlFoto+Dados.Geral.FieldByName('urlfoto').AsString) then
              lURLFoto := vUrlFoto+Dados.Geral.FieldByName('urlfoto').AsString
           else
              lURLFoto := ExtractFilePath(Application.ExeName)+'imagens\logo.png';

         Result := Result+
            '<tr BGCOLOR="#CCFFFF" valign="top"><td COLSPAN=5 HEIGHT="10"></td></tr>';

         Result := Result+
            '<tr BGCOLOR="#D2D2D2" valign="top">'+
            '<td BGCOLOR="#D2D2D2">Código:</td>'+
            '<td BGCOLOR="#FFFF99" ALIGN="center">'+vDataSet.FieldByName('CODIGO').AsString+'</td>'+
            '<td BGCOLOR="#D2D2D2">Referencia:</td>'+
            '<td BGCOLOR="#FFFF99" ALIGN="center">'+vDataSet.FieldByName('REFERENCIA').AsString+'</td>'+
            '<td BGCOLOR="#FFFF99" ROWSPAN="6" ALIGN="center"><img src="'+lURLFoto+'" height="200" width="200"></td></tr>'+

            '<tr BGCOLOR="#D2D2D2" valign="top" HEIGHT="40">'+
            '<td BGCOLOR="#D2D2D2">Descrição:</td>'+
            '<td BGCOLOR="#FFFF99" COLSPAN="3">'+vDataSet.FieldByName('DESCRICAO').AsString+'</td></tr>'+

            '<tr BGCOLOR="#D2D2D2" valign="top" HEIGHT="40">'+
            '<td BGCOLOR="#D2D2D2">Preferencias:</td>'+
            '<td BGCOLOR="#FFFF99" COLSPAN="3">'+vDataSet.FieldByName('PREFERENCIA').AsString+'</td></tr>'+

            '<tr BGCOLOR="#D2D2D2" valign="top" HEIGHT="20">'+
            '<td BGCOLOR="#D2D2D2">Manequim:</td>'+
            '<td BGCOLOR="#FFFF99" COLSPAN="3">'+vDataSet.FieldByName('TAMANHOS').AsString+'</td></tr>'+

            '<tr BGCOLOR="#D2D2D2" valign="top" HEIGHT="20">'+
            '<td BGCOLOR="#D2D2D2">Valor:</td>'+
            '<td BGCOLOR="#FFFF99" ALIGN="center">'+FormatFloat('R$ #,##0.00',vDataSet.FieldByName('VALORALUGUEL1').AsFloat)+'</td>'+
            iif(_porCadastro,
            '',
            '<td BGCOLOR="#D2D2D2">Bloqueado:</td>'+
            '<td BGCOLOR="#FFFF99" ALIGN="center">'+iif(vDataSet.FieldByName('PRODUTOBLOQUEADO').AsInteger = 1,'Sim', 'Não')+'</td>')+'</tr>'+

            '<tr BGCOLOR="#FFFF99" valign="top" HEIGHT="20" ALIGN="center">'+
            '<td BGCOLOR="#FFFF99" COLSPAN="2"><a href="acao:selecionar?'+vDataSet.FieldByName('CODIGO').AsString+'">SELECIONAR PRODUTO</a></td>'+
            '<td BGCOLOR="#FFFF99" COLSPAN="2"><a href="acao:VERFOTO?'+vDataSet.FieldByName('CODIGO').AsString+'">VER FOTOS</a></td></tr>'#13#10;

         vDataSet.Next;
         end;

      Result := Result+'</table></body></html>';
   except
      on e: exception do
         ShowMessage('Error 55224:'+E.Message);
   end;
end;


procedure TfrmConsultaProdutos.CarregarFotos(iCodigo: Integer);
var
  lblAuxy : Tlabel;
  imgAuxy : TImage;
begin
  qryProdutoFoto.Close;
  qryProdutoFoto.ParamByName('codigo').AsInteger := iCodigo;
  qryProdutoFoto.Open;

  lblFoto1.Visible  := False;  imgFoto1.Visible  := False;
  lblFoto2.Visible  := False;  imgFoto2.Visible  := False;
  lblFoto3.Visible  := False;  imgFoto3.Visible  := False;
  lblFoto4.Visible  := False;  imgFoto4.Visible  := False;
  lblFoto5.Visible  := False;  imgFoto5.Visible  := False;
  lblFoto6.Visible  := False;  imgFoto6.Visible  := False;
  lblFoto7.Visible  := False;  imgFoto7.Visible  := False;
  lblFoto8.Visible  := False;  imgFoto8.Visible  := False;
  lblFoto9.Visible  := False;  imgFoto9.Visible  := False;
  lblFoto10.Visible := False;  imgFoto10.Visible := False;

  while not qryProdutoFoto.Eof do
  begin

    lblAuxy := nil;
    imgAuxy := nil;
    Case qryProdutoFoto.RecNo of
      1 : begin
        lblAuxy := lblFoto1;
        imgAuxy := imgFoto1;
      end;
      2 : begin
        lblAuxy := lblFoto2;
        imgAuxy := imgFoto2;
      end;
      3 : begin
        lblAuxy := lblFoto3;
        imgAuxy := imgFoto3;
      end;
      4 : begin
        lblAuxy := lblFoto4;
        imgAuxy := imgFoto4;
      end;
      5 : begin
        lblAuxy := lblFoto5;
        imgAuxy := imgFoto5;
      end;
      6 : begin
        lblAuxy := lblFoto6;
        imgAuxy := imgFoto6;
      end;
      7 : begin
        lblAuxy := lblFoto7;
        imgAuxy := imgFoto7;
      end;
      8 : begin
        lblAuxy := lblFoto8;
        imgAuxy := imgFoto8;
      end;
      9 : begin
        lblAuxy := lblFoto9;
        imgAuxy := imgFoto9;
      end;
      10 : begin
        lblAuxy := lblFoto10;
        imgAuxy := imgFoto10;
      end;
    End;

    lblAuxy.Caption := qryProdutoFotoDESCRICAO.Text;

    if fileExists(vUrlFoto+qryProdutoFotoURLFOTO.AsString) then
      imgAuxy.Picture.LoadFromFile(vUrlFoto+qryProdutoFotoURLFOTO.AsString);

    lblAuxy.Visible := True;
    imgAuxy.Visible := True;

    qryProdutoFoto.Next;
  end;

  pnlFotos.Visible := True;
end;

procedure TfrmConsultaProdutos.cxButton1Click(Sender: TObject);
var
  i, CodigoProduto, Bloqueado : Integer;
  Descricao : String;
begin


  try
    if not cdsSelecionados.Active then
      cdsSelecionados.Open();

    grdPainelDBTableView1.Controller.SelectAll;

    for i:=0 to grdPainelDBTableView1.Controller.SelectedRowCount - 1 do
    begin

      CodigoProduto := grdPainelDBTableView1.Controller.SelectedRows[i].Values[grdPainelDBTableView1CODIGO.Index];
      Descricao := grdPainelDBTableView1.Controller.SelectedRows[i].Values[grdPainelDBTableView1DESCRICAO.Index];

      try
        Bloqueado := grdPainelDBTableView1.Controller.SelectedRows[i].Values[grdPainelDBTableView1BLOQUEADO.Index];
      except
        Bloqueado := 0;
      end;

      if not cdsSelecionados.FindKey([CodigoProduto]) then
      begin

        if Bloqueado = 0 then
        begin
          cdsSelecionados.Insert();
          cdsSelecionadosCODIGO.AsInteger := CodigoProduto;
          cdsSelecionadosNOME.Text := Descricao;
          cdsSelecionadosSELECTED.AsBoolean := True;
          cdsSelecionados.Post();

//          qryConsultaSelecionado.AsBoolean := True;
        end;

      end;

    end;
  finally
    grdPainelDBTableView1.Controller.ClearSelection;
  end;

end;

procedure TfrmConsultaProdutos.cxButton2Click(Sender: TObject);
begin
  if not _porCadastro then
  begin
    SetLength(ProdutosSelecionados,cdsSelecionados.RecordCount);
    cdsSelecionados.First;
    while not cdsSelecionados.Eof do
    begin
      ProdutosSelecionados[cdsSelecionados.RecNo - 1] := cdsSelecionadosCODIGO.AsInteger;
      cdsSelecionados.Next;
    end;
  end
  else
    CodigoSelecionado := qryConsultaCODIGO.AsInteger;
  Close;
end;

procedure TfrmConsultaProdutos.cxButton3Click(Sender: TObject);
begin

  if not cdsSelecionados.Active then
    cdsSelecionados.Open();

  cdsSelecionados.EmptyDataSet;

//  While not qryConsulta.Eof do
//  begin
//    qryConsultaSelecionado.AsBoolean := False;
//    qryConsulta.Next;
//  end;

end;

procedure TfrmConsultaProdutos.cxButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmConsultaProdutos.cxButton7Click(Sender: TObject);
var
  vFilter: String;
begin
   vFilter := '';
   mPosHtml := 0;
   mFilter := '';

   if edtFiltro_Codigo.Text <> '' then
      vFilter := vFilter+' AND (CODIGO = '+ edtFiltro_Codigo.Text + ')';

   if edtFiltro_Referencia.Text <> '' then
      vFilter := vFilter+' AND (REFERENCIA LIKE '+#39'%'+edtFiltro_Referencia.Text +'%'#39')';

   if edtFiltro_Valor.Text <> '' then
      vFilter := vFilter+' AND (VALORALUGUEL1 = '+
          StringReplace(StringReplace(edtFiltro_Valor.Text,'.','',[rfReplaceAll]),',','.',[rfReplaceAll]) +')';

   if edtFiltro_Descricao.Text <> '' then
      vFilter := vFilter+' AND (DESCRICAO LIKE '+#39'%'+edtFiltro_Descricao.Text +'%'#39')';

   if edtFiltro_Preferencias.Text <> '' then
      vFilter := vFilter+' AND (PREFERENCIA LIKE '+#39'%'+edtFiltro_Preferencias.Text +'%'#39')';

   if edtFiltro_Manequim.Text <> '' then
      vFilter := vFilter+' AND (TAMANHOS LIKE '+#39'%'+edtFiltro_Manequim.Text +'%'#39')';

   mFilter := vFilter;

   qryConsulta.Close;
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--where incremental')+1] := mFilter;
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--rows')+1] := 'rows '+IntToStr(mPosHtml+1)+' to '+IntToStr(mPosHtml+25);
   qryConsulta.Open;

   pnlRegistros.Caption := 'Registros: '+IntToStr(mPosHtml+1)+' ao '+IntToStr(mPosHtml+25);

   pnlFiltro.Visible := False;

   vHTML := CriaTextoHTML();
   ExibirCodigoHTML(wbListagem, vHTML);
end;

procedure TfrmConsultaProdutos.cxButton8Click(Sender: TObject);
begin
   pnlFiltro.Visible := False;
end;

procedure TfrmConsultaProdutos.edtIncrementalChange(Sender: TObject);
begin
//  if Trim(edtIncremental.Text) <> '' then
//  begin
//    qryConsulta.Close;
//    qryConsulta.SQL.Strings[qryConsulta.SQL.IndexOf('--where incremental') + 1] :=
//       ' and p.descricao like '+QuotedSTr('%'+edtIncremental.Text+'%');
//    qryConsulta.Open;
//  end
//  else
//  begin
//    qryConsulta.Close;
//    qryConsulta.SQL.Strings[qryConsulta.SQL.IndexOf('--where incremental') + 1] := '';
//    qryConsulta.Open;
//  end;
end;

procedure TfrmConsultaProdutos.ExportarLista1Click(Sender: TObject);
begin
  ExportarGrid(grdPainel);
end;

procedure TfrmConsultaProdutos.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
//  if pnlZoom.Visible then
//  begin
//    pnlZoom.Left := 656;
//    if Width > 1025 then
//      pnlZoom.Width := Width - 656
//    else
//      pnlZoom.Width := 361;
//  end;
end;

procedure TfrmConsultaProdutos.FormCreate(Sender: TObject);
begin
   wbListagem.Navigate('about:blank');
end;

procedure TfrmConsultaProdutos.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;

  vHTML := '';
  mPosHtml := 0;
  mFilter := '';
  mCampoBloqueado := ',coalesce((select distinct (case when vw.codigoproduto is null then 0 else 1 end) '+
       ' from viewhistoricoproduto vw '+
       ' where vw.codigoproduto = p.codigo and coalesce(DEVOLVIDO,0) = 0 '+
       ' and ((:DATA_AGENDA between vw.datainicio and vw.datafim) or (:DATA_EVENTO between vw.datainicio and vw.datafim))),0) as produtobloqueado';


  PageControl1.OnChange := nil;

  vUrlFoto := Dados.ValidaURL(tuProduto);

  if _porArara and _CompativeisPedido then
  begin

    dados.Geral.Close;
    dados.Geral.SQL.text := 'SELECT First 1 P.data, p.idperfil, p.idpedidoagenda, P.IDEVENTO FROM tabagenda P WHERE P.CODIGO = '+intToStr(_CodigoAgenda);
    dados.Geral.Open;

    vDataAgenda   := dados.geral.Fields[0].AsDateTime;
    if _IdPed > 0 then
       vCodigoPerfil := _IdPed
    else
       vCodigoPerfil := dados.geral.Fields[1].AsInteger;
    vCodigoPedido := dados.geral.Fields[2].AsInteger;
    vIDEvento     := dados.geral.Fields[3].AsInteger;

    dados.Geral.Close;
    dados.Geral.SQL.text := 'SELECT COALESCE(EV.DATAEVENTO,pe.DATAEVENTO) AS DATAEVENTO, ac.ID '+
                            '  FROM tabpedidoagendamento pe '+
                            '  left join TABACOMPANHANTESPEDIDOAGENDA AC ON (pe.CODIGO = AC.CODIGOPEDIDO AND AC.CODIGOPERFIL =0'+intToStr(vCodigoPerfil)+') '+
                            '  left join TABPEDIDOAGENDAMENTOEVENTOS EV ON (EV.CODIGO = PE.CODIGO AND EV.ID = AC.IDEVENTO) '+
                            '  WHERE Pe.CODIGO = '+intToStr(vCodigoPedido) +
                            '  AND COALESCE(AC.IDEVENTO,0) = '+intToStr(vIDEvento);{+
                            '  AND AC.CODIGOPERFIL = '+intToStr(_IdPed)};
    dados.Geral.Open;

    vDataEvento := dados.geral.Fields[0].AsDateTime;
    vID         := dados.geral.Fields[1].AsInteger;
  end
  else
  if _porPedido then
  begin

    Dados.Geral.Close;
    Dados.Geral.SQL.Text := ' SELECT P.DATAEVENTO, A.CODIGOPERFIL '+
                            '   FROM TABPEDIDOAGENDAMENTO P '+
                            '  INNER JOIN TABACOMPANHANTESPEDIDOAGENDA A ON (P.CODIGO =A.CODIGOPEDIDO) '+
                            '  WHERE P.CODIGO ='+ intToStr(_CodigoPedido) +
                            '    AND A.ID = '+intToStr(_IdPed);
    Dados.Geral.Open;

    vDataAgenda   := dados.geral.Fields[0].AsDateTime;
    vCodigoPerfil := dados.geral.Fields[1].AsInteger;
    vCodigoPedido := _CodigoPedido;
    vDataEvento   := vDataAgenda;
    vID           := _IdPed;


  end
  else
  if _porCadastro then
  begin
    vDataAgenda   := 0;
    vCodigoPerfil := 0;
    vCodigoPedido := 0;
    vDataEvento   := 0;
    vID           := 0;

    mCampoBloqueado := ',0 as produtobloqueado';

    grdPainelDBTableView1BLOQUEADO.Visible := False;
    grdPainelDBTableView1HISTORICO.Visible := False;
    pnlSelecionados.Visible := False;
    pnlBtnProdutos.Visible := True;
    pnlZoom.Visible := True;
  end;

  mmSelecionados.Close;
  mmSelecionados.Open;
//
//  qryConsulta.Close;
//  qryConsulta.Open;

  PageControl1.OnChange := PageControl1Change;

  PageControl1Change(Self);

  SetLength(ProdutosSelecionados,0);
end;

procedure TfrmConsultaProdutos.grdPainelDBTableView1CODIGOPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  if (qryConsultaCODIGO.AsInteger > 0) and not _porCadastro then
  begin
    if Application.FindComponent('cadastro_produto') = Nil then
           Application.CreateForm(Tcadastro_produto, cadastro_produto);

    cadastro_produto.Show;

    cadastro_produto.qryProduto.Locate('CODIGO',qryConsultaCODIGO.Text,[]);
  end;
end;

procedure TfrmConsultaProdutos.grdPainelDBTableView1Column1PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  if AButtonIndex = 1 then
    CarregarFotos(qryConsultaCODIGO.AsInteger)
  else if _porCadastro then
    cxButton2Click(self)
  else
    SelecionarProduto(qryConsultaCODIGO.AsInteger);

end;

procedure TfrmConsultaProdutos.grdPainelDBTableView1Column6PropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin

  if Assigned(frmAcompanhaHistoricoProduto) then
    FreeAndNil(frmAcompanhaHistoricoProduto);

  Application.CreateForm(TfrmAcompanhaHistoricoProduto, frmAcompanhaHistoricoProduto);

  With frmAcompanhaHistoricoProduto do
  begin
    Show;
    cbProduto.KeyValue := qryConsultaCODIGO.AsInteger;
    cxButton1.Click;
  end;

end;

procedure TfrmConsultaProdutos.grdPainelDBTableView1CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  Bloqueado: Integer;
begin

  try
    Bloqueado := VarAsType(AViewInfo.GridRecord.DisplayTexts[grdPainelDBTableView1BLOQUEADO.Index], varInteger);
  except
    Bloqueado := 0;
  end;

  if Bloqueado = 1 then
    ACanvas.Brush.Color := clRed;
end;

procedure TfrmConsultaProdutos.grdPainelDBTableView1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) and (_porCadastro) then
    cxButton2Click(self)
end;

procedure TfrmConsultaProdutos.SelecionarProduto(iCodigo: Integer);
begin

  qryConsulta.Locate('CODIGO',iCodigo,[]);

  if qryConsultaPRODUTOBLOQUEADO.AsInteger = 1 then
  begin
    application.MessageBox(PChar('Produto bloqueado para o período!'),'Erro!',MB_OK+MB_ICONERROR);
    Abort;
  end;

  if not cdsSelecionados.Active then
    cdsSelecionados.Open();

  if not cdsSelecionados.FindKey([qryConsultaCODIGO.AsInteger]) then
  begin
    cdsSelecionados.Insert();
    cdsSelecionadosCODIGO.Text := qryConsultaCODIGO.Text;
    cdsSelecionadosNOME.Text := qryConsultaDESCRICAO.Text;
    cdsSelecionadosSELECTED.AsBoolean := True;
    cdsSelecionados.Post();
  end;
end;

procedure TfrmConsultaProdutos.SpeedButton1Click(Sender: TObject);
begin
  pnlFotos.Visible := False;

  if not _porCadastro then
     begin
     pnlZoom.Visible := False;
     pnlSelecionados.Visible := True;
     end
  else
     imgZoom.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'imagens\logo.png');
end;

procedure TfrmConsultaProdutos.SpeedButton2Click(Sender: TObject);
var
   vHTML: String;
begin
   if mPosHtml = 0 then
      Exit;

   mPosHtml := mPosHtml - 25;

   qryConsulta.Close;
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--where incremental')+1] := mFilter;
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--rows')+1] := 'rows '+IntToStr(mPosHtml+1)+' to '+IntToStr(mPosHtml+25);
   qryConsulta.Open;

   pnlRegistros.Caption := 'Registros: '+IntToStr(mPosHtml+1)+' ao '+IntToStr(mPosHtml+25);

   vHTML := CriaTextoHTML();
   ExibirCodigoHTML(wbListagem, vHTML);
end;

procedure TfrmConsultaProdutos.SpeedButton3Click(Sender: TObject);
var
   vHTML: String;
   rCount: Integer;
   Multiplo: Integer;
   strTempBloqueado: String;
begin
   strTempBloqueado := mCampoBloqueado;
   mCampoBloqueado := ',0 as produtobloqueado';
   SoContar := True;
   qryConsulta.Close;
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--where incremental')+1] := '';
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--rows')+1] := '';
   qryConsulta.Open;
   SoContar := False;
   mCampoBloqueado := strTempBloqueado;
   qryConsulta.Last;

   rCount := qryConsulta.RecordCount;

   Multiplo := rCount div 25;

   if rCount = 0 then
      mPosHtml := 0
   else
      mPosHtml := 25 * Multiplo;

   qryConsulta.Close;
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--where incremental')+1] := mFilter;
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--rows')+1] := 'rows '+IntToStr(mPosHtml+1)+' to '+IntToStr(mPosHtml+25);
   qryConsulta.Open;

   pnlRegistros.Caption := 'Registros: '+IntToStr(mPosHtml+1)+' ao '+IntToStr(mPosHtml+25);

   vHTML := CriaTextoHTML();
   ExibirCodigoHTML(wbListagem, vHTML);
end;

procedure TfrmConsultaProdutos.SpeedButton4Click(Sender: TObject);
var
   vHTML: String;
  mTempPos : Integer;
begin
   if qryConsulta.RecordCount < 25 then
      Exit;

   mTempPos := mPosHtml;
   mPosHtml := mPosHtml + 25;

   qryConsulta.Close;
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--where incremental')+1] := mFilter;
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--rows')+1] := 'rows '+IntToStr(mPosHtml+1)+' to '+IntToStr(mPosHtml+25);
   qryConsulta.Open;

   if qryConsulta.IsEmpty then
   begin
     mPosHtml := mTempPos;
     qryConsulta.Close;
     qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--where incremental')+1] := mFilter;
     qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--rows')+1] := 'rows '+IntToStr(mPosHtml+1)+' to '+IntToStr(mPosHtml+25);
     qryConsulta.Open;
   end;

   pnlRegistros.Caption := 'Registros: '+IntToStr(mPosHtml+1)+' ao '+IntToStr(mPosHtml+25);

   vHTML := CriaTextoHTML();
   ExibirCodigoHTML(wbListagem, vHTML);
end;

procedure TfrmConsultaProdutos.SpeedButton5Click(Sender: TObject);
var
   vHTML: String;
begin
   mPosHtml := 0;

   qryConsulta.Close;
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--where incremental')+1] := mFilter;
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--rows')+1] := 'rows '+IntToStr(mPosHtml+1)+' to '+IntToStr(mPosHtml+25);
   qryConsulta.Open;

   pnlRegistros.Caption := 'Registros: '+IntToStr(mPosHtml+1)+' ao '+IntToStr(mPosHtml+25);

   vHTML := CriaTextoHTML();
   ExibirCodigoHTML(wbListagem, vHTML);
end;

procedure TfrmConsultaProdutos.wbListagemBeforeNavigate2(ASender: TObject;
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
      if lUrl.Rotina = 'ATUALIZAR' then
      begin
        vHTML := CriaTextoHTML();
        ExibirCodigoHTML(wbListagem, vHTML);
      end
      else if lUrl.Rotina = 'FILTRAR' then
      begin
        edtFiltro_Codigo.Text := '';
        edtFiltro_Referencia.Text := '';
        edtFiltro_Valor.Text := '';
        edtFiltro_Descricao.Text := '';
        edtFiltro_Preferencias.Text := '';
        edtFiltro_Manequim.Text := '';

        pnlFiltro.Visible := True;
        Repaint;
        Refresh;
        edtFiltro_Descricao.SetFocus;
      end
      else if lUrl.Rotina = 'SELECIONAR' then
      begin
        if _porCadastro then
        begin
          CodigoSelecionado := StrToIntDef(lUrl.Chave,0);
          Close;
        end
        else
          SelecionarProduto(StrToIntDef(lUrl.Chave,0));
      end
      else if lUrl.Rotina = 'VERFOTO' then
        CarregarFotos(StrToIntDef(lUrl.Chave,0));

      Cancel := True;
   end;
end;


procedure TfrmConsultaProdutos.wbListagemEnter(Sender: TObject);
begin
   pnlFotos.Visible := False;
  if _porCadastro then
    begin
    imgZoom.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'imagens\logo.png');
    pnlSelecionados.Visible := True;
    end
  else
    pnlZoom.Visible := False;

  pnlSelecionados.Visible := True;
end;

procedure TfrmConsultaProdutos.imgFoto1Click(Sender: TObject);
begin
  if Width > 1025 then
    pnlZoom.Width := Width - 656
  else
    pnlZoom.Width := 361;
  imgZoom.Picture := (Sender as TImage).Picture;
  pnlZoom.Visible := True;
  pnlSelecionados.Visible := False;
end;

procedure TfrmConsultaProdutos.ImprimirLista1Click(Sender: TObject);
begin
  ImprimirGrid(grdPainel,'Listagem de Produtos');
end;

procedure TfrmConsultaProdutos.PageControl1Change(Sender: TObject);
begin

   qryConsulta.Close;
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--where incremental')+1] := '';
   qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--rows')+1] := '';

   if PageControl1.ActivePageIndex = 1 then
     begin
     qryConsulta.sql.Strings[qryConsulta.sql.IndexOf('--rows')+1] := 'rows '+IntToStr(mPosHtml+1)+' to '+IntToStr(mPosHtml+25);
     qryConsulta.Open;

     pnlRegistros.Caption := 'Registros: '+IntToStr(mPosHtml+1)+' ao '+IntToStr(mPosHtml+25);

     if vHTML = '' then
       begin
       vHTML := CriaTextoHTML();
       ExibirCodigoHTML(wbListagem, vHTML);
       end;
     end
   else
     qryConsulta.Open;
end;

procedure TfrmConsultaProdutos.PageControl1Enter(Sender: TObject);
begin
   pnlFotos.Visible := False;
  if _porCadastro then
    begin
    imgZoom.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'imagens\logo.png');
    pnlSelecionados.Visible := True;
    end
  else
    pnlZoom.Visible := False;

  pnlSelecionados.Visible := True;
end;

Procedure TfrmConsultaProdutos.ExibirCodigoHTML(iWeb: TWebBrowser; i_Codigo: string);
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


procedure TfrmConsultaProdutos.qryConsultaBeforeOpen(DataSet: TDataSet);
begin
  qryConsulta.SQL.Strings[qryConsulta.sql.IndexOf('--Bloqueado')+1] := mCampoBloqueado;
   
  if (_porArara and _CompativeisPedido) or (_porPedido) then
  begin
//    qryConsulta.SQL.Strings[qryConsulta.sql.IndexOf('--x1')+1] :=
//        'and not Exists( '+
//        '     select * from viewhistoricoproduto vw '+
//        '      where ((:DATA_AGENDA between vw.datainicio and vw.datafim) '+
//        '          or (:DATA_EVENTO between vw.datainicio and vw.datafim)) '+
//        '         and (vw.codigoproduto = p.codigo) '+
//        '         )';
      qryConsulta.SQL.Strings[qryConsulta.sql.IndexOf('--x2')+1] :=
        'and (Select resultado from PROC_PRODUTO_COMPATIVEL_PEDIDO(p.codigo,:codigopedido,:codigoperfil,:id)) = 1';

    if (Not SoContar) then
      begin
      qryConsulta.ParamByName('DATA_AGENDA').AsDateTime := vDataAgenda;
      qryConsulta.ParamByName('DATA_EVENTO').AsDateTime := vDataEvento;
      end;
    qryConsulta.ParamByName('codigopedido').AsInteger := vCodigoPedido;
    qryConsulta.ParamByName('codigoperfil').AsInteger := vCodigoPerfil;
    qryConsulta.ParamByName('ID').AsInteger := vID;

  end
  else
  begin
    qryConsulta.SQL.Strings[qryConsulta.sql.IndexOf('--x1')+1] := '';
    qryConsulta.SQL.Strings[qryConsulta.sql.IndexOf('--x2')+1] := '';
  end;

end;

end.
