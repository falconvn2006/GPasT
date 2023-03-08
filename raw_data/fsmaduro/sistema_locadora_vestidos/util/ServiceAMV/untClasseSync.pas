unit untClasseSync;

interface

uses
  System.Classes, Windows, forms, ComCtrls, Dialogs,
  SysUtils, ExtCtrls, Data.DBXFirebird, Data.FMTBcd, Data.DB, Data.SqlExpr,
  CalDAV, StdCtrls, DBCtrls;

type
  TContasReminder = Record
    Metodo: Integer;
    Valor: Integer;
    Periodo: Integer;
  End;

type
  TContas = Record
    UserName: String;
    PassWord: String;
    Conectado: Boolean;
    _Reminder: TContasReminder;
    _Calendar: TCDCalendar;
  End;

type
  TConfig = Record
    TempoEspera: Integer;
    SincronizaAgendaPedido: Boolean;
    SincronizaAgendaProdutos: Boolean;
    SincronizaAgendaServicos: Boolean;
    Contas: Array of TContas;
  End;

type
  SyncAgenda = class(TThread)
  private
    _Form: Tform;
    _Qry: TSQLQuery;
    _Qry2: TSQLQuery;
    _Config: TConfig;
    _Label : TLabel;
    _Conta : String;
    _AddTime: Integer;
    iLetra: Integer;
    procedure SetName;
    procedure LoadConfig();
    function Conectar(iConta: Integer; UserName: String; PassWord: String): Boolean;
    Function AddEvent(iConta: Integer;
                       iTitulo: String;
                       iDiaTodo: Boolean;
                       iDataInicial: TDate;
                       iHoraInicial: TTime;
                       iDataFinal: TDate;
                       iHoraFinal: TTime;
                       iLocal: String;
                       iDescricao: String): Boolean;
    function NovoIDMASTER(): String;
    procedure AddStiruacao(Situacao: String);
    procedure CarregarAgendas(iWhere: String = '');
    procedure IncLetra();
    function ProximoSinc(iNow: TTime): TTime;
    Function xConnect(iConta: Integer) : Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean;
                       Form: Tform;
                       lblStatus : TLabel;
                       Qry: TSQLQuery;
                       Qry2: TSQLQuery;
                       Conta: String;
                       AddTime: Integer);
  end;

type
  TThreadNameInfo = record
    FType: LongWord;     // must be 0x1000
    FName: PChar;        // pointer to name (in user address space)
    FThreadID: LongWord; // thread ID (-1 indicates caller thread)
    FFlags: LongWord;    // reserved for future use, must be zero
  end;

implementation

uses untApplication;

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure SyncAgenda.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end;

    or

    Synchronize(
      procedure
      begin
        Form1.Caption := 'Updated in thread via an anonymous method'
      end
      )
    );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ SyncAgenda }

constructor SyncAgenda.Create(CreateSuspended: Boolean;
                       Form: TForm;
                       lblStatus : TLabel;
                       Qry: TSQLQuery;
                       Qry2: TSQLQuery;
                       Conta: String;
                       AddTime: Integer);
begin
  inherited Create (CreateSuspended);

  _Form := Form;
  _Label := lblStatus;
  _Qry := Qry;
  _Qry2 := Qry2;
  _Conta := Conta;
  _AddTime := AddTime;

  AddStiruacao('Iniciando Sincronismo');

  LoadConfig();

  SetName();

  FreeOnTerminate := false;
end;

procedure SyncAgenda.CarregarAgendas(iWhere: String = '');
begin
  try
    _Qry.Close;
    if not FileExists(ExtractFilePath(Application.ExeName)+'\SQLAgendas_'+_Conta+'.sql') then
       _Qry.sql.LoadFromFile(ExtractFilePath(Application.ExeName)+'\SQLAgendas.sql')
    else
       _Qry.sql.LoadFromFile(ExtractFilePath(Application.ExeName)+'\SQLAgendas_'+_Conta+'.sql');
    _Qry.SQL.Strings[_Qry.SQL.IndexOf('--where')+1] := iWhere;
    _Qry.Open;
  except
    raise;
  end;
end;

procedure SyncAgenda.AddStiruacao(Situacao: String);
begin
  _Label.Caption := Situacao;
  Application.ProcessMessages;
end;

function SyncAgenda.Conectar(iConta: Integer; UserName: String; PassWord: String): Boolean;
var
  I: Integer;
  bAchei: Boolean;
begin
  AddStiruacao('Conectando à '+UserName);
  Result := True;
  try

    _Config.Contas[iConta]._Calendar.LogFileName := '_AmvSyncCalendar_'+UserName+'_'+NovoIDMASTER+'.log';

    _Config.Contas[iConta]._Calendar.BaseURL := 'https://caldav.icloud.com';
    _Config.Contas[iConta]._Calendar.UserName := UserName;
    _Config.Contas[iConta]._Calendar.Password := PassWord;
    _Config.Contas[iConta]._Calendar.GetCalendars;

    bAchei := False;
    for I := 0 to _Config.Contas[iConta]._Calendar.Calendars.Count - 1 do
    begin
      if TCDCollection(_Config.Contas[iConta]._Calendar.Calendars[I]).Name = 'AMVSystem' then
      begin
        _Config.Contas[iConta]._Calendar.BaseURL := TCDCollection(_Config.Contas[iConta]._Calendar.Calendars[I]).URL;
        bAchei := True;
        break;
      end;
    end;

    if not bAchei then
    begin
      _Config.Contas[iConta]._Calendar.CreateVEVENTCalendar('AMVSystem');
      _Config.Contas[iConta]._Calendar.GetCalendars;
      for I := 0 to _Config.Contas[iConta]._Calendar.Calendars.Count - 1 do
      begin
        if TCDCollection(_Config.Contas[iConta]._Calendar.Calendars[I]).Name = 'AMVSystem' then
        begin
          _Config.Contas[iConta]._Calendar.BaseURL := TCDCollection(_Config.Contas[iConta]._Calendar.Calendars[I]).URL;
          break;
        end;
      end;
    end;
  except
    on e: exception do
    begin
      AddStiruacao('Falha ao conectar: '+E.Message);
      Result := False;
    end;
  end;

end;

procedure SyncAgenda.SetName;
var
  ThreadNameInfo: TThreadNameInfo;
begin
  ThreadNameInfo.FType := $1000;
  ThreadNameInfo.FName := 'AutoExecute';
  ThreadNameInfo.FThreadID := $FFFFFFFF;
  ThreadNameInfo.FFlags := 0;

  try
    RaiseException( $406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo );
  except
  end;
end;

procedure SyncAgenda.LoadConfig();
begin
  AddStiruacao('Carregando Configurações');
  //limpar configurações
  _Config.TempoEspera := 0;
  _Config.SincronizaAgendaPedido := False;
  _Config.SincronizaAgendaProdutos := False;
  _Config.SincronizaAgendaServicos := False;
  SetLength(_Config.Contas,0);

  _Qry2.Close;
  _Qry2.SQL.Text := 'Select * from TABCONFIGSINCRONISMO';
  _Qry2.Open;

  _Config.TempoEspera              := _Qry2.FieldByName('INTERVALO').AsInteger;
  _Config.SincronizaAgendaPedido   := _Qry2.FieldByName('AGENDASDEPEDIDOS').AsInteger = 1;
  _Config.SincronizaAgendaProdutos := _Qry2.FieldByName('AGENDASDEPRODUTOS').AsInteger = 1;
  _Config.SincronizaAgendaServicos := _Qry2.FieldByName('AGENDASDESERVICO').AsInteger = 1;

  AddStiruacao('Carregando Contas');
  _Qry2.Close;
  _Qry2.SQL.Text := 'Select * from TABCONTASSINCAGENDA where USERNAME = :USERNAME';
  _Qry2.ParamByName('USERNAME').AsString := _Conta;
  _Qry2.Open;

  while not _Qry2.Eof do
  begin
    AddStiruacao(_Qry2.FieldByName('USERNAME').AsString);
    SetLength(_Config.Contas,Length(_Config.Contas)+1);
    _Config.Contas[Length(_Config.Contas)-1].UserName := _Qry2.FieldByName('USERNAME').AsString;
    _Config.Contas[Length(_Config.Contas)-1].PassWord := _Qry2.FieldByName('SENHA').AsString;

    _Config.Contas[Length(_Config.Contas)-1]._Reminder.Metodo  := _Qry2.FieldByName('REMINDER_METODO').AsInteger;
    _Config.Contas[Length(_Config.Contas)-1]._Reminder.Valor   := _Qry2.FieldByName('REMINDER_VALOR').AsInteger;
    _Config.Contas[Length(_Config.Contas)-1]._Reminder.Periodo := _Qry2.FieldByName('REMINDER_PERIODO').AsInteger;

    if Assigned(_Config.Contas[Length(_Config.Contas)-1]._Calendar) then
      FreeAndNil(_Config.Contas[Length(_Config.Contas)-1]._Calendar);

    _Config.Contas[Length(_Config.Contas)-1]._Calendar := TCDCalendar.Create;

    _Config.Contas[Length(_Config.Contas)-1].Conectado :=
        Conectar(Length(_Config.Contas)-1,
                 _Qry2.FieldByName('USERNAME').AsString,
                 _Qry2.FieldByName('SENHA').AsString );
    _Qry2.Next;
  end;
end;

Function SyncAgenda.AddEvent(iConta: Integer;
                              iTitulo: String;
                              iDiaTodo: Boolean;
                              iDataInicial: TDate;
                              iHoraInicial: TTime;
                              iDataFinal: TDate;
                              iHoraFinal: TTime;
                              iLocal: String;
                              iDescricao: String): Boolean;
var
  TZID, vRepeatRule, vETagEd : String;
  Event: TCDEvent;
  Reminder: TCDReminder;
  TZCB: TStringList;
  I, TZCB_ItemIndex: INTEGER;
begin

  AddStiruacao('Adcionado Evento "'+iLocal+'" em '+ _Config.Contas[iConta].UserName);

  Result := True;
  try
    TZCB := TStringList.Create ;
    try
      Event := _Config.Contas[iConta]._Calendar.NewEvent;

      vRepeatRule := Event.RepeatRule;
      vETagEd     := Event.ETag;
      TZCB.AddObject(' None (Floating)', nil);
      TZCB.AddObject(' UTC', TBundledTimeZone.GetTimeZone('UTC'));
      for I := 0 to Length(TBundledTimeZone.KnownTimeZones(false)) - 1 do
      begin
        TZID := TBundledTimeZone.KnownTimeZones(false)[I];
        if Event.Calendar.TimeZoneAvailable(TZID) then
          TZCB.AddObject(TZID, TBundledTimeZone.GetTimeZone(TZID));
      end;
      if Event.StartTimeTZ <> nil then
        TZCB_ItemIndex := TZCB.IndexOfObject(Event.StartTimeTZ)
      else
        TZCB_ItemIndex := 0;

      Reminder := TCDReminder.Create(Event.Calendar);
      with Reminder do
      begin
        Method := TReminderMethod(_Config.Contas[iConta]._Reminder.Metodo);
        Period := TReminderPeriod(_Config.Contas[iConta]._Reminder.Periodo);
        PeriodsCount := _Config.Contas[iConta]._Reminder.Valor;
        Event.AddReminder(Reminder);
      end;

      Event.Title := iTitulo;
      Event.AllDay := iDiaTodo; // AllDay property must be set BEFORE StartTime and EndTime
      if not Event.AllDay then
      begin
        Event.StartTime := Trunc(iDataInicial) + Frac(iHoraInicial);
        Event.EndTime := Trunc(iDataFinal) + Frac(iHoraFinal);
      end
      else
      begin
        Event.StartTime := Trunc(iDataInicial);
        Event.EndTime := Trunc(iDataFinal);
      end;

      if TZCB_ItemIndex > 0 then
      begin
        Event.StartTimeTZ := TBundledTimeZone(TZCB.Objects[TZCB_ItemIndex]);
        Event.EndTimeTZ := TBundledTimeZone(TZCB.Objects[TZCB_ItemIndex]);
      end
      else
      begin
        Event.StartTimeTZ := nil;
        Event.EndTimeTZ := nil;
      end;

      Event.Location := iLocal;
      Event.Description := iDescricao;
      Event.RepeatRule := vRepeatRule;
      if Event.Calendar.IsiCloud then
        Event.Store;

    finally
      FreeAndNil(TZCB);
    end;
  except
    on e: exception do
    begin
      AddStiruacao('Falha ao Enviar: '+E.Message);
      Result := False;
    end;
  end;
end;

function SyncAgenda.NovoIDMASTER(): String;
Const Letras = 'abcdefghijklmnopqrstuvwxyz';
var
  xLetra: String;
begin
  xLetra := Letras[iLetra];
  Result := 'AMV' + FormatDateTime('ddMMyyyyhhmmss',now)+xLetra;
end;

procedure SyncAgenda.IncLetra();
begin
  inc(iLetra);
  if iLetra > 25 then
    iLetra := 0;
end;

function SyncAgenda.ProximoSinc(iNow: TTime): TTime;
var
  sTime: TTime;
  AddTime: TTime;
begin
  if _Config.TempoEspera < 10 then
    sTime := StrToTimeDef('00:0'+IntToStr(_Config.TempoEspera)+':00',0)
  else if _Config.TempoEspera >= 60 then
    sTime := StrToTimeDef('01:00:00',0)
  else
    sTime := StrToTimeDef('00:'+IntToStr(_Config.TempoEspera)+':00',0);

  if _AddTime < 10 then
    AddTime := StrToTimeDef('00:0'+IntToStr(_Config.TempoEspera)+':00',0)
  else if _AddTime >= 60 then
    AddTime := StrToTimeDef('01:00:00',0)
  else
    AddTime := StrToTimeDef('00:'+IntToStr(_Config.TempoEspera)+':00',0);

  result := iNow + sTime + AddTime;

end;

Function SyncAgenda.xConnect(iConta: Integer) : Boolean;
begin
  result := True;
//  result := Conectar(iConta,_Config.Contas[iConta].UserName, _Config.Contas[iConta].PassWord );
end;

procedure SyncAgenda.Execute;
var
  Bloco : integer;
  iTimeRefresh : tTime;
  I: INTEGER;
  xIDMASTER: String;
  bEventoAdcionado,
  bGravarEvento, xConected: Boolean;
  lTransaction: TTransactionDesc;
begin
  NameThreadForDebugging('trSyncAgenda');
  { Place thread code here }
  Bloco := 1;
  SetName;
  try
    iTimeRefresh := StrToTime('00:00:00');

    while (not Terminated) do
    begin
      Bloco := 2;

      if ((now >= ProximoSinc(iTimeRefresh)) or (TimeToStr(iTimeRefresh) = '00:00:00')) then
      begin
        AddStiruacao('Sincronizando...');
        Bloco := 3;
        //aqui sincroniza

        iLetra := 0;


          for I := 0 to LENGTH(_Config.Contas) - 1 do
          BEGIN

  //          xConected := xConnect(i);
  //          if not xConected then
  //            Continue;

            Bloco := 4;
            CarregarAgendas();

            while (not _Qry.Eof) and (not Terminated) do
            begin

              lTransaction.TransactionID := StrToInt(FormatDateTime('hhmmssss', now));
              lTransaction.GlobalID := StrToInt(FormatDateTime('hhmmssss', now));
              lTransaction.IsolationLevel := xilREADCOMMITTED;
              lTransaction.CustomIsolation := 99999;

              _Qry.SQLConnection.StartTransaction(lTransaction);
              try

                IncLetra();

                Bloco := 5;
                if _Qry.FieldByName('IDMASTER_SINC').AsString = '' then
                begin
                  xIDMASTER := NovoIDMASTER()  ;
                  _Qry2.Close;
                  _Qry2.SQL.Clear;
                  _Qry2.SQL.Text := 'update TABAGENDA set IDMASTER_SINC = :IDMASTER'+
                                    ' where CODIGO = :CODIGO';
                  _Qry2.ParamByName('IDMASTER').AsString := xIDMASTER;
                  _Qry2.ParamByName('CODIGO').AsInteger := _Qry.FieldByName('CODIGO').AsInteger;
                  _Qry2.ExecSQL();
                end
                else
                  xIDMASTER := _Qry.FieldByName('IDMASTER_SINC').AsString;

                bGravarEvento := True;

                Bloco := 6;
                _Qry2.Close;
                _Qry2.SQL.Clear;
                _Qry2.SQL.Text := 'Select sincronizado from TABCONTOLESINCAGENDA '+
                                  ' where USERNAME = :USERNAME'+
                                  ' and IDAGENDA = :IDAGENDA';
                _Qry2.ParamByName('USERNAME').AsString := _Config.Contas[i].UserName;
                _Qry2.ParamByName('IDAGENDA').AsInteger := _Qry.FieldByName('CODIGO').AsInteger;
                _Qry2.Open;

                Bloco := 7;
                if _Qry2.FieldByName('sincronizado').AsInteger = 1 then
                begin
                  _Qry.Next;
                  Continue;
                end;

                Bloco := 8;
                bEventoAdcionado :=
                  AddEvent(I,
                           _Qry.FieldByName('NOMEPERFIL').AsString,
                           False,
                           _Qry.FieldByName('DATAINICIO').AsDateTime,
                           _Qry.FieldByName('HORAINICIO').AsDateTime,
                           _Qry.FieldByName('DATAFIM').AsDateTime,
                           _Qry.FieldByName('HORAFIM').AsDateTime,
                           'CÓDIGO: '+IntToStr(_Qry.FieldByName('CODIGO').AsInteger)+' IDMASTER: '+xIDMASTER+'',
                           _Qry.FieldByName('DESCRICAO').AsString);

                Bloco := 9;
                if not bEventoAdcionado then
                  bGravarEvento := False
                else
                begin
                  _Qry2.Close;
                  _Qry2.SQL.Clear;
                  _Qry2.SQL.Text := 'update TABCONTOLESINCAGENDA set sincronizado = 1 '+
                                    ' where USERNAME = :USERNAME'+
                                    ' and IDAGENDA = :IDAGENDA';
                  _Qry2.ParamByName('USERNAME').AsString := _Config.Contas[i].UserName;
                  _Qry2.ParamByName('IDAGENDA').AsInteger := _Qry.FieldByName('CODIGO').AsInteger;
                  _Qry2.ExecSQL();
                end;

                if bGravarEvento then
                begin
      //            _Qry2.SQL.Text := 'update TABAGENDA set IDMASTER_SINC = '+QuotedStr(xIDMASTER)+
      //                              ', SINCRONIZADA = 1, DATA_SINC = :DATA_SINC, HORA_SINC = :HORA_SINC '+
      //                              ' where CODIGO = '+IntToStr(_Qry.FieldByName('CODIGO').AsInteger);
      //            _Qry2.ParamByName('DATA_SINC').AsDateTime := Now;
      //            _Qry2.ParamByName('HORA_SINC').AsDateTime := Now;
      //            _Qry2.ExecSQL();
      //            _Qry2.SQLConnection.Commit(nil);
                end;
              finally
                _Qry.SQLConnection.Commit(lTransaction);
              end;

              _Qry.Next;
            end;
          END;

        iTimeRefresh := now;

        AddStiruacao('Próximo Sincronismo às '+FormatDateTime('hh:mm:ss',ProximoSinc(iTimeRefresh)));
      end;
    end;
  except
    on E: Exception do
    begin
      AddStiruacao('Erro no Sincronismo: Bloco '+IntToStr(Bloco)+'  '+E.Message+#13#13#13+_Qry2.SQL.Text);
      self.Terminate;
    end;
  end;;
end;

end.
