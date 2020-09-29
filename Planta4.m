clear 
clc
close all

num=5*[1 -5];%numerador da planta
den= conv([1 0],conv([1 -2],[1 0]));%denominador da planta
G = tf(num,den);%planta 4
figure(1)
rlocus(G)%lugar das raizes planta sem compensador
print -depsc LGR41

Mf=feedback(G,1);
figure(2)
step(Mf)%resposta planta sem compensador
print -depsc Resposta41
%especificacoes
ts=0.8;%tempo de acomodacao
Os=15;%overshoot
zeta=sqrt((log(Os/100))^2/(pi^2+log(Os/100)^2));%coeficinete de amortecimento
Wn=4/(ts*zeta);%frequencia natural
Im=Wn*sqrt(1-zeta^2);%parte iamginaria do polo desejado
real=-zeta*Wn;%parte real do polo desejado
disp('Polos desejados');
polo1=real-1i*Im;
disp(polo1);
polo2=real+1i*Im;
disp(polo2);
%controlador em avanço
z=abs(real);%zero do controladro
theta1=180-atand(Im/(5+z));%fase do primeiro zero
disp('Compensdor em avanço');
disp('theta1');
disp(theta1);
phi1=180-atand(Im/(z+2));%fase do primeiro polo
disp('phi1');
disp(phi1);
phi2=180-atand(Im/(z));%fase do segundo polo
disp('phi2');
disp(phi2);
phi3=-180-90+phi1+2*phi2-theta1;%fase do polo do controlador
disp('Fase polo controlador');
disp(phi3);


d=abs(Im/tand(phi3));
p=d+z;%polo do controlador
disp('zero controlador');
disp(z);
disp('polo controlador');
disp(p);
%calculo dos modulos 
h1=sqrt((z+2)^2+Im^2);
h2=sqrt((z)^2+Im^2);
h3=sqrt(d^2+Im^2);
c1=sqrt((z+5)^2+Im^2);
c2=Im;
Kc=(h1*h2^2*h3)/(c1*c2*5);%ganho do controlador em avanço
disp('ganho do controlador');
disp(Kc);
C=tf(Kc*[1 z],[1 p]);
Mf2=feedback(C*G,1);%malha fechada com controlador em avanço

figure(3) 
hold on
plot(real,-Im,'*');
plot(real, Im,'*');
rlocus(C*G)%lugar das raizes do controlador em avanço
print -depsc LGR42
figure(4) 
hold on
step(Mf2);%resposta do controlador em avanço
print -depsc Resposta42

%compensador em atraso
%polo próximo a origem
disp('Compensador em atraso proximo origem');
p=0.1;%polo do controlador
z1=1.6*p;%zero do controlador
%calculo dos modulos
a1=h1;
a2=sqrt(((z-p)^2+Im^2));
a3=h2;
b1=c1;
b2=sqrt((z-z1)^2+Im^2);
Kc1=(a1*a2*a3^2)/(5*b1*b2);%ganho do controlador em atraso
disp('Ganho do controlador');
disp(Kc1);
C1=tf(Kc1*[1 z1],[1 p]);
figure(5)
hold on
plot(real,-Im,'*');
plot(real, Im,'*');
rlocus(C*C1*G);%lugar das raizes com os dois compensadores em serie
print -depsc LGR43
figure(6)
Mf3=feedback(C*C1*G,1);%resposta para os dois compensadores em serie
step(Mf3);
print -depsc Resposta43



