clear
clc
close all
%%
load dc0_ac0_compare.mat
%%
% income
figure
hold on
grid on
plot(gen,dc(:,2),'-x','LineWidth',1.5);
plot(gen,ac(:,2),'-o','LineWidth',1.5);
xlim([0 16])
xticks(gen)
ylim([0 6000])
yticks(0:500:6000)
legend('DC OPF','AC OPF','Location','best')
xlabel('Generator Number')
ylabel('Generation Income ($)')
text(gen,dc(:,2),strcat([' '],[num2str(dc(:,1))]),'horiz','left','vert','bottom')
text(gen,ac(:,2),strcat([' '],[num2str(ac(:,1))]),'horiz','right','vert','bottom')

% profit
figure
hold on
grid on
plot(gen,dc(:,end),'-x','LineWidth',1.5);
plot(gen,ac(:,end),'-o','LineWidth',1.5);
xlim([0 16])
xticks(gen)
ylim([0 3500])
yticks(0:250:3500)
legend('DC OPF','AC OPF','Location','best')
xlabel('Generator Number')
ylabel('Generation Profit ($)')

text(gen,dc(:,end),strcat([' '],[num2str(dc(:,1))]),'horiz','left','vert','bottom')
text(gen,ac(:,end),strcat([' '],[num2str(ac(:,1))]),'horiz','right','vert','bottom')

% profit per MW
figure
hold on
grid on
plot(gen,dc(:,end)./dc(:,1),'-x','LineWidth',1.5);
plot(gen,ac(:,end)./ac(:,1),'-o','LineWidth',1.5);
xlim([0 8])
xticks(gen)
ylim([0 7.5])
% yticks(0:250:3500)
legend('DC OPF','AC OPF','Location','best')
xlabel('Generator Number')
ylabel('Profit per Production ($/MW)')

text(gen,dc(:,end)./dc(:,1),strcat([' '],[num2str(dc(:,1))]),'horiz','left','vert','bottom')
text(gen,ac(:,end)./ac(:,1),strcat([' '],[num2str(ac(:,1))]),'horiz','right','vert','bottom')