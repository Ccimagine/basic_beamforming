%% ����ԪCapon MUSIC �����γ�
clc;clear all;close all;
%% ������ʼ��
sensor=7;       %����������Ԫ
%sensor=4;      %����Ԫ
source=2;       %��Դ
j=sqrt(-1);
GPS_F=1.57542e9;
c=3e8;
Fs=62e6;  %����Ƶ��
lamda=c/Fs;  %�����Ĳ�������lambda
ss=1024;%����
ts=1/Fs;
t=(0:ss-1)*ts;
%snr=10;
snr=[10 10 10];%����Ȳ�ͬ�������γ��ϵ�Ӱ�죿
position=[0,0;0.5,0;0.25,sqrt(3)/4;-0.25,sqrt(3)/4;-0.5,0;-0.25,-sqrt(3)/4;0.25,-sqrt(3)/4]*lamda;%��Ԫλ�� ��

%position=[0,0;-sqrt(3)/2,1/2;sqrt(3)/2,1/2;0,-1]*lamda/2;%����Ԫ

theta=[60 40 80]*pi/180;   %�ź�Դ����� ������
phi=[160 250 160]*pi/180;    %ˮƽ��

Fi=[1.575 1 2.5]*1e9;   %ʲôƵ��?Ƶ���к�Ӱ�죿
%lamda_i=[c/Fi(1) c/Fi(2) c/Fi(3)];%���Ų���
%% ���껻��
ux=sin(theta).*cos(phi);
uy=sin(theta).*sin(phi);
uz=cos(theta);
%% �������/��������/��Ӧ����
%A_sig=exp(-j*2*pi*position*[ux_s;uy_s]/lamda);  %�������Զ��ƽ�沨7*1
for i=1:source;
    A(:,i)=exp(-j*2*pi*position*[ux(i);uy(i)]/lamda);%7*3
end
% ��������
% A_desired=[1;0;0;0;0;0;0];%7*3
theta_desired=[20]*pi/180;   %�ź�Դ����� ������
phi_desired=[300]*pi/180;    %ˮƽ��
ux_desired=sin(theta_desired).*cos(phi_desired);
uy_desired=sin(theta_desired).*sin(phi_desired);
A_desired = exp(-j*2*pi*position*[ux_desired;uy_desired]/lamda);
%% ����
%Noise=zeros(array_num,N);
Noise=randn(sensor,ss)+j*randn(sensor,ss);%7*512
%% �źŸ�����
for i=1:1:source
    S(i,:)=10.^(snr(i)/10)*exp(-j*2*pi*Fi(i)'*t);%3*512
end
%d=10.^(snr/10)*exp(-j*2*pi*GPS_F*t);%1*512
%% Э�������
X=A*S+Noise;%7*512
Rx=X*X'/ss;%7*7
%rxd=X*d'/ss;%7*1
Rx_inv = inv(Rx);

W_opt=Rx_inv*A_desired/(A_desired'*Rx_inv*A_desired);%����Ȩֵ
W=W_opt/sqrt(W_opt'*W_opt);%��һ��
anti_jam_X = [W(1,1)*X(1,:);W(2,1)*X(2,:);W(3,1)*X(3,:);W(4,1)*X(4,:);W(5,1)*X(5,:);W(6,1)*X(6,:);W(7,1)*X(7,:)];
Rx_anti=anti_jam_X*anti_jam_X'/ss;%7*7
Rx_inv_anti = inv(Rx_anti);

%% CAPON �����γ�
angle_step=1;
theta_pos=0;
phi_pos=0;
for phi_s=1:angle_step:360
    phi_pos=phi_pos+1;
    theta_pos=0;
    for theta_s=1:angle_step:90
      theta_pos=theta_pos+1;  
      ux_s=sin(theta_s*pi/180).*cos(phi_s*pi/180);
      uy_s=sin(theta_s*pi/180).*sin(phi_s*pi/180);
      A_temp=exp(-j*2*pi*position*[ux_s;uy_s]/lamda);
      Pcapon(phi_pos,theta_pos,:)=1/(A_temp'*Rx_inv*A_temp);
%       P(phi_pos,theta_pos,:)=W'*A_temp;
        P(phi_pos,theta_pos)=A_temp'*Rx_inv*A_temp;
      end
end

Max2=max(max(abs(Pcapon)));
G2=abs(Pcapon)/Max2;%��һ��
% G1_dB=20*log10(G1);
figure();
mesh([1:angle_step:90],[1:angle_step:360],G2);
colorbar;
xlabel('������/ \circ');ylabel('��λ��/ \circ');zlabel('Pcapon/dB');title('Capon����������');
figure();
contour([1:angle_step:90],[1:angle_step:360],G2);grid on;
xlabel('������/ \circ');ylabel('��λ��/ \circ');title('Capon���������׸���ͼ');

% figure();
% meshc([1:angle_step:90],[1:angle_step:360],20*log10(abs(P)));
% 
Max1=max(max(abs(Pcapon)));
G1=abs(Pcapon)/Max1;%��һ��
G1_dB=20*log10(G1);
figure();
mesh([1:angle_step:90],[1:angle_step:360],G1_dB);
colorbar;
xlabel('������/ \circ');ylabel('��λ��/ \circ');zlabel('Pcapon/dB');title('Capon����������');
figure();
contour([1:angle_step:90],[1:angle_step:360],G1_dB);grid on;
xlabel('������/ \circ');ylabel('��λ��/ \circ');title('Capon���������׸���ͼ');

figure();
mesh([1:angle_step:90],[1:angle_step:360],abs(P));
colorbar;
xlabel('������/ \circ');ylabel('��λ��/ \circ');zlabel('Pcapon/dB');title('Capon����������');
figure();
contour([1:angle_step:90],[1:angle_step:360],P);grid on;
xlabel('������/ \circ');ylabel('��λ��/ \circ');title('Capon���������׸���ͼ');
% 
% figure();meshc([1:angle_step:90],[1:angle_step:360],20*log10(abs(P)));%colorbar;%rmal
% xlabel('������/ \circ');ylabel('��λ��/ \circ');zlabel('����ͼ����/dB');title('��Լ��ʱ�����ŷ���ͼ');
% figure();contour([1:angle_step:90],[1:angle_step:360],20*log10(abs(P)));grid on;
% xlabel('������/ \circ');ylabel('��λ��/ \circ');title('��Լ��ʱ�����ŷ���ͼ����ͼ');
% 
% 
% angle_step=1;
% theta_pos=0;
% phi_pos=0;
% for phi_s=1:angle_step:360
%     phi_pos=phi_pos+1;
%     theta_pos=0;
%     for theta_s=1:angle_step:90
%       theta_pos=theta_pos+1;  
%       ux_s=sin(theta_s*pi/180).*cos(phi_s*pi/180);
%       uy_s=sin(theta_s*pi/180).*sin(phi_s*pi/180);
%       A_temp=exp(-j*2*pi*position*[ux_s;uy_s]/lamda);
%       Pcapon_anti(phi_pos,theta_pos,:)=1/(A_temp'*Rx_inv_anti*A_temp);
%       end
% end
% 
% Max3=max(max(abs(Pcapon_anti)));
% G3=abs(Pcapon_anti)/Max3;%��һ��
% figure();
% meshc([1:angle_step:90],[1:angle_step:360],G3);
% colorbar;
% xlabel('������/ \circ');ylabel('��λ��/ \circ');zlabel('Pcapon/dB');title('Capon�����������');
% figure();
% contour([1:angle_step:90],[1:angle_step:360],G3);grid on;
% xlabel('������/ \circ');ylabel('��λ��/ \circ');title('Capon����������׸���ͼ');
% 
% Max4=max(max(abs(Pcapon_anti)));
% G4=abs(Pcapon_anti)/Max4;%��һ��
% G4_dB=20*log10(G4);
% figure();
% mesh([1:angle_step:90],[1:angle_step:360],G4_dB);
% colorbar;
% xlabel('������/ \circ');ylabel('��λ��/ \circ');zlabel('Pcapon/dB');title('Capon�����������');
% figure();
% contour([1:angle_step:90],[1:angle_step:360],G4_dB);grid on;
% xlabel('������/ \circ');ylabel('��λ��/ \circ');title('Capon����������׸���ͼ');



%% MUSIC
%�ο�����doa_music
% 
% [Vec,Val]=eig(Rx);%��������������ֵ
% [Val Seq]=sort(max(Val));
% %����Ԫ
% Vec_s=Vec(:,Seq(sensor-source:7));%��Դ��������sensor-GDE_num+1:sensor�ź��������������Դ�;ȡ5��7��
% Vec_n=Vec(:,Seq(1:sensor-source));%1:sensor-GDE_num������������  7*4��ȡ1��4��  sensor-source
% %����Ԫ
% %Vec_s=Vec(:,Seq(2:4));%��Դ��������sensor-GDE_num+1:sensor�ź��������������Դ�;ȡ5��7��
% %Vec_n=Vec(:,Seq(1:1));%1:sensor-GDE_num������������  7*4��ȡ1��4��
% 
% theta_pos=0;
% phi_pos=0;
% for theta_s=0:angle_step:360
%     theta_pos=theta_pos+1;
%     phi_pos=0;
%     for phi_s=0:angle_step:90
%       phi_pos=phi_pos+1;  
%       ux_s=cos(theta_s*pi/180).*sin(phi_s*pi/180);
%       uy_s=sin(theta_s*pi/180).*sin(phi_s*pi/180);
%       As_temp=exp(-j*2*pi*position*[ux_s;uy_s]/lamda);%7*1
%       B=(As_temp'*Vec_n*Vec_n'*As_temp);
%       P(theta_pos,phi_pos)=1/B;%real(1/B)
%     end 
% end
% P_guiyi=20*log10(abs(P)/max(max(abs(P))));
% figure();
% mesh([0:angle_step:90],[0:angle_step:360],P_guiyi);colorbar;
% xlabel('������/ \circ');ylabel('��λ��/ \circ');zlabel('Parten/dB');title('MUSIC����������');
% figure();
% contour([0:angle_step:90],[0:angle_step:360],P_guiyi);grid on;
% xlabel('������/ \circ');ylabel('��λ��/ \circ');title('MUSIC���������׸���ͼ');

%% ���ȷ����Դ�������Ƕ�Բ�������ź�Դ����?


