clear 
clc
close all

%planta 1
G=tf(5*[0 1 0.5],[1 2 0]);

figure(1) 
rlocus(G);
print -depsc LGR11
Mf=feedback(G,1); % malha fechada sem controlador
figure(2)
step(Mf);

%Especificações
ts=1;%tempo de acomodação
Os=10;%overshoot
zeta=sqrt((log(Os/100))^2/(pi^2+log(Os/100)^2));%coeficiente de amortecimento
Wn=4/(ts*zeta);%frequência natural
Im=Wn*sqrt(1-zeta^2);%parte imaginária do polo desejado
real=-zeta*Wn;%parte real do polo desejado
disp('Polos desejados');
polo1=real-1i*Im;
disp(polo1);
polo2=real+1i*Im;
disp(polo2);
z=abs(real);

disp('Compensador em avanço');
%calculo das fases 
phi1=180-atand(Im/z);%fase do primeiro polo
disp('phi1');
disp(phi1);
phi2=180-atand(Im/(z-2));%fase do segundo polo
disp('phi2');
disp(phi2);
theta1=180-atand(Im/(z-0.5));%fase do zero da planta 
disp('theta1');
disp(theta1);
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
h1=sqrt(z^2+Im^2);
h2=sqrt((z-2)^2+Im^2);
h3=sqrt(d^2+Im^2);
c1=sqrt((z-0.5)^2+Im^2);
c2=Im;
Kc=(h1*h2*h3)/(c1*c2*5);%ganho do controlador 
disp('ganho do controlador');
disp(Kc);
C=tf(Kc*[1 z],[1 p]);%controlador em avanço 
Mf2=feedback(C*G,1);%malha fechada com controlador em avanço

figure(3) 
step(Mf2);%resposta para o controlador em avanço

figure(4) 
hold on
plot(real,-Im,'*');
plot(real, Im,'*');
rlocus(C*G)%diagrama de Bode com compensador em avanço
print -depsc LGR12

%compensador em atraso
%polo próximo a origem
disp('Compensador em atraso proximo origem');
p=0.1;%polo do controlador
z1=8*p;%zero do controlador
%calculo dos novos modulos
a1=h1;
a2=sqrt(((z-p)^2+Im^2));
a3=h2;
b1=c1;
b2=sqrt((z-z1)^2+Im^2);
Kc1=(a1*a2*a3)/(5*b1*b2);%ganho do controlador em atraso
disp('Ganho do controlador');
disp(Kc1);
C1=tf(Kc1*[1 z1],[1 p]);%controlador em atraso
figure(5)
hold on
plot(real,-Im,'*');
plot(real, Im,'*');
rlocus(C1*G);%lugar das raizes controladro em atraso
print -depsc LGR13
figure(6)
Mf3=feedback(C1*G,1);
step(Mf3);%resposta para o controlador em atraso


%polo próximo do polo em 2
disp('Compensador em atraso próximo de 2')
p=2.1;%polo do controlador
z2=8*p;%zero do controlador
%calculo dos modulos do controlador
a2=sqrt((z-p)^2+Im^2);
b2=sqrt((z2-z)^2+Im^2);
Kc2=(a1*a2*a3)/(5*b1*b2);%ganho do novo controlador em atraso
disp('Ganho do controlador');
disp(Kc2);
C2=tf(Kc2*[1 z2],[1 p]);
figure(7)
rlocus(C2*G);%lugar das raízes novo controlador em atraso
hold on
plot(real,-Im,'*');
plot(real, Im,'*');
print -depsc LGR14
Mf4=feedback(C2*G,1);
figure(8)
step(Mf4);%reposta para o novo controlador em atraso