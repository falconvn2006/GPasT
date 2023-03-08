{ ******************************************************************************
  Title: Constants
  Description: 

  @author Fabiano Morais (fcpm_mike@hotmail.com)
  @add initial
  **************************************************************************** }
unit initialPascal.Constants;

interface

uses
  SysUtils;

const
  ftCnpj = '##.###.###/####-##;0;_';
  ftCpf = '###.###.###-##;0;_';
  ftZipCode = '##.###-####;0;_';
  ftPhone = '(##)# ####-####;0;_';

type


  TConstantes = class
  const
  {$WriteableConst ON}
    PAGINATE_TOTAL: Integer = 50;
    DECIMAL_VALUE: Integer = 2;
    DECIMAL_AMOUNT: Integer = 2;
  {$WriteableConst OFF}
    LAYOUT_FOLDER_IMG = 'img' + PathDelim + 'layout' + PathDelim;
  end;

implementation

end.
