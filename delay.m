function [output]=delay(constants,inSound,depth,delay_time,feedback)
%DELAY applies a delay effect to inSound which is delayed by delay_time 
% then added to the original signal according to depth and passed back as
% feedback with the feedback gain specified

