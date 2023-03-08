unit UCst;

interface

//const
//   LecteurLame='E';
//   LecteurTools='F';

const
   lesplace: array[1..22] of string = ('192.168.0.11', '192.168.0.12', '192.168.0.13', '192.168.0.14', '192.168.0.15', '192.168.0.16', '192.168.0.17','192.168.0.118','192.168.0.119','192.168.13.20', '192.168.13.22',
                                       'GSA-LAME1',    'GSA-LAME2',    'GSA-LAME3',    'GSA-LAME4',    'GSA-LAME5',    'GSA-LAME6',    'GSA-LAME7',   'GSA-LAME8',    'GSA-LAME9',    'SYMREPLIC1',    'SYMREPLIC2');
   lesMachine: array[1..22] of string = ('http://lame1.no-ip.com/', 'http://lame2.no-ip.com/', 'http://lame3.no-ip.com/', 'http://lame4.no-ip.com/', 'http://lame5.no-ip.com/','http://lame6.no-ip.org/','http://lame7.no-ip.org/','http://lame8.no-ip.org/','http://lame9.no-ip.org/','http://192.168.13.20/','http://192.168.13.22/',
                                         'http://lame1.no-ip.com/', 'http://lame2.no-ip.com/', 'http://lame3.no-ip.com/', 'http://lame4.no-ip.com/', 'http://lame5.no-ip.com/','http://lame6.no-ip.org/','http://lame7.no-ip.org/','http://lame8.no-ip.org/','http://lame9.no-ip.org/','http://192.168.13.20/','http://192.168.13.22/');
//   lesLectLame: array[1..22] of string = ('D'        , 'D'           , 'D'           , 'D'           , 'D'           , 'D'           , 'D'           , 'D'           , 'D'           , 'D'           , 'D'            ,
//                                          'D'        , 'D'           , 'D'           , 'D'           , 'D'           , 'D'           , 'D'           , 'D'           , 'D'           , 'E'           , 'E'            );

var
  PURL: string;
  LecteurLame: string;
  LecteurTools: string;
  bDoZipAuto: boolean;

function URL:String;
FUNCTION traitechaine(S: string): string;

implementation

FUNCTION traitechaine(S: string): string;
var
   kk: Integer;
begin
   while pos(' ', S) > 0 do
   begin
      kk := pos(' ', S);
      delete(S, kk, 1);
      Insert('%20', S, kk);
   end;
   result := S;
end;

function URL:String;
begin
  if PURL = '' then
    PURL := 'http://192.168.13.52/tech/AccesBase.dll/';

  result  := PURL;
end;

end.
