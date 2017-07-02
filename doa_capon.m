%% DOA CAPON
%% ��ʼ������ initial parameter
close all;
clear all;clc;
source=2;       %��Դ  signal number �����ź�
N=4;            %array number
theta_s=[20 60];      %DOA of signal
ss=1024;        %snapshot  ������
snr=[1 1];    %  SNR  �����
j=sqrt(-1);
%% �źŸ����� SIGNAL
w=[pi/6 pi/5]';
for m=1:source
    S(m,:)=10.^(snr(m)/10)*exp(-j*w(m)*[0:ss-1]);
end
%% ��������  STEERING VECTOR
A=exp(-j*(0:N-1)'*pi*sin(theta_s/180*pi));
%% ����  NOISE
n=randn(N,ss)+j*randn(N,ss);
%% �۲��ź�  SIGNAL RECEIVED
X=A*S+n;
%% ����Э�������  COVIARIANCE MATRIX
R=X*X'/ss;
inv_R = inv(R);
%% Capon DOA
for phi=1:1:90;
    a=exp(-j*pi*(0:N-1)'*sin(phi*pi/180));
    Pcapon(phi)=1/(a'*inv_R*a);
end
phi_scan=1:1:90;
Pcapon=10*log10(Pcapon);
figure();
plot(phi_scan,Pcapon,'linewidth',2);legend('N=7,d=lamda/2');
xlabel('Picth Angle (\circ)');ylabel('Magnitude (dB)');
grid on;

