function [soundOut,gain,block_power] = compressor(constants,inSound,threshold,slope,attack,avg_len)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [output,gain] = compressor(constants,inSound,threshold,attack,avg_len)
%
%COMPRESSOR applies variable gain to the inSound vector by limiting the
% level of any audio sample of avg_length with rms power greater than
% threshold according to slope
%
% OUTPUTS
%   soundOut    = The output sound vector
%   gain        = The vector of gains applied to inSound to create soundOut
%
% INPUTS
%   constants   = the constants structure
%   inSound     = The input audio vector
%   threshold   = The level setting to switch between the two gain settings
%   attack      = time over which the gain changes
%   avg_len     = amount of time to average over for the power measurement

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load constants
fs = constants.fs;

gain = ones(size(inSound));
sound = [zeros(avg_len-1,size(inSound,2)).' inSound.'].';
block_power = zeros(round((length(inSound)-avg_len)/(attack*fs)),1);

for jj = 0:round((length(inSound)-avg_len)/(attack*fs))-1
    ii = int64(jj*attack*fs + avg_len);
    block_power(jj+1) = rms(sound(ii-avg_len+1:ii));
    if block_power(jj+1)
        next_gain = transfer(block_power(jj+1),threshold,slope)/block_power(jj+1);
    elseif ~block_power(jj+1)
        next_gain = 1;
    end
    
    %gain_trans = repmat(linspace(1,next_gain(jj+1),attack*fs).',1,size(inSound,2));
    gain(ii-avg_len+1:ii) = gain(ii-avg_len+1:ii)*next_gain;
    sound(avg_len:end) = sound(avg_len:end).*gain; 
end

soundOut = inSound.*gain;
end

function out_level = transfer(in_power,threshold,slope)
    if in_power <= threshold
        out_level = in_power;
    elseif in_power > threshold
        out_level = threshold + slope*(in_power-threshold); 
    end
end