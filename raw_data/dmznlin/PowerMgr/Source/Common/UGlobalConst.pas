{*******************************************************************************
  作者: dmzn@ylsoft.com 2021-10-08
  描述: 项目所有模块公用常、变量定义单元
*******************************************************************************}
unit UGlobalConst;

interface

uses
  SysUtils, Classes, ULibFun;

type
  TOrganizationStructure = (osGroup, osArea, osFactory, osPost);
  TOrganizationStructures = set of TOrganizationStructure;
  //组织架构: 集团,区域,工厂,岗位

const
  sOrganizationNames: array[TOrganizationStructure] of string = ('集团', '区域',
    '工厂', '岗位');
  //组织结构名称

type
  POrganizationItem = ^TOrganizationItem;
  TOrganizationItem = record
    FID     : string;                                    //记录标识
    FName   : string;                                    //组织名称
    FParent : string;                                    //上级标识
    FType   : TOrganizationStructure;                    //组织类型
  end;
  TOrganizationItems = TArray<TOrganizationItem>;

  POrgAddress = ^TOrgAddress;
  TOrgAddress = record
    FID       : string;                                  //记录标识
    FName     : string;                                  //名称
    FPost     : string;                                  //邮编
    FAddr     : string;                                  //地址
    FOwner    : string;                                  //拥有者

    FValid    : Boolean;                                 //有效标识
    FModified : Boolean;                                 //改动标识
    FSelected : Boolean;                                 //选中标识
  end;
  TOrgAddressItems = TArray<TOrgAddress>;

  POrgContact = ^TOrgContact;
  TOrgContact = record
    FID       : string;                                  //记录标识
    FName     : string;                                  //名称
    FPhone    : string;                                  //电话
    FMail     : string;                                  //邮件
    FOwner    : string;                                  //拥有者

    FValid    : Boolean;                                 //有效标识
    FModified : Boolean;                                 //改动标识
    FSelected : Boolean;                                 //选中标识
  end;
  TOrgContactItems = TArray<TOrgContact>;

  TGlobalBusiness = class
  public
    class function Name2Organization(const nName: string):
      TOrganizationStructure; static;
    {*名称转组织结构类型*}
  end;

implementation

//Date: 2021-10-15
//Parm: 组织结构名称
//Desc: 返回nName对应的组织结构类型
class function TGlobalBusiness.Name2Organization(
  const nName: string): TOrganizationStructure;
var nIdx: TOrganizationStructure;
begin
  for nIdx := Low(sOrganizationNames) to High(sOrganizationNames) do
   if sOrganizationNames[nIdx] = nName then
   begin
     Result := nIdx;
     Exit;
   end;

  Result := osFactory;
  //for default
end;

end.


