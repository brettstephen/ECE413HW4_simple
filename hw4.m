%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT
%    hw4
%
% NAME: _________________
%
% This script runs questions 1 through 7 of the HW4 from ECE313:Music and
% Engineering.
%
% This script was adapted from hw1 recevied in 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear functions
clear variables
dbstop if error

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs=44100;                     % Sampling rate in samples per second
STDOUT=1;                               % Define the standard output stream
STDERR=2;                               % Define the standard error stream

%% Sound Samples
% claims to be guitar
% source: http://www.traditionalmusic.co.uk/scales/musical-scales.htm
[guitarSound, fsg] = audioread('guitar_C_major.wav');

% sax riff - should be good for compressor
% source: http://www.freesound.org/people/simondsouza/sounds/763
[saxSound, fss] = audioread('sax_riff.wav');

% a fairly clean guitar riff
% http://www.freesound.org/people/ERH/sounds/69949/
[cleanGuitarSound, fsag] = audioread('guitar_riff_acoustic.wav');

% Harmony central drums (just use the first half)
[drumSound, fsd] = audioread('drums.wav');
L = size(drumSound,1);
drumSound = drumSound(1:round(L/2), :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Common Values 
% may work for some examples, but not all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
depth=75;
LFO_type='sin';
LFO_rate=0.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 1 - Compressor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
threshold = 0.05; 
slope = 1/4;
attack = 0.05;
avg_len = 5000;
[output,gain,count]=compressor(constants,saxSound,threshold,slope,attack,avg_len);

soundsc(saxSound,constants.fs)
disp('Playing the Compressor input')
pause(length(saxSound)/constants.fs)
soundsc(output,constants.fs)
disp('Playing the Compressor Output');
pause(length(saxSound)/constants.fs)
audiowrite('output_compressor.wav',output,fss);

% PLOTS for Question 1d
figure;
plot(saxSound)
hold on;
plot(output)
plot(gain)
legend('input','output','gain')
title('Compressor Signals')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 2 - Ring Modulator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs = fsg;
% the input frequency is fairly arbitrary, but should be about an order of
% magnitude higher than the input frequencies to produce a
% consistent-sounding effect
inputFreq = 2500;
depth = 0.5;
[output]=ringmod(constants,guitarSound,inputFreq,depth);

soundsc(guitarSound,constants.fs)
disp('Playing the RingMod input')
pause(length(guitarSound)/constants.fs)
soundsc(output,constants.fs)
disp('Playing the RingMod Output');
pause(length(output)/constants.fs)
audiowrite('output_ringmod.wav',output,fsg);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 3 - Stereo Tremolo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LFO_type = 'sin';
LFO_rate = 4;
% lag is specified in number of samples
% the lag becomes very noticeable one the difference is about 1/10 sec
lag = constants.fs/2;
depth = 0.5;
[output]=tremolo(constants,guitarSound,LFO_type,LFO_rate,lag,depth);

soundsc(guitarSound,constants.fs)
disp('Playing the Tremolo input')
pause(length(guitarSound)/constants.fs)
soundsc(output,constants.fs)
disp('Playing the Tremolo Output');
pause(length(guitarSound)/constants.fs)
audiowrite('output_tremelo.wav',output,fsg);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 4 - Distortion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gain = 20;
inSound = cleanGuitarSound(:,1);
tone = 0.3;
[output]=distortion(constants,inSound,gain,tone);

soundsc(inSound,constants.fs)
disp('Playing the Distortion input')
pause(length(cleanGuitarSound(:,1))/constants.fs)
soundsc(output,constants.fs)
disp('Playing the Distortion Output');
pause(length(cleanGuitarSound(:,1))/constants.fs)
audiowrite('output_distortion.wav',output,fsag);

% look at what distortion does to the spectrum
L = 10000;
n = 1:L;
sinSound = sin(2*pi*440*(n/fsag)).';
output=distortion(constants,sinSound,gain,tone);

figure;
plot(output(1:400))
title('Output of Distortion with Sinusoidal Input')
xlabel('Samples')

figure;
spectrogram(output,'yaxis')
title('Spectrum of Output of Distortion with Sinusoidal Input')

% I designed my distortion to have soft clipping in order to eliminate
% sharp discontinuities in the signal, and used a lowpass filter to reduce the presence of higher-order harmonics.
% I made the transfer function asymmetric, in order to introduce both even and odd harmonics, as even
% harmonics tend to sound better. This results in a better sounding output.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 5 - Delay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% slapback settings
inSound = cleanGuitarSound(:,1);
constants.fs = fsag;
delay_time = 0.08; % in seconds
depth = 0.8;
feedback = 0;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(inSound,constants.fs)
disp('Playing the Slapback input')
pause(length(cleanGuitarSound(:,1))/constants.fs)
soundsc(output,constants.fs)
disp('Playing the Slapback Output');
audiowrite('output_slapback.wav',output,fsag);
pause(length(cleanGuitarSound(:,1))/constants.fs)


% cavern echo settings
inSound = guitarSound;
delay_time = 0.4;
depth = 0.8;
feedback = 0.7;
[output]=delay(constants,inSound,depth,delay_time,feedback);

sound(inSound,constants.fs)
disp('Playing the cavern input')
pause(length(guitarSound)/constants.fs)
sound(output,constants.fs)
disp('Playing the cavern Output');
pause(length(guitarSound)/constants.fs)
audiowrite('output_cave.wav',output,fsg);


% delay (to the beat) settings
inSound = guitarSound;
delay_time = 0.18;
depth = 1;
feedback = 1;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(inSound,constants.fs)
disp('Playing the delayed on the beat input')
pause(length(guitarSound)/constants.fs)
soundsc(output,constants.fs)
disp('Playing the delayed on the beat Output');
pause(length(guitarSound)/constants.fs)
audiowrite('output_beatdelay.wav',output,fsg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 6 - Flanger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inSound = drumSound;
constants.fs = fsd;
depth = 1;
delay = .001;   
width = .002;   
LFO_Rate =0.5;   
[output]=flanger(constants,inSound,depth,delay,width,LFO_Rate);

soundsc(inSound,constants.fs)
disp('Playing the Flanger input')
pause(length(drumSound)/constants.fs)
soundsc(output,constants.fs)
disp('Playing the Flanger Output');
pause(length(drumSound)/constants.fs)
audiowrite('output_flanger.wav',output,fsd);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 7 - Chorus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inSound = guitarSound(:,1);
constants.fs = fsg;
depth = 0.8;
delay = .03;   
width = 0.02;   
LFO_Rate = 0.5; % irrelevant if width = 0
[output]=flanger(constants,inSound,depth,delay,width,LFO_Rate);

soundsc(inSound,constants.fs)
disp('Playing the Chorus input')
pause(length(guitarSound)/constants.fs)
soundsc(output,constants.fs)
disp('Playing the Chorus Output');
audiowrite('output_chorus.wav',output,fsg);