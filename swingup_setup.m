%% BALANCE SETUP
clear; clc; close all;
T = 0.001;
theta_cal = -(360/4096) * (pi/180);
alpha_cal = -(360/4096) * (pi/180);
tstop = 60*5;

theta_ref = 0 * 30/180 * pi;
theta_freq = 0 * 2;
Vin_HARDLIM = 5;
theta_HARDLIM = 160/180 * pi;

ABSALPHA_ON = 22.5 + (5);
ALPHAUR_ON = 60;



A = [0 0 1 0;
    0 0 0 1;
    0 81.403 -10.2536 -0.9319;
    0 122.0545 -10.332 -1.3972];
B = [0;0;83.2;80.1];
C = [1 0 0 0;0 1 0 0];
D = [0;0];

ss_cont = ss(A,B,C,D);

[b,a] = ss2tf(A,B,C,D);
b1 = b(1,:); b2 = b(2,:);  a = a(1,:);
tf1 = minreal(tf(b1,a)); tf2 = minreal(tf(b2,a));

ss_disc = c2d(ss_cont,T);
Ad = ss_disc.A; Bd = ss_disc.B;
Cd = ss_disc.C; Dd = ss_disc.D;

theta_max = 4/180 * pi;
alpha_max = 1.5/180 * pi;
dtheta_max = 100; dalpha_max = 1;
q1 = 1/(theta_max^2); q2 = 1/(alpha_max^2);
q3 = 1/(dtheta_max^2); q4 = 1/(dalpha_max^2);
Q = diag([q1 q2 q3 q4]);

Vmax = 5; R = 1/(Vmax^2);
[K_lqr,~,~] = lqr(ss_cont,Q,R)

% SWINGUP SETUP
bemf_lim = .25; %.25 working

umax = 5; mu = 5.5; %mu = 8 working umax = 9


Er = 0.42; 
Kg = 70;
km = 7.68e-3;
Mp = 0.127; Lp = 0.337; Lp = 0.337; Jp = 0.0012; g = 9.81;
Bp = 0.0024;r = 0.216;
Jarm = 9.98e-4; mb = 0.0024; Jarm = 0.002; Kenc = 4096;
eta_g = 0.9; eta_m = 0.69; kt = 0.00768; Rm = 2.6;
tau = 5*(eta_g*Kg*eta_m*kt)/(Rm);
Mr = 0.257; Lr = 0.216;
umax_LIM = tau/(Mr*Lr);


% Velocity Filter
s = tf('s');
lp_pole = 50;
vf_cont = lp_pole/(s + lp_pole);
vf_disc = c2d(vf_cont,T,'Tustin');
[numV denV] = tfdata(vf_disc, 'v');
