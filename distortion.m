function [output]=distortion(constants,inSound,gain,tone)
%DISTORTION applies the specified gain to inSound, then applies clipping
%according to internal parameters and filtering according to the specified
%tone parameter
%plot(-3:0.01:0,0.5*(exp(-3:0.01:0)-1))

%plot(-3:0.01:3,[logistic((-3:0.01:0)*2)-0.5 2*(logistic((0.01:0.01:3)*2)-0.5)])
fs = constants.fs;

sound = inSound*gain;
output = transfer(sound);
end

function out = transfer(in)
logistic = @(x) exp(x) ./ (1 + exp(x));
out = NaN(size(in));
for jj = 1:size(in,2)
    for ii = 1:length(in)
        if in(ii,jj) <= 0
            out(ii,jj) = logistic(in(ii,jj)*2) - 0.5;
        elseif in(ii,jj) > 0
            out(ii,jj) = 2*logistic(in(ii,jj)*2) - 0.5;
        end
    end
end

end