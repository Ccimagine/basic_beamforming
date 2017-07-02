%% beamforming anti-jamming
%% ��ʼ������ initial parameter
close all;
clear all;clc;
source=1;           %��Դ  signal number �����ź�
interference=3;     %����  interference number   6
N=7;               %array number     ��Ԫ��   7
theta_s=0;          %DOA of signal   -60  0
theta_i=[-60 -20 40 20 60 -40];  %DOA of interference
ss=2048;            %snapshot  ������
snr=[-10 40 20 30 50 30 30];    %  SNR  �����
j=sqrt(-1);
%% �źŸ����� SIGNAL
w=[pi/6 pi/6 pi/3 pi/4 pi/4 pi/4 pi/4]';
for m=1:(source+interference)
    SS(m,:)=10.^(snr(m)/10)*exp(-j*w(m)*[0:ss-1]);        %3*1024
    S(m,:) = awgn(SS(m,:),4,'measured');
end

% for m=1:(source+interference)
%     SS(m,:) = 10.^(snr(m)/10)*(randn(1,ss)+j*randn(1,ss));         %Signal and interference
%     S(m,:) = awgn(SS(m,:),10,'measured');
% end
%% ��������  STEERING VECTOR
A_i=exp(-j*(0:N-1)'*pi*sin(theta_i/180*pi));%8*4
A_s=exp(-j*(0:N-1)'*pi*sin(theta_s/180*pi));%8*1�źŷ���40
A = [A_s A_i(:,1:interference)];
%% ����  NOISE
n=randn(N,ss)+j*randn(N,ss);
%% �۲��ź�  SIGNAL RECEIVED
X=A*S+n;
% X=A*S;
%% ����Э�������  COVIARIANCE MATRIX
R=X*X'/ss;
inv_R = inv(R);
%% ��С��������MNV   CAPON   MVDR  LVDS
P=inv(A_s'*inv_R*A_s);% ��С�������
W_mnv = P*inv_R*A_s;
% W_gui1 = W_mnv/W_mnv(1,1);
% W_guiyi = W_gui1/max(abs(real(W_gui1)));
% W_mnv = W_guiyi;
% % W_mnv = P*inv_R*A_s*exp(j*pi/9)*1.5;
% W_mnv2 = inv_R*A_s;
% % W_mnv=W_mnv/max(W_mnv);
% amp_w = abs(W_mnv);
% pha_w = angle(W_mnv);

% yy = W_mnv'*X;
% figure();plot(1:ss,yy);
% fft_yy = fft(yy);
% p = unwrap(angle(fft_yy)); 
% figure();plot(1:ss,p);
% % ����Ÿ����MSINR
% Ai = A_i(:,1:interference);
% X_i_n = Ai*S(source+1:source+interference,:);
% R_i_n = X_i_n*X_i_n'/ss;
% W_msinr = inv(R_i_n)*A_s;
% % W_msinr=W_msinr/sqrt(W_msinr'*W_msinr);%��һ��

% % ��С������� MMSE
% snr_d = -10;
% % dd = 10.^(snr_d/10)*(randn(1,ss)+j*randn(1,ss));
% % d = awgn(dd,10,'measured');
% d = 10.^(snr_d/10)*exp(-j*w(1)*[0:ss-1]);
% r_xd = X*d'/ss;
% W_mmse = inv_R*r_xd;

%% ���з���ͼ  pattern
phi=-89:1:90;
a=exp(-j*pi*(0:N-1)'*sin(phi*pi/180));
F=W_mnv'*a;     % W_mnv  W_msinr  W_mmse
%figure();
%plot(phi,F);
G=abs(F).^2./max(abs(F).^2);
% G=abs(F).^2;
G_dB=10*log10(G);
%figure();
%plot(phi,G);legend('N=8,d=lamda/2');
figure();
plot(phi,G_dB,'linewidth',2);legend('N=16,d=lamda/2');
xlabel('Picth Angle (\circ)');ylabel('Magnitude (dB)');
grid on;
% axis equal;
% axis([-90 90 -310 0]);