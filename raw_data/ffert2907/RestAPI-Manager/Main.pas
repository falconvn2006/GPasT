unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo, FMX.StdCtrls,

  u_REST_API_Generic, FMX.Memo.Types, System.Rtti, FMX.Grid.Style, FMX.TabControl, FMX.Layouts, FMX.Grid, FMX.ListBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope, Fmx.Bind.Grid, Data.Bind.Grid,
  Data.Bind.Controls, Fmx.Bind.Navigator, FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin, FMX.ComboEdit,
  Math;

type
  TF_Main = class(TForm)
    M_Log: TMemo;
    E_URL: TEdit;
    E_API_sandbox: TEdit;
    E_API: TEdit;
    B_TestAPI: TButton;
    E_Group: TEdit;
    E_ApiName: TEdit;
    B_OAuth: TButton;
    E_Authorization: TEdit;
    E_ProxyServer: TEdit;
    E_ProxyPort: TEdit;
    E_UserName: TEdit;
    E_Pwd: TEdit;
    SG_Data: TStringGrid;
    Splitter1: TSplitter;
    Layout1: TLayout;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TI_Proxy: TTabItem;
    TI_OAuth: TTabItem;
    TI_API: TTabItem;
    CB_AuthMode: TComboBox;
    E_Groupe: TEdit;
    E_Name: TEdit;
    CB_TypeRequest: TComboBox;
    E_APIURL: TEdit;
    E_RequestBody: TEdit;
    E_APIResponse: TEdit;
    SG_API: TStringGrid;
    BindList: TBindingsList;
    DS_APILIst: TDataSource;
    BSDB_API: TBindSourceDB;
    LinkGridToDataSourceBSDB_API: TLinkGridToDataSource;
    BN_API: TBindNavigator;
    TI_Keys: TTabItem;
    E_Service: TEdit;
    E_OAuthURL: TEdit;
    E_Conversion: TEdit;
    E_SuccessValue: TEdit;
    SB_SaveAPI: TSpeedButton;
    SD: TSaveDialog;
    SB_OpenAPI: TSpeedButton;
    OD: TOpenDialog;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    SG_Keys: TStringGrid;
    DS_KeyList: TDataSource;
    BSDB_Keys: TBindSourceDB;
    BN_Keys: TBindNavigator;
    SB_OpenKeys: TSpeedButton;
    SB_SaveKeys: TSpeedButton;
    E_ServiceKey: TEdit;
    E_GroupKey: TEdit;
    E_NameKey: TEdit;
    CB_KindKey: TComboBox;
    CB_EncryptionKey: TComboBox;
    E_KeyName: TEdit;
    E_KeyValue: TEdit;
    L_TS: TLabel;
    LinkGridToDataSourceBSDB_Keys: TLinkGridToDataSource;
    E_PostData: TEdit;
    CB_Header: TComboEdit;
    Label1: TLabel;
    Splitter2: TSplitter;
    FDMemTable1: TFDMemTable;
    E_FieldData: TEdit;
    E_FieldSuccess: TEdit;
    E_FieldMessage: TEdit;
    E_APIRoute: TEdit;
    B_Call: TButton;
    E_URLDebug: TEdit;
    DS_Data: TDataSource;
    BSDB_Data: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    Ti_Swagger: TTabItem;
    Label2: TLabel;
    SB_codeDelphi: TButton;
    B_CodeDelphiGenerateClass: TButton;
    SB_SaveFile: TSpeedButton;
    SD_Delphi: TSaveDialog;
    procedure B_TestAPIClick(Sender: TObject);
    procedure B_OAuthClick(Sender: TObject);
    procedure B_AddClick(Sender: TObject);
    procedure TI_APIClick(Sender: TObject);
    procedure SB_SaveAPIClick(Sender: TObject);
    procedure SB_OpenAPIClick(Sender: TObject);
    procedure BN_APIClick(Sender: TObject; Button: TNavigateButton);
    procedure BN_KeysClick(Sender: TObject; Button: TNavigateButton);
    procedure SB_SaveKeysClick(Sender: TObject);
    procedure SB_OpenKeysClick(Sender: TObject);
    procedure TI_KeysClick(Sender: TObject);
    procedure DS_APILIstDataChange(Sender: TObject; Field: TField);
    procedure E_APIURLChange(Sender: TObject);
    procedure B_CallClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SB_codeDelphiClick(Sender: TObject);
    procedure B_CodeDelphiGenerateClassClick(Sender: TObject);
    procedure SB_SaveFileClick(Sender: TObject);
  private
    FPath : string;
    procedure SetDataAPI(aInsertMode: boolean);
    procedure GetDataAPI;
    procedure GetDataKeys;
    procedure SetDataKeys(aInsertMode: boolean);
    procedure APIAfterScroll(DataSet: TDataSet);
    Function CreateProcedure(aClassName : string = 'TForm' ; aDSParam : boolean = false) : string;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  F_Main: TF_Main;
  API : TRESTAPI;

implementation

{$R *.fmx}



procedure TF_Main.BN_APIClick(Sender: TObject; Button: TNavigateButton);
begin
  case Button of
    nbFirst: ;
    nbPrior: ;
    nbNext: ;
    nbLast: ;
    nbInsert:
      SetDataAPI(true);
    nbDelete: ;
    nbEdit:
      GetDataAPI;
    nbPost:
      SetDataAPI(false);
    nbCancel: ;
    nbRefresh: ;
    nbApplyUpdates: ;
    nbCancelUpdates: ;
  end;
end;

procedure TF_Main.BN_KeysClick(Sender: TObject; Button: TNavigateButton);
begin
  case Button of
    nbFirst: ;
    nbPrior: ;
    nbNext: ;
    nbLast: ;
    nbInsert:
      SetDataKeys(true);
    nbDelete: ;
    nbEdit:
      GetDataKeys;
    nbPost:
      SetDataKeys(false);
    nbCancel: ;
    nbRefresh: ;
    nbApplyUpdates: ;
    nbCancelUpdates: ;
  end;
end;

procedure TF_Main.B_TestAPIClick(Sender: TObject);
//var
//  vAPI : TRESTAPI;
begin
  //API := u_REST_API_Generic.TRESTAPI.Create('','', E_API_sandbox.Text);
  if not(assigned(API)) then
    API := u_REST_API_Generic.TRESTAPI.Create(nil);
//    API := u_REST_API_Generic.TRESTAPI.Create('','', E_API_sandbox.Text);

  API.CallAPI(E_Group.Text, E_ApiName.Text);
//  if assigned(vAPI.CurrentMarket) then
//  begin
//
//
//
//  end;



end;

procedure TF_Main.B_OAuthClick(Sender: TObject);
begin
  API := u_REST_API_Generic.TRESTAPI.Create(nil); //'','', E_API_sandbox.Text);
  API.ProxyServer := E_ProxyServer.Text;
  API.ProxyPort := StrToIntDef(E_ProxyPort.Text, 80);
  API.ProxyUsername := E_UserName.Text;
  API.ProxyPassword := E_Pwd.Text;

//  if API.OAuth('https://digital.iservices.rte-france.com/token/oauth/', 'Basic ' + E_Authorization.Text) then
//  if API.OAuth2('https://digital.iservices.rte-france.com/token/oauth/', 'Basic ' + E_Authorization.Text) then
//  begin
//    Showmessage('AOuth OK - ' + API.OAuth_AccessToken + ' / ' + API.OAuth_TokenType);
//  end;
end;


// ***********************************************
//     Gestion API
// ***********************************************
procedure TF_Main.TI_APIClick(Sender: TObject);
begin
  // Activer l'affichage
  DS_APILIst.DataSet := u_REST_API_Generic.APIList;
  BSDB_API.DataSource :=  DS_APILIst;
  if not(u_REST_API_Generic.APIList.active) then
    u_REST_API_Generic.APIList.active := true;

  u_REST_API_Generic.APIList.AfterScroll := APIAfterScroll;

  SG_API.IsUsedInBinding := true;

end;


procedure TF_Main.SB_OpenAPIClick(Sender: TObject);
var
  i : integer;
begin
  OD.DefaultExt := '.API';
  if FPath <> '' then
    OD.InitialDir := FPath;

  if OD.Execute then
  begin
    u_REST_API_Generic.APIList.LoadFrom(OD.FileName);

    i := 0;
    while i < SG_API.ColumnCount do
    begin
      SG_API.Columns[i].Width := Max(65, Min(250, SG_API.Columns[i].Width / 2));
      inc(i);
    end;



    SD.FileName := OD.FileName;
  end;
end;

procedure TF_Main.SB_SaveAPIClick(Sender: TObject);
begin
  SD.DefaultExt := '.API';
  if FPath <> '' then
    SD.InitialDir := FPath;

  if SD.Execute then
  begin
    u_REST_API_Generic.APIList.SaveTo(SD.FileName);
    OD.FileName := SD.FileName;
  end;
end;

procedure TF_Main.SB_SaveFileClick(Sender: TObject);
begin
  if FPath <> '' then
    SD_Delphi.InitialDir := FPath;

  if SD_Delphi.Execute then
  begin
    //
    M_Log.Lines.SaveToFile(SD_Delphi.FileName);
  end;

end;

procedure TF_Main.APIAfterScroll(DataSet: TDataSet);
begin
  GetDataAPI;
end;

procedure TF_Main.DS_APILIstDataChange(Sender: TObject; Field: TField);
begin
 // if DS_APILIst.State = TDataSetState.dsBrowse then
 //   GetDataAPI;
end;

procedure TF_Main.E_APIURLChange(Sender: TObject);
begin
 // SetDataAPI(false);
end;

procedure TF_Main.FormShow(Sender: TObject);
begin
  // Activer l'onglet API

  FPath := '';
  if ParamCount > 1 then
    FPath := ParamStr(1);

  TI_APIClick( TI_API);
end;

procedure TF_Main.SetDataAPI(aInsertMode : boolean);
begin
  if (DS_APILIst.State <> TDataSetState.dsEdit) and (DS_APILIst.State <> TDataSetState.dsInsert) then
  begin
    if aInsertMode then
      u_REST_API_Generic.APIList.Append
    else
      u_REST_API_Generic.APIList.Edit;
  end;

  u_REST_API_Generic.APIList.FieldbyName('Service').Value := E_Service.Text;
  u_REST_API_Generic.APIList.FieldbyName('Group').Value   := E_Groupe.Text;
  u_REST_API_Generic.APIList.FieldbyName('Name').Value    := E_Name.Text;

  u_REST_API_Generic.APIList.FieldbyName('HeaderMode').Value := CB_AuthMode.items[max(0, CB_AuthMode.ItemIndex)];   // TAuthenticationMode
  u_REST_API_Generic.APIList.FieldbyName('OAuthURL').Value   := E_OAuthURL.Text;      // URL de l'authentification
  u_REST_API_Generic.APIList.FieldbyName('Request').Value    := CB_TypeRequest.items[Max(0, CB_TypeRequest.ItemIndex)];         // GEST / POST / PUT / DELETE

  u_REST_API_Generic.APIList.FieldbyName('URL').Value      := E_APIURL.Text;
  u_REST_API_Generic.APIList.FieldbyName('URLDebug').Value := E_URLDebug.Text;
  u_REST_API_Generic.APIList.FieldbyName('Route').Value    := E_APIRoute.Text;

  u_REST_API_Generic.APIList.FieldbyName('Header').Value := CB_Header.Text;
  u_REST_API_Generic.APIList.FieldbyName('PostData').asString := E_PostData.Text;
  u_REST_API_Generic.APIList.FieldbyName('Body').Value   := E_RequestBody.Text;
  u_REST_API_Generic.APIList.FieldbyName('Response').Value   := E_APIResponse.Text;
  u_REST_API_Generic.APIList.FieldbyName('DataConversion').Value := E_Conversion.Text;

  u_REST_API_Generic.APIList.FieldbyName('FieldData').Value          := E_FieldData.Text;
  u_REST_API_Generic.APIList.FieldbyName('FieldSuccess').Value      := E_FieldSuccess.Text;
  u_REST_API_Generic.APIList.FieldbyName('FieldErrorMessage').Value := E_FieldMessage.Text;
  u_REST_API_Generic.APIList.FieldbyName('SuccessValue').Value      := E_SuccessValue.Text;

  u_REST_API_Generic.APIList.Post;

end;


procedure TF_Main.GetDataAPI;
begin

  E_Service.Text := u_REST_API_Generic.APIList.FieldbyName('Service').asString;
  E_Groupe.Text  := u_REST_API_Generic.APIList.FieldbyName('Group').asString;
  E_Name.Text    := u_REST_API_Generic.APIList.FieldbyName('Name').asString;

  CB_AuthMode.ItemIndex :=  CB_AuthMode.Items.IndexOf(u_REST_API_Generic.APIList.FieldbyName('HeaderMode').asString);
  E_OAuthURL.Text := u_REST_API_Generic.APIList.FieldbyName('OAuthURL').asString;
  CB_TypeRequest.ItemIndex := CB_TypeRequest.Items.IndexOf(u_REST_API_Generic.APIList.FieldbyName('Request').asString);

  E_APIURL.Text      := u_REST_API_Generic.APIList.FieldbyName('URL').asString;
  E_URLDebug.Text    := u_REST_API_Generic.APIList.FieldbyName('URLDebug').asString;
  E_APIRoute.Text    := u_REST_API_Generic.APIList.FieldbyName('Route').asString;

  CB_Header.Text     := u_REST_API_Generic.APIList.FieldbyName('Header').asString;
  E_RequestBody.Text := u_REST_API_Generic.APIList.FieldbyName('Body').asString;

  E_PostData.Text    :=  u_REST_API_Generic.APIList.FieldbyName('PostData').asString;

  E_APIResponse.Text := u_REST_API_Generic.APIList.FieldbyName('Response').asString;
  E_Conversion.Text  := u_REST_API_Generic.APIList.FieldbyName('DataConversion').asString;

  E_FieldData.Text    := u_REST_API_Generic.APIList.FieldbyName('FieldData').asString;
  E_FieldSuccess.Text  := u_REST_API_Generic.APIList.FieldbyName('FieldSuccess').asString;
  E_FieldMessage.Text := u_REST_API_Generic.APIList.FieldbyName('FieldErrorMessage').asString;
  E_SuccessValue.Text  := u_REST_API_Generic.APIList.FieldbyName('SuccessValue').asString;

end;

procedure TF_Main.TI_KeysClick(Sender: TObject);
begin
  // Activer l'affichage
  DS_KeyList.DataSet := u_REST_API_Generic.APIKeys;
  BSDB_Keys.DataSource :=  DS_KeyList;
  SG_Keys.IsUsedInBinding := true;

end;

procedure TF_Main.SB_OpenKeysClick(Sender: TObject);
begin
  OD.DefaultExt := '.keys';
  if OD.Execute then
  begin
    u_REST_API_Generic.APIKeys.LoadFrom(OD.FileName);
    SD.FileName := OD.FileName;
  end;
end;

procedure TF_Main.SB_SaveKeysClick(Sender: TObject);
begin
  SD.DefaultExt := '.keys';
  if SD.Execute then
  begin
    u_REST_API_Generic.APIKeys.SaveTo(SD.FileName);
    OD.FileName := SD.FileName;
  end;
end;

procedure TF_Main.SetDataKeys(aInsertMode : boolean);
begin

  if aInsertMode then
    u_REST_API_Generic.APIKeys.Append
  else
    u_REST_API_Generic.APIKeys.Edit;

  u_REST_API_Generic.APIKeys.FieldbyName('Service').Value := E_ServiceKey.Text;
  u_REST_API_Generic.APIKeys.FieldbyName('Group').Value   := E_GroupKey.Text;
  u_REST_API_Generic.APIKeys.FieldbyName('Name').Value    := E_NameKey.Text;

  u_REST_API_Generic.APIKeys.FieldbyName('Kind').Value := CB_KindKey.items[CB_KindKey.ItemIndex];     // TAuthenticationMode
  u_REST_API_Generic.APIKeys.FieldbyName('Encryption').Value := CB_EncryptionKey.items[CB_EncryptionKey.ItemIndex];  // GEST / POST / PUT / DELETE

  u_REST_API_Generic.APIKeys.FieldbyName('KeyName').Value   := E_KeyName.Text;
  u_REST_API_Generic.APIKeys.FieldbyName('KeyValue').Value  := E_KeyValue.Text;
  u_REST_API_Generic.APIKeys.FieldbyName('TimeStamp').Value := now;

  u_REST_API_Generic.APIKeys.Post;

end;


procedure TF_Main.GetDataKeys;
begin

  E_ServiceKey.Text := u_REST_API_Generic.APIKeys.FieldbyName('Service').asString;
  E_GroupKey.Text   := u_REST_API_Generic.APIKeys.FieldbyName('Group').asString;
  E_NameKey.Text    := u_REST_API_Generic.APIKeys.FieldbyName('Name').asString;

  CB_AuthMode.ItemIndex :=  CB_AuthMode.Items.IndexOf(u_REST_API_Generic.APIKeys.FieldbyName('Kind').asString); // UserPwd-APIKey-OAuth-
  CB_EncryptionKey.ItemIndex := CB_EncryptionKey.Items.IndexOf(u_REST_API_Generic.APIKeys.FieldbyName('Encryption').asString);   // None, Base64,

  E_KeyName.Text := u_REST_API_Generic.APIKeys.FieldbyName('KeyName').asString; // Keyname : APIKey-Public, APIKey-Private, APIKeyBase64,
  E_KeyValue.Text  := u_REST_API_Generic.APIKeys.FieldbyName('KeyValue').asString; // Value
  L_TS.Text := u_REST_API_Generic.APIKeys.FieldbyName('TimeStamp').asString;   // dernière date de mise à jour

end;



procedure TF_Main.B_AddClick(Sender: TObject);
begin
  //

//   SetDataAPI(true);
//
//
//  BindList.DependencyList.Add(TDependency.Create(E_Service,  BSDB_API, 'Text', 'Service'));
//  BindList.DependencyList.Add(TDependency.Create(E_Group,  BSDB_API, 'Text', 'Group'));
//  BindList.DependencyList.Add(TDependency.Create(E_Name,  BSDB_API, 'Text', 'Name'));
//
//  BindList.DependencyList.Add(TDependency.Create(CB_AuthMode,  BSDB_API, 'Text', 'HeaderMode'));
//  BindList.DependencyList.Add(TDependency.Create(E_OAuthURL,  BSDB_API, 'Text', 'OAuthURL'));
//  BindList.DependencyList.Add(TDependency.Create(CB_TypeRequest,  BSDB_API, 'Text', 'Request'));
//
//  BindList.DependencyList.Add(TDependency.Create(E_URL,  BSDB_API, 'Text', 'URL'));
//  BindList.DependencyList.Add(TDependency.Create(E_Header,  BSDB_API, 'Text', 'Header'));
//  BindList.DependencyList.Add(TDependency.Create(E_RequestBody,  BSDB_API, 'Text', 'Body'));
//
//  BindList.DependencyList.Add(TDependency.Create(E_APIResponse,  BSDB_API, 'Text', 'Response'));
//  BindList.DependencyList.Add(TDependency.Create(E_Conversion,  BSDB_API, 'Text', 'Conversion'));
//  BindList.DependencyList.Add(TDependency.Create(E_Success,  BSDB_API, 'Text', 'Success'));



end;



procedure TF_Main.B_CallClick(Sender: TObject);
var
  vRest : TRESTAPI;
  i : integer;
begin
  //
  vRest := TRESTAPI.Create(nil);
  vRest.CallAPI( u_REST_API_Generic.APIList.FieldbyName('Service').AsString,
                 u_REST_API_Generic.APIList.FieldbyName('Group').AsString,
                 u_REST_API_Generic.APIList.FieldbyName('Name').AsString);

  DS_Data.dataset := vRest;

  // redimensionner les colonnes
  i := 0;
  while i < SG_Data.ColumnCount do
  begin
    SG_Data.Columns[i].Width := Max(65, Min(250, SG_Data.Columns[i].Width / 2));
    inc(i);
  end;


end;

function TF_Main.CreateProcedure(aClassName : string = 'TForm' ; aDSParam : boolean = false) : string;
var
  vSL : TStringList;
  aSL : TstringList;
  vParams : string;
  i : integer;
begin

  vSL := TStringList.Create;
  try

    aSL := TstringList.Create();
    u_REST_API_Generic.Split('|', u_REST_API_Generic.APIList.FieldbyName('PostData').asString, aSL);

    if aDSParam then
    begin

      vParams := '';
      if aSL.Count > 0 then
      begin
        if aSL.Count < 7 then
        begin
          i := 0;
          while i < aSL.Count do
          begin
            if aSL[i] <> '' then
            begin
              if (pos('=',aSL[i]) > 0 ) then
                vParams := vParams + ' ; a' + copy(aSL[i], 0 , pos('=', aSL[i]) -1) + ' : string = ''''';
            end;
            inc(i);
          end;
        end
        else
        begin
           vParams := ' ; aParamList : TSTrings = nil';
        end;
      end;

      vSL.add('procedure T' + aClassName + '.' + u_REST_API_Generic.APIList.FieldbyName('Group').AsString + '_' + u_REST_API_Generic.APIList.FieldbyName('Name').AsString + '(ADataSet : TFDMemTable ' + vParams +  ');');
    end
    else
    begin
      vSL.add('procedure T' + aClassName + '.' + u_REST_API_Generic.APIList.FieldbyName('Group').AsString + '_' + u_REST_API_Generic.APIList.FieldbyName('Name').AsString + ';');
    end;
    vSL.add('begin');

    if aSL.Count > 0 then
      vSL.add('  // List of params needed for this call');

    i := 0;
    while i < aSL.Count do
    begin
      if aSL[i] <> '' then
      begin
        if (pos('=',aSL[i]) > 0 ) then
          vSL.add('  FRest.AddParam(''' + copy(aSL[i], 0 , pos('=', aSL[i]) -1) + ''', a' + copy(aSL[i], 0 , pos('=', aSL[i]) -1) + ');');

//          vSL.add('  FRest.AddParam(''' + StringReplace(aSL[i], '=', QuotedStr(', '), []) + ''');');
      end;
      inc(i);
    end;

    vSL.add('  // Call service from u_REST_API_Generic.APIList ');
    vSL.add('  try');
    vSL.add('    Var vError : string := FRest.CallAPI( ' + QuotedStr(u_REST_API_Generic.APIList.FieldbyName('Service').AsString) + ', ' + QuotedStr(u_REST_API_Generic.APIList.FieldbyName('Group').AsString) + ', ' + QuotedStr(u_REST_API_Generic.APIList.FieldbyName('Name').AsString) + ');');
    vSL.add('    // Use Data ');
    if aDSParam then
    begin
      vSL.add('    If (aDataSet <> nil) and (FRest.Success) then ');
      vSL.add('    begin');
      vSL.add('      aDataSet.CloneCursor(FRest); ');
      vSL.add('    end');
      vSL.add('    else');
      vSL.add('    begin');
      vSL.add('      // manager Unsuccess here');
      vSL.add('    end;');

    end
    else
    begin
      vSL.add('  DS_Data.dataset := FRest; ');
    end;

    vSL.add('  except ');
    vSL.add('    // Manage error here ');
    vSL.add('    // raise Exception.Create(vError));');
    vSL.add('  end; ');

    vSL.add('end;');
    vSL.add(' ');

    result := vSL.text;

  finally
    aSL.Free;
    vSL.Free;
  end;
end;

procedure TF_Main.SB_codeDelphiClick(Sender: TObject);
begin
  //
  M_Log.lines.add('-------------------------------------------------');

  M_Log.lines.add('uses u_REST_API_Generic,');
  M_Log.lines.add('  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, ');
  M_Log.lines.add('    FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.EngExt, Fmx.Bind.DBEngExt, ');
  M_Log.lines.add('    System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope, Fmx.Bind.Grid, Data.Bind.Grid, ');
  M_Log.lines.add('    Data.Bind.Controls, Fmx.Bind.Navigator, FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin; ');
  M_Log.lines.add('  ');
  M_Log.lines.add('  ..... ');

  M_Log.lines.add('type ');
  M_Log.lines.add('  var FRest : TRESTAPI; ');
  M_Log.lines.add('  ..... ');


  //
  CreateProcedure;

  M_Log.lines.add('');
  M_Log.lines.add('........ Initialise on event .....');
  M_Log.lines.add('procedure TForm.FormShow(Sender: TObject);');
  M_Log.lines.add('begin');
  M_Log.lines.add('  // Init RestAPI Object');
  M_Log.lines.add('  FRest := TRESTAPI.Create(nil);');
  M_Log.lines.add('end;');
  M_Log.lines.add('');
  M_Log.lines.add('procedure TForm.FormClose(Sender: TObject);');
  M_Log.lines.add('begin');
  M_Log.lines.add('  // Free Object');
  M_Log.lines.add('  FREST.Free;');
  M_Log.lines.add('end;');
  M_Log.lines.add('');
  M_Log.lines.add('........ OR Initialise at start .....');
  M_Log.lines.add('Initialization');
  M_Log.lines.add('  // Init RestAPI Object');
  M_Log.lines.add('  FRest := TRESTAPI.Create(nil);');
  M_Log.lines.add('');
  M_Log.lines.add('Finalization');
  M_Log.lines.add('  // Free Object');
  M_Log.lines.add('  FRest.Free;');



end;


procedure TF_Main.B_CodeDelphiGenerateClassClick(Sender: TObject);
var
  vClassName : string;
  vProcedures : string;
  s : string;
begin
  //

  vClassName := u_REST_API_Generic.APIList.FieldbyName('Service').AsString;

  u_REST_API_Generic.APIList.First;

  SD_Delphi.FileName := 'u_API_' + vClassName + '.pas';

  // M_Log.lines.add('-------------------------------------------------');
  M_Log.lines.add('unit u_API_' + vClassName + ';');
  M_Log.lines.add('  ');
  M_Log.lines.add('interface');
  M_Log.lines.add('  ');
  M_Log.lines.add('uses ');
  M_Log.lines.add('  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, ');
  M_Log.lines.add('  u_REST_API_Generic,');
  M_Log.lines.add('  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, ');
  M_Log.lines.add('  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.EngExt, Fmx.Bind.DBEngExt, ');
  M_Log.lines.add('  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope, Fmx.Bind.Grid, Data.Bind.Grid, ');
  M_Log.lines.add('  Data.Bind.Controls, Fmx.Bind.Navigator, FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin; ');
  M_Log.lines.add('  ');

  M_Log.lines.add('const  ');
  M_Log.lines.add('  {$IFDEF PRODUCTION}');
  M_Log.lines.add('    KAPIURL = ' + QuotedStr(u_REST_API_Generic.APIList.FieldbyName('URL').AsString) +';');
  M_Log.lines.add('  {$ELSE}');
  M_Log.lines.add('    KAPIURL = ' + QuotedStr(u_REST_API_Generic.APIList.FieldbyName('URLDebug').AsString) +';');
  M_Log.lines.add('  {$ENDIF}');
  M_Log.lines.add('  ');

  M_Log.lines.add('type ');
  M_Log.lines.add('  T' + vClassName + ' = class(TObject)');
  M_Log.lines.add('  Private');
  M_Log.lines.add('    FRest : TRESTAPI; ');
  M_Log.lines.add('  Public');
  M_Log.lines.add('    Constructor Create; ');
  M_Log.lines.add('    Destructor Destroy; ');

  while not(u_REST_API_Generic.APIList.eof) do
  begin
    if u_REST_API_Generic.APIList.FieldbyName('Service').AsString = vClassName then
    begin

      s := CreateProcedure(vClassName, true);
      vProcedures := vProcedures + #$A#$D + s;
      s := stringReplace(copy(s, 0, pos(#$A, s) -1), 'T' + vClassName + '.', '', [rfIgnoreCase]);
      M_Log.lines.add('    ' + s);

    end;

    u_REST_API_Generic.APIList.Next;
  end;

  M_Log.lines.add('  Published');

  M_Log.lines.add('  end;');

  M_Log.lines.add('');

  M_Log.lines.add('var');
  M_Log.lines.add('  ' + vClassName + ' : T' + vClassName + ';');
  M_Log.lines.add('Implementation');

  M_Log.lines.add(vProcedures);


  M_Log.lines.add('');
  M_Log.lines.add('Constructor T' + vClassName + '.Create;');
  M_Log.lines.add('begin');
  M_Log.lines.add('  inherited;');
  M_Log.lines.add('  FRest := TRESTAPI.Create(nil);');
  M_Log.lines.add('');
  M_Log.lines.add('end;');
  M_Log.lines.add('');
  M_Log.lines.add('Destructor T' + vClassName + '.Destroy;');
  M_Log.lines.add('begin');
  M_Log.lines.add('');
  M_Log.lines.add('  FRest.Free;');
  M_Log.lines.add('  inherited');
  M_Log.lines.add('end;');
  M_Log.lines.add('');

  M_Log.lines.add('//  Initialize var ');
  M_Log.lines.add('Initialization');
  M_Log.lines.add('  // Init RestAPI Object');
  M_Log.lines.add('  ' + vClassName + ' := T' + vClassName + '.Create;');
  M_Log.lines.add('');
  M_Log.lines.add('Finalization');
  M_Log.lines.add('  // Free Object');
  M_Log.lines.add('  ' + vClassName + '.Free;');

  M_Log.lines.add('');
  M_Log.lines.add('end.');


end;

end.
