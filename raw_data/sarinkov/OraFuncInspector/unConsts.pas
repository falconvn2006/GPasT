unit unConsts;

interface

const
  T_FUNCTION           = 1;
  T_JAVA_SOURCE        = 2;
  T_LIBRARY            = 3;
  T_PACKAGE            = 4;
  T_PACKAGE_BODY       = 5;
  T_PROCEDURE          = 6;
  T_TRIGGER            = 7;
  T_TYPE               = 8;
  T_TYPE_BODY          = 9;

  S_PROCEDURE          = 'PROCEDURE';
  S_JAVA_SOURCE        = 'JAVA_SOURCE';
  S_LIBRARY            = 'LIBRARY';
  S_PACKAGE            = 'PACKAGE';
  S_PACKAGE_BODY       = 'PACKAGE BODY';
  S_TRIGGER            = 'TRIGGER';
  S_FUNCTION           = 'FUNCTION';
  S_TYPE               = 'TYPE';
  S_TYPE_BODY          = 'TYPE_BODY';

  TYPE_NAMES: array [T_FUNCTION..T_TYPE_BODY] of string = (
    S_PROCEDURE,
    S_JAVA_SOURCE,
    S_LIBRARY,
    S_PACKAGE,
    S_PACKAGE_BODY,
    S_TRIGGER,
    S_FUNCTION,
    S_TYPE,
    S_TYPE_BODY
  );

  S_WRAPPED            = 'WRAPPED';

  S_OWNER              = 'Owner';
  S_GRID_WIDTH         = 'Grid.Width';
  S_SOURCE_AREA        = 'SourceArea';
  S_COLOR              = 'Color';
  S_FONT_NAME          = 'FontName';
  S_FONT_SIZE          = 'FontSize';
  S_LINE_NUMBERS       = 'LineNumbers';
  S_SQL_SYNTAX         = 'SQLSyntax';
  S_EDITOR_PATH        = 'EditorPath';

  S_OBJECTS_TYPES      = 'ObjectsTypes';

  S_APP_SETTINGS       = 'AppSettings';

  S_SAVE_OPTIONS       = S_APP_SETTINGS + '.SaveOptions';
  S_DIRECTORY          = 'Directory';
  S_FILE_EXT           = 'FileExt';
  S_OWNER_DIR          = 'CreateOwnerDir';
  S_TYPE_DIR           = 'CreateTypeDir';
  S_OWNER_IN_NAME      = 'OwnerInFileName';
  S_TYPE_IN_NAME       = 'TypeInFileName';

implementation

end.
