unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Gorilla.Viewport, FMX.Controls3D, Gorilla.Control, Gorilla.Transform,
  Gorilla.Mesh, Gorilla.Cube, Gorilla.SkyBox, Gorilla.Physics, Gorilla.Model,
  Gorilla.Prefab, FMX.Types3D, System.Math.Vectors, Gorilla.Light,
  FMX.MaterialSources, Gorilla.Material.Default, Gorilla.Material.POM,
  Gorilla.Material.PBR, Gorilla.Cone, Gorilla.Physics.Q3.Body, Gorilla.Physics.Q3.Contact,
  System.Diagnostics,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects3D, Gorilla.Camera,
  Gorilla.Particle.Influencer, Gorilla.Particle.Emitter,
  Gorilla.Material.Particle, FMX.Ani, Gorilla.Controller,
  Gorilla.Controller.Passes.Environment, Gorilla.Plane, Gorilla.Material.Blinn,
  Gorilla.Sphere, FMX.Objects, Gorilla.Audio.FMOD, Gorilla.Audio.FMOD.Intf.Sound,
  Gorilla.Audio.FMOD.Intf.Channel, Gorilla.Particle.Explosion;

const
  // Number of obstacles in scene per row
  OBSTACLES = 10;
  // Basic size value of obstacles
  OBSTACLE_SIZE = 0.5;
  // Obstacle movement speed factor
  OBSTACLE_SPEED = 0.25;
  // Width of scene to place obstacles into
  SCENE_WIDTH = 100;

  // For Debugging: Show physics colliders
  SHOW_PHYSICS_COLLIDERS = false;

  // Max. LifeTime
  LIFETIME_START = 100;
  FUEL_START = 1000;

type
  TForm1 = class(TForm)
    GorillaViewport1: TGorillaViewport;
    GorillaSkyBox1: TGorillaSkyBox;
    GorillaPhysicsSystem1: TGorillaPhysicsSystem;
    GorillaPrefabSystem1: TGorillaPrefabSystem;
    Rocketship: TGorillaModel;
    GorillaLight1: TGorillaLight;
    TopBar: TGorillaCube;
    GorillaPBRMaterialSource1: TGorillaPBRMaterialSource;
    BottomBar: TGorillaCube;
    GorillaPBRMaterialSource2: TGorillaPBRMaterialSource;
    Timer1: TTimer;
    Button1: TButton;
    RenderPhysics: TDummy;
    GorillaCamera1: TGorillaCamera;
    RocketShipGroup: TDummy;
    FloatAnimation1: TFloatAnimation;
    GorillaRenderPassEnvironment1: TGorillaRenderPassEnvironment;
    FlamePlane: TGorillaPlane;
    GorillaBlinnMaterialSource1: TGorillaBlinnMaterialSource;
    Obstacle: TGorillaSphere;
    LifeTimeBackground: TRoundRect;
    Status: TRectangle;
    LifeTime: TRoundRect;
    LifeTimeLabel: TLabel;
    FuelBackground: TRoundRect;
    Fuel: TRoundRect;
    FuelLabel: TLabel;
    Astroid: TGorillaSphere;
    GorillaFMODAudioManager1: TGorillaFMODAudioManager;
    BoostBackground: TRoundRect;
    Boost: TRoundRect;
    Menu: TRectangle;
    Label1: TLabel;
    ColorAnimation1: TColorAnimation;
    ColorAnimation2: TColorAnimation;
    ColorAnimation3: TColorAnimation;
    ColorAnimation4: TColorAnimation;
    ColorAnimation5: TColorAnimation;
    Diamond: TGorillaSphere;
    DiamondMaterialSource: TGorillaBlinnMaterialSource;
    ColorAnimation6: TColorAnimation;
    Label2: TLabel;

    /// Create / Prepare all necessary things
    procedure FormCreate(Sender: TObject);
    /// On closing application stop all things
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    /// Moving astroids and objects around rocketship
    procedure Timer1Timer(Sender: TObject);
    /// Start button click
    procedure Button1Click(Sender: TObject);
    /// User control by keyboard
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    /// Render physics colliders
    procedure RenderPhysicsRender(Sender: TObject; Context: TContext3D);
    /// Collision detected
    procedure GorillaPhysicsSystem1BeginContact(
      const AContact: PQ3ContactConstraint; const ABodyA, ABodyB: TQ3Body);
  private
    FColliders : TArray<TQ3Body>;
    FStopWatch : TStopWatch;
    FLastTick  : Int64;
    FFlyTime   : Int64;
    FLifeTime  : Integer;
    FFuel      : Integer;
    FSpeed     : Single;

    FBoostChannel : IGorillaFMODChannel;
    FBoostSound   : IGorillaFMODSound;

    FCrashChannel : IGorillaFMODChannel;
    FCrashSound   : IGorillaFMODSound;

    FSpaceSound   : IGorillaFMODSound;
    FMusic        : IGorillaFMODSound;

    FDiamond1Sound,
    FDiamond2Sound: IGorillaFMODSound;

    /// <summary>
    /// Prepare diamond instance
    /// </summary>
    procedure CreateDiamond();
    /// <summary>
    /// Setup and initialize top and bottom row astroid obstacles, incl. physics
    /// colliders.
    /// </summary>
    procedure CreateObstacles();
    /// <summary>
    /// Move top/bottom row obstacles around the rocket-ship
    /// </summary>
    procedure MoveObstacles();
    /// <summary>
    /// Initialize a new astroid.
    /// </summary>
    procedure ThrowAstroid();
    /// <summary>
    /// Initialize a new diamond.
    /// </summary>
    procedure ThrowDiamond();
    /// <summary>
    /// Start the game.
    /// </summary>
    procedure Start();

    /// <summary>
    /// Reduce / add lifetime and show the current status in a progress bar (top center).
    /// </summary>
    procedure AdjustLifeTimeBar(AInc : Integer);
    /// <summary>
    /// Reduce / add fuel and show the current status in a progress bar (top left).
    /// </summary>
    procedure AdjustFuelBar(AInc : Integer);
    /// <summary>
    /// Display the current boosting status taken from rigid body of the rocketship
    /// and getting displayed in a progress bar on the right side.
    /// </summary>
    procedure AdjustBoostBar();
    /// <summary>
    /// Main handling routine to stop the game.
    /// </summary>
    procedure DoOnEndOfGame();
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Math, System.TypInfo,
  Gorilla.Utils.Math,
  Gorilla.Audio.FMOD.Lib.Common,
  Gorilla.Physics.Q3.Collide,
  Gorilla.Physics.Q3.Collider,
  Gorilla.Physics.Q3.Collider.Box,
  Gorilla.Physics.Q3.Collider.Sphere,
  Gorilla.Physics.Q3.Collider.Capsule,
  Gorilla.Physics.Q3.Collider.Mesh,
  Gorilla.Physics.Q3.Matrices,
  Gorilla.Physics.Q3.Transform,
  Gorilla.Physics.Q3.Renderer,
  Gorilla.DefTypes;

type
  /// <summary>
  /// Create a helper class to access protected methods for adding colliders.
  /// Default methods only handle TControl3D instances, but we
  /// want to add colliders dynamically for our virtual instances (TGorillaMeshInstance).
  /// </summary>
  TGorillaPhysicsHelper = class helper for TGorillaPhysicsSystem
    public
      procedure AddInstanceCollider(const ATemplate : TMeshDef;
        const AData: TGorillaMeshInstance; const APrefab: TGorillaColliderSettings;
        const AAbsoluteMatrix: TMatrix3D; const ASize: TPoint3D; const AFlipData : Boolean;
        out ABody: TQ3Body);
  end;

{ TGorillaPhysicsHelper }

procedure TGorillaPhysicsHelper.AddInstanceCollider(const ATemplate : TMeshDef;
  const AData: TGorillaMeshInstance; const APrefab: TGorillaColliderSettings;
  const AAbsoluteMatrix: TMatrix3D; const ASize: TPoint3D; const AFlipData : Boolean;
  out ABody: TQ3Body);
var LTransform : TMatrix3D;
begin
  // Get the translation from absolute instance matrix
  LTransform := TMatrix3D.CreateTranslation(
    TTransformationMatrixUtils.GetTranslationFromTransformationMatrix(AAbsoluteMatrix)
    );

  // Add a sphere collider for each instance with the maximum size of a side as radius
  DoAddSphereCollider(AData, TypeInfo(TGorillaMeshInstance), APrefab,
    LTransform, Max(ASize.X, Max(ASize.Y, ASize.Z)), ABody);
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var LCollider : TGorillaColliderSettings;
    LPath : String;
begin
  // Generate a global random seed
  Randomize();

  // For debugging with increase shift intensity for faster movement in 3D-Space
  GorillaViewport1.GetDesignCameraController().ShiftIntensity := 5;

  // Activate Bloom effect for emissive coloring
  GorillaViewport1.EmissiveBlur := 3;

  // Activate Global Illumination for shadowing (only for better GPUs)
//  GorillaViewport1.GlobalIllumDetail := 3;
//  GorillaViewport1.GlobalIllumSoftness := 3;
//  GorillaViewport1.ShadowStrength := 1;

  // Activate environment mapping for rocket ship pbr materials
  GorillaRenderPassEnvironment1.IsDynamic := true;
  GorillaRenderPassEnvironment1.Target := RocketShip;
  GorillaRenderPassEnvironment1.Enabled := true;
  RocketShip.SetEnvironmentMapping(GorillaRenderPassEnvironment1, 1, 0);

  // Disable frustum culling for our obstacle template
  Obstacle.FrustumCullingCheck := false;

  // Let's create a stop watch for cpu-independent movement of obstacles
  FStopWatch := TStopWatch.Create();

  //
  // SETUP ROCKET SHIP PHYSICS
  //

  // Add physics collider for starship
  LCollider := TGorillaColliderSettings.Create(TQ3BodyType.eDynamicBody);

  // Our starship has a few submeshes! We want the complete mesh!
  LCollider.AllowSubColliders := false;

  // Because the world around the spaceship only move, we don't need x-axis/z-axis movement
  LCollider.LockMoveAxisX := true;
  LCollider.LockMoveAxisZ := true;

  // Lock rotation axis
  LCollider.LockRotAxisX := true;
  LCollider.LockRotAxisY := true;

  // Add a box collider for the starship
  GorillaPhysicsSystem1.AddBoxCollider(RocketShipGroup, LCollider);

  // Link the color animation (on collision) to the material of the rocketship
  ColorAnimation4.Parent := RocketShip.Meshes[0].MaterialSource;
  ColorAnimation4.PropertyName := 'Emissive';

  // Link the color animation (on destruction) to the material of the rocketship
  ColorAnimation5.Parent := RocketShip.Meshes[0].MaterialSource;
  ColorAnimation5.PropertyName := 'Emissive';

  //
  // INITIALIZE OBSTACLES BY INSTANCE RENDERING
  //
  CreateObstacles();
  CreateDiamond();

  //
  // PREPARE MUSIC / AUDIO
  //
{$IFDEF MSWINDOWS}
  LPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    IncludeTrailingPathDelimiter('assets') +
    IncludeTrailingPathDelimiter('audio');
{$ELSE}
  LPath := IncludeTrailingPathDelimiter(TPath.GetHomePath());
{$ENDIF}
  // Directly play background space sound
  FSpaceSound := GorillaFMODAudioManager1.LoadSoundFromFile(LPath + '670700__matrixxx__space-atmosphere-02-remastered.wav');
  FSpaceSound.Mode := FMOD_LOOP_NORMAL;
  GorillaFMODAudioManager1.PlaySound(FSpaceSound);

  // Directly play background music
  FMusic := GorillaFMODAudioManager1.LoadSoundFromFile(LPath + 'dark-matter-10710.mp3');
  FMusic.Mode := FMOD_LOOP_NORMAL;
  GorillaFMODAudioManager1.PlaySound(FMusic);

  // Prepare boost sound
  FBoostSound := GorillaFMODAudioManager1.LoadSoundFromFile(LPath + '521377__jarusca__rocket-launch.mp3');

  // Prepare crash sound
  FCrashSound := GorillaFMODAudioManager1.LoadSoundFromFile(LPath + '321143__rodincoil__concrete-and-glass-breaking-in-dumpster.wav');

  // Prepare diamond #1/#2 sound
  FDiamond1Sound := GorillaFMODAudioManager1.LoadSoundFromFile(LPath + '171639__leszek_szary__scale-d6.wav');
  FDiamond2Sound := GorillaFMODAudioManager1.LoadSoundFromFile(LPath + '171646__leszek_szary__scale-e6.wav');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Stop obstacle movement
  Timer1.Enabled := false;

  // Stop all audio
  // Clear audio interfaces
  FBoostChannel := nil;
  FCrashChannel := nil;

  FBoostSound := nil;
  FCrashSound := nil;
  FDiamond1Sound := nil;
  FDiamond2Sound := nil;
  FSpaceSound := nil;
  FMusic := nil;

  GorillaFMODAudioManager1.StopAllChannels();
  GorillaFMODAudioManager1.ClearSounds();

  // Stop physics simulation
  GorillaPhysicsSystem1.Active := false;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
var LRigidBody : TQ3Body;
    LAngles    : TPoint3D;
    LBoosted   : Boolean;
begin
  // Only move rocket ship if physics is active
  if not GorillaPhysicsSystem1.Active then
    Exit;

  LBoosted := false;

  // On "w" we move updwards, on "s" we move downwards
  case KeyChar of
    'w' : begin
            // move up
            GorillaPhysicsSystem1.RemoteBodyForce(RocketShipGroup, Point3D(0, -1, 0) * 50, true);
            LBoosted := true;
          end;

    's' : begin
            // move down
            GorillaPhysicsSystem1.RemoteBodyForce(RocketShipGroup, Point3D(0, 1, 0) * 50, true);
            LBoosted := true;
          end;
  end;

{$IFDEF MSWINDOWS}
  // For Windows we do also support navigation by cursor-up / cursor-down keys
  case Key of
    $26 : begin
            // move up
            GorillaPhysicsSystem1.RemoteBodyForce(RocketShipGroup, Point3D(0, -1, 0) * 50, true);
            LBoosted := true;
          end;

    $28 : begin
            // move down
            GorillaPhysicsSystem1.RemoteBodyForce(RocketShipGroup, Point3D(0, 1, 0) * 50, true);
            LBoosted := true;
          end;
  end;
{$ENDIF}

  if not LBoosted then
    Exit;

  // Reduce fuel on boost
  AdjustFuelBar(-1);

  // Let the rocketship flame burn
  ColorAnimation3.Enabled := true;
  ColorAnimation3.Start;

  // To get more control on the rocket again, after it crashed against an astroid
  // we should also rotate to normal angle again
  LRigidBody := RocketShipGroup.TagObject as TQ3Body;
  if not Assigned(LRigidBody) then
    Exit;

  // Get rotation of the rocketship to detect, if it needs to be adjusted
  LAngles := TRotationMatrixUtils.RotationMatrixToEulerianAngles(
    LRigidBody.GetTransformRef()^.Rotation.ToMatrix, TRotationOrder.EULER_XYZ);

  // If rotation is larger than 1 degree on z-axis, we should start to adjust
  if Abs(LAngles.Z) > 1 then
  begin
    // We adjust by angular velocity for a smooth adjustment, instead of
    // setting rotation hard to zero degree
    GorillaPhysicsSystem1.RemoteBodyAngularVelocity(LRigidBody,
      Point3D(0, 0, DegToRad(-LAngles.Z)) );
  end;

  // Play boost sound but only limited times, to prevent robotic sound
  if not ( Assigned(FBoostChannel) and (FBoostChannel.IsPlaying) ) then
  begin
    // Only play, if not already playing
    FBoostChannel := GorillaFMODAudioManager1.PlaySound(FBoostSound, nil, false);
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // Move obstacle instances to simulate movement
  MoveObstacles();

  // Show used boost value
  AdjustBoostBar();

  // Increase time flied
  Inc(FFlyTime, 1);
  if (FFlyTime mod 10 = 0) then
  begin
    // increas speed in regular steps
    FSpeed := FSpeed + 0.01;
    FSpeed := Min(1.5, FSpeed);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Start();
end;

procedure TForm1.RenderPhysicsRender(Sender: TObject; Context: TContext3D);
var LRender : TQ3Render;
begin
  if not SHOW_PHYSICS_COLLIDERS then
    Exit;

  // Here we render physics colliders for debugging
  LRender.Context := Context;
  GorillaPhysicsSystem1.Engine.Render(@LRender);
end;

procedure TForm1.GorillaPhysicsSystem1BeginContact(
  const AContact: PQ3ContactConstraint; const ABodyA, ABodyB: TQ3Body);
begin
  // Only check collisions if physics is activated.
  if not GorillaPhysicsSystem1.Active then
    Exit;

  // Notify collision between the rocket ship and obstacle colliders
  if not Assigned(AContact) then
    Exit;

  if not (Assigned(ABodyA) and Assigned(ABodyB)) then
    Exit;

  // Collision detection between astroids and diamonds
  if ((ABodyA = RocketShipGroup.TagObject) and (ABodyB = Diamond.TagObject))
  or ((ABodyB = RocketShipGroup.TagObject) and (ABodyA = Diamond.TagObject)) then
  begin
    // Diamond collision detected - collect lifetime / fuel - depending on the type
    case Diamond.Tag of
      // fuel diamond
      1 : begin
            Self.GorillaFMODAudioManager1.PlaySound(FDiamond1Sound, nil, false);
            Self.AdjustFuelBar(10 + Random(100));
          end;
      // lifetime diamond
      else
          begin
            Self.GorillaFMODAudioManager1.PlaySound(FDiamond2Sound, nil, false);
            Self.AdjustLifeTimeBar((1 + Random(3)) * 10);
          end;
    end;

    // Create a new diamond of random type
    Self.ThrowDiamond();
  end
  else if (ABodyA = RocketShipGroup.TagObject) or (ABodyB = RocketShipGroup.TagObject) then
  begin
    // Collision with top/bottom astroids - reduce life time by 10
    // or collision with single astroids
    if (ABodyA = Astroid.TagObject) or (ABodyB = Astroid.TagObject) then
      Self.AdjustLifeTimeBar(-5)
    else
      Self.AdjustLifeTimeBar(-10);

    // Playback color animation on rocketship
    ColorAnimation4.Enabled := true;
    ColorAnimation4.Start;

    // Play crash sound, but only limited times, to prevent robotic sound
    if not ( Assigned(FCrashChannel) and (FCrashChannel.IsPlaying) ) then
    begin
      // Only play, if not already playing
      FCrashChannel := GorillaFMODAudioManager1.PlaySound(FCrashSound, nil, false);
    end;
  end;
end;

procedure TForm1.ThrowAstroid();
var LPos : TPoint3D;
begin
  if Random(2) = 0 then
    LPos := Point3D(50 + (25 * (1.5 - FSpeed)) + Random(25), Random(10), 0)
  else
    LPos := Point3D(50 + (25 * (1.5 - FSpeed)) + Random(25), -Random(10), 0);

  Astroid.Position.Point := LPos;
  GorillaPhysicsSystem1.RemoteBodyTransform(Astroid, LPos, TPoint3D.Zero);
end;

procedure TForm1.CreateDiamond();
begin
  // Set opacity for diamond template body
  Diamond.SetOpacityValue(0.75);
end;

procedure TForm1.ThrowDiamond();
var LPos : TPoint3D;
begin
  // diamonds for lifetime or fuel
  if Random(3) = 0 then
  begin
    // lifetime diamond
    Diamond.Tag := 0;
    DiamondMaterialSource.Emissive := $40FF7F50;
    ColorAnimation6.StartValue := $40FFFF00;
    ColorAnimation6.StopValue := $FFFFFF00;
  end
  else
  begin
    // fuel diamond
    Diamond.Tag := 1;
    DiamondMaterialSource.Emissive := $4000FFFF;
    ColorAnimation6.StartValue := $4000FFFF;
    ColorAnimation6.StopValue := $FF00FFFF;
  end;

  if Random(2) = 0 then
    LPos := Point3D(50 + (25 * (1.75 - FSpeed)) + Random(25), Random(10), 0)
  else
    LPos := Point3D(50 + (25 * (1.75 - FSpeed)) + Random(25), -Random(10), 0);

  Diamond.Position.Point := LPos;
  GorillaPhysicsSystem1.RemoteBodyTransform(Diamond, LPos, TPoint3D.Zero);
end;

procedure TForm1.CreateObstacles();
var LObstacles,
    LCellCount,
    LCellIdx,
    I, LIdx   : Integer;
    LCells    : TArray<Integer>;
    LBaseTransf : TMatrix3D;
    LInstance : TGorillaMeshInstance;
    LSceneWidth,
    LHalfSceneWidth,
    LCellSize,
    LXOfs     : Single;
    LSize,
    LScale    : TPoint3D;
    LCollider : TGorillaColliderSettings;
    LRigidBody: TQ3Body;
begin
  // Prepare physics colliders
  System.SetLength(FColliders, OBSTACLES * 2);

  // Move the obstacle template out of screen, because we only want to display
  // instances
  Obstacle.Position.Y := 50;

  // Setup a basic transform for all instances
  LBaseTransf := TMatrix3D.Identity;

  // Clear all instances
  Obstacle.Instances.ClearInstances();

  // Get size of the obstacle
  LSize := Point3D(Obstacle.Width, Obstacle.Height, Obstacle.Depth);

  // We split width of the scene into parts for a better distribution of obstacles
  LObstacles  := OBSTACLES;
  LCellCount  := LObstacles;
  LSceneWidth := SCENE_WIDTH;
  LHalfSceneWidth := LSceneWidth / 2;
  LCellSize := LSceneWidth / (LCellCount);

  // Top row instancing
  System.SetLength(LCells, 0);
  System.SetLength(LCells, LCellCount);
  for I := 1 to LObstacles do
  begin
    // Add a new instance item in top row
    LIdx := Obstacle.AddInstanceItem(Format('TopObstacle%d', [I]), LBaseTransf);
    LInstance := Obstacle.Instances.Items[LIdx] as TGorillaMeshInstance;

    repeat
      LCellIdx := Random(LCellCount);
    until (LCells[LCellIdx] = 0);
    LCells[LCellIdx] := LCellIdx;

    LXOfs := LCellIdx * LCellSize;
    LInstance.Position.Point := Point3D(-LHalfSceneWidth + LXOfs, -20, 0);

    LInstance.ResetRotationAngle();
    LInstance.RotationAngle.Point := Point3D(0, 0, Random(360));

    LScale := LSize * (OBSTACLE_SIZE + (Random(100) / 100));
    LInstance.Scale.Point := LScale;

    // Add physics collider and rigid body
    LCollider := TGorillaColliderSettings.Create(TQ3BodyType.eStaticBody);
    GorillaPhysicsSystem1.AddInstanceCollider((Self.Obstacle.Def as TMeshDef),
      LInstance, LCollider, LInstance.Transform, LScale, false, LRigidBody);

    FColliders[I-1] := LRigidBody;
  end;

  // Bottom row instancing
  System.SetLength(LCells, 0);
  System.SetLength(LCells, LCellCount);
  for I := 1 to LObstacles do
  begin
    // Add a new instance item in bottom row
    LIdx := Obstacle.AddInstanceItem(Format('BottomObstacle%d', [I]), LBaseTransf);
    LInstance := Obstacle.Instances.Items[LIdx] as TGorillaMeshInstance;

    repeat
      LCellIdx := Random(LCellCount);
    until (LCells[LCellIdx] = 0);
    LCells[LCellIdx] := LCellIdx;

    LXOfs := LCellIdx * LCellSize;
    LInstance.Position.Point := Point3D(-LHalfSceneWidth + LXOfs, 20, 0);

    LInstance.ResetRotationAngle();
    LInstance.RotationAngle.Point := Point3D(0, 0, Random(360));

    LScale := LSize * (OBSTACLE_SIZE + (Random(100) / 100));
    LInstance.Scale.Point := LScale;

    // Add physics collider and rigid body
    LCollider := TGorillaColliderSettings.Create(TQ3BodyType.eStaticBody);
    GorillaPhysicsSystem1.AddInstanceCollider((Self.Obstacle.Def as TMeshDef),
      LInstance, LCollider, LInstance.Transform, LScale, true, LRigidBody);

    FColliders[I+9] := LRigidBody;
  end;
end;

procedure TForm1.MoveObstacles();
var I          : Integer;
    LSpeed,
    LXOfs      : Single;
    LObstacles : Integer;
    LInstance  : TGorillaMeshInstance;
    LSize,
    LScale     : TPoint3D;
    LCollider  : TGorillaColliderSettings;
    LRigidBody : TQ3Body;
    LCurrTick  : Int64;
begin
  LObstacles  := OBSTACLES;

  // Get size of the obstacle
  LSize := Point3D(Obstacle.Width, Obstacle.Height, Obstacle.Depth);

  // Calculate a CPU independent obstacle movement speed
  LCurrTick := FStopWatch.ElapsedMilliseconds;
  LXOfs := (Abs(LCurrTick - FLastTick) / 1000) * FSpeed;
  LXOfs := Max(0.1, Max(0.5, LXOfs));
  FLastTick := LCurrTick;

  Obstacle.Instances.BeginUpdate();
  try
    // Move top row
    I := 0;
    repeat
      LInstance := Obstacle.Instances.Items[I] as TGorillaMeshInstance;
      LInstance.Position.Point := LInstance.Position.Point + Point3D(-LXOfs, 0, 0);

      // Check if out of range
      if LInstance.Position.Point.X < -50 then
      begin
        // Re-position
        LInstance.Position.X := 50;

        // Re-scale
        LScale := LSize * (OBSTACLE_SIZE + (Random(100) / 100));
        LInstance.Scale.Point := LScale;

        // Remove old collider, because size of the obstacle has changed
        GorillaPhysicsSystem1.RemoveCollider(FColliders[I]);

        // Add a new collider for this obstacle
        LCollider := TGorillaColliderSettings.Create(TQ3BodyType.eStaticBody);
        GorillaPhysicsSystem1.AddInstanceCollider((Self.Obstacle.Def as TMeshDef),
          LInstance, LCollider, LInstance.Transform, LScale, false, LRigidBody);

        FColliders[I] := LRigidBody;
      end;

      // Move physics collider
      GorillaPhysicsSystem1.RemoteBodyTransform(FColliders[I], LInstance.Position.Point,
        TPoint3D.Zero);

      Inc(I);
    until (I >= LObstacles);

    // Move bottom row
    repeat
      LInstance := Obstacle.Instances.Items[I] as TGorillaMeshInstance;
      LInstance.Position.Point := LInstance.Position.Point + Point3D(-LXOfs, 0, 0);

      // Check if out of range
      if LInstance.Position.Point.X < -50 then
      begin
        // Re-position
        LInstance.Position.X := 50;

        // re-scale
        LScale := LSize * (OBSTACLE_SIZE + (Random(100) / 100));
        LInstance.Scale.Point := LScale;

        // Remove old collider, because size of the obstacle has changed
        GorillaPhysicsSystem1.RemoveCollider(FColliders[I]);

        // Add a new collider for this obstacle
        LCollider := TGorillaColliderSettings.Create(TQ3BodyType.eStaticBody);
        GorillaPhysicsSystem1.AddInstanceCollider((Self.Obstacle.Def as TMeshDef),
          LInstance, LCollider, LInstance.Transform, LScale, true, LRigidBody);

        FColliders[I] := LRigidBody;
      end;

      // Move physics collider and flip around x-axis (only for bottom row)
      GorillaPhysicsSystem1.RemoteBodyTransform(FColliders[I], LInstance.Position.Point,
        TPoint3D.Zero);

      Inc(I);
    until (I >= (LObstacles * 2));
  finally
    Obstacle.Instances.EndUpdate();
  end;

  // After we have moved obstacles, we move Astroid and diamond
  // Caution: We use a slightly different speed for a more differential look
  if Astroid.Position.Point.X < -50 then
    Self.ThrowAstroid()
  else
  begin
    LSpeed := LXOfs * (1 + Random(50) / 100);
    Astroid.Position.Point := Astroid.Position.Point + Point3D(-LSpeed, 0, 0);
    GorillaPhysicsSystem1.RemoteBodyTransform(Astroid, Astroid.Position.Point,
      TPoint3D.Zero);
  end;

  if Diamond.Position.Point.X < -50 then
    Self.ThrowDiamond()
  else
  begin
    LSpeed := LXOfs * (1 + Random(50) / 100);
    Diamond.Position.Point := Diamond.Position.Point + Point3D(-LSpeed, 0, 0);
    GorillaPhysicsSystem1.RemoteBodyTransform(Diamond, Diamond.Position.Point,
      TPoint3D.Zero);
  end;
end;

procedure TForm1.Start();
begin
  // Prepare statistic values
  FLifeTime := LIFETIME_START;
  AdjustLifeTimeBar(0);

  FFuel := FUEL_START;
  AdjustFuelBar(0);

  FSpeed := OBSTACLE_SPEED;

  // Start time watching
  FStopWatch.Start();

  // Activate physics
  GorillaPhysicsSystem1.Active := true;

  // Reset rocketship to starting position
  RocketshipGroup.Position.Point := TPoint3D.Create(0, -5, 0);
  RocketshipGroup.ResetRotationAngle();
  GorillaPhysicsSystem1.RemoteBodyTransform(RocketshipGroup, Point3D(0, -5, 0), TPoint3D.Zero);

  // Throw the first astroid and first diamond
  ThrowAstroid();
  ThrowDiamond();

  // Start obstacle movement
  Timer1.Enabled := true;

  // Hide the menu
  Menu.Visible := false;
end;

procedure TForm1.AdjustLifeTimeBar(AInc : Integer);
var LRatio : Single;
    LWidth : Single;
begin
  // Inc / Dec lifetime value
  FLifeTime := FLifeTime + AInc;
  FLifeTime := Max(0, Min(LIFETIME_START, FLifeTime));

  LifeTimeLabel.Text := IntToStr(FLifeTime);

  // Calculate width of lifetime bar
  LRatio := FLifeTime / LIFETIME_START;
  LRatio := Max(0, Min(1, LRatio));
  LWidth := LifeTimeBackground.Width * LRatio;
  LifeTime.Width := LWidth;

  // Let the bar blink
  ColorAnimation1.Enabled := true;
  ColorAnimation1.Start;

  // Check for end of game
  if FLifeTime <= 0 then
    DoOnEndOfGame();
end;

procedure TForm1.AdjustFuelBar(AInc : Integer);
var LRatio : Single;
    LWidth : Single;
begin
  // Inc / Dec lifetime value
  FFuel := FFuel + AInc;
  FFuel := Max(0, Min(FUEL_START, FFuel));

  FuelLabel.Text := IntToStr(FFuel);

  // Calculate width of lifetime bar
  LRatio := FFuel / FUEL_START;
  LRatio := Max(0, Min(1, LRatio));
  LWidth := FuelBackground.Width * LRatio;
  Fuel.Width := LWidth;

  // Let the bar blink
  ColorAnimation2.Enabled := true;
  ColorAnimation2.Start;

  // Check for end of game
  if FFuel <= 0 then
    DoOnEndOfGame();
end;

procedure TForm1.AdjustBoostBar();
var LRigidBody : TQ3Body;
    LRatio     : Single;
    LHeight    : Single;
begin
  // Here we get the boost from linear velocity of the spaceship rigid body
  LRigidBody := RocketShipGroup.TagObject as TQ3Body;
  if not Assigned(LRigidBody) then
    Exit;

  // Calculate the ratio between 0.0 - 1.0
  LRatio := 1.0 - Min(1, (Abs(LRigidBody.LinearVelocity.Y) / 10));
  LRatio := Max(0, Min(1, LRatio));

  // And set the height of the bar
  LHeight := BoostBackground.Height * LRatio;
  Boost.Height := LHeight;
end;

procedure TForm1.DoOnEndOfGame();
begin
  // Playback color animation of destroyed rocketship
  ColorAnimation5.Enabled := true;
  ColorAnimation5.Start;

  // Stop obstacle movement
  Timer1.Enabled := false;

  // Show menu again
  Menu.Visible := true;
  Menu.BringToFront();

  // Stop physics
//  GorillaPhysicsSystem1.Active := false;

{$IFDEF MSWINDOWS}
  // Force to finish movement on physics
  Application.ProcessMessages();
{$ENDIF}
end;

end.
