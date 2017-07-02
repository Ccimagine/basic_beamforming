%% DOA MUSIC
%% ��ʼ������ initial parameter
close all;clear all;clc;
source=2;       %��Դ  signal number �����ź�
sensor=7;            %array number
theta=[20 60];      %DOA of signal
ss=1024;        %snapshot  ������
snr=[40 60];    %  SNR  �����
j=sqrt(-1);
%% �źŸ����� SIGNAL
w=[pi/6 pi/5]';
for m=1:source
    S(m,:)=10.^(snr(m)/10)*exp(-j*w(m)*[0:ss-1]);
end
%% ��������  STEERING VECTOR
A=exp(-j*(0:sensor-1)'*pi*sin(theta/180*pi));
%% ����  NOISE
N=randn(sensor,ss)+j*randn(sensor,ss);
%% �۲��ź�  SIGNAL RECEIVED
Y=A*S+N;
%% ����Э�������  COVIARIANCE MATRIX
R=Y*Y'/ss;
%% �����ֽ� eigen-decomposition
p=length(theta);
[E,X,V]=svd(R);%E=V,        X������ֵ��E�����������������ʹ� �ִ��źŴ��� P131 3.9.22ʽ
%Es=X(:,1:p); 
En=E(:,p+1:sensor);%X����ֵ�ɴ�С �������� ���Դ�����ֵ��ǰ ���ź�����ֵ��ǰ

% [V,D]=eig(R);%[��������������ֵ]
% D=diag(D);
% Es=V(:,sensor-p+1:sensor);
% En=V(:,1:sensor-p);%������������  ����ֵ��С���� �������� ���Դ�����ֵ�ں� ���ź�����ֵ�ں�

search_doa=[0:1:90];
for i=1:length(search_doa)
    a_theta=exp(-j*pi*(0:sensor-1)'*sin(search_doa(i)*pi/180));
    Q=(a_theta)'*En*En'*a_theta;
    Pmusic(i)=1./Q;
end
P_music=10*log10(Pmusic);
plot(search_doa,P_music,'linewidth',2);
title('MUSIC beamforming');
xlabel('angle/degree');
ylabel('magnitude/dB');
grid;
%     Pmusic(i)=1./abs(Q);%abs(1./((a_theta)'*En*En'*a_theta));