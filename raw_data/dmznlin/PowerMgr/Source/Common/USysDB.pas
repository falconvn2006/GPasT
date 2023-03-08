{*******************************************************************************
  作者: dmzn@163.com 2020-06-13
  描述: 系统数据库常量定义
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes, UDBManager;

const
  cPrecision          = 100;
  {-----------------------------------------------------------------------------
   描述: 计算精度
   *.重量为吨的计算中,小数值比较或者相减运算时会有误差,所以会先放大,去掉
     小数位后按照整数计算.放大倍数由精度值确定.
  -----------------------------------------------------------------------------}

  {*权限项*}
  sPopedom_Read       = 'A';                         //浏览
  sPopedom_Add        = 'B';                         //添加
  sPopedom_Edit       = 'C';                         //修改
  sPopedom_Delete     = 'D';                         //删除
  sPopedom_Preview    = 'E';                         //预览
  sPopedom_Print      = 'F';                         //打印
  sPopedom_Export     = 'G';                         //导出

  {*数据库标识*}
  sFlag_DB_K3         = 'King_K3';                   //金蝶数据库
  sFlag_DB_NC         = 'YonYou_NC';                 //用友数据库

  {*相关标记*}
  sFlag_Yes           = 'Y';                         //是
  sFlag_No            = 'N';                         //否
  sFlag_Unknow        = 'U';                         //未知
  sFlag_Enabled       = 'Y';                         //启用
  sFlag_Disabled      = 'N';                         //禁用

  sFlag_ManualNo      = '%';                         //手动指定(非系统自动)
  sFlag_NotMatter     = '@';                         //无关编号(任意编号都可)
  sFlag_ForceDone     = '#';                         //强制完成(未完成前不换)
  sFlag_FixedNo       = '$';                         //指定编号(使用相同编号)

  {*数据表*}
  sTable_Null         = 'Sys_Null';                  //空表
  sTable_UserGroup    = 'Sys_UserGroup';             //用户组
  sTable_Popedom      = 'Sys_Popedom';               //权限表
  sTable_PopItem      = 'Sys_PopItem';               //权限项

  sTable_ExtInfo      = 'Sys_ExtInfo';               //附加信息
  sTable_SysLog       = 'Sys_EventLog';              //系统日志
  sTable_BaseInfo     = 'Sys_BaseInfo';              //基础信息
  sTable_SerialStatus = 'Sys_SerialStatus';          //编号状态
  sTable_WorkePC      = 'Sys_WorkePC';               //验证授权
  sTable_Factorys     = 'Sys_Factorys';              //工厂列表
  sTable_ManualEvent  = 'Sys_ManualEvent';           //人工干预

  sTable_Organization = 'Sys_Organization';          //组织架构
  sTable_OrgAddress   = 'Sys_OrgAddress';            //通讯地址
  sTable_OrgContact   = 'Sys_OrgContact';            //联系方式

implementation

//Desc: 表结构描述和数据字典
procedure SystemTables(const nList: TList);
begin
  gDBManager.DefaultFit := dtMSSQL;
  //默认数据库类型: SQL Server

  gDBManager.AddTable(sTable_ExtInfo, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '记录编号').
    AddF('I_Group',     'varChar(20)',               '信息分组').
    AddF('I_ItemID',    'varChar(20)',               '信息标识').
    AddF('I_Item',      'varChar(30)',               '信息项').
    AddF('I_Info',      'varChar(500)',              '信息内容').
    AddF('I_ParamA',    sField_SQLServer_Decimal,    '浮点参数').
    AddF('I_ParamB',    'varChar(50)',               '字符参数').
    AddF('I_Index',     'Integer Default 0',         '显示索引',    '0');
  //ExtInfo

  gDBManager.AddTable(sTable_SysLog, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '记录编号').
    AddF('L_Date',      'DateTime',                  '操作日期').
    AddF('L_Man',       'varChar(32)',               '操作人').
    AddF('L_Group',     'varChar(20)',               '信息分组').
    AddF('L_ItemID',    'varChar(20)',               '信息标识').
    AddF('L_KeyID',     'varChar(20)',               '辅助标识').
    AddF('L_Event',     'varChar(220)',              '事件').
    AddI('idx_date',    'L_Date DESC');
  //SysLog

  gDBManager.AddTable(sTable_BaseInfo, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '记录编号').
    AddF('B_ID',        'varChar(15)',               '节点编号').
    AddF('B_Group',     'varChar(15)',               '分组').
    AddF('B_Text',      'varChar(100)',              '内容').
    AddF('B_Py',        'varChar(100)',              '拼音简写').
    AddF('B_Memo',      'varChar(50)',               '备注信息').
    AddF('B_Parent',    'varChar(15)',               '上级节点').
    AddF('B_Index',     sField_SQLServer_Decimal,    '创建顺序',    '0').
    AddI('idx_group',   'B_Group ASC');
  //BaseInfo

  gDBManager.AddTable(sTable_SerialStatus, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '记录编号').
    AddF('S_Object',    'varChar(32)',               '对象').
    AddF('S_SerailID',  'varChar(32)',               '串行编号').
    AddF('S_PairID',    'varChar(32)',               '配对编号').
    AddF('S_Status',    'Char(1) Default ''N''',     '状态(Y,N)',  'N').
    AddF('S_Date',      'DateTime',                  '创建时间').
    AddI('idx_status',  'S_Status ASC').
    AddI('idx_object',  'S_Object DESC,S_SerailID DESC');
  //SerialStatus

  gDBManager.AddTable(sTable_WorkePC, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '记录编号').
    AddF('W_Name',      'varChar(100)',              '电脑名称').
    AddF('W_MAC',       'varChar(32)',               'MAC地址').
    AddF('W_Factory',   'varChar(32)',               '工厂编号').
    AddF('W_Departmen', 'varChar(32)',               '部门').
    AddF('W_Serial',    'varChar(32)',               '编号').
    AddF('W_ReqMan',    'varChar(32)',               '申请人').
    AddF('W_ReqTime',   'DateTime',                  '申请时间').
    AddF('W_RatifyMan', 'varChar(32)',               '批准人').
    AddF('W_RatifyTime','DateTime',                  '批准时间').
    AddF('W_PoundID',   'varChar(32)',               '磅站编号').
    AddF('W_MITUrl',    'varChar(128)',              '业务服务').
    AddF('W_HardUrl',   'varChar(128)',              '硬件服务').
    AddF('W_Valid',     'Char(1) Default ''N''',     '有效(Y/N)',  'N');
  //WorkPC

  gDBManager.AddTable(sTable_Factorys, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '记录编号').
    AddF('F_ID',        'varChar(32)',               '工厂编号').
    AddF('F_Name',      'varChar(100)',              '工厂名称').
    AddF('F_MITUrl',    'varChar(128)',              '中间件地址').
    AddF('F_HardUrl',   'varChar(128)',              '硬件守护地址').
    AddF('F_WechatUrl', 'varChar(128)',              '微信服务地址').
    AddF('F_DBConn',    'varChar(500)',              '数据库连接配置').
    AddF('F_Valid',     'Char(1) Default ''Y''',     '有效(Y/N)').
    AddF('F_Index',     sField_SQLServer_Decimal,    '创建顺序',    '0');
  //Factorys

  gDBManager.AddTable(sTable_ManualEvent, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '记录编号').
    AddF('E_ID',        'varChar(32)',               '流水号').
    AddF('E_From',      'varChar(32)',               '来源').
    AddF('E_Key',       'varChar(32)',               '记录标识').
    AddF('E_Event',     'varChar(200)',              '事件').
    AddF('E_Solution',  'varChar(100)',              '处理方案').
    AddF('E_Result',    'varChar(12)',               '处理结果').
    AddF('E_Departmen', 'varChar(32)',               '处理部门').
    AddF('E_Date',      'DateTime',                  '发生时间').
    AddF('E_ManDeal',   'varChar(32)',               '处理人').
    AddF('E_DateDeal',  'DateTime',                  '处理时间').
    AddF('E_ParamA',    'Integer',                   '整形参数').
    AddF('E_ParamB',    'varChar(128)',              '字符串参数').
    AddF('E_Memo',      'varChar(512)',              '备注信息').
    AddI('idx_date',    'E_Date DESC').
    AddI('idx_event',   'E_Date DESC, E_Result ASC, E_Departmen ASC');
  //ManualEvent

  gDBManager.AddTable(sTable_Organization, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '记录编号').
    AddF('O_ID',        'varChar(32)',               '单位编号').
    AddF('O_Name',      'varChar(100)',              '单位名称').
    AddF('O_NamePy',    'varChar(100)',              '单位检索').
    AddF('O_Type',      'varChar(16)',               '单位类型').
    AddF('O_Parent',    'varChar(32)',               '上级单位').
    AddF('O_Admin',     'varChar(32)',               '管理员').
    AddF('O_ValidOn',   'DateTime',                  '授权时间').
    AddI('idx_id',      'O_ID ASC').
    AddI('idx_parent',  'O_Parent ASC');
  //organization

  gDBManager.AddTable(sTable_OrgAddress, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '记录编号').
    AddF('A_ID',        'varChar(32)',               '地址编号').
    AddF('A_Name',      'varChar(100)',              '地址名称').
    AddF('A_PostCode',  'varChar(16)',               '邮政编码').
    AddF('A_Address',   'varChar(320)',              '详细地址').
    AddF('A_Owner',     'varChar(32)',               '所属单位').
    AddI('idx_id',      'A_ID ASC').
    AddI('idx_owner',   'A_Owner ASC');
  //address

  gDBManager.AddTable(sTable_OrgContact, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '记录编号').
    AddF('C_ID',        'varChar(32)',               '通讯编号').
    AddF('C_Name',      'varChar(100)',              '通讯名称').
    AddF('C_Phone',     'varChar(50)',               '电话号码').
    AddF('C_Mail',      'varChar(50)',               '电子邮箱').
    AddF('C_Owner',     'varChar(32)',               '所属单位').
    AddI('idx_id',      'C_ID ASC').
    AddI('idx_owner',   'C_Owner ASC');
  //contact

  gDBManager.AddTable(sTable_Null, nList).
    AddF('R_ID',        sField_SQLServer_AutoInc,    '记录编号').
    AddP('DB_ShowFiles', //显示数据库的文件占用
//++++++++++++++++++++++++++++ 存储过程: 开始 ++++++++++++++++++++++++++++++++++
'CREATE PROCEDURE DB_ShowFiles' +sEnt+
'AS' +sEnt+
'SELECT a.name [文件名称]' +sEnt+
' ,CAST(a.[size]*1.0/128 as decimal(12,1)) AS [文件设置大小(MB)]' +sEnt+
' ,CAST(fileproperty(s.name,''SpaceUsed'')/(8*16.0) AS DECIMAL(12,1)) AS [文件所占空间(MB)]' +sEnt+
' ,CAST((fileproperty(s.name,''SpaceUsed'')/(8*16.0))/(s.size/(8*16.0))*100.0  AS DECIMAL(12,1)) AS [所占空间率%]' +sEnt+
' ,CASE WHEN A.growth =0 THEN ''文件大小固定，不会增长'' ELSE ''文件将自动增长'' end [增长模式]' +sEnt+
' ,CASE WHEN A.growth > 0 AND is_percent_growth = 0 THEN ''增量为固定大小''' +sEnt+
'	WHEN A.growth > 0 AND is_percent_growth = 1 THEN ''增量将用整数百分比表示''' +sEnt+
'	ELSE ''文件大小固定，不会增长'' END AS [增量模式]' +sEnt+
' ,CASE WHEN A.growth > 0 AND is_percent_growth = 0 THEN cast(cast(a.growth*1.0/128as decimal(12,0)) AS VARCHAR)+''MB''' +sEnt+
'	WHEN A.growth > 0 AND is_percent_growth = 1 THEN cast(cast(a.growth AS decimal(12,0)) AS VARCHAR)+''%''' +sEnt+
'	ELSE ''文件大小固定，不会增长'' end AS [增长值(%或MB)]' +sEnt+
' ,a.physical_name AS [文件所在目录]' +sEnt+
' ,a.type_desc AS [文件类型]' +sEnt+
'FROM sys.database_files  a' +sEnt+
'INNER JOIN sys.sysfiles AS s ON a.[file_id]=s.fileid' +sEnt+
'LEFT JOIN sys.dm_db_file_space_usage b ON a.[file_id]=b.[file_id]' +sEnt+
'ORDER BY a.[type]').
//------------------------------------------------------------------------------
    AddP('DB_ShowTables ', //显示表空间占用
//++++++++++++++++++++++++++++ 存储过程: 开始 ++++++++++++++++++++++++++++++++++
'CREATE PROCEDURE DB_ShowTables' +sEnt+
'  @nByRows bit = 1,   --1,按记录数;0,按空间大小' +sEnt+
'  @nByDesc bit = 1    --1,降序;0,升序' +sEnt+
'AS' +sEnt+
'BEGIN' +sEnt+
'  declare @nStr varChar(200)' +sEnt+
'  declare @nOrder varChar(200)' +sEnt+
'  create table #t(name varchar(255), rows bigint, reserved varchar(20),' +sEnt+
'    data varchar(20), index_size varchar(20), unused varchar(20))' +sEnt+
'  exec sp_MSforeachtable "insert into #t exec sp_spaceused ''?''"' +sEnt+
'' +sEnt+
'  if @nByRows = 1' +sEnt+
'	   select @nOrder = ''order by rows''' +sEnt+
'  else select @nOrder = ''order by datasize''' +sEnt+
'  if @nByDesc = 1' +sEnt+
'	   select @nOrder = @nOrder + '' desc''' +sEnt+
'  else select @nOrder = @nOrder + '' asc''' +sEnt+
'' +sEnt+
'  select @nStr = ''select *,convert(int,left(data,' +sEnt+
'    charindex(''''KB'''',data)-1)) as datasize from #t''' +sEnt+
'  select @nStr = ''select * from ('' + @nStr + '') t '' + @nOrder' +sEnt+
'  exec(@nStr)' +sEnt+
'  drop table #t' +sEnt+
'END').
//------------------------------------------------------------------------------
    AddP('Data_OutputData', //导出指定表数据
//++++++++++++++++++++++++++++ 存储过程: 开始 ++++++++++++++++++++++++++++++++++
'CREATE PROCEDURE [Data_OutputData] ' +sEnt+
'  @tablename sysname,' +sEnt+
'  @wherefilter NVARCHAR(MAX) = ''''' +sEnt+
'AS' +sEnt+
'  declare @column NVARCHAR(MAX)' +sEnt+
'  declare @columndata NVARCHAR(MAX)' +sEnt+
'  declare @sql NVARCHAR(MAX)' +sEnt+
'  declare @xtype tinyint' +sEnt+
'  declare @name sysname' +sEnt+
'  declare @objectId int' +sEnt+
'  declare @objectname sysname' +sEnt+
'  declare @ident int' +sEnt+
'' +sEnt+
'  set nocount on' +sEnt+
'  set @objectId=object_id(@tablename)' +sEnt+
'  if @objectId is null   --判断对象是否存在' +sEnt+
'  begin' +sEnt+
'    print @tablename + ''对象不存在''' +sEnt+
'    return' +sEnt+
'  end' +sEnt+
'' +sEnt+
'  set @objectname=rtrim(object_name(@objectId))' +sEnt+
'  if @objectname is null or charindex(@objectname,@tablename)=0' +sEnt+
'  begin' +sEnt+
'    print @tablename + ''对象不在当前数据库中''' +sEnt+
'    return' +sEnt+
'  end' +sEnt+
'' +sEnt+
'  if OBJECTPROPERTY(@objectId,''IsTable'') <> 1 --判断对象是否是表' +sEnt+
'  begin' +sEnt+
'    print @tablename + ''对象不是表''' +sEnt+
'    return' +sEnt+
'  end' +sEnt+
'' +sEnt+
'  select @ident=status&0x80 from syscolumns' +sEnt+
'  where id=@objectid and status&0x80=0x80' +sEnt+
'  if @ident is not null' +sEnt+
'    print ''SET IDENTITY_INSERT ''+ @TableName + '' ON''' +sEnt+
'  --' +sEnt+
'' +sEnt+
'  --定义游标，循环取数据并生成Insert语句' +sEnt+
'  declare syscolumns_cursor cursor for' +sEnt+
'  select c.name,c.xtype from syscolumns c' +sEnt+
'  where c.id=@objectid order by c.colid' +sEnt+
'' +sEnt+
'  --打开游标' +sEnt+
'  open syscolumns_cursor' +sEnt+
'  set @column=''''' +sEnt+
'  set @columndata=''''' +sEnt+
'  fetch next from syscolumns_cursor into @name,@xtype' +sEnt+
'  while @@fetch_status <> -1' +sEnt+
'  begin' +sEnt+
'    if @@fetch_status <> -2' +sEnt+
'    begin' +sEnt+
'      if @xtype not in(189,34,35,99,98)' +sEnt+
'	  --timestamp不需处理，image,text,ntext,sql_variant 暂时不处理' +sEnt+
'      begin' +sEnt+
'        set @column=@column +' +sEnt+
'        case when len(@column)=0 then '''' else '','' end + @name' +sEnt+
'        set @columndata = @columndata +' +sEnt+
'        case when len(@columndata)=0 then '''' else '','''','''','' end  +' +sEnt+
'' +sEnt+
'        case when @xtype in(167,175) then ''''''''''''''''''+''+@name+''+''''''''''''''''''' +sEnt+
'			 --varchar,char' +sEnt+
'             when @xtype in(231,239) then ''''''N''''''''''''+''+@name+''+''''''''''''''''''' +sEnt+
'			 --nvarchar,nchar' +sEnt+
'             when @xtype=6 then ''''''''''''''''''+convert(char(23),''+@name+'',121)+''''''''''''''''''' +sEnt+
'			 --datetime' +sEnt+
'             when @xtype=58 then ''''''''''''''''''+convert(char(16),''+@name+'',120)+''''''''''''''''''' +sEnt+
'			 --smalldatetime' +sEnt+
'             when @xtype=36 then ''''''''''''''''''+convert(char(36),''+@name+'')+''''''''''''''''''' +sEnt+
'			 --uniqueidentifier' +sEnt+
'             else @name' +sEnt+
'        end' +sEnt+
'      end' +sEnt+
'    end' +sEnt+
'    fetch next from syscolumns_cursor into @name,@xtype' +sEnt+
'  end' +sEnt+
'  close syscolumns_cursor' +sEnt+
'  deallocate syscolumns_cursor' +sEnt+
'' +sEnt+
'  set @sql=''set nocount on select ''''insert ''+@tablename+''(''+@column+'') values(''''as ''''--'''',''+@columndata+'','''')'''' from ''+@tablename' +sEnt+
'  if @wherefilter <> ''''' +sEnt+
'  begin' +sEnt+
'    set @sql = @sql + '' where '' + @wherefilter' +sEnt+
'  end' +sEnt+
'' +sEnt+
'  print ''--''+@sql' +sEnt+
'  exec(@sql)' +sEnt+
'' +sEnt+
'  if @ident is not null' +sEnt+
'  print ''SET IDENTITY_INSERT ''+@TableName+'' OFF''').
//------------------------------------------------------------------------------
    AddP('Data_GetTree', //检索指定节点的所有父节点或子节点
//++++++++++++++++++++++++++++ 存储过程: 开始 ++++++++++++++++++++++++++++++++++
'CREATE PROCEDURE [dbo].[Data_GetTree](' +sEnt+
'  @nID NVARCHAR(MAX),             ---记录标识' +sEnt+
'  @nColID NVARCHAR(MAX),          ---记录所在字段' +sEnt+
'  @nColParent NVARCHAR(MAX),      ---父节点字段名' +sEnt+
'  @nTable NVARCHAR(MAX),          ---表名称' +sEnt+
'  @nToChild bit = 0,              ---1,子节点;0,父节点' +sEnt+
'  @nWhere NVARCHAR(MAX) = Null,   ---过滤条件' +sEnt+
'  @nFields NVARCHAR(MAX) = ''*''    ---返回的字段' +sEnt+
') AS' +sEnt+
'BEGIN' +sEnt+
'  DECLARE @nExtWhere NVARCHAR(MAX);' +sEnt+
'  DECLARE @nExtDir NVARCHAR(MAX);' +sEnt+
'  if @nWhere is Null' +sEnt+
'       SET @nExtWhere = ''''' +sEnt+
'  else SET @nExtWhere = '' and ('' + @nWhere + '')'';' +sEnt+
'  if @nToChild = 0' +sEnt+
'	      SET @nExtDir = @nColID + ''=b.'' + @nColParent' +sEnt+
'  else SET @nExtDir = @nColParent + ''=b.'' + @nColID' +sEnt+
'' +sEnt+
'  DECLARE @nSQL NVARCHAR(MAX);' +sEnt+
'  SET @nSQL = ''with CTE as (' +sEnt+
'    select 0 as Level,* from '' + @nTable + ''' +sEnt+
'    where '' + @nColID + ''='''''' + @nID + '''''''' + @nExtWhere + ''' +sEnt+
'    union all' +sEnt+
'    select Level+1,a.* from '' + @nTable + '' a' +sEnt+
'    inner join CTE b on a.'' + @nExtDir + @nExtWhere + ''' +sEnt+
'  ) select '' + @nFields + '' from CTE'';' +sEnt+
'' +sEnt+
'  EXEC sp_executesql @nSQL;' +sEnt+
'END');
end;

initialization
  if Assigned(gDBManager) then
    gDBManager.AddTableBuilder(SystemTables);
  //将数据表提交至数据库管理器
end.


