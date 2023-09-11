clear
clc
%%
system_case = 'case_Market_Project';
%system_case = 'case_Market_Project_no_4_14';
%system_case = 'case_Market_Project_no_3_8';
mpc=loadcase(system_case);
mpopt=mpoption;
%%
i1=input('PowerFlow Model? AC/DC: ','s');
mpopt=mpoption(mpopt,'model',i1,'opf.flow_lim','P','out.all',1);
%%
branch_limit=mpc.branch(:,6);
bus_l_limit=mpc.bus(:,end);
bus_u_limit=mpc.bus(:,end-1);
i2=input('With/WithoutNetwork Constraints? 1/0: ');
if i2==0
    mpc.branch(:,6:8)=0;
    %mpc.bus(:,end)=0; mpc.bus(:,end-1)=14; %Voltage limits on buses
end
%%
result=runopf(mpc,mpopt);
%printpf(result)
%clc
%%
Visualizing_results
typec=["Without Constraints","With Constraints"];
title("PF: "+i1+" , "+typec(i2+1));
branches_mu=result.branch(:,[1,2,18])