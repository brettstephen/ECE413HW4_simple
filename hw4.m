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
threshold = 0.1; 
slope = 1/4;
attack = 0.2;
avg_len = 5000;
[output,gain]=compressor(constants,saxSound,threshold,slope,attack,avg_len);

soundsc(saxSound,constants.fs)
disp('Playing the Compressor input')
pause(length(saxSound)/constants.fs)
soundsc(output,constants.fs)
disp('Playing the Compressor Output');
audiowrite('output_compressor.wav',output,fss);

% PLOTS for Question 1d

% TODO: Add code to complete plots

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 2 - Ring Modulator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
sound(output,constants.fs)
disp('Playing the Tremolo Output');
pause(length(guitarSound)/constants.fs)
audiowrite('output_tremelo.wav',output,fsg);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 4 - Distortion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gain = 20;
inSound = cleanGuitarSound(:,1);
tone = 0.5;
[output]=distortion(constants,inSound,gain,tone);

soundsc(inSound,constants.fs)
disp('Playing the Distortion input')
pause(length(cleanGuitarSound(:,1))/constants.fs)
soundsc(output,constants.fs)
disp('Playing the Distortion Output');
pause(length(cleanGuitarSound(:,1))/constants.fs)
wavwrite(output,fsag,'output_distortion.wav');

% % look at what distortion does to the spectrum
% L = 10000;
% n = 1:L;
% sinSound = sin(2*pi*440*(n/fsag));
% [output]=distortion(constants,sinSound,gain,tone);

% TODO: Add some Sample code to demonstrate the spectrum 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 5 - Delay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% slapback settings
inSound = cleanGuitarSound(:,1);
delay_time = 0.08; % in seconds
depth = 0.8;
feedback = 0;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(inSound,constants.fs)
disp('Playing the Slapback input')
soundsc(output,constants.fs)
disp('Playing the Slapback Output');
wavwrite(output,fsag,'output_slapback.wav');


% cavern echo settings
inSound = guitarSound;
delay_time = 0.4;
depth = 0.8;
feedback = 0.7;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(inSound,constants.fs)
disp('Playing the cavern input')
soundsc(output,constants.fs)
disp('Playing the cavern Output');
wavwrite(output,fsh,'output_cave.wav');


% delay (to the beat) settings
inSound = guitarSound;
delay_time = 0.18;
depth = 1;
feedback = 1;
[output]=delay(constants,inSound,depth,delay_time,feedback);

soundsc(inSound,constants.fs)
disp('Playing the delayed on the beat input')
soundsc(output,constants.fs)
disp('Playing the delayed on the beat Output');
wavwrite(output,fsg,'output_beatdelay.wav');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 6 - Flanger
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inSound = drumSound;
constants.fs = fsd;
depth = 0.8;
delay = .001;   
width = .002;   
LFO_Rate = 0.5;   
[output]=flanger(constants,inSound,depth,delay,width,LFO_Rate);

soundsc(inSound,constants.fs)
disp('Playing the Flanger input')
soundsc(output,constants.fs)
disp('Playing the Flanger Output');
wavwrite(output,fsd,'output_flanger.wav');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 7 - Chorus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inSound = guitarSound(:,1);
constants.fs = fsg;
depth = 0.9;
delay = .03;   
width = 0.1;   
LFO_Rate = 0.5; % irrelevant if width = 0
[output]=flanger(constants,inSound,depth,delay,width,LFO_Rate);

soundsc(inSound,constants.fs)
disp('Playing the Chorus input')
soundsc(output,constants.fs)
disp('Playing the Chorus Output');
wavwrite(output,fsg,'output_chorus.wav');


