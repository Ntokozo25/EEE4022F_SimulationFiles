load pvLoadPriceData2.mat;

Fuzzy_BESS = readfis('Fuzzy_BESS.fis');
Fuzzy_PCC_Load = readfis('Fuzzy_PCC_Load.fis');

% Display basic info about the loaded FIS
disp(Fuzzy_EMS);
disp(Fuzzy_PCC);

%load pvLoadTariffData.mat;
costDataOffset = costData2;
%gridPriceOffset = gridPrice + 0;

% Microgrid Settings
panelArea = 2000;   % Area of PV Array [m^2]
panelEff = 0.18;     % Efficiency of Array
%loadBase = 350e3;   % Base Load of Microgrid [W]
loadBase = 0;   % Base Load of Microgrid [W]

BattCap = 3000;     % Energy Storage Rated Capacity [kWh]
batteryMinMax.Pmin = -400e3;    % Max Discharge Rate [W]
batteryMinMax.Pmax = 400e3;     % Max Charge Rate [W]

% Online optimization parameters
FinalWeight = 1;    % Final weight on energy storage
timeOptimize = 30;    % Time step for optimization [min]
timePred = 20;        % Predict ahead horizon [hours]

% Compute PV Array Power Output
clearPpv = panelArea*panelEff*pvProfile;

% Select Load Profile
loadSelect = 3;
loadFluc = loadData(:,loadSelect);

% Battery SOC Energy constraints (keep between 30%-90% SOC)
battEnergy = 3.6e6*BattCap;
batteryMinMax.Emax = 0.9*battEnergy;
batteryMinMax.Emin = 0.3*battEnergy;

% Setup Optimization time vector
optTime = timeOptimize*60;
stepAdjust = (timeOptimize*60)/(time(2)-time(1));
N = numel(time(1:stepAdjust:end))-1;
tvec = (1:N)'*optTime;


%Clean up unneeded Variables
clear clearDay cloudyDay BattCap panelArea panelEff loadBase;
clear M N i loadSelect stepAdjust timeOptimize;
clear batteryMinMax timePred tvec loadData loadDataOpt FinalWeight