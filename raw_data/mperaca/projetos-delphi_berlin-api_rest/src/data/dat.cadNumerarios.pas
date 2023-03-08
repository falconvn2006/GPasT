unit dat.cadNumerarios;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaNumerario(XId: integer): TJSONObject;
function RetornaListaNumerarios(const XQuery: TDictionary<string, string>): TJSONArray;
function IncluiNumerario(XNumerario: TJSONObject): TJSONObject;
function AlteraNumerario(XIdNumerario: integer; XNumerario: TJSONObject): TJSONObject;
function ApagaNumerario(XIdNumerario: integer): TJSONObject;
function VerificaRequisicao(XNumerario: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaNumerario(XId: integer): TJSONObject;
var wquery: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wret: TJSONObject;
begin
  try
// cria provider de conexão com BD
    wconexao := TProviderDataModuleConexao.Create(nil);

    wquery   := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       with wquery do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('select  "CodigoInternoNumerario"     as id,');
         SQL.Add('        "DescricaoNumerario"         as descricao,');
         SQL.Add('        "EhChequeNumerario"          as ehcheque,');
         SQL.Add('        "TipoNumerario"              as tipo,');
         SQL.Add('        "PercAcresDescNumerario"     as percacrescdesc,');
         SQL.Add('        "TipoAcresDescNumerario"     as tipoacrescdesc,');
         SQL.Add('        "DiasPrazoNumerario"         as diasprazo,');
         SQL.Add('        "ImprimeDividaNumerario"     as imprimedivida,');
         SQL.Add('        "IdentificaClienteNumerario" as identificacliente,');
         SQL.Add('        "IdentificaCliente"          as identifica,');
         SQL.Add('        "ImprimeTEFNumerario"        as imprimetef,');
         SQL.Add('        "TransacaoChequeNumerario"   as transacaocheque,');
         SQL.Add('        "EhRedeCardNumerario"        as ehredecard,');
         SQL.Add('        "EhBanricomprasNumerario"    as ehbanricompras,');
         SQL.Add('        "EhTecBanNumerario"          as ehtecban,');
         SQL.Add('        "RestricaoNumerario"         as restricao,');
         SQL.Add('        "SomaVendaNumerario"         as somavenda,');
         SQL.Add('        "VendaAVistaNumerario"       as vendaavista,');
         SQL.Add('        "VendaAPrazoNumerario"       as vendaaprazo,');
         SQL.Add('        "GeraBonusFidelidadeNumerario" as gerabonusfidelidade,');
         SQL.Add('        "OrdemNumerario"             as ordem,');
         SQL.Add('        "ExigeLiberacaoNumerario"    as exigeliberacao,');
         SQL.Add('        "CodigoPortadorNumerario"    as idportador,');
         SQL.Add('        "VisivelCaixaNumerario"      as visivelcaixa,');
         SQL.Add('        "GeraBonusPromocionalNumerario"  as gerabonuspromocional,');
         SQL.Add('        "GeraCreditoDevolucaoNumerario"  as geracreditodevolucao,');
         SQL.Add('        "GeraMovimentoBancarioNumerario" as geramovimentobancario ');
         SQL.Add('from "Numerario" ');
         SQL.Add('where "CodigoInternoNumerario"=:xid ');
         ParamByName('xid').AsInteger := XId;
         Open;
         EnableControls;
       end;

   if wquery.RecordCount>0 then
      wret := wquery.ToJSONObject()
   else
      begin
        wret := TJSONObject.Create;
        wret.AddPair('status','500');
        wret.AddPair('description','Nenhum Numerário encontrado');
        wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      end;

  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := TJSONObject.Create;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao retornar Atividade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;

function RetornaListaNumerarios(const XQuery: TDictionary<string, string>): TJSONArray;
var wqueryLista: TFDQuery;
    wconexao: TProviderDataModuleConexao;
    wobj: TJSONObject;
    wret: TJSONArray;
begin
  try
// cria provider de conexão com BD
    wconexao    := TProviderDataModuleConexao.Create(nil);
    wqueryLista := TFDQuery.Create(nil);

    if wconexao.EstabeleceConexaoDB then
       with wqueryLista do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
          SQL.Add('select  "CodigoInternoNumerario"     as id,');
         SQL.Add('        "DescricaoNumerario"         as descricao,');
         SQL.Add('        "EhChequeNumerario"          as ehcheque,');
         SQL.Add('        "TipoNumerario"              as tipo,');
         SQL.Add('        "PercAcresDescNumerario"     as percacrescdesc,');
         SQL.Add('        "TipoAcresDescNumerario"     as tipoacrescdesc,');
         SQL.Add('        "DiasPrazoNumerario"         as diasprazo,');
         SQL.Add('        "ImprimeDividaNumerario"     as imprimedivida,');
         SQL.Add('        "IdentificaClienteNumerario" as identificacliente,');
         SQL.Add('        "IdentificaCliente"          as identifica,');
         SQL.Add('        "ImprimeTEFNumerario"        as imprimetef,');
         SQL.Add('        "TransacaoChequeNumerario"   as transacaocheque,');
         SQL.Add('        "EhRedeCardNumerario"        as ehredecard,');
         SQL.Add('        "EhBanricomprasNumerario"    as ehbanricompras,');
         SQL.Add('        "EhTecBanNumerario"          as ehtecban,');
         SQL.Add('        "RestricaoNumerario"         as restricao,');
         SQL.Add('        "SomaVendaNumerario"         as somavenda,');
         SQL.Add('        "VendaAVistaNumerario"       as vendaavista,');
         SQL.Add('        "VendaAPrazoNumerario"       as vendaaprazo,');
         SQL.Add('        "GeraBonusFidelidadeNumerario" as gerabonusfidelidade,');
         SQL.Add('        "OrdemNumerario"             as ordem,');
         SQL.Add('        "ExigeLiberacaoNumerario"    as exigeliberacao,');
         SQL.Add('        "CodigoPortadorNumerario"    as idportador,');
         SQL.Add('        "VisivelCaixaNumerario"      as visivelcaixa,');
         SQL.Add('        "GeraBonusPromocionalNumerario"  as gerabonuspromocional,');
         SQL.Add('        "GeraCreditoDevolucaoNumerario"  as geracreditodevolucao,');
         SQL.Add('        "GeraMovimentoBancarioNumerario" as geramovimentobancario ');
         SQL.Add('from "Numerario" where "CodigoEmpresaNumerario"=:xempresa ');
         ParamByName('xempresa').AsInteger := wconexao.FIdEmpresaNumerario;
         if XQuery.ContainsKey('descricao') then // filtro por descrição
            begin
              SQL.Add('and lower("DescricaoNumerario") like lower(:xdescricao) ');
              ParamByName('xdescricao').AsString := XQuery.Items['descricao']+'%';
              SQL.Add('order by "DescricaoNumerario" ');
            end;
         if XQuery.ContainsKey('tipo') then // filtro por tipo
            begin
              SQL.Add('and "TipoNumerario" like :xtipo ');
              ParamByName('xtipo').AsString := XQuery.Items['tipo']+'%';
              SQL.Add('order by "TipoNumerario" ');
            end;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhum Numerário encontrado');
         wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
         wret := TJSONArray.Create;
         wret.AddElement(wobj);
       end;
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wobj := TJSONObject.Create;
      wobj.AddPair('status','500');
      wobj.AddPair('description',E.Message);
      wobj.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
      wret := TJSONArray.Create;
      wret.AddElement(wobj);
//      messagedlg('Problema ao retorna listas de Atividades'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;

function IncluiNumerario(XNumerario: TJSONObject): TJSONObject;
var wquery: TFDMemTable;
    wqueryInsert,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wnum: integer;
    wconexao: TProviderDataModuleConexao;
    wval: string;
begin
  try
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryInsert := TFDQuery.Create(nil);
    if wconexao.EstabeleceConexaoDB then
       begin
         with wqueryInsert do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Insert into "Numerario" ("CodigoEmpresaNumerario","DescricaoNumerario","EhChequeNumerario","TipoNumerario","PercAcresDescNumerario",');
           SQL.Add('"TipoAcresDescNumerario","DiasPrazoNumerario","ImprimeDividaNumerario","IdentificaClienteNumerario","IdentificaCliente",');
           SQL.Add('"ImprimeTEFNumerario","TransacaoChequeNumerario","EhRedeCardNumerario","EhBanricomprasNumerario","EhTecBanNumerario","RestricaoNumerario",');
           SQL.Add('"SomaVendaNumerario","VendaAVistaNumerario","VendaAPrazoNumerario","GeraBonusFidelidadeNumerario","OrdemNumerario","ExigeLiberacaoNumerario",');
           SQL.Add('"CodigoPortadorNumerario","VisivelCaixaNumerario","GeraBonusPromocionalNumerario","GeraCreditoDevolucaoNumerario","GeraMovimentoBancarioNumerario") ');
           SQL.Add('values (:xidempresa,:xdescricao,:xehcheque,:xtipo,:xpercacrescdesc,');
           SQL.Add(':xtipoacrescdesc,:xdiasprazo,:ximprimedivida,:xidentificacliente,:xidentifica,');
           SQL.Add(':ximprimetef,:xtransacaocheque,:xehredecard,:xehbanricompras,:xehtecban,:xrestricao,');
           SQL.Add(':xsomavenda,:xvendaavista,:xvendaaprazo,:xgerabonusfidelidade,:xordem,:xexigeliberacao,');
           SQL.Add('(case when :xidportador>0 then :xidportador else null end),:xvisivelcaixa,:xgerabonuspromocional,:xgeracreditodevolucao,:xgeramovimentobancario) ');
           ParamByName('xidempresa').AsInteger   := wconexao.FIdEmpresaNumerario;
           ParamByName('xdescricao').AsString    := XNumerario.GetValue('descricao').Value;
           if XNumerario.TryGetValue('ehcheque',wval) then
              ParamByName('xehcheque').AsBoolean := strtobooldef(XNumerario.GetValue('ehcheque').Value,false)
           else
              ParamByName('xehcheque').AsBoolean := false;
           if XNumerario.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsString      := XNumerario.GetValue('tipo').Value
           else
              ParamByName('xtipo').AsString      := '';
           if XNumerario.TryGetValue('percacrescdesc',wval) then
              ParamByName('xpercacrescdesc').AsFloat := strtofloatdef(XNumerario.GetValue('percacrescdesc').Value,0)
           else
              ParamByName('xpercacrescdesc').AsFloat := 0;
           if XNumerario.TryGetValue('tipoacrescdesc',wval) then
              ParamByName('xtipoacrescdesc').AsString      := XNumerario.GetValue('tipoacrescdesc').Value
           else
              ParamByName('xtipoacrescdesc').AsString      := '';
           if XNumerario.TryGetValue('diasprazo',wval) then
              ParamByName('xdiasprazo').AsInteger := strtointdef(XNumerario.GetValue('diasprazo').Value,0)
           else
              ParamByName('xdiasprazo').AsInteger := 0;
           if XNumerario.TryGetValue('imprimedivida',wval) then
              ParamByName('ximprimedivida').AsBoolean := strtobooldef(XNumerario.GetValue('imprimedivida').Value,false)
           else
              ParamByName('ximprimedivida').AsBoolean := false;
           if XNumerario.TryGetValue('identificacliente',wval) then
              ParamByName('xidentificacliente').AsBoolean := strtobooldef(XNumerario.GetValue('identificacliente').Value,false)
           else
              ParamByName('xidentificacliente').AsBoolean := false;
           if XNumerario.TryGetValue('identifica',wval) then
              ParamByName('xidentifica').AsBoolean := strtobooldef(XNumerario.GetValue('identifica').Value,false)
           else
              ParamByName('xidentifica').AsBoolean := false;
           if XNumerario.TryGetValue('imprimetef',wval) then
              ParamByName('ximprimetef').AsBoolean := strtobooldef(XNumerario.GetValue('imprimetef').Value,false)
           else
              ParamByName('ximprimetef').AsBoolean := false;
           if XNumerario.TryGetValue('transacaocheque',wval) then
              ParamByName('xtransacaocheque').AsBoolean := strtobooldef(XNumerario.GetValue('transacaocheque').Value,false)
           else
              ParamByName('xtransacaocheque').AsBoolean := false;
           if XNumerario.TryGetValue('ehredecard',wval) then
              ParamByName('xehredecard').AsBoolean := strtobooldef(XNumerario.GetValue('ehredecard').Value,false)
           else
              ParamByName('xehredecard').AsBoolean := false;
           if XNumerario.TryGetValue('ehbanricompras',wval) then
              ParamByName('xehbanricompras').AsBoolean := strtobooldef(XNumerario.GetValue('ehbanricompras').Value,false)
           else
              ParamByName('xehbanricompras').AsBoolean := false;
           if XNumerario.TryGetValue('ehtecban',wval) then
              ParamByName('xehtecban').AsBoolean := strtobooldef(XNumerario.GetValue('ehtecban').Value,false)
           else
              ParamByName('xehtecban').AsBoolean := false;
           if XNumerario.TryGetValue('restricao',wval) then
              ParamByName('xrestricao').AsString      := XNumerario.GetValue('restricao').Value
           else
              ParamByName('xrestricao').AsString      := '';
           if XNumerario.TryGetValue('somavenda',wval) then
              ParamByName('xsomavenda').AsBoolean := strtobooldef(XNumerario.GetValue('somavenda').Value,false)
           else
              ParamByName('xsomavenda').AsBoolean := false;
           if XNumerario.TryGetValue('vendaavista',wval) then
              ParamByName('xvendaavista').AsBoolean := strtobooldef(XNumerario.GetValue('vendaavista').Value,false)
           else
              ParamByName('xvendaavista').AsBoolean := false;
           if XNumerario.TryGetValue('vendaaprazo',wval) then
              ParamByName('xvendaaprazo').AsBoolean := strtobooldef(XNumerario.GetValue('vendaaprazo').Value,false)
           else
              ParamByName('xvendaaprazo').AsBoolean := false;
           if XNumerario.TryGetValue('gerabonusfidelidade',wval) then
              ParamByName('xgerabonusfidelidade').AsBoolean := strtobooldef(XNumerario.GetValue('gerabonusfidelidade').Value,false)
           else
              ParamByName('xgerabonusfidelidade').AsBoolean := false;
           if XNumerario.TryGetValue('ordem',wval) then
              ParamByName('xordem').AsInteger := strtointdef(XNumerario.GetValue('ordem').Value,0)
           else
              ParamByName('xordem').AsInteger := 0;
           if XNumerario.TryGetValue('exigeliberacao',wval) then
              ParamByName('xexigeliberacao').AsBoolean := strtobooldef(XNumerario.GetValue('exigeliberacao').Value,false)
           else
              ParamByName('xexigeliberacao').AsBoolean := false;
           if XNumerario.TryGetValue('idportador',wval) then
              ParamByName('xidportador').AsInteger := strtointdef(XNumerario.GetValue('idportador').Value,0)
           else
              ParamByName('xidportador').AsInteger := 0;
           if XNumerario.TryGetValue('visivelcaixa',wval) then
              ParamByName('xvisivelcaixa').AsBoolean := strtobooldef(XNumerario.GetValue('visivelcaixa').Value,false)
           else
              ParamByName('xvisivelcaixa').AsBoolean := false;
           if XNumerario.TryGetValue('gerabonuspromocional',wval) then
              ParamByName('xgerabonuspromocional').AsBoolean := strtobooldef(XNumerario.GetValue('gerabonuspromocional').Value,false)
           else
              ParamByName('xgerabonuspromocional').AsBoolean := false;
           if XNumerario.TryGetValue('geracreditodevolucao',wval) then
              ParamByName('xgeracreditodevolucao').AsBoolean := strtobooldef(XNumerario.GetValue('geracreditodevolucao').Value,false)
           else
              ParamByName('xgeracreditodevolucao').AsBoolean := false;
           if XNumerario.TryGetValue('geramovimentobancario',wval) then
              ParamByName('xgeramovimentobancario').AsBoolean := strtobooldef(XNumerario.GetValue('geramovimentobancario').Value,false)
           else
              ParamByName('xgeramovimentobancario').AsBoolean := false;
           ExecSQL;
           EnableControls;
           wnum := RowsAffected;
         end;

         if wnum>0 then
            begin
              wquerySelect := TFDQuery.Create(nil);
              with wquerySelect do
              begin
                Connection := wconexao.FDConnectionApi;
                DisableControls;
                Close;
                SQL.Clear;
                Params.Clear;
                SQL.Add('select  "CodigoInternoNumerario"     as id,');
                SQL.Add('        "DescricaoNumerario"         as descricao,');
                SQL.Add('        "EhChequeNumerario"          as ehcheque,');
                SQL.Add('        "TipoNumerario"              as tipo,');
                SQL.Add('        "PercAcresDescNumerario"     as percacrescdesc,');
                SQL.Add('        "TipoAcresDescNumerario"     as tipoacrescdesc,');
                SQL.Add('        "DiasPrazoNumerario"         as diasprazo,');
                SQL.Add('        "ImprimeDividaNumerario"     as imprimedivida,');
                SQL.Add('        "IdentificaClienteNumerario" as identificacliente,');
                SQL.Add('        "IdentificaCliente"          as identifica,');
                SQL.Add('        "ImprimeTEFNumerario"        as imprimetef,');
                SQL.Add('        "TransacaoChequeNumerario"   as transacaocheque,');
                SQL.Add('        "EhRedeCardNumerario"        as ehredecard,');
                SQL.Add('        "EhBanricomprasNumerario"    as ehbanricompras,');
                SQL.Add('        "EhTecBanNumerario"          as ehtecban,');
                SQL.Add('        "RestricaoNumerario"         as restricao,');
                SQL.Add('        "SomaVendaNumerario"         as somavenda,');
                SQL.Add('        "VendaAVistaNumerario"       as vendaavista,');
                SQL.Add('        "VendaAPrazoNumerario"       as vendaaprazo,');
                SQL.Add('        "GeraBonusFidelidadeNumerario" as gerabonusfidelidade,');
                SQL.Add('        "OrdemNumerario"             as ordem,');
                SQL.Add('        "ExigeLiberacaoNumerario"    as exigeliberacao,');
                SQL.Add('        "CodigoPortadorNumerario"    as idportador,');
                SQL.Add('        "VisivelCaixaNumerario"      as visivelcaixa,');
                SQL.Add('        "GeraBonusPromocionalNumerario"  as gerabonuspromocional,');
                SQL.Add('        "GeraCreditoDevolucaoNumerario"  as geracreditodevolucao,');
                SQL.Add('        "GeraMovimentoBancarioNumerario" as geramovimentobancario ');
                SQL.Add('from "Numerario" where "CodigoEmpresaNumerario"=:xempresa and "DescricaoNumerario"=:xdescricao ');
                ParamByName('xempresa').AsInteger  := wconexao.FIdEmpresaNumerario;
                ParamByName('xdescricao').AsString := XNumerario.GetValue('descricao').Value;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Numerário incluído');
              wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
            end;
        end;
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := TJSONObject.Create;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao incluir nova Atividade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;


function AlteraNumerario(XIdNumerario: integer; XNumerario: TJSONObject): TJSONObject;
var wquery: TFDMemTable;
    wqueryUpdate,wquerySelect: TFDQuery;
    wret: TJSONObject;
    wconexao: TProviderDataModuleConexao;
    wcampos,wval: string;
    wnum: integer;
begin
  try
    wcampos      := '';
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryUpdate := TFDQuery.Create(nil);

    //define quais campos serão alterados
    if XNumerario.TryGetValue('descricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"DescricaoNumerario"=:xdescricao'
         else
            wcampos := wcampos+',"DescricaoNumerario"=:xdescricao';
       end;
    if XNumerario.TryGetValue('ehcheque',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhChequeNumerario"=:xehcheque'
         else
            wcampos := wcampos+',"EhChequeNumerario"=:xehcheque';
       end;
    if XNumerario.TryGetValue('tipo',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoNumerario"=:xtipo'
         else
            wcampos := wcampos+',"TipoNumerario"=:xtipo';
       end;
    if XNumerario.TryGetValue('percacrescdesc',wval) then
       begin
         if wcampos='' then
            wcampos := '"PercAcresDescNumerario"=:xpercacrescdesc'
         else
            wcampos := wcampos+',"PercAcresDescNumerario"=:xpercacrescdesc';
       end;
    if XNumerario.TryGetValue('tipoacrescdesc',wval) then
       begin
         if wcampos='' then
            wcampos := '"TipoAcresDescNumerario"=:xtipoacrescdesc'
         else
            wcampos := wcampos+',"TipoAcresDescNumerario"=:xtipoacrescdesc';
       end;
    if XNumerario.TryGetValue('diasprazo',wval) then
       begin
         if wcampos='' then
            wcampos := '"DiasPrazoNumerario"=:xdiasprazo'
         else
            wcampos := wcampos+',"DiasPrazoNumerario"=:xdiasprazo';
       end;
    if XNumerario.TryGetValue('imprimedivida',wval) then
       begin
         if wcampos='' then
            wcampos := '"ImprimeDividaNumerario"=:ximprimedivida'
         else
            wcampos := wcampos+',"ImprimeDividaNumerario"=:ximprimedivida';
       end;
    if XNumerario.TryGetValue('identificacliente',wval) then
       begin
         if wcampos='' then
            wcampos := '"IdentificaClienteNumerario"=:xidentificacliente'
         else
            wcampos := wcampos+',"IdentificaClienteNumerario"=:xidentificacliente';
       end;
    if XNumerario.TryGetValue('identifica',wval) then
       begin
         if wcampos='' then
            wcampos := '"IdentificaCliente"=:xidentifica'
         else
            wcampos := wcampos+',"IdentificaCliente"=:xidentifica';
       end;
    if XNumerario.TryGetValue('imprimetef',wval) then
       begin
         if wcampos='' then
            wcampos := '"ImprimeTEFNumerario"=:ximprimetef'
         else
            wcampos := wcampos+',"ImprimeTEFNumerario"=:ximprimetef';
       end;
    if XNumerario.TryGetValue('transacaocheque',wval) then
       begin
         if wcampos='' then
            wcampos := '"TransacaoChequeNumerario"=:xtransacaocheque'
         else
            wcampos := wcampos+',"TransacaoChequeNumerario"=:xtransacaocheque';
       end;
    if XNumerario.TryGetValue('ehredecard',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhRedeCardNumerario"=:xehredecard'
         else
            wcampos := wcampos+',"EhRedeCardNumerario"=:xehredecard';
       end;
    if XNumerario.TryGetValue('ehbanricompras',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhBanricomprasNumerario"=:xehbanricompras'
         else
            wcampos := wcampos+',"EhBanricomprasNumerario"=:xehbanricompras';
       end;
    if XNumerario.TryGetValue('ehtecban',wval) then
       begin
         if wcampos='' then
            wcampos := '"EhTecBanNumerario"=:xehtecban'
         else
            wcampos := wcampos+',"EhTecBanNumerario"=:xehtecban';
       end;
    if XNumerario.TryGetValue('restricao',wval) then
       begin
         if wcampos='' then
            wcampos := '"RestricaoNumerario"=:xrestricao'
         else
            wcampos := wcampos+',"RestricaoNumerario"=:xrestricao';
       end;
    if XNumerario.TryGetValue('somavenda',wval) then
       begin
         if wcampos='' then
            wcampos := '"SomaVendaNumerario"=:xsomavenda'
         else
            wcampos := wcampos+',"SomaVendaNumerario"=:xsomavenda';
       end;
    if XNumerario.TryGetValue('vendaavista',wval) then
       begin
         if wcampos='' then
            wcampos := '"VendaAVistaNumerario"=:xvendaavista'
         else
            wcampos := wcampos+',"VendaAVistaNumerario"=:xvendaavista';
       end;
    if XNumerario.TryGetValue('vendaaprazo',wval) then
       begin
         if wcampos='' then
            wcampos := '"VendaAPrazoNumerario"=:xvendaaprazo'
         else
            wcampos := wcampos+',"VendaAPrazoNumerario"=:xvendaaprazo';
       end;
    if XNumerario.TryGetValue('gerabonusfidelidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"GeraBonusFidelidadeNumerario"=:xgerabonusfidelidade'
         else
            wcampos := wcampos+',"GeraBonusFidelidadeNumerario"=:xgerabonusfidelidade';
       end;
    if XNumerario.TryGetValue('ordem',wval) then
       begin
         if wcampos='' then
            wcampos := '"OrdemNumerario"=:xordem'
         else
            wcampos := wcampos+',"OrdemNumerario"=:xordem';
       end;
    if XNumerario.TryGetValue('exigeliberacao',wval) then
       begin
         if wcampos='' then
            wcampos := '"ExigeLiberacaoNumerario"=:xexigeliberacao'
         else
            wcampos := wcampos+',"ExigeLiberacaoNumerario"=:xexigeliberacao';
       end;
    if XNumerario.TryGetValue('idportador',wval) then
       begin
         if wcampos='' then
            wcampos := '"CodigoPortadorNumerario"=:xidportador'
         else
            wcampos := wcampos+',"CodigoPortadorNumerario"=:xidportador';
       end;
    if XNumerario.TryGetValue('visivelcaixa',wval) then
       begin
         if wcampos='' then
            wcampos := '"VisivelCaixaNumerario"=:xvisivelcaixa'
         else
            wcampos := wcampos+',"VisivelCaixaNumerario"=:xvisivelcaixa';
       end;
    if XNumerario.TryGetValue('gerabonuspromocional',wval) then
       begin
         if wcampos='' then
            wcampos := '"GeraBonusPromocionalNumerario"=:xgerabonuspromocional'
         else
            wcampos := wcampos+',"GeraBonusPromocionalNumerario"=:xgerabonuspromocional';
       end;
    if XNumerario.TryGetValue('geracreditodevolucao',wval) then
       begin
         if wcampos='' then
            wcampos := '"GeraCreditoDevolucaoNumerario"=:xgeracreditodevolucao'
         else
            wcampos := wcampos+',"GeraCreditoDevolucaoNumerario"=:xgeracreditodevolucao';
       end;
    if XNumerario.TryGetValue('geramovimentobancario',wval) then
       begin
         if wcampos='' then
            wcampos := '"GeraMovimentoBancarioNumerario"=:xgeramovimentobancario'
         else
            wcampos := wcampos+',"GeraMovimentoBancarioNumerario"=:xgeramovimentobancario';
       end;
    if wconexao.EstabeleceConexaoDB then
       begin
         with wqueryUpdate do
         begin
           Connection := wconexao.FDConnectionApi;
           DisableControls;
           Close;
           SQL.Clear;
           Params.Clear;
           SQL.Add('Update "Numerario" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoNumerario"=:xid ');
           ParamByName('xid').AsInteger               := XIdNumerario;
           if XNumerario.TryGetValue('descricao',wval) then
              ParamByName('xdescricao').AsString      := XNumerario.GetValue('descricao').Value;
           if XNumerario.TryGetValue('ehcheque',wval) then
              ParamByName('xehcheque').AsBoolean      := strtobooldef(XNumerario.GetValue('ehcheque').Value,false);
           if XNumerario.TryGetValue('tipo',wval) then
              ParamByName('xtipo').AsString           := XNumerario.GetValue('tipo').Value;
           if XNumerario.TryGetValue('percacrescdesc',wval) then
              ParamByName('xpercacrescdesc').AsFloat  := strtofloatdef(XNumerario.GetValue('percacrescdesc').Value,0);
           if XNumerario.TryGetValue('tipoacrescdesc',wval) then
              ParamByName('xtipoacrescdesc').AsString := XNumerario.GetValue('tipoacrescdesc').Value;
           if XNumerario.TryGetValue('diasprazo',wval) then
              ParamByName('xdiasprazo').AsInteger     := strtointdef(XNumerario.GetValue('diasprazo').Value,0);
           if XNumerario.TryGetValue('imprimedivida',wval) then
              ParamByName('ximprimedivida').AsBoolean := strtobooldef(XNumerario.GetValue('imprimedivida').Value,false);
           if XNumerario.TryGetValue('identificacliente',wval) then
              ParamByName('xidentificacliente').AsBoolean := strtobooldef(XNumerario.GetValue('identificacliente').Value,false);
           if XNumerario.TryGetValue('identifica',wval) then
              ParamByName('xidentifica').AsBoolean    := strtobooldef(XNumerario.GetValue('identifica').Value,false);
           if XNumerario.TryGetValue('imprimetef',wval) then
              ParamByName('ximprimetef').AsBoolean    := strtobooldef(XNumerario.GetValue('imprimetef').Value,false);
           if XNumerario.TryGetValue('transacaocheque',wval) then
              ParamByName('xtransacaocheque').AsBoolean := strtobooldef(XNumerario.GetValue('transacaocheque').Value,false);
           if XNumerario.TryGetValue('ehredecard',wval) then
              ParamByName('xehredecard').AsBoolean      := strtobooldef(XNumerario.GetValue('ehredecard').Value,false);
           if XNumerario.TryGetValue('ehbanricompras',wval) then
              ParamByName('xehbanricompras').AsBoolean  := strtobooldef(XNumerario.GetValue('ehbanricompras').Value,false);
           if XNumerario.TryGetValue('ehtecban',wval) then
              ParamByName('xehtecban').AsBoolean      := strtobooldef(XNumerario.GetValue('ehtecban').Value,false);
           if XNumerario.TryGetValue('restricao',wval) then
              ParamByName('xrestricao').AsString      := XNumerario.GetValue('restricao').Value;
           if XNumerario.TryGetValue('somavenda',wval) then
              ParamByName('xsomavenda').AsBoolean     := strtobooldef(XNumerario.GetValue('somavenda').Value,false);
           if XNumerario.TryGetValue('vendaavista',wval) then
              ParamByName('xvendaavista').AsBoolean   := strtobooldef(XNumerario.GetValue('vendaavista').Value,false);
           if XNumerario.TryGetValue('vendaaprazo',wval) then
              ParamByName('xvendaaprazo').AsBoolean   := strtobooldef(XNumerario.GetValue('vendaaprazo').Value,false);
           if XNumerario.TryGetValue('gerabonusfidelidade',wval) then
              ParamByName('xgerabonusfidelidade').AsBoolean := strtobooldef(XNumerario.GetValue('gerabonusfidelidade').Value,false);
           if XNumerario.TryGetValue('ordem',wval) then
              ParamByName('xordem').AsInteger          := strtointdef(XNumerario.GetValue('ordem').Value,0);
           if XNumerario.TryGetValue('exigeliberacao',wval) then
              ParamByName('xexigeliberacao').AsBoolean := strtobooldef(XNumerario.GetValue('exigeliberacao').Value,false);
           if XNumerario.TryGetValue('idportador',wval) then
              ParamByName('xidportador').AsInteger     := strtointdef(XNumerario.GetValue('idportador').Value,0);
           if XNumerario.TryGetValue('visivelcaixa',wval) then
              ParamByName('xvisivelcaixa').AsBoolean   := strtobooldef(XNumerario.GetValue('visivelcaixa').Value,false);
           if XNumerario.TryGetValue('gerabonuspromocional',wval) then
              ParamByName('xgerabonuspromocional').AsBoolean := strtobooldef(XNumerario.GetValue('gerabonuspromocional').Value,false);
           if XNumerario.TryGetValue('geracreditodevolucao',wval) then
              ParamByName('xgeracreditodevolucao').AsBoolean := strtobooldef(XNumerario.GetValue('geracreditodevolucao').Value,false);
           if XNumerario.TryGetValue('geramovimentobancario',wval) then
              ParamByName('xgeramovimentobancario').AsBoolean := strtobooldef(XNumerario.GetValue('geramovimentobancario').Value,false);
           ExecSQL;
           EnableControls;
           wnum := RowsAffected;
         end;

         wquerySelect := TFDQuery.Create(nil);

         if wnum>0 then
            with wquerySelect do
            begin
              Connection := wconexao.FDConnectionApi;
              DisableControls;
              Close;
              SQL.Clear;
              Params.Clear;
              SQL.Add('select  "CodigoInternoNumerario"     as id,');
              SQL.Add('        "DescricaoNumerario"         as descricao,');
              SQL.Add('        "EhChequeNumerario"          as ehcheque,');
              SQL.Add('        "TipoNumerario"              as tipo,');
              SQL.Add('        "PercAcresDescNumerario"     as percacrescdesc,');
              SQL.Add('        "TipoAcresDescNumerario"     as tipoacrescdesc,');
              SQL.Add('        "DiasPrazoNumerario"         as diasprazo,');
              SQL.Add('        "ImprimeDividaNumerario"     as imprimedivida,');
              SQL.Add('        "IdentificaClienteNumerario" as identificacliente,');
              SQL.Add('        "IdentificaCliente"          as identifica,');
              SQL.Add('        "ImprimeTEFNumerario"        as imprimetef,');
              SQL.Add('        "TransacaoChequeNumerario"   as transacaocheque,');
              SQL.Add('        "EhRedeCardNumerario"        as ehredecard,');
              SQL.Add('        "EhBanricomprasNumerario"    as ehbanricompras,');
              SQL.Add('        "EhTecBanNumerario"          as ehtecban,');
              SQL.Add('        "RestricaoNumerario"         as restricao,');
              SQL.Add('        "SomaVendaNumerario"         as somavenda,');
              SQL.Add('        "VendaAVistaNumerario"       as vendaavista,');
              SQL.Add('        "VendaAPrazoNumerario"       as vendaaprazo,');
              SQL.Add('        "GeraBonusFidelidadeNumerario" as gerabonusfidelidade,');
              SQL.Add('        "OrdemNumerario"             as ordem,');
              SQL.Add('        "ExigeLiberacaoNumerario"    as exigeliberacao,');
              SQL.Add('        "CodigoPortadorNumerario"    as idportador,');
              SQL.Add('        "VisivelCaixaNumerario"      as visivelcaixa,');
              SQL.Add('        "GeraBonusPromocionalNumerario"  as gerabonuspromocional,');
              SQL.Add('        "GeraCreditoDevolucaoNumerario"  as geracreditodevolucao,');
              SQL.Add('        "GeraMovimentoBancarioNumerario" as geramovimentobancario ');
              SQL.Add('from "Numerario" ');
              SQL.Add('where "CodigoInternoNumerario" =:xid ');
              ParamByName('xid').AsInteger := XIdNumerario;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhum Numerário alterado');
              wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
            end;
       end;

    wret   := wquerySelect.ToJSONObject();
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret := TJSONObject.Create;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao alterar Atividade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
//  wquery.Free;
end;

function VerificaRequisicao(XNumerario: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
    if not XNumerario.TryGetValue('descricao',wval) then
       wret := false;
    if not XNumerario.TryGetValue('tipo',wval) then
       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaNumerario(XIdNumerario: integer): TJSONObject;
var wret: TJSONObject;
    wconexao: TProviderDataModuleConexao;
    wqueryDelete: TFDQuery;
    wnum: integer;
begin
  try
    wret         := TJSONObject.Create;
    wconexao     := TProviderDataModuleConexao.Create(nil);
    wqueryDelete := TFDQuery.Create(nil);

    if wconexao.EstabeleceConexaoDB then
       with wqueryDelete do
       begin
         Connection := wconexao.FDConnectionApi;
         DisableControls;
         Close;
         SQL.Clear;
         Params.Clear;
         SQL.Add('delete from "Numerario" where "CodigoInternoNumerario"=:xid ');
         ParamByName('xid').AsInteger := XIdNumerario;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Numerário excluído com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhum Numerário excluído');
       end;
    wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
  except
    On E: Exception do
    begin
      wconexao.EncerraConexaoDB;
      wret.AddPair('status','500');
      wret.AddPair('description',E.Message);
      wret.AddPair('datetime',formatdatetime('yyyy-mm-dd hh:nn:ss',now));
//      messagedlg('Problema ao excluir Atividade'+slinebreak+E.Message,mterror,[mbok],0);
    end;
  end;
  wconexao.EncerraConexaoDB;
  Result := wret;
end;
end.
