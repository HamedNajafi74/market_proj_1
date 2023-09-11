gendata=sortrows(table(mpc.gencost(:,end-1),mpc.gen(:,1),mpc.gen(:,9)));
x=zeros(1,size(gendata,1)+1);
y=table2array(gendata(:,1));
for i=2:length(x)
    x(i)=sum(table2array(gendata(1:i-1,end)));
end
x=x./100;
y=[y;y(end)];

figure
l1=stairs(x,y,'-b','LineWidth',2);
xlabel('Total demand (p.u.) (S_{base}=100)')
ylabel('Price ($/MW-hr)')
ylim([0 max(y)*1.1])
grid on
hold on
Total_D=sum(result.gen(:,2));
l2=plot([Total_D Total_D]./100,[0 max(y)],'-r','LineWidth',2);
plot([Total_D]/100,[12],'x','MarkerSize',10)

