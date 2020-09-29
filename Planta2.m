clear 
clc
close all

num=5*conv([1 6 13],[1 0.5]);%numerador da planta
den=conv([1 -2],conv([1 -1],[1 8 41]));%denominador da planta
G=tf(num,den);%planta 2

figure(1)
rlocus(G);%lugas das raízes sem compensador
print -depsc LGR21
Mf=feedback(G,1);%malha fechada sem controlador
figure(2)
step(8.48*Mf);%resposta malha fechada sem compensador 

%especificacoes de desempenho
zeta=1;%overshoot igual a zero
Ts=1;
Wn=4/Ts;

real=-zeta*Wn;%parte real do polo desejado
Im=Wn*sqrt(1-zeta^2);%parte imaginaria do polo desejado
disp('Polos desejados');
polo1=real-1i*Im;
disp(polo1);
polo2=real+1i*Im;
disp(polo2);

%controlador para compensar os polos e zeros complexos
C=tf(1.714*[1 8 41],[1 6 13]);
Mf2=feedback(C*G,1);
figure(3)
hold on
plot(real,-Im,'*');
plot(real, Im,'*');
rlocus(G*C);%lugar das raízes com compensador
print -depsc LGR22
figure(4)
step(Mf2);%resposta com o compensador

%controlador para compensar o zero em -0,5
C2=tf([1 abs(real)],[1 0.5]);
figure(5)
rlocus(C*C2*G);%lugar das raízes com os dois compensadores em serie
hold on
plot(real,-Im,'*');
plot(real, Im,'*');
print -depsc LGR23
figure(6)
Mf3=feedback(100*C*C2*G,1);%resposta com os dois compensadores em serie
step(Mf3)
%o ganho de 100 foi determiando a partir do lugar das raízes para queo
%sistema não apresentasse overshoot

%Diagramas de Bode
figure(7)
bode(Mf3);

figure(8)
Mfd=feedback(G,C*C2);%disturbio
bode(Mfd);

figure 
Mfr=feedback(-C*C2*G,-1);%ruido
bode(Mfr,'r');