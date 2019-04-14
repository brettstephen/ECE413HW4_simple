function [output] = ringmod(constants,inSound,inputFreq,depth)
%RINGMOD applies ring modulator effect to inSound
fs = constants.fs;
t = 0:1/fs:length(inSound)/fs-1/fs;
output = [depth.*cos(inputFreq*t).'.*inSound(:,1) depth.*cos(inputFreq*t).'.*inSound(:,2)];