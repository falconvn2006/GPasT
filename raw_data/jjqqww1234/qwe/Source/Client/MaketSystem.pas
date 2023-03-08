unit MaketSystem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  Grobal2, HUtil32, EdCode;

const

  MAKET_ITEMCOUNT_PER_PAGE = 10;
  MAKET_MAX_PAGE = 12;
  MAKET_MAX_ITEM_COUNT = MAKET_ITEMCOUNT_PER_PAGE * MAKET_MAX_PAGE;

  MAKET_STATE_EMPTY   = 0;
  MAKET_STATE_LOADING = 1;
  MAKET_STATE_LOADED  = 2;

{
    TMaketItem = record
      Item     : TClientItem;  // 변경된 능력치는 여기에 적용됨.
      SellIndex  : integer;      // 판매번호
      SellPrice  : integer;      // 판매 가격
      SellWho  : string[20];  // 판매자
      Selldate  : string[10]   // 판매날짜(0312311210 = 2003-12-31 12:10 )
      SellState : word          // 1 = 판매중 , 2 = 판매완료
   end;
}

type
  TMarketItemManager = class(TObject)
  private
    FState: integer;  // 메니저 상태  0 = Empty , 1 = Loading 2 = Full

    FMaxPage:    integer;  // 최대 페이지
    FCurrPage:   integer;  // 현재 페이지
    FLoadedpage: integer;  // 로딩된 최대 페이지

    FItems: TList;    // MaketItem 의 리스트
    FSelectedIndex: integer;  // 선택된 인덱스

    FUserMode: integer;
    FItemType: integer;
    bFirst:    integer;
  public
    RecvCurPage: integer;
    RecvMaxPage: integer;
  private
    procedure RemoveAll;
    procedure InitFirst;

    function CheckIndex(index_: integer): boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Load;
    procedure ReLoad;

    procedure Add(pInfo_: PTMarketItem);
    procedure Delete(Index_: integer);
    procedure Clear;

    function GetItem(Index_: integer; var rSelected: boolean): PTMarketItem;
      overload;
    function GetItem(Index_: integer): PTMarketItem; overload;
    function Select(Index_: integer): boolean;
    function IsEmpty: boolean;
    function Count: integer;
    function GetFirst: integer;
    function PageCount: integer;
    function GetUserMode: integer;
    function GetItemType: integer;

    procedure OnMsgReadData(msg: TDefaultMessage; body: string);
    procedure OnMsgWriteData(msg: TDefaultMessage; body: string);

  end;

var
  g_Market: TMarketItemManager;

implementation

uses
  ClMain;

// 생성자
constructor TMarketItemManager.Create;
begin
  inherited;

  FItems := TList.Create;
  InitFirst;
end;
// 소멸자
destructor TMarketItemManager.Destroy;
begin
  RemoveAll;
  FItems.Free;

  inherited;
end;

// 데이터 삭제
procedure TMarketItemManager.RemoveAll;
var
  i:     integer;
  pinfo: PTMarketItem;
begin
  for i := FItems.Count - 1 downto 0 do begin
    pinfo := FItems.Items[i];

    if pinfo <> nil then
      dispose(pinfo);

    FItems.Delete(i);
  end;

  FItems.Clear;

  FState := MAKET_STATE_EMPTY;
end;

function TMarketItemManager.CheckIndex(Index_: integer): boolean;
begin
  if (Index_ >= 0) and (Index_ < FItems.Count) then
    Result := True
  else
    Result := False;
end;

// 초기화
procedure TMarketItemManager.InitFirst;
begin
  FSelectedIndex := -1;
  FState := MAKET_STATE_EMPTY;

  RecvCurPage := 0;
  RecvMaxPage := 0;
end;

// 데이터 읽어옴
procedure TMarketItemManager.Load;
begin
  if IsEmpty and (FState = MAKET_STATE_EMPTY) then begin
    // 데이터 읽기위한 메세지 전송
    //        OnMsgReadData;
  end;
end;

procedure TMarketItemManager.ReLoad;
begin
  if not IsEmpty then
    RemoveAll;

  Load;
end;

//아이템 추가
procedure TMarketItemManager.Add(pInfo_: PTMarketItem);
begin
  if (FItems <> nil) and (pInfo_ <> nil) then begin
    FItems.Add(pInfo_);
  end;
end;

//아이템 삭제
procedure TMarketItemManager.Delete(Index_: integer);
begin

end;

procedure TMarketItemManager.Clear;
begin
  RemoveAll;
  InitFirst;
end;

// 데이터 선택
function TMarketItemManager.Select(Index_: integer): boolean;
begin
  Result := False;

  if CheckIndex(Index_) then begin
    FSelectedIndex := Index_;
    Result := True;
  end;
end;

//데이터가 비어있는지
function TMarketItemManager.IsEmpty: boolean;
begin
  if FItems.Count > 0 then
    Result := False
  else
    Result := True;

end;

//개수를 얻어온다.
function TMarketItemManager.Count: integer;
begin
  Result := FItems.Count;
end;

function TMarketItemManager.GetFirst: integer;
begin
  Result := bFirst;
end;

// 페이지수자를 가져온다.
function TMarketItemManager.PageCount: integer;
begin
  if FItems.Count = 0 then
    Result := 0
  else
    Result := FItems.Count div MAKET_ITEMCOUNT_PER_PAGE + 1;
end;

function TMarketItemManager.GetUserMode: integer;
begin
  Result := FUserMode;
end;

function TMarketItemManager.GetItemType: integer;
begin
  Result := FitemType;
end;


//데이터를 읽어올때 선택된넘인지 구별한다.
function TMarketItemManager.GetItem(Index_: integer;     // 아이템 인덱스
  var rSelected: boolean      // 선택된넘인지 리턴함
  ): PTMarketItem;
begin
  // 데이터를 얻고
  Result := GetItem(Index_);

  // 선택된넘과 같으면 TRUE
  if Result <> nil then begin
    if Index_ = FSelectedIndex then
      rSelected := True
    else
      rSelected := False;
  end;

end;

// 데이터 읽어들이기.
function TMarketItemManager.GetItem(Index_: integer      // 아이템 인덱스
  ): PTMarketItem;
begin
  Result := nil;

  if checkIndex(Index_) then begin
    Result := PTMarketItem(FItems.Items[Index_]);

  end;
end;


// 여러가지 메세지 전송및 수신 -------------------------------------------------
procedure TMarketItemManager.OnMsgReadData(msg: TDefaultMessage; body: string);
begin

end;

procedure TMarketItemManager.OnMsgWriteData(msg: TDefaultMessage; body: string);
var
  //    itemtype    : integer;
  //    bFirst      : integer;
  nCount: integer;
  i:      integer;
  pInfo:  PTMarketItem;
  buffer1: string;
  buffer2: string;
begin
  //    DScreen.AddSysMsg ('GET MARKET MSG');

  case msg.Ident of
    SM_MARKET_LIST: begin
      FUserMode := msg.Recog;
      FItemType := msg.Param;
      bFirst    := msg.Tag;

      buffer1 := DecodeString(body);

      if bFirst > 0 then
        Clear;

      buffer1 := GetValidStr3(buffer1, buffer2, ['/']);
      nCount  := Str_ToInt(buffer2, 0);

      buffer1     := GetValidStr3(buffer1, buffer2, ['/']);
      RecvCurPage := Str_ToInt(buffer2, 0);

      buffer1     := GetValidStr3(buffer1, buffer2, ['/']);
      RecvMaxPage := Str_ToInt(buffer2, 0);

      for i := 0 to nCount - 1 do begin

        buffer1 := GetValidStr3(buffer1, buffer2, ['/']);
        new(pInfo);
        DecodeBuffer(buffer2, pointer(pInfo), sizeof(TMarketItem));

        Add(pInfo);
      end;

    end;
  end;
end;

end.
