unit MCIData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, ADODB, Math;

const
        DBSetupFileName     ='.\!DBSETUP.txt';
//        DBSetupFileName     ='.\!ADOSETUP.txt';
        INTER_ALIAS_NAME    ='MIR_RES';
type
  TRES_DATAS = class(TDataModule)
    LeftDataSource  : TDataSource;
    RightDataSource : TDataSource;
    MagicDataSource: TDataSource;
    ItemDataSource: TDataSource;
    LeftTable: TADOTable;
    RightTable: TADOTable;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    ItemTable: TADOTable;
    MagicTable: TADOTable;
    MobItemQuery: TADOQuery;
    MobItemSource: TDataSource;
    procedure LeftTableAfterPost(DataSet: TDataSet);
    procedure LeftTableBeforeInsert(DataSet: TDataSet);
    procedure RightTableBeforeInsert(DataSet: TDataSet);
    procedure ItemTableBeforeInsert(DataSet: TDataSet);
    procedure MagicTableBeforeInsert(DataSet: TDataSet);
  private
    { Private declarations }
    FRightLock      : Boolean;
    FLeftLock       : Boolean;
    FConneted       : Boolean;
    FDatabaseInfo   : string;
    FItemGoldName   : string;

    procedure SetInfo( Params : TStrings );
    procedure AddAlias( AliasName : String ; Params : TStrings );

  public
    { Public declarations }
    constructor Create;
    destructor  Destroy; override;

    procedure Connect;
    procedure DisConnect;
    function  GetInfo: String;
    procedure LoadItemNameList( ItemList : TStrings);

    property Connected  : Boolean read FConneted;

    function  DecodeStringPassword( var src: string; key: integer ): string;

  end;

var
  RES_DATAS: TRES_DATAS;

implementation

{$R *.DFM}
constructor TRES_DATAS.Create;
begin

    FLeftLock   := true;
    FRightLock  := true;

    FItemGoldName := '';
end;

destructor TRES_DATAS.Destroy;
begin
    // TODO : Cloase Database

    inherited;
end;

procedure TRES_DATAS.AddAlias( AliasName : String ; Params : TStrings );
var
    sAliasList  : TStringList;
    AliasParam  : TStringList;
begin
    sAliasList := TStringList.Create;

    Session.ConfigMode := cmPersistent;
    Session.GetAliasNames(sAliasList);

    if sAliasList.IndexOf(AliasName) > -1 then
    begin
//        Session.DeleteAlias(AliasName);
//        Session.SaveConfigFile;
    end
    else
    begin

        AliasParam := TStringList.Create;

        AliasParam.Add('SERVER NAME='   +Params.Values['SERVER NAME']);
        AliasParam.Add('DATABASE NAME=' +Params.Values['DATABASE NAME']);
        AliasParam.Add('USER NAME='     +Params.Values['USER NAME']);
        AliasParam.Add('PASSWORD='      +Params.Values['PASSWORD']);
        AliasParam.Add('LANGDRIVER='    +Params.Values['LANGDRIVER']);

        Session.AddAlias(AliasName, 'MSSQL', AliasParam);
        Session.SaveConfigFile;

        AliasParam.Free;

    end;

    sAliasList.Free;

end;

procedure TRES_DATAS.Connect;
var
   Params   : TStringList;
   Pwd, EncodedPwd : string;
begin
   if FileExists( DBSetupFileName ) then begin

      with ADOConnection1 do begin
         // ������ ���̽� ����
         if not ADOConnection1.Connected then begin

            // Load DB Connection Infos
            Params := TStringList.Create;
            Params.LoadFromFile( DBSetupFileName );


            //ConnectionString := Params.Values['CONNECT_INFO'];

            Pwd := Params.Values['PASSWORD'];
            //----------------------------
            //��й�ȣ ��ȣȭ
            EncodedPwd := DecodeStringPassword( Pwd, $16 );
            if EncodedPwd <> '' then begin
                Params.Strings[Params.IndexOfName('PASSWORD')] := 'PASSWORD=' + EncodedPwd;
                Params.SaveToFile( DBSetupFileName );
            end;
            //----------------------------

            // ADO Connection Info
            ConnectionString :=
                'Provider=SQLOLEDB.1;Password='         + Pwd +
                ';Persist Security Info=True;User ID='  + Params.Values['USER NAME'] +
                ';Initial Catalog='                     + Params.Values['DATABASE NAME'] +
                ';Data Source='                         + Params.Values['SERVER NAME'] ;

            // AddAlias ( INTER_ALIAS_NAME , Params );

//            SetInfo( Params );

//            Database.AliasName    := Params.Values['ALIAS NAME'];
//            DatabaseName          := 'InterDatabase';

            LoginPrompt := False;
            Connected   := true;

         end;

         // ���̺� ����
         if ADOConnection1.Connected then begin
            LeftTable.TableName     := Params.Values['TABLE_MOBITEM'];
            LeftTable.active        := true;

            RightTable.TableName    := Params.Values['TABLE_MONSTER'];
            RightTable.active       := true;

            ItemTable.TableName     := Params.Values['TABLE_STDITEMS'];
            ItemTable.Active        := true;

            MagicTable.TableName    := Params.Values['TABLE_MAGIC'];
            Magictable.Active       := true;
         end;

         FItemGoldName := Params.Values['GOLDNAME'];

         Params.Free;
      end;


   end;// FileExists...

end;

procedure TRES_DATAS.Disconnect;
begin
    LeftTable.active    := false;
    Righttable.active   := false;
    ADOConnection1.Connected  := false;
end;

function TRES_DATAS.GetInfo: String;
begin
    Result := FDataBaseInfo;
end;

procedure TRES_DATAS.SetInfo( Params : TStrings );
begin
    FDataBaseInfo :=
        'SERVER:'+ Params.Values['SERVER NAME'] + ' / ' +
        'DB:'+ Params.Values['DATABASE NAME']   + ' / ' +
        'USER:'+ Params.Values['USER NAME'];
end;

procedure TRES_DATAS.LoadItemNameList( ItemList : TStrings);
var
    i   :integer;
begin
    if FItemGoldName = '' then
    begin
    Application.MessageBox('Check GOLDNAME in the !DBSETUP.TXT','ERROR !', MB_OK + MB_ICONWARNING);
    Exit;
    end;

    with ADOQuery1 do
    begin
        Active := true;

        ItemList.Clear;

        // ���ӳ� ��ü ������ ������ ��
        ItemList.add( FItemGoldName );

        First;
        for i := 0 to RecordCount - 1 do
        begin
            ItemList.add( Fields[0].AsString );
            Next;
        end;

        Active := false;
    end;

end;

procedure TRES_DATAS.LeftTableAfterPost(DataSet: TDataSet);
begin
    DataSet.Refresh;
end;

procedure TRES_DATAS.LeftTableBeforeInsert(DataSet: TDataSet);
begin
    DataSet.Last;
end;

procedure TRES_DATAS.RightTableBeforeInsert(DataSet: TDataSet);
begin
    DataSet.Last;
end;

procedure TRES_DATAS.ItemTableBeforeInsert(DataSet: TDataSet);
begin
    DataSet.Last;
end;

procedure TRES_DATAS.MagicTableBeforeInsert(DataSet: TDataSet);
begin
    DataSet.Last;
end;

function  TRES_DATAS.DecodeStringPassword( var src: string; key: integer ): string;
var
   i, temp: integer;
   tempstr, EncodedPwd : string;
begin
    Result := '';

    tempstr := Copy( UPPERCASE(src), 1, MIN(7, Length(src)) );
    if tempstr = 'ENCODE_' then begin
        src := Copy( src, 8, Length(src) );
        EncodedPwd := src;
        //Encode Password
        for i:=1 to Length(src) do begin
            temp := Integer(src[i]) xor key;
            if not ((temp >= 33) and (temp <= 126)) then begin
                temp := Integer(src[i]);
            end;
            EncodedPwd[i] := Char(temp);
        end;
        Result := EncodedPwd;
    end else begin
        //Decode Password
        for i:=1 to Length(src) do begin
            temp := Integer(src[i]) xor key;
            if not ((temp >= 33) and (temp <= 126)) then begin
                temp := Integer(src[i]);
            end;
            src[i] := Char(temp);
        end;
    end;
end;

end.


