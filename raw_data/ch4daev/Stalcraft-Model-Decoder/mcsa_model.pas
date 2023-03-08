unit mcsa_model;

{$mode objfpc}{$H+}

interface

uses
  Model, Logger, readers;

const
  MCSA_HDR_FLAG_SKELETON_PRESENT = 0;
  MCSA_HDR_FLAG_UV_PRESENT = 1;
  MCSA_HDR_FLAG_2 = 2;
  MCSA_HDR_FLAG_4BYTES_FROM_10h = 3;
  MCSA_HDR_FLAG_4 = 4;

type
  TMCSAHeaderData = record
    magic:cardinal;
    version:single;
    flags:array[0..4] of Byte;
    xyz_scale:single;
    uv_scale:single;
    meshes_count:integer;
  end;

  { TMCSAMesh }

  TMCSAMesh = class(TMesh)
  protected
    _logger:TLogger;
    function ReadVertexId(r:TReader):cardinal;
  public
    constructor Create(l:TLogger = nil);
    function Load(r:TReader; model:TModel):boolean; override;
  end;

  { TMCSASkeleton }

  TMCSASkeleton = class(TSkeleton)
  protected
    _logger:TLogger;

  public
    constructor Create(l:TLogger = nil);
    function Load(r:TReader; model:TModel):boolean; override;
  end;

  { TMCSAModel }

  TMCSAModel = class(TModel)
  private
    _hdr:TMCSAHeaderData;
    _logger:TLogger;
    function ParseHeader(r:TReader):boolean;
  public
    constructor Create(l:TLogger = nil);
    function GetHeader():TMCSAHeaderData;
    function Load(r:TReader):boolean; override;
  end;

  function Unpack16bitFloat(d:word):single;
implementation
uses sysutils, strutils;

function ReadMCSAString(r:TReader):string;
var
  c:integer;
begin
  c:=r.ReadUWord();
  result:='';
  while c > 0 do begin
    result:=result+chr(r.ReadByte());
    c:=c-1;
  end;
end;

function Unpack16bitFloat(d:word):single;
var
  s, e, m:cardinal;
  sgn:integer;
begin
  result:=0;

  s:=d shr 15;

  if s = 0 then sgn:=1 else sgn:=-1;


  e:=(d and $7FFF) shr 10;
  m:=d and $3FF;

  if e = $1f then begin
    //NaN or Inf
    assert(false, 'NaN or Inf value reached');
  end else if e = 0 then begin
    // Denormalized value
    result:=sgn*(1/(1 shl 14))*(m/1024);
  end else begin
    //Normal value
    if e >= 15 then begin
      result:=sgn*(1 shl (e-15))*(1+(m/1024));
    end else begin
      result:=sgn*(1/(1 shl (15-e)))*(1+(m/1024));
    end;
  end;
end;

function Read16bitFloat(r:TReader):single;
begin
  result:=Unpack16bitFloat(r.ReadUWord());
end;

{ TMCSASkeleton }

constructor TMCSASkeleton.Create(l: TLogger);
begin
  _logger:=l;
end;

function TMCSASkeleton.Load(r: TReader; model: TModel): boolean;
var
  mcsa_hdr:TMCSAHeaderData;
  cnt:byte;

  i, parent:integer;
begin
  mcsa_hdr:=TMCSAModel(model).GetHeader();
  if mcsa_hdr.flags[MCSA_HDR_FLAG_SKELETON_PRESENT] = 0 then begin
    TLogger.Log(_logger, 'Attempt to load skeleton from model without MCSA_HDR_FLAG_SKELETON_PRESENT');
  end;

  cnt:=r.ReadByte();
  Resize(cnt);

  for i:=0 to cnt-1 do begin
    _bones[i].name:=ReadMCSAString(r);
    parent:=r.ReadByte();
    if parent = i then begin
      parent:=-1;
    end;
    _bones[i].parentid:=parent;

    _bones[i].pos.x:=r.ReadFloat();
    _bones[i].pos.y:=r.ReadFloat();
    _bones[i].pos.z:=r.ReadFloat();

    _bones[i].rot.x:=r.ReadFloat();
    _bones[i].rot.y:=r.ReadFloat();
    _bones[i].rot.z:=r.ReadFloat();

    // Bone coordinates in MCSA are global. We need to recalculate them to local (bone) space to build correct skeleton
    // However, instead of re-calculation we could just remove links, so every bone become a 'root' bone. Let's do it.
    _bones[i].parentid := -1;
  end;

end;

{ TMCSAMesh }

function TMCSAMesh.ReadVertexId(r: TReader): cardinal;
begin
  if length(_vertices) > $7FFF then begin
    result:=r.ReadUDword();
  end else begin
    result:=r.ReadUWord();
  end;
end;

constructor TMCSAMesh.Create(l: TLogger);
begin
  _logger:=l;
end;

function TMCSAMesh.Load(r: TReader; model: TModel): boolean;
var
  mcsa_hdr:TMCSAHeaderData;
  i, j, c, tmp:integer;
  x,y,z,w,u,v:smallint;

  link_count:integer;
  bones_arr:array of byte;
  f:textfile;

  t1, t2, t3, t4:integer;
  f1,f2,f3,f4:single;
const
  NORM_VAL_S16:integer = 32768;
begin
  result:=false;
  bones_arr:=nil;
  link_count:=0;
  try
    mcsa_hdr:=TMCSAModel(model).GetHeader();

    _name:=ReadMCSAString(r);
    _material:=ReadMCSAString(r);
    if mcsa_hdr.flags[MCSA_HDR_FLAG_SKELETON_PRESENT] <> 0 then begin
      link_count:=r.ReadByte(); //max bones links count (per vertex)

      tmp:=r.ReadByte(); //Total count of bones linked with this mesh
      setlength(bones_arr, tmp);
      for i:=0 to length(bones_arr)-1 do begin
        bones_arr[i]:=r.ReadByte(); //bone index
      end;
    end;

    tmp:=r.ReadUDword();
    ResizeVertices(tmp);
    tmp:=r.ReadUDword();
    setlength(_polys, tmp);

    ////////Read vertex container data////////
    if mcsa_hdr.flags[MCSA_HDR_FLAG_2] <> 0 then begin
      r.ReadFloat(); // unknown
    end;

    for i:=0 to length(_vertices)-1 do begin
      x:=r.ReadSWord();
      y:=r.ReadSWord();
      z:=r.ReadSWord();
      w:=r.ReadUWord();

      _vertices[i].pos.x:= mcsa_hdr.xyz_scale * x / NORM_VAL_S16;
      _vertices[i].pos.y:= mcsa_hdr.xyz_scale * y / NORM_VAL_S16;
      _vertices[i].pos.z:= mcsa_hdr.xyz_scale * z / NORM_VAL_S16;
    end;

    if mcsa_hdr.flags[MCSA_HDR_FLAG_UV_PRESENT] <> 0 then begin
      for i:=0 to length(_vertices)-1 do begin
        u:=r.ReadSWord();
        v:=r.ReadSWord();

        _vertices[i].u:= mcsa_hdr.uv_scale * u / NORM_VAL_S16;
        _vertices[i].v:= mcsa_hdr.uv_scale * v / NORM_VAL_S16;
      end;
    end;

    //skip unknown vertex data
    if mcsa_hdr.flags[MCSA_HDR_FLAG_4BYTES_FROM_10h] > 0 then begin
      for i:=0 to length(_vertices)-1 do begin
        r.ReadSWord();
        r.ReadSWord();
      end;
    end;

    if mcsa_hdr.flags[MCSA_HDR_FLAG_2] <> 0 then begin
        for i:=0 to length(_vertices)-1 do begin
          r.ReadSWord();
          r.ReadSWord();
        end;
    end;

    ////////Read skeleton link info////////
    if (link_count > 0) and (link_count <= 2) then begin
        // Linked bones and weight are packed to one DWORD
        for i:=0 to length(_vertices)-1 do begin
          _vertices[i].bone_counts:=link_count;

          for j:=0 to sizeof(word)-1 do begin
            tmp:=r.ReadByte();
            if tmp >= length(bones_arr) then begin
              TLogger.Log(_logger, 'Invalid bone vertex index: '+inttostr(tmp)+', vertex #'+inttostr(i));
            end;
            _vertices[i].bone_ids[j]:=bones_arr[tmp];
          end;

          for j:=0 to sizeof(word)-1 do begin
            tmp:=r.ReadByte();
            _vertices[i].bone_weights[j]:=tmp / $FF;
          end;
        end;
    end else if (link_count > 2) and (link_count <= 4) then begin
      // Linked bones and weight are stored on separate "plains"
      for i:=0 to length(_vertices)-1 do begin
          _vertices[i].bone_counts:=link_count;
          for j:=0 to sizeof(cardinal)-1 do begin
            tmp:=r.ReadByte();
            if tmp >= length(bones_arr) then begin
              TLogger.Log(_logger, 'Invalid bone vertex index: '+inttostr(tmp)+', vertex #'+inttostr(i));
            end;
            _vertices[i].bone_ids[j]:=bones_arr[tmp];
          end;
      end;

      for i:=0 to length(_vertices)-1 do begin
        for j:=0 to sizeof(cardinal)-1 do begin
          tmp:=r.ReadByte();
          _vertices[i].bone_weights[j]:=tmp / $FF;
        end;
      end;

    end else if link_count <> 0 then begin
      TLogger.Log(_logger, 'Link count '+inttostr(link_count)+' support not implemented');
      exit;
    end;

    ////////Read polygons////////
    for i:=0 to length(_polys)-1 do begin
      _polys[i].v1:=ReadVertexId(r);
      _polys[i].v2:=ReadVertexId(r);
      _polys[i].v3:=ReadVertexId(r);
    end;


    if (false) then begin
      assignfile(f, 'verts.txt');
      try
         append(f);
      except
            rewrite(f);
      end;
      writeln(f,'///////////////////////////////////////');

      for i:=0 to length(_vertices)-1 do begin
        writeln(f, inttostr(i)+' - pos:'+floattostr(_vertices[i].pos.x)+', '+floattostr(_vertices[i].pos.y)+', '+floattostr(_vertices[i].pos.z)+', norm '+floattostr(_vertices[i].norm.x)+', '+floattostr(_vertices[i].norm.y)+', '+floattostr(_vertices[i].norm.z));
        if _vertices[i].norm.x*_vertices[i].norm.x + _vertices[i].norm.z*_vertices[i].norm.z > 1 then begin
          TLogger.Log(_logger, 'abnormal');
        end;
      end;

      closefile(f);
    end;

    result:=true;
  finally
    setlength(bones_arr, 0);
  end;
end;

{ TMCSAModel }

function TMCSAModel.Load(r: TReader): boolean;
var
  i:integer;
begin
  result:=false;

  Reset();

  if not ParseHeader(r) then exit;

  setlength(_meshes, _hdr.meshes_count);
  for i:=0 to _hdr.meshes_count-1 do begin
    _meshes[i]:=TMCSAMesh.Create(_logger);
  end;

  for i:=0 to _hdr.meshes_count-1 do begin
    if not _meshes[i].Load(r, self) then begin
      Reset();
      exit;
    end;
  end;

  if _hdr.flags[MCSA_HDR_FLAG_SKELETON_PRESENT] <> 0 then begin
    _skeleton:=TMCSASkeleton.Create(_logger);
    _skeleton.Load(r, self);
  end;

  result:=true;
end;


function TMCSAModel.ParseHeader(r: TReader): boolean;
const
  MAGIC_SIG:cardinal = $4153434D;
var
  i, flags_cnt:integer;
begin
  result:=false;
  TLogger.Log(_logger, 'Attempting to load MCSA model file');

  FillChar(_hdr, sizeof(_hdr), chr($00));

  _hdr.magic:=r.ReadUDword();
  if _hdr.magic <> MAGIC_SIG then begin
    TLogger.Log(_logger, 'Invalid header signature!');
    exit;
  end;

  _hdr.version:=r.ReadFloat();

  flags_cnt:=0;
  if (_hdr.version = 7) then begin
    flags_cnt:=4;
  end else if (_hdr.version = 8) then begin
    flags_cnt:=5;
  end else begin
    TLogger.Log(_logger, 'Unknown file version: '+floattostr(_hdr.version));
    exit;
  end;

  for i:=0 to flags_cnt-1 do begin
    _hdr.flags[i]:=r.ReadByte();
  end;

  if (_hdr.flags[MCSA_HDR_FLAG_4] = 1) or ((_hdr.flags[MCSA_HDR_FLAG_UV_PRESENT] = 0) and (_hdr.flags[MCSA_HDR_FLAG_2] = 1)) or ((_hdr.flags[MCSA_HDR_FLAG_UV_PRESENT] = 1) and (_hdr.flags[MCSA_HDR_FLAG_2] = 0)) then begin
    TLogger.Log(_logger, 'Header contains unsupported flags combination');
    exit;
  end;

  _hdr.xyz_scale:=r.ReadFloat();

  if _hdr.flags[MCSA_HDR_FLAG_UV_PRESENT] <> 0 then begin
    _hdr.uv_scale:=r.ReadFloat();
  end;
  _hdr.meshes_count:=r.ReadUDword();

  result:=true;
end;

constructor TMCSAModel.Create(l: TLogger);
begin
  _logger:=l;
end;

function TMCSAModel.GetHeader(): TMCSAHeaderData;
begin
  result:=_hdr;
end;

end.

