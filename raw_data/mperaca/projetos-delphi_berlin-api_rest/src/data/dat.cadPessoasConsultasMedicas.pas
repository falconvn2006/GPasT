unit dat.cadPessoasConsultasMedicas;

interface

uses Vcl.Dialogs, System.UITypes, System.JSON, DataSet.Serialize, FireDAC.Stan.Param,
     System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
     FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
     Data.DB, FireDAC.Comp.Client, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.DApt,
  System.Generics.Collections;


function RetornaConsulta(XId: integer): TJSONObject;
function RetornaListaConsultas(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
function IncluiConsulta(XConsulta: TJSONObject; XIdPessoa: integer): TJSONObject;
function AlteraConsulta(XIdConsulta: integer; XConsulta: TJSONObject): TJSONObject;
function ApagaConsulta(XIdConsulta: integer): TJSONObject;
function VerificaRequisicao(XConsulta: TJSONObject): boolean;

implementation

uses prv.dataModuleConexao;

function RetornaConsulta(XId: integer): TJSONObject;
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
         SQL.Add('select "CodigoInternoConsultas"         as id,');
         SQL.Add('       "CodigoLinkPessoasConsultas"     as idpessoa,');
         SQL.Add('       "NumeroConsultasMesConsultas"    as numeromes,');
         SQL.Add('       "NumeroConsultasSemanaConsultas" as numerosemana,');
         SQL.Add('       "NumeroConsultasDiaT1Consultas"  as numerodiat1,');
         SQL.Add('       "NumeroConsultasDiaT2Consultas"  as numerodiat2,');
         SQL.Add('       "NumeroConsultasDiaT3Consultas"  as numerodiat3,');
         SQL.Add('       "HorarioInicialTurno1Consultas"  as horainicialt1,');
         SQL.Add('       "HorarioInicialTurno2Consultas"  as horainicialt2,');
         SQL.Add('       "HorarioInicialTurno3Consultas"  as horainicialt3,');
         SQL.Add('       "HorarioFinalTurno1Consultas"    as horafinalt1,');
         SQL.Add('       "HorarioFinalTurno2Consultas"    as horafinalt2,');
         SQL.Add('       "HorarioFinalTurno3Consultas"    as horafinalt3,');
         SQL.Add('       "PeriodicidadeConsultas"         as periodicidade ');
         SQL.Add('from "PessoaConsultasMedicas" ');
         SQL.Add('where "CodigoInternoConsultas"=:xid ');
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
        wret.AddPair('description','Nenhuma Consulta encontrada');
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

function RetornaListaConsultas(const XQuery: TDictionary<string, string>; XIdPessoa: integer): TJSONArray;
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
         SQL.Add('select "CodigoInternoConsultas"         as id,');
         SQL.Add('       "CodigoLinkPessoasConsultas"     as idpessoa,');
         SQL.Add('       "NumeroConsultasMesConsultas"    as numeromes,');
         SQL.Add('       "NumeroConsultasSemanaConsultas" as numerosemana,');
         SQL.Add('       "NumeroConsultasDiaT1Consultas"  as numerodiat1,');
         SQL.Add('       "NumeroConsultasDiaT2Consultas"  as numerodiat2,');
         SQL.Add('       "NumeroConsultasDiaT3Consultas"  as numerodiat3,');
         SQL.Add('       "HorarioInicialTurno1Consultas"  as horainicialt1,');
         SQL.Add('       "HorarioInicialTurno2Consultas"  as horainicialt2,');
         SQL.Add('       "HorarioInicialTurno3Consultas"  as horainicialt3,');
         SQL.Add('       "HorarioFinalTurno1Consultas"    as horafinalt1,');
         SQL.Add('       "HorarioFinalTurno2Consultas"    as horafinalt2,');
         SQL.Add('       "HorarioFinalTurno3Consultas"    as horafinalt3,');
         SQL.Add('       "PeriodicidadeConsultas"         as periodicidade ');
         SQL.Add('from "PessoaConsultasMedicas" where "CodigoLinkPessoasConsultas"=:xidpessoa ');
         ParamByName('xidpessoa').AsInteger := XIdPessoa;;
         Open;
         EnableControls;
       end;
    if wqueryLista.RecordCount>0 then
       wret := wqueryLista.ToJSONArray()
    else
       begin
         wobj := TJSONObject.Create;
         wobj.AddPair('status','500');
         wobj.AddPair('description','Nenhuma Consulta encontrada');
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

function IncluiConsulta(XConsulta: TJSONObject; XIdPessoa: integer): TJSONObject;
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
           SQL.Add('Insert into "PessoaConsultasMedicas" ("CodigoLinkPessoasConsultas","NumeroConsultasMesConsultas","NumeroConsultasSemanaConsultas",');
           SQL.Add('"NumeroConsultasDiaT1Consultas","NumeroConsultasDiaT2Consultas","NumeroConsultasDiaT3Consultas","HorarioInicialTurno1Consultas",');
           SQL.Add('"HorarioInicialTurno2Consultas","HorarioInicialTurno3Consultas","HorarioFinalTurno1Consultas","HorarioFinalTurno2Consultas",');
           SQL.Add('"HorarioFinalTurno3Consultas","PeriodicidadeConsultas") ');
           SQL.Add('values (:xidpessoa,:xnumeromes,:xnumerosemana,');
           SQL.Add(':xnumerodiat1,:xnumerodiat2,:xnumerodiat3,:xhorainicialt1,');
           SQL.Add(':xhorainicialt2,:xhorainicialt3,:xhorafinalt1,:xhorafinalt2,');
           SQL.Add(':xhorafinalt3,:xperiodicidade) ');
           ParamByName('xidpessoa').AsInteger   := XIdPessoa;
           if XConsulta.TryGetValue('numeromes',wval) then
              ParamByName('xnumeromes').AsInteger := strtointdef(XConsulta.GetValue('numeromes').Value,0)
           else
              ParamByName('xnumeromes').AsInteger := 0;
           if XConsulta.TryGetValue('numerosemana',wval) then
              ParamByName('xnumerosemana').AsInteger := strtointdef(XConsulta.GetValue('numerosemana').Value,0)
           else
              ParamByName('xnumerosemana').AsInteger := 0;
           if XConsulta.TryGetValue('numerodiat1',wval) then
              ParamByName('xnumerodiat1').AsInteger := strtointdef(XConsulta.GetValue('numerodiat1').Value,0)
           else
              ParamByName('xnumerodiat1').AsInteger := 0;
           if XConsulta.TryGetValue('numerodiat2',wval) then
              ParamByName('xnumerodiat2').AsInteger := strtointdef(XConsulta.GetValue('numerodiat2').Value,0)
           else
              ParamByName('xnumerodiat2').AsInteger := 0;
           if XConsulta.TryGetValue('numerodiat3',wval) then
              ParamByName('xnumerodiat3').AsInteger := strtointdef(XConsulta.GetValue('numerodiat3').Value,0)
           else
              ParamByName('xnumerodiat3').AsInteger := 0;
           if XConsulta.TryGetValue('horainicialt1',wval) then
              ParamByName('xhorainicialt1').AsString := XConsulta.GetValue('horainicialt1').Value
           else
              ParamByName('xhorainicialt1').AsString := '';
           if XConsulta.TryGetValue('horainicialt2',wval) then
              ParamByName('xhorainicialt2').AsString := XConsulta.GetValue('horainicialt2').Value
           else
              ParamByName('xhorainicialt2').AsString := '';
           if XConsulta.TryGetValue('horainicialt3',wval) then
              ParamByName('xhorainicialt3').AsString := XConsulta.GetValue('horainicialt3').Value
           else
              ParamByName('xhorainicialt3').AsString := '';
           if XConsulta.TryGetValue('horafinalt1',wval) then
              ParamByName('xhorafinalt1').AsString := XConsulta.GetValue('horafinalt1').Value
           else
              ParamByName('xhorafinalt1').AsString := '';
           if XConsulta.TryGetValue('horafinalt2',wval) then
              ParamByName('xhorafinalt2').AsString := XConsulta.GetValue('horafinalt2').Value
           else
              ParamByName('xhorafinalt2').AsString := '';
           if XConsulta.TryGetValue('horafinalt3',wval) then
              ParamByName('xhorafinalt3').AsString := XConsulta.GetValue('horafinalt3').Value
           else
              ParamByName('xhorafinalt3').AsString := '';
           if XConsulta.TryGetValue('periodicidade',wval) then
              ParamByName('xperiodicidade').AsString := XConsulta.GetValue('periodicidade').Value
           else
              ParamByName('xperiodicidade').AsString := '';
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
                SQL.Add('select "CodigoInternoConsultas"         as id,');
                SQL.Add('       "CodigoLinkPessoasConsultas"     as idpessoa,');
                SQL.Add('       "NumeroConsultasMesConsultas"    as numeromes,');
                SQL.Add('       "NumeroConsultasSemanaConsultas" as numerosemana,');
                SQL.Add('       "NumeroConsultasDiaT1Consultas"  as numerodiat1,');
                SQL.Add('       "NumeroConsultasDiaT2Consultas"  as numerodiat2,');
                SQL.Add('       "NumeroConsultasDiaT3Consultas"  as numerodiat3,');
                SQL.Add('       "HorarioInicialTurno1Consultas"  as horainicialt1,');
                SQL.Add('       "HorarioInicialTurno2Consultas"  as horainicialt2,');
                SQL.Add('       "HorarioInicialTurno3Consultas"  as horainicialt3,');
                SQL.Add('       "HorarioFinalTurno1Consultas"    as horafinalt1,');
                SQL.Add('       "HorarioFinalTurno2Consultas"    as horafinalt2,');
                SQL.Add('       "HorarioFinalTurno3Consultas"    as horafinalt3,');
                SQL.Add('       "PeriodicidadeConsultas"         as periodicidade ');
                SQL.Add('from "PessoaConsultasMedicas" where "CodigoLinkPessoasConsultas"=:xidpessoa ');
                ParamByName('xidpessoa').AsInteger  := XIdPessoa;
                Open;
                EnableControls;
              end;
              wret := wquerySelect.ToJSONObject();
            end
         else
            begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Consulta incluída');
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


function AlteraConsulta(XIdConsulta: integer; XConsulta: TJSONObject): TJSONObject;
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
    if XConsulta.TryGetValue('numeromes',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroConsultasMesConsultas"=:xnumeromes'
         else
            wcampos := wcampos+',"NumerosConsultasMesConsultas"=:xnumeromes';
       end;
    if XConsulta.TryGetValue('numerosemana',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroConsultasSemanaConsultas"=:xnumerosemana'
         else
            wcampos := wcampos+',"NumerosConsultasSemanaConsultas"=:xnumerosemana';
       end;
    if XConsulta.TryGetValue('numerodiat1',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroConsultasDiaT1Consultas"=:xnumerodiat1'
         else
            wcampos := wcampos+',"NumerosConsultasDiaT1Consultas"=:xnumerodiat1';
       end;
    if XConsulta.TryGetValue('numerodiat2',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroConsultasDiaT2Consultas"=:xnumerodiat2'
         else
            wcampos := wcampos+',"NumerosConsultasDiaT2Consultas"=:xnumerodiat2';
       end;
    if XConsulta.TryGetValue('numerodiat3',wval) then
       begin
         if wcampos='' then
            wcampos := '"NumeroConsultasDiaT3Consultas"=:xnumerodiat3'
         else
            wcampos := wcampos+',"NumerosConsultasDiaT3Consultas"=:xnumerodiat3';
       end;
    if XConsulta.TryGetValue('horainicialt1',wval) then
       begin
         if wcampos='' then
            wcampos := '"HorarioInicialT1Consultas"=:xhorainicialt1'
         else
            wcampos := wcampos+',"HorarioInicialT1Consultas"=:xhorainicialt1';
       end;
    if XConsulta.TryGetValue('horainicialt2',wval) then
       begin
         if wcampos='' then
            wcampos := '"HorarioInicialT2Consultas"=:xhorainicialt2'
         else
            wcampos := wcampos+',"HorarioInicialT2Consultas"=:xhorainicialt2';
       end;
    if XConsulta.TryGetValue('horainicialt3',wval) then
       begin
         if wcampos='' then
            wcampos := '"HorarioInicialT3Consultas"=:xhorainicialt3'
         else
            wcampos := wcampos+',"HorarioInicialT3Consultas"=:xhorainicialt3';
       end;
    if XConsulta.TryGetValue('horafinalt1',wval) then
       begin
         if wcampos='' then
            wcampos := '"HorarioFinalT1Consultas"=:xhorafinalt1'
         else
            wcampos := wcampos+',"HorarioFinalT1Consultas"=:xhorafinalt1';
       end;
    if XConsulta.TryGetValue('horafinalt2',wval) then
       begin
         if wcampos='' then
            wcampos := '"HorarioFinalT2Consultas"=:xhorafinalt2'
         else
            wcampos := wcampos+',"HorarioFinalT2Consultas"=:xhorafinalt2';
       end;
    if XConsulta.TryGetValue('horafinalt3',wval) then
       begin
         if wcampos='' then
            wcampos := '"HorarioFinalT3Consultas"=:xhorafinalt3'
         else
            wcampos := wcampos+',"HorarioFinalT3Consultas"=:xhorafinalt3';
       end;
    if XConsulta.TryGetValue('periodicidade',wval) then
       begin
         if wcampos='' then
            wcampos := '"PeriodicidadeConsultas"=:xperiodicidade'
         else
            wcampos := wcampos+',"PeriodicidadeConsultas"=:xperiodicidade';
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
           SQL.Add('Update "PessoaConsultasMedicas" set '+wcampos+' ');
           SQL.Add('where "CodigoInternoConsultas"=:xid ');
           ParamByName('xid').AsInteger             := XIdConsulta;
           if XConsulta.TryGetValue('numeromes',wval) then
              ParamByName('xnumeromes').AsInteger   := strtointdef(XConsulta.GetValue('numeromes').Value,0);
           if XConsulta.TryGetValue('numerosemana',wval) then
              ParamByName('xnumerosemana').AsInteger   := strtointdef(XConsulta.GetValue('numerosemana').Value,0);
           if XConsulta.TryGetValue('numerodiat1',wval) then
              ParamByName('xnumerodiat1').AsInteger   := strtointdef(XConsulta.GetValue('numerodiat1').Value,0);
           if XConsulta.TryGetValue('numerodiat2',wval) then
              ParamByName('xnumerodiat2').AsInteger   := strtointdef(XConsulta.GetValue('numerodiat2').Value,0);
           if XConsulta.TryGetValue('numerodiat3',wval) then
              ParamByName('xnumerodiat3').AsInteger   := strtointdef(XConsulta.GetValue('numerodiat3').Value,0);
           if XConsulta.TryGetValue('horainicialt1',wval) then
              ParamByName('xhorainicialt1').AsString  := XConsulta.GetValue('horainicialt1').Value;
           if XConsulta.TryGetValue('horainicialt2',wval) then
              ParamByName('xhorainicialt2').AsString  := XConsulta.GetValue('horainicialt2').Value;
           if XConsulta.TryGetValue('horainicialt3',wval) then
              ParamByName('xhorainicialt3').AsString  := XConsulta.GetValue('horainicialt3').Value;
           if XConsulta.TryGetValue('horafinalt1',wval) then
              ParamByName('xhorafinalt1').AsString    := XConsulta.GetValue('horafinalt1').Value;
           if XConsulta.TryGetValue('horafinalt2',wval) then
              ParamByName('xhorafinalt2').AsString    := XConsulta.GetValue('horafinalt2').Value;
           if XConsulta.TryGetValue('horafinalt3',wval) then
              ParamByName('xhorafinalt3').AsString    := XConsulta.GetValue('horafinalt3').Value;
           if XConsulta.TryGetValue('periodicidade',wval) then
              ParamByName('xperiodicidade').AsString  := XConsulta.GetValue('periodicidade').Value;
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
              SQL.Add('select "CodigoInternoConsultas"         as id,');
              SQL.Add('       "CodigoLinkPessoasConsultas"     as idpessoa,');
              SQL.Add('       "NumeroConsultasMesConsultas"    as numeromes,');
              SQL.Add('       "NumeroConsultasSemanaConsultas" as numerosemana,');
              SQL.Add('       "NumeroConsultasDiaT1Consultas"  as numerodiat1,');
              SQL.Add('       "NumeroConsultasDiaT2Consultas"  as numerodiat2,');
              SQL.Add('       "NumeroConsultasDiaT3Consultas"  as numerodiat3,');
              SQL.Add('       "HorarioInicialTurno1Consultas"  as horainicialt1,');
              SQL.Add('       "HorarioInicialTurno2Consultas"  as horainicialt2,');
              SQL.Add('       "HorarioInicialTurno3Consultas"  as horainicialt3,');
              SQL.Add('       "HorarioFinalTurno1Consultas"    as horafinalt1,');
              SQL.Add('       "HorarioFinalTurno2Consultas"    as horafinalt2,');
              SQL.Add('       "HorarioFinalTurno3Consultas"    as horafinalt3,');
              SQL.Add('       "PeriodicidadeConsultas"         as periodicidade ');
              SQL.Add('from "PessoaConsultasMedicas" ');
              SQL.Add('where "CodigoInternoConsultas" =:xid ');
              ParamByName('xid').AsInteger := XIdConsulta;
              Open;
              EnableControls;
            end
         else
           begin
              wret := TJSONObject.Create;
              wret.AddPair('status','500');
              wret.AddPair('description','Nenhuma Consulta alterada');
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

function VerificaRequisicao(XConsulta: TJSONObject): boolean;
var wret: boolean;
    wval: string;
begin
  try
    wret := true;
//    if not XCNAE.TryGetValue('data',wval) then
//       wret := false;
  finally
  end;
  Result := wret;
end;

function ApagaConsulta(XIdConsulta: integer): TJSONObject;
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
         SQL.Add('delete from "PessoaConsultasMedicas" where "CodigoInternoConsultas"=:xid ');
         ParamByName('xid').AsInteger := XIdConsulta;
         ExecSQL;
         EnableControls;
         wnum := RowsAffected;
       end
    else
       wnum := 0;

    if wnum>0 then
       begin
         wret.AddPair('status','200');
         wret.AddPair('description','Consulta excluída com sucesso');
       end
    else
       begin
         wret.AddPair('status','500');
         wret.AddPair('description','Nenhuma Consulta excluída');
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
