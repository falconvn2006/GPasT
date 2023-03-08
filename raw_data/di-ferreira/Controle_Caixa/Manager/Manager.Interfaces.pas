unit Manager.Interfaces;

interface

uses
  System.Generics.Collections, Manager.Types, Data.DB;

type
  iManager<T: class> = interface
    function This: T;
    procedure Save(aObject: T);
    procedure Update(aObject: T);
    procedure Remove(aObject: T); overload;
    procedure Remove(ID: Integer); overload;
    function List: TObjectList<T>;
    function FindAll: iManager<T>;
    function FindByID(ID: Integer): T;
    function DataSource: TDataSource;
    function UniqueResult: T;
    function ResultLastInsert: T;
    function Where(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<T>;
    function _And(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<T>;
    function _Or(Column: string; FilterOperator: tpFilterOperator; aValue: string; aValue2: string = ''): iManager<T>;
    function Count: Integer;
    function Sum(Column: string): iManager<T>;
    function OrderBy(Column: string; Direction: tpOrderDirection = tpOrderDirection.Asc): iManager<T>;
  end;

implementation

end.

