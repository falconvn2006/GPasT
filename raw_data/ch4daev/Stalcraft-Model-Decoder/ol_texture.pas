unit ol_texture;

{$mode objfpc}{$H+}

interface
uses readers, logger;

type

  TTextureDimensions = record
    width:cardinal;
    height:cardinal;
  end;

  { TOlDecodedStream }

  TOlDecodedStream = class
  protected
    _logger:TLogger;
    _data:array of byte;

  public
    constructor Create(l:TLogger=nil);
    destructor Destroy(); override;
    function LoadFromCompressedLZ4Stream(r:TReader; compressed_size:cardinal; uncompressed_size:cardinal):boolean;
    function Unpack8BITXYDXT(dims:TTextureDimensions):boolean;

    procedure SaveDataToFile(fname:string);
    function GetRawData():string;
    function RawDataSize():cardinal;
  end;

  { TOlTexture }

  TOlTexture = class
  protected
    _main_size:TTextureDimensions;
    _format_type:cardinal;
    _decoded_streams:array of TOlDecodedStream;
    _logger:TLogger;

    function BuildDDS():string;
  public
    constructor Create(l:TLogger=nil);
    destructor Destroy(); override;

    function Load(r:TReader):boolean;
    function SaveDDSFile(fname:string):boolean;
  end;

implementation
uses sysutils;

const
  FORMAT_DXT1:cardinal = $31545844;
  FORMAT_DXT5:cardinal = $35545844;
  FORMAT_8BITXYDXT:cardinal = $1;
  FORMAT_BGRA:cardinal=$2;

type
  dds_pixelformat = packed record
  dwSize:cardinal;
  dwFlags:cardinal;
  dwFourCC:cardinal;
  dwRGBBitCount:cardinal;
  dwRBitmask:cardinal;
  dwGBitmask:cardinal;
  dwBBitmask:cardinal;
  dwABitmask:cardinal;
end;

dds_header = packed record
  dwSize:cardinal;
  dwFlags:cardinal;
  dwHeight:cardinal;
  dwWidth:cardinal;
  dwPitchOrLinearSize:cardinal;
  dwDepth:cardinal;
  dwMipMapCount:cardinal;
  dwReserved1:array[0..10] of Cardinal;
  ddspf:dds_pixelformat;
  dwCaps:cardinal;
  dwCaps2:cardinal;
  dwCaps3:cardinal;
  dwCaps4:cardinal;
  dwReserved2:cardinal;
end;




function ConvertBEWtoLEW(value:word):word;
begin
  result:=(value shl 8) or (value shr 8);
end;

function ConvertBEDWtoLEDW(value:cardinal):cardinal;
begin
  result:=((value and $FF000000) shr 24) or ((value and $00FF0000) shr 8) or ((value and $0000FF00) shl 8) or ((value and $000000FF) shl 24)
end;


{ TOlDecodedStream }

constructor TOlDecodedStream.Create(l: TLogger);
begin
  _logger:=l;
end;

destructor TOlDecodedStream.Destroy();
begin
  inherited Destroy();
end;

function TOlDecodedStream.LoadFromCompressedLZ4Stream(r: TReader; compressed_size: cardinal; uncompressed_size: cardinal): boolean;
var
  token, tmpb:byte;
  cur_pos,processed_count, match_start, match_size, literal_size, cnt, i, maxi:cardinal;
  match_offset:word;
begin
  result:=false;

  if (compressed_size = 0) or (uncompressed_size = 0) then begin
    setlength(_data, 0);
    exit;
  end;

  cur_pos:=0;
  processed_count:=0;
  setlength(_data, uncompressed_size);
  repeat
    token:=r.ReadByte();
    processed_count:=processed_count+1;

    literal_size:=token shr 4;
    if literal_size = $f then begin
      repeat
        tmpb:=r.ReadByte();
        processed_count:=processed_count+1;
        literal_size:=literal_size+tmpb;
      until tmpb <> $FF;
    end;

    if cur_pos + literal_size > uncompressed_size then begin
      TLogger.Log(_logger, 'Uncompressed data length is greater than uncompressed_size');
      exit;
    end;

    cnt:=r.ReadBuf(@_data[cur_pos], literal_size);
    if cnt <> literal_size then begin
      TLogger.Log(_logger, 'Can''t read literal_size bytes from input stream');
      exit;
    end;

    cur_pos:=cur_pos+cnt;
    processed_count:=processed_count+cnt;
    if processed_count = compressed_size then begin
      break;
    end;

    match_offset:=r.ReadUWord();
    processed_count:=processed_count+2;
    if (match_offset = 0) or (cur_pos < match_offset) then begin
      TLogger.Log(_logger, 'Invalid offset in LZ4 decoder, pos '+inttohex(r.Pos(), 8));
      exit;
    end;

    match_start:=cur_pos-match_offset;

    match_size:=token and $0f;
    if match_size = $f then begin
      repeat
        tmpb:=r.ReadByte();
        processed_count:=processed_count+1;
        match_size:=match_size+tmpb;
      until tmpb <> $FF;
    end;
    match_size:=match_size+4;

    i:=match_start;
    maxi:=cur_pos;
    while match_size > 0 do begin
      if i >= maxi then begin
        i:=match_start;
      end;

      _data[cur_pos]:=_data[i];
      cur_pos:=cur_pos+1;

      match_size:=match_size-1;
      i:=i+1;
    end;
  until processed_count >= compressed_size;

  if uncompressed_size <> cur_pos then begin
    TLogger.Log(_logger, 'Uncompressed buffer size mismatch');
    exit;
  end;

  result:=true;
end;


type
  TDXTUNPACKEDSQUARE = array [0..3] of array[0..3] of byte;
  TDXT8BITSQUARE = packed record
    c0:byte;
    c1:byte;
    indices:array[0..5] of byte;
  end;
  pTDXT8BITSQUARE = ^TDXT8BITSQUARE;

procedure UnpackDxt8bitSquare(s_in:TDXT8BITSQUARE; var s_out:TDXTUNPACKEDSQUARE);
var
  palette:array[0..7] of byte;
  indices:int64;
  i, j:integer;
  tmp:byte;
begin
  palette[0]:=s_in.c0;
  palette[1]:=s_in.c1;

  if s_in.c0 > s_in.c1 then begin
    palette[2]:=(6*palette[0] + 1*palette[1]) div 7;
    palette[3]:=(5*palette[0] + 2*palette[1]) div 7;
    palette[4]:=(4*palette[0] + 3*palette[1]) div 7;
    palette[5]:=(3*palette[0] + 4*palette[1]) div 7;
    palette[6]:=(2*palette[0] + 5*palette[1]) div 7;
    palette[7]:=(1*palette[0] + 6*palette[1]) div 7;
  end else begin
    palette[2]:=(4*palette[0] + 1*palette[1]) div 5;
    palette[3]:=(3*palette[0] + 2*palette[1]) div 5;
    palette[4]:=(2*palette[0] + 3*palette[1]) div 5;
    palette[5]:=(1*palette[0] + 4*palette[1]) div 5;
    palette[6]:= 0;
    palette[7]:= $FF;
  end;

  indices:=int64(s_in.indices[0]) or (int64(s_in.indices[1]) shl 8) or (int64(s_in.indices[2]) shl 16) or (int64(s_in.indices[3]) shl 24) or (int64(s_in.indices[4]) shl 32) or (int64(s_in.indices[5]) shl 40);
  for i:=0 to 3 do begin
    for j:=0 to 3 do begin
      tmp:=indices and $7;
      indices:=indices shr 3;
      s_out[i][j]:=palette[tmp];
    end;
  end;


end;

function TOlDecodedStream.Unpack8BITXYDXT(dims: TTextureDimensions):boolean;
var
  newdata:array of array of array [0..3] of byte;
  i, j, kx, ky:integer;

  unp_square_g:TDXTUNPACKEDSQUARE;
  unp_square_r:TDXTUNPACKEDSQUARE;

  cur_pos_in:integer;
begin
  result:=false;

  if dims.width*dims.height <> cardinal(length(_data)) then begin
    TLogger.Log(_logger, 'Can''t unpack 8-Bit XY DXT - invalid buffer length');
    exit;
  end;

  if (dims.width mod 4 <> 0) or (dims.height mod 4 <> 0) then begin
    TLogger.Log(_logger, 'Can''t unpack 8-Bit XY DXT - dimensions not multiple of 4');
    exit;
  end;


  newdata:=nil;
  setlength(newdata, dims.height);
  for i:=0 to length(newdata)-1 do begin
    setlength(newdata[i], dims.width);
  end;


  try
    cur_pos_in:=0;
    for j:=0 to (dims.height div 4)-1 do begin
      for i:=0 to (dims.width div 4)-1 do begin
        // 'Y' channel
        UnpackDxt8bitSquare(pTDXT8BITSQUARE(@_data[cur_pos_in])^, unp_square_g);
        cur_pos_in:=cur_pos_in+sizeof(TDXT8BITSQUARE);
        // 'X' channel
        UnpackDxt8bitSquare(pTDXT8BITSQUARE(@_data[cur_pos_in])^, unp_square_r);
        cur_pos_in:=cur_pos_in+sizeof(TDXT8BITSQUARE);

        for ky:=0 to 3 do begin
          for kx:=0 to 3 do begin
            newdata[j*4+ky][i*4+kx][0]:=$FF;
            newdata[j*4+ky][i*4+kx][1]:=unp_square_r[ky][kx];
            newdata[j*4+ky][i*4+kx][2]:=unp_square_g[ky][kx];
            newdata[j*4+ky][i*4+kx][3]:=$FF;
          end;
        end;
      end;
    end;

    setlength(_data, dims.width * dims.height * 4);
    for ky:=0 to dims.height - 1 do begin
      for kx:=0 to dims.width - 1 do begin
        for i:=0 to 3 do begin
          _data[cardinal(ky)*4*dims.width + cardinal(kx)*4+cardinal(i)]:=newdata[ky][kx][i];
        end;
      end;
    end;

    result:=true;

  finally
    for i:=0 to length(newdata)-1 do begin
      setlength(newdata[i], 0);
    end;
    setlength(newdata, 0);
  end;
end;

procedure TOlDecodedStream.SaveDataToFile(fname: string);
var
  f:file;
begin
  assignfile(f, fname);
  rewrite(f, 1);
  BlockWrite(f, _data[0], length(_data));
  closefile(f);
end;

function TOlDecodedStream.GetRawData(): string;
var
  i:integer;
begin
  result:='';
  for i:=0 to length(_data)-1 do begin
    result:=result+chr(_data[i]);
  end;
end;

function TOlDecodedStream.RawDataSize(): cardinal;
begin
  result:=length(_data);
end;

{ TOlTexture }

function TOlTexture.BuildDDS(): string;
const
  DDS_MAGIC:cardinal = $20534444;

  DDPF_RGB:cardinal = $40;
  DDPF_FOURCC:cardinal = $4;
  DDPF_ALPHAPIXELS:cardinal=$1;

  DDPF_FOURCC_DXT5:cardinal =$35545844;
  DDPF_FOURCC_DXT3:cardinal =$33545844;
  DDPF_FOURCC_DXT1:cardinal =$31545844;

  DDSD_CAPS:cardinal=$1;
  DDSD_HEIGHT:cardinal=$2;
  DDSD_WIDTH:cardinal=$4;
  DDSD_PITCH:cardinal=$8;
  DDSD_PIXELFORMAT:cardinal=$1000;
  DDSD_MIPMAPCOUNT:cardinal=$20000;
  DDSD_LINEARSIZE:cardinal=$80000;
  DDSD_DEPTH:cardinal=$800000;

  DDSCAPS_COMPLEX:cardinal=$8;
  DDSCAPS_MIPMAP:cardinal=$400000;
  DDSCAPS_TEXTURE:cardinal=$1000;
var
  hdr:dds_header;
  i, streams_count:integer;
begin
  result:='';

  FillChar(hdr, sizeof(hdr), 0);
  hdr.dwSize:=sizeof(dds_header);
  hdr.ddspf.dwSize:=sizeof(hdr.ddspf);

  hdr.dwFlags:=DDSD_CAPS or DDSD_PIXELFORMAT or DDSD_WIDTH or DDSD_HEIGHT;
  hdr.dwWidth:=_main_size.width;
  hdr.dwHeight:=_main_size.height;
  hdr.dwCaps:=DDSCAPS_TEXTURE;


  streams_count:=1; //length(_decoded_streams);

  if streams_count>1 then begin
    hdr.dwFlags:=hdr.dwFlags or DDSD_MIPMAPCOUNT;
    hdr.dwCaps:=hdr.dwCaps or DDSCAPS_COMPLEX or DDSCAPS_MIPMAP;
    hdr.dwMipMapCount:=streams_count;
  end;

  hdr.dwFlags:=hdr.dwFlags or DDSD_LINEARSIZE;
  hdr.dwPitchOrLinearSize:=_decoded_streams[0].RawDataSize();

  if (_format_type = FORMAT_DXT1) or (_format_type = FORMAT_DXT5) then begin
    hdr.ddspf.dwFlags:=DDPF_FOURCC;
    hdr.ddspf.dwFourCC:=_format_type;
  end else if _format_type = FORMAT_BGRA then begin
    hdr.ddspf.dwFlags:=DDPF_RGB or DDPF_ALPHAPIXELS;
    hdr.ddspf.dwRBitmask:=$00FF0000;
    hdr.ddspf.dwGBitmask:=$0000FF00;
    hdr.ddspf.dwBBitmask:=$000000FF;
    hdr.ddspf.dwABitmask:=$FF000000;
    hdr.ddspf.dwRGBBitCount:=32;
  end;

  result:=chr($44)+chr($44)+chr($53)+chr($20);
  for i:=0 to sizeof(hdr)-1 do begin
    result:=result+PAnsiChar(@hdr)[i];
  end;

  for i:=0 to streams_count-1 do begin
    result:=result+_decoded_streams[i].GetRawData();
  end;


end;

constructor TOlTexture.Create(l: TLogger);
begin
  setlength(_decoded_streams, 0);
  _logger:=l;
end;

destructor TOlTexture.Destroy();
var
  i:integer;
begin
  for i:=0 to length(_decoded_streams)-1 do begin
    FreeAndNil(_decoded_streams[i]);
  end;

  setlength(_decoded_streams, 0);
  inherited Destroy();
end;

function TOlTexture.Load(r: TReader): boolean;
var
  uncompressed_sizes: array of cardinal;
  compressed_sizes: array of cardinal;

  i, streams_count, id_size:integer;
  format, id_str:string;
const
  OL_MAGIC:cardinal=$FD23950A;
begin
  result:=false;
  uncompressed_sizes:=nil;
  compressed_sizes:=nil;

  try
    if r.ReadUDword()<>OL_MAGIC then begin
      TLogger.Log(_logger, 'Invalid magic signature');
      exit;
    end;
    _main_size.width:=ConvertBEDWtoLEDW(r.ReadUDword());
    _main_size.height:=ConvertBEDWtoLEDW(r.ReadUDword());
    streams_count:=ConvertBEDWtoLEDW(r.ReadUDword());

    _format_type:=0;
    format:=r.ReadZString();
    if format = '#?3VGGGGGGGGGGGG' then begin
      _format_type:=FORMAT_DXT1;
    end else if format = '#?3RGGGGGGGGGGGG' then begin
      _format_type:=FORMAT_DXT5;
    end else if format = '#?)8?>GGGGGGGGGG' then begin
      _format_type:=FORMAT_8BITXYDXT;
    end else if format = '% 5&_GGGGGGGGGGG' then begin
      _format_type:=FORMAT_BGRA;
    end else begin
      TLogger.Log(_logger, 'Unknown texture format');
      exit;
    end;


    for i:=1 to length(format) do begin
     format[i]:=chr(byte(format[i]) xor $47);
    end;

    setlength(_decoded_streams, streams_count);
    setlength(compressed_sizes, streams_count);
    setlength(uncompressed_sizes, streams_count);

    for i:=0 to streams_count-1 do begin
      _decoded_streams[i]:=TOlDecodedStream.Create(_logger);
      uncompressed_sizes[i]:=ConvertBEDWtoLEDW(r.ReadUDword());
    end;

    for i:=0 to streams_count-1 do begin
      compressed_sizes[i]:=ConvertBEDWtoLEDW(r.ReadUDword());
    end;

    id_size:=ConvertBEWtoLEW(r.ReadUWord());
    id_str:='';
    for i:=0 to id_size-1 do begin
      id_str:=id_str + chr(r.ReadByte());
    end;

    for i:=0 to streams_count-1 do begin
      if not _decoded_streams[i].LoadFromCompressedLZ4Stream(r, compressed_sizes[i], uncompressed_sizes[i]) then begin
        TLogger.Log(_logger, 'Can''t load compressed stream #'+inttostr(i));
      end;
    end;

    if (_format_type = FORMAT_8BITXYDXT) then begin
      if (streams_count > 0) then begin
        for i:=1 to streams_count-1 do begin
          _decoded_streams[i].Free();
        end;
        setlength(_decoded_streams, 1);
        result:=_decoded_streams[0].Unpack8BITXYDXT(_main_size);
        _format_type:=FORMAT_BGRA;
      end;
    end else begin
      result:=true;
    end;
  finally
    setlength(uncompressed_sizes, 0);
    setlength(compressed_sizes, 0);
  end;
end;

function TOlTexture.SaveDDSFile(fname: string): boolean;
var
  f:file;
  d:string;
begin
  result:=false;

  d:=BuildDDS();
  if length(d)>0 then begin

    assignfile(f, fname);

    try
      rewrite(f, 1);
      BlockWrite(f, d[1], length(d));
      result:=true;
    finally
      closefile(f);
    end;

  end;

end;

end.

