function [output] = tremolo(constants,inSound,LFO_type,LFO_rate,lag,depth)
%TREMOLO applies a stereo tremelo effect to inSound by multiplying the
%signal by a low frequency oscillator specified by LFO_type and LFO_rate. 
% depth determines the prevalence of the tremeloed signal in the output,
% and lag determines the delay between the left and right tracks. 
