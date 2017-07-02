%% beamforming anti-jamming
%% ��ʼ������ initial parameter
close all;
clear all;clc;
source=1;       %��Դ  signal number �����ź�
interference=1; %����  interference number
N=21;            %array number
theta_s=0;      %DOA of signal
theta_i=-60;  %DOA of interference
ss=1024;        %snapshot  ������
snr=[0 30];    %  SNR  �����
j=sqrt(-1);
%% �źŸ����� SIGNAL
w=[pi/3 pi/6]';
for m=1:(source+interference)
    S(m,:)=10.^(snr(m)/10)*exp(-j*w(m)*[0:ss-1]);
end
%% ��������  STEERING VECTOR
A_i=exp(j*(0:N-1)'*pi*sin(theta_i/180*pi));
A_s=exp(j*(0:N-1)'*pi*sin(theta_s/180*pi));
A = [A_s A_i(:,1:interference)];
%% ����  NOISE
n=1000*randn(N,ss)+j*1000*randn(N,ss);
%% �۲��ź�  SIGNAL RECEIVED
X=A*S+n;
%% ����Э�������  COVIARIANCE MATRIX
R=X*X'/ss;
inv_R = inv(R);
%% CAPON/MVDR BEAMFORMING
W_mnv = inv_R*A_s;
%% ���з���ͼ  pattern
phi=-89:1:90;
a=exp(j*pi*(0:N-1)'*sin(phi*pi/180));
F=W_mnv'*a;     
G=abs(F).^2./max(abs(F).^2);
G_dB=10*log10(G);
figure();
plot(phi,G_dB,'linewidth',2);legend('N=16,d=lamda/2');
xlabel('Picth Angle (\circ)');ylabel('Magnitude (dB)');
grid on;
%% FREQUENCY SPECTRUM
yy = W_mnv'*X;
fft_X = abs(fft(X(1,:)));
fft_yy = abs(fft(yy));
figure();plot(1:ss,20*log10(fft_X));
xlabel('Ƶ��/MHz');ylabel('����/dB');
figure();plot(1:ss,20*log10(fft_yy));
xlabel('Ƶ��/MHz');ylabel('����/dB');