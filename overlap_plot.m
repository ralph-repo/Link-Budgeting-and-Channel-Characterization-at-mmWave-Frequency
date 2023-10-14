clc
clear all; close all;
% loading h matrix file dataset file
filename='hmatrixfile.mat';
foldername1=['D:\NYUSIM_V31_WIN_package\project related ' ...
    'files\28Ghz rayleigh channel 10000 simrun without NAN final'];
foldername2=['D:\NYUSIM_V31_WIN_package\project related ' ...
    'files\28Ghz rayleigh channel 10000 simrun without NAN ' ...
    'final tx height 40 sep 100'];
% loading other h matrix dataset file
myfile1=fullfile(foldername1,filename);
load(myfile1);
% measuring size of h matrix loaded first
[r,c]=size(hf_freq);
for i=1:c
    A=[real(hf_freq(1,i)),imag(hf_freq(1,i))];
    % calculating resultant of complex data
    resultant(i)=sqrt(A(1,1)^2 + A(1,2)^2);
end
% normalizing the resultant
h_normalized=resultant/(sqrt(var(resultant)));
% plotting its histogram
figure(1);
h = histogram(h_normalized,50);
p = histcounts(h_normalized,50,'Normalization','pdf');
% plot its pdf using corresponding bins
figure(2);
binCenters = h.BinEdges + (h.BinWidth/2);
plot(binCenters(1:end-1), p, 'r-')
xlabel('instantaneous value of the resultant amplitude');
ylabel('probability');
title('pdf of h(t)');
hold on
% plotting proof of randomness in channel
figure(3);
plot(10*log10(h_normalized(1:100)));
xlabel('normalised amplitude of channel output');
ylabel('instantaneuos time');
title('randomness in channel from one time instant to other');
hold on

myfile2=fullfile(foldername2,filename);
load(myfile2);
% measuring size of h matrix loaded after the first one
[r,c]=size(hf_freq);
for i=1:c
    A=[real(hf_freq(1,i)),imag(hf_freq(1,i))];
    % calculating resultant of second h matrix
    resultant(i)=sqrt(A(1,1)^2 + A(1,2)^2);
end
% normalizing the resultant
h_normalized=resultant/(sqrt(var(resultant)));
% potting its histogram
figure(4);
h = histogram(h_normalized,50);
p = histcounts(h_normalized,50,'Normalization','pdf');
% plot its pdf over the first plot
binCenters = h.BinEdges + (h.BinWidth/2);
figure(2);
plot(binCenters(1:end-1), p, 'b-')
% plotting proof of randomness over the first plot
figure(3);
plot(10*log10(h_normalized(1:100)));