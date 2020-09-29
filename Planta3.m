clear 
clc 
close all

num=5*[1 -5];%numerador da planta
den= conv([1 -2],[1 2]);%deominador da planta
G = tf(num,den);%planta 3

figure(1)
rlocus(G)%lugar das raízes sem compensador
print -depsc LGR31
Mf=feedback(G,1);
figure(2)
step(Mf)%resposta sem comensador
print -depsc Resposta31
%especificações de desempenho 
ts=1;%tempo de acomodacao
Os=10;%overshoot
zeta=sqrt((log(Os/100))^2/(pi^2+log(Os/100)^2));%coeficiente de amortecimento
Wn=4/(ts*zeta);%frequencia natural
Im=Wn*sqrt(1-zeta^2);%parte imaginaria do polo desejado
real=-zeta*Wn;%parte real do polo desejado
disp('Polos desejados');
polo1=real-1i*Im;
disp(polo1);
polo2=real+1i*Im;
disp(polo2);

z=abs(real);%zero do controlador
%calculo das fases
theta1=180-atand(Im/(5+z));%fase do primeiro zero
disp('Compensador em avanço');
disp('theta1');
disp(theta1);
phi1=180-atand(Im/(z+2));%fase do primeiro polo
disp('phi1');
disp(phi1);
phi2=180-atand(Im/(z-2));%fase do segundo polo
disp('phi2');
disp(phi2);
phi3=-180-90+phi1+phi2-theta1;%fase do polo do controlador
disp('Fase polo controlador');
disp(phi3);

d=Im/tand(phi3);
p=d+z;%polo do controlador
disp('zero controlador');
disp(z);
disp('polo controlador');
disp(p);
%calculo dos modulos
h1=sqrt((z+2)^2+Im^2);
h2=sqrt((z-2)^2+Im^2);
h3=sqrt(d^2+Im^2);
c1=sqrt((z+5)^2+Im^2);
c2=Im;
Kc=(h1*h2*h3)/(c1*c2*5);%ganho do controlador
disp('ganho do controlador');
disp(Kc);
C=tf(Kc*[1 z],[1 p]);
Mf2=feedback(C*G,1);%malha fechada com controlador em avanço

figure(3) 
step(Mf2);%resposta com controlador em avanço
print -depsc Resposta32

figure(4) 
hold on
plot(real,-Im,'*');
plot(real, Im,'*');
rlocus(C*G)%lugar das raízes com controlador em avanço
print -depsc LGR32


%compensador em atraso
%polo próximo a origem
disp('Compensador em atraso proximo origem');
p=0.1;%polo do controlador
z1=1.44*p;%zero do controlador
%calculo dos modulos
a1=h1;
a2=sqrt(((z-p)^2+Im^2));
a3=h2;
b1=c1;
b2=sqrt((z-z1)^2+Im^2);
Kc1=(a1*a2*a3)/(5*b1*b2);%ganho do controlador em atraso
disp('Ganho do controlador');
disp(Kc1);
C1=tf(Kc1*[1 z1],[1 p]);
figure(5)
hold on
plot(real,-Im,'*');
plot(real, Im,'*');
rlocus(C1*G);%lugar das raizes compensador em atraso
print -depsc LGR33

figure(6)
Mf3=feedback(C1*G,1);
step(Mf3);%resposta com compensador em atraso
print -depsc Resposta33

%polo próximo do polo em 2
disp('Compensador em atraso próximo de 2')
p=2.1;%polo do controlador
z2=1.44*p;%zero do controlador
%calculos dos modulos
a2=sqrt((z-p)^2+Im^2);
b2=sqrt((z2-z)^2+Im^2);
Kc2=(a1*a2*a3)/(5*b1*b2);%ganho do novo controlador em taraso
disp('Ganho do controlador');
disp(Kc2);
C2=tf(Kc2*[1 z2],[1 p]);
figure(7)
hold on
plot(real,-Im,'*');
plot(real, Im,'*');
rlocus(C2*G);%lugar das raizes com o novo controlador em atraso
print -depsc LGR34

Mf4=feedback(C2*G,1);
figure(8)
step(Mf4);%resposta com o novo controlador em atraso
print -depsc Resposta34