clear; clc; close all;
load('alpha_UR_data.mat');
t = alpha_out(:,1); alpha = alpha_out(:,2);
plot(t,alpha); hold on; grid on;
alphaUR = -90 + mod(alpha+90,180);
plot(t,alphaUR);
xlabel('Time (s)'); ylabel('\alpha (deg)');
legend('alpha\_out','alpha\_UR');

%%
clear; clc; close all;
alphaL = 0:.1:720;
t = 0:1:7200;
alphaR = 0:-.1:-720;
alphaUR_L = -180 + mod(alphaL ,360);
alphaUR_R = -180 + mod(alphaR ,360);

a = (abs(alphaL) >= 150); b = (abs(alphaUR_L) <= 30);
switch_cond = a&b;
%%
figure;
plot(t(switch_cond),alphaR(switch_cond));
legend('alphaL','alphaR','alphaUR_L','alphaUR_R');
%%
figure;
scatter(t(switch_cond),alphaR(switch_cond)); hold on;
scatter(t(switch_cond),alphaUR_R(switch_cond));

figure;
scatter(t(switch_cond),alphaL(switch_cond)); hold on;
scatter(t(switch_cond),alphaUR_L(switch_cond));
