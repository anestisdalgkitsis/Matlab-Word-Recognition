function VoiceRecognition
% Records a small library and test word recognition

clc
warning off;

fs = 11025;

% RECORD LIBRARY SAMPLES

disp('Record Library Samples');

disp(' [1] Press Return to record first word');
k = waitforbuttonpress;
disp(' > Recording Started...');
LIBWORD_1 = wavrecord(5*fs,fs);
disp(' | Recording Ended');
subplot(211); plot(LIBWORD_1); title('Library Word 1 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(212); spectrogram(LIBWORD_1,256,224,1024,fs,'yaxis'); title('Spectrogram of Signal'); ylabel('Frequency (Hz)'); xlabel('Time (Seconds)');

LIBWORD_1 = EndPointingVAD(LIBWORD_1); 
MFCCVectors_LIBWORD_1 = mfcc_calculator(LIBWORD_1);

disp(' [2] Press Return to record second word');
k = waitforbuttonpress;
disp(' > Recording Started...');
LIBWORD_2 = wavrecord(5*fs,fs);
disp(' | Recording Ended');
subplot(211); plot(LIBWORD_2); title('Library Word 2 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(212); spectrogram(LIBWORD_2,256,224,1024,fs,'yaxis'); title('Spectrogram of Signal'); ylabel('Frequency (Hz)'); xlabel('Time (Seconds)');
LIBWORD_2 = EndPointingVAD(LIBWORD_2); 
MFCCVectors_LIBWORD_2 = mfcc_calculator(LIBWORD_2);

disp(' [3] Press Return to record third word');
k = waitforbuttonpress;
disp(' > Recording Started...');
LIBWORD_3 = wavrecord(5*fs,fs);
disp(' | Recording Ended');
subplot(211); plot(LIBWORD_3); title('Library Word 3 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(212); spectrogram(LIBWORD_3,256,224,1024,fs,'yaxis'); title('Spectrogram of Signal'); ylabel('Frequency (Hz)'); xlabel('Time (Seconds)');
LIBWORD_3 = EndPointingVAD(LIBWORD_3);
MFCCVectors_LIBWORD_3 = mfcc_calculator(LIBWORD_3);

disp(' [4] Press Return to record fourth word');
k = waitforbuttonpress;
disp(' > Recording Started...');
LIBWORD_4 = wavrecord(5*fs,fs);
disp(' | Recording Ended');
subplot(211); plot(LIBWORD_4); title('Library Word 4 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(212); spectrogram(LIBWORD_4,256,224,1024,fs,'yaxis'); title('Spectrogram of Signal'); ylabel('Frequency (Hz)'); xlabel('Time (Seconds)');
LIBWORD_4 = EndPointingVAD(LIBWORD_4);
MFCCVectors_LIBWORD_4 = mfcc_calculator(LIBWORD_4);

disp('Library ok');
subplot(411); plot(LIBWORD_1); title('Library Word 1 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(412); plot(LIBWORD_2); title('Library Word 2 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(413); plot(LIBWORD_3); title('Library Word 3 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
subplot(414); plot(LIBWORD_4); title('Library Word 4 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
wavplay(LIBWORD_1,fs);
wavplay(LIBWORD_2,fs);
wavplay(LIBWORD_3,fs);
wavplay(LIBWORD_4,fs);


% RECORD SAMPLE

disp('--------------');
disp('Press Return and say a sample from library');
k = waitforbuttonpress;
disp(' > Recording Started...');
TEST_SAMPLE = wavrecord(5*fs,fs);
disp(' | Recording Ended');
TEST_SAMPLE =  EndPointingVAD(TEST_SAMPLE); 
wavplay(TEST_SAMPLE,fs);
MFCCVectors_TEST_SAMPLE = mfcc_calculator(TEST_SAMPLE);

% COMPARE

[F , TS]=size(MFCCVectors_TEST_SAMPLE);
[F , LW1]=size(MFCCVectors_LIBWORD_1);
[F , LW2]=size(MFCCVectors_LIBWORD_2);
[F , LW1]=size(MFCCVectors_LIBWORD_1);
[F , LW4]=size(MFCCVectors_LIBWORD_4);
[F , LW3]=size(MFCCVectors_LIBWORD_3);
M = [TS,LW1,LW2,LW3,LW4];
[M,I] = max(M);

NMFCCVectors_TEST_SAMPLE = zeros(F,M);
NMFCCVectors_LIBWORD_1 = zeros(F,M);
NMFCCVectors_LIBWORD_2 = zeros(F,M);
NMFCCVectors_LIBWORD_4 = zeros(F,M);
NMFCCVectors_LIBWORD_3 = zeros(F,M);

NMFCCVectors_TEST_SAMPLE(1:F,1:TS)=MFCCVectors_TEST_SAMPLE;
NMFCCVectors_LIBWORD_1(1:F,1:LW1)=MFCCVectors_LIBWORD_1;
NMFCCVectors_LIBWORD_2(1:F,1:LW2)=MFCCVectors_LIBWORD_2;
NMFCCVectors_LIBWORD_4(1:F,1:LW4)=MFCCVectors_LIBWORD_4;
NMFCCVectors_LIBWORD_3(1:F,1:LW3)=MFCCVectors_LIBWORD_3;


DISTANCE_LW1 = DTW(NMFCCVectors_TEST_SAMPLE,NMFCCVectors_LIBWORD_1);
DISTANCE_LW2 = DTW(NMFCCVectors_TEST_SAMPLE,NMFCCVectors_LIBWORD_2);
DISTANCE_LW3 = DTW(NMFCCVectors_TEST_SAMPLE,NMFCCVectors_LIBWORD_3);
DISTANCE_LW4 = DTW(NMFCCVectors_TEST_SAMPLE,NMFCCVectors_LIBWORD_4);

M = [DISTANCE_LW1,DISTANCE_LW2,DISTANCE_LW3,DISTANCE_LW4];
[A,I] = min(M);
if(I==1) 
    disp('Sample Matched LIBWORD_1');
    subplot(211); plot(TEST_SAMPLE); title('Spoken Sample'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    subplot(212); plot(LIBWORD_1); title('Matched Library Word 1 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    wavplay(LIBWORD_1,fs); % LIBWORD_1
end
if(I==2)
    disp('Sample Matched LIBWORD_2');
    subplot(211); plot(TEST_SAMPLE); title('Spoken Sample'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    subplot(212); plot(LIBWORD_2); title('Matched Library Word 2 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    wavplay(LIBWORD_2,fs); % LIBWORD_2
end
if(I==3)
    disp('Sample Matched LIBWORD_3');
    subplot(211); plot(TEST_SAMPLE); title('Spoken Sample'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    subplot(212); plot(LIBWORD_3); title('Matched Library Word 3 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
	wavplay(LIBWORD_3,fs); % LIBWORD_3
end
if(I==4)
    disp('Sample Matched LIBWORD_4');
    subplot(211); plot(TEST_SAMPLE); title('Spoken Sample'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    subplot(212); plot(LIBWORD_4); title('Matched Library Word 4 Signal'); ylabel('Amplitude (dB)'); xlabel('Time (Seconds)');
    wavplay(LIBWORD_4,fs); % LIBWORD_4
end
end