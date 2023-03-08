{ ******************************************************************************
  Title: Types
  Description: Enums

  @author Fabiano Morais
  @add initial
  **************************************************************************** }
unit initialPascal.Types;

interface

type
  generic TProc<T> = procedure (aArg: T) of object;
  TProcString = specialize TProc<String>;
  TProcInteger = specialize TProc<Integer>;

  TFormMessage = (fmInfo, fmAlert, fmQuestion);

implementation

end.
