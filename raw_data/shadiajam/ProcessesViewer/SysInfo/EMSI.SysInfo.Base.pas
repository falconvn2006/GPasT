{********************************************}
{        EMSI System Info                    }
{    Base Objects Unit                       }
{Last modified:                              }
{Revision:                                   }
{Author:         Shadi AJAM                  }
{********************************************}

unit EMSI.SysInfo.Base;

interface

uses
  System.SysUtils,
  Winapi.Windows,
  System.Generics.Collections,

  EMSI.SysInfo.Consts
  ;

type
  TEMSI_ObjectChangeStatus = (ocsNewObject,ocsNoChange,ocsChanged,ocsDeleted,ocsDeleting);
  TEMSI_ListChangeStatus = (lcsNoChange,lcsChanged);

  TEMSI_SysInfoObj = class(TObject)
  private
    FChangeStatus : TEMSI_ObjectChangeStatus;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure Assign(Source:TEMSI_SysInfoObj);virtual;

    function IsSameObject(Obj: TEMSI_SysInfoObj):boolean;virtual;

    property ChangeStatus : TEMSI_ObjectChangeStatus read FChangeStatus;
  end;

  TEMSI_SysInfoList<T:TEMSI_SysInfoObj> = class(TObjectList<T>)
  protected
    FChangeStatus : TEMSI_ListChangeStatus;
    function FillList:TEMSI_Result; virtual;



    procedure MergeWithNewList(NewList:TEMSI_SysInfoList<T>); virtual;

    function NewObject:T;virtual;abstract;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property ChangeStatus : TEMSI_ListChangeStatus read FChangeStatus;
    function SearchObject(Obj: T):T;virtual;
  end;

  EEMSI_SysInfo = class(Exception)
  public
    constructor Create(const EMSI_Result:TEMSI_Result); overload;

  end;

implementation


{ TEMSI_SysInfoObj }

procedure TEMSI_SysInfoObj.AfterConstruction;
begin
  inherited;
  FChangeStatus := ocsNewObject;
end;

procedure TEMSI_SysInfoObj.Assign(Source: TEMSI_SysInfoObj);
begin

end;

procedure TEMSI_SysInfoObj.BeforeDestruction;
begin
  inherited;

end;

function TEMSI_SysInfoObj.IsSameObject(Obj: TEMSI_SysInfoObj): boolean;
begin
  Result := False;
end;

{ TEMSI_SysInfoList<T> }

procedure TEMSI_SysInfoList<T>.AfterConstruction;
begin
  inherited;
end;

procedure TEMSI_SysInfoList<T>.BeforeDestruction;
begin
  inherited;

end;

procedure TEMSI_SysInfoList<T>.MergeWithNewList(NewList: TEMSI_SysInfoList<T>);
var AObj,BObj : T;
    DeletedCount : integer;
begin

  DeletedCount := 0;
  Self.FChangeStatus := lcsNoChange;
  for AObj in Self do
  begin
    BObj := NewList.SearchObject(AObj);
    if Assigned(BObj) then
    begin
      AObj.Assign(BObj);
      AObj.FChangeStatus := ocsNoChange;
      BObj.FChangeStatus := ocsNoChange;
    end else
    begin
      if AObj.FChangeStatus = ocsDeleting then
        AObj.FChangeStatus := ocsDeleted else
        AObj.FChangeStatus := ocsDeleting;
      inc(DeletedCount);
    end;
  end;

  if DeletedCount > 0  then
    Self.FChangeStatus := lcsChanged;

  for AObj in NewList do
  begin
    if AObj.FChangeStatus = ocsNewObject then
    begin
      BObj := Self.NewObject;
      BObj.Assign(AObj);
      Self.Add(BObj);
      Self.FChangeStatus := lcsChanged;
    end;

  end;
end;

function TEMSI_SysInfoList<T>.FillList: TEMSI_Result;
begin
  Result := emsi_Unknown;
end;


function TEMSI_SysInfoList<T>.SearchObject(Obj: T): T;
var BObj : T;
begin
  Result := nil;
  for BObj in Self do
    if BObj.IsSameObject(Obj) then exit(BObj);

end;

{ EEMSI_SysInfo }

constructor EEMSI_SysInfo.Create(const EMSI_Result: TEMSI_Result);
begin
  inherited Create(emsi_ErrorText(EMSI_Result));
end;

end.
