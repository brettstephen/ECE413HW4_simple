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
LFO = round((0.5*width*sin(2*pi*LFO_Rate*t) + delay + width/2)*fs);

de = [zeros(delay_min,size(inSound,2)); inSound];
soundOut = NaN(size(inSound));
for ii = 1:length(inSound)
    
    if ii+LFO(ii)-delay_min <= length(inSound)
        %inSound(ii+1,:) = inSound(ii+1,:) + feedback*output(ii,:);
        %delay = [zeros(delay_time*fs,size(inSound,2)); inSound];
        %de(ii+1+LFO(ii+1),:) = de(ii+1+LFO(ii+1),:) + feedback*de(ii+1,:);
        soundOut(ii,:) = inSound(ii,:) + depth*de(ii+LFO(ii)-delay_min,:);
    else
        soundOut(ii,:) = inSound(ii,:);
    end
end