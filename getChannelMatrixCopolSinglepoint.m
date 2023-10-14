clc
clear all; close all; tic
load('BasicParameters.mat'); % load the output data file containing the basic channel parameters
f = BasicParameters.Frequency; % center carrier frequency
RFBW = BasicParameters.Bandwidth; % RF bandwidth
Nt = BasicParameters.NumberOfTxAntenna; % number of transmit antenna elements
Nr = BasicParameters.NumberOfRxAntenna; % number of receive antenna elements
dTxAnt = BasicParameters.TxAntennaSpacing; % spacing between adjacent transmit antenna 
%   elements with respect to the wavelength
dRxAnt = BasicParameters.RxAntennaSpacing; % spacing between adjacent receive antenna 
%   initialising path for the genereated dataset
filename='dirpdpnewsimulation.mat';
foldername='D:\NYUSIM_V31_WIN_package\NYUSIM Base Code';
myfile=fullfile(foldername,filename);
load(myfile); % load the output data file containing the channel impulse response parameters

% Remove NaN lines
nanInd = isnan(dirpdp_contentnew(:,3));
dirpdp_contentnew(nanInd,:) = [];

% Find the unique simulation number to obtain the channel matrix for each of
% the TX-RX location pairs
SimNum = unique(dirpdp_contentnew(:,1));
% find the phase for particular arriving ray from column 5
phase_dis=dirpdp_contentnew(:,5);
j = sqrt(-1);
f_sub = f; 
Hf_pvs = cell(length(f_sub),length(SimNum)); 
% initialising matrix variable
A={};
for id = 1:length(SimNum)
    clear Idx; Idx = find(dirpdp_contentnew(:,1)==SimNum(id));
    for q = 1:length(f_sub)
        Hf_temp = zeros(Nr,Nt);
        for w = 1:Nr
            for y = 1:Nt
            % using saleh-valenzuela channel model
            Hf_temp(w,y) = sum(sqrt(10.^(dirpdp_contentnew(Idx,4)./10)) ...
                .*exp(1i.*dirpdp_contentnew(Idx,5)));
            % appending to A 
            A = [A; Hf_temp];
            end
        end
    Hf_pvs{q,id} = Hf_temp;
    end
end
% converting from cell to matrix format
Hf_time=cell2mat(Hf_pvs);
% inverting the operation done in line 42 of phase multiplication
hf_freq=fft(Hf_time);
% saving the hmatrix and phase data of arriving rays
save('hmatrixfile.mat', 'hf_freq');
save('phase_dis.mat', 'phase_dis');
toc