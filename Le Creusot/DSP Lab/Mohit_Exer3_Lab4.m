close all
clc

%% just for playing:
%% using the recorded sound:

fsampleRecord = 1000;
nBitsRecord = 16;
nChannelsRecord = 1;
deviceRecord = -1;
fsamplePlay = 20000;
r = audiorecorder(fsampleRecord, nBitsRecord,NChannelsRecord, deviceRecord);
record(r);
ch = 
