unit Model;
{$mode objfpc}{$H+}

interface
uses readers;

type
  TVector3D = record
    x:single;
    y:single;
    z:single;
  end;

  TVertex = record
    pos:TVector3D;
    norm:TVector3D;

    u:single;
    v:single;

    bone_counts:cardinal;
    bone_ids:array [0..3] of cardinal;
    bone_weights:array [0..3] of single;
  end;

  TPoly = record
    v1:cardinal;
    v2:cardinal;
    v3:cardinal;
  end;

  TModel = class;
  { TMesh }

  TMesh = class
  protected
    _vertices:array of TVertex;
    _polys:array of TPoly;
    _name:string;
    _material:string;


    procedure ResizeVertices(newcount:integer);
  public
    constructor Create();
    destructor Destroy(); override;

    function Load(r:TReader; model:TModel):boolean; virtual; abstract;

    procedure Reset();
    function v_count():integer;
    function p_count():integer;
    function v_get(idx:integer):TVertex;
    function p_get(idx:integer):TPoly;

    function name_get():string;
    function material_get():string;
  end;

  TBone = record
    name:string;
    parentid:integer;
    pos:TVector3D;
    rot:TVector3D;
  end;

  { TSkeleton }

  TSkeleton = class
  protected
    _bones:array of TBone;

    procedure Resize(newcount:integer);
  public
    constructor Create();
    destructor Destroy(); override;

    function Load(r:TReader; model:TModel):boolean; virtual; abstract;
    procedure Reset();
    function BonesCount():integer;
    function GetBone(idx:integer):TBone;
  end;

  { TModel }

  TModel = class
  protected
    _meshes:array of TMesh;
    _skeleton:TSkeleton;
  public
    constructor Create();
    function Load(r:TReader):boolean; virtual; abstract;
    function MeshesCount():integer;
    function GetMesh(idx:integer):TMesh;
    function GetSkeleton():TSkeleton;
    destructor Destroy(); override;
    procedure Reset();

    function TotalVertsCount():cardinal;
    function TotalPolysCount():cardinal;

  end;

  procedure ExportModelToMs3DAsciiFile(model:TModel; fname:string);
  procedure ExportModelToMs3DBinaryFile(model: TModel; fname: string);
implementation
uses sysutils, math;

procedure ResetVector(var v:TVector3D);
begin
  v.x:=0;
  v.y:=0;
  v.z:=0;
end;

procedure ResetVertex(var v:TVertex);
var
  i:integer;
begin
  ResetVector(v.pos);
  ResetVector(v.norm);
  v.u:=0;
  v.v:=0;

  v.bone_counts:=0;
  for i:=0 to length(v.bone_ids)-1 do begin
    v.bone_ids[i]:=0;
  end;

  for i:=0 to length(v.bone_weights)-1 do begin
    v.bone_weights[i]:=0;
  end;

end;

procedure ResetBone(var b:TBone);
begin
  b.name:='';
  b.parentid:=-1;
  ResetVector(b.pos);
  ResetVector(b.rot);
end;

{ TSkeleton }

procedure TSkeleton.Resize(newcount: integer);
var
  oldcnt, i:integer;
begin
  oldcnt:=length(_bones);
  setlength(_bones, newcount);
  for i:=oldcnt to newcount-1 do begin
    ResetBone(_bones[i]);
  end;
end;

constructor TSkeleton.Create();
begin
  setlength(_bones, 0);
end;

destructor TSkeleton.Destroy();
begin
  Reset();
  inherited Destroy();
end;

procedure TSkeleton.Reset();
begin
  setlength(_bones, 0);
end;

function TSkeleton.BonesCount(): integer;
begin
  result:=length(_bones);
end;

function TSkeleton.GetBone(idx: integer): TBone;
begin
  if (idx < 0) or (idx >= BonesCount()) then begin
    raise Exception.Create('Invalid vertex index');
  end;
  result:=_bones[idx];
end;

{ TMesh }

procedure TMesh.ResizeVertices(newcount: integer);
var
  oldcnt, i:integer;
begin
  oldcnt:=length(_vertices);
  setlength(_vertices, newcount);
  for i:=oldcnt to newcount-1 do begin
    ResetVertex(_vertices[i]);
  end;
end;

constructor TMesh.Create();
begin
  Reset();
end;

destructor TMesh.Destroy();
begin
  Reset();
  inherited;
end;

procedure TMesh.Reset();
begin
  setlength(_vertices, 0);
  setlength(_polys, 0);
end;

function TMesh.v_count(): integer;
begin
  result:=length(_vertices);
end;

function TMesh.p_count(): integer;
begin
  result:=length(_polys);
end;

function TMesh.v_get(idx: integer): TVertex;
begin
  if (idx < 0) or (idx >= v_count()) then begin
    raise Exception.Create('Invalid vertex index');
  end;
  result:=_vertices[idx];
end;

function TMesh.p_get(idx: integer): TPoly;
begin
  if (idx < 0) or (idx >= p_count()) then begin
    raise Exception.Create('Invalid poly index');
  end;

  result:=_polys[idx];
end;

function TMesh.name_get(): string;
begin
  result:=_name;
end;

function TMesh.material_get(): string;
begin
  result:=_material;
end;

{ TModel }

constructor TModel.Create();
begin
  SetLength(_meshes, 0);
  _skeleton:=nil;
end;

function TModel.MeshesCount(): integer;
begin
  result:=length(_meshes);
end;

function TModel.GetMesh(idx: integer): TMesh;
begin
  assert((idx>=0) and (idx < MeshesCount()), 'Invalid mesh id');
  result:=_meshes[idx];
end;

function TModel.GetSkeleton(): TSkeleton;
begin
  result:=_skeleton;
end;

destructor TModel.Destroy();
begin
  Reset();
  inherited Destroy();
end;

procedure TModel.Reset();
var
  i:integer;
begin
  for i:=0 to length(_meshes)-1 do begin
    _meshes[i].Free;
  end;
  SetLength(_meshes, 0);
  FreeAndNil(_skeleton);
end;

function TModel.TotalVertsCount(): cardinal;
var
  i:integer;
begin
  result:=0;
  for i:=0 to MeshesCount()-1 do begin
    result:=result+cardinal(GetMesh(i).v_count());
  end;
end;

function TModel.TotalPolysCount(): cardinal;
var
  i:integer;
begin
  result:=0;
  for i:=0 to MeshesCount()-1 do begin
    result:=result+cardinal(GetMesh(i).p_count());
  end;
end;

procedure ExportModelToMs3DAsciiFile(model: TModel; fname: string);
var
  fout:textfile;
  i, j, k, id:integer;
  v:TVertex;
  p:TPoly;
  b:TBone;
  s:string;
  tmp_f:single;
begin
  s:='// MilkShape 3D ASCII'+chr($0d)+chr($0a)+chr($0d)+chr($0a);
  s:=s+'Frames: 30'+chr($0d)+chr($0a);
  s:=s+'Frame: 1'+chr($0d)+chr($0a)+chr($0d)+chr($0a);
  s:=s+'Meshes: '+inttostr(model.MeshesCount())+chr($0d)+chr($0a);

  for i:=0 to model.MeshesCount()-1 do begin
    s:=s+'"'+inttostr(i)+'_'+model.GetMesh(i).name_get()+'" 0 '+inttostr(i)+chr($0d)+chr($0a);
    s:=s+inttostr(model.GetMesh(i).v_count())+chr($0d)+chr($0a);
    for j:=0 to model.GetMesh(i).v_count()-1 do begin
      v:=model.GetMesh(i).v_get(j);

      id:=-1;
      tmp_f:=0;
      for k:=0 to v.bone_counts-1 do begin
        if v.bone_weights[k] > tmp_f then begin
          id:=k;
          tmp_f:=v.bone_weights[k];
        end;
      end;
      s:=s+'0 '+floattostr(v.pos.x)+' '+floattostr(v.pos.y)+' '+floattostr(v.pos.z)+' '+floattostr(v.u)+' '+floattostr(v.v)+' '+inttostr(v.bone_ids[id])+chr($0d)+chr($0a);
    end;

    s:=s+'1'+chr($0d)+chr($0a); //normals count
    s:=s+'0.000000 0.000000 1.000000'+chr($0d)+chr($0a); //normals data
    s:=s+inttostr(model.GetMesh(i).p_count())+chr($0d)+chr($0a);
    for j:=0 to model.GetMesh(i).p_count()-1 do begin
      p:=model.GetMesh(i).p_get(j);
      s:=s+'0 '+inttostr(p.v1)+' '+inttostr(p.v2)+' '+inttostr(p.v3)+' 0 0 0 1'+chr($0d)+chr($0a);
    end;
  end;

  s:=s+chr($0d)+chr($0a);
  s:=s+'Materials: '+inttostr(model.MeshesCount())+chr($0d)+chr($0a);
  for i:=0 to model.MeshesCount()-1 do begin
    s:=s+'"'+inttostr(i)+'_'+model.GetMesh(i).material_get()+'"'+chr($0d)+chr($0a);
    s:=s+'0.200000 0.200000 0.200000 1.000000'+chr($0d)+chr($0a);
    s:=s+'0.800000 0.800000 0.800000 1.000000'+chr($0d)+chr($0a);
    s:=s+'0.000000 0.000000 0.000000 1.000000'+chr($0d)+chr($0a);
    s:=s+'0.000000 0.000000 0.000000 1.000000'+chr($0d)+chr($0a);
    s:=s+'0.000000'+chr($0d)+chr($0a);
    s:=s+'1.000000'+chr($0d)+chr($0a);
    s:=s+'""'+chr($0d)+chr($0a);
    s:=s+'""'+chr($0d)+chr($0a);
  end;

  s:=s+chr($0d)+chr($0a);

  if model.GetSkeleton() = nil then begin
    s:=s+'Bones: 0'+chr($0d)+chr($0a);
  end else begin
    s:=s+'Bones: '+inttostr(model.GetSkeleton().BonesCount())+chr($0d)+chr($0a);
    for i:=0 to model.GetSkeleton().BonesCount()-1 do begin
      b:=model.GetSkeleton().GetBone(i);

      s:=s+'"'+b.name+'"'+chr($0d)+chr($0a);
      if b.parentid <0 then begin
        s:=s+'""'+chr($0d)+chr($0a);
      end else begin
        s:=s+'"'+model.GetSkeleton().GetBone(b.parentid).name+'"'+chr($0d)+chr($0a);
      end;
      s:=s+'0 '+floattostr(b.pos.x)+' '+floattostr(b.pos.y)+' '+floattostr(b.pos.z)+' '+floattostr(b.rot.x)+' '+floattostr(b.rot.y)+' '+floattostr(b.rot.z)+chr($0d)+chr($0a);
      s:=s+'0'+chr($0d)+chr($0a);
      s:=s+'0'+chr($0d)+chr($0a);
    end;
  end;


  s:=s+'GroupComments: 0'+chr($0d)+chr($0a);
  s:=s+'MaterialComments: 0'+chr($0d)+chr($0a);
  s:=s+'BoneComments: 0'+chr($0d)+chr($0a);
  s:=s+'ModelComment: 0'+chr($0d)+chr($0a);

  assignfile(fout, fname);
  rewrite(fout);
  writeln(fout, s);
  closefile(fout);
end;


procedure ExportModelToMs3DBinaryFile(model: TModel; fname: string);
var
  f:file;
  vertex_refs:array of byte;
  s:string;
  tmp_int:integer;
  tmp_word:word;
  tmp_byte:byte;
  tmp_float:single;
  tmp_str:string;
  tmp_char:char;

  i, j:integer;
  m:TMesh;
  p:TPoly;
  v:TVertex;
  b:TBone;
  cur_id, cnt:integer;
const
  MAX_VERTICES:cardinal=65534;
  MAX_TRIANGLES:cardinal=65534;
  MAX_GROUPS:cardinal=127;
  MAX_JOINTS:cardinal=127;
begin
  if cardinal(model.MeshesCount()) > MAX_GROUPS then begin
    raise Exception.Create('Model has too many meshes');
  end;

  if model.TotalVertsCount() > MAX_VERTICES then begin
    raise Exception.Create('Model has too many vertices');
  end;

  if model.TotalPolysCount() > MAX_TRIANGLES then begin
    raise Exception.Create('Model has too many polys');
  end;

  if (model.GetSkeleton() <> nil) and (cardinal(model.GetSkeleton().BonesCount()) > MAX_JOINTS) then begin
    raise Exception.Create('Model has too many bones');
  end;

  assignfile(f, fname);
  rewrite(f, 1);
  try
    s:='MS3D000000'; //header
    BlockWrite(f, s[1], length(s));
    tmp_int:=4; //header version
    BlockWrite(f, tmp_int, sizeof(tmp_int));

    //Calculate references for all vertices
    setlength(vertex_refs, model.TotalVertsCount());
    for i:=0 to model.MeshesCount()-1 do begin
      m:=model.GetMesh(i);
      for j:=0 to m.p_count()-1 do begin
        p:=m.p_get(j);

        if (vertex_refs[p.v1] = $FF) then begin
          raise Exception.Create('Model vertex #'+inttostr(p.v1)+' has to many references');
        end;
        vertex_refs[p.v1]:=vertex_refs[p.v1]+1;

        if (vertex_refs[p.v2] = $FF) then begin
          raise Exception.Create('Model vertex #'+inttostr(p.v2)+' has to many references');
        end;
        vertex_refs[p.v2]:=vertex_refs[p.v2]+1;

        if (vertex_refs[p.v3] = $FF) then begin
          raise Exception.Create('Model vertex #'+inttostr(p.v3)+' has to many references');
        end;
        vertex_refs[p.v3]:=vertex_refs[p.v3]+1;
      end;
    end;

    //Write vertices data
    tmp_word:=model.TotalVertsCount();
    BlockWrite(f, tmp_word, sizeof(tmp_word));

    cur_id:=0;
    for i:=0 to model.MeshesCount()-1 do begin
      m:=model.GetMesh(i);
      for j:=0 to m.v_count()-1 do begin
        v:=m.v_get(j);
        tmp_byte:=0;
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));  // flags

        tmp_float:=v.pos.x;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=v.pos.y;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=v.pos.z;
        BlockWrite(f, tmp_float, sizeof(tmp_float));

        if v.bone_counts > 0 then begin
          tmp_byte:=v.bone_ids[0];
        end else begin
          tmp_byte:=$FF;
        end;
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));
        BlockWrite(f, vertex_refs[cur_id], sizeof(vertex_refs[cur_id]));

        cur_id:=cur_id+1;
      end;
    end;
    setlength(vertex_refs, 0);

    //Write triangles data
    tmp_word:=model.TotalPolysCount();
    BlockWrite(f, tmp_word, sizeof(tmp_word));

    cnt:=0;
    for i:=0 to model.MeshesCount()-1 do begin
      m:=model.GetMesh(i);
      for j:=0 to m.p_count()-1 do begin
        p:=m.p_get(j);
        tmp_word:=0;
        BlockWrite(f, tmp_word, sizeof(tmp_word));  // flags

        // Indices
        tmp_word:=word(p.v1)+word(cnt);
        BlockWrite(f, tmp_word, sizeof(tmp_word));
        tmp_word:=word(p.v2)+word(cnt);
        BlockWrite(f, tmp_word, sizeof(tmp_word));
        tmp_word:=word(p.v3)+word(cnt);
        BlockWrite(f, tmp_word, sizeof(tmp_word));

        // Normal for 1st vertex
        tmp_float:=m.v_get(p.v1).norm.x;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=m.v_get(p.v1).norm.y;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=m.v_get(p.v1).norm.z;
        BlockWrite(f, tmp_float, sizeof(tmp_float));

        // Normal for 2nd vertex
        tmp_float:=m.v_get(p.v2).norm.x;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=m.v_get(p.v2).norm.y;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=m.v_get(p.v2).norm.z;
        BlockWrite(f, tmp_float, sizeof(tmp_float));

        // Normal for 3rd vertex
        tmp_float:=m.v_get(p.v3).norm.x;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=m.v_get(p.v3).norm.y;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=m.v_get(p.v3).norm.z;
        BlockWrite(f, tmp_float, sizeof(tmp_float));

        // U coordinates
        tmp_float:=m.v_get(p.v1).u;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=m.v_get(p.v2).u;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=m.v_get(p.v3).u;
        BlockWrite(f, tmp_float, sizeof(tmp_float));

        // V coordinates
        tmp_float:=m.v_get(p.v1).v;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=m.v_get(p.v2).v;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=m.v_get(p.v3).v;
        BlockWrite(f, tmp_float, sizeof(tmp_float));

        tmp_byte:=1; // Smoothing group
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));

        tmp_byte:=i; // Mesh group
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));
      end;
      cnt:=cnt+m.v_count();
    end;

    //Write groups data
    tmp_word:=model.MeshesCount();
    BlockWrite(f, tmp_word, sizeof(tmp_word));

    cnt:=0;
    for i:=0 to model.MeshesCount()-1 do begin
      m:=model.GetMesh(i);
      tmp_byte:=0;
      BlockWrite(f, tmp_byte, sizeof(tmp_byte));  // flags

      tmp_str:=inttostr(i)+'_'+m.name_get();
      for j:=1 to 32 do begin
        if (j<=length(tmp_str)) and (j<32) then begin
          tmp_char:=tmp_str[j];
        end else begin
          tmp_char:=chr($00);
        end;
        BlockWrite(f, tmp_char, sizeof(tmp_char));
      end;

      tmp_word:=m.p_count();
      BlockWrite(f, tmp_word, sizeof(tmp_word));
      for j:=0 to m.p_count()-1 do begin
        tmp_word:=cnt+j; // triangle index
        BlockWrite(f, tmp_word, sizeof(tmp_word));
      end;

      tmp_byte:=i;
      BlockWrite(f, tmp_byte, sizeof(tmp_byte));

      cnt:=cnt+m.p_count();
    end;

    //Write materials
    tmp_word:=model.MeshesCount();
    BlockWrite(f, tmp_word, sizeof(tmp_word));
    for i:=0 to model.MeshesCount()-1 do begin
      m:=model.GetMesh(i);

      //name
      tmp_str:=inttostr(i)+'_'+m.material_get();
      for j:=1 to 32 do begin
        if (j<=length(tmp_str)) and (j<32) then begin
          tmp_byte:=byte(tmp_str[j]);
        end else begin
          tmp_byte:=0;
        end;
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));
      end;

      //ambient
      tmp_float:=0.2;
      BlockWrite(f, tmp_float, sizeof(tmp_float));
      tmp_float:=0.2;
      BlockWrite(f, tmp_float, sizeof(tmp_float));
      tmp_float:=0.2;
      BlockWrite(f, tmp_float, sizeof(tmp_float));
      tmp_float:=1.0;
      BlockWrite(f, tmp_float, sizeof(tmp_float));

      //diffuse
      tmp_float:=0.8;
      BlockWrite(f, tmp_float, sizeof(tmp_float));
      tmp_float:=0.8;
      BlockWrite(f, tmp_float, sizeof(tmp_float));
      tmp_float:=0.8;
      BlockWrite(f, tmp_float, sizeof(tmp_float));
      tmp_float:=1.0;
      BlockWrite(f, tmp_float, sizeof(tmp_float));

      //specular
      tmp_float:=0.0;
      BlockWrite(f, tmp_float, sizeof(tmp_float));
      tmp_float:=0.0;
      BlockWrite(f, tmp_float, sizeof(tmp_float));
      tmp_float:=0.0;
      BlockWrite(f, tmp_float, sizeof(tmp_float));
      tmp_float:=1.0;
      BlockWrite(f, tmp_float, sizeof(tmp_float));

      //emissive
      tmp_float:=0.0;
      BlockWrite(f, tmp_float, sizeof(tmp_float));
      tmp_float:=0.0;
      BlockWrite(f, tmp_float, sizeof(tmp_float));
      tmp_float:=0.0;
      BlockWrite(f, tmp_float, sizeof(tmp_float));
      tmp_float:=1.0;
      BlockWrite(f, tmp_float, sizeof(tmp_float));

      //shininess
      tmp_float:=0.0;
      BlockWrite(f, tmp_float, sizeof(tmp_float));

      //transparency
      tmp_float:=1.0;
      BlockWrite(f, tmp_float, sizeof(tmp_float));

      //mode
      tmp_byte:=0;
      BlockWrite(f, tmp_byte, sizeof(tmp_byte));

      //texture
      tmp_byte:=0;
      for j:=1 to 128 do begin
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));
      end;

      //alphamap
      tmp_byte:=0;
      for j:=1 to 128 do begin
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));
      end;
    end;

    //fAnimationFPS
    tmp_float:=24;
    BlockWrite(f, tmp_float, sizeof(tmp_float));

    //fCurrentTime
    tmp_float:=1;
    BlockWrite(f, tmp_float, sizeof(tmp_float));

    //iTotalFrames
    tmp_float:=30;
    BlockWrite(f, tmp_float, sizeof(tmp_float));

    //Write skeleton
    if model.GetSkeleton() = nil then begin
      tmp_word:=0;
      BlockWrite(f, tmp_word, sizeof(tmp_word));
    end else begin
      tmp_word:=model.GetSkeleton().BonesCount();
      BlockWrite(f, tmp_word, sizeof(tmp_word));
      for i:=0 to model.GetSkeleton().BonesCount()-1 do begin
        b:=model.GetSkeleton().GetBone(i);
        tmp_byte:=0;
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));  // flags

        //name
        tmp_str:=b.name;
        for j:=1 to 32 do begin
          if (j<=length(tmp_str)) and (j<32) then begin
            tmp_byte:=byte(tmp_str[j]);
          end else begin
            tmp_byte:=0;
          end;
          BlockWrite(f, tmp_byte, sizeof(tmp_byte));
        end;

        //parent name
        if b.parentid<0 then begin
          tmp_str:='';
        end else begin
          tmp_str:=model.GetSkeleton().GetBone(b.parentid).name;
        end;
        for j:=1 to 32 do begin
          if (j<=length(tmp_str)) and (j<32) then begin
            tmp_byte:=byte(tmp_str[j]);
          end else begin
            tmp_byte:=0;
          end;
          BlockWrite(f, tmp_byte, sizeof(tmp_byte));
        end;

        //rotation
        tmp_float:=b.rot.x;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=b.rot.y;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=b.rot.z;
        BlockWrite(f, tmp_float, sizeof(tmp_float));

        //position
        tmp_float:=b.pos.x;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=b.pos.y;
        BlockWrite(f, tmp_float, sizeof(tmp_float));
        tmp_float:=b.pos.z;
        BlockWrite(f, tmp_float, sizeof(tmp_float));

        //numKeyFramesRot
        tmp_word:=0;
        BlockWrite(f, tmp_word, sizeof(tmp_word));

        //numKeyFramesTrans
        tmp_word:=0;
        BlockWrite(f, tmp_word, sizeof(tmp_word));
      end;
    end;

    //sub-version
    tmp_int:=1;
    BlockWrite(f, tmp_int, sizeof(tmp_int));

    //Number of group comments
    tmp_int:=0;
    BlockWrite(f, tmp_int, sizeof(tmp_int));

    //Number of material comments
    tmp_int:=0;
    BlockWrite(f, tmp_int, sizeof(tmp_int));

    //Number of joint comments
    tmp_int:=0;
    BlockWrite(f, tmp_int, sizeof(tmp_int));

    //Model comments presence
    tmp_int:=0;
    BlockWrite(f, tmp_int, sizeof(tmp_int));

    //vertex comments sub-version
    tmp_int:=2;
    BlockWrite(f, tmp_int, sizeof(tmp_int));

    for i:=0 to model.MeshesCount()-1 do begin
      m:=model.GetMesh(i);
      for j:=0 to m.v_count()-1 do begin
        v:=m.v_get(j);

        if v.bone_counts > 1 then begin
          tmp_byte:=v.bone_ids[1];
        end else begin
          tmp_byte:=$FF;
        end;
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));

        if v.bone_counts > 2 then begin
          tmp_byte:=v.bone_ids[2];
        end else begin
          tmp_byte:=$FF;
        end;
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));

        if v.bone_counts > 3 then begin
          tmp_byte:=v.bone_ids[3];
        end else begin
          tmp_byte:=$FF;
        end;
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));

        tmp_byte:=floor(v.bone_weights[0] * 100);
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));
        tmp_byte:=floor(v.bone_weights[1] * 100);
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));
        tmp_byte:=floor(v.bone_weights[2] * 100);
        BlockWrite(f, tmp_byte, sizeof(tmp_byte));

        tmp_int:=0;
        BlockWrite(f, tmp_int, sizeof(tmp_int));
      end;
    end;

  finally
    closefile(f);
    setlength(vertex_refs, 0);
  end;
end;

end.

