function [output] = tremolo(constants,inSound,LFO_type,LFO_rate,lag,depth)
%TREMOLO applies a stereo tremelo effect to inSound by multiplying the
%signal by a low frequency oscillator specified by LFO_type and LFO_rate. 
% depth determines the prevalence of the tremeloed signal in the output,
% and lag determines the delay between the left and right tracks. 
fs = constants.fs;

t = 0:1/fs:length(inSound)/fs-1/fs;
switch LFO_type
    case 'sin'
        mod_signal = [depth*cos(2*pi*LFO_rate*t).' depth*cos(2*pi*LFO_rate*t-lag/fs).'];
    case 'square'
        mod_signal = depth*square(2*pi*LFO_rate*t-lag);
     case 'sawtooth'
        mod_signal = depth*sawtooth(2*pi*LFO_rate*t-lag);
end
output = mod_signal.*inSound;