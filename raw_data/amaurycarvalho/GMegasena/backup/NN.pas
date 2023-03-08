unit NN;

{$MODE Delphi}

interface

uses SysUtils, Classes, Math;

type TNNActivationFunction = (LogisticSigmoid, HyperbolicTangent, Hybrid);

type TNNMLP = class
        private
                HiddenLayerSumData: array of double;
                HiddenLayerErrorData: array of double;
                HiddenLayerOutputData: array of double;
                HiddenLayerWeightData: array of array of double;
                HiddenLayerBiasData: array of array of double;

                OutputLayerSumData: array of double;
                OutputLayerWeightData: array of array of double;
                OutputLayerBiasData: array of array of double;
                OutputLayerDestData: array of double;

                InputLayerNormalizedData: array of double;
                InputLayerNormalizeMin: array of double;
                InputLayerNormalizeMax: array of double;

                OutputLayerNormalizedData: array of double;
                OutputLayerNormalizeMin: array of double;
                OutputLayerNormalizeMax: array of double;

                LearnNormalizeResetInput : boolean;
                LearnNormalizeResetOutput : boolean;

                RandomLearnIndex: array of array of integer;

                procedure Init();

                procedure NormalizeInput();
                procedure DenormalizeOutput();

                function RenormalizeInput(learn, i : integer):boolean;
                function RenormalizeOutput(learn, o : integer):boolean;

                procedure PropagateError();
                procedure AdjustWeights();

        public
                InputLayerData: array of double;
                OutputLayerData: array of double;
                OutputLayerErrorData: array of double;

                LearningRate: double;
                LearningEpoques: integer;
                LearningMinErr: double;
                LearningNormalizeFactorMax: double;
                LearningNormalizeFactorMin: double;
                Learned: boolean;
                ActivationFunction: TNNActivationFunction;

                InputLayerSize, HiddenLayerSize, OutputLayerSize: integer;
                LearningDataSize: integer;

                LearningInputData: array of array of double;
                LearningOutputData: array of array of double;

                constructor Create(pInputLayerSize, pHiddenLayerSize, pOutputLayerSize: integer);
                procedure SetLearningDataSize(pLearningDataSize: integer);
                procedure LoadLearningInputData(learnIndex : integer);

                procedure Reset();
                procedure Learn();
                procedure Think();

                procedure SetNet(snet : TStringList);
                function GetNet(): TStringList;

end;

implementation

        function IsNAN(CONST d: DOUBLE): BOOLEAN;
        var
            Overlay: Int64 ABSOLUTE d;
        begin
          RESULT :=
              ((Overlay AND $7FF0000000000000)  = $7FF0000000000000) AND
              ((Overlay AND $000FFFFFFFFFFFFF) <> $0000000000000000)
        end;

        function IsInfinity(CONST d: DOUBLE): BOOLEAN;
        var
            Overlay: Int64 ABSOLUTE d;
        begin
          RESULT :=
              ((Overlay AND $7FF0000000000000) = $7FF0000000000000) AND
              ((Overlay AND $000FFFFFFFFFFFFF) = $0000000000000000)
        end;

        constructor TNNMLP.Create(pInputLayerSize, pHiddenLayerSize, pOutputLayerSize: integer);
        begin
                Randomize;

                InputLayerSize := pInputLayerSize;
                HiddenLayerSize := pHiddenLayerSize;
                OutputLayerSize := pOutputLayerSize;

                if(InputLayerSize = 1) then
                        LearningRate := 0.9
                else
                        LearningRate := 1.0/(InputLayerSize*InputLayerSize);

                LearningEpoques := 1;
                LearningMinErr := 0.0001;
                LearningNormalizeFactorMax := 4;
                LearningNormalizeFactorMin := 0.5;
                ActivationFunction := LogisticSigmoid;

                LearnNormalizeResetInput := true;
                LearnNormalizeResetOutput := true;

                Init;
        end;

        procedure TNNMLP.Init();
        begin
                SetLength(InputLayerData, InputLayerSize);
                SetLength(OutputLayerData, OutputLayerSize);

                SetLength(HiddenLayerSumData, HiddenLayerSize);
                SetLength(HiddenLayerErrorData, HiddenLayerSize);
                SetLength(HiddenLayerOutputData, HiddenLayerSize);
                SetLength(HiddenLayerWeightData, HiddenLayerSize, InputLayerSize);
                SetLength(HiddenLayerBiasData, HiddenLayerSize, InputLayerSize);

                SetLength(OutputLayerSumData, OutputLayerSize);
                SetLength(OutputLayerDestData, OutputLayerSize);
                SetLength(OutputLayerErrorData, OutputLayerSize);
                SetLength(OutputLayerWeightData, OutputLayerSize, HiddenLayerSize);
                SetLength(OutputLayerBiasData, OutputLayerSize, HiddenLayerSize);

                SetLength(InputLayerNormalizedData, InputLayerSize);
                SetLength(InputLayerNormalizeMin, InputLayerSize);
                SetLength(InputLayerNormalizeMax, InputLayerSize);

                SetLength(OutputLayerNormalizedData, OutputLayerSize);
                SetLength(OutputLayerNormalizeMin, InputLayerSize);
                SetLength(OutputLayerNormalizeMax, InputLayerSize);

                SetLearningDataSize(1);

                Reset();
        end;

        procedure TNNMLP.SetLearningDataSize(pLearningDataSize: integer);
        var     n, f, k : integer;
        begin
                LearningDataSize := pLearningDataSize;

                SetLength(LearningInputData, LearningDataSize, InputLayerSize);
                SetLength(LearningOutputData, LearningDataSize, OutputLayerSize);

                SetLength(RandomLearnIndex, 5, LearningDataSize);

                // normal / inverse order
                f := LearningDataSize-1;
                for n := 0 to f do
                begin
                        RandomLearnIndex[0, n] := n;
                        RandomLearnIndex[2, n] := f - n;
                end;

                // odd / pair order
                k := 0;
                for n := 0 to f do
                begin
                        if (n mod 2) = 0 then
                                RandomLearnIndex[1, k] := n
                        else
                        begin
                                RandomLearnIndex[3, k] := n;
                                k := k + 1;
                        end;
                end;
                for n := 0 to f do
                begin
                        if k <= f then
                                if (n mod 2) = 0 then
                                        RandomLearnIndex[3, k] := n
                                else
                                begin
                                        RandomLearnIndex[1, k] := n;
                                        k := k + 1;
                                end;
                end;

                // alternate
                k := 0;
                for n := 0 to f do
                begin
                        if (n mod 2) = 0 then
                                RandomLearnIndex[4, n] := k
                        else
                        begin
                                RandomLearnIndex[4, n] := f - k;
                                k := k + 1;
                        end;
                end;

        end;

        procedure TNNMLP.Reset();
        var     h, i, o : integer;
        begin
                Learned := false;
                LearnNormalizeResetInput := true;
                LearnNormalizeResetOutput := true;

                // generate random sinapsis weight and bias
                for h := 0 to HiddenLayerSize-1 do
                begin
                        for i := 0 to InputLayerSize-1 do
                        begin
                                HiddenLayerWeightData[h, i] := random * 0.8 + 0.1;
                                HiddenLayerBiasData[h, i] := 0; //random * 0.1;
                        end;
                end;
                for o := 0 to OutputLayerSize-1 do
                begin
                        for h := 0 to HiddenLayerSize-1 do
                        begin
                                OutputLayerWeightData[o, h] := random * 0.8 + 0.1;
                                OutputLayerBiasData[o, h] := 0; //random * 0.1;
                        end;
                end;
                for i := 0 to InputLayerSize-1 do
                begin
                        InputLayerNormalizeMin[i] := infinity;
                        InputLayerNormalizeMax[i] := -infinity;
                end;
                for o := 0 to OutputLayerSize-1 do
                begin
                        OutputLayerNormalizeMin[o] := infinity;
                        OutputLayerNormalizeMax[o] := -infinity;
                end;
        end;

        procedure TNNMLP.Learn();
        var     i, o : integer;
                epoque, learn, rl, lx : integer;
                finish : boolean;
        begin
                finish := false;
                rl := 0;

                // do epoques
                for epoque := 0 to LearningEpoques-1 do
                begin
                        finish := true;
                        for lx := 0 to LearningDataSize-1 do
                        begin
                                learn := RandomLearnIndex[rl, lx];
                                for i := 0 to InputLayerSize-1 do
                                begin
                                        if (RenormalizeInput(learn, i)) then
                                            finish := false;
                                        InputLayerData[i] := LearningInputData[learn, i];
                                end;
                                for o := 0 to OutputLayerSize-1 do
                                begin
                                        if (RenormalizeOutput(learn, o)) then
                                            finish := false;
                                        OutputLayerDestData[o] := (LearningOutputData[learn, o] - OutputLayerNormalizeMin[o]) / (OutputLayerNormalizeMax[o] - OutputLayerNormalizeMin[o]);
                                end;
                                Think();
                                PropagateError();
                                AdjustWeights();
                        end;
                        for o := 0 to OutputLayerSize-1 do
                        begin
                                finish := finish And ((OutputLayerErrorData[o] >= -LearningMinErr) And (OutputLayerErrorData[o] <= LearningMinErr));
                                if (not finish) then break;
                        end;
                        if (finish) then break;
                        rl := rl + 1;
                        if rl > 4 then
                                rl := 0;
                end;

                Learned := finish;
        end;

        procedure TNNMLP.LoadLearningInputData(learnIndex : integer);
        var i, j : integer;
        begin
             if learnIndex < LearningDataSize then
                for i := 0 to InputLayerSize-1 do
                    InputLayerData[i] := LearningInputData[learnIndex, i];
        end;

        procedure TNNMLP.Think();
        var h, i, o : integer;
        begin
                NormalizeInput;
                for h := 0 to HiddenLayerSize-1 do
                begin
                        HiddenLayerSumData[h] := 0;
                        for i := 0 to InputLayerSize-1 do
                        begin
                                HiddenLayerSumData[h] := HiddenLayerSumData[h] + ((HiddenLayerWeightData[h, i] * InputLayerNormalizedData[i]) + HiddenLayerBiasData[h, i]);
                        end;
                        Case ActivationFunction Of
                        LogisticSigmoid :
                                HiddenLayerOutputData[h] := 1.0 / (1.0 + exp(-HiddenLayerSumData[h]));
                        HyperbolicTangent, Hybrid:
                                HiddenLayerOutputData[h] := 1.716 * tanh(0.667 * HiddenLayerSumData[h]);
                        end;
                end;

                for o := 0 to OutputLayerSize-1 do
                begin
                        OutputLayerSumData[o] := 0;
                        for h := 0 to HiddenLayerSize-1 do
                        begin
                                OutputLayerSumData[o] := OutputLayerSumData[o] + ((OutputLayerWeightData[o, h] * HiddenLayerOutputData[h]) + OutputLayerBiasData[o, h]);
                        end;
                        Case ActivationFunction Of
                        LogisticSigmoid, Hybrid :
                                OutputLayerNormalizedData[o] := 1.0 / (1.0 + exp(-OutputLayerSumData[o]));
                        HyperbolicTangent:
                                OutputLayerNormalizedData[o] := 1.716 * tanh(0.667 * OutputLayerSumData[o]);
                        end;
                end;
                DenormalizeOutput;
        end;

        procedure TNNMLP.NormalizeInput();
        var i : integer;
        begin
                for i := 0 to InputLayerSize-1 do
                begin
                        InputLayerNormalizedData[i] := (InputLayerData[i] - InputLayerNormalizeMin[i]) / (InputLayerNormalizeMax[i] - InputLayerNormalizeMin[i]);
                        If ActivationFunction <> LogisticSigmoid then
                                InputLayerNormalizedData[i] := InputLayerNormalizedData[i] * 2 - 1;
                end;
        end;

        procedure TNNMLP.DenormalizeOutput();
        var     o : integer;
                n : double;
        begin
                for o := 0 to OutputLayerSize-1 do
                begin
                        n := OutputLayerNormalizedData[o];
                        if ActivationFunction = HyperbolicTangent then
                                n := (n+1)/2;
                        OutputLayerData[o] := (n * (OutputLayerNormalizeMax[o] - OutputLayerNormalizeMin[o])) + OutputLayerNormalizeMin[o];
                end;
        end;

        function TNNMLP.RenormalizeInput(learn, i : integer):boolean;
        var     //h : integer;
                //d : double;
                NewMax, NewMin : double;
                renormalize : boolean;
        begin
                renormalize := false;

                if LearnNormalizeResetInput then
                begin
                     NewMax := LearningInputData[learn, i] * LearningNormalizeFactorMax;
                     if NewMax = 0 then
                        NewMax := 1;
                     NewMin := LearningInputData[learn, i] * LearningNormalizeFactorMin;
                     LearnNormalizeResetInput := false;
                     renormalize := true;
                end
                else
                begin
                     NewMax := InputLayerNormalizeMax[i];
                     NewMin := InputLayerNormalizeMin[i];

                     if (LearningInputData[learn, i] > NewMax) then
                     begin
                        NewMax := LearningInputData[learn, i] * LearningNormalizeFactorMax;
                        if NewMax = 0 then
                           NewMax := 1;
                        renormalize := true;
                     end;
                     if (LearningInputData[learn, i] < NewMin) then
                     begin
                        NewMin := LearningInputData[learn, i] * LearningNormalizeFactorMin;
                        renormalize := true;
                     end;
                end;

                if (renormalize) then
                begin
                        {
                        d := (NewMax - NewMin) / (InputLayerNormalizeMax[i] - InputLayerNormalizeMin[i]);
                        for h := 0 to HiddenLayerSize-1 do
                        begin
                                HiddenLayerWeightData[h, i] := HiddenLayerWeightData[h, i] * d;
                        end;
                        }
                        InputLayerNormalizeMax[i] := NewMax;
                        InputLayerNormalizeMin[i] := NewMin;
                end;
                result := renormalize;
        end;

        function TNNMLP.RenormalizeOutput(learn, o : integer):boolean;
        var     //h : integer;
                //d : double;
                NewMax, NewMin : double;
                renormalize : boolean;
        begin
                renormalize := false;

                if LearnNormalizeResetOutput then
                begin
                     NewMax := LearningOutputData[learn, o] * LearningNormalizeFactorMax;
                     if NewMax = 0 then
                        NewMax := 1;
                     NewMin := LearningOutputData[learn, o] * LearningNormalizeFactorMin;
                     LearnNormalizeResetOutput := false;
                     renormalize := true;
                end
                else
                begin
                     NewMax := OutputLayerNormalizeMax[o];
                     NewMin := OutputLayerNormalizeMin[o];

                     if (LearningOutputData[learn, o] > NewMax) then
                     begin
                        NewMax := LearningOutputData[learn, o] * LearningNormalizeFactorMax;
                        if NewMax = 0 then
                           NewMax := 1;
                        renormalize := true;
                     end
                     else if (LearningOutputData[learn, o] < NewMin) then
                     begin
                        NewMin := LearningOutputData[learn, o] * LearningNormalizeFactorMin;
                        renormalize := true;
                     end;
                end;

                if (renormalize) then
                begin
                        {
                        d := (NewMax - NewMin) / (OutputLayerNormalizeMax[o] - OutputLayerNormalizeMin[o]);
                        for h := 0 to HiddenLayerSize-1 do
                        begin
                                OutputLayerWeightData[o, h] := OutputLayerWeightData[o, h] * d;
                                OutputLayerBiasData[o, h] := OutputLayerBiasData[o, h] * d;
                        end;
                        }
                        OutputLayerNormalizeMax[o] := NewMax;
                        OutputLayerNormalizeMin[o] := NewMin;
                end;
                result := renormalize;
        end;

        procedure TNNMLP.PropagateError();
        var     ddx : double;
                h, o : integer;
        begin
                ddx := 1;
                for o := 0 to OutputLayerSize-1 do
                begin
                        Case ActivationFunction Of
                        LogisticSigmoid, Hybrid :
                                ddx := OutputLayerNormalizedData[o] * (1.0 - OutputLayerNormalizedData[o]);  // logistic sigmoid curve derivate
                        HyperbolicTangent:
                                ddx := 0.388695 * (1.716 - OutputLayerNormalizedData[o]) * (1.716 + OutputLayerNormalizedData[o]); // hiperbolic tangent curve derivate
                        end;
                        OutputLayerErrorData[o] := ddx * (OutputLayerDestData[o] - OutputLayerNormalizedData[o]);
                end;
                for h := 0 to HiddenLayerSize-1 do
                begin
                        Case ActivationFunction Of
                        LogisticSigmoid :
                                ddx := HiddenLayerOutputData[h] * (1.0 - HiddenLayerOutputData[h]);   // logistic sigmoid curve derivate
                        HyperbolicTangent, Hybrid :
                                ddx := 0.388695 * (1.716 - HiddenLayerOutputData[h]) * (1.716 + HiddenLayerOutputData[h]); // hiperbolic tangent curve derivate
                        end;
                        HiddenLayerErrorData[h] := 0;
                        for o := 0 to OutputLayerSize-1 do
                        begin
                                HiddenLayerErrorData[h] := HiddenLayerErrorData[h] + (ddx * (OutputLayerErrorData[o] * OutputLayerWeightData[o, h]));
                        end;
                end;
        end;

        procedure TNNMLP.AdjustWeights();
        var     adj : double;
                h, o, i : integer;
        begin
                for h := 0 to HiddenLayerSize-1 do
                begin
                        adj := LearningRate * HiddenLayerErrorData[h];
                        for i := 0 to InputLayerSize-1 do
                        begin
                                HiddenLayerWeightData[h, i] := HiddenLayerWeightData[h, i] + (adj * InputLayerNormalizedData[i]);
                                HiddenLayerBiasData[h, i] := HiddenLayerBiasData[h, i] + adj;
                        end;
                end;
                for o := 0 to OutputLayerSize-1 do
                begin
                        adj := LearningRate * OutputLayerErrorData[o];
                        for h := 0 to HiddenLayerSize-1 do
                        begin
                                OutputLayerWeightData[o, h] := OutputLayerWeightData[o, h] + (adj * HiddenLayerOutputData[h]);
                                OutputLayerBiasData[o, h] := OutputLayerBiasData[o, h] + adj;
                        end;
                end;
        end;

        procedure TNNMLP.SetNet(snet:TStringList);
        var     h, i, o, k : integer;
        begin

                if (snet <> nil) then
                begin
                        if(snet.Count > 3) then
                        begin
                                InputLayerSize := StrToInt(snet[0]);
                                HiddenLayerSize:= StrToInt(snet[1]);
                                OutputLayerSize:= StrToInt(snet[2]);

                                Init;

                                if snet[3] = '0' then
                                    ActivationFunction := LogisticSigmoid
                                else if snet[3] = '1' then
                                    ActivationFunction := HyperbolicTangent
                                else if snet[3] = '2' then
                                    ActivationFunction := Hybrid;

                                k := 4;

                                // hidden layer

                                for h := 0 to HiddenLayerSize-1 do
                                        for i := 0 to InputLayerSize-1 do
                                        begin
                                                HiddenLayerWeightData[h, i] := StrToFloat(snet[k]);
                                                k := k + 1;
                                                HiddenLayerBiasData[h, i] := StrToFloat(snet[k]);
                                                k := k + 1;
                                        end;

                                // output layer

                                for o := 0 to OutputLayerSize-1 do
                                        for h := 0 to HiddenLayerSize-1 do
                                        begin
                                                OutputLayerWeightData[o, h] := StrToFloat(snet[k]);
                                                k := k + 1;
                                                OutputLayerBiasData[o, h] := StrToFloat(snet[k]);
                                                k := k + 1;
                                        end;

                                // normalizer layer

                                for i := 0 to InputLayerSize-1 do
                                begin
                                     if snet[k] = '-INF' then
                                        InputLayerNormalizeMin[i] := -Infinity
                                     else
                                        InputLayerNormalizeMin[i] := StrToFloat(snet[k]);
                                     k := k + 1;
                                     if snet[k] = '+INF' then
                                        InputLayerNormalizeMax[i] := Infinity
                                     else
                                        InputLayerNormalizeMax[i] := StrToFloat(snet[k]);
                                     k := k + 1;
                                end;
                                for o := 0 to OutputLayerSize-1 do
                                begin
                                     if snet[k] = '-INF' then
                                        OutputLayerNormalizeMin[o] := -Infinity
                                     else
                                        OutputLayerNormalizeMin[o] := StrToFloat(snet[k]);
                                     k := k + 1;
                                     if snet[k] = '+INF' then
                                        OutputLayerNormalizeMax[o] := Infinity
                                     else
                                        OutputLayerNormalizeMax[o] := StrToFloat(snet[k]);
                                     k := k + 1;
                                end;

                        end;
                end;

        end;

        function TNNMLP.GetNet(): TStringList;
        var     snet : TStringList;
                h, i, o : integer;
        begin
                snet := TStringList.Create;

                snet.Add(IntToStr(InputLayerSize));
                snet.Add(IntToStr(HiddenLayerSize));
                snet.Add(IntToStr(OutputLayerSize));

                case ActivationFunction of
                LogisticSigmoid :
                    snet.Add('0');
                HyperbolicTangent :
                    snet.Add('1');
                Hybrid :
                    snet.Add('2');
                end;

                // hidden layer

                for h := 0 to HiddenLayerSize-1 do
                        for i := 0 to InputLayerSize-1 do
                        begin
                                snet.Add(FloatToStr(HiddenLayerWeightData[h, i]));
                                snet.Add(FloatToStr(HiddenLayerBiasData[h, i]));
                        end;

                // output layer

                for o := 0 to OutputLayerSize-1 do
                        for h := 0 to HiddenLayerSize-1 do
                        begin
                                snet.Add(FloatToStr(OutputLayerWeightData[o, h]));
                                snet.Add(FloatToStr(OutputLayerBiasData[o, h]));
                        end;

                // normalizer layer

                for i := 0 to InputLayerSize-1 do
                begin
                     if IsInfinity(InputLayerNormalizeMin[i]) then
                        snet.Add('-INF')
                     else
                        snet.Add(FloatToStr(InputLayerNormalizeMin[i]));
                     if IsInfinity(InputLayerNormalizeMax[i]) then
                        snet.Add('+INF')
                     else
                        snet.Add(FloatToStr(InputLayerNormalizeMax[i]));
                end;
                for o := 0 to OutputLayerSize-1 do
                begin
                     if IsInfinity(OutputLayerNormalizeMin[o]) then
                        snet.Add('-INF')
                     else
                        snet.Add(FloatToStr(OutputLayerNormalizeMin[o]));
                     if IsInfinity(OutputLayerNormalizeMax[o]) then
                        snet.Add('+INF')
                     else
                        snet.Add(FloatToStr(OutputLayerNormalizeMax[o]));
                end;

                result := snet;
        end;

end.
