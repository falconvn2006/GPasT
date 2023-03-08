unit Actor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grobal2, DxDraws, CliUtil, magiceff, Wil, ClFunc;

const
  MAXACTORSOUND = 3;
  CMMX = 150;
  CMMY = 200;

  HUMANFRAME = 920;
  WEAPONFRAME = 600;
  KILLERFRAME = 728;
  MONFRAME = 280;
  EXPMONFRAME = 360;
  SCULMONFRAME = 440;
  ZOMBIFRAME = 430;
  MERCHANTFRAME = 60;
  MAXSAY = 5;
  //   MON1_FRAME =
  //   MON2_FRAME =

  RUN_MINHEALTH = 10;
  DEFSPELLFRAME = 10;
  FIREHIT_READYFRAME = 6;  //염화결 시전 프래임
  MAGBUBBLEBASE = 3890;
  MAGBUBBLESTRUCKBASE = 3900;
  MAXWPEFFECTFRAME = 5;
  WPEFFECTBASE = 3750;
  EFFECTBASE   = 0;

type
  TActionInfo = record
    start:   word;              // 시작 프래임
    frame:   word;              // 프래임 갯수
    skip:    word;
    ftime:   word;              // 프래임 갯수
    usetick: byte;              // 사용틱, 이동 동작에만 사용됨
  end;
  PTActionInfo = ^TActionInfo;

  THumanAction = record
    ActStand:    TActionInfo;   //1
    ActWalk:     TActionInfo;   //8
    ActRun:      TActionInfo;   //8
    ActRushLeft: TActionInfo;
    ActRushRight: TActionInfo;
    ActWarMode:  TActionInfo;     //1
    ActHit:      TActionInfo;     //6
    ActHeavyHit: TActionInfo;     //6
    ActBigHit:   TActionInfo;     //6
    ActFireHitReady: TActionInfo; //6
    ActSpell:    TActionInfo;     //6
    ActSitdown:  TActionInfo;     //1
    ActStruck:   TActionInfo;     //3
    ActDie:      TActionInfo;     //4
    ActRide1: TActionInfo;
    ActRide2: TActionInfo;
    ActRide3: TActionInfo;
    ActRide4: TActionInfo;
    ActRide5: TActionInfo;

  end;
  PTHumanAction = ^THumanAction;

  TMonsterAction = record
    ActStand:    TActionInfo;   //1
    ActWalk:     TActionInfo;   //8
    ActAttack:   TActionInfo;   //6
    ActCritical: TActionInfo;   //6
    ActStruck:   TActionInfo;   //3
    ActDie:      TActionInfo;   //4
    ActDeath:    TActionInfo;
  end;
  PTMonsterAction = ^TMonsterAction;

const
  HA: THumanAction = (
    ActStand: (start: 0; frame: 4; skip: 4; ftime: 200; usetick: 0);
    ActWalk: (start: 64; frame: 6; skip: 2; ftime: 90; usetick: 2);
    ActRun: (start: 128; frame: 6; skip: 2; ftime: 120; usetick: 3);
    ActRushLeft: (start: 128; frame: 3; skip: 5; ftime: 120; usetick: 3);
    ActRushRight: (start: 131; frame: 3; skip: 5; ftime: 120; usetick: 3);
    ActWarMode: (start: 192; frame: 1; skip: 0; ftime: 200; usetick: 0);
    //ActHit:    (start: 200;    frame: 5;  skip: 3;  ftime: 140;  usetick: 0);
    ActHit: (start: 200; frame: 6; skip: 2; ftime: 85; usetick: 0);
    ActHeavyHit: (start: 264; frame: 6; skip: 2; ftime: 90; usetick: 0);
    ActBigHit: (start: 328; frame: 8; skip: 0; ftime: 70; usetick: 0);
    ActFireHitReady: (start: 192; frame: 6; skip: 4; ftime: 70; usetick: 0);
    ActSpell: (start: 392; frame: 6; skip: 2; ftime: 60; usetick: 0);
    ActSitdown: (start: 456; frame: 2; skip: 0; ftime: 300; usetick: 0);
    ActStruck: (start: 472; frame: 3; skip: 5; ftime: 70; usetick: 0);
    ActDie: (start: 536; frame: 4; skip: 4; ftime: 120; usetick: 0);
    ActRide1: (start: 600; frame: 4; skip: 4; ftime: 120; usetick: 0);
    ActRide2: (start: 664; frame: 8; skip: 0; ftime: 120; usetick: 0);
    ActRide3: (start: 728; frame: 6; skip: 2; ftime: 120; usetick: 0);
    ActRide4: (start: 792; frame: 3; skip: 6; ftime: 120; usetick: 0);
    ActRide5: (start: 856; frame: 6; skip: 3; ftime: 120; usetick: 0)

    );

  MA9: TMonsterAction = (  //축구공
    ActStand: (start: 0; frame: 1; skip: 7; ftime: 200; usetick: 0);
    ActWalk: (start: 64; frame: 6; skip: 2; ftime: 120; usetick: 3);
    ActAttack: (start: 64; frame: 6; skip: 2; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 64; frame: 6; skip: 2; ftime: 100; usetick: 0);
    ActDie: (start: 0; frame: 1; skip: 7; ftime: 140; usetick: 0);
    ActDeath: (start: 0; frame: 1; skip: 7; ftime: 0; usetick: 0);
    );
  MA10: TMonsterAction = (  //닭, 뭉코(8Frame짜리)
    ActStand: (start: 0; frame: 4; skip: 4; ftime: 200; usetick: 0);
    ActWalk: (start: 64; frame: 6; skip: 2; ftime: 120; usetick: 3);
    ActAttack: (start: 128; frame: 4; skip: 4; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 192; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 208; frame: 4; skip: 4; ftime: 140; usetick: 0);
    ActDeath: (start: 272; frame: 1; skip: 0; ftime: 0; usetick: 0);
    );
  MA11: TMonsterAction = (  //사슴(10Frame짜리)
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 120; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 140; usetick: 0);
    ActDeath: (start: 340; frame: 1; skip: 0; ftime: 0; usetick: 0);
    );
  MA12: TMonsterAction = (  //경비병, 때리는 속도 빠르다.
    ActStand: (start: 0; frame: 4; skip: 4; ftime: 200; usetick: 0);
    ActWalk: (start: 64; frame: 6; skip: 2; ftime: 120; usetick: 3);
    ActAttack: (start: 128; frame: 6; skip: 2; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 192; frame: 2; skip: 0; ftime: 150; usetick: 0);
    ActDie: (start: 208; frame: 4; skip: 4; ftime: 160; usetick: 0);
    ActDeath: (start: 272; frame: 1; skip: 0; ftime: 0; usetick: 0);
    );
  MA13: TMonsterAction = (  //식인초
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 10; frame: 8; skip: 2; ftime: 160;
    usetick: 0); //등장...
    ActAttack: (start: 30; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 110; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 130; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 20; frame: 9; skip: 0; ftime: 150;
    usetick: 0); //숨음..
    );
  MA14: TMonsterAction = (  //해골 오마
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 340; frame: 10; skip: 0; ftime: 100; usetick: 0);
    //백골인경우(소환)
    );
  MA15: TMonsterAction = (  //도끼던지는 오마
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 1; frame: 1; skip: 0; ftime: 100; usetick: 0);
    );
  MA16: TMonsterAction = (  //가스쏘는 구데기
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 160; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 4; skip: 6; ftime: 160; usetick: 0);
    ActDeath: (start: 0; frame: 1; skip: 0; ftime: 160; usetick: 0);
    );
  MA17: TMonsterAction = (  //바딱꺼리는 몹
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 60; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 100; usetick: 0);
    ActDeath: (start: 340; frame: 1; skip: 0; ftime: 140; usetick: 0);
    );
  MA19: TMonsterAction = (  //우면귀 (죽는거 빨리죽음)
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 140; usetick: 0);
    ActDeath: (start: 340; frame: 1; skip: 0; ftime: 140; usetick: 0);
    );
  MA20: TMonsterAction = (  //죽었다 살아나는 좀비)
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 100; usetick: 0);
    ActDeath: (start: 340; frame: 10; skip: 0; ftime: 170; usetick: 0);
    //다시 살아나기
    );
  MA21: TMonsterAction = (  //벌집
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 10; frame: 6; skip: 4; ftime: 120;
    usetick: 0); //벌 발사
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 20; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 30; frame: 10; skip: 0; ftime: 160; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );
  MA22: TMonsterAction = (  //석상몬스터(염소대장,염소장군)
    ActStand: (start: 80; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 160; frame: 6; skip: 4; ftime: 160; usetick: 3);
    ActAttack: (start: 240; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 320; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 340; frame: 10; skip: 0; ftime: 160; usetick: 0);
    ActDeath: (start: 0; frame: 6; skip: 4; ftime: 170;
    usetick: 0); //석상녹음
    );
  MA23: TMonsterAction = (  //주마왕
    ActStand: (start: 20; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 100; frame: 6; skip: 4; ftime: 160; usetick: 3);
    ActAttack: (start: 180; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 260; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 280; frame: 10; skip: 0; ftime: 160; usetick: 0);
    ActDeath: (start: 0; frame: 20; skip: 0; ftime: 100;
    usetick: 0); //석상녹음
    );
  MA24: TMonsterAction = (  //전갈, 공격 2가지
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 240; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActStruck: (start: 320; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 340; frame: 10; skip: 0; ftime: 140; usetick: 0);
    ActDeath: (start: 420; frame: 1; skip: 0; ftime: 140; usetick: 0);
    );
  MA25: TMonsterAction = (  //지네왕
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 70; frame: 10; skip: 0; ftime: 200; usetick: 3); //등장
    ActAttack: (start: 20; frame: 6; skip: 4; ftime: 120;
    usetick: 0); //직접공격
    ActCritical: (start: 10; frame: 6; skip: 4; ftime: 120; usetick: 0);
    //독침공격(원거리)
    ActStruck: (start: 50; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 60; frame: 10; skip: 0; ftime: 200; usetick: 0);
    ActDeath: (start: 80; frame: 10; skip: 0; ftime: 200; usetick: 3);
    );
  MA26: TMonsterAction = (  //성문,
    ActStand: (start: 0; frame: 1; skip: 7; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 160;
    usetick: 0); //등장...
    ActAttack: (start: 56; frame: 6; skip: 2; ftime: 500; usetick: 0); //열기
    ActCritical: (start: 64; frame: 6; skip: 2; ftime: 500; usetick: 0); //닫기
    ActStruck: (start: 0; frame: 4; skip: 4; ftime: 100; usetick: 0);
    ActDie: (start: 24; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 150;
    usetick: 0); //숨음..
    );
  MA27: TMonsterAction = (  //성벽
    ActStand: (start: 0; frame: 1; skip: 7; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 160;
    usetick: 0); //등장...
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 250; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 250; usetick: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 0; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 150; usetick: 0); //숨음..
    );
  MA28: TMonsterAction = (  //신수 (변신 전)
    ActStand: (start: 80; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 160; frame: 6; skip: 4; ftime: 160; usetick: 3);
    ActAttack: (start: 0; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 100;
    usetick: 0); //등장..
    );
  MA29: TMonsterAction = (  //신수 (변신 후)
    ActStand: (start: 80; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 160; frame: 6; skip: 4; ftime: 160; usetick: 3);
    ActAttack: (start: 240; frame: 6; skip: 4; ftime: 100; usetick: 0);
    ActCritical: (start: 0; frame: 10; skip: 0; ftime: 100; usetick: 0);
    ActStruck: (start: 320; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 340; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 100;
    usetick: 0); //등장..
    );

  MA30: TMonsterAction = (  //혈거인왕, 심장, 적월마
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 10; skip: 0; ftime: 200; usetick: 3);
    ActAttack: (start: 10; frame: 6; skip: 4; ftime: 120;
    usetick: 0); //공격폼
    ActCritical: (start: 10; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 20; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 30; frame: 20; skip: 0; ftime: 150; usetick: 0);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 200; usetick: 3);
    );
  MA31: TMonsterAction = (  //폭안거미
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 10; skip: 0; ftime: 200; usetick: 3);
    ActAttack: (start: 10; frame: 6; skip: 4; ftime: 120;
    usetick: 0); //공격폼
    ActCritical: (start: 0; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 0; frame: 2; skip: 8; ftime: 100; usetick: 0);
    ActDie: (start: 20; frame: 10; skip: 0; ftime: 200; usetick: 0);
    ActDeath: (start: 0; frame: 10; skip: 0; ftime: 200; usetick: 3);
    );
  MA32: TMonsterAction = (  //폭주
    ActStand: (start: 0; frame: 1; skip: 9; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 6; skip: 4; ftime: 200; usetick: 3);
    ActAttack: (start: 0; frame: 6; skip: 4; ftime: 120; usetick: 0); //공격폼
    ActCritical: (start: 0; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 0; frame: 2; skip: 8; ftime: 100; usetick: 0);
    ActDie: (start: 80; frame: 10; skip: 0; ftime: 80; usetick: 0);
    ActDeath: (start: 80; frame: 10; skip: 0; ftime: 200; usetick: 3);
    );
  MA33: TMonsterAction = (  //뢰혈사, 왕중앙 (주마본왕), 왕돈
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 200; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120;
    usetick: 0); //공격폼
    ActCritical: (start: 340; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 200; usetick: 0);
    ActDeath: (start: 260; frame: 10; skip: 0; ftime: 200; usetick: 0);
    );
  // 2003/02/11
  MA34: TMonsterAction = (  //해골반왕
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 200; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120;
    usetick: 0); //공격폼
    ActCritical: (start: 320; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 400; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 420; frame: 20; skip: 0; ftime: 200; usetick: 0);
    ActDeath: (start: 420; frame: 20; skip: 0; ftime: 200; usetick: 0);
    );
  MA50: TMonsterAction = (  //일반 NPC
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 30; frame: 10; skip: 0; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 0; usetick: 0);
    ActDie: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );
  MA51: TMonsterAction = (
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 30; frame: 20; skip: 0; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 0; usetick: 0);
    ActDie: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );
  MA52: TMonsterAction = (
    ActStand: (start: 30; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 30; frame: 4; skip: 6; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 0; usetick: 0);
    ActDie: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );
  // 2003/07/15 추가된 과거비천 몹
  MA53: TMonsterAction = (  //과거 비천 경비병, 때리는 속도 빠르다.
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 80; frame: 6; skip: 4; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDie: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );
  MA54: TMonsterAction = (  //마계석
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 300; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 10; frame: 6; skip: 4; ftime: 150; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 20; frame: 2; skip: 0; ftime: 150; usetick: 0);
    ActDie: (start: 30; frame: 10; skip: 0; ftime: 80; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );
  MA55: TMonsterAction = (  //오마패왕
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 250; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 210; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 110;
    usetick: 0); //공격폼
    ActCritical: (start: 580; frame: 20; skip: 0; ftime: 135; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 120; usetick: 0);
    ActDie: (start: 260; frame: 20; skip: 0; ftime: 130; usetick: 0);
    ActDeath: (start: 260; frame: 20; skip: 0; ftime: 130; usetick: 0);
    );
  MA56: TMonsterAction = ( //석상
    ActStand: (start: 0; frame: 2; skip: 8; ftime: 200; usetick: 0);
    ActWalk: (start: 0; frame: 2; skip: 8; ftime: 200; usetick: 0);
    ActAttack: (start: 0; frame: 2; skip: 8; ftime: 200; usetick: 0);
    ActCritical: (start: 0; frame: 2; skip: 8; ftime: 200; usetick: 0);
    ActStruck: (start: 0; frame: 2; skip: 8; ftime: 200; usetick: 0);
    ActDie: (start: 0; frame: 2; skip: 8; ftime: 200; usetick: 0);
    ActDeath: (start: 0; frame: 2; skip: 8; ftime: 200; usetick: 0);
    );
  MA57: TMonsterAction = (  // 도깨비불, 꽃눈
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 10; frame: 8; skip: 2; ftime: 160;
    usetick: 0); //등장...
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    //        ActDie:    (start: 30;     frame: 20; skip: 0;  ftime: 120;  usetick: 0); //꽃눈
    //        ActDeath:  (start: 30;     frame: 20; skip: 0;  ftime: 150;  usetick: 0);
    ActDie: (start: 30; frame: 10; skip: 0; ftime: 120;
    usetick: 0); //도깨비불
    ActDeath: (start: 30; frame: 10; skip: 0; ftime: 150; usetick: 0); //숨음..
    );
  MA58: TMonsterAction = (  // 월령(천녀)
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 160; usetick: 0);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 160; usetick: 0);
    ActCritical: (start: 160; frame: 6; skip: 4; ftime: 160; usetick: 0);
    // SM_LIGHTING(마법사용=>강격) 때 쓰임
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 150; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 340; frame: 10; skip: 0; ftime: 100; usetick: 0);
    );
  MA59: TMonsterAction = (  // FireDragon (화룡)
    ActStand: (start: 0; frame: 10; skip: 0; ftime: 300; usetick: 0);
    ActWalk: (start: 10; frame: 6; skip: 4; ftime: 150; usetick: 0);
    ActAttack: (start: 20; frame: 6; skip: 4; ftime: 150; usetick: 0);
    ActCritical: (start: 40; frame: 10; skip: 0; ftime: 150; usetick: 0);
    ActStruck: (start: 40; frame: 2; skip: 8; ftime: 150; usetick: 0);
    ActDie: (start: 30; frame: 6; skip: 4; ftime: 150; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );
  MA60: TMonsterAction = (  // 용조신상 (용석상)
    ActStand: (start: 0; frame: 10; skip: 0; ftime: 300; usetick: 0);
    ActWalk: (start: 0; frame: 10; skip: 0; ftime: 300; usetick: 0);
    ActAttack: (start: 10; frame: 10; skip: 0; ftime: 300; usetick: 0);
    ActCritical: (start: 10; frame: 10; skip: 0; ftime: 100; usetick: 0);
    ActStruck: (start: 0; frame: 1; skip: 9; ftime: 300; usetick: 0);
    ActDie: (start: 0; frame: 1; skip: 9; ftime: 300; usetick: 0);
    ActDeath: (start: 0; frame: 1; skip: 9; ftime: 300; usetick: 0);
    );
  MA61: TMonsterAction = ( // 마룡의전각 불꽃NPC
    ActStand: (start: 0; frame: 20; skip: 0; ftime: 100; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDie: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );
  MA62: TMonsterAction = (  //설인대충,주마격뢰장,환영한호, 거미(신석독마주)
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 250; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 100; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 110; usetick: 0);
    ActCritical: (start: 340; frame: 6; skip: 4; ftime: 150; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 120; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 90; usetick: 0);
    ActDeath: (start: 420; frame: 1; skip: 0; ftime: 140; usetick: 0);
    );
  MA63: TMonsterAction = (  //보물함
    ActStand: (start: 0; frame: 2; skip: 8; ftime: 1000; usetick: 0);
    ActWalk: (start: 0; frame: 2; skip: 8; ftime: 1000; usetick: 0);
    ActAttack: (start: 0; frame: 2; skip: 8; ftime: 1000; usetick: 0);
    ActCritical: (start: 0; frame: 2; skip: 8; ftime: 1000; usetick: 0);
    ActStruck: (start: 10; frame: 6; skip: 4; ftime: 150; usetick: 0);
    ActDie: (start: 20; frame: 2; skip: 8; ftime: 1000; usetick: 0);
    ActDeath: (start: 20; frame: 2; skip: 8; ftime: 1000; usetick: 0);
    );
  MA64: TMonsterAction = (  //호혼석(필드)
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 10; frame: 4; skip: 6; ftime: 200;
    usetick: 0); //등장...
    ActAttack: (start: 20; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActCritical: (start: 20; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 30; frame: 2; skip: 8; ftime: 100; usetick: 0);
    ActDie: (start: 40; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 40; frame: 10; skip: 0; ftime: 120;
    usetick: 0); //숨음..
    );
  MA65: TMonsterAction = (  //호기연
    ActStand: (start: 0; frame: 10; skip: 0; ftime: 150; usetick: 0);
    ActWalk: (start: 10; frame: 10; skip: 0; ftime: 150; usetick: 0);
    ActAttack: (start: 20; frame: 10; skip: 0; ftime: 150; usetick: 0);
    ActCritical: (start: 20; frame: 10; skip: 0; ftime: 150; usetick: 0);
    ActStruck: (start: 30; frame: 4; skip: 6; ftime: 100; usetick: 0);
    ActDie: (start: 40; frame: 10; skip: 0; ftime: 150; usetick: 0);
    ActDeath: (start: 40; frame: 10; skip: 0; ftime: 150; usetick: 0);
    );
  MA66: TMonsterAction = (  //비월천주
    ActStand: (start: 0; frame: 20; skip: 0; ftime: 150; usetick: 0);
    ActWalk: (start: 0; frame: 20; skip: 0; ftime: 150; usetick: 3);
    ActAttack: (start: 20; frame: 10; skip: 0; ftime: 150; usetick: 0);
    ActCritical: (start: 20; frame: 10; skip: 0; ftime: 150; usetick: 0);
    ActStruck: (start: 30; frame: 2; skip: 8; ftime: 100; usetick: 0);
    ActDie: (start: 400; frame: 18; skip: 0; ftime: 150; usetick: 0);
    ActDeath: (start: 400; frame: 18; skip: 0; ftime: 150; usetick: 0);
    );
  MA67: TMonsterAction = (  //호혼기석
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 150; usetick: 0);
    ActWalk: (start: 0; frame: 4; skip: 6; ftime: 150; usetick: 3);
    ActAttack: (start: 10; frame: 4; skip: 6; ftime: 300; usetick: 0);
    ActCritical: (start: 10; frame: 4; skip: 6; ftime: 300; usetick: 0);
    ActStruck: (start: 0; frame: 4; skip: 6; ftime: 150; usetick: 0);
    ActDie: (start: 0; frame: 4; skip: 6; ftime: 300; usetick: 0);
    ActDeath: (start: 0; frame: 4; skip: 6; ftime: 300; usetick: 0);
    );
  MA68: TMonsterAction = (  //NPC 3방향 서있기 모션만
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 150; usetick: 0);
    ActWalk: (start: 0; frame: 4; skip: 6; ftime: 150; usetick: 3);
    ActAttack: (start: 10; frame: 4; skip: 6; ftime: 150; usetick: 0);
    ActCritical: (start: 10; frame: 4; skip: 6; ftime: 150; usetick: 0);
    ActStruck: (start: 0; frame: 4; skip: 6; ftime: 150; usetick: 0);
    ActDie: (start: 0; frame: 4; skip: 6; ftime: 150; usetick: 0);
    ActDeath: (start: 0; frame: 4; skip: 6; ftime: 150; usetick: 0);
    );
  MA69: TMonsterAction = (  //BlackFoxman  RedFoxman
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 200; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120;
    usetick: 0); //공격폼
    ActCritical: (start: 160; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 200; usetick: 0);
    ActDeath: (start: 340; frame: 10; skip: 0; ftime: 200; usetick: 0);
    );
  MA70: TMonsterAction = (  //WhiteFoxman
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 200; usetick: 3);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120;
    usetick: 0); //공격폼
    ActCritical: (start: 340; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 200; usetick: 0);
    ActDeath: (start: 420; frame: 10; skip: 0; ftime: 120; usetick: 0);
    );
  MA71: TMonsterAction = (  //TrapRock, GuardianRock
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 300; usetick: 0);
    ActWalk: (start: 0; frame: 4; skip: 6; ftime: 300; usetick: 0);
    ActAttack: (start: 20; frame: 6; skip: 4; ftime: 300;
    usetick: 0); //공격폼
    ActCritical: (start: 10; frame: 4; skip: 6; ftime: 180; usetick: 0);
    ActStruck: (start: 30; frame: 2; skip: 0; ftime: 300; usetick: 0);
    ActDie: (start: 40; frame: 10; skip: 0; ftime: 300; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );
  MA72: TMonsterAction = (  //ThunderElement, CloudElement
    ActStand: (start: 0; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActWalk: (start: 10; frame: 10; skip: 0; ftime: 180; usetick: 1);
    ActAttack: (start: 20; frame: 10; skip: 0; ftime: 120;
    usetick: 0); //공격폼
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 30; frame: 4; skip: 0; ftime: 120; usetick: 0);
    ActDie: (start: 40; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );
  MA73: TMonsterAction = (  //GreatFoxSpirit
    ActStand: (start: 0; frame: 20; skip: 0; ftime: 120; usetick: 0);
    ActWalk: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActAttack: (start: 0; frame: 0; skip: 0; ftime: 0;
    usetick: 0); //공격폼
    ActCritical: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    ActStruck: (start: 20; frame: 10; skip: 0; ftime: 120; usetick: 0);
    ActDie: (start: 400; frame: 18; skip: 0; ftime: 120; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );
  MA74: TMonsterAction = (  //BigKektal
    ActStand: (start: 0; frame: 4; skip: 6; ftime: 200; usetick: 0);
    ActWalk: (start: 80; frame: 6; skip: 4; ftime: 200; usetick: 0);
    ActAttack: (start: 160; frame: 6; skip: 4; ftime: 120;
    usetick: 0); //공격폼
    ActCritical: (start: 340; frame: 6; skip: 4; ftime: 120; usetick: 0);
    ActStruck: (start: 240; frame: 2; skip: 0; ftime: 100; usetick: 0);
    ActDie: (start: 260; frame: 10; skip: 0; ftime: 200; usetick: 0);
    ActDeath: (start: 0; frame: 0; skip: 0; ftime: 0; usetick: 0);
    );


  WORDER: array[0..1, 0..599] of byte = (  //1: 칼이 앞으로,  0: 칼이 뒤로
    (       //남자
    //정지
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
    0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1,
    //걷기
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
    //뛰기
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1,
    0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
    //war모드
    0, 1, 1, 1, 0, 0, 0, 0,
    //공격
    1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1,
    //공격 2
    0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
    0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1,
    //공격3
    1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0,
    1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0,
    //마법
    0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
    0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1,
    //앚기
    0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0,
    //맞기
    0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    //쓰러짐
    0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1
    ),

    (
    //정지
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
    0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1,
    //걷기
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
    //뛰기
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1,
    0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1,
    //war모드
    1, 1, 1, 1, 0, 0, 0, 0,
    //공격
    1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1,
    //공격 2
    0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
    1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
    0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1,
    //공격3
    1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0,
    1, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0,
    //마법
    0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1,
    1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
    0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1,
    //앚기
    0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0,
    //맞기
    0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    //쓰러짐
    0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1,
    0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1
    )
    );

  EffDir: array[0..7] of byte = (0, 0, 1, 1, 1, 1, 1, 0);


type
  TActor = class
    RecogId: integer;
    XX:      word;
    YY:      word;
    Dir:     byte;
    Sex:     byte;
    Race:    byte;
    Hair:    byte;
    Dress:   byte;
    Weapon:  byte;
    Job:     byte; //직업 0:전사  1:술사  2:도사
    Appearance: word;
    //      DeathState: byte;
    Feature: integer;
    State:   integer;
    Death:   boolean;
    bigmagmode: boolean;
    KillerMode: boolean; //Assassin
    KillerSecondHit: boolean; //Assassin
    SecondHum: boolean;
    revivalmode: boolean;
    revivalmodetime: integer;
    Skeleton: boolean;
    BoDelActor: boolean;
    BoDelActionAfterFinished: boolean;
    DescUserName: string;
    UserName: string;
    NameColor: integer;
    Abil:    TAbility;
    Gold:    integer;
    HitSpeed: shortint; //공격속도 0: 기본, (-)느림 (+)빠름
    Visible: boolean;
    BoHoldPlace: boolean;

    Saying:     array[0..MAXSAY - 1] of string;
    SayWidths:  array[0..MAXSAY - 1] of integer;
    SayTime:    longword;
    SayX, SayY: integer;
    SayLineCount: integer;

    ShiftX: integer;
    ShiftY: integer;

    px:      integer;
    py:      integer;
    Rx, Ry:  integer;
    DownDrawLevel: integer;    //몇 셀 이전에 그리게 함...
    TargetX, TargetY: integer; //몬스터인 경우, 던지는 공격을 하는 경우 타격의 위치
    TargetRecog: integer;
    HiterCode: integer;
    MagicNum: integer;
    CurrentEvent: integer;   //서버의 이벤트 아이디
    BoDigFragment: boolean;  //이번 곡괭이 질이 캐졌는지..
    BoThrow: boolean;

    BodyOffset, HairOffset, WingOffset, WeaponOffset: integer;
    BoUseMagic:      boolean;
    BoHitEffect:     boolean;
    BoUseEffect:     boolean;  //효과를 사용하는지..
    HitEffectNumber: integer;
    WaitMagicRequest: longword;
    WaitForRecogId:  integer;  //자신이 사라지면 WaitFor의 actor를 visible 시킨다.
    WaitForFeature:  integer;
    WaitForStatus:   integer;
    //BoEatEffect: Boolean;  //약 먹는 효과
    //EatEffectFrame: integer;
    //EatEffectTime: longword;

    CurEffFrame:  integer;
    SpellFrame:   integer; //마법의 시전 프래임
    CurMagic:     TUseMagicInfo;
    //GlimmingMode: Boolean;
    //CurGlimmer: integer;
    //MaxGlimmer: integer;
    //GlimmerTime: longword;
    GenAniCount:  integer;
    BoOpenHealth: boolean;
    BoInstanceOpenHealth: boolean;
    OpenHealthStart: longword;
    OpenHealthTime: integer;

    //SRc: TRect;  //Screen Rect 화면의 실제좌표(마우스 기준)
    BodySurface: TDirectDrawSurface;

    Grouped:      boolean; //나와 그룹인 사람
    CurrentAction: integer;
    ReverseFrame: boolean;
    WarMode:      boolean;
    WarModeTime:  longword;
    ChrLight:     integer;
    MagLight:     integer;
    RushDir:      integer;  //0, 1 한번은 왼쪽 한번은 오른쪽

    WalkFrameDelay: integer;  //기본 값은 클라이언트의 ftime 이면
    //서버에서 받으면 서버에서 받은 값으로 한다.

    LockEndFrame:   boolean;
    LastStruckTime: longword;
    SendQueryUserNameTime: longword;
    DeleteTime:     longword;

    //사운드 효과
    MagicStruckSound: integer;
    borunsound:    boolean;
    footstepsound: integer;  //주인공인경우, CM_WALK, CM_RUN
    strucksound:   integer;  //맞을때 나는 소리    SM_STRUCK
    struckweaponsound: integer;

    appearsound: integer;     //등장소리 0
    normalsound: integer;     //일반소리 1
    attacksound: integer;     //         2
    weaponsound: integer;     //          3
    screamsound: integer;     //         4
    diesound:    integer;     //죽을때   5  나는 소리    SM_DEATHNOW
    die2sound:   integer;

    magicstartsound:     integer;
    magicfiresound:      integer;
    magicexplosionsound: integer;

    Bo50LevelEffect: boolean;
    BoWriterEffect:  boolean;

  private
  protected
    startframe:   integer;
    endframe:     integer;
    currentframe: integer;
    effectstart:  integer;
    effectframe:  integer;
    effectend:    integer;
    effectstarttime: longword;
    effectframetime: longword;
    frametime:    longword;   //한 프래임당 시간
    starttime:    longword;   //최근의 프래임을 찍은 시간
    maxtick:      integer;
    curtick:      integer;
    movestep:     integer;
    msgmuch:      boolean;
    struckframetime: longword;
    currentdefframe: integer;
    defframetime: longword;
    defframecount: integer;
    SkipTick, SkipTick2: integer;
    smoothmovetime: longword;
    genanicounttime: longword;
    loadsurfacetime: longword;

    oldx, oldy, olddir: integer;
    actbeforex, actbeforey: integer;  //행동 전의 좌표
    wpord: integer;

    procedure CalcActorFrame; dynamic;
    procedure DefaultMotion; dynamic;
    function GetDefaultFrame(wmode: boolean): integer; dynamic;
    procedure DrawEffSurface(dsurface, Source: TDirectDrawSurface;
      ddx, ddy: integer; blend: boolean; ceff: TColorEffect);
    procedure DrawWeaponGlimmer(dsurface: TDirectDrawSurface; ddx, ddy: integer);
  public
    MsgList: TList;         //list of PTChrMsg
    RealActionMsg: TChrMsg; //FrmMain에서 사용함

    constructor Create; dynamic;
    destructor Destroy; override;
    procedure SendMsg(ident: word; x, y, cdir, feature, state: integer;
      str: string; sound: integer);
    procedure UpdateMsg(ident: word; x, y, cdir, feature, state: integer;
      str: string; sound: integer);
    procedure CleanUserMsgs;
    procedure ProcMsg;
    procedure ProcHurryMsg;
    function IsIdle: boolean;
    function ActionFinished: boolean;
    function CanWalk: integer;
    function CanRun: integer;
    function Strucked: boolean;
    procedure Shift(dir, step, cur, max: integer);
    procedure ReadyAction(msg: TChrMsg);
    function CharWidth: integer;
    function CharHeight: integer;
    function CheckSelect(dx, dy: integer): boolean;
    procedure CleanCharMapSetting(x, y: integer);
    procedure Say(str: string);
    procedure SetSound; dynamic;
    procedure Run; dynamic;
    procedure RunSound; dynamic;
    procedure RunActSound(frame: integer); dynamic;
    procedure RunFrameAction(frame: integer); dynamic;
    //프래임마다 독특하게 해야할일
    procedure ActionEnded; dynamic;
    function Move(step: integer): boolean;
    procedure MoveFail;
    function CanCancelAction: boolean;
    procedure CancelAction;
    procedure FeatureChanged; dynamic;
    function Light: integer; dynamic;
    procedure LoadSurface; dynamic;
    function GetDrawEffectValue: TColorEffect;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); dynamic;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); dynamic;
  end;


  TNpcActor = class(TActor)
  private
    // 2003/07/15 신규 NPC 추가
    ax, ay:   integer;
    PlaySnow: boolean;
    SnowStartTime: longword;
    EffectSurface: TDirectDrawSurface;
  public
    constructor Create; override;
    procedure Run; override;
    procedure CalcActorFrame; override;
    function GetDefaultFrame(wmode: boolean): integer; override;
    procedure LoadSurface; override;
    // 2003/07/15 신규 NPC 추가
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); override;
    procedure DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer); override;
  end;

  THumActor = class(TActor)
  private
    HairSurface:     TDirectDrawSurface;
    WeaponSurface:   TDirectDrawSurface;
 //   Weapon2Surface:  TDirectDrawSurface;
    WingSurface:     TDirectDrawSurface;
    BoWeaponEffect:  boolean;  //무기 제련성공,깨짐 효과
    CurWpEffect:     integer;
    CurBubbleStruck: integer;
    wpeffecttime:    longword;
    BoHideWeapon:    boolean;

    hpx, epx, epx2, epx3, wpx, wpx2: integer;
    hpy, epy, epy2, epy3, wpy, wpy2: integer;

    WingCurrentFrame:  integer;
    WingStartTime:     longword;
    WingFrameTime:     longword;              // 프래임 갯수
    // 50Level Effect
    H50LevelEffectSurface: TDirectDrawSurface;
    H50LevelEffectOffset: integer;
    H50LevelEffectCurrentFrame: integer;
    H50LevelEffectStartTime: longword;
    H50LevelEffectFrameTime: longword;
    Bo50LevelHEffect:  boolean;
    // 공파섬
    SKillCurrentFrame: integer;
    SKillStartTime:    longword;
    SKillFrameTime:    longword;
    // 50LevelDress Effect
    Bo50DressHEffect:  boolean;
    Weapon2Surface: TDirectDrawSurface;

  protected
    procedure CalcActorFrame; override;
    procedure DefaultMotion; override;
    function GetDefaultFrame(wmode: boolean): integer; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Run; override;
    procedure RunFrameAction(frame: integer); override;
    function Light: integer; override;
    procedure LoadSurface; override;
    procedure DoWeaponBreakEffect;
    procedure DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
      blend: boolean; WingDraw: boolean); override;
  end;

function RaceByPM(race, appr: integer): PTMonsterAction;
function GetMonImg(appr: integer): TWMImages;
function GetOffset(appr: integer): integer;



implementation

uses
  ClMain, SoundUtil, clEvent;

function RaceByPM(race, appr: integer): PTMonsterAction;
begin
  Result := nil;
  case race of   // 여기의 Race는 RaceImg 로 생각됨 ... COPARK
    9: Result  := @MA9;
    10: Result := @MA10;
    11: Result := @MA11;
    12, 24: Result := @MA12;
    13: Result := @MA13;
    14, 17, 18, 23: Result := @MA14;
    15, 22: Result := @MA15;
    16: Result := @MA16;
    30, 31: Result := @MA17;
    19, 20, 21,
    37,                        //비독거미
    101, //백사(청영사)
    40, 45, 52, 53, 95: Result := @MA19;
    41, 42: Result := @MA20;
    43: Result := @MA21;
    47: Result := @MA22;
    48, 49: Result := @MA23;
    32: Result := @MA24;      //전갈, 공격이 2가지 방식
    33: Result := @MA25;      //지네왕, 촉룡신
    34, 90: Result := @MA30;  //혈거인왕, 심장, 90=>화룡몸
    35: Result := @MA31;      //폭안거미
    36: Result := @MA32;      //폭주
    54: Result := @MA28;
    55: Result := @MA29;  //신수(변신후)
    60, 61, 62: Result := @MA33;  //뢰혈사, 왕돈, 주본왕(왕중왕)
    // 2003/02/11
    63: Result := @MA34;
    64, 65, 66, 67, 68, 69:
      //낭인귀, 부식귀, 해골무장, 해골병졸, 해골무사, 해골궁수 추가
      Result   := @MA19;
    // 2003/03/04
    70, 71, 72: Result := @MA33;  //반야우사, 반야좌사, 사우천왕
    // 2003/07/15
    73: Result := @MA19;  // 날개오마
    74: Result := @MA19;
    // 쇠뭉치상급오마, 몽둥이상급오마, 칼하급오마, 도끼하급오마
    75: Result := @MA54;  // 마계석1
    76: Result := @MA53;  // 과거비천 경비
    77: Result := @MA54;  // 마계석2
    78: Result := @MA55;  // 과거비천보스
    79: Result := @MA19;  // 활하급오마
    80, 96: Result := @MA57;  // 행운의지뢰

    81: Result := @MA58;  // 월령
    83: Result := @MA59;  // 화룡 FireDragon
    84, 85, 86, 87, 88, 89: Result := @MA60; // 용조신상

    91, 92, 93, 94: Result := @MA62;
    // 2004/03/23 설인대충, 주마격뢰장, 환영한호, 거미(신석독마주) 추가
    97: Result := @MA63;  // 보물함

    98: Result := @MA27;
    99: Result := @MA26;

    100: Result := @MA62; // 황금이무기

    102, 103: Result := @MA69; //BlackFoxman  RedFoxman
    104: Result := @MA70; //WhiteFoxman
    105, 106: Result := @MA71; //TrapRock, GuardianRock
    107, 108: Result := @MA72; //ThunderElement, CloudElement
    109: Result := @MA73; //GreatFoxSpirit
    110, 111: Result := @MA74; //BigKektals

    50:  //npc
      case appr of
        23: begin
          Result := @MA51;
        end;
        // 2003/07/15 과거비천 NPC
        27, 32,
        24, 25: begin
          Result := @MA52;
        end;
        35..41, 48, 49, 50, 53, 54, 55, 57, 58, 60: // npc추가
        begin
          Result := @MA56;//석상
        end;
        42, 43, 44, 45, 46, 47:// NewNpc
        begin
          Result := @MA61;
        end;
        56, 59: begin
          Result := @MA68; //서있기 모션만 있는것들
        end;
        else
          Result := @MA50; //일반 NPC
      end;
  end;
end;

function GetMonImg(appr: integer): TWMImages;
begin
  Result := FrmMain.WMonImg; //Default
  case (appr div 10) of
    0: Result  := FrmMain.WMonImg;
    1: Result  := FrmMain.WMon2Img;  //식인초
    2: Result  := FrmMain.WMon3Img;
    3: Result  := FrmMain.WMon4Img;
    4: Result  := FrmMain.WMon5Img;
    5: Result  := FrmMain.WMon6Img;
    6: Result  := FrmMain.WMon7Img;
    7: Result  := FrmMain.WMon8Img;
    8: Result  := FrmMain.WMon9Img;
    9: Result  := FrmMain.WMon10Img;
    10: Result := FrmMain.WMon11Img;
    11: Result := FrmMain.WMon12Img;
    12: Result := FrmMain.WMon13Img;
    13: Result := FrmMain.WMon14Img;
    14: Result := FrmMain.WMon15Img;
    15: Result := FrmMain.WMon16Img;
    16: Result := FrmMain.WMon17Img;
    17: Result := FrmMain.WMon18Img;
    18: Result := FrmMain.WMon19Img;
    // 2003/02/11 신규 몹 등장
    19: Result := FrmMain.WMon20Img;
    // 2003/03/04 신규 몹 등장
    20: Result := FrmMain.WMon21Img;
    // 2003/07/15 과거 비천 추가몹
    21: Result := FrmMain.WMon22Img;
    22: Result := FrmMain.WMon23Img;
    23: Result := FrmMain.WMon24Img;
    24: Result := FrmMain.WMon25Img;

    80: Result := FrmMain.WDragonImg; // FireDragon

    90: Result := FrmMain.WEffectImg;  //성문, 성벽
  end;
end;

function GetOffset(appr: integer): integer;
var
  nrace, npos: integer;
begin
  Result := 0;
  nrace  := appr div 10;
  npos   := appr mod 10;
  case nrace of
    0: Result := npos * 280;  //8프래임
    1: begin
      case npos of
        0, 1: Result := npos * 230;
        2: Result    := 280;
      end;
    end;
    2, 3, 7..12, 14..16: Result := npos * 360;  //10프래임 기본

    13: case npos of
        1: Result := 360;   //적월마 (심장)
        2: Result := 440;   //폭안거미 (엄마거미)
        3: Result := 550;   //폭주(새끼거미)
        else
          Result := npos * 360;
      end;

    4: begin
      Result := npos * 360;
      if npos = 1 then
        Result := 600;  //비막원충
    end;
    5: Result := npos * 430;   //좀비
    6: Result := npos * 440;   //주마신장,호법,왕
    17: if npos = 2 then
        Result := 920 // 월령
      else
        Result := npos * 350;   //신수
    18: case npos of
        0: Result := 0;     //뢰혈사
        1: Result := 520;   //왕돈
        2: Result := 950;   //주마본왕(왕중왕)
      end;
    // 2003/02/11 신규 몹 등장
    19: case npos of
        0: Result := 0;      //낭인귀
        1: Result := 370;    //부식귀
        2: Result := 810;    //해골무장
        3: Result := 1250;   //해골병졸
        4: Result := 1630;   //해골무사
        5: Result := 2010;   //해골궁수
        6: Result := 2390;   //해골반왕
      end;
    // 2003/03/04 신규 몹 등장
    20: case npos of
        0: Result := 0;      //반야귀졸
        1: Result := 360;    //반야빙귀
        2: Result := 720;    //반야운귀
        3: Result := 1080;   //반야풍귀
        4: Result := 1440;   //반야화귀
        5: Result := 1800;   //반야우사
        6: Result := 2350;   //반야좌사
        7: Result := 3060;   //사우천왕
      end;
    // 2003/07/15 신규 몹 등장
    21: case npos of
        0: Result := 0;     //날개오마
        1: Result := 460;   //쇠뭉치상급오마
        2: Result := 820;   //몽둥이상급오마
        3: Result := 1180;  //칼하급오마
        4: Result := 1540;  //도끼하급오마
        5: Result := 1900;  //활하급오마
        6: Result := 2260;  //창경비
        7: Result := 2440;  //마계석1
        8: Result := 2570;  //마계석2
        9: Result := 2700;  //과거비천보스
      end;
    // 2004/03/23 신규몬스터 추가
    22: case npos of
        0: Result := 0;     //설인대충
        1: Result := 430;   //주마격뢰장
        2: Result := 1290;  //환영한호
        3: Result := 1810;  //거미(신석독마주)
        4: Result := 2320;  //황금이무기
        5: Result := 2920;  //백사(청영사)
        6: Result := 3270;  //혈독황사
        7: Result := 3620;  //혈독남사
      end;

    23: case npos of
        0: Result := 0;     //BlackFoxman
        1: Result := 440;   //RedFoxman
        2: Result := 820;  //WhiteFoxman
        3: Result := 1360;  //TrapRock
        4: Result := 1420;  //GuardianRock
        5: Result := 1450;  //Orb1
        6: Result := 1560;  //Orb2
        7: Result := 1670;  //GreatFoxSpirit
        8: Result := 2270;  //BigKektal1
        9: Result := 2700;  //BigKektal2
      end;

    24: case npos of
        0: Result := 0;     //SmallKektal1
        1: Result := 350;   //SmallKektal2
      end;

    80: case npos of // FireDragon
        0: Result := 0;     //화룡
        1: Result := 80;    //화룡몸
        2: Result := 300;   //용석상우상
        3: Result := 301;   //용석상우중
        4: Result := 302;   //용석상우하
        5: Result := 320;   //용석좌우상
        6: Result := 321;   //용석좌우중
        7: Result := 322;   //용석좌우하

      end;

    90: case npos of
        0: Result := 80;   //성문
        1: Result := 168;
        2: Result := 184;
        3: Result := 200;
      end;
  end;
end;

function GetNpcOffset(appr: integer): integer;
begin
  case appr of
    0..22: Result := MERCHANTFRAME * appr;
    23: Result := 1380;
    // 2003/07/15 과거비천 NPC
    27, 32: Result := 1620 + MERCHANTFRAME * (appr - 26) - 30;
    26, 28, 29, 30, 31, 33, 34, 35..41: // 41:마계수
      Result := 1620 + MERCHANTFRAME * (appr - 26);
    42, 43: //화롯불1,2
      Result := 2580;
    44, 45, 46, 47: //탑불1,2,3,4
      Result := 2640;
    48, 49, 50: //48:계단 49:게시판 50:부서진수레
      Result := 2700 + MERCHANTFRAME * (appr - 48);
    51: // 민규NPC(귀신)    //2004/05/27 50LevelQuest
      Result := 2880;
    52: //괴물NPC
      Result := 2960;
    53: //눈사람  //NewNPC
      Result := 3030;
    54: //우물 //@@@@@
      Result := 3120;
    55: //시체
      Result := 3180;
    56: //경비병
      Result := 3240;
    57: //차원의문
      Result := 3300;
    58: //사자석상
      Result := 3320;
    59: //호혼기석npc
      Result := 3340;
    60: //해골시체-연인퀘스트
      Result := 3380;

    else
      Result := 1470 + MERCHANTFRAME * (appr - 24);
  end;
end;


constructor TActor.Create;
begin
  inherited Create;
  MsgList     := TList.Create;
  RecogId     := 0;
  BodySurface := nil;
  FillChar(Abil, sizeof(TAbility), 0);
  Gold    := 0;
  Visible := True;
  BoHoldPlace := True;
  KillerMode     := False;

  //현재 진행중인 동작, 종료됬어도 가지고 있음
  //동작의 currentframe이 endframe을 넘었으면 동작이 완료된것으로 봄
  CurrentAction := 0;
  ReverseFrame := False;
  ShiftX      := 0;
  ShiftY      := 0;
  DownDrawLevel := 0;
  currentframe := -1;
  effectframe := -1;
  RealActionMsg.Ident := 0;
  UserName    := '';
  NameColor   := clWhite;
  SendQueryUserNameTime := 0; //GetTickCount;

  WarMode    := False;
  WarModeTime := 0;    //War mode로 변경된 시점의 시간
  Death      := False;
  Skeleton   := False;
  BoDelActor := False;
  BoDelActionAfterFinished := False;

  ChrLight     := 0;
  MagLight     := 0;
  LockEndFrame := False;
  smoothmovetime := 0; //GetTickCount;
  genanicounttime := 0;
  defframetime := 0;
  loadsurfacetime := GetTickCount;
  Grouped      := False;
  BoOpenHealth := False;
  BoInstanceOpenHealth := False;

  CurMagic.ServerMagicCode := 0;
  //CurMagic.MagicSerial := 0;

  SpellFrame := DEFSPELLFRAME;

  normalsound   := -1;
  footstepsound := -1; //없음  //주인공인경우, CM_WALK, CM_RUN
  attacksound   := -1;
  weaponsound   := -1;
  strucksound   := s_struck_body_longstick;  //맞을때 나는 소리    SM_STRUCK
  struckweaponsound := -1;
  screamsound   := -1;
  diesound      := -1;    //없음    //죽을때 나는 소리    SM_DEATHNOW
  die2sound     := -1;
end;

destructor TActor.Destroy;
var
  i: Integer;
begin
  for i:=0 to MsgList.Count - 1 do
    Dispose(PTChrMsg(MsgList[i]));
  MsgList.Free;

  inherited Destroy;
end;

procedure TActor.SendMsg(ident: word; x, y, cdir, feature, state: integer;
  str: string; sound: integer);
var
  pmsg: PTChrMsg;
begin
  new(pmsg);
  pmsg.ident  := ident;
  pmsg.x      := x;
  pmsg.y      := y;
  pmsg.dir    := cdir;
  pmsg.feature := feature;
  pmsg.state  := state;
  pmsg.saying := str;
  pmsg.Sound  := sound;
  MsgList.Add(pmsg);
end;

procedure TActor.UpdateMsg(ident: word; x, y, cdir, feature, state: integer;
  str: string; sound: integer);
var
  i, n: integer;
  pmsg: PTChrMsg;
begin
  if self = Myself then begin
    n := 0;
    while True do begin
      if n >= MsgList.Count then
        break;
      if (PTChrMsg(MsgList[n]).Ident >= 3000) and //클라이언트에서 보낸 메세지는
        (PTChrMsg(MsgList[n]).Ident <= 3099) or     //무시해도 된다.
        (PTChrMsg(MsgList[n]).Ident = ident) //같은건 무시
      then begin
        Dispose(PTChrMsg(MsgList[n]));
        MsgList.Delete(n);
      end else
        Inc(n);
    end;
    SendMsg(ident, x, y, cdir, feature, state, str, sound);
  end else begin
    //if not ((ident = SM_STRUCK) and (MsgList.Count >= 2)) then //맞는 동작 생략
    if MsgList.Count > 0 then begin
      for i := 0 to MsgList.Count - 1 do begin
        if PTChrMsg(MsgList[i]).Ident = ident then begin
          Dispose(PTChrMsg(MsgList[i]));
          MsgList.Delete(i);
          break;
        end;
      end;
    end;
    SendMsg(ident, x, y, cdir, feature, state, str, sound);
  end;
end;

procedure TActor.CleanUserMsgs;
var
  n: integer;
begin
  n := 0;
  while True do begin
    if n >= MsgList.Count then
      break;
    if (PTChrMsg(MsgList[n]).Ident >= 3000) and //클라이언트에서 보낸 메세지는
      (PTChrMsg(MsgList[n]).Ident <= 3099)      //무시해도 된다.
    then begin
      Dispose(PTChrMsg(MsgList[n]));
      MsgList.Delete(n);
    end else
      Inc(n);
  end;
end;

procedure TActor.CalcActorFrame;
var
  pm: PTMonsterAction;
  haircount: integer;
begin
  BoUseMagic   := False;
  currentframe := -1;

  BodyOffset := GetOffset(Appearance);
  pm := RaceByPM(Race, Appearance);
  if pm = nil then
    exit;

  case CurrentAction of
    SM_TURN: begin
      startframe    := pm.ActStand.start + Dir *
        (pm.ActStand.frame + pm.ActStand.skip);
      endframe      := startframe + pm.ActStand.frame - 1;
      frametime     := pm.ActStand.ftime;
      starttime     := GetTickCount;
      defframecount := pm.ActStand.frame;
      Shift(Dir, 0, 0, 1);
    end;
    SM_WALK, SM_RUSH, SM_RUSHKUNG, SM_BACKSTEP: begin
      startframe := pm.ActWalk.start + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
      endframe   := startframe + pm.ActWalk.frame - 1;
      frametime  := WalkFrameDelay; //pm.ActWalk.ftime;
      starttime  := GetTickCount;
      maxtick    := pm.ActWalk.UseTick;
      curtick    := 0;
      movestep   := 1;
      if CurrentAction = SM_BACKSTEP then
        Shift(GetBack(Dir), movestep, 0, endframe - startframe + 1)
      else
        Shift(Dir, movestep, 0, endframe - startframe + 1);
    end;
      {SM_BACKSTEP:
         begin
            startframe := pm.ActWalk.start + (pm.ActWalk.frame - 1) + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
            endframe := startframe - (pm.ActWalk.frame - 1);
            frametime := WalkFrameDelay; //pm.ActWalk.ftime;
            starttime := GetTickCount;
            maxtick := pm.ActWalk.UseTick;
            curtick := 0;
            movestep := 1;
            Shift (GetBack(Dir), movestep, 0, endframe-startframe+1);
         end;}
    SM_HIT: begin
      startframe  := pm.ActAttack.start + Dir *
        (pm.ActAttack.frame + pm.ActAttack.skip);
      endframe    := startframe + pm.ActAttack.frame - 1;
      frametime   := pm.ActAttack.ftime;
      starttime   := GetTickCount;
      //WarMode := TRUE;
      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
    end;
    SM_STRUCK: begin
      startframe := pm.ActStruck.start + Dir *
        (pm.ActStruck.frame + pm.ActStruck.skip);
      endframe   := startframe + pm.ActStruck.frame - 1;
      frametime  := struckframetime; //pm.ActStruck.ftime;
      starttime  := GetTickCount;
      Shift(Dir, 0, 0, 1);
    end;
    SM_DEATH: begin
      startframe := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      startframe := endframe;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;
    end;
    SM_NOWDEATH: begin
      startframe := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip);
      endframe   := startframe + pm.ActDie.frame - 1;
      frametime  := pm.ActDie.ftime;
      starttime  := GetTickCount;
    end;
    SM_SKELETON: begin
      startframe := pm.ActDeath.start + Dir;
      endframe   := startframe + pm.ActDeath.frame - 1;
      frametime  := pm.ActDeath.ftime;
      starttime  := GetTickCount;
    end;
  end;
end;

procedure TActor.ReadyAction(msg: TChrMsg);
var
  i, n:   integer;
  pmag:   PTUseMagicInfo;
  gCheck: boolean;
begin
  actbeforex := XX;
  actbeforey := YY;

{   if msg.Ident = SM_ALIVE then begin
      Death := FALSE;
      Skeleton := FALSE;
   end;}

  if not Death then begin
    case msg.Ident of
      SM_TURN, SM_WALK, SM_BACKSTEP, SM_RUSH, SM_RUSHKUNG, SM_RUN,
      SM_DIGUP, SM_ALIVE: begin
        Feature := msg.feature;
        if msg.Ident <> SM_RUSH then
          State := msg.state;

        //캐릭터의 부가적인 상태 표시
        if State and STATE_OPENHEATH <> 0 then
          BoOpenHealth := True
        // 2003/03/04 그룹원 탐기표시
        else begin
          n := 0;
          for i := 1 to ViewListCount do
            if (ViewList[i].Index = RecogId) then
              n := i;
          if n = 0 then
            BoOpenHealth := False;
        end;
      end;
    end;
    if (msg.Ident = SM_DRAGON_FIRE1) or (msg.Ident = SM_DRAGON_FIRE2) or
      (msg.Ident = SM_DRAGON_FIRE3) or (msg.Ident = SM_LIGHTING_1) then
      n := 0; // FireDragon
    if msg.ident = SM_LIGHTING then
      n := 0;
    if Myself = self then begin
      if (msg.Ident = CM_WALK) then
        if not PlayScene.CanWalk(msg.x, msg.y) then
          exit;  //이동 불가
      if (msg.Ident = CM_RUN) then
        if not PlayScene.CanRun(Myself.XX, Myself.YY, msg.x, msg.y) then
          exit; //이동 불가

      //msg
      case msg.Ident of
        CM_TURN,
        CM_WALK,
        CM_SITDOWN,
        CM_RUN,
        CM_HIT,
        CM_POWERHIT,
        CM_slashhit, //Slash
        CM_LONGHIT,
        CM_WIDEHIT,
        CM_WIDEHIT2, //Assassin Skill 2
        // 2003/03/15 신규무공
        CM_CROSSHIT,
        CM_HEAVYHIT,
        CM_BIGHIT: begin
          RealActionMsg := msg; //현재 실행되고 있는 행동, 서버에 메세지를 보냄.
          msg.Ident     := msg.Ident - 3000;  //SM_?? 으로 변환 함
        end;
        CM_THROW: begin
          if feature <> 0 then begin
            TargetX     := TActor(msg.feature).XX;    //x 던지는 목표
            TargetY     := TActor(msg.feature).YY;    //y
            TargetRecog := TActor(msg.feature).RecogId;
          end;
          RealActionMsg := msg;
          msg.Ident     := SM_THROW;
        end;
        CM_FIREHIT: begin
          RealActionMsg := msg;
          msg.Ident     := SM_FIREHIT;
        end;
        // 2003/07/15 신규무공
        CM_TWINHIT: begin
          RealActionMsg := msg;
          msg.Ident     := SM_TWINHIT;
        end;
        CM_SPELL: begin
          RealActionMsg := msg;
          pmag      := PTUseMagicInfo(msg.feature);
          RealActionMsg.Dir := pmag.MagicSerial;
          msg.Ident := msg.Ident - 3000;  //SM_?? 으로 변환 함
        end;
      end;

      oldx   := XX;
      oldy   := YY;
      olddir := Dir;
    end;
    case msg.Ident of
      SM_STRUCK: begin
        //Abil.HP := msg.x; {HP}
        //Abil.MaxHP := msg.y; {maxHP}
        //msg.dir {damage}
        //레벨이 높으면 맞는 시간이 짧다.
        MagicStruckSound := msg.x; //1이상, 마법효과
        n := Round(200 - Abil.Level * 5);
        if n > 80 then
          struckframetime := n
        else
          struckframetime := 80;
        LastStruckTime := GetTickCount;
        gCheck := False;
        if GroupIdList.Count > 0 then
          for i := 0 to GroupIdList.Count - 1 do begin
            if integer(GroupIdList[i]) = HiterCode then begin
              gCheck := True;
              Break;
            end;
          end;

        if ((Race <> 0) and (Race <> 34) and (HiterCode = Myself.RecogId) or
          gCheck) and (Abil.MaxHP < 2000) then begin   //MonOpenHp
          if not BoInstanceOpenHealth then begin
            BoInstanceOpenHealth := True;
            OpenHealthTime  := 60 * 1000;
            OpenHealthStart := GetTickCount;
          end;
        end;
        if Race = 0 then
          BoInstanceOpenHealth := False;
      end;
      SM_SPELL: begin
        Dir  := msg.dir;
        //msg.x  :targetx
        //msg.y  :targety
        pmag := PTUseMagicInfo(msg.feature);
        if pmag <> nil then begin
          CurMagic := pmag^;
          CurMagic.ServerMagicCode := -1; //FIRE 대기
          //CurMagic.MagicSerial := 0;
          CurMagic.TargX := msg.x;
          CurMagic.TargY := msg.y;
          Dispose(pmag);
        end;
        //DScreen.AddSysMsg ('SM_SPELL');
      end;
      else begin
        XX  := msg.x;
        YY  := msg.y;
        Dir := msg.dir;
      end;
    end;

    CurrentAction := msg.Ident;
    CalcActorFrame;
    //DScreen.AddSysMsg (IntToStr(msg.Ident) + ' ' + IntToStr(XX) + ' ' + IntToStr(YY) + ' : ' + IntToStr(msg.x) + ' ' + IntToStr(msg.y));
  end else begin
    if msg.Ident = SM_SKELETON then begin
      CurrentAction := msg.Ident;
      CalcActorFrame;
      Skeleton := True;
    end;
  end;
  if (msg.Ident = SM_DEATH) or (msg.Ident = SM_NOWDEATH) then begin
    if GroupIdList.Count > 0 then
      for i := 0 to GroupIdList.Count - 1 do begin  // MonOpenHp
        if integer(GroupIdList[i]) = RecogId then begin
          GroupIdList.Delete(i);
          Break;
        end;
      end;
    Death := True;
    PlayScene.ActorDied(self);
  end;

  RunSound;
end;

procedure TActor.ProcMsg;
var
  msg:  TChrMsg;
  meff: TMagicEff;
begin
  while True do begin
    if MsgList.Count <= 0 then
      break;
    if CurrentAction <> 0 then
      break;
    msg := PTChrMsg(MsgList[0])^;
    Dispose(PTChrMsg(MsgList[0]));
    MsgList.Delete(0);

    case msg.ident of
      SM_STRUCK: begin
        HiterCode := msg.Sound; //나를 때린놈
        ReadyAction(msg);
      end;
      SM_DEATH,
      SM_NOWDEATH,
      SM_SKELETON,
      SM_ALIVE,
      // 2003/04/01 광풍참 시전 모습
      SM_CROSSHIT,
      SM_TWINHIT,
      SM_STONEHIT,
      SM_ACTION_MIN..SM_ACTION_MAX,
      SM_ACTION2_MIN..SM_ACTION2_MAX,
      SM_DRAGON_LIGHTING..SM_LIGHTING_1,
      3000..3099: //클라이언트 이동 메세지로 예약됨
      begin
        ReadyAction(msg);
      end;
      SM_SPACEMOVE_HIDE: begin
        meff := TScrollHideEffect.Create(250, 10, XX, YY, self);
        PlayScene.EffectList.Add(meff);
        PlaySound(s_spacemove_out);
      end;
      SM_SPACEMOVE_HIDE2: begin
        meff := TScrollHideEffect.Create(1590, 10, XX, YY, self);
        PlayScene.EffectList.Add(meff);
        PlaySound(s_spacemove_out);
      end;
      SM_SPACEMOVE_SHOW: begin
        meff := TCharEffect.Create(260, 10, self);
        PlayScene.EffectList.Add(meff);
        msg.ident := SM_TURN;
        ReadyAction(msg);
        PlaySound(s_spacemove_in);
      end;
      SM_SPACEMOVE_SHOW2: begin
        meff := TCharEffect.Create(1600, 10, self);
        PlayScene.EffectList.Add(meff);
        msg.ident := SM_TURN;
        ReadyAction(msg);
        PlaySound(s_spacemove_in);
      end;
      else begin
      end;
    end;
  end;

end;

procedure TActor.ProcHurryMsg; //빨리 처리해야 되는 메세지 처리함..
var
  n:   integer;
  msg: TChrMsg;
  fin: boolean;
begin
  n := 0;
  while True do begin
    if MsgList.Count <= n then
      break;
    msg := PTChrMsg(MsgList[n])^;
    fin := False;
    case msg.Ident of
      SM_MAGICFIRE: if CurMagic.ServerMagicCode <> 0 then begin
          CurMagic.ServerMagicCode := 111;
          CurMagic.Target := msg.x;
          if msg.y in [0..MAXMAGICTYPE - 1] then
            CurMagic.EffectType := TMagicType(msg.y);
          CurMagic.EffectNumber := msg.dir;
          CurMagic.TargX := msg.feature;
          CurMagic.TargY := msg.state;
          CurMagic.Recusion := True;
          fin := True;
          if CurMagic.EffectNumber = 54 then begin //Reincarnation
          if CurMagic.Target > 0 then begin
          if revivalmode = False then begin
          revivalmode := True;
          revivalmodetime := GetTickCount;
          end else begin
          revivalmode := False;
          end;
          end else begin
          revivalmode := False;
          end;
          end;
          //DScreen.AddSysMsg ('SM_MAGICFIRE GOOD');
        end;
      SM_MAGICFIRE_FAIL: if CurMagic.ServerMagicCode <> 0 then begin
          CurMagic.ServerMagicCode := 0;
          fin := True;
        end;
    end;
    if fin then begin
      Dispose(PTChrMsg(MsgList[n]));
      MsgList.Delete(n);
    end else
      Inc(n);
  end;
end;

function TActor.IsIdle: boolean;
begin
if revivalmode then begin
  if GetTickCount - revivalmodetime > 5000 then begin
    Result := True;
    SilenceSound;
  end else begin
    Result := False;
  end;
end else begin
  if (CurrentAction = 0) and (MsgList.Count = 0) and (not bigmagmode) then
    Result := True
  else
    Result := False;
end;
end;

function TActor.ActionFinished: boolean;
begin
  if (CurrentAction = 0) or (currentframe >= endframe) then
    Result := True
  else
    Result := False;
end;

function TActor.CanWalk: integer;
begin
  //얻어 맞은 다음에 걸을 수 없다. or 마법 딜래이
  if {(GetTickCount - LastStruckTime < 1300) or}(GetTickCount -
    LatestSpellTime < MagicPKDelayTime) then
    Result := -1   //딜레이
  else
    Result := 1;
end;

function TActor.CanRun: integer;
begin
  //민첩이 떨어졌거나, 체력이 소모되었으면 뛸 수 없음..
  //얻어 맞은 다음에 바로 뛸 수 없음..
  Result := 1;
  if Abil.HP < RUN_MINHEALTH then begin
    Result := -1;
  end else if (GetTickCount - LastStruckTime < RUN_STRUCK_DELAY) or
    (GetTickCount - LatestSpellTime < MagicPKDelayTime) then
    Result := -2;

end;

function TActor.Strucked: boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to MsgList.Count - 1 do begin
    if PTChrMsg(MsgList[i]).Ident = SM_STRUCK then begin
      Result := True;
      break;
    end;
  end;
end;


 //dir : 방향
 //step : 이동 칸
 //cur : 현재 스텝
 //max : 최대 스텝
procedure TActor.Shift(dir, step, cur, max: integer);
var
  unx, uny, ss, v: integer;
begin
  unx := UNITX * step;
  uny := UNITY * step;
  if cur > max then
    cur := max;
  Rx := XX;
  Ry := YY;
  ss := Round((max - cur - 1) / max) * step;
  case dir of
    DR_UP: begin
      ss     := Round((max - cur) / max) * step;
      ShiftX := 0;
      Ry     := YY + ss;
      if ss = step then
        ShiftY := -Round(uny / max * cur)
      else
        ShiftY := Round(uny / max * (max - cur));
    end;
    DR_UPRIGHT: begin
      if max >= 6 then
        v := 2
      else
        v := 0;
      ss := Round((max - cur + v) / max) * step;
      Rx := XX - ss;
      Ry := YY + ss;
      if ss = step then begin
        ShiftX := Round(unx / max * cur);
        ShiftY := -Round(uny / max * cur);
      end else begin
        ShiftX := -Round(unx / max * (max - cur));
        ShiftY := Round(uny / max * (max - cur));
      end;
    end;
    DR_RIGHT: begin
      ss := Round((max - cur) / max) * step;
      Rx := XX - ss;
      if ss = step then
        ShiftX := Round(unx / max * cur)
      else
        ShiftX := -Round(unx / max * (max - cur));
      ShiftY := 0;
    end;
    DR_DOWNRIGHT: begin
      if max >= 6 then
        v := 2
      else
        v := 0;
      ss := Round((max - cur - v) / max) * step;
      Rx := XX - ss;
      Ry := YY - ss;
      if ss = step then begin
        ShiftX := Round(unx / max * cur);
        ShiftY := Round(uny / max * cur);
      end else begin
        ShiftX := -Round(unx / max * (max - cur));
        ShiftY := -Round(uny / max * (max - cur));
      end;
    end;
    DR_DOWN: begin
      if max >= 6 then
        v := 1
      else
        v := 0;
      ss := Round((max - cur - v) / max) * step;
      ShiftX := 0;
      Ry     := YY - ss;
      if ss = step then
        ShiftY := Round(uny / max * cur)
      else
        ShiftY := -Round(uny / max * (max - cur));
    end;
    DR_DOWNLEFT: begin
      if max >= 6 then
        v := 2
      else
        v := 0;
      ss := Round((max - cur - v) / max) * step;
      Rx := XX + ss;
      Ry := YY - ss;
      if ss = step then begin
        ShiftX := -Round(unx / max * cur);
        ShiftY := Round(uny / max * cur);
      end else begin
        ShiftX := Round(unx / max * (max - cur));
        ShiftY := -Round(uny / max * (max - cur));
      end;
    end;
    DR_LEFT: begin
      ss := Round((max - cur) / max) * step;
      Rx := XX + ss;
      if ss = step then
        ShiftX := -Round(unx / max * cur)
      else
        ShiftX := Round(unx / max * (max - cur));
      ShiftY := 0;
    end;
    DR_UPLEFT: begin
      if max >= 6 then
        v := 2
      else
        v := 0;
      ss := Round((max - cur + v) / max) * step;
      Rx := XX + ss;
      Ry := YY + ss;
      if ss = step then begin
        ShiftX := -Round(unx / max * cur);
        ShiftY := -Round(uny / max * cur);
      end else begin
        ShiftX := Round(unx / max * (max - cur));
        ShiftY := Round(uny / max * (max - cur));
      end;
    end;
  end;
end;

procedure TActor.FeatureChanged;
var
  haircount: integer;
begin
  case Race of
    //human
    0: begin
      hair      := HAIRfeature(Feature);         //변경된다.
      dress     := DRESSfeature(Feature);
      weapon    := WEAPONfeature(Feature);
    //  ShowMessage (IntToStr(weapon));
    //ShowMessage (IntToStr(dress));
    if weapon in [144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155,
    156, 157, 158, 159, 160, 161, 162, 163] then KillerMode := True
    else KillerMode := False;
    if dress in [150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161,
    162, 163, 164, 165, 166, 167] then SecondHum := True
    else SecondHum := False;
      if SecondHum then begin
      if KillerMode then begin
      BodyOffset := (KILLERFRAME * (Dress - 150)); //남자0, 여자1
      haircount := FrmMain.WHairImg.ImageCount div HUMANFRAME div 2;
      if hair > haircount - 1 then
        hair := haircount - 1;
      hair := hair;
      if hair > 1 then
        HairOffset := KILLERFRAME * (hair + Sex)
      else
        HairOffset := -1;
      end else begin
      BodyOffset := (HUMANFRAME + 320) * (Dress - 150); //남자0, 여자1
      haircount := FrmMain.WHairImg.ImageCount div HUMANFRAME div 2;
      if hair > haircount - 1 then
        hair := haircount - 1;
      hair := hair * 2;
      if hair > 1 then
        HairOffset := HUMANFRAME * (hair + Sex)
      else
        HairOffset := -1;
      end;
      end else begin
      if KillerMode then begin
      BodyOffset := (KILLERFRAME * Dress); //남자0, 여자1
      haircount := FrmMain.WHairImg.ImageCount div HUMANFRAME div 2;
      if hair > haircount - 1 then
        hair := haircount - 1;
      hair := hair;
      if hair > 1 then
        HairOffset := KILLERFRAME * (hair + Sex)
      else
        HairOffset := -1;
      end else begin
      BodyOffset := HUMANFRAME * Dress; //남자0, 여자1
      haircount := FrmMain.WHairImg.ImageCount div HUMANFRAME div 2;
      if hair > haircount - 1 then
        hair := haircount - 1;
      hair := hair * 2;
      if hair > 1 then
        HairOffset := HUMANFRAME * (hair + Sex)
      else
        HairOffset := -1;
      end;
      end;
      if KillerMode then begin
      if weapon in [144, 145] then WeaponOffset := KILLERFRAME * 0
      else if weapon in [146, 147] then WeaponOffset := KILLERFRAME
      else
      WeaponOffset := KILLERFRAME * (weapon - 144);
      end else begin
      WeaponOffset := WEAPONFRAME * weapon;
      end;
  if KillerMode then begin
  if dress = 18 then
    WingOffset := 0                  // 천의무봉(남)
  else if dress = 19 then
    WingOffset := KILLERFRAME    // 천의무봉(여)
  else if dress = 20 then
    WingOffset := KILLERFRAME * 2  // 천룡불사의(남)
  else if dress = 21 then
    WingOffset := KILLERFRAME * 3 // 천룡불사의(여)
  else if dress in [22, 23] then
    WingOffset := 352; // 50레벨옷
  end else begin
  if dress = 18 then
    WingOffset := 0                  // 천의무봉(남)
  else if dress = 19 then
    WingOffset := HUMANFRAME    // 천의무봉(여)
  else if dress = 20 then
    WingOffset := HUMANFRAME * 2  // 천룡불사의(남)
  else if dress = 21 then
    WingOffset := HUMANFRAME * 3 // 천룡불사의(여)
  else if dress in [22, 23] then
    WingOffset := 352; // 50레벨옷
  end;
    end;
    50: ;  //npc
    else begin
      Appearance := APPRfeature(Feature);
      BodyOffset := GetOffset(Appearance);
      //BodyOffset := MONFRAME * (Appearance mod 10);
    end;
  end;
end;

function TActor.Light: integer;
begin
  Result := ChrLight;
end;

procedure TActor.LoadSurface;
var
  mimg: TWMImages;
begin
  mimg := GetMonImg(Appearance);
  if mimg <> nil then begin
    if (not ReverseFrame) then
      BodySurface := mimg.GetCachedImage(GetOffset(Appearance) +
        currentframe, px, py)
    else
      BodySurface := mimg.GetCachedImage(GetOffset(Appearance) +
        endframe - (currentframe - startframe), px, py);
  end;
end;

function TActor.CharWidth: integer;
begin
  if BodySurface <> nil then
    Result := BodySurface.Width
  else
    Result := 48;
end;

function TActor.CharHeight: integer;
begin
  if BodySurface <> nil then
    Result := BodySurface.Height
  else
    Result := 70;
end;

function TActor.CheckSelect(dx, dy: integer): boolean;
var
  c: integer;
begin
  Result := False;
  if BodySurface <> nil then begin
    c := BodySurface.Pixels[dx, dy];
    if (c <> 0) and ((BodySurface.Pixels[dx - 1, dy] <> 0) and
      (BodySurface.Pixels[dx + 1, dy] <> 0) and
      (BodySurface.Pixels[dx, dy - 1] <> 0) and
      (BodySurface.Pixels[dx, dy + 1] <> 0)) then
      Result := True;
  end;
end;

procedure TActor.DrawEffSurface(dsurface, Source: TDirectDrawSurface;
  ddx, ddy: integer; blend: boolean; ceff: TColorEffect);
begin
  if State and $00800000 <> 0 then begin
    blend := True;  //투명
  end;
  if not Blend then begin
    if ceff = ceNone then begin
      if Source <> nil then
        dsurface.Draw(ddx, ddy, Source.ClientRect, Source, True);
    end else begin
      if Source <> nil then begin
        ImgMixSurface.Draw(0, 0, Source.ClientRect, Source, False);
        DrawEffect(0, 0, Source.Width, Source.Height, ImgMixSurface, ceff);
        dsurface.Draw(ddx, ddy, Source.ClientRect, ImgMixSurface, True);
      end;
    end;
  end else begin
    if ceff = ceNone then begin
      if Source <> nil then
        DrawBlend(dsurface, ddx, ddy, Source, 0);
    end else begin
      if Source <> nil then begin
        ImgMixSurface.Fill(0);
        ImgMixSurface.Draw(0, 0, Source.ClientRect, Source, False);
        DrawEffect(0, 0, Source.Width, Source.Height, ImgMixSurface, ceff);
        DrawBlend(dsurface, ddx, ddy, ImgMixSurface, 0);
      end;
    end;
  end;
end;

procedure TActor.DrawWeaponGlimmer(dsurface: TDirectDrawSurface; ddx, ddy: integer);
var
  idx, ax, ay: integer;
  d: TDirectDrawSurface;
begin
  //사용안함..(염화결) 그래픽 오류...
   (*if BoNextTimeFireHit and WarMode and GlimmingMode then begin
      if GetTickCount - GlimmerTime > 200 then begin
         GlimmerTime := GetTickCount;
         Inc (CurGlimmer);
         if CurGlimmer >= MaxGlimmer then CurGlimmer := 0;
      end;
      idx := GetEffectBase (5-1{염화결반짝임}, 1) + Dir*10 + CurGlimmer;
      d := FrmMain.WMagic.GetCachedImage (idx, ax, ay);
      if d <> nil then
         DrawBlend (dsurface, ddx + ax, ddy + ay, d, 1);
                          //dx + ax + ShiftX,
                          //dy + ay + ShiftY,
                          //d, 1);
   end;*)
end;

function TActor.GetDrawEffectValue: TColorEffect;
var
  ceff: TColorEffect;
begin
  ceff := ceNone;

  //선택된 캐릭 밝게.
  if (FocusCret = self) or (MagicTarget = self) then begin
    ceff := ceBright;
  end;

  //중독
  if State and $80000000 <> 0 then begin        //POISON_DECHEALTH
    ceff := ceGreen;
  end;
  if State and $40000000 <> 0 then begin        //POISON_DAMAGEARMOR
    ceff := ceRed;
  end;
  if State and $20000000 <> 0 then begin        //POISON_ICE
    ceff := ceBlue;
  end;
  if State and $10000000 <> 0 then begin        //POISON_STUN
    ceff := ceYellow;
  end;
  if State and $08000000 <> 0 then begin        //POISON_SLOW
    ceff := ceFuchsia;
  end;
  if State and $04000000 <> 0 then begin        //POISON_STONE
    ceff := ceGrayScale;
  end;
  if State and $02000000 <> 0 then begin        //POISON_DONTMOVE
    ceff := ceGrayScale;   // 사자후 관련
  end;

  // 2004/03/22 50 LevelEffect
  if (Race = 0) and (State and $00080000 <> 0) then //50LEVELEFFECT
    Bo50LevelEffect := True
  else
    Bo50LevelEffect := False;
  Result := ceff;
end;

procedure TActor.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend: boolean; WingDraw: boolean);
var
  idx, ax, ay: integer;
  d:    TDirectDrawSurface;
  ceff: TColorEffect;
  wimg: TWMImages;
begin
  if not (Dir in [0..7]) then
    exit;
  if GetTickCount - loadsurfacetime > 60 * 1000 then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
    //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
  end;

  ceff := GetDrawEffectValue;

  if BodySurface <> nil then begin
    DrawEffSurface(dsurface, BodySurface, dx + px + ShiftX, dy +
      py + ShiftY, blend, ceff);
  end;

  if BoUseMagic {and (EffDir[Dir] = 1)} and (CurMagic.EffectNumber > 0) then
    if CurEffFrame in [0..SpellFrame - 1] then begin
      GetEffectBase(Curmagic.EffectNumber - 1, 0, wimg, idx);
      idx := idx + CurEffFrame;
      if wimg <> nil then begin
        d := wimg.GetCachedImage(idx, ax, ay);
        if d <> nil then
          DrawBlend(dsurface,
            dx + ax + ShiftX,
            dy + ay + ShiftY,
            d, 1);
      end;
    end;
end;

procedure TActor.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
end;


function TActor.GetDefaultFrame(wmode: boolean): integer;
var
  cf, dr: integer;
  pm:     PTMonsterAction;
begin
  Result := 0;
  pm     := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;

  if Death then begin
    if Skeleton then
      Result := pm.ActDeath.start
    else
      Result := pm.ActDie.start + Dir * (pm.ActDie.frame + pm.ActDie.skip) +
        (pm.ActDie.frame - 1);
  end else begin
    defframecount := pm.ActStand.frame;
    if currentdefframe < 0 then
      cf := 0
    else if currentdefframe >= pm.ActStand.frame then
      cf := 0
    else
      cf := currentdefframe;
    Result := pm.ActStand.start + Dir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
  end;
end;

procedure TActor.DefaultMotion;   //동작 없음,  기본 자세..
begin
  ReverseFrame := False;
  if WarMode or bigmagmode then begin
    if (GetTickCount - WarModeTime > 3.7 * 1000) then begin //and not BoNextTimeFireHit then
      WarMode := False;
      bigmagmode := False;
  end;
  end;
  currentframe := GetDefaultFrame(WarMode);
  Shift(Dir, 0, 1, 1);
end;

//사운드 변수를 초기화 한다.
procedure TActor.SetSound;
var
  cx, cy, bidx, wunit, attackweapon: integer;
  hiter: TActor;
begin
  if Race = 0 then begin
    if (self = Myself) and ((CurrentAction = SM_WALK) or
      (CurrentAction = SM_BACKSTEP) or (CurrentAction = SM_RUN) or
      (CurrentAction = SM_RUSH) or (CurrentAction = SM_RUSHKUNG)) then begin
      cx    := Myself.XX - Map.BlockLeft;
      cy    := Myself.YY - Map.BlockTop;
      cx    := cx div 2 * 2;
      cy    := cy div 2 * 2;
      bidx  := Map.MArr[cx, cy].BkImg and $7FFF;
      wunit := Map.MArr[cx, cy].Area;
      bidx  := wunit * 10000 + bidx - 1;
      case bidx of
        //짧은 풀
        330..349, 450..454, 550..554, 750..754,
        950..954, 1250..1254, 1400..1424, 1455..1474,
        1500..1524, 1550..1574: footstepsound := s_walk_lawn_l;

        //중간풀

        //긴 풀
        250..254, 1005..1009, 1050..1054, 1060..1064, 1450..1454,
        1650..1654: footstepsound := s_walk_rough_l;

        //돌 길
        //대리석 바닥
        605..609, 650..654, 660..664, 2000..2049,
        3025..3049, 2400..2424, 4625..4649, 4675..4678: footstepsound :=
            s_walk_stone_l;

        //동굴안
        1825..1924, 2150..2174, 3075..3099, 3325..3349,
        3375..3399: footstepsound := s_walk_cave_l;

        //나무바닥
        3230, 3231, 3246, 3277: footstepsound := s_walk_wood_l;

        //던전..
        3780..3799: footstepsound := s_walk_wood_l;

        3825..4434: if (bidx - 3825) mod 25 = 0 then
            footstepsound := s_walk_wood_l
          else
            footstepsound := s_walk_ground_l;


        //집안(소리 별루 안남)
        2075..2099, 2125..2149: footstepsound := s_walk_room_l;

        //개울
        1800..1824: footstepsound := s_walk_water_l;

        else
          footstepsound := s_walk_ground_l;
      end;
      //궁전내부
      if (bidx >= 825) and (bidx <= 1349) then begin
        if ((bidx - 825) div 25) mod 2 = 0 then
          footstepsound := s_walk_stone_l;
      end;
      //동굴내부
      if (bidx >= 1375) and (bidx <= 1799) then begin
        if ((bidx - 1375) div 25) mod 2 = 0 then
          footstepsound := s_walk_cave_l;
      end;
      case bidx of
        1385, 1386, 1391, 1392: footstepsound := s_walk_wood_l;
      end;

      bidx := Map.MArr[cx, cy].MidImg and $7FFF;
      bidx := bidx - 1;
      case bidx of
        0..115: footstepsound   := s_walk_ground_l;
        120..124: footstepsound := s_walk_lawn_l;
      end;

      bidx := Map.MArr[cx, cy].FrImg and $7FFF;
      bidx := bidx - 1;
      case bidx of
        //벽돌길
        221..289, 583..658, 1183..1206, 7163..7295,
        7404..7414: footstepsound := s_walk_stone_l;
        //나무마루
        3125..3267, {3319..3345, 3376..3433,} 3757..3948,
        6030..6999: footstepsound := s_walk_wood_l;
        //방바닥
        3316..3589: footstepsound := s_walk_room_l;
      end;
      if CurrentAction = SM_RUN then
        footstepsound := footstepsound + 2;

    end;

    if Sex = 0 then begin //남자
      screamsound := s_man_struck;
      diesound    := s_man_die;
    end else begin //여자
      screamsound := s_wom_struck;
      diesound    := s_wom_die;
    end;

    case CurrentAction of
      // 2003/03/15 신규무공
      SM_THROW, SM_HIT, SM_HIT + 1, SM_HIT + 2, SM_POWERHIT, SM_slashhit, SM_LONGHIT,
      SM_WIDEHIT, SM_WIDEHIT2, SM_FIREHIT, SM_CROSSHIT, SM_TWINHIT, SM_STONEHIT: begin
        case (weapon div 2) of
          6, 20: weaponsound := s_hit_short;
          1, 27, 28, 33: weaponsound := s_hit_wooden;
          2, 13, 9, 5, 14, 22, 25, 30, 35, 36, 37: weaponsound := s_hit_sword;
          4, 17, 10, 15, 16, 23, 26, 29, 31, 34: weaponsound := s_hit_do;
          3, 7, 11: weaponsound := s_hit_axe;
          24: weaponsound := s_hit_club;
          8, 12, 18, 21, 32: weaponsound := s_hit_long;
          //144, 145, 146, 147, 148, 149, 162, 163:
          72, 73, 74, 81: weaponsound := s_hit_killer1;
          //150, 151, 152, 153, 154, 155, 156, 157, 160, 161:
          75, 76, 77, 78, 80: weaponsound := s_hit_killer2;
          //158, 159:
          79: weaponsound := s_hit_killer3;
          else
            weaponsound := s_hit_fist;
        end;
      end;
      SM_STRUCK: begin
        if MagicStruckSound >= 1 then begin  //마법으로 맞음
          //strucksound := s_struck_magic;  //임시..
        end else begin
          hiter := PlayScene.FindActor(HiterCode);
          attackweapon := 0;
          if hiter <> nil then begin //때린놈이 무엇으로 때렸는지 검사
            attackweapon := hiter.weapon div 2;
            if hiter.Race = 0 then
              case (dress div 2) of
                3: //갑옷
                  case attackweapon of
                    6: strucksound := s_struck_armor_sword;
                    1, 2, 4, 5, 9, 10, 13, 14, 15, 16, 17,
                    22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 33, 34,
                    35, 36, 37: strucksound := s_struck_armor_sword;
                    3, 7, 11: strucksound := s_struck_armor_axe;
                    8, 12, 18, 21, 32: strucksound := s_struck_armor_longstick;
                    else
                      strucksound := s_struck_armor_fist;
                  end;
                else //일반
                  case attackweapon of
                    6: strucksound := s_struck_body_sword;
                    1, 2, 4, 5, 9, 10, 13, 14, 15, 16, 17,
                    22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 33, 34,
                    35, 36, 37: strucksound := s_struck_body_sword;
                    3, 7, 11: strucksound := s_struck_body_axe;
                    8, 12, 18, 21, 32: strucksound := s_struck_body_longstick;
                    else
                      strucksound := s_struck_body_fist;
                  end;
              end;
          end;
        end;
      end;
    end;

    //마법 소리
    if BoUseMagic and (CurMagic.MagicSerial > 0) then begin
      magicstartsound     := 10000 + CurMagic.MagicSerial * 10;
      magicfiresound      := 10000 + CurMagic.MagicSerial * 10 + 1;
      magicexplosionsound := 10000 + CurMagic.MagicSerial * 10 + 2;
    end;

  end else begin
    if CurrentAction = SM_STRUCK then begin
      if MagicStruckSound >= 1 then begin  //마법으로 맞음
        //strucksound := s_struck_magic;  //임시..
      end else begin
        hiter := PlayScene.FindActor(HiterCode);
        if hiter <> nil then begin  //때린놈이 무엇으로 때렸는지 검사
          attackweapon := hiter.weapon div 2;
          case attackweapon of
            6: strucksound  := s_struck_body_sword;
            1, 2, 4, 5, 9, 10, 13, 14, 15, 16, 17,
            22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 33, 34, 35, 36,
            37: strucksound := s_struck_body_sword;
            3, 7, 11: strucksound := s_struck_body_axe;
            8, 12, 18, 21, 32: strucksound := s_struck_body_longstick;
            else
              strucksound := s_struck_body_fist;
          end;
        end;
      end;
    end;

    if Race = 50 then begin
    end else begin
      appearsound := 200 + (Appearance) * 10;
      normalsound := 200 + (Appearance) * 10 + 1;
      attacksound := 200 + (Appearance) * 10 + 2;  //우워억
      weaponsound := 200 + (Appearance) * 10 + 3;  //휙(무기휘두룸)
      screamsound := 200 + (Appearance) * 10 + 4;
      diesound    := 200 + (Appearance) * 10 + 5;
      die2sound   := 200 + (Appearance) * 10 + 6;
    end;
  end;

  //칼 맞는 소리
  if CurrentAction = SM_STRUCK then begin
    hiter := PlayScene.FindActor(HiterCode);
    attackweapon := 0;
    if hiter <> nil then begin  //때린놈이 무엇으로 때렸는지 검사
      attackweapon := hiter.weapon div 2;
      if hiter.Race = 0 then
        case (attackweapon div 2) of
          6, 20: struckweaponsound := s_struck_short;
          1, 27, 28, 33: struckweaponsound := s_struck_wooden;
          2, 13, 9, 5, 14, 22, 25, 30, 35, 36, 37: struckweaponsound := s_struck_sword;
          4, 17, 10, 15, 16, 23, 26, 29, 31, 34: struckweaponsound := s_struck_do;
          3, 7, 11: struckweaponsound := s_struck_axe;
          24: struckweaponsound := s_struck_club;
          8, 12, 18, 21, 32: struckweaponsound := s_struck_wooden; //long;
          //144, 145, 146, 147, 148, 149, 162, 163:
          72, 73, 74, 81: struckweaponsound := s_struck_killer1;
          //150, 151, 152, 153, 154, 155, 156, 157, 160, 161:
          75, 76, 77, 78, 80: struckweaponsound := s_struck_killer2;
          //158, 159:
          79: struckweaponsound := s_struck_killer3;
          //else struckweaponsound := s_struck_fist;
        end;
    end;
  end;
end;

procedure TActor.RunSound;
begin
  borunsound := True;
  SetSound;
  case CurrentAction of
    SM_STRUCK: begin
      if (struckweaponsound >= 0) then
        PlaySound(struckweaponsound);
      if (strucksound >= 0) then
        PlaySound(strucksound);
      if (screamsound >= 0) then
        PlaySound(screamsound);
    end;
    SM_NOWDEATH: begin
      if (diesound >= 0) then
        PlaySound(diesound);
    end;
    SM_THROW, SM_HIT, SM_FLYAXE, SM_LIGHTING, SM_LIGHTING_1, SM_DIGDOWN{문닫힘}: begin
      if ((Race = 91) and (CurrentAction = SM_LIGHTING)) then
        PlaySound(2406) // 설인대충 Attact2 사운드
      else if ((Race = 92) and (CurrentAction = SM_LIGHTING)) then
        PlaySound(2416) // 주마격뢰장 Attact2 사운드
      else if ((Race = 93) and (CurrentAction = SM_LIGHTING)) then
        PlaySound(2426) // 환영한호 Attact2 사운드
      else if ((Race = 94) and (CurrentAction = SM_LIGHTING)) then
        PlaySound(2436) // 거미 Attact2 사운드
      else if ((Race = 102) and (CurrentAction = SM_LIGHTING)) then
        PlaySound(2506) // BlackFoxman Attack 2
      else if ((Race = 103) and (CurrentAction = SM_LIGHTING)) then
        PlaySound(2516) // RedFoxman Attack
      else if ((Race = 103) and (CurrentAction = SM_LIGHTING_1)) then
        PlaySound(2517) // RedFoxman Attack 2
      else if ((Race = 104) and (CurrentAction = SM_FLYAXE)) then
        PlaySound(2526) // WhiteFoxman Attack
      else if ((Race = 104) and (CurrentAction = SM_LIGHTING)) then
        PlaySound(2527) // WhiteFoxman Attack 2
      else if ((Race = 104) and (CurrentAction = SM_LIGHTING_1)) then
        PlaySound(2528) // WhiteFoxman Attack 3
      else if ((Race = 105) and (CurrentAction = SM_LIGHTING)) then
        PlaySound(157) // TrapRock Attack
      else if ((Race = 109) and (CurrentAction = SM_LIGHTING_1)) then
        Playsound(2579) // GreatFoxSpirit Recall
      else if attacksound >= 0 then
        PlaySound(attacksound);
    end;
    //      SM_ALIVE, SM_DIGUP{등장,문열림}:
    SM_DIGUP{등장,문열림}: //####
    begin
      PlaySound(appearsound);
    end;
    SM_SPELL: begin
      PlaySound(magicstartsound);
    end;
  end;
end;

procedure TActor.RunActSound(frame: integer);
begin
  if borunsound then begin
    if Race = 0 then begin
      case CurrentAction of
        SM_THROW, SM_HIT, SM_HIT + 1, SM_HIT + 2: if frame = 2 then begin
            PlaySound(weaponsound);
            borunsound := False;
          end;
        SM_POWERHIT: if frame = 2 then begin
            PlaySound(weaponsound);
            if Sex = 0 then
              PlaySound(s_yedo_man)
            else
              PlaySound(s_yedo_woman);
            borunsound := False;
          end;
        SM_slashhit: if frame = 2 then begin
            PlaySound(weaponsound);
            PlaySound(s_slashhit);
            borunsound := False; //한번만 소리냄
          end;
        SM_LONGHIT: if frame = 2 then begin
            PlaySound(weaponsound);
            PlaySound(s_longhit);
            borunsound := False; //한번만 소리냄
          end;
        SM_WIDEHIT: if frame = 2 then begin
            PlaySound(weaponsound);
            PlaySound(s_widehit);
            borunsound := False;
          end;
        SM_WIDEHIT2: if frame = 2 then begin
            PlaySound(weaponsound);
            borunsound := False;
          end;
        SM_FIREHIT: if frame = 2 then begin
            PlaySound(weaponsound);
            PlaySound(s_firehit);
            borunsound := False;
          end;
        SM_CROSSHIT: if frame = 2 then begin
            PlaySound(weaponsound);
            PlaySound(s_crosshit);
            borunsound := False; //한번만 소리냄
          end;
        SM_TWINHIT: if frame = 2 then begin
            PlaySound(weaponsound);
            PlaySound(s_twinhit);
            borunsound := False;
          end;
      end;
    end else begin
      if Race = 50 then begin
      end else begin
        //(** 새 사운드
        if (CurrentAction = SM_WALK) or (CurrentAction = SM_TURN) then begin
          if (frame = 1) and (Random(8) = 1) then begin
            PlaySound(normalsound);
            borunsound := False; //한번만 소리냄
          end;
        end;
        if CurrentAction = SM_HIT then begin
          if (frame = 3) and (attacksound >= 0) then begin
            PlaySound(weaponsound);
            borunsound := False;
          end;
        end;
        case Appearance of
          80: //관박쥐
          begin
            if CurrentAction = SM_NOWDEATH then begin
              if (frame = 2) then begin
                PlaySound(die2sound);
                borunsound := False; //한번만 소리냄
              end;
            end;
          end;
        end;
      end; //*)

    end;
  end;
end;

procedure TActor.RunFrameAction(frame: integer);
begin
end;

procedure TActor.ActionEnded;
begin
end;

procedure TActor.Run;

  function MagicTimeOut: boolean;
  begin
    //      if self = Myself then begin
    Result := GetTickCount - WaitMagicRequest > 3000;
    //      end else
    //         Result := GetTickCount - WaitMagicRequest > 2000;
    if Result then
      CurMagic.ServerMagicCode := 0;
  end;

var
  prv:   integer;
  frametimetime: longword;
  bofly: boolean;
begin

  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) or (CurrentAction = SM_RUSH) or
    (CurrentAction = SM_RUSHKUNG) then
    exit;

  msgmuch := False;
  if self <> Myself then begin
    if MsgList.Count >= 2 then
      msgmuch := True;
  end;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    //      if (self <> Myself) and (BoUseMagic) then begin
    //         frametimetime := Round(frametime / 1.8);
    //      end else begin
    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime; //2004/04/07 속도관련 수정
    //      end;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin
        //마법인 경우 서버의 신호를 받아, 성공/실패를 확인한후
        //마지막동작을 끝낸다.
        if BoUseMagic then begin
          if (CurEffFrame = SpellFrame - 2) or (MagicTimeOut) then begin //기다림 끝
            if (CurMagic.ServerMagicCode >= 0) or (MagicTimeOut) then
            begin //서버로 부터 받은 결과. 아직 안왔으면 기다림
              Inc(currentframe);
              Inc(CurEffFrame);
              starttime := GetTickCount;
            end;
          end else begin
            if currentframe < endframe - 1 then
              Inc(currentframe);
            Inc(CurEffFrame);
            starttime := GetTickCount;
          end;
        end else begin
          Inc(currentframe);
          starttime := GetTickCount;
        end;

      end else begin
        if BoDelActionAfterFinished then begin
          //이 동작후 사라짐.
          BoDelActor := True;
        end;
        //동작이 끝남.
        if self = Myself then begin
          //주인공 인경우
          if FrmMain.ServerAcceptNextAction then begin
            ActionEnded;
            CurrentAction := 0;
            BoUseMagic    := False;
          end;
        end else begin
          ActionEnded;
          CurrentAction := 0; //동작 완료
          BoUseMagic    := False;
        end;
      end;
      if BoUseMagic then begin
        //마법을 쓰는 경우
        if CurEffFrame = SpellFrame - 1 then begin //마법 발사 시점
          //마법 발사
          if CurMagic.ServerMagicCode > 0 then begin
            with CurMagic do
              PlayScene.NewMagic(self,
                ServerMagicCode,
                EffectNumber,
                XX,
                YY,
                TargX,
                TargY,
                Target,
                EffectType,
                Recusion,
                AniTime,
                bofly);
            if bofly then
              PlaySound(magicfiresound)
            else
              PlaySound(magicexplosionsound);
          end;
          //LatestSpellTime := GetTickCount;
          CurMagic.ServerMagicCode := 0;
        end;
      end;
    end;
    if Appearance in [0, 1, 43] then
      currentdefframe := -10
    else
      currentdefframe := 0;
    defframetime := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;

end;

function TActor.Move(step: integer): boolean;
var
  prv, curstep, maxstep: integer;
  fastmove, normmove:    boolean;
begin
  Result   := False;
  fastmove := False;
  normmove := False;
  if (CurrentAction = SM_BACKSTEP) then
    //or (CurrentAction = SM_RUSH) or (CurrentAction = SM_RUSHKUNG) then
    fastmove := True;
  if (CurrentAction = SM_RUSH) or (CurrentAction = SM_RUSHKUNG) then
    normmove := True;
  // 2003/07/03 이벤트용 코드
  //   if ((UseItems[U_DRESS].S.Shape = 10) or
  //       (UseItems[U_DRESS].S.Shape = 12) )and (UseItems[U_DRESS].Dura > 0) then begin
  //      fastmove := TRUE;
  //   end;

  if (self = Myself) and (not fastmove) and (not normmove) then begin
    BoMoveSlow    := False;
    BoMoveSlow2   := False;
    BoAttackSlow  := False;
    MoveSlowLevel := 0;
    MoveSlowValue := 0;
    if Abil.Weight > Abil.MaxWeight then begin
      MoveSlowLevel := Abil.Weight div Abil.MaxWeight;
      BoMoveSlow    := True;
    end;
    if Abil.WearWeight > Abil.MaxWearWeight then begin
      MoveSlowLevel := MoveSlowLevel + Abil.WearWeight div Abil.MaxWearWeight;
      BoMoveSlow    := True;
    end;
    if Abil.HandWeight > Abil.MaxHandWeight then begin
      BoAttackSlow := True;
    end;
    // 2003/07/15 상태이상 추가 둔화 ... 이동 속도, 공격 속도 둔화
    if State and $08000000 <> 0 then begin        //POISON_SLOW
      MoveSlowLevel := MoveSlowLevel + 5;
      MoveSlowValue := 1; //저주술 슬로우 속도 조정
      BoMoveSlow2   := True;
      BoAttackSlow  := True;
    end;

    if BoMoveSlow and (SkipTick < MoveSlowLevel) then begin
      Inc(SkipTick); //한번 쉰다.
      exit;
    end else begin
      SkipTick := 0;
    end;

    if BoMoveSlow2 and (SkipTick2 > MoveSlowValue) then begin
      SkipTick2 := 0;
      exit;
    end else begin
      Inc(SkipTick2);
    end;

    //사운드 효과
    if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
      (CurrentAction = SM_RUN) or (CurrentAction = SM_RUSH) or
      (CurrentAction = SM_RUSHKUNG) then begin
      case (currentframe - startframe) of
        1: PlaySound(footstepsound);
        4: PlaySound(footstepsound + 1);
      end;
    end;
  end;

  Result  := False;
  msgmuch := False;
  if self <> Myself then begin
    if MsgList.Count >= 2 then
      msgmuch := True;
  end;
  prv := currentframe;
  //걷기 뛰기
  if (CurrentAction = SM_WALK) or (CurrentAction = SM_RUN) or
    (CurrentAction = SM_RUSH) or (CurrentAction = SM_RUSHKUNG) then begin
    if (currentframe < startframe) or (currentframe > endframe) then begin
      currentframe := startframe - 1;
    end;
    if currentframe < endframe then begin
      Inc(currentframe);
      if msgmuch and not normmove then //or fastmove then
        if currentframe < endframe then
          Inc(currentframe);

      //부드럽게 이동하게 하려고
      curstep := currentframe - startframe + 1;
      maxstep := endframe - startframe + 1;
      Shift(Dir, movestep, curstep, maxstep);
    end;
    if currentframe >= endframe then begin
      if self = Myself then begin
        if FrmMain.ServerAcceptNextAction then begin
          CurrentAction  := 0;      //서버의 신호를 받으면 다음 동작
          LockEndFrame   := True;   //서버의신호가 없어서 마지막프래임에서 멈춤
          smoothmovetime := GetTickCount;
        end;
      end else begin
        CurrentAction  := 0; //동작 완료
        LockEndFrame   := True;
        smoothmovetime := GetTickCount;
      end;
      Result := True;
    end;
    if CurrentAction = SM_RUSH then begin
      if self = Myself then begin
        DizzyDelayStart := GetTickCount;
        DizzyDelayTime  := 300; //딜레이
      end;
    end;
    if CurrentAction = SM_RUSHKUNG then begin
      if currentframe >= endframe - 3 then begin
        XX := actbeforex;
        YY := actbeforey;
        Rx := XX;
        Ry := YY;
        CurrentAction := 0;
        LockEndFrame := True;
        //smoothmovetime := GetTickCount;
      end;
    end;
    Result := True;
  end;
  //뒷걸음질
  if (CurrentAction = SM_BACKSTEP) then begin
    if (currentframe > endframe) or (currentframe < startframe) then begin
      currentframe := endframe + 1;
    end;
    if currentframe > startframe then begin
      Dec(currentframe);
      if msgmuch or fastmove then
        if currentframe > startframe then
          Dec(currentframe);

      //부드럽게 이동하게 하려고
      curstep := endframe - currentframe + 1;
      maxstep := endframe - startframe + 1;
      Shift(GetBack(Dir), movestep, curstep, maxstep);
    end;
    if currentframe <= startframe then begin
      if self = Myself then begin
        //if FrmMain.ServerAcceptNextAction then begin
        CurrentAction  := 0;     //서버의 신호를 받으면 다음 동작
        LockEndFrame   := True;   //서버의신호가 없어서 마지막프래임에서 멈춤
        smoothmovetime := GetTickCount;

        //뒤로 밀린 다음 한동안 못 움직인다.
        DizzyDelayStart := GetTickCount;
        DizzyDelayTime  := 1000; //1초 딜레이
        //end;
      end else begin
        CurrentAction  := 0; //동작 완료
        LockEndFrame   := True;
        smoothmovetime := GetTickCount;
      end;
      Result := True;
    end;
    Result := True;
  end;
  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;

procedure TActor.MoveFail;
begin
  CurrentAction := 0; //동작 완료
  LockEndFrame  := True;
  Myself.XX     := oldx;
  Myself.YY     := oldy;
  Myself.Dir    := olddir;
  CleanUserMsgs;
end;

function TActor.CanCancelAction: boolean;
begin
  Result := False;
  if CurrentAction = SM_HIT then
    if not BoUseEffect then
      Result := True;
end;

procedure TActor.CancelAction;
begin
  CurrentAction := 0; //동작 완료
  LockEndFrame  := True;
end;

procedure TActor.CleanCharMapSetting(x, y: integer);
begin
  Myself.XX := x;
  Myself.YY := y;
  Myself.RX := x;
  Myself.RY := y;
  oldx      := x;
  oldy      := y;
  CurrentAction := 0;
  currentframe := -1;
  CleanUserMsgs;
end;

procedure TActor.Say(str: string);
var
  i, len, aline, n: integer;
  dline, temp: string;
  loop: boolean;
const
  MAXWIDTH = 150;
begin
  SayTime      := GetTickCount;
  SayLineCount := 0;

  n    := 0;
  loop := True;
  while loop do begin
    temp := '';
    i    := 1;
    len  := Length(str);
    while True do begin
      if i > len then begin
        loop := False;
        break;
      end;
      if byte(str[i]) >= 128 then begin
        temp := temp + str[i];
        Inc(i);
        if i <= len then
          temp := temp + str[i]
        else begin
          loop := False;
          break;
        end;
      end else
        temp := temp + str[i];

      aline := FrmMain.Canvas.TextWidth(temp);
      if aline > MAXWIDTH then begin
        Saying[n]    := temp;
        SayWidths[n] := aline;
        Inc(SayLineCount);
        Inc(n);
        if n >= MAXSAY then begin
          loop := False;
          break;
        end;
        str  := Copy(str, i + 1, Len - i);
        temp := '';
        break;
      end;
      Inc(i);
    end;
    if temp <> '' then begin
      if n < MAXWIDTH then begin
        Saying[n]    := temp;
        SayWidths[n] := FrmMain.Canvas.TextWidth(temp);
        Inc(SayLineCount);
      end;
    end;
  end;
end;



{============================== NPCActor =============================}


// 2003/07/15 신규 NPC 추가
constructor TNpcActor.Create;
begin
  inherited Create;
  EffectSurface := nil;
  BoUseEffect   := False;
  PlaySnow      := False;
end;

procedure TNpcActor.CalcActorFrame;
var
  pm: PTMonsterAction;
  haircount: integer;
begin
  BoUseMagic   := False;
  currentframe := -1;

  BodyOffset := GetNpcOffset(Appearance);

  pm := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;
  Dir := Dir mod 3;  //방향은 0, 1, 2 밖에 없음..
  case CurrentAction of
    SM_TURN: //NewNpc
    begin
      if Appearance = 57 then begin
        Dir := 0;
        pm.ActStand.frame := 10;
        pm.ActStand.ftime := 120;
      end else if Appearance in [58, 60] then
        Dir := 0;

      startframe    := pm.ActStand.start + Dir *
        (pm.ActStand.frame + pm.ActStand.skip);
      endframe      := startframe + pm.ActStand.frame - 1;
      frametime     := pm.ActStand.ftime;
      starttime     := GetTickCount;
      defframecount := pm.ActStand.frame;
      Shift(Dir, 0, 0, 1);

      if ((Appearance = 33) or (Appearance = 34)) and (not BoUseEffect) then begin
        BoUseEffect := True;
        effectstart := 30;
        effectframe := effectstart;
        effectend   := effectstart + 9;
        effectstarttime := GetTickCount;
        effectframetime := 300;
      end else if Appearance in [42, 43, 44, 45, 46, 47] then begin //FireDragon
        startframe  := 20;
        endframe    := 10;
        BoUseEffect := True;
        effectstart := 0;
        effectframe := 0;
        effectend   := 19;
        effectstarttime := GetTickCount;
        effectframetime := 100;
      end else if Appearance = 51 then begin //2004/05/27 50LevelQuest
        BoUseEffect := True;
        effectstart := 60;
        effectframe := effectstart;
        effectend   := effectstart + 7;
        effectstarttime := GetTickCount;
        effectframetime := 500;
      end;
    end;
    SM_HIT: begin
      // 2003/07/15 신규 NPC 추가
      if Appearance = 57 then begin
        Dir := 0;
        pm.ActStand.frame := 10;
        pm.ActStand.ftime := 120;
      end else if Appearance in [58, 60] then
        Dir := 0;

      if Appearance in [33, 34, 35..41, 48..50, 53..55, 57..60] then begin
        //            if Appearance = 55 then DScreen.AddChatBoardString ('Appearance = 55', clYellow, clRed);
        startframe    := pm.ActStand.start + Dir *
          (pm.ActStand.frame + pm.ActStand.skip);
        endframe      := startframe + pm.ActStand.frame - 1;
        frametime     := pm.ActStand.ftime;
        starttime     := GetTickCount;
        defframecount := pm.ActStand.frame;
      end else begin
        startframe := pm.ActAttack.start + Dir *
          (pm.ActAttack.frame + pm.ActAttack.skip);
        endframe   := startframe + pm.ActAttack.frame - 1;
        frametime  := pm.ActAttack.ftime;
        starttime  := GetTickCount;
        if Appearance = 51 then begin //2004/05/27 50LevelQuest
          BoUseEffect := True;
          effectstart := 60;
          effectframe := effectstart;
          effectend   := effectstart + 7;
          effectstarttime := GetTickCount;
          effectframetime := 500;
        end;
      end;
    end;
    SM_DIGUP: begin
      if Appearance = 53 then begin //2004/12/14 눈사람
        PlaySnow      := True;
        SnowStartTime := GetTickCount + 23000;
        Randomize;
        SilenceSound;
        PlaySound(146 + Random(7));
        //   DScreen.AddChatBoardString ('눈사람 SM_DIGUP PlaySong=> '+IntToStr(146+Random(7)), clYellow, clRed);
        BoUseEffect := True;
        effectstart := 60;
        effectframe := effectstart;
        effectend   := effectstart + 11;
        effectstarttime := GetTickCount;
        effectframetime := 100;
      end;
    end;
  end;
  if Appearance in [35..41, 48..50, 53..55, 57..60] then
    Dir := 0; //한방향 고정 NewNpc
end;

function TNpcActor.GetDefaultFrame(wmode: boolean): integer;
var
  cf, dr: integer;
  pm:     PTMonsterAction;
begin
  Result := 0;
  pm     := RaceByPm(Race, Appearance);
  if pm = nil then
    exit;
  Dir := Dir mod 3;  //방향은 0, 1, 2 밖에 없음..

  if Appearance in [35..41, 48..50, 53..55, 57..60] then
    Dir := 0; //한방향 고정 NewNpc

  if currentdefframe < 0 then
    cf := 0
  else if currentdefframe >= pm.ActStand.frame then
    cf := 0
  else
    cf := currentdefframe;
  Result := pm.ActStand.start + Dir * (pm.ActStand.frame + pm.ActStand.skip) + cf;
end;

procedure TNpcActor.LoadSurface;
begin
  case Race of
    //상인 Npc
    50: BodySurface := FrmMain.WNpcImg.GetCachedImage(BodyOffset +
        currentframe, px, py);
  end;

  if Appearance in [42, 43, 44, 45, 46, 47] then begin
    // BodySurface 필요없음 불의경우 이펙트만 필요 (탑은 Object)
    BodySurface := nil;
  end;

  if BoUseEffect then begin // 시공석,화롯불,탑불,귀신npc
    if Appearance in [33, 34] then begin // 화면에 나타나는 위치 보정
      EffectSurface := FrmMain.WNpcImg.GetCachedImage(BodyOffset +
        effectframe, ax, ay);
    end else if Appearance = 42 then
    begin// 불항아리(우) Object와 위치를 각자 맞춰야함.  FireDragon
      EffectSurface := FrmMain.WNpcImg.GetCachedImage(BodyOffset +
        effectframe, ax, ay);
      ax := ax + 71;
      ay := ay + 5;
    end else if Appearance = 43 then begin// 불항아리(좌)
      EffectSurface := FrmMain.WNpcImg.GetCachedImage(BodyOffset +
        effectframe, ax, ay);
      ax := ax + 71;
      ay := ay + 37;
    end else if Appearance = 44 then begin// 탑불(우하)
      EffectSurface := FrmMain.WNpcImg.GetCachedImage(BodyOffset +
        effectframe, ax, ay);
      ax := ax + 7;
      ay := ay - 12;
    end else if Appearance = 45 then begin// 탑불(우상)
      EffectSurface := FrmMain.WNpcImg.GetCachedImage(BodyOffset +
        effectframe, ax, ay);
      ax := ax + 6;
      ay := ay - 12;
    end else if Appearance = 46 then begin// 탑불(좌하)
      EffectSurface := FrmMain.WNpcImg.GetCachedImage(BodyOffset +
        effectframe, ax, ay);
      ax := ax + 7;
      ay := ay - 12;
    end else if Appearance = 47 then begin// 탑불(좌상)
      EffectSurface := FrmMain.WNpcImg.GetCachedImage(BodyOffset +
        effectframe, ax, ay);
      ax := ax + 8;
      ay := ay - 12;
    end else if Appearance = 51 then begin// 귀신 npc
      EffectSurface := FrmMain.WNpcImg.GetCachedImage(BodyOffset +
        effectframe, ax, ay);
    end else if Appearance = 53 then begin// 눈사람
      EffectSurface := FrmMain.WNpcImg.GetCachedImage(BodyOffset +
        effectframe, ax, ay);
    end;

  end;

end;

procedure TNpcActor.Run;
var
  prv: integer;
  effectframetimetime: longword;
begin
  inherited Run;
  // 2003/07/15 신규 NPC 추가
  prv := effectframe;
  if BoUseEffect then begin
    if msgmuch then
      effectframetimetime := Round(effectframetime * 2 / 3)
    else
      effectframetimetime := effectframetime;
    if GetTickCount - effectstarttime > effectframetimetime then begin
      effectstarttime := GetTickCount;
      if effectframe < effectend then begin
        Inc(effectframe);
      end else begin
        if PlaySnow then begin
          if SnowStartTime < GetTickCount then begin
            BoUseEffect   := False;
            PlaySnow      := False;
            SnowStartTime := GetTickCount;
          end;
          effectframe := effectstart;
        end else
          effectframe := effectstart;
        effectstarttime := GetTickCount;
      end;
    end;
  end;
  if (prv <> effectframe) then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;
end;

// 2003/07/15 신규 NPC 추가
procedure TNpcActor.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend: boolean; WingDraw: boolean);
var
  idx, ax, ay: integer;
  d:    TDirectDrawSurface;
  ceff: TColorEffect;
  wimg: TWMImages;
begin
  Dir := Dir mod 3;  //방향은 0, 1, 2 밖에 없음..
  if GetTickCount - loadsurfacetime > 60 * 1000 then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;

  ceff := GetDrawEffectValue;

  if BodySurface <> nil then begin
    if Appearance = 51 then begin //귀신 npc
      DrawEffSurface(dsurface, BodySurface, dx + px + ShiftX, dy +
        py + ShiftY, True, ceff);
      DrawEffSurface(dsurface, BodySurface, dx + px + ShiftX, dy +
        py + ShiftY, True, ceff);
    end else
      DrawEffSurface(dsurface, BodySurface, dx + px + ShiftX, dy +
        py + ShiftY, blend, ceff);
  end;
  // inherited DrawChr(dsurface, dx, dy, blend);
end;

procedure TNpcActor.DrawEff(dsurface: TDirectDrawSurface; dx, dy: integer);
begin
  if BoUseEffect then
    if EffectSurface <> nil then begin
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        EffectSurface, 1);
    end;
end;


{============================== HUMActor =============================}

//            사람

{-------------------------------}


constructor THumActor.Create;
begin
  inherited Create;
  HairSurface    := nil;
    WeaponSurface := nil;
    Weapon2Surface := nil;
  WingSurface    := nil;
  BoWeaponEffect := False;
  KillerMode     := False;

  WingFrameTime := 150;
  WingStartTime := GetTickCount;
  WingCurrentFrame := 0;
  WingOffset := 0;

  H50LevelEffectSurface := nil;
  H50LevelEffectFrameTime := 150;
  H50LevelEffectStartTime := GetTickCount;
  H50LevelEffectCurrentFrame := 0;
  H50LevelEffectOffset := 312;
end;

destructor THumActor.Destroy;
begin
  inherited Destroy;
end;

procedure THumActor.CalcActorFrame;
var
  haircount: integer;
begin
  BoUseMagic := False;
  BoHitEffect := False;
  currentframe := -1;
  //human
  hair   := HAIRfeature(Feature);         //변경된다.
  //   dress  := DRESSfeature (Feature); //무태보시 옷갈아입으면 문제가 됨, 그래서 주석 처리
  //      DScreen.AddChatBoardString ('CalcActorFrame() dress=> '+IntToStr(dress), clYellow, clRed);
  weapon := WEAPONfeature(Feature);
    if weapon in [144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155,
    156, 157, 158, 159, 160, 161, 162, 163] then KillerMode := True
    else KillerMode := False;
    if dress in [150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161,
    162, 163, 164, 165, 166, 167] then SecondHum := True
    else SecondHum := False;
      if SecondHum then begin
      if KillerMode then begin
      BodyOffset := (KILLERFRAME * (Dress - 150)); //남자0, 여자1
      haircount := FrmMain.WHairImg.ImageCount div HUMANFRAME div 2;
      if hair > haircount - 1 then
        hair := haircount - 1;
      hair := hair;
      if hair > 1 then
        HairOffset := KILLERFRAME * (hair + Sex)
      else
        HairOffset := -1;
      end else begin
      BodyOffset := (HUMANFRAME + 320) * (Dress - 150); //남자0, 여자1
      haircount := FrmMain.WHairImg.ImageCount div HUMANFRAME div 2;
      if hair > haircount - 1 then
        hair := haircount - 1;
      hair := hair * 2;
      if hair > 1 then
        HairOffset := HUMANFRAME * (hair + Sex)
      else
        HairOffset := -1;
      end;
      end else begin
      if KillerMode then begin
      BodyOffset := (KILLERFRAME * Dress); //남자0, 여자1
      haircount := FrmMain.WHairImg.ImageCount div HUMANFRAME div 2;
      if hair > haircount - 1 then
        hair := haircount - 1;
      hair := hair;
      if hair > 1 then
        HairOffset := KILLERFRAME * (hair + Sex)
      else
        HairOffset := -1;
      end else begin
      BodyOffset := HUMANFRAME * Dress; //남자0, 여자1
      haircount := FrmMain.WHairImg.ImageCount div HUMANFRAME div 2;
      if hair > haircount - 1 then
        hair := haircount - 1;
      hair := hair * 2;
      if hair > 1 then
        HairOffset := HUMANFRAME * (hair + Sex)
      else
        HairOffset := -1;
      end;
      end;
      if KillerMode then begin
      if weapon in [144, 145] then WeaponOffset := KILLERFRAME * 0
      else if weapon in [146, 147] then WeaponOffset := KILLERFRAME
      else
      WeaponOffset := KILLERFRAME * (weapon - 144);
      end else begin
      WeaponOffset := WEAPONFRAME * weapon;
      end;
  if KillerMode then begin
  if dress = 18 then
    WingOffset := 0                  // 천의무봉(남)
  else if dress = 19 then
    WingOffset := KILLERFRAME    // 천의무봉(여)
  else if dress = 20 then
    WingOffset := KILLERFRAME * 2  // 천룡불사의(남)
  else if dress = 21 then
    WingOffset := KILLERFRAME * 3 // 천룡불사의(여)
  else if dress in [22, 23] then
    WingOffset := 352; // 50레벨옷
  end else begin
  if dress = 18 then
    WingOffset := 0                  // 천의무봉(남)
  else if dress = 19 then
    WingOffset := HUMANFRAME    // 천의무봉(여)
  else if dress = 20 then
    WingOffset := HUMANFRAME * 2  // 천룡불사의(남)
  else if dress = 21 then
    WingOffset := HUMANFRAME * 3 // 천룡불사의(여)
  else if dress in [22, 23] then
    WingOffset := 352; // 50레벨옷
  end;

  case CurrentAction of
    SM_TURN: begin
      startframe    := HA.ActStand.start + Dir *
        (HA.ActStand.frame + HA.ActStand.skip);
      endframe      := startframe + HA.ActStand.frame - 1;
      frametime     := HA.ActStand.ftime;
      starttime     := GetTickCount;
      defframecount := HA.ActStand.frame;
      Shift(Dir, 0, 0, endframe - startframe + 1);
    end;
    SM_WALK,
    SM_BACKSTEP: begin
      startframe := HA.ActWalk.start + Dir * (HA.ActWalk.frame + HA.ActWalk.skip);
      endframe   := startframe + HA.ActWalk.frame - 1;
      frametime  := HA.ActWalk.ftime;
      starttime  := GetTickCount;
      maxtick    := HA.ActWalk.UseTick;
      curtick    := 0;
      //WarMode := FALSE;
      movestep   := 1;
      if CurrentAction = SM_BACKSTEP then
        Shift(GetBack(Dir), movestep, 0, endframe - startframe + 1)
      else
        Shift(Dir, movestep, 0, endframe - startframe + 1);
    end;
    SM_RUSH: begin
      if RushDir = 0 then begin
        RushDir    := 1;
        startframe := HA.ActRushLeft.start + Dir *
          (HA.ActRushLeft.frame + HA.ActRushLeft.skip);
        endframe   := startframe + HA.ActRushLeft.frame - 1;
        frametime  := HA.ActRushLeft.ftime;
        starttime  := GetTickCount;
        maxtick    := HA.ActRushLeft.UseTick;
        curtick    := 0;
        movestep   := 1;
        Shift(Dir, 1, 0, endframe - startframe + 1);
      end else begin
        RushDir    := 0;
        startframe := HA.ActRushRight.start + Dir *
          (HA.ActRushRight.frame + HA.ActRushRight.skip);
        endframe   := startframe + HA.ActRushRight.frame - 1;
        frametime  := HA.ActRushRight.ftime;
        starttime  := GetTickCount;
        maxtick    := HA.ActRushRight.UseTick;
        curtick    := 0;
        movestep   := 1;
        Shift(Dir, 1, 0, endframe - startframe + 1);
      end;
    end;
    SM_RUSHKUNG: begin
      startframe := HA.ActRun.start + Dir * (HA.ActRun.frame + HA.ActRun.skip);
      endframe   := startframe + HA.ActRun.frame - 1;
      frametime  := HA.ActRun.ftime;
      starttime  := GetTickCount;
      maxtick    := HA.ActRun.UseTick;
      curtick    := 0;
      movestep   := 1;
      Shift(Dir, movestep, 0, endframe - startframe + 1);
    end;
      {SM_BACKSTEP:
         begin
            startframe := pm.ActWalk.start + (pm.ActWalk.frame - 1) + Dir * (pm.ActWalk.frame + pm.ActWalk.skip);
            endframe := startframe - (pm.ActWalk.frame - 1);
            frametime := pm.ActWalk.ftime;
            starttime := GetTickCount;
            maxtick := pm.ActWalk.UseTick;
            curtick := 0;
            movestep := 1;
            Shift (GetBack(Dir), movestep, 0, endframe-startframe+1);
         end;  }
    SM_SITDOWN: begin
      startframe := HA.ActSitdown.start + Dir *
        (HA.ActSitdown.frame + HA.ActSitdown.skip);
      endframe   := startframe + HA.ActSitdown.frame - 1;
      frametime  := HA.ActSitdown.ftime;
      starttime  := GetTickCount;
    end;
    SM_RUN: begin
      startframe := HA.ActRun.start + Dir * (HA.ActRun.frame + HA.ActRun.skip);
      endframe   := startframe + HA.ActRun.frame - 1;
      frametime  := HA.ActRun.ftime;
      starttime  := GetTickCount;
      maxtick    := HA.ActRun.UseTick;
      curtick    := 0;
      //WarMode := FALSE;
      if CurrentAction = SM_RUN then
        movestep := 2
      else
        movestep := 1;
      //movestep := 2;
      Shift(Dir, movestep, 0, endframe - startframe + 1);
    end;
    SM_THROW: begin
      startframe  := HA.ActHit.start + Dir * (HA.ActHit.frame + HA.ActHit.skip);
      endframe    := startframe + HA.ActHit.frame - 1;
      frametime   := HA.ActHit.ftime;
      starttime   := GetTickCount;
      WarMode     := True;
      WarModeTime := GetTickCount;
      BoThrow     := True;
      Shift(Dir, 0, 0, 1);
    end;
    // 2003/03/15 신규무공
    SM_HIT, SM_POWERHIT, SM_slashhit, SM_LONGHIT, SM_WIDEHIT, SM_FIREHIT, SM_CROSSHIT,
    SM_TWINHIT, SM_WIDEHIT2: begin
      if (KillerMode) and (KillerSecondHit = False) and (Random(5) = 0) then
      KillerSecondHit := True;

      if KillerSecondHit then begin
      //          DScreen.AddSysMsg (UserName +' ''s Current Action =' + IntToStr(CurrentAction));
      startframe  := (HA.ActHit.start + 400) + Dir * (HA.ActHit.frame + HA.ActHit.skip);
      if (CurrentAction = SM_WIDEHIT2) then begin   //Assassin Skill 2
        BoHitEffect := True;
        MagLight    := 2;
        HitEffectNumber := 11;
        PlaySound(s_widehit2l)
      end;
      KillerSecondHit := False;
      end else begin
      //          DScreen.AddSysMsg (UserName +' ''s Current Action =' + IntToStr(CurrentAction));
      startframe  := HA.ActHit.start + Dir * (HA.ActHit.frame + HA.ActHit.skip);
      if (CurrentAction = SM_WIDEHIT2) then begin   //Assassin Skill 2
        BoHitEffect := True;
        MagLight    := 2;
        HitEffectNumber := 10;
        PlaySound(s_widehit2r);
    end;
    end;
      endframe    := startframe + HA.ActHit.frame - 1;
      frametime   := HA.ActHit.ftime;
      starttime   := GetTickCount;
      WarMode     := True;
      WarModeTime := GetTickCount;
      if (CurrentAction = SM_POWERHIT) then begin
        BoHitEffect := True;
        MagLight    := 2;
        HitEffectNumber := 1;
      end;
      if (CurrentAction = SM_slashhit) then begin   //Slash
        BoHitEffect := True;
        MagLight    := 2;
        HitEffectNumber := 9;
      end;
      if (CurrentAction = SM_LONGHIT) then begin
        BoHitEffect := True;
        MagLight    := 2;
        HitEffectNumber := 2;
      end;
      if (CurrentAction = SM_WIDEHIT) then begin
        BoHitEffect := True;
        MagLight    := 2;
        HitEffectNumber := 3;
      end;
      if (CurrentAction = SM_FIREHIT) then begin
        BoHitEffect := True;
        MagLight    := 2;
        HitEffectNumber := 4;
      end;
      // 2003/03/15 신규무공
      if (CurrentAction = SM_CROSSHIT) then begin
        BoHitEffect := True;
        MagLight    := 2;
        HitEffectNumber := 6;
      end;
      if (CurrentAction = SM_TWINHIT) then begin
        BoHitEffect := True;
        MagLight    := 2;
        HitEffectNumber := 7;
      end;

      Shift(Dir, 0, 0, 1);
    end;
    SM_HEAVYHIT: begin
      startframe  := HA.ActHeavyHit.start + Dir *
        (HA.ActHeavyHit.frame + HA.ActHeavyHit.skip);
      endframe    := startframe + HA.ActHeavyHit.frame - 1;
      frametime   := HA.ActHeavyHit.ftime;
      starttime   := GetTickCount;
      WarMode     := True;
      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
    end;
    SM_BIGHIT: begin
      startframe  := HA.ActBigHit.start + Dir *
        (HA.ActBigHit.frame + HA.ActBigHit.skip);
      endframe    := startframe + HA.ActBigHit.frame - 1;
      frametime   := HA.ActBigHit.ftime;
      starttime   := GetTickCount;
      WarMode     := True;
      WarModeTime := GetTickCount;
      Shift(Dir, 0, 0, 1);
      if Sex = 0 then
      Playsound(168)
      else
      Playsound(169);
    end;
    SM_SPELL: begin
      startframe  := HA.ActSpell.start + Dir *
        (HA.ActSpell.frame + HA.ActSpell.skip);
      endframe    := startframe + HA.ActSpell.frame - 1;
      frametime   := HA.ActSpell.ftime;
      starttime   := GetTickCount;
      CurEffFrame := 0;
      BoUseMagic  := True;
      case CurMagic.EffectNumber of
        22: begin //뢰설화
          MagLight   := 4;  //뢰설화
          SpellFrame := 10; //뢰설화는 10 프래임으로 변경
                WarMode     := True;
                      WarModeTime := GetTickCount;
        end;
        26: begin //탐기파연
          MagLight   := 2;
          SpellFrame := 20;
          frametime  := frametime div 2;
                WarMode     := True;
                      WarModeTime := GetTickCount;
        end;
        35: begin //무극진기 PDS 2003-03-27
          MagLight   := 2;  //무극진기
          SpellFrame := 15; //무극진기는 15 프래임으로 변경
                WarMode     := True;
                      WarModeTime := GetTickCount;
        end;
        43: begin // 사자후
          MagLight   := 2;
          SpellFrame := 20;
          frametime  := 70;
                WarMode     := True;
                      WarModeTime := GetTickCount;
        end;
        44: begin // 공파섬
          startframe  :=
            HA.ActBigHit.start + Dir * (HA.ActBigHit.frame + HA.ActBigHit.skip);
          endframe    := startframe + HA.ActBigHit.frame - 1;
          frametime   := HA.ActBigHit.ftime;
          starttime   := GetTickCount;
          MagLight    := 2;
          SpellFrame  := 20;
          SKillStartTime := GetTickCount;
          SKillCurrentFrame := 0;
          //                  SKillFrametime    := 80;
          SKillFrametime := frametime;
          BoHitEffect := True;
          HitEffectNumber := 8;
          PlaySound(weaponsound);
          PlaySound(s_twinhit);
                WarMode     := True;
                      WarModeTime := GetTickCount;
        end;
        45: begin //화룡기염
          MagLight   := 2;
          SpellFrame := 10; //23;
          frametime  := 100;//100;
          FrmMain.UseNormalEffect(NE_FIRECIRCLE, self.XX, self.YY);
          // 마법 시젼중 움직일수 있게 하려고
                WarMode     := True;
                      WarModeTime := GetTickCount;
        end;
        47: begin // 포승검
          MagLight   := 2;
          SpellFrame := 10;
          frametime  := 80;
                WarMode     := True;
                      WarModeTime := GetTickCount;
        end;
        50: begin //무극진기 PDS 2003-03-27
          MagLight   := 2;  //무극진기
          SpellFrame := 10; //무극진기는 15 프래임으로 변경
                WarMode     := True;
                      WarModeTime := GetTickCount;
        end;
        52, 53: begin // Blizzard MeteorStrike
          startframe  := HA.ActSpell.start + Dir *
        (HA.ActSpell.frame + HA.ActSpell.skip);
          endframe    := startframe + HA.ActSpell.frame - 2;
          frametime   := HA.ActBigHit.ftime;
          MagLight    := 2;
          WarMode := False;
          bigmagmode := True;
                WarModeTime := GetTickCount;
        end;
        54: begin // Reincarnation
          MagLight    := 1;
        end;
        else begin //.....  대회복술, 사자윤회, 빙설풍
          MagLight   := 2;
          SpellFrame := DEFSPELLFRAME;
          WarMode     := True;
                WarModeTime := GetTickCount;
        end;
      end;
      WaitMagicRequest := GetTickCount;
      Shift(Dir, 0, 0, 1);
    end;
      (*SM_READYFIREHIT:
         begin
            startframe := HA.ActFireHitReady.start + Dir * (HA.ActFireHitReady.frame + HA.ActFireHitReady.skip);
            endframe := startframe + HA.ActFireHitReady.frame - 1;
            frametime := HA.ActFireHitReady.ftime;
            starttime := GetTickCount;

            BoHitEffect := TRUE;
            HitEffectNumber := 4;
            MagLight := 2;

            CurGlimmer := 0;
            MaxGlimmer := 6;

            WarMode := TRUE;
            WarModeTime := GetTickCount;
            Shift (Dir, 0, 0, 1);
         end; *)
    SM_STRUCK: begin
      startframe := HA.ActStruck.start + Dir *
        (HA.ActStruck.frame + HA.ActStruck.skip);
      endframe   := startframe + HA.ActStruck.frame - 1;
      frametime  := struckframetime; //HA.ActStruck.ftime;
      starttime  := GetTickCount;
      Shift(Dir, 0, 0, 1);

      genanicounttime := GetTickCount;
      CurBubbleStruck := 0;
      bigmagmode := False;
      revivalmode := False;
    end;
    SM_NOWDEATH: begin
      startframe := HA.ActDie.start + Dir * (HA.ActDie.frame + HA.ActDie.skip);
      endframe   := startframe + HA.ActDie.frame - 1;
      frametime  := HA.ActDie.ftime;
      starttime  := GetTickCount;
    end;
  end;
end;

procedure THumActor.DefaultMotion;
begin
  inherited DefaultMotion;
  if (Dress in [22, 23]) and (currentframe < 536) then begin
    if GetTickCount - WingStartTime > 100 then begin
      if WingCurrentFrame < 19 then
        Inc(WingCurrentFrame)
      else begin
        if not Bo50DressHEffect then
          Bo50DressHEffect := True
        else
          Bo50DressHEffect := False;
        WingCurrentFrame := 0;
      end;
      //         DScreen.AddSysMsg ('THumActor.DefaultMotion=>(Dress in [22,23])');
      WingStartTime := GetTickCount;
    end;
    WingSurface := FrmMain.WEffectImg.GetCachedImage(WingOffset +
      WingCurrentFrame, epx, epy);
  end else if (Dress in [18, 19, 20, 21]) and (currentframe < 64) then begin
    if GetTickCount - WingStartTime > WingFrametime then begin
      if WingCurrentFrame < 7 then
        Inc(WingCurrentFrame)
      else
        WingCurrentFrame := 0;
      //         DScreen.AddSysMsg ('THumActor.DefaultMotion=>(Dress in [Wing])');
      WingStartTime := GetTickCount;
    end;
    if KillerMode then
    WingSurface := FrmMain.WKillerWing.GetCachedImage(WingOffset +
      Dir * 8 + WingCurrentFrame, epx, epy)
    else
    WingSurface := FrmMain.WHumWing.GetCachedImage(WingOffset +
      Dir * 8 + WingCurrentFrame, epx, epy)
  end;
  if currentframe > 535 then
    Bo50DressHEffect := False;


  if Bo50LevelEffect then begin
    if GetTickCount - H50LevelEffectStartTime > H50LevelEffectFrameTime then begin
      if H50LevelEffectCurrentFrame < 7 then
        Inc(H50LevelEffectCurrentFrame)
      else begin
        H50LevelEffectCurrentFrame := 0;
        Bo50LevelHEffect := not Bo50LevelHEffect;
      end;
      H50LevelEffectStartTime := GetTickCount;
    end;
    H50LevelEffectSurface :=
      FrmMain.WEffectImg.GetCachedImage(H50LevelEffectOffset +
      H50LevelEffectCurrentFrame, epx2, epy2);
  end;

{if KillerMode then begin
WeaponSurface := FrmMain.WWeapon.GetCachedImage(WeaponOffset + currentframe, wpx, wpy);
Weapon2Surface := FrmMain.WWeapon.GetCachedImage(WeaponOffset + currentframe, wpx2, wpy2);
end else begin
WeaponSurface := FrmMain.WWeapon.GetCachedImage(WeaponOffset + currentframe, wpx, wpy);
Weapon2Surface := nil;
end;}

end;

function THumActor.GetDefaultFrame(wmode: boolean): integer;
var
  cf, dr: integer;
  pm:     PTMonsterAction;
begin
  //GlimmingMode := FALSE;
  //dr := Dress div 2;            //HUMANFRAME * (dr)
  if Death then
    Result := HA.ActDie.start + Dir * (HA.ActDie.frame + HA.ActDie.skip) +
      (HA.ActDie.frame - 1)
  else if wmode then begin
    Result := (HA.ActWarMode.start) + Dir * (HA.ActWarMode.frame + HA.ActWarMode.skip)
  end else if bigmagmode then begin
    Result := (HA.ActSpell.start + 4) + Dir * (HA.ActSpell.frame + HA.ActSpell.skip);
  end else begin
    defframecount := HA.ActStand.frame;
    if currentdefframe < 0 then
      cf := 0
    else if currentdefframe >= HA.ActStand.frame then
      cf := 0 //HA.ActStand.frame-1
    else
      cf := currentdefframe;
    Result := HA.ActStand.start + Dir * (HA.ActStand.frame + HA.ActStand.skip) + cf;
  end;
end;

procedure THumActor.RunFrameAction(frame: integer);
var
  meff:  TMapEffect;
  event: TClEvent;
  mfly:  TFlyingAxe;
begin
  BoHideWeapon := False;
  if CurrentAction = SM_HEAVYHIT then begin
    if (frame = 5) and (BoDigFragment) then begin
      BoDigFragment := False;
      meff := TMapEffect.Create(8 * Dir, 3, XX, YY);
      meff.ImgLib := FrmMain.WEffectImg;
      meff.NextFrameTime := 80;
      PlaySound(s_strike_stone);
      //PlaySound (s_drop_stonepiece);
      PlayScene.EffectList.Add(meff);
      event := EventMan.GetEvent(XX, YY, ET_PILESTONES);
      if event <> nil then
        event.EventParam := event.EventParam + 1;
    end;
  end;
  if CurrentAction = SM_THROW then begin
    if (frame = 3) and (BoThrow) then begin
      BoThrow := False;
      mfly    := TFlyingAxe(PlayScene.NewFlyObject(self, XX, YY,
        TargetX, TargetY, TargetRecog, mtFlyAxe));
      if mfly <> nil then begin
        TFlyingAxe(mfly).ReadyFrame := 40;
        mfly.ImgLib := FrmMain.WMon3Img;
        mfly.FlyImageBase := FLYOMAAXEBASE;
      end;

    end;
    if frame >= 3 then
      BoHideWeapon := True;
  end;
end;

procedure THumActor.DoWeaponBreakEffect;
begin
  BoWeaponEffect := True;
  CurWpEffect    := 0;
end;

procedure THumActor.Run;

  function MagicTimeOut: boolean;
  begin
    //      if self = Myself then begin
    Result := GetTickCount - WaitMagicRequest > 3000;
    //      end else
    //         Result := GetTickCount - WaitMagicRequest > 2000;
    if Result then
      CurMagic.ServerMagicCode := 0;
  end;

var
  prv:   integer;
  frametimetime: longword;
  bofly: boolean;
begin
  if GetTickCount - genanicounttime > 120 then begin //주술의막 등... 애니메이션 효과
    genanicounttime := GetTickCount;
    Inc(GenAniCount);
    if GenAniCount > 100000 then
      GenAniCount := 0;
    Inc(CurBubbleStruck);
  end;
  if BoWeaponEffect then begin  //무기 향상/부서짐 효과
    if GetTickCount - wpeffecttime > 120 then begin
      wpeffecttime := GetTickCount;
      Inc(CurWpEffect);
      if CurWpEffect >= MAXWPEFFECTFRAME then
        BoWeaponEffect := False;
    end;
  end;

  if (CurrentAction = SM_WALK) or (CurrentAction = SM_BACKSTEP) or
    (CurrentAction = SM_RUN) or (CurrentAction = SM_RUSH) or
    (CurrentAction = SM_RUSHKUNG) then
    exit;

  msgmuch := False;
  if self <> Myself then begin
    if MsgList.Count >= 2 then
      msgmuch := True;
  end;

  //사운드 효과
  RunActSound(currentframe - startframe);
  RunFrameAction(currentframe - startframe);

  prv := currentframe;
  if CurrentAction <> 0 then begin
    if (currentframe < startframe) or (currentframe > endframe) then
      currentframe := startframe;

    //      if (self <> Myself) and (BoUseMagic) then begin
    //         frametimetime := Round(frametime / 1.8);
    //      end else begin
    if msgmuch then
      frametimetime := Round(frametime * 2 / 3)
    else
      frametimetime := frametime; //2004/04/07 속도관련 수정
    //      end;

    if GetTickCount - starttime > frametimetime then begin
      if currentframe < endframe then begin

        //마법인 경우 서버의 신호를 받아, 성공/실패를 확인한후
        //마지막동작을 끝낸다.
        if BoUseMagic then begin
          if (CurEffFrame = SpellFrame - 2) or (MagicTimeOut) then begin //기다림 끝
            if (CurMagic.ServerMagicCode >= 0) or (MagicTimeOut) then
            begin //서버로 부터 받은 결과. 아직 안왔으면 기다림
              Inc(currentframe);
              Inc(CurEffFrame);
              starttime := GetTickCount;
            end;
          end else begin
            if currentframe < endframe - 1 then
              Inc(currentframe);
            Inc(CurEffFrame);
            starttime := GetTickCount;
          end;
        end else begin
          Inc(currentframe);
          starttime := GetTickCount;
        end;

      end else begin
        if self = Myself then begin
          if FrmMain.ServerAcceptNextAction then begin
            CurrentAction := 0;
            BoUseMagic    := False;
          end;
        end else begin
          CurrentAction := 0; //동작 완료
          BoUseMagic    := False;
        end;
        BoHitEffect := False;
      end;
      if BoUseMagic then begin
        if CurEffFrame = SpellFrame - 1 then begin //마법 발사 시점
          //마법 발사
          if CurMagic.ServerMagicCode > 0 then begin
            with CurMagic do
              PlayScene.NewMagic(self,
                ServerMagicCode,
                EffectNumber,
                XX,
                YY,
                TargX,
                TargY,
                Target,
                EffectType,
                Recusion,
                AniTime,
                bofly);
            if bofly then
              PlaySound(magicfiresound)
            else
              PlaySound(magicexplosionsound);
          end;
          if self = Myself then
            LatestSpellTime := GetTickCount;
          CurMagic.ServerMagicCode := 0;
        end;
      end;

    end;
    if Race = 0 then
      currentdefframe := 0
    else
      currentdefframe := -10;
    defframetime := GetTickCount;
  end else begin
    if GetTickCount - smoothmovetime > 200 then begin
      if GetTickCount - defframetime > 500 then begin
        defframetime := GetTickCount;
        Inc(currentdefframe);
        if currentdefframe >= defframecount then
          currentdefframe := 0;
      end;
      DefaultMotion;
    end;
  end;

  if prv <> currentframe then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
  end;

end;

function THumActor.Light: integer;
var
  l: integer;
begin
  l := ChrLight;
  if l < MagLight then begin
    if BoUseMagic or BoHitEffect then
      l := MagLight;
  end;
  Result := l;
end;

procedure THumActor.LoadSurface;
begin
if SecondHum then begin
if KillerMode then begin
  BodySurface := FrmMain.WKillerHumImg2.GetCachedImage(BodyOffset + currentframe, px, py);
  if HairOffset >= 0 then
    HairSurface := FrmMain.WKillerHairImg.GetCachedImage(HairOffset +
      currentframe, hpx, hpy)
  else
    HairSurface := nil;
  end else begin
  BodySurface := FrmMain.WHumImg2.GetCachedImage(BodyOffset + currentframe, px, py);
  if HairOffset >= 0 then
    HairSurface := FrmMain.WHairImg.GetCachedImage(HairOffset +
      currentframe, hpx, hpy)
  else
    HairSurface := nil;
  end;
  end else begin
if KillerMode then begin
  BodySurface := FrmMain.WKillerHumImg.GetCachedImage(BodyOffset + currentframe, px, py);
  if HairOffset >= 0 then
    HairSurface := FrmMain.WKillerHairImg.GetCachedImage(HairOffset +
      currentframe, hpx, hpy)
  else
    HairSurface := nil;
  end else begin
  BodySurface := FrmMain.WHumImg.GetCachedImage(BodyOffset + currentframe, px, py);
  if HairOffset >= 0 then
    HairSurface := FrmMain.WHairImg.GetCachedImage(HairOffset +
      currentframe, hpx, hpy)
  else
    HairSurface := nil;
  end;
  end;
  if (Dress in [22, 23]) and (currentframe < 536) then begin
    if GetTickCount - WingStartTime > 100 then begin
      if WingCurrentFrame < 19 then
        Inc(WingCurrentFrame)
      else begin
        if not Bo50DressHEffect then
          Bo50DressHEffect := True
        else
          Bo50DressHEffect := False;
        WingCurrentFrame := 0;
      end;

      //         DScreen.AddSysMsg ('SF=>'+ IntToStr(Dir*8)+' CF=>'+ IntToStr(WingCurrentFrame)+' THumActor');
      WingStartTime := GetTickCount;
    end;
    WingSurface := FrmMain.WEffectImg.GetCachedImage(WingOffset +
      WingCurrentFrame, epx, epy);
  end else if (Dress in [18, 19, 20, 21]) and (currentframe < 64) then begin
    if GetTickCount - WingStartTime > WingFrametime then begin
      if WingCurrentFrame < 7 then
        Inc(WingCurrentFrame)
      else
        WingCurrentFrame := 0;
      //         DScreen.AddSysMsg ('SF=>'+ IntToStr(Dir*8)+' CF=>'+ IntToStr(WingCurrentFrame)+' THumActor');
      WingStartTime := GetTickCount;
    end;
    if KillerMode then
    WingSurface := FrmMain.WKillerWing.GetCachedImage(WingOffset +
      Dir * 8 + WingCurrentFrame, epx, epy)
      else
    WingSurface := FrmMain.WHumWing.GetCachedImage(WingOffset +
      Dir * 8 + WingCurrentFrame, epx, epy);
  end else if Dress in [18, 19, 20, 21] then begin
    if KillerMode then
    WingSurface := FrmMain.WKillerWing.GetCachedImage(WingOffset +
      currentframe, epx, epy)
      else
    WingSurface := FrmMain.WHumWing.GetCachedImage(WingOffset +
      currentframe, epx, epy);
    end;

  if currentframe > 535 then
    Bo50DressHEffect := False;

  if Bo50LevelEffect then begin
    if GetTickCount - H50LevelEffectStartTime > H50LevelEffectFrameTime then begin
      if H50LevelEffectCurrentFrame < 7 then
        Inc(H50LevelEffectCurrentFrame)
      else begin
        H50LevelEffectCurrentFrame := 0;
        Bo50LevelHEffect := not Bo50LevelHEffect;
      end;
      H50LevelEffectStartTime := GetTickCount;
    end;
    H50LevelEffectSurface :=
      FrmMain.WEffectImg.GetCachedImage(H50LevelEffectOffset +
      H50LevelEffectCurrentFrame, epx2, epy2);
  end;

if KillerMode then begin
WeaponSurface := FrmMain.WKillerWeaponL.GetCachedImage(WeaponOffset + currentframe, wpx, wpy);
Weapon2Surface := FrmMain.WKillerWeaponR.GetCachedImage(WeaponOffset + currentframe, wpx2, wpy2);
end else begin
WeaponSurface := FrmMain.WWeapon.GetCachedImage(WeaponOffset + currentframe, wpx, wpy);
Weapon2Surface := nil;
end;

end;

procedure THumActor.DrawChr(dsurface: TDirectDrawSurface; dx, dy: integer;
  blend: boolean; WingDraw: boolean);
var
  idx, ax, ay: integer;
  d:    TDirectDrawSurface;
  ceff: TColorEffect;
  wimg: TWMImages;
begin
  if not (Dir in [0..7]) then
    exit;
  if GetTickCount - loadsurfacetime > 60 * 1000 then begin
    loadsurfacetime := GetTickCount;
    LoadSurface;
    //bodysurface등이 loadsurface를 다시 부르지 않아 메모리가 프리되는 것을 막음
  end;

  ceff := GetDrawEffectValue;


  if Race = 0 then begin
    if (currentframe >= 0) and (currentframe <= 599) then
      wpord := WORDER[Sex, currentframe];

    // 2번 모드 --------------------------------------------------------------------
    if Dress in [18, 19, 20, 21] then begin

      if self = Myself then begin
        if blend then
          if ((Dir = DR_DOWN) or (Dir = DR_DOWNRIGHT) or (Dir = DR_DOWNLEFT)) and
            (WingSurface <> nil) and (not WingDraw) then
            DrawBlend(dsurface, dx + epx + ShiftX, dy + epy +
              ShiftY, WingSurface, 1)
          else if ((Dir = DR_DOWN) or (Dir = DR_DOWNRIGHT) or
            (Dir = DR_DOWNLEFT)) and (WingSurface <> nil) and WingDraw then
            DrawBlend(dsurface, dx + epx + ShiftX, dy + epy +
              ShiftY, WingSurface, 1);
      end else begin
        if ((FocusCret <> nil) or (MagicTarget <> nil)) and blend and
          ((Dir = DR_DOWN) or (Dir = DR_DOWNRIGHT) or (Dir = DR_DOWNLEFT)) and
          (WingSurface <> nil) and (not WingDraw) then
          DrawBlend(dsurface, dx + epx + ShiftX, dy + epy + ShiftY,
            WingSurface, 1)
        else if ((Dir = DR_DOWN) or (Dir = DR_DOWNRIGHT) or (Dir = DR_DOWNLEFT)) and
          (WingSurface <> nil) and WingDraw then
          DrawBlend(dsurface, dx + epx + ShiftX, dy + epy + ShiftY,
            WingSurface, 1);
      end;

    end;

    // 2번 모드 --------------------------------------------------------------------
    if (wpord = 0) and (not blend) and (Weapon >= 2) and
      (WeaponSurface <> nil) and (not BoHideWeapon) then begin
      DrawEffSurface(dsurface, WeaponSurface, dx + wpx + ShiftX,
        dy + wpy + ShiftY, blend, ceNone);  //칼은 색이 안변함
    end;
    if (wpord = 0) and (not blend) and (Weapon >= 2) and
      (Weapon2Surface <> nil) and (not BoHideWeapon) then begin
      DrawEffSurface(dsurface, Weapon2Surface, dx + wpx2 + ShiftX,
        dy + wpy2 + ShiftY, blend, ceNone);  //칼은 색이 안변함
    end;

    //몸통 그리고
    if BodySurface <> nil then
      DrawEffSurface(dsurface, BodySurface, dx + px + ShiftX, dy +
        py + ShiftY, blend, ceff);
    if HairSurface <> nil then
      DrawEffSurface(dsurface, HairSurface, dx + hpx + ShiftX,
        dy + hpy + ShiftY, blend, ceff);

  //  보이는 각도에 따라서 몸,머리,무기를 그리는 순서가 달라진다.
    if (wpord = 1) and {(not blend) and} (Weapon >= 2) and
      (WeaponSurface <> nil) and (not BoHideWeapon) then begin
      DrawEffSurface(dsurface, WeaponSurface, dx + wpx + ShiftX,
        dy + wpy + ShiftY, blend, ceNone);
    end;
     if (wpord = 1) and {(not blend) and} (Weapon >= 2) and
      (Weapon2Surface <> nil) and (not BoHideWeapon) then begin
      DrawEffSurface(dsurface, Weapon2Surface, dx + (wpx2 - 5) + ShiftX,
        dy + wpy2 + ShiftY, blend, ceNone);
    end;

    // 2번모드 ---------------------------------------------------------------------
    if Dress in [18, 19, 20, 21] then begin

      if self = Myself then begin
        if blend then
          if ((Dir = DR_UP) or (Dir = DR_UPLEFT) or (Dir = DR_UPRIGHT) or
            (Dir = DR_LEFT) or (Dir = DR_RIGHT)) and (WingSurface <> nil) and
            (not WingDraw) then
            DrawBlend(dsurface, dx + epx + ShiftX, dy + epy +
              ShiftY, WingSurface, 1)
          else if ((Dir = DR_UP) or (Dir = DR_UPLEFT) or
            (Dir = DR_UPRIGHT) or (Dir = DR_LEFT) or (Dir = DR_RIGHT)) and
            (WingSurface <> nil) and WingDraw then
            DrawBlend(dsurface, dx + epx + ShiftX, dy + epy +
              ShiftY, WingSurface, 1);
      end else begin
        if ((FocusCret <> nil) or (MagicTarget <> nil)) and
          ((Dir = DR_UP) or (Dir = DR_UPLEFT) or (Dir = DR_UPRIGHT) or
          (Dir = DR_LEFT) or (Dir = DR_RIGHT)) and (WingSurface <> nil) and
          (not WingDraw) then
          DrawBlend(dsurface, dx + epx + ShiftX, dy + epy + ShiftY,
            WingSurface, 1)
        else if ((Dir = DR_UP) or (Dir = DR_UPLEFT) or (Dir = DR_UPRIGHT) or
          (Dir = DR_LEFT) or (Dir = DR_RIGHT)) and (WingSurface <> nil) and
          WingDraw then
          DrawBlend(dsurface, dx + epx + ShiftX, dy + epy + ShiftY,
            WingSurface, 1);
      end;

    end;


    // 2번모드 ---------------------------------------------------------------------

    // 50레벨옷 임펙트
    if (Dress in [22, 23]) and Bo50DressHEffect and (WingSurface <> nil) then
      DrawBlend(dsurface, dx + epx + ShiftX, dy + epy + ShiftY, WingSurface, 1);

    // 50Level Effect
    if (Bo50LevelEffect) and (Bo50LevelHEffect) then
      DrawBlend(dsurface, dx + epx2 + ShiftX, dy + epy2 + ShiftY,
        H50LevelEffectSurface, 1);

    //주술의막인 경우
    if State and $00100000{STATE_BUBBLEDEFENCEUP} <> 0 then begin  //주술의막
      if (CurrentAction = SM_STRUCK) and (CurBubbleStruck < 3) then
        idx := MAGBUBBLESTRUCKBASE + CurBubbleStruck
      else
        idx := MAGBUBBLEBASE + (GenAniCount mod 3);
      d := FrmMain.WMagic.GetCachedImage(idx, ax, ay);
      if d <> nil then
        DrawBlend(dsurface,
          dx + ax + ShiftX,
          dy + ay + ShiftY,
          d, 1);
    end;

  end;

  if BoHitEffect and (HitEffectNumber = 8) then begin
  end else begin
    if BoUseMagic {and (EffDir[Dir] = 1)} and (CurMagic.EffectNumber > 0) then begin
      if CurEffFrame in [0..SpellFrame - 1] then begin
        GetEffectBase(CurMagic.EffectNumber - 1, 0, wimg, idx);
        if CurMagic.EffectNumber = 61 then
        idx := idx + (Dir * 10) + CurEffFrame
        else
        idx := idx + CurEffFrame;
        if wimg <> nil then begin
          d := wimg.GetCachedImage(idx, ax, ay);
          if d <> nil then
            DrawBlend(dsurface,
              dx + ax + ShiftX,
              dy + ay + ShiftY,
              d, 1);
        end;
      end;
    end;
  end;

  // 공파섬 별도 처리
  if BoHitEffect and (HitEffectNumber = 8) then begin
    if GetTickCount - SKillStartTime > SKillFrametime then begin
      if SKillCurrentFrame < (14) then
        Inc(SKillCurrentFrame)
      else begin
        SKillCurrentFrame := 0;
        BoHitEffect := False;
      end;
      SKillStartTime := GetTickCount;
    end;
    idx  := Dir * 20;
    wimg := FrmMain.WMagic2;
    if wimg <> nil then begin
      d := wimg.GetCachedImage((740 + idx) + SKillCurrentFrame, ax, ay);
      //      DScreen.AddChatBoardString ('SKillCurrentFrame=>'+IntToStr(SKillCurrentFrame), clYellow, clRed);
      if d <> nil then
        DrawBlend(dsurface,
          dx + ax + ShiftX,
          dy + ay + ShiftY,
          d, 1);
    end;
  end   //검법 효과
  else if BoHitEffect and (HitEffectNumber > 0) then begin
    GetEffectBase(HitEffectNumber - 1, 1, wimg, idx);
    if HitEffectNumber = 9 then  //Slash
    idx := idx  + (currentframe - startframe)
    else
    idx := idx + Dir * 10 + (currentframe - startframe);

    if wimg <> nil then begin
      d := wimg.GetCachedImage(idx, ax, ay);
      if d <> nil then
        DrawBlend(dsurface,
          dx + ax + ShiftX,
          dy + ay + ShiftY,
          d, 1);
    end;
  end;

  //물약 먹고 나는 효과
  //if BoEatEffect then begin
  //   if GetTickCount - EatEffectTime > 70 then begin
  //      EatEffectTime := GetTickCount;
  //      Inc (EatEffectFrame);
  //   end;
  //   if EatEffectFrame >= 6 then begin
  //      BoEatEffect := FALSE;
  //      EatEffectFrame := 0;
  //   end;

  //   d := FrmMain.WEffectImg.GetCachedImage (296 + EatEffectFrame, ax, ay);
  //   if d <> nil then
  //      DrawBlend (dsurface,
  //                       dx + ax + ShiftX,
  //                       dy + ay + ShiftY,
  //                       d, 1);
  //end;

  //무기 향상/부서짐 효과
  if BoWeaponEffect then begin
    idx := WPEFFECTBASE + Dir * 10 + CurWpEffect;
    d   := FrmMain.WMagic.GetCachedImage(idx, ax, ay);
    if d <> nil then
      DrawBlend(dsurface,
        dx + ax + ShiftX,
        dy + ay + ShiftY,
        d, 1);
  end;

end;

end.
