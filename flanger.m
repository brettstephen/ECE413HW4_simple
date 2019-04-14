function [soundOut]=flanger(constants,inSound,depth,delay,width,LFO_Rate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [soundOut]=flanger(constants,inSound,depth,delay,width,LFO_Rate)
%
% This function creates the sound output from the flanger effect
%
% OUTPUTS
%   soundOut = The output sound vector
%
% INPUTS
%   constants   = the constants structure
%   inSound     = The input audio vector
%   depth       = depth setting in seconds
%   delay       = minimum time delay in seconds
%   width       = total variation of the time delay from the minimum to the maximum
%   LFO_Rate    = The frequency of the Low Frequency oscillator in Hz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fs = constants.fs;

delay_min = delay*fs;
delay_max = (delay + width)*fs;

t = 0:1/fs:length(inSound)/fs-1/fs;
LFO = round((0.5*width*sin(2*pi*LFO_rate*t) + delay + width/2)*fs);

de = [zeros(delay_min,size(inSound,2)); inSound];
output = NaN(size(inSound));
for ii = 1:length(inSound)
    output(ii,:) = inSound(ii,:) + depth*delay(ii,:);
    if ii ~= length(inSound)
        %inSound(ii+1,:) = inSound(ii+1,:) + feedback*output(ii,:);
        %delay = [zeros(delay_time*fs,size(inSound,2)); inSound];
        delay(ii+1+delay_time*fs,:) = delay(ii+1+delay_time*fs,:) + feedback*delay(ii+1,:);
    end
end