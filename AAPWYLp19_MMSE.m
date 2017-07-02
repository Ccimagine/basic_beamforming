%% MMSE criterion using SMI algorithm
%% ��ʼ������  initial parameter
close all;clear all;clc;
N=16;                       % sensor��Ԫ��
theta=[0 -60 -20 40];      % ����� 10Ϊ�ź� ����Ϊ����
% direction of arrival. the first one is expect signal; others are interference signals
ss=1024;                    % snapshot  ������  32
snr=[50 80 40 30];                     % SNR �����
j=sqrt(-1);
%% �źŸ�����  signal
w=[pi/5 pi/6 pi/4 pi/3]';
for m = 1:length(theta)
    S(m,:)=10.^(snr(m)/10)*exp(-j*w(m)*[0:ss-1]);   
end
d=10.^(snr(1)/10)*exp(-j*w(1)*[0:ss-1]);   %�����ź�  pilot signal
%% ��������  steering vector
A=exp(j*(0:N-1)'*pi*sin(theta/180*pi));                %8*4
%% ����   noise
n=randn(N,ss)+j*randn(N,ss);
%% �۲��ź�   received signal
X=A*S+n;
%% ����Э�������   covariance matrix of pilot signal and received signal
R=X*X'/ss;
%% �����ź�������źŸ�����Э�������  covariance matrix
rxd=X*d'/ss;
%% ���з���ͼ
W=inv(R)*rxd;           % weighting vector
phi=-89:1:90;
a=exp(j*pi*(0:N-1)'*sin(phi*pi/180));
F=W'*a;
G=abs(F).^2./max(abs(F).^2);
G_dB=10*log10(G);
figure();
plot(phi,G_dB,'linewidth',2);hold on;grid on;     
legend('MMSE');                       
xlabel('Picth Angle (\circ)');ylabel('Magnitude (dB)');
