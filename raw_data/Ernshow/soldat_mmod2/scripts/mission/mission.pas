// Soldat Multiplayer Mission mod by Zakath

const
    ALPHA = 1;
    BRAVO = 2;
    CHARLIE = 3;
    DELTA = 4;
    SPECTATOR = 5;
    BASICSOLDIER = 0;
    COMMANDO = 1;
    ARTILLERY = 2;
    MARINE = 3;
    ASSAULT = 4;
    VESTLEVEL = 16;
    EXPPRECISION = 25;
    ENABLEMINIGUN = false; // enable miniguns
    EXTRACTPERCENT = 30; // third of the team has to get to the extraction point
    RESTARTPERCENT = 51; // amount of votes required for a restart
    RaidInterval=30;//Raid interval in seconds
    MissileStep=20;//distance between missiles
    RaidWarning=3;// amount of seconds before raid to warn
    REQUIREDLEVEL=0; // Required Level to play on server
    MMVERSION=2.0;
    BASEHOLDAMOUNT=120; // seconds to hold the base
    // WEAPONS for forceweapon
    SOCOM=0;
    DEAGLES=1;
    MP5=2;
    AK=3;
    AUG=4;
    SPAS=5;
    RUGER=6;
    M79=7;
    BARRET=8;
    MINIMI=9;
    MINIGUN=10;
    FLAMER=11;
    RAMBOBOW=12;
    FLAMERAMBOBOW=13;
    KNIFE=14;
    CHAINSAW=15;
    LAW=16;
    FISTS=255;
type item = Record
    Player : String;
    Score : integer;
end;
type tplayer = record
     hud : boolean;
     evacuated : boolean;
     level, levelupcount, spree , spec, mmx, cooldown: integer;
     maxXP, xp, multiplier : double;
end;
type tmission = record
     name: string;
     text: string;
     map : string;
     mtype : integer;
     airstrike : boolean;
     xp : double;
     vest : boolean;
end;

var
    mission_soldier: array[1..32]  of tplayer;
    voted : array[1..32] of boolean;
    maplist : array[1..100] of string;
    br : string;
    cmap : integer;
    disableCommands : boolean;
    evacuatedamount : integer;
    evacuated : boolean;
    maxmap : integer;
    mission :  tmission;
    debug : boolean;
    mnr : integer;
    flagcap : boolean;
    mamount : integer;
    Commander : byte;
    countdown : integer;
    LeftX, RightX, FlagHeight, AlphaX, AlphaY : single;
    RaidCountdown : integer;
    toplist : array[1..10] of item; // toplist
    toplistAdded : boolean;
//
// Utility Functions
//

function Explode(Source: string; const Delimiter: string): array of string;
var
    TempStr: string;
begin
    SetArrayLength(Result, 0);
    Source := Source + Delimiter;
    repeat
        TempStr := GetPiece(Source, Delimiter, 0);
        SetArrayLength(Result, GetArrayLength(Result) + 1);
        Result[GetArrayLength(Result) - 1] := TempStr;
        Delete(Source, 1, Length(TempStr) + Length(Delimiter));
    until Length(Source) = 0;
end;

function parseBool(b : string): boolean;
begin
    Result := false;
    if(b = 'YES') then
    begin
       Result:= true;
    end;
end;
function Exp(Exponent: double): double;
var
    i, j: integer;
    numerator, denominator: double;
begin
    Result := 1;
    for i:= 1 to EXPPRECISION do
    begin
        denominator := 1;
        numerator := 1;
        for j:= 1 to i do
        begin
            denominator := denominator * j;
            numerator := numerator * Exponent;
        end;
        Result := Result + numerator/denominator;
    end;
end;

//
// Misc Functions (restart mission)
//
procedure restartMission(ID : byte);
var
    count,loop :byte;
begin
    if(GetPlayerStat(ID, 'Team') <> ALPHA) then
    begin
        WriteConsole(ID, 'You have to join the game before you can do a restart', RGB(255,255,255));
        exit;
    end;
    if(voted[ID]) then
    begin
	   WriteConsole(ID, 'You have already voted for a restart', RGB(255,255,255));
	   exit;
    end;
    count := 0;
    voted[ID] := true;
    for loop:= 1 to 32 do 
    begin
	   if(voted[loop]) then
	   begin
	       count := count +1;
	   end;
    end;
    if(count = 1) then
    begin
	   WriteConsole(0, 'A vote for mission mod restart has been started', RGB(255,255,255));
    end;
    if(round((count*100)/ALPHAPLAYERS) > RESTARTPERCENT) then
    begin
	   WriteConsole(0, 'Restarting Mission mod', RGB(255,255,255));
	   cmap := 1;
	   command('/map ' + maplist[cmap]);
    end
    else
    begin
	   WriteConsole(0, floattostr(roundto((count*100)/ALPHAPLAYERS,2)) + '/' + inttostr(RESTARTPERCENT) + '% Required for restart', RGB(255,255,255));
    end;
    
end;
//
// Misc Functions (calculate max map)
//
function calcMaxMap(): integer;
var
    i, count, total: integer;
begin
    total := 0;
    count := 0;
    for i:= 1 to 32 do
    begin
        if(GetPlayerStat(i, 'Active') and (GetPlayerStat(i, 'Human'))) then
        begin
            total := total + mission_soldier[i].level;
            count := count + 1;
        end;
    end;
    if(count > 0) then
    begin
        Result := 2 + total/count;
    end
    else
    begin
        Result := 3;
    end;
end;
//
// Airstrike Functions (Variables)
//
procedure calcAirstrikeVars();
var
    BlueFlagX,BlueFlagY,RedFlagX,RedFlagY:single;
begin
    GetFlagsXY(BlueFlagX, BlueFlagY, RedFlagX, RedFlagY);
    AlphaX := RedFlagX;
    AlphaY := RedFlagY;
    if(BlueFlagX > RedFlagX) then
    begin
        LeftX := RedFlagX;
        RightX := BlueFlagX;
    end
    else
    begin
        LeftX := BlueFlagX;
        RightX := RedFlagX;
    end;
    FlagHeight := ((BlueFlagY+RedFlagY)/2);

end;
//
// Airstrike Functions (perform)
//
procedure PerformAirstrike();
var
    loop:single;
    rand : integer;
begin
    if(LeftX = 1) and (RightX = 2) and (FlagHeight = 3) then
    begin
	calcAirstrikeVars();
    end;
    
    loop := LeftX;
    WriteConsole(0, 'Incoming Airstrike take Cover!!!', RGB(255,122,0));
    while(loop < RightX) do
    begin
        rand := Random(1,10);
        if(rand = 1) then
        begin
            CreateBullet(Loop,FlagHeight - Random(800,1200),0,0,25,4,Commander);
        end;
        loop := loop + MissileStep;
    end;
end;
//
// Skills (Flamer)
//
procedure PerformFlamer(ID : byte);
begin
    if(mission_soldier[ID].spec = MARINE) then
    begin
        if(mission_soldier[ID].level >= 20) then
        begin
            if((GetTickCount()-mission_soldier[ID].cooldown) > 60 * (100-mission_soldier[ID].level)) then
            begin
                ForceWeapon(ID, 11, GetPlayerStat(ID, 'Primary'),0);
		//SpawnObject(GetPlayerStat(ID,'x'),GetPlayerStat(ID,'y'),18);
		
                mission_soldier[ID].cooldown := GetTickCount();
            end
            else
            begin
                WriteConsole(ID,'You have to wait: ' + inttostr(((60*(100-mission_soldier[ID].level))-(GetTickCount()-mission_soldier[ID].cooldown))/60) + ' Seconds before you can use that skill!',RGB(255,122,0));
            end;
        end
        else
        begin
            WriteConsole(ID,'Not High enough Level!',RGB(255,122,0));
        end;
    end
    else
    begin
        WriteConsole(ID,'Cant use that skill with your class!',RGB(255,122,0));
    end;
end;
//
// Skills (Rage)
//
procedure PerformRage(ID : byte);
begin
    if(mission_soldier[ID].spec = ASSAULT) then
    begin
        if(mission_soldier[ID].level >= 20) then
        begin
            if((GetTickCount()-mission_soldier[ID].cooldown) > 60 * (100-mission_soldier[ID].level)) then
            begin
                GiveBonus(ID,2);
                mission_soldier[ID].cooldown := GetTickCount();
            end
            else
            begin
                WriteConsole(ID,'You have to wait: ' + inttostr(((60*(100-mission_soldier[ID].level))-(GetTickCount()-mission_soldier[ID].cooldown))/60) + ' Seconds before you can use that skill!',RGB(255,122,0));
            end;
        end
        else
        begin
            WriteConsole(ID,'Not High enough Level!',RGB(255,122,0));
        end;
    end
    else
    begin
        WriteConsole(ID,'Cant use that skill with your class!',RGB(255,122,0));
    end;
end;
//
// Skills (stealth)
//
procedure PerformStealth(ID : byte);
begin
    if(mission_soldier[ID].spec = COMMANDO) then
    begin
        if(mission_soldier[ID].level >= 20) then
        begin
            if((GetTickCount()-mission_soldier[ID].cooldown) > 60 * (300-(mission_soldier[ID].level*2))) then
            begin
                GiveBonus(ID,1);
                mission_soldier[ID].cooldown := GetTickCount();
            end
            else
            begin
                WriteConsole(ID,'You have to wait: ' + inttostr(((60*(300-(mission_soldier[ID].level*2)))-(GetTickCount()-mission_soldier[ID].cooldown))/60) + ' Seconds before you can use that skill!',RGB(255,122,0));
            end;
        end
        else
        begin
            WriteConsole(ID,'Not High enough Level!',RGB(255,122,0));
        end;
    end
    else
    begin
        WriteConsole(ID,'Cant use that skill with your class!',RGB(255,122,0));
    end;
end;
//
// Skills (nuke)
//
procedure PerformNuke(ID: byte);
var
    count : byte;
    X,Y, EX, EY : single;
begin
    if(mission_soldier[ID].spec = ARTILLERY) then
    begin
        if(mission_soldier[ID].level >= 20) then
        begin
            if((GetTickCount()-mission_soldier[ID].cooldown) > 60 * (150-mission_soldier[ID].level)) then
            begin
                GetPlayerXY(ID,X,Y);
                WriteConsole(0, IDToName(ID) + ' Called a Tactical NUKE!!!', RGB(255,0,0));
                for count:= 1 to 32 do
                begin
	               if(GetPlayerStat(count,'Active')) then
	               begin
	                   if(GetPlayerStat(count,'Team') = BRAVO) then
	                   begin
		                  GetPlayerXY(count,EX,EY);
		                  if(abs(X-EX) < 500) and (abs(Y-EY) < 500) then
		                  begin
    		                  CreateBullet(EX,EY,50,0,10000,4,ID);
		                  end;
	                   end;
	               end;
                end;
                mission_soldier[ID].cooldown := GetTickCount();
            end
            else
            begin
                WriteConsole(ID,'You have to wait: ' + inttostr(((60*(150-mission_soldier[ID].level))-(GetTickCount()-mission_soldier[ID].cooldown))/60) + ' Seconds before you can use that skill!',RGB(255,122,0));
            end;
        end
        else
        begin
            WriteConsole(ID,'Not High enough Level!',RGB(255,122,0));
        end;
    end
    else
    begin
        WriteConsole(ID,'Cant use that skill with your class!',RGB(255,122,0));
    end;

end;
//
// Skills (bio)
//
procedure PerformBio(ID: byte);
var
    count : byte;
    X,Y, EX, EY : single;
begin
    if(mission_soldier[ID].spec = MARINE) then
    begin
        if(mission_soldier[ID].level >= 25) then
        begin
            if((GetTickCount()-mission_soldier[ID].cooldown) > 60 * (75-mission_soldier[ID].level)) then
            begin
                GetPlayerXY(ID,X,Y);
                WriteConsole(0, IDToName(ID) + ' Called a Bio Strike!!!', RGB(0,255,0));
                for count:= 1 to 32 do
                begin
	               if(GetPlayerStat(count,'Active')) then
	               begin
	                   if(GetPlayerStat(count,'Team') = BRAVO) then
	                   begin
		                  GetPlayerXY(count,EX,EY);
		                  if(abs(X-EX) < 800) and (abs(Y-EY) < 800) then
		                  begin
                            //WriteConsole(0, IDToName(ID) + ' Health: ' + inttostr(GetPlayerStat(count, 'Health')) + ' Vest: ' + inttostr(GetPlayerStat(count, 'Vest')), RGB(255,0,0));
    		                  CreateBullet(EX,EY,0,0,25,5,ID);
                              DoDamage(count, (GetPlayerStat(count, 'Health') + GetPlayerStat(count, 'Vest')-5));
                            //WriteConsole(0, IDToName(ID) + ' Health: ' + inttostr(GetPlayerStat(count, 'Health')) + ' Vest: ' + inttostr(GetPlayerStat(count, 'Vest')), RGB(255,0,0));
		                  end;
	                   end;
	               end;
                end;
                mission_soldier[ID].cooldown := GetTickCount();
            end
            else
            begin
                WriteConsole(ID,'You have to wait: ' + inttostr(((60*(75-mission_soldier[ID].level))-(GetTickCount()-mission_soldier[ID].cooldown))/60) + ' Seconds before you can use that skill!',RGB(255,122,0));
            end;
        end
        else
        begin
            WriteConsole(ID,'Not High enough Level!',RGB(255,122,0));
        end;
    end
    else
    begin
        WriteConsole(ID,'Cant use that skill with your class!',RGB(255,122,0));
    end;

end;
//
// Skills (bomb)
//
procedure performBomb(ID: byte);
var i,angle: integer;
    X,Y,VelX,VelY: single;
begin
    if(mission_soldier[ID].spec = ARTILLERY) then
    begin
        if(mission_soldier[ID].level >= 12) then
        begin
            if((GetTickCount()-mission_soldier[ID].cooldown) > 60 * 10) then
            begin
                WriteConsole(ID,'KABOOM!',RGB(0,0,0));
                GetPlayerXY(ID,X,Y);
                for i := 1 to 8 do
                begin
                    angle := Random(45,135);
                    VelX := cos(angle*pi/180)
                    VelY := sin(angle*pi/180);
                    CreateBullet(X,Y,VelX*5,-VelY*5,10,2,ID);
                end;
                mission_soldier[ID].cooldown := GetTickCount();
            end
            else
            begin
                WriteConsole(ID,'You have to wait: ' + inttostr(((60*10)-(GetTickCount()-mission_soldier[ID].cooldown))/60) + ' Seconds before you can use that skill!',RGB(255,122,0));
            end;
        end
        else
        begin
            WriteConsole(ID,'Not High enough Level!',RGB(255,122,0));
        end;
    end
    else
    begin
        WriteConsole(ID,'Cant use that skill with your class!',RGB(255,122,0));
    end;
end;
//
// Skills (reinforce 1)
//
procedure performTele1(ID: byte);
var loop: byte;
    tempDistance ,Distance, loopX, loopY : single;
    X,Y : single;
    BlueFlagX,BlueFlagY,RedFlagX,RedFlagY: single;
begin
    if(GetPlayerStat(ID, 'Flagger')) then
    begin
        WriteConsole(ID, 'Can''t reinforce yourself',RGB(255,255,255));
        exit;
    end;
    Distance := 10000000;
    if(mission_soldier[ID].level >= 30) then
    begin
        if((GetTickCount()-mission_soldier[ID].cooldown) > 60 * 300) then
        begin
            GetFlagsXY(BlueFlagX,BlueFlagY,RedFlagX,RedFlagY);
            for loop := 1 to 32 do
            begin
                if(GetPlayerStat(loop, 'Active')) then
                begin
                    if(GetPlayerStat(loop, 'Human')) then
                    begin
                        if(GetPlayerStat(loop, 'Alive')) then
                        begin
                            if(loop <> ID) then
                            begin
                                GetPlayerXY(loop, loopX, loopY);
                                tempDistance := sqrt(((BlueFlagX-loopX)*(BlueFlagX-loopX)) + ((BlueFlagY-loopY)*(BlueFlagY-loopY)));
                                if(tempDistance < Distance) then
                                begin
                                    Distance := tempDistance;
                                    X := loopX;
                                    Y := loopY;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            if(Distance <>  10000000) then
            begin
                WriteConsole(0,'DO NOT FEAR ' + IDToName(ID) + ' IS HERE!!!',RGB(255,255,255));
                MovePlayer(ID, X, Y);
                mission_soldier[ID].cooldown := GetTickCount();
            end
            else
            begin
                WriteConsole(ID, 'No one to reinforce :(', RGB(255,255,255));
            end;
        end
        else
        begin
            WriteConsole(ID,'You have to wait: ' + inttostr(((60*300)-(GetTickCount()-mission_soldier[ID].cooldown))/60) + ' Seconds before you can use that skill!',RGB(255,122,0));
        end;
    end
    else
    begin
        WriteConsole(ID,'Not High enough Level!',RGB(255,122,0));
    end;
end;
//
// Skills (reinforce 2)
//
procedure performTele2(ID: byte);
var loop: byte;
    tempDistance ,Distance, loopX, loopY : single;
    X,Y : single;
    BlueFlagX,BlueFlagY,RedFlagX,RedFlagY: single;
begin
    if(GetPlayerStat(ID, 'Flagger')) then
    begin
        WriteConsole(ID, 'Can''t reinforce yourself',RGB(255,255,255));
        exit;
    end;
    Distance := 10000000;
    if(mission_soldier[ID].level >= 30) then
    begin
        if((GetTickCount()-mission_soldier[ID].cooldown) > 60 * 300) then
        begin
            GetFlagsXY(BlueFlagX,BlueFlagY,RedFlagX,RedFlagY);
            for loop := 1 to 32 do
            begin
                if(GetPlayerStat(loop, 'Active')) then
                begin
                    if(GetPlayerStat(loop, 'Human')) then
                    begin
                        if(GetPlayerStat(loop, 'Alive')) then
                        begin
                            if(loop <> ID) then
                            begin
                                GetPlayerXY(loop, loopX, loopY);
                                tempDistance := sqrt(((RedFlagX-loopX)*(RedFlagX-loopX)) + ((RedFlagY-loopY)*(RedFlagY-loopY)));
                                if(tempDistance < Distance) then
                                begin
                                    Distance := tempDistance;
                                    X := loopX;
                                    Y := loopY;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            if(Distance <>  10000000) then
            begin
                WriteConsole(0,'DO NOT FEAR ' + IDToName(ID) + ' IS HERE!!!',RGB(255,255,255));
                MovePlayer(ID, X, Y);
                mission_soldier[ID].cooldown := GetTickCount();
            end
            else
            begin
                WriteConsole(ID, 'No one to reinforce :(', RGB(255,255,255));
            end;
        end
        else
        begin
            WriteConsole(ID,'You have to wait: ' + inttostr(((60*300)-(GetTickCount()-mission_soldier[ID].cooldown))/60) + ' Seconds before you can use that skill!',RGB(255,122,0));
        end;
    end
    else
    begin
        WriteConsole(ID,'Not High enough Level!',RGB(255,122,0));
    end;
end;
//
// Skills (regen)
//
procedure regen(ID : byte; amount : integer);
var health : integer;
begin
    health := GetPlayerStat(ID, 'Health');
    if(health > (150-amount-1)) then
    begin
	   DoDamageBy(ID,Commander, -(150-health));
    end
    else
    begin
	   DoDamageBy(ID,Commander, -amount);
    end;
end;
//
// Account related Functions(weapon speciality)
//
procedure setWeaponSpec(ID,SPEC: byte);
begin
    SetWeaponActive(ID,1,false); // DEAGLES
    SetWeaponActive(ID,2,false); // MP5
    SetWeaponActive(ID,3,false); // AK
    SetWeaponActive(ID,4,false); // AUG
    SetWeaponActive(ID,5,false); // SPAS
    SetWeaponActive(ID,6,false); // RUGER
    SetWeaponActive(ID,7,false); // M79
    SetWeaponActive(ID,8,false); // BARRET
    SetWeaponActive(ID,9,false); // MINIMI
    SetWeaponActive(ID,10,false); // MINIGUN
    SetWeaponActive(ID,11,true); // SOCOM
    SetWeaponActive(ID,12,false); // KNIFE
    SetWeaponActive(ID,13,false); // SAW
    SetWeaponActive(ID,14,false); // LAW

	// Setting Weapon Speciality
    if(mission_soldier[ID].level > 1) then
    begin
        SetWeaponActive(ID,3,true); // AK
    end;
    if(mission_soldier[ID].level > 4) then
    begin
       case SPEC of
                    COMMANDO: begin
                        if(mission_soldier[ID].level > 7) then // Level 8
                        begin
                            SetWeaponActive(ID,6,true); // RUGER
                        end;
                        if(mission_soldier[ID].level > 11) then // Level 12
                        begin
                            SetWeaponActive(ID,8,true); // BARRET
                        end;
                        SetWeaponActive(ID,12,true); // KNIFE
                    end;
                    ARTILLERY: begin
                        if(mission_soldier[ID].level > 7) then // Level 8
                        begin
                            SetWeaponActive(ID,7,true); // M79
                        end;
                        SetWeaponActive(ID,14,true); // LAW
                    end;
                    MARINE: begin
                        SetWeaponActive(ID,2,true); // MP5
                        if(mission_soldier[ID].level > 7) then // Level 8
                        begin
                            SetWeaponActive(ID,1,true); // DEAGLES
                        end;
                        if(mission_soldier[ID].level > 11) then // Level 12
                        begin
                            SetWeaponActive(ID,4,true); // AUG
                        end;
                    end;
                    ASSAULT: begin
                        if(mission_soldier[ID].level > 7) then // Level 8
                        begin
                            SetWeaponActive(ID,5,true); // SPAS
                        end;
                        if(mission_soldier[ID].level > 11) then // Level 12
                        begin
                            SetWeaponActive(ID,9,true); // MINIMI
			    if(ENABLEMINIGUN) then
			    begin
                        	SetWeaponActive(ID,10,true); // MINIGUN
			    end;
                        end;
                        SetWeaponActive(ID,13,true); // SAW
                    end;
       end;
       mission_soldier[ID].spec := SPEC;
    end;
end;
//
// Account related Functions(Experience)
//

procedure MaxXP(ID: integer);
begin
    mission_soldier[ID].maxXP := 50 + (50 * mission_soldier[ID].level* mission_soldier[ID].level)/2 + exp(strtofloat(inttostr(mission_soldier[ID].level))/3);  // Release Formula
end;
procedure IncXP(ID: byte;XP: double);
begin
    //WriteLn(IDToName(ID) + 'XP Before: ' +inttostr(mission_soldier[ID].xp) + ' Adding: ' + inttostr(XP));
	mission_soldier[ID].xp := mission_soldier[ID].xp + XP;
    //WriteLn(IDToName(ID) + 'XP After: ' +inttostr(mission_soldier[ID].xp));
	if (mission_soldier[ID].xp >= mission_soldier[ID].maxXP) then
    begin
		mission_soldier[ID].xp := mission_soldier[ID].xp-mission_soldier[ID].maxXP;
		mission_soldier[ID].level := mission_soldier[ID].level+1;
        mission_soldier[ID].levelupcount := 5;
        setWeaponSpec(ID,mission_soldier[ID].spec);
		//DrawText(ID,'Level up!',200,RGB(255,255,255),0.4,40,300);
		WriteConsole(ID,'You have reached level '+IntToStr(mission_soldier[ID].level),RGB(255,255,255));
		MaxXP(ID);
		
	end;
	
end;

//
// Account related Functions(reset)
//
procedure Reset(ID: byte);

begin
    SetWeaponActive(ID,1,false); // DEAGLES
    SetWeaponActive(ID,2,false); // MP5
    SetWeaponActive(ID,3,false); // AK
    SetWeaponActive(ID,4,false); // AUG
    SetWeaponActive(ID,5,false); // SPAS
    SetWeaponActive(ID,6,false); // RUGER
    SetWeaponActive(ID,7,false); // M79
    SetWeaponActive(ID,8,false); // BARRET
    SetWeaponActive(ID,9,false); // MINIMI
    SetWeaponActive(ID,10,false); // MINIGUN
    SetWeaponActive(ID,11,true); // SOCOM
    SetWeaponActive(ID,12,false); // KNIFE
    SetWeaponActive(ID,13,false); // SAW
    SetWeaponActive(ID,14,false); // LAW

    // Resetting account stats


    mission_soldier[ID].level := 1;
    mission_soldier[ID].mmx := 1;
    mission_soldier[Id].hud := true;
    mission_soldier[Id].evacuated := false;
    mission_soldier[ID].multiplier := 0.5;
    mission_soldier[ID].levelupcount := 0;
    mission_soldier[ID].spree := 0;
    mission_soldier[ID].xp := 0;
    mission_soldier[ID].spec := 0;
    mission_soldier[ID].cooldown := 0;
    MaxXP(ID);
end;
//
// Account related Functions(reset account)
//
procedure ResetAccount(ID: byte);

begin
    // Resetting account stats
    mission_soldier[ID].level := 1;
    mission_soldier[ID].evacuated := false;
    mission_soldier[ID].multiplier := 0.5;
    mission_soldier[ID].levelupcount := 0;
    mission_soldier[ID].spree := 0;
    mission_soldier[ID].xp := 0;
    mission_soldier[ID].spec := 0;
    mission_soldier[ID].cooldown := 0;
    MaxXP(ID);
end;
//
// Account related Functions(get speciality)
//
function getSpeciality(spec: integer): string;
begin
    case spec of
        BASICSOLDIER: Result := 'Soldier';
        COMMANDO: Result := 'Commando';
        ARTILLERY: Result := 'Artillery';
        MARINE: Result := 'Marine';
        ASSAULT: Result := 'Assault';
    end;
end;

//
// Account related Functions(save)
//
function Save(ID: byte; hwid,Action: string): boolean;
begin

    if Action = 'new' then
    begin
		Reset(ID);
        if(REQUIREDLEVEL > 0) then
        begin
            DrawText(ID,'Level '+ inttostr(REQUIREDLEVEL) +' Required' + br + 'Yours: ' + inttostr(mission_soldier[ID].level),200,RGB(255,255,255),0.2,20,250);			
			command('/setteam5 ' + inttostr(ID));
            exit;
        end;
        		
        

    end;
    
      
    if WriteFile('accounts/'+hwid+'.ini',
      '[ACCOUNT]'+chr(13)+chr(10)+            
      '[STATS]'+chr(13)+chr(10)+
      'Level='+IntToStr(mission_soldier[ID].level)+chr(13)+chr(10)+
      'XP='+FloatToStr(mission_soldier[ID].xp)+chr(13)+chr(10)+
      'SPEC='+IntToStr(mission_soldier[ID].spec)+chr(13)+chr(10)
      
      ) then
    begin
        if(Action = 'logout') then
        begin
            Reset(ID);
            command('/setteam5 ' + inttostr(ID));
        end
        else if(Action = 'quit') then
        begin
            Reset(ID);
        end
        else if(Action = 'new') then
        begin
            command('/setteam1 ' + inttostr(ID));
            setWeaponSpec(ID, mission_soldier[ID].spec);
        end
        else
        begin
            setWeaponSpec(ID, mission_soldier[ID].spec);
        end;
        Result := true;

    end
    else
    begin
        Result := false;
    end;
end;


procedure KickAllBots();
var
    count : integer;
begin
    for count:= 1 to 32 do
    begin
        if(GetPlayerStat(count, 'Active')) then
	    begin
		      // Check For BRAVO
		      if(GetPlayerStat(count, 'Team') = BRAVO) then
		      begin
		          if(GetPlayerStat(count, 'Human') = false) then
		          begin
                        if(GetPlayerStat(count, 'Name') <> 'Commander') then
    	                begin
                            command('/kick ' + inttostr(count));
                        end;
                  end;
              end;
        end;
    end;
end;
procedure LoadMapData(map: string);
var
    file: String;
    ts : String;
    list: array of string;
    count : integer;
    //element: TStringArray;


begin
    file := ReadFile('missions/'+map+'.ini');
    if file <> '' then
    begin
        list := Explode(copy(file,1,Length(file)), chr(13) + chr(10));
        //element:=xsplit(file,'#13#10');
        //if(ArrayHigh(list) = 0) then
        //begin
        //    list := Explode(copy(file,1,Length(file)), chr(10));
        //end;
        //for count := 0 to GetArrayLength(element) - 1 do
        for count := 0 to ArrayHigh(list) do
	    begin
            //ts := StrReplace(copy(list[count],1,Length(list[count])), chr(13), '');
            //ts := StrReplace(ts, chr(10), '');
	    ts := copy(list[count],1,Length(list[count]));
            //WriteLnFile('tempdebug.txt', ts);
	    if(length(ts) > 4) then
	    begin
        	if(copy(ts, 1, 4) = 'NAME') then
        	begin
            	    mission.name := copy(ts, 6, Length(ts));
        	end;
        	if(copy(ts, 1, 4) = 'TEXT') then
        	begin
            	    mission.text := copy(ts, 6, Length(ts));
        	end;
		if(copy(ts, 1, 4) = 'VEST') then
        	begin
            	    mission.vest := parseBool(copy(ts, 6, Length(ts)));
        	end;
		if(copy(ts, 1, 4) = 'TYPE') then
		begin
		    mission.mtype := StrToInt(copy(ts, 6, length(ts)));
		end;
	    end;
	    if(Length(ts) > 9) then
	    begin
        	if(copy(ts, 1, 9) = 'AIRSTRIKE') then
        	begin
            	    mission.airstrike := parseBool(copy(ts, 11, Length(ts)));
        	end;	
            end;
	    if(Length(ts) > 2) then
	    begin
        	if(copy(ts, 1, 2) = 'XP') then
        	begin
            	    mission.xp := StrToFloat(copy(ts, 4, Length(ts)));
        	end;
	    end;
	    if(Length(ts) > 3) then
	    begin
        	if(copy(ts, 1, 3) = 'BOT') then
        	begin
            	    command('/addbot2 ' + copy(ts, 5, Length(ts)));
        	end;
	    end;
        end;
    end;
end;
//
// Account related Functions(load)
//
function Load(ID: byte; hwid: string): string;
var
    file: String;
begin
	file := ReadFile('accounts/'+hwid+'.ini');
	if file <> '' then
    begin
        
	
		//if mission_soldier[ID].name <> '' then Save(ID,hwid,''); // Saving current account
		Reset(ID);
		
		try
			mission_soldier[ID].level := StrToInt(copy(file,StrPos('Level=',file)+6,StrPos('XP=',file)-StrPos('Level=',file)-8));
			if(mission_soldier[ID].level >= 16) then
			begin
				GiveBonus(ID,3);
			end;
		except
			mission_soldier[ID].level := 1;
		end;

		try
			mission_soldier[ID].xp := StrToFloat(copy(file,StrPos('XP=',file)+3,StrPos('SPEC=',file)-StrPos('XP=',file)-5));
		except
			mission_soldier[ID].xp := 0;
		end;
		try
			mission_soldier[ID].spec := StrToInt(copy(file,StrPos('SPEC=',file)+5,1));
		except
			mission_soldier[ID].spec := BASICSOLDIER;
		end;
		setWeaponSpec(ID, mission_soldier[ID].spec);
		MaxXP(ID);
		if(mission_soldier[ID].level < REQUIREDLEVEL) then
		begin
			DrawText(ID,'Level '+ inttostr(REQUIREDLEVEL) +' Required' + br + 'Yours: ' + inttostr(mission_soldier[ID].level),200,RGB(255,255,255),0.2,20,250);
			Result := 'Not High enough level: ' + inttostr(mission_soldier[ID].level);
			reset(ID);
			command('/setteam5 ' + inttostr(ID));
			exit;

		end;
		Result := 'Logged in with level: ' + inttostr(mission_soldier[ID].level);		
		setWeaponSpec(ID, mission_soldier[ID].spec);        
    end
    else
    begin
		save(ID,hwid,'new');
        Result := 'Logged in with level: ' + inttostr(mission_soldier[ID].level);
    end;
end;

//
// misc related Functions(help)
//
procedure Help(ID: byte);
begin
	WriteConsole(ID,'Available commands:',RGB(255,122,0));
	WriteConsole(ID,'/credits - displays Credits',RGB(255,122,0));
	WriteConsole(ID,'/help - displays this help message',RGB(255,122,0));
	WriteConsole(ID,'/allchars - displays characters',RGB(255,122,0));
	WriteConsole(ID,'/char - displays you character''s information',RGB(255,122,0));	
	WriteConsole(ID,'/resetaccount - Resets your account(WARNING you will loose all your level/speciality etc',RGB(255,122,0));
	WriteConsole(ID,'/chpass <oldpassword> <newpassword> - changes password onto an account',RGB(255,122,0));
	WriteConsole(ID,'(NOTE: your account is automatically saved any time you quit/disconnect)',RGB(255,122,0))
	WriteConsole(ID,'/spreetop - displays spreetop',RGB(255,122,0));
	WriteConsole(ID,'/hud - turns hud ON/OFF',RGB(255,122,0));
	WriteConsole(ID,'/skills - displays Skills',RGB(255,122,0));
	WriteConsole(ID,'/classes - shows classes',RGB(255,122,0));
	WriteConsole(ID,'/mission - shows mission info',RGB(255,122,0));
	WriteConsole(ID,'/class <class> set your class requires level>=5 ',RGB(255,122,0));
	WriteConsole(ID,'!restart - Restarts mission mod',RGB(255,122,0));
    WriteConsole(ID,'!irc - displays irc info',RGB(255,122,0));
    WriteConsole(ID,'!currentmaps - displays the current maps info',RGB(255,122,0));
	WriteConsole(ID,'______________________',RGB(255,122,0));
	WriteConsole(ID,'Don''t forget to visit the forum:',RGB(255,122,0));
	WriteConsole(ID,'http://www.inc-soldat.se/forum/',RGB(255,122,0));
  
	WriteConsole(ID,'Press T or / to show the whole help message!',RGB(255,122,0));
end;
//
// misc related Functions(skills)
//
procedure Skills(ID: byte);
begin
	WriteConsole(ID,'Available skills:',RGB(255,122,0));
	WriteConsole(ID,'Active:',RGB(255,122,0));
	WriteConsole(ID,'/flamer - Marine(level 20)',RGB(255,122,0));
	WriteConsole(ID,'/rage - Assault(level 20)',RGB(255,122,0));
	WriteConsole(ID,'/stealth - Commando(level 20)',RGB(255,122,0));
	WriteConsole(ID,'/bomb - Artillery(level 12)',RGB(255,122,0));
	WriteConsole(ID,'/nuke - Artillery(level 20)',RGB(255,122,0));
	WriteConsole(ID,'/bio - Marine(level 25)',RGB(255,122,0));
    WriteConsole(ID,'/reinforce1 - All(level 30) reinforce(black flag)', RGB(255,122,0));
    WriteConsole(ID,'/reinforce2 - All(level 30) reinforce(white flag)', RGB(255,122,0));
    WriteConsole(ID,'/skill<X> - change <X> to 1-4 for taunt mappings of skills', RGB(255,122,0));
	WriteConsole(ID,'Passive:',RGB(255,122,0));
	WriteConsole(ID,'vest at spawn - level 16',RGB(255,122,0));
	WriteConsole(ID,'regen increases per level - level 1',RGB(255,122,0));
	WriteConsole(ID,'grenades at kill chance increases per level - level 1(All except Commando)',RGB(255,122,0));
    WriteConsole(ID,'critical hit chance increases per level - level 1(Commando, Marine)',RGB(255,122,0));
    WriteConsole(ID,'Lock and Load increases per level - level 1(Assault)',RGB(255,122,0));
    WriteConsole(ID,'______________________',RGB(255,122,0));
	WriteConsole(ID,'Don''t forget to visit the forum:',RGB(255,122,0));
	WriteConsole(ID,'http://inc.sytes.net/forum/',RGB(255,122,0));
	WriteConsole(ID,'Press T or / to show the whole help message!',RGB(255,122,0));
end;
//
// toplist related Functions(print to player)
//
procedure printTopListToPlayer(ID : byte);
var
    count : integer;
begin
    if(toplistAdded) then
    begin
        WriteConsole(ID,'Spree Toplist:', RGB(255,122,0));
        for count := 1 to 10 do
        begin
            if(toplist[count].Player <> '') then
            begin
                WriteConsole(ID,inttostr(count) + '. ' + toplist[count].Player + ' at ' + inttostr(toplist[count].Score) + ' Kills', RGB(255,122,0));
            end;
        end;
    end
    else
    begin
        WriteConsole(ID, 'None Added yet', RGB(255,122,0));
    end;
end;



//
// toplist related Functions(print to all)
//
procedure printTopList();
var
    count : integer;
begin
    if(toplistAdded) then
    begin
        WriteConsole(0,'Spree Toplist:', RGB(255,122,0));
        for count := 1 to 3 do
        begin
            if(toplist[count].Player <> '') then
            begin
                WriteConsole(0,inttostr(count) + '. ' + toplist[count].Player + ' at ' + inttostr(toplist[count].Score) + ' Kills', RGB(255,122,0));
            end;
        end;
    end;
end;
//
// toplist related Functions(add player to toplist)
//
procedure AddToToplist(Player: byte; Score : integer);
var
    count : integer;
    added : boolean;
    tempPlayer1 : String;
    tempScore1 : integer;
    tempPlayer2 : String;
    tempScore2 : integer;
begin
    toplistAdded := true;
    added := false;
    for count:= 1 to 10 do
    begin
        if(added) then
        begin
            tempPlayer2 := toplist[count].Player;
            tempScore2 := toplist[count].Score;
            toplist[count].Player := tempPlayer1;
            toplist[count].Score := tempScore1;
            tempPlayer1 := tempPlayer2;
            tempScore1 := tempScore2;
        end
        else
        begin
            if(toplist[count].Score < Score) then
            begin
                tempPlayer1 := toplist[count].Player;
                tempScore1 := toplist[count].Score;
                toplist[count].Score := Score;
                toplist[count].Player := IDToName(Player);
                added := true;
            end;
        end;
    end;
end;
//
// mission related Functions(give xp)
//
procedure giveMissionXP();
var 
    count :byte;
begin
    for count:= 1 to 32 do
    begin
	   if(GetPlayerStat(count, 'Active')) then
	   begin
	       if(GetPlayerStat(count, 'Team') = ALPHA) then
	       begin
                WriteConsole(count, 'Mission XP gained: ' + floattostr(roundto((15+mission.xp*strtofloat(inttostr(mission_soldier[count].level*mission_soldier[count].mmx))),0)), RGB(0,0,255));
                incXP(count,15+mission.xp*strtofloat(inttostr(mission_soldier[count].level*mission_soldier[count].mmx)));
                mission_soldier[count].mmx := 1;
	       end;
	   end;
    end;
end;
//
// mission related Functions(finish mission)
//
procedure finishMission();
var
    lmax,tmax :integer;
begin
    disableCommands := true;
    giveMissionXP();
    flagcap := false;
    lmax := calcMaxMap();
    if(lmax > maxmap) then
    begin
        tmax := maxmap;
    end
    else
    begin
        tmax := lmax;
    end;
    SetTeamScore(ALPHA, 60000);
    if(cmap >= tmax) then
    begin
	   cmap := 1;
	   command('/map ' + maplist[cmap]);
    end
    else
    begin
	   cmap := cmap +1;
	   command('/map ' + maplist[cmap]);
    end;
end;
//
// mission related Functions(calculate mission finish)
//
procedure calcMissionFinish();
var 
    loop : byte;
    total : integer;
    count : integer;
    X,Y : single;
    BlueFlagX, BlueFlagY, RedFlagX, RedFlagY : single;
begin
    GetFlagsXY(BlueFlagX, BlueFlagY, RedFlagX, RedFlagY);
    count := 0;
    evacuated := true;
    for loop := 1 to 32 do
    begin
	   if(GetPlayerStat(loop, 'Active')) then
	   begin
	       if(GetPlayerStat(loop, 'Human')) then
	       begin
		      GetPlayerXY(loop, X, Y);
		      //if(debug) then
		      //begin
		      //    WriteConsole(0, 'AlphaX: ' + floattostr(AlphaX) + ' AlphaY: ' + floattostr(AlphaY) + ' X: ' + floattostr(X) + ' Y: ' + floattostr(Y), RGB(255,0,0));
		      //end;
		      if(abs(X-RedFlagX) <= 200) and (abs(Y-RedFlagY) <= 30) then
		      begin
		          mission_soldier[loop].mmx := 3;
                  mission_soldier[loop].evacuated := true;
//		          DrawText(loop,'Evacuate Bonus',200,RGB(255,255,255),0.1,20,350);
		          count := count +1;
		      end
		      else
		      begin
                  //DrawText(loop,'Evacuate Complete',200,RGB(255,255,255),0.1,20,350);
                  mission_soldier[loop].evacuated := false;
		          mission_soldier[loop].mmx := 1;
		      end;
	       end;
	   end;
    end;
    if(count > 0) then
    begin
	   total := (count*100)/(ALPHAPLAYERS);
	   //if(debug) then
	   //begin
	   //    WriteConsole(0, 'Total: ' + inttostr(total) + ' Count: ' + inttostr(count) + ' AlphaPlayers: ' + inttostr(ALPHAPLAYERS), RGB(255,0,0));
	   //end;
	   if(total >= EXTRACTPERCENT) then
	   begin
            evacuatedamount := 0;
	        finishMission();

	   end
	   else
	   begin
	       total := ((ALPHAPLAYERS*EXTRACTPERCENT)/100) - count;
           evacuatedamount := total +1;
	       //WriteConsole(0, 'Evacuate: ' + inttostr(total+1) + ' more', RGB(255,255,255));
           //DrawText(0,'Evacuate: ' + inttostr(total+1) + ' more',200,RGB(255,255,255),0.1,20,350);
	   end;
    end
    else
	begin
	   total := ((ALPHAPLAYERS*EXTRACTPERCENT)/100);
       evacuatedamount := total +1;
	  // WriteConsole(0, 'Objective Completed Get To The Extraction Point(White Flag) Need ' + inttostr(total+1) + ' more players!!!', RGB(255,255,255));
       //DrawText(0,'Evacuate: ' + inttostr(total+1)+ ' more',200,RGB(255,255,255),0.1,20,350);
	end;
end;
procedure calcBaseMissionFinish();
var 
    ID : byte;
    X,Y : single;
    BlueFlagX, BlueFlagY, RedFlagX, RedFlagY : single;
begin
    GetFlagsXY(BlueFlagX, BlueFlagY, RedFlagX, RedFlagY);

    for ID := 1 to 32 do
    begin
	   if(GetPlayerStat(ID, 'Active')) then
	   begin
	       if(not GetPlayerStat(ID, 'Human')) then
	       begin
		    if(GetPlayerStat(ID, 'Alive')) then
		    begin
		      GetPlayerXY(ID, X, Y);
		      if(abs(X-RedFlagX) <= 30) and (abs(Y-RedFlagY) <= 30) then
		      begin
		    	    countdown := BASEHOLDAMOUNT;
		      end;
		    end;
	       end;
	   end;
    end;
    if(countdown  < 1) then
    begin
	for ID := 1 to 32 do
	begin
	    if(GetPlayerStat(ID, 'Active') = true) and (GetPlayerStat(ID,'Team') = ALPHA) then
	    begin
		mission_soldier[ID].mmx := 3;
	    end;
	end;
        evacuated := true;
	finishMission();
    end
    else
    begin
	countdown := countdown - 1;	
    end;
end;

procedure DrawHud(ID : byte);
var
    text : string;
begin
    if(mission_soldier[ID].hud) then
    begin
        Text := '';
        
        
        Text := 'Kills: ' + inttostr(mission_soldier[ID].spree) + br + 'XP: ' + floattostr(mission_soldier[ID].multiplier) + 'X';
        
        case mission_soldier[ID].spec of
            ARTILLERY : begin
                if(mission_soldier[ID].level >= 12) then
                begin
                    if((((60*10)-(GetTickCount()-mission_soldier[ID].cooldown))/60) > 0) then
                    begin
                        Text := Text + br + 'Bomb: ' + inttostr(((60*10)-(GetTickCount()-mission_soldier[ID].cooldown))/60);
                    end
                    else
                    begin
                        Text := Text + br + 'Bomb: Ready';
                    end;
                end;
                if(mission_soldier[ID].level >= 20) then
                begin
                    if((((60*(150-mission_soldier[ID].level))-(GetTickCount()-mission_soldier[ID].cooldown))/60) > 0) then
                    begin
                        Text := Text + br + 'Nuke: ' + inttostr(((60*(150-mission_soldier[ID].level))-(GetTickCount()-mission_soldier[ID].cooldown))/60);
                    end
                    else
                    begin
                        Text := Text + br + 'Nuke: Ready';
                    end;
                end;
            end;
            MARINE : begin
                if(mission_soldier[ID].level >= 20) then
                begin
                    if((((60*(100-mission_soldier[ID].level))-(GetTickCount()-mission_soldier[ID].cooldown))/60) > 0) then
                    begin
                        Text := Text + br + 'Flamer: ' + inttostr(((60*(100-mission_soldier[ID].level))-(GetTickCount()-mission_soldier[ID].cooldown))/60);
                    end
                    else
                    begin
                        Text := Text + br + 'Flamer: Ready';
                    end;
                end;
                if(mission_soldier[ID].level >= 25) then
                begin
                    if((((60*(75-mission_soldier[ID].level))-(GetTickCount()-mission_soldier[ID].cooldown))/60) > 0) then
                    begin
                        Text := Text + br + 'Bio: ' + inttostr(((60*(75-mission_soldier[ID].level))-(GetTickCount()-mission_soldier[ID].cooldown))/60);
                    end
                    else
                    begin
                        Text := Text + br + 'Bio: Ready';
                    end;
                end;
            end;
            COMMANDO : begin
                if(mission_soldier[ID].level >= 20) then
                begin
                    if((((60*(300-(mission_soldier[ID].level*2)))-(GetTickCount()-mission_soldier[ID].cooldown))/60) > 0) then
                    begin
                        Text := Text + br + 'Stealth: ' + inttostr(((60*(300-(mission_soldier[ID].level*2)))-(GetTickCount()-mission_soldier[ID].cooldown))/60);
                    end
                    else
                    begin
                        Text := Text + br + 'Stealth: Ready';
                    end;
                end;
            end;
            ASSAULT : begin
                if(mission_soldier[ID].level >= 20) then
                begin
                    if((((60*(100-mission_soldier[ID].level))-(GetTickCount()-mission_soldier[ID].cooldown))/60) > 0) then
                    begin
                        Text := Text + br + 'Rage: ' + inttostr(((60*(100-mission_soldier[ID].level))-(GetTickCount()-mission_soldier[ID].cooldown))/60);
                    end
                    else
                    begin
                        Text := Text + br + 'Rage: Ready';
                    end;
                end;

            end;
        end;
        if(mission_soldier[ID].level >= 30) then
        begin
            if((((60*300)-(GetTickCount()-mission_soldier[ID].cooldown))/60) > 0) then
            begin
                Text := Text + br + 'Reinforce: ' + inttostr(((60*300)-(GetTickCount()-mission_soldier[ID].cooldown))/60);
            end
            else
            begin
                Text := Text + br + 'Reinforce: Ready';
            end;
        end;
        if(evacuated) and (mission.mtype = 1)then
        begin
            if(evacuatedamount = 0) then
            begin
                if(mission_soldier[ID].evacuated) then
                begin
                    Text := Text + br + 'Evacuation Bonus';
                end
                else
                begin
                    Text := Text + br + 'Evacuation Complete';
                end;
            end
            else
            begin
                Text := Text + br + 'Evacuate: ' + inttostr(evacuatedamount) + ' more';
            end;
        end;
	if(evacuated) and (mission.mtype = 2) then
	begin
            Text := Text + br + 'Reinforcements has Arrived';
	end
	else if(mission.mtype = 2) then
	begin
	    Text := Text + br + 'Reinforcements Arrives in: ' + inttostr(countdown);
	end;
        if(mission_soldier[ID].levelupcount > 0) then
        begin
            if(evacuated) then
            begin
                Text := Text + ' Level Up!';
            end
            else
            begin
                Text := Text + br + 'Level Up!';
            end;
            mission_soldier[ID].levelupcount := mission_soldier[ID].levelupcount - 1;
        end;
        if(Text <> '') then
        begin
            DrawText(ID,Text,200,RGB(255,255,255),0.1,20,300);
        end;
    end
    else
    begin
        if(evacuated) then
        begin
            if(evacuatedamount = 0) then
            begin
		if(mission.mtype = 1) then
		begin
            	    if(mission_soldier[ID].evacuated) then
            	    begin
                	WriteConsole(ID,'Evacuation Bonus',RGB(255,255,255));
            	    end
            	    else
        	    begin
                	WriteConsole(ID,'Evacuation Complete',RGB(255,255,255));
            	    end;
		end;
		if(mission.mtype = 2) then
		begin
		    WriteConsole(ID,'Reinforcements has Arrived', RGB(255,255,255));
		end;
            end
            else
            begin
		if(mission.mtype = 1) then
		begin
            	    WriteConsole(ID,'Evacuate: ' + inttostr(evacuatedamount) + ' more',RGB(255,255,255));
		end;
		if(mission.mtype = 2) then
		begin
		    WriteConsole(ID,'Reinforcements in: ' + inttostr(countdown) + ' Seconds', RGB(255,255,255));
		end;
            end;
        end;
    end;
end;
//
// Events
//
procedure OnPlayerKill(Killer, Victim: byte;Weapon: string);
var 
    spree: array[1..30] of string;
    killsNeeded: byte;
    rand : integer;
begin
    // Normal experience
    if(GetPlayerStat(Killer, 'Team') = ALPHA) and (Killer <> Victim) then
    begin
        IncXP(Killer,mission.xp*mission_soldier[killer].multiplier);
        rand := random(1,100);
        if(rand <= mission_soldier[Killer].level) and (mission_soldier[Killer].spec <> COMMANDO) then
        begin
            if(mission_soldier[Killer].spec = ASSAULT) then
            begin
                forceWeapon(Killer, GetPlayerStat(Killer,'Primary'), GetPlayerStat(Killer,'Secondary'), 0);
                //WriteConsole(Killer, 'Lock And Load', RGB(255,122,0));
            end
            else
            begin
                WriteConsole(Killer, 'Looted some grenades', RGB(255,122,0));
            end;
            GiveBonus(Killer,4);
        end;

    end;
    killsNeeded := 5; //number of kills needed to count as a killing spree
    //spree[x] where x represents the current number of spree kills player has
    //more can be added just be sure to change the spree array size
    spree[killsNeeded] := ' is on a Killing Spree!';
    spree[8] := ' is on a Rampage!';
    spree[11] := ' is Dominating!';
    spree[14] := ' is Madness!';
    spree[17] := ' is Ownage!';
    spree[20] := ' is Unstopable!';
    spree[22] := ' is Godlike!';
    spree[25] := ' is a Cheater!!';
    spree[27] := ' Dude! Stop it!!';
    if (Killer <> Victim)  then
    begin
        if(GetPlayerStat(victim,'Team') <> GetPlayerStat(killer,'Team')) and(Killer <> Commander) then
        begin
            mission_soldier[killer].spree := mission_soldier[killer].spree + 1;
            if (mission_soldier[Victim].spree >= killsNeeded) then
            begin
                WriteConsole(0, + GetplayerStat(Victim,'name') + 's ' + inttostr(mission_soldier[victim].spree) + ' kills spree ended by ' + GetPlayerStat(killer,'name'),RGB(255,122,0));
		        mission_soldier[Victim].multiplier := 0.5;
                AddToToplist(Victim, mission_soldier[Victim].spree);
            end;
            mission_soldier[victim].spree := 0;
            if (mission_soldier[killer].spree <= Arrayhigh(spree)) then
            begin
                if (spree[mission_soldier[Killer].spree] <> '') then
                begin
                    
					if(mission_soldier[killer].multiplier < 5) then
					begin
						mission_soldier[Killer].multiplier := mission_soldier[Killer].multiplier +0.5;
						if not(mission_soldier[Killer].hud) then
						begin
							WriteConsole(Killer, floattostr(mission_soldier[Killer].multiplier) + 'X', RGB(255,122,0));
						end;
					end;
                    
                    WriteConsole(0, + GetPlayerStat(Killer,'name') + spree[mission_soldier[Killer].spree],RGB(255,122,0));
                end;
            end;
        end
        else
        begin
            if (mission_soldier[killer].spree > 0) then
            begin
                SayToPlayer(Killer, 'Your spree kills have been reset for team killing');
                mission_soldier[Killer].multiplier := 0.5;
            end;
            mission_soldier[killer].spree := 0;
        end;
    end
    else
    begin
        if(mission_soldier[Killer].spree >= killsNeeded) then
        begin
            WriteConsole(0, GetplayerStat(Victim,'name') + 's ' + inttostr(mission_soldier[Victim].spree) + ' kills spree ended by himself',RGB(255,122,0));
            mission_soldier[Victim].multiplier := 0.5;
            AddToToplist(Victim, mission_soldier[Victim].spree);
        end;
        mission_soldier[Killer].spree := 0;
    end;    
end;

procedure OnFlagScore(ID, TeamFlag: byte);
begin
    flagcap := true;
    WriteConsole(0, 'Objective Completed Get To The Extraction Point(White Flag)', RGB(255,255,255));
end;

procedure AppOnIdle(Ticks: integer);
var 
    ID : integer;
begin
    // 5 min
    if(Ticks mod 18000 = 0) then
    begin
        printTopList();
        if(NumPlayers = NumBots) then
	    begin
	    cmap := 1;
	    command('/map ' + maplist[cmap]);
        disableCommands := false;
//            command('/loadlist mapslist');
//            command('/map ' + STARTMAP);
	    //command('/nextmap');
        end;
    end;
    // 5 sec
//    if(Ticks = 300) then
//    begin
//        LoadMapData(CurrentMap);
//	calcAirStrikeVars();
//	flagcap := false;
//    end;
    if (Ticks mod (60) = 0) then
    begin
    	if(mission.mtype = 2) and (evacuated = false) then
	begin
	    CalcBaseMissionFinish();
	end;
	   for ID := 1 to 32 do
	   begin
	       if(GetPlayerStat(ID, 'Active')) then
	       begin
        	   if(GetPlayerStat(ID, 'Team') = ALPHA) then
        	   begin
		          regen(ID,mission_soldier[ID].level);
                  DrawHud(ID);
    	       end;
               if(GetPlayerStat(ID, 'Team') = SPECTATOR) then
               begin
                    DrawText(ID,'Welcome to Mission Mod ' + floattostr(MMVERSION) + br + 'Join Alpha(read /help) ' + br +'To start playing' + br + 'Level ' + inttostr(REQUIREDLEVEL) + ' required on this server',600,RGB(255,255,255),0.1,20,350);
               end;
	       end;
        end;
    end;
    if(flagcap) and (mission.mtype = 1) then
    begin
	   if(Ticks mod 180 = 0) then
	   begin
	       CalcMissionFinish();
	   end;
    end;
    if(mission.airstrike) then
    begin
        if(((Ticks+(RaidCountdown*60)) mod (60*(RaidInterval))) = 0) then
	    begin
	       if(RaidCountdown = RaidWarning) then
	       begin
		      WriteConsole(0, 'Incoming Airstrike in: ', RGB(255,122,0));
	       end;
    	   WriteConsole(0, '...' + inttostr(RaidCountdown), RGB(255,122,0));
	       RaidCountdown := RaidCountdown -1;
	       if(RaidCountdown = 0) then
	       begin
		      Raidcountdown := RaidWarning;
	       end;
	   end;
	   if((Ticks mod (60*RaidInterval)) = 0) then
	   begin
            PerFormAirStrike();
	   end;
    end;
end;

procedure OnMapChange(NewMap: string);
var
    count : integer;
begin

    for count:= 1 to 32 do
    begin
	   if(GetPlayerStat(count, 'Human')) then
	   begin
	       if(GetPlayerStat(count, 'Active')) then
	       begin
		      if(GetPlayerStat(count,'Team') = ALPHA) then
		      begin
		         save(count, GetPlayerStat(count, 'HWID'), '');
			     mission_soldier[count].cooldown := 0;
                 mission_soldier[count].evacuated := false;
			     voted[count] := false;

		      end;
	       end;
	   end;
    end;
    LeftX := 1;
    RightX := 2;
    FlagHeight:= 3;
    flagcap := false;
    evacuated := false;
    countdown := BASEHOLDAMOUNT;
    KickAllBots();
    LoadMapData(NewMap);
    calcAirstrikeVars();
    disableCommands := false;
    WriteConsole(0, 'Mission: ' + mission.name,RGB(255,122,0));
    WriteConsole(0, 'Objective: ' + mission.text,RGB(255,122,0));
end;

procedure OnLeaveGame(ID, Team: byte;Kicked: boolean);
begin
    if(Team = ALPHA) then
    begin       
		Save(ID,GetPlayerStat(ID,'HWID'),'quit');
		voted[ID] := false;
        Reset(ID);        
    end;
end;

procedure ActivateServer();
var
    count : byte;
begin
    RaidCountdown := RaidWarning;
    br:=chr(13) + chr(10);
    evacuatedamount := 0;
    disableCommands := false;
    evacuated := false;
    LeftX := 1;
    RightX := 2;
    FlagHeight := 3;
    toplistAdded := false;
    CountDown := BASEHOLDAMOUNT;
    debug:= false;
    // Add commander Bot
    command('/addbot5 Commander');
	Commander := 1;
	for count := 1 to 32 do
	begin
    	    if(GetPlayerStat(count, 'Name') = 'Bomber Squadron') then
    	    begin
        	   Commander := count;
    	    end;
	end;
//    ServerModifier('Gravity',0.06);
    // Config Start
    // Here you add all the maps we want to play
    // remember to create mission data for them
    maplist[1] := 'mm2_Prison';
    maplist[2] := 'mm2_Carrier';
    maplist[3] := 'mm2_Invade';
    maplist[4] := 'mm2_Field';
    maplist[5] := 'mm2_Village';
    maplist[6] := 'mm2_Domicile';
    maplist[7] := 'mm2_Airfield';
    maplist[8] := 'mm2_Harlem';
    maplist[9] := 'mm2_Tower';
    maplist[10] := 'mm2_Bureau';
    maplist[11] := 'mm2_Highway';
    maplist[12] := 'mm2_Base';
    maplist[13] := 'mm2_Whitehouse';
    maplist[14] := 'mm2_Farm';
    maplist[15] := 'mm2_Radar';
    maplist[16] := 'mm2_Facility';
    maplist[17] := 'mm2_Island';
    maplist[18] := 'mm2_Valley';
    maplist[19] := 'mm2_Canyon';
    maplist[20] := 'mm2_Norad';
    maplist[21] := 'mm2_GoldenGate';
    maplist[22] := 'mm2_SF';
    maplist[23] := 'mm2_Bay';
    maplist[24] := 'mm2_OilRig';
    maplist[25] := 'mm2_Mexico';
    maplist[26] := 'mm2_SE';
    maplist[27] := 'mm2_Japan';
    maplist[28] := 'mm2_Zeppelin';
    cmap := 1; // Current Map should be 1
    maxmap := 28; // Amount of Maps
    // Config End

end;

procedure OnPlayerRespawn(ID: Byte);
var
    rand : integer;
    secondary : integer;
    primary : integer;
begin
    if(GetPlayerStat(ID, 'Active')) then
    begin
	   if(GetPlayerStat(ID, 'Human') = false) then
	   begin
            //Weapons
            if(MaskCheck(GetPlayerStat(ID, 'Name'),'*Sniper*')) then
            begin
                ForceWeapon(ID,BARRET,KNIFE,0);
            end;
            if(MaskCheck(GetPlayerStat(ID, 'Name'),'Demo*')) then
            begin
                ForceWeapon(ID,M79,LAW,0);
            end;
            if(MaskCheck(GetPlayerStat(ID, 'Name'),'Marine*')) then
            begin
                rand := Random(1,6);
                case rand of
                    1: ForceWeapon(ID,DEAGLES,SOCOM,0);
                    2: ForceWeapon(ID,MP5,SOCOM,0);
                    3: ForceWeapon(ID,AK,SOCOM,0);
                    4: ForceWeapon(ID,AUG,SOCOM,0);
                    5: ForceWeapon(ID,RUGER,SOCOM,0);
                end;

		
            end;
            if(MaskCheck(GetPlayerStat(ID, 'Name'),'Assault*')) then
            begin
		
                if(ENABLEMINIGUN) then
                begin
                    rand := Random(1,5);
                end
                else
                begin
                    rand := Random(1,4);
                end;
                case rand of
                    1: ForceWeapon(ID,SPAS,CHAINSAW,0);
                    2: ForceWeapon(ID,MINIMI,CHAINSAW,0);
                    3: ForceWeapon(ID,RUGER,CHAINSAW,0);
                    4: ForceWeapon(ID,MINIGUN,CHAINSAW,0);
                end;

            end;
            if(MaskCheck(GetPlayerStat(ID, 'Name'),'Flamer*')) then
            begin
                ForceWeapon(ID,FLAMER,SOCOM,0);
		//SpawnObject(GetPlayerStat(ID,'x'),GetPlayerStat(ID,'y'),18);

            end;
            if(mission.vest) then
            begin
                GiveBonus(ID, 3);
            end;
        end
    	else
        begin
	
            // fixing for ppl getting there default secondary
            secondary := GetPlayerStat(ID, 'Secondary');
            primary := GetPlayerStat(ID, 'Primary');
            if(primary < 1) or (primary > 10) then
            begin
                primary := 3;
            end;
            if(mission_soldier[ID].spec = ARTILLERY) then
            begin
                if(secondary <>  LAW) then
                begin
                    ForceWeapon(ID, primary, SOCOM, 0);
                end;
            end;
            if(mission_soldier[ID].spec = MARINE) then
            begin
                if(secondary <>  SOCOM) then
                begin
                    ForceWeapon(ID, primary, SOCOM, 0);
                end;
            end;
            if(mission_soldier[ID].spec = BASICSOLDIER) then
            begin
                if(secondary <>  SOCOM) then
                begin
                    ForceWeapon(ID, primary, SOCOM, 0);
                end;
            end;
            if(mission_soldier[ID].spec = COMMANDO) then
            begin
                if(secondary <>  KNIFE) then
                begin
                    ForceWeapon(ID, primary, SOCOM, 0);
                end;
            end;
            if(mission_soldier[ID].spec = ASSAULT) then
            begin
                if(secondary <>  CHAINSAW) then
                begin
                    ForceWeapon(ID, primary, SOCOM, 0);
                end;
            end;

            // Vest on respawn for high levels
            if(mission_soldier[ID].level >= VESTLEVEL) then
            begin
                GiveBonus(ID, 3);
            end;
            // set weapons
	        setWeaponSpec(ID, mission_soldier[ID].spec);
        end;
    end;
end;

procedure OnJoinGame(ID, Team: byte);
begin
    WriteConsole(ID, 'Welcome Soldat Multiplayer Mission Mod', RGB(255,122,0));
    WriteConsole(ID, 'join #soldat.inc for info and feature requests ', RGB(255,122,0));
    if(GetPlayerStat(ID, 'Human')) then
    begin
        reset(ID);
    end;
    voted[ID] := false;
end;

procedure OnJoinTeam(ID, Team: byte);
begin
    if(GetPlayerStat(ID, 'Human')) then
    begin
        if(Team = ALPHA) then
        begin
			Load(ID,GetPlayerStat(ID,'HWID'));
            WriteConsole(ID, 'Welcome to Alpha Force', RGB(255,255,255));
            WriteConsole(ID, 'Type /help for commands', RGB(255,255,255));
            WriteConsole(ID, 'Mission: ' + mission.name,RGB(255,122,0));
            WriteConsole(ID, 'Objective: ' + mission.text,RGB(255,122,0));
            exit;
        end;        
        if(Team = BRAVO) then
        begin
            reset(ID);
            Command('/setteam1 '+ IntToStr(ID));
            exit;
        end;
		if(Team = SPECTATOR) then
		begin
			reset(ID);
			exit;
		end;
    end;
end;

function OnPlayerDamage(Victim,Shooter: Byte;Damage: Integer) : integer;
var
    primary : byte;
    Rnd : double;
begin
    Result := Damage;
    // Critical Damage
    if(Shooter <> Victim) and (GetPlayerStat(Shooter,'Human') = true) then
    begin
	Rnd:= Random(0,100);
//	WriteConsole(Shooter,'Damage: ' + inttostr(Damage) + 'Crit: ' + floattostr((sqrt(damage*damage*damage)*mission_soldier[Shooter].level)/25) + 'Rand: ' + floattostr(Rnd), RGB(255,255,255));
	
	//if(Random(0,100) < ((mission_soldier[Shooter].level*Damage*Damage)/300)) then
//	if(Random(0,100) < ((mission_soldier[Shooter].level*Damage)/12)) then
	
//	if(Rnd < ((sqrt(damage*damage*damage)*mission_soldier[Shooter].level)/25)) then
	//if(Rnd < ((mission_soldier[Shooter].level*Damage*Damage)/300)) then
	if (Rnd < ((mission_soldier[Shooter].level * Damage * sqrt(Damage)) / 50 + (0.1 * mission_soldier[Shooter].level))) then
	begin
//	    WriteConsole(Shooter,'Crit: ' + inttostr((mission_soldier[Shooter].level*Damage*Damage)/300),RGB(255,255,255));
	    Result := 4000;
	end;
    
    end;
    {
    if(mission_soldier[Shooter].spec = MARINE) and (Shooter <> Victim) then
    begin
        primary := GetPlayerStat(Shooter,'Primary');
        if(primary = DEAGLES) then
        begin
            if(Random(0,100) < ((mission_soldier[Shooter].level*2)/3)) then
            begin
                Result := 4000;
            end;
        end;
    end;
    if(mission_soldier[Shooter].spec = COMMANDO) and (Shooter <> Victim) then
    begin
        //if(debug) then
        //begin
	       //writeLnFile('debuglog.txt',FormatDate('hh:nn:ss am/pm')+':dmg:'+IDToName(Shooter)+':'+inttostr(Damage)+':'+IDToName(Victim));
        //end;
        primary := GetPlayerStat(Shooter,'Primary');
        if(primary = RUGER) then
        begin
            if(Random(0,100) < mission_soldier[Shooter].level) then
            begin
                Result := 4000;
            end;
        end
        if(primary = BARRET) then
        begin
            Result := 4000;
        end;
    end;
}
end;

procedure OnPlayerSpeak(ID: byte; Text: string);
var
    loop : integer;
    loopamount : integer;
    mapstring : string;
begin
  If Length(text) > 1 then begin
    If copy(text,1,1) = '/' then begin
      WriteConsole(ID,'Commands beginning with / must be typed into the console.',RGB(255,255,255));
      WriteConsole(ID,'To see how this works, type !howto.',RGB(255,255,255));
      DrawText(ID,'Commands beginning with / must be typed into the console. To see how this works, type !howto.',200,RGB(255,255,255),0.065,20,360);
    end
    else
    If copy(text,1,1) = '!' then
      case lowercase(text) of
        '!help','!info':begin
            WriteConsole(ID,'Welcome to Mission Mod. This is a Mission type script that allows',RGB(255,255,255));
            WriteConsole(ID,'you to gain levels/classes etc by killing enimies and finishing missions',RGB(255,255,255));
        end;
        '!howto':begin
            WriteConsole(ID,'Most commands in Mission Mod are console and not chat commands.',RGB(255,255,255));
            WriteConsole(ID,'Console commands begin with a slash: /char',RGB(255,255,255));
            WriteConsole(ID,'To open the console, press / instead of T and then enter the command.',RGB(255,255,255));
            WriteConsole(ID,'Do not open chat with T to enter a command, simply press /.',RGB(255,255,255));
        end;
        '!fixcommands':begin
    	    disablecommands := false;
            WriteConsole(0,'Commands enabled.',RGB(255,255,255));
        end;
        

	   '!irc' : begin
	        WriteConsole(ID,'Join us at #soldat.inc at quakenet',RGB(255,255,255));
	    end;
	    '!restart' : begin
	        restartMission(ID);
	    end;
        '!currentmaps' : begin
            loopamount := calcMaxMap();
            if(loopamount > maxmap) then
            begin
                loopamount := maxmap;
            end;
            mapstring := '';
        writeConsole(ID, 'Current Maps:', RGB(255,255,255));
            for loop := 1 to loopamount do
            begin
                 mapstring := mapstring + maplist[loop] + ' ';
                 if((loop mod 4) = 0) then
                 begin
                    writeConsole(ID, mapstring, RGB(255,255,255));
                    mapstring := '';
                 end;
            end;
            if(mapstring <> '') then
            begin
                writeConsole(ID, mapstring, RGB(255,255,255));
            end;
	    end
     end;
  end;
end;
function OnCommand(ID: Byte; Text: string): boolean;
var
    level : integer;
    element : array of string;
begin
	element := Explode(copy(Text,1, Length(Text)), ' ');

	case lowercase(element[0]) of
        
        '/setmission' : begin
			
			if(GetArrayLength(element) > 1) then
			begin
				level := strtoint(element[1]);
				if(level > 1) and (level <= maxmap) then
				begin
					cmap:= level;
					disablecommands := true;
					command('/map ' + maplist[cmap]);
				end;
			end;
			
        end;				
        
    end;
    Result:= false;

end;
function OnPlayerCommand(ID: Byte; Text: string): boolean; 
var
    i : integer;
    count : integer;
    //element: TStringArray;
    element : array of string;
begin
    if(disableCommands) then
    begin
        WriteConsole(ID, 'Commands are disabled while loading map data please try again shortly', RGB(255,0,0));
        exit;
    end;
//    element:=xsplit(text,' ');
    element := Explode(copy(Text,1, Length(Text)), ' ');
    //if(debug) then
    //begin
	   //writeLnFile('debuglog.txt',FormatDate('hh:nn:ss am/pm')+':cmd:'+IDToName(ID)+':'+Text);
   // end;
    // Account-related
	case lowercase(element[0]) of
        '/spreetop' : begin
            printTopListToPlayer(ID);
        end;
	    '/resetaccount' : ResetAccount(ID);
        '/allchars' : begin
            WriteConsole(ID,'Chars: ',RGB(255,122,0));
            for count := 1 to 32 do
            begin
                if GetPlayerStat(count,'Team') = ALPHA then
                begin
				    WriteConsole(ID,getSpeciality(mission_soldier[count].spec) + ' ' +IDToName(count) + ' at Level: ' + IntToStr(mission_soldier[count].level),RGB(255,122,0));
                end;
            end;
  	     end;
        '/char' : begin
			if GetPlayerStat(ID,'Team') = ALPHA then
            begin				
                WriteConsole(ID,'You are level '+IntToStr(mission_soldier[ID].level),RGB(255,122,0));
			    WriteConsole(ID,'XP: '+FloatToStr(roundto(mission_soldier[ID].xp,0))+'/'+FloatToStr(roundto(mission_soldier[ID].maxXP,0))+' ('+FloatToStr(RoundTo(mission_soldier[ID].xp/mission_soldier[ID].maxXP*100,0))+'%)',RGB(255,122,0));
			    WriteConsole(ID,'Your speciality is '+getSpeciality(mission_soldier[ID].spec),RGB(255,122,0));
            end
			else
            begin
                WriteConsole(ID,'You need to be playing to use this feature',RGB(255,122,0));
            end;
  	     end;
        '/classes' : begin
			if GetPlayerStat(ID,'Team') = ALPHA then
            begin
				WriteConsole(ID,'Classes: ',RGB(255,122,0));
				WriteConsole(ID,'Commando: Specialized in covert killing and behind the lines infiltration ',RGB(255,122,0));
				WriteConsole(ID,'Artillery: Specializes in explosives and explosive weapons ',RGB(255,122,0));
				WriteConsole(ID,'Marine: Highly trained Infantry ',RGB(255,122,0));
                WriteConsole(ID,'Assault: Heavy Infantry ',RGB(255,122,0));
            end
			else
            begin
                WriteConsole(ID,'You need to be playing to use this feature',RGB(255,122,0));
            end;
  	     end;
         '/credits' : begin
			WriteConsole(ID,'Credits: ',RGB(255,122,0));
			WriteConsole(ID,'Some Code/Ideas borrowed from Danmers Zombie script and Avarax Trenchwar/Miracle Mod',RGB(255,122,0));
            WriteConsole(ID,'Explode function from DorkeyDear',RGB(255,122,0));
            WriteConsole(ID,'Other ideas from Norbo,Gizd,Sandman',RGB(255,122,0));
  	     end;
         '/mission' : begin
			if GetPlayerStat(ID,'Team') = ALPHA then
            begin
                WriteConsole(ID, 'Mission: ' + mission.name,RGB(255,122,0));
                WriteConsole(ID, 'Objective: ' + mission.text,RGB(255,122,0));
            end
			else
            begin
                WriteConsole(ID,'You need to be playing to use this feature',RGB(255,122,0));
            end;
  	     end;

        '/class' : begin
			if GetPlayerStat(ID,'Team') = ALPHA then
			begin
				if(GetArrayLength(element) > 1) then
				begin
					if(mission_soldier[ID].level >= 5) then
					begin
						if(mission_soldier[ID].spec = 0) then
						begin
							case lowercase(element[1]) of
							'commando' : setWeaponSpec(ID, COMMANDO);
							'artillery' : setWeaponSpec(ID, ARTILLERY);
							'marine' : setWeaponSpec(ID, MARINE);
							'assault' : setWeaponSpec(ID, ASSAULT);
							end;
							WriteConsole(ID,'Your speciality is now: '+ getSpeciality(mission_soldier[ID].spec),RGB(255,122,0));
						end
						else
						begin
							WriteConsole(ID,'You already have a speciality: '+ getSpeciality(mission_soldier[ID].spec),RGB(255,122,0));
						end;
					end
					else
					begin
						WriteConsole(ID,'You need to be level 5 or higher to choose a class',RGB(255,122,0));
					end;
				end;
			end
			else
			begin
				WriteConsole(ID,'You need to be playing to use this feature',RGB(255,122,0));
			
			end;
        end;				
        '/hud' : begin
            if(mission_soldier[ID].hud) then
            begin
                WriteConsole(ID,'HUD Turned OFF!',RGB(255,122,0));
                mission_soldier[ID].hud := false;
            end
            else
            begin
                WriteConsole(ID,'HUD Turned ON!',RGB(255,122,0));
                mission_soldier[ID].hud := true;
            end;
        end;
        // Skills
        '/skills' : Skills(ID);
        '/flamer' : performFlamer(ID);
        '/rage' : performRage(ID);
        '/stealth' : performStealth(ID);
        '/nuke' : performNuke(ID);
        '/bio' : performBio(ID);
        '/bomb' : performBomb(ID);
        '/reinforce1' : performTele1(ID);
        '/reinforce2' : performTele2(ID);
        // Skill aliases
        '/skill1' : begin
            case mission_soldier[ID].spec of
                ARTILLERY : performBomb(ID);
                MARINE : performFlamer(ID);
                COMMANDO : performStealth(ID);
                ASSAULT : performRage(ID);
            end;
        end;
        '/skill2' : begin
            case mission_soldier[ID].spec of
                ARTILLERY : performNuke(ID);
                MARINE : performBio(ID);
                COMMANDO : performStealth(ID);
                ASSAULT : performRage(ID);
            end;
        end;
        '/skill3' : performTele1(ID);
        '/skill4' : performTele2(ID);
        // help
        '/help' : Help(ID);
        '/commands' : Help(ID);
    end;
    Result:= false;
end;
