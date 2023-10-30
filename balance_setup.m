%% SETUP
clear; clc; close all;
T = 0.001;
theta_cal = -(360/4096) * (pi/180);
alpha_cal = -(360/4096) * (pi/180);
tstop = 200;

theta_ref = 0 * 45/180 * pi;
theta_freq = 4;


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

theta_max = 4/180 * pi; alpha_max = 2/180 * pi;
dtheta_max = 12; dalpha_max = 12;
q1 = 1/(theta_max^2); q2 = 1/(alpha_max^2);
q3 = 1/(dtheta_max^2); q4 = 1/(dalpha_max^2);
Q = diag([q1 q2 q3 q4]);

Vmax = 7.5; R = 1/(Vmax^2);
[K_lqr,~,~] = lqr(ss_cont,Q,R)
