function [output]=distortion(constants,inSound,gain,tone)
%DISTORTION applies the specified gain to inSound, then applies clipping
%according to internal parameters and filtering according to the specified
%tone parameter

fs = constants.fs;

filtertype = 'FIR';
Fpass = 0.5*tone*fs;
steepness = 0.51;
W = (1-steepness)*Fpass;
Fstop = Fpass + W;
Astop = 60;
HPF = dsp.LowpassFilter('SampleRate',fs,...
                             'FilterType',filtertype,...
                             'PassbandFrequency',Fpass,...
                             'StopbandFrequency',Fstop,...
                             'StopbandAttenuation',Astop);
                         
output = HPF(transfer(inSound,gain));
output = output/max(output);
end

function out = transfer(in,gain)
logistic = @(x) exp(x) ./ (1 + exp(x));
out = NaN(size(in));
for jj = 1:size(in,2)
    for ii = 1:length(in)
        if in(ii,jj) <= 0
            out(ii,jj) = logistic(in(ii,jj)*2*gain) - 0.5;
        elseif in(ii,jj) > 0
            out(ii,jj) = (2*logistic(in(ii,jj)*2*gain) - 0.5)/1.5;
        end
    end
end

end