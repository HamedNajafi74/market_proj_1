close all

s=mpc.branch(:,1);
t=mpc.branch(:,2);

wp=round(result.branch(:,14),1);
w=wp(:,1);
w=w./100;
w(w==0)=1e-8;

arrow_pos=w;
arrow_pos(1:length(s))=0.5;
for i=1:length(s)
    if i1=="AC"
        arrow_pos(i)=0.3;
    end
    if sign(w(i))==-1
        temp=s(i);
        s(i)=t(i);
        t(i)=temp;
        if i1=="AC"
            arrow_pos(i)=0.9;
        end
    end
end
w=abs(w);
clear i temp

bus_no=15;
eq(1:bus_no,1)="=";

vbp=result.bus(:,8);
if i1=="DC"
    names=string((1:bus_no)');
else
    names=string((1:bus_no)')+string(char(eq))+string(round(vbp(:,1),2));
end


%NG=graph(s,t);
%NGn=graph(s,t,w,names);

G = digraph(s,t,w,names);

c=zeros(length(s),3);
st=[s,t];
st_sorted=table2array(sortrows(table(s,t)));

for k=1:length(s)
    row=find(st(:,1)==st_sorted(k,1) & st(:,2)==st_sorted(k,2));
    %st(row,:)
    i=row;
     if abs(w(i))>branch_limit(i)/100
        c(i,:)=[1 0 0]; %red
    elseif abs(w(i))==branch_limit(i)/100
        c(i,:)=[0 0 0]; %black
    else
        c(i,:)=[0 1 0]; %green
     end
    
end
temp=sortrows(table(s,t,wp,w,branch_limit./100,c,(arrow_pos)));
c=table2array(temp(:,6));
arrow_pos=table2array(temp(:,7));
clear temp
G.Edges.EdgeColors=c;

%sortrows(table(s,t,wp,w,branch_limit./100,c))

% figure
% h1 = plot(G,'Layout','force3','EdgeLabel',G.Edges.Weight,'MarkerSize',6,'LineStyle','-','LineWidth',2,'NodeFontSize',10,'ArrowSize',15,'EdgeFontSize',10,'EdgeFontAngle','normal','EdgeColor',c);
% 
% figure
% h2 = plot(G,'Layout','circle','EdgeLabel',G.Edges.Weight,'MarkerSize',6,'LineStyle','-','LineWidth',2,'NodeFontSize',10,'ArrowSize',15,'EdgeFontSize',10,'EdgeFontAngle','normal','EdgeColor',c);

figure
h3 = plot(G,'Layout','circle','EdgeLabel',G.Edges.Weight,'MarkerSize',6,'LineStyle','-','LineWidth',2,'NodeFontSize',10,'ArrowSize',15,'EdgeFontSize',10,'EdgeFontAngle','normal','EdgeColor',c,'ArrowPosition',arrow_pos);

if system_case == "case_Market_Project" | system_case == "case_Market_Project_no_4_14"
    X=[1 0 1 3 3 0 1 1 2 2 3.5 5 5 6 7];
    Y=[11 9 9 9 11 4 2 4 4.7 6 1.5 0 2 3 2];
    X=X+0.7;
    X([2,6])=0;
    Y([1:5])=Y([1:5])+0.5;
    
    
    h3.XData = X;
    h3.YData = Y;
end

%%
genbus=result.gen(:,1);
Pg=result.gen(:,2);
genmc=result.gencost(:,5);
LAM_P=result.bus(:,end-3);
LAM_P_gen=LAM_P(result.gen(:,1));
income=Pg.*LAM_P_gen;
expen=Pg.*genmc;
prof=income-expen;
dis_table = table(genbus,Pg,genmc,LAM_P_gen,income,expen,prof,...
                'VariableNames',{'Gen_Bus','Pg','MC','λp','Income','Cost','Profit'})
total_generation=sum(dis_table.Pg)
total_gen_income=sum(dis_table.Income)
total_gen_expen=sum(dis_table.Cost)
total_gen_profit=sum(dis_table.Profit)
LMP_table= table((1:length(LAM_P))',LAM_P,...
                'VariableNames',{'Bus','λp'})
 
if i1=="AC"
    figure
    plot((1:bus_no),round(vbp(:,1),2))
end

if i1=="AC"
    figure
    plot((1:bus_no),100.*ones(1,15),'b--','LineWidth',1);
    hold on
    plot((1:bus_no),LAM_P./12.*100,'r-','LineWidth',1.5)
    grid on
    xlim([0 16])
    xticks([1:15])
    ylim(100.*[0.94 1.16])
    %yticks(100+sort(((LAM_P-12)./12.*100)))
    xlabel('Bus Number')
    ylabel('Energy Price (% of 12 $/MW-hr)')
    legend('π_{DC}','π_{AC}','Location','best')
end




