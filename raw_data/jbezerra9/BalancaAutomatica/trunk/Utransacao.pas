unit Utransacao;

interface

uses
  classes,SqlExpr,sysutils,dialogs,DBXCommon;//DBXpress;

type
  TTransacao = class(TObject)
  private

    procedure setLista(valor:TStringList);
    procedure setDataSet(valor:TSQLDataSet);
    procedure setConexao(valor:TSQLConnection);
  public
    pLista : TStringList;
    pDataSet : TSQLDataSet;
    pConexao : TSQLConnection;
    Trans : TTransactionDesc;
    constructor Create(valor:Tsqlconnection);
    destructor  Destroy; override;
    property Lista : TStringList read pLista write setLista;
    property DataSet : TSQLDataSet read pDataSet write setDataset;
    property Conexao : TSQLConnection read pConexao write setConexao;
    procedure Executar;
    function  ExecutarR :Boolean;
    procedure Adicionar(sql: string);
    procedure Limpar;
    procedure SubirTrans;
    procedure CancelarTrans;
    function ExecutarRR: string;
  end;

implementation

uses
  uMensagem, uModulo;

constructor TTransacao.Create(valor:TSQLConnection);
begin
  inherited create;

  //cria lista de strings
  pLista   := TStringList.Create;
  //atribui a conexao
  pconexao := valor;

  //cria o SQLDataSet
  pDataSet := TSQLDataSet.Create(nil);
  pDataSet.Name := 'pDataSet';
  pDataSet.MaxBlobSize := -1;
  pDataSet.SQLConnection := pConexao;
end;

destructor TTransacao.Destroy;
begin
  //destroi os objetos criados
  FreeAndNil(pLista);
  FreeAndNil(pDataset);

  inherited;
end;

procedure TTransacao.setLista(valor:TStringList);
begin
  //associa uma lista à propriedade pLista
  pLista.Assign(valor);
end;

procedure TTransacao.setDataSet(valor:TSQLDataset);
begin
  //associa um SQLDataSet à propriedade pDataSet
  pDataSet.Assign(valor);
end;

procedure TTransacao.setConexao(valor:TSQLConnection);
begin
  //associa uma conexao à propriedade pConexao
  pConexao.Assign(valor);
end;

procedure TTransacao.Executar;
var
I: Integer;
begin
  if (Lista.Count <> 0) then
  begin
    try
      Trans.IsolationLevel:= xilREADCOMMITTED;
      pConexao.StartTransaction(Trans);

      //executa as instruçoes da lista
      for I:= 0 to Lista.Count -1 do
      begin
        pDataset.Close();
        pDataset.CommandText := Lista.Strings[I];
        pDataset.ExecSQL();
      end;

      pConexao.Commit(Trans);

      Limpar();
    except
      on E: Exception do
      begin
        pDataSet.Close();
        pConexao.Rollback(Trans);
      end;
    end;
  end;
end;

procedure TTransacao.Adicionar(sql: string);
begin
  Lista.Add(sql);
end;

procedure TTransacao.Limpar;
begin
  Lista.Clear();
end;

function TTransacao.ExecutarR :Boolean;
var
  I: Integer;
begin
     if (Lista.Count <> 0) then
     begin
          Result := True;
          try
               {*************************************************************************
               ALTERADO POR MARCEL - 18/07/2012
               Alterações: Comentado o código do Random e alterado o valor
               xilrepeatableread para xilREADCOMMITTED
               *************************************************************************}

               Trans.IsolationLevel:= xilREADCOMMITTED;         //Alterado por Marcel - 18/07/2012

               try
                    pConexao.StartTransaction(Trans);
               except
               on E: Exception do
                    begin
                         pDataSet.Close();
                         pConexao.Rollback(Trans);
                         dm.sMsgErro := e.message;
                         Result := False;
                         Exit;
                    end;

               end;

               dm.FiErro := 1;
               //executa as instruçoes da lista
               for I:= 0 to Lista.Count -1 do
               begin
                    pDataset.Close();
                    pDataset.CommandText := Lista.Strings[I];
                    pDataset.ExecSQL();
                    dm.FiErro := dm.FiErro + 1;
               end;

               Limpar();
          except
          on E: Exception do
               begin
                    pDataSet.Close();
                    pConexao.Rollback(Trans);
                    dm.sMsgErro := e.message;
                    Result := False;
                    Exit;
               end;
          end;
     end;
end;

procedure TTransacao.SubirTrans;
begin
     pConexao.Commit(Trans);
end;

procedure TTransacao.CancelarTrans;
begin
     Limpar;
     pDataSet.Close();
     pConexao.Rollback(Trans);
end;

function TTransacao.ExecutarRR: string;
var
  Trans : TTransactionDesc;
  I: Integer;
begin
  if (Lista.Count <> 0) then
  begin
    try
      {*************************************************************************
      ALTERADO POR MARCEL - 18/07/2012
      Alterações: Comentado o código do Random e alterado o valor
        xilrepeatableread para xilREADCOMMITTED
      *************************************************************************}

      //Randomize();                                   //Comentado por Marcel - 18/07/2012
      //Trans.TransactionId := random(999);            //Comentado por Marcel - 18/07/2012
      Trans.IsolationLevel:= xilREADCOMMITTED;         //Alterado por Marcel - 18/07/2012
      pConexao.StartTransaction(Trans);

      //executa as instruçoes da lista
      for I:= 0 to Lista.Count -1 do
      begin
        pDataset.Close();
        pDataset.CommandText := Lista.Strings[I];
        pDataset.ExecSQL();
      end;

      pConexao.Commit(Trans);

      Limpar();
    except
      on E: Exception do
      begin
//        MessageError(Lista.Strings[I]);
        //MessageError('Erro:' + #13 + E.Message);
        pDataSet.Close();
        pConexao.Rollback(Trans);
        Result := e.message;
        Exit;
      end;
    end;
    Result := '';
  end;
end;

end.
