{*******************************************************************************
  作者: dmzn@163.com 2019-02-26
  描述: 界面风格管理单元
*******************************************************************************}
unit UStyleModule;

interface

uses
  System.SysUtils, System.Classes, dxSkinsCore, dxCore, dxSkinsDefaultPainters,
  cxLookAndFeelPainters, cxGraphics, dxLayoutLookAndFeels, dxAlertWindow,
  System.ImageList, Vcl.ImgList, Vcl.Controls, cxImageList, cxLookAndFeels,
  dxSkinsForm, cxClasses, cxEdit;

type
  TVerifyUIData = reference to procedure (const nCtrl: TControl;
   var nResult: Boolean; var nHint: string);
  //验证组件数据

  TFSM = class(TDataModule)
    EditStyle1: TcxDefaultEditStyleController;
    SkinManager: TdxSkinController;
    Image16: TcxImageList;
    AlertManager1: TdxAlertWindowManager;
    Image32: TcxImageList;
    dxLayout1: TdxLayoutLookAndFeelList;
    dxLayoutWeb1: TdxLayoutWebLookAndFeel;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FSkins: TStrings;
    FSkinDir: string;
    FSkinActive: string;
    {*活动主题*}
    FAdminKey: string;
    {*管理员密钥*}
  public
    { Public declarations }
    procedure LoadSkinNames(const nList: TStrings);
    {*主题列表*}
    procedure SwitchSkinRandom(const nOverDefault: Boolean = False);
    procedure SwitchSkin(const nSkin: string);
    {*切换主题*}
    procedure ShowMsg(const nMsg: string; nTitle: string = '');
    {*消息框*}
    procedure ShowDlg(const nMsg: string; nTitle: string = '');
    function QueryDlg(const nMsg: string; nTitle: string = ''): Boolean;
    function InputDlg(const nMsg,nTitle: string; var nValue: string;
      const nSize: Word = 0; const nPwd: Boolean = False): Boolean;
    {*提示框*}
    function VerifyAdministrator: Boolean;
    {*验证身份*}
    function VerifyUIData(const nParent: TWinControl;
      const nVerify: TVerifyUIData; const nShowMsg: Boolean = True;
      const nVerifySub: Boolean = True): Boolean;
    {*验证数据*}
    property Skins: TStrings read FSkins;
    property SkinActive: string read FSkinActive;
    property AdminKey: string read FAdminKey write FAdminKey;
    {*属性相关*}
  end;

var
  FSM: TFSM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.IniFiles, Vcl.Forms, ULibFun, UManagerGroup, UGoogleOTP,
  UFormInputbox, UFormMessagebox;

procedure TFSM.DataModuleCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  FAdminKey := '';
  //key for admin
  FSkins := TStringList.Create;
  FSkinDir := TApplicationHelper.gPath + 'Skins' + PathDelim;

  nIni := TIniFile.Create(TApplicationHelper.gFormConfig);
  try
    nStr := nIni.ReadString('Config', 'SkinDir', '');
    if nStr <> '' then
    begin
      nStr := TApplicationHelper.ReplaceGlobalPath(nStr);
      FSkinDir := TApplicationHelper.RegularPath(nStr);
    end;

    nStr := nIni.ReadString('Config', 'Theme', '');
    if nStr <> '' then
    begin
      LoadSkinNames(nil);
      SwitchSkin(nStr);
    end;
  finally
    nIni.Free;
  end;
end;

procedure TFSM.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FSkins);
end;

//Date: 2019-02-27
//Parm: 列表
//Desc: 当前可用的皮肤列表
procedure TFSM.LoadSkinNames(const nList: TStrings);
var nStr: string;
    nIdx: Integer;
    nSList: TStrings;
    nRet: Integer;
    nSR: TSearchRec;
begin
  if (not Assigned(nList)) or (FSkins.Count < 1) then //load skin files
  begin
    FSkins.Clear;
    nSList := TStringList.Create;

    nRet := FindFirst(FSkinDir + '*.skinres', faAnyFile, nSR);
    while nRet = 0 do
    try
      nSList.Clear;
      nStr := FSkinDir + nSR.Name;
      dxSkinsUserSkinPopulateSkinNames(nStr, nSList);

      for nIdx := 0 to nSList.Count-1 do
        FSkins.AddPair(nSList[nIdx], nStr);
      nRet := FindNext(nSR);
    except
      on nErr: Exception do
      begin
        gMG.FLogManager.AddLog('FSM.LoadSkinNames: ' + nErr.Message);
        Break;
      end;
    end;

    nSList.Free;
    FindClose(nSR); //find close

    for nIdx := 0 to cxLookAndFeelPaintersManager.Count - 1 do
     with cxLookAndFeelPaintersManager[nIdx] do
      if (LookAndFeelStyle = lfsSkin) and (not IsInternalPainter) then
       FSkins.AddPair(LookAndFeelName, '');
    //xxxxx
  end;

  if Assigned(nList) then
  begin
    nList.Clear;
    for nIdx := 0 to FSkins.Count-1 do
      nList.Add(FSkins.Names[nIdx]);
    //xxxxx
  end;
end;

//Date: 2019-02-27
//Parm: 主题名称
//Desc: 切换主题为nSkin
procedure TFSM.SwitchSkin(const nSkin: string);
var nStr: string;
    nIdx: Integer;
begin
  for nIdx := FSkins.Count-1 downto 0 do
  if CompareText(nSkin, FSkins.Names[nIdx]) = 0 then
  begin
    if FSkinActive = FSkins.Names[nIdx] then
      Break;
    //skin enabled

    nStr := FSkins.ValueFromIndex[nIdx];
    if FileExists(nStr) then
    begin
      SkinManager.SkinName := 'UserSkin';
      dxSkinsUserSkinLoadFromFile(nStr, nSkin);
    end else
    begin
      if SkinManager.SkinName <> nSkin then
        SkinManager.SkinName := nSkin;
      //xxxxx
    end;

    FSkinActive := FSkins.Names[nIdx];
    Break;
  end;
end;

//Date: 2020-10-26
//Parm: 覆盖默认
//Desc: 随机切换主题
procedure TFSM.SwitchSkinRandom(const nOverDefault: Boolean);
var nIdx: Integer;
    nList: TStrings;
begin
  if (FSkinActive <> '') and (not nOverDefault) then Exit;
  //use default skin

  nList := nil;
  try
    nList := gMG.FObjectPool.Lock(TStrings) as TStrings;
    FSM.LoadSkinNames(nList);
    nIdx := Random(nList.Count);

    if nIdx < nList.Count then
      FSM.SwitchSkin(nList[nIdx]);
    //xxxxx
  finally
    gMG.FObjectPool.Release(nList);
  end;
end;

//Date: 2019-03-01
//Parm: 父容器;验证函数;是否弹消息框;验证子容器
//Desc: 验证nParent下的所有控件数据有效
function TFSM.VerifyUIData(const nParent: TWinControl;
  const nVerify: TVerifyUIData; const nShowMsg,nVerifySub: Boolean): Boolean;
var nStr: string;
    nIdx: Integer;
begin
  Result := True;
  for nIdx := 0 to nParent.ControlCount - 1 do
  begin
    nVerify(nParent.Controls[nIdx], Result, nStr);
    //call-back to verify data

    if not Result then
    begin
      if nShowMsg then
      begin
        if nStr <> '' then
          ShowMsg(nStr);
        //xxxxx

        if nParent.Controls[nIdx] is TWinControl then
          (nParent.Controls[nIdx] as TWinControl).SetFocus;
        //xxxxx
      end;

      Exit;
    end;

    if nVerifySub and (nParent.Controls[nIdx] is TWinControl) then
    begin
      Result := VerifyUIData(nParent.Controls[nIdx] as TWinControl,
        nVerify, nShowMsg);
      if not Result then Exit;      
    end;
  end;
end;

//Date: 2021-04-02
//Desc: 使用动态口令验证是否为管理员
function TFSM.VerifyAdministrator: Boolean;
var nStr: string;
    nPrm: TApplicationHelper.TAppParam;
begin
  Result := InputDlg('请输入管理员动态口令:', '验证', nStr, 0, False) and
            TStringHelper.IsNumber(nStr, False);
  if not Result then Exit;

  if FAdminKey = '' then
  begin
    if FileExists(TApplicationHelper.gSysConfig) then
    begin
      nPrm.FAdminKey := '';
      TApplicationHelper.LoadParameters(nPrm, nil, False);

      if nPrm.FAdminKey <> '' then
        FAdminKey := nPrm.FAdminKey;
      //new key
    end;

    if FAdminKey = '' then
      FAdminKey := TApplicationHelper.sDefaultKey;
    //default key
  end;

  with TGoogleOTP do
    Result := Validate(EncodeBase32(FAdminKey), StrToInt(nStr));
  //xxxxx
end;

//Date: 2019-02-28
//Parm: 消息内容;标题
//Desc: 弹出消息框
procedure TFSM.ShowMsg(const nMsg: string; nTitle: string);
begin
  if nTitle = '' then
    nTitle := '提示';
  AlertManager1.Show(nTitle, nMsg, 5);
end;

//Date: 2021-03-29
//Parm: 消息;标题
//Desc: 提示对话框
procedure TFSM.ShowDlg(const nMsg: string; nTitle: string);
begin
  if nTitle = '' then
    nTitle := '提示';
  ShowMsgBox(nMsg, nTitle);
end;

//Date: 2021-03-29
//Parm: 消息;标题
//Desc: 询问对话框
function TFSM.QueryDlg(const nMsg: string; nTitle: string): Boolean;
begin
  if nTitle = '' then
    nTitle := '询问';
  Result := ShowQueryBox(nMsg, nTitle);
end;

//Date: 2021-04-02
//Parm: 消息;标题;值;大小;是否密码
//Desc: 显示输入框
function TFSM.InputDlg(const nMsg, nTitle: string; var nValue: string;
  const nSize: Word; const nPwd: Boolean): Boolean;
begin
  if nPwd then
       Result := ShowInputPWDBox(nMsg, nTitle, nValue, nSize)
  else Result := ShowInputBox(nMsg, nTitle, nValue, nSize);
end;

end.
