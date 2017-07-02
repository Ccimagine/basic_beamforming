%% ����ԪCapon MUSIC �����γ�
clc;clear all;close all;
%% �����趨
% % sensor=11;          %������11��Ԫ  ��Ԫ��
sensor=25;          %������7��Ԫ  ��Ԫ��
% sensor=6;          %������19��Ԫ  ��Ԫ��
source=5;           %��Դ  ������
%source=8;           %��Դ  ������
j=sqrt(-1);
Freq=46.5e6;
c=3e8;
lambda=c/Freq;
snapshot=2048;      %����
snr=[30 30 30 30 40];  %����Ȳ�ͬ�������γ��ϵ�Ӱ��
theta=[17 30 50 70 50]*pi/180;   %�ź�Դ����� ������
phi=[243 100 150 200 250]*pi/180;    %ˮƽ��
%% �����Ų�
% ����
% 7ULA
% position=[-1.5,0;-1,0;-0.5,0;0,0;0.5,0;1,0;1.5,0]*lambda;% ;2,0   ;2,0;0,0.5;0,1
% 2 ULA
% position=[0,0;0.5,0]*lambda;
% 4 ULA
% position=[0,0;0.5,0;1,0;1.5,0]*lambda;
% 7 HEX ARRAY
% position=[0,0;0.5,0;0.25,sqrt(3)/4;-0.25,sqrt(3)/4;-0.5,0;-0.25,-sqrt(3)/4;0.25,-sqrt(3)/4]*lambda;%��Ԫλ�� ��

% 5+4 L ARRAY
% position=[0,0;0.5,0;1,0;1.5,0;2,0;0,0.5;0,1;0,1.5;0,2]*lambda;% ;2,0   ;2,0;0,0.5;0,1

% 5+4 ʮ ARRAY
% position=[-1,0;-0.5,0;0,0;0.5,0;1,0;0,0.5;0,1;0,-0.5;0,-1]*lambda;% ;2,0
% ;2,0;0,0.5;0,1

% 5X5����
position=[-1,0;-0.5,0;0,0;0.5,0;1,0;....
          -1,0.5;-0.5,0.5;0,0.5;0.5,0.5;1,0.5;....
          -1,1;-0.5,1;0,1;0.5,1;1,1;....
          -1,-0.5;-0.5,-0.5;0,-0.5;0.5,-0.5;1,-0.5;....
          -1,-1;-0.5,-1;0,-1;0.5,-1;1,-1]*lambda;
      
% 19��Ԫ  Բ����Ȧ�����������
% position=[0,0;1/2,0;1,0;0.25,sqrt(3)/4;3/4,sqrt(3)/4;0.5,sqrt(3)/2;....
%     0,1;-1/2,0;-1,0;-0.25,sqrt(3)/4;-3/4,sqrt(3)/4;-0.5,sqrt(3)/2;....
%     -0.25,-sqrt(3)/4;-3/4,-sqrt(3)/4;-0.5,-sqrt(3)/2;....
%     0,-1;0.25,-sqrt(3)/4;3/4,-sqrt(3)/4;0.5,-sqrt(3)/2]*lambda;

% position=[0,0;0.5,0;0.25,1/(sqrt(3)*4);0.25,3/(sqrt(3)*4);-0.5,0;-0.25,1/(sqrt(3)*4);-0.25,3/(sqrt(3)*4);....
% 0.25,-1/(sqrt(3)*4);0.25,-3/(sqrt(3)*4);-0.25,-1/(sqrt(3)*4);-0.25,-3/(sqrt(3)*4)]*lambda;
                     % ��Ԫλ�� �뾶Ϊ1/2������������Բ���������������λ��
% position=[0,0;sqrt(3)/2,0;sqrt(3)/4,0.25;sqrt(3)/4,3/4;-sqrt(3)/2,0;-sqrt(3)/4,0.25;-sqrt(3)/4,3/4;sqrt(3)/4,-0.25;....
%     sqrt(3)/4,-3/4;-sqrt(3)/4,-0.25;-sqrt(3)/4,-3/4]*lambda;
                    % ��Ԫλ�� �뾶Ϊ1/2������������Բ����������ζ���λ��
% 19��Ԫ  ��������  
% position = [0,0; 1/2,0; 1,0; 0.25,sqrt(3)/4; 3/4,sqrt(3)/4; 0.5,sqrt(3)/2;...
%     0,sqrt(3)/2; -1/2,0; -1,0; -0.25,sqrt(3)/4; -3/4,sqrt(3)/4; -0.5,sqrt(3)/2;...
%     -0.25,-sqrt(3)/4; -3/4,-sqrt(3)/4; -0.5,-sqrt(3)/2;...
%     0,-sqrt(3)/2; 0.25,-sqrt(3)/4; 3/4,-sqrt(3)/4;
%     0.5,-sqrt(3)/2]*lambda;

figure();plot(position(:,1),position(:,2),'s');
xlabel('X');ylabel('Y');title('�����Ų���ʽ');
% axis tight;
grid on;
%% ���껻��
ux=cos(theta).*sin(phi);
uy=cos(theta).*cos(phi);
%uz=cos(theta);
%% �������/��������/��Ӧ����
%A_sig=exp(-j*2*pi*position*[ux_s;uy_s]/lamda);  %�������Զ��ƽ�沨7*1
for i=1:source
    A(:,i)=exp(-j*2*pi*position*[ux(i);uy(i)]/lambda);  %sensor*source
end
%% ����
%Noise=zeros(array_num,N);
Noise=(randn(sensor,snapshot)+j*randn(sensor,snapshot));
%% �źŸ�����
% S=2*randn(source,snapshot);
f = [200 100 500 300 465];
w=2*pi./f;
% w=[pi/6 pi/5 pi/4 0 pi/2]';
for i=1:1:source-1
    S(i,:)=10.^(snr(i)/10)*exp(-j*w(i)*(0:snapshot-1));  %source*snapshot
end
S(i+1,:)=10.^(snr(i+1)/10)*(randn(1,snapshot)+j*randn(1,snapshot));
%d=10.^(snr/10)*exp(-j*2*pi*GPS_F*t);%1*512
%% Э�������
X=A*S;%+Noise;%7*512
Rx=X*X'/snapshot;%7*7
%rxd=X*d'/snapshot;%7*1
inv_Rx = inv(Rx);
%% CAPON �����γ�
angle_step=1;
% theta_pos=0;
phi_pos=0;
for phi_s=0:angle_step:360
    phi_pos=phi_pos+1;
    theta_pos=0;
    for theta_s=0:angle_step:90
      theta_pos=theta_pos+1;  
%       ux_s=sin(theta_s*pi/180).*cos(phi_s*pi/180);
%       uy_s=sin(theta_s*pi/180).*sin(phi_s*pi/180);
        ux_s=cos(theta_s*pi/180).*sin(phi_s*pi/180);
      uy_s=cos(theta_s*pi/180).*cos(phi_s*pi/180);
      A_temp=exp(-j*2*pi*position*[ux_s;uy_s]/lambda);
      Pcapon(phi_pos,theta_pos)=1/(A_temp'*inv_Rx*A_temp);
%       P(phi_pos,theta_pos)=abs(A_temp'*inv_Rx*A_temp);
    end
end

figure();
mesh([0:angle_step:90],[0:angle_step:360],abs(Pcapon));
xlabel('pitch/ \circ');ylabel('azimuth/ \circ');zlabel('magnitude/dB');title('Capon method DOA estimation');

Max1=max(max(abs(Pcapon)));
G1=abs(Pcapon/Max1);%��һ��
G1_dB=10*log10(G1);
figure();
mesh([0:angle_step:90],[0:angle_step:360],G1_dB);% colorbar;
xlabel('pitch/ \circ');ylabel('azimuth/ \circ');zlabel('magnitude/dB');title('Capon method DOA estimation');
% PP=G1_dB(:,20);
% figure();plot([0:angle_step:360],G1_dB(:,60),'r');grid on;
% figure();plot([0:angle_step:90],G1_dB(200,:),'k');grid on;
% figure();plot([0:angle_step:360],G1_dB(200,:),'r');% grid on;
%% MUSIC
[Vec,Val]=eig(Rx);                              %��������������ֵ
[Val Seq]=sort(max(Val));                       % ��С��������
Vec_s=Vec(:,Seq(sensor-source+1:sensor));      %��Դ��������sensor-GDE_num+1:sensor �ź��������������Դ�;ȡ5��7��
Vec_n=Vec(:,Seq(1:sensor-source));             %1:sensor-GDE_num ������������  7*4��ȡ1��4��

%����Ԫ
%Vec_s=Vec(:,Seq(2:4));%��Դ��������sensor-GDE_num+1:sensor�ź��������������Դ�;ȡ5��7��
%Vec_n=Vec(:,Seq(1:1));%1:sensor-GDE_num������������  7*4��ȡ1��4��

theta_pos=0;
phi_pos=0;
for theta_s=0:angle_step:360
    theta_pos=theta_pos+1;
    phi_pos=0;
    for phi_s=0:angle_step:90
      phi_pos=phi_pos+1;  
      ux_s=cos(theta_s*pi/180).*sin(phi_s*pi/180);
      uy_s=sin(theta_s*pi/180).*sin(phi_s*pi/180);
      As_temp=exp(-j*2*pi*position*[ux_s;uy_s]/lambda);
      B=As_temp'*Vec_n*Vec_n'*As_temp;
      Pmusic(theta_pos,phi_pos)=1/B;         %real(1/B)
    end 
end
figure();
mesh([0:angle_step:90],[0:angle_step:360],abs(Pmusic));
xlabel('pitch/ \circ');ylabel('azimuth/ \circ');zlabel('magnitude/dB');title('MUSIC method DOA estimation');
P_guiyi=10*log10(abs(Pmusic)/max(max(abs(Pmusic))));
figure();
mesh([0:angle_step:90],[0:angle_step:360],P_guiyi);% colorbar;
xlabel('pitch/ \circ');ylabel('azimuth/ \circ');zlabel('magnitude/dB');title('MUSIC method DOA estimation');

figure();plot([0:angle_step:360],P_guiyi(:,60),'r');grid on;
figure();plot([0:angle_step:90],P_guiyi(200,:),'k');grid on;