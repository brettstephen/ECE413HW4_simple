function [output]=delay(constants,inSound,depth,delay_time,feedback)
%DELAY applies a delay effect to inSound which is delayed by delay_time 
% then added to the original signal according to depth and passed back as
% feedback with the feedback gain specified
fs = constants.fs;

delay = [zeros(delay_time*fs,size(inSound,2)); inSound];
output = NaN(size(inSound));
for ii = 1:length(inSound)
    output(ii,:) = inSound(ii,:) + depth*delay(ii,:);
    if ii ~= length(inSound)
        %inSound(ii+1,:) = inSound(ii+1,:) + feedback*output(ii,:);
        %delay = [zeros(delay_time*fs,size(inSound,2)); inSound];
        delay(ii+1+delay_time*fs,:) = delay(ii+1+delay_time*fs,:) + feedback*delay(ii+1,:);
    end
end