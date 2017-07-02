%% MVDR beamforming; mainbeam widen
%% ��ʼ������ initial parameter
close all;clear all;clc;
source=1;           %��Դ  signal number
interference=1;     %����  interference number   6
N=16;               %array number     ��Ԫ��   7
theta_s=0;          %DOA of signal   -60  0
theta_i=[-60 -20 40 20 60 -40];  %DOA of interference
ss=1024;            %snapshot  ������
snr=[-10 40 20 30 50 30 30];    %  SNR  �����

j=sqrt(-1);
%% �źŸ����� SIGNAL
% w=[pi/6 pi/6 pi/3 pi/4]';
% for m=1:4
%     S(m,:)=10.^(snr(m)/10)*exp(-j*w(m)*[0:ss-1]);        %3*1024
% end

for m=1:(source+interference)
    S(m,:) = 10.^(snr(m)/10)*(randn(1,ss)+j*randn(1,ss));         %Signal and interference
end
%% ��������  STEERING VECTOR

A_i=exp(-j*pi*(0:N-1)'*sin(theta_i/180*pi));%8*4
A_s=exp(-j*pi*(0:N-1)'*sin(theta_s*pi/180));%8*1�źŷ���40
A = [A_s A_i(:,1:interference)];
%% ����  NOISE
n=randn(N,ss)+j*randn(N,ss);

%% �۲��ź�  SIGNAL RECEIVED
X=A*S+n;

%% ����Э�������  COVIARIANCE MATRIX
R=X*X'/ss;
Inv_Rx = inv(R);
delta = 1;
A_s1=exp(-j*pi*(0:N-1)'*sin((theta_s+delta)*pi/180));
A_s2=exp(-j*pi*(0:N-1)'*sin((theta_s-delta)*pi/180));
As = [A_s A_s1 A_s2];     %****
f = [1 1 1]';       %****

%% ���з���ͼ  pattern
W_opt=Inv_Rx*As*inv(As'*Inv_Rx*As)*f;%����Ȩֵ   
W_opt=W_opt/sqrt(W_opt'*W_opt);%��һ��
W_MVDR=Inv_Rx*A_s*inv(A_s'*Inv_Rx*A_s);
phi=-89:1:90;
a=exp(-j*pi*(0:N-1)'*sin(phi*pi/180));
F=W_opt'*a;
F1=W_MVDR'*a;
%figure();
%plot(phi,F);
G=abs(F).^2./max(abs(F).^2);
G1=abs(F1).^2./max(abs(F1).^2);
% G=abs(F).^2;
G_dB=10*log10(G);
G1_dB=10*log10(G1);
%figure();
%plot(phi,G);legend('N=8,d=lamda/2');
figure();
plot(phi,G_dB,'linewidth',2);legend('N=16,d=lamda/2');hold on
plot(phi,G1_dB,'r:','linewidth',2);
xlabel('Picth Angle (\circ)');ylabel('Magnitude (dB)');
grid on;axis equal;
%axis([-90 90 -50 0]);