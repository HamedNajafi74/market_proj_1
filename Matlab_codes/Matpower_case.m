function mpc = case_Market_Project
mpc.version = '2';        %% MATPOWER Case Format : Version 2
mpc.baseMVA = 100;  %% system MVA base
%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [ %% (Pd and Qd are specified in MW & MVAr here)
    1	3	100	20.30586606	0	0	1	1	0	400	1	1	1;
    2	2	100	20.30586606	0	0	1	1	0	400	1	1	1;
    3	2	200	40.61173213	0	0	1	1	0	400	1	1	1;
    4	2	100	20.30586606	0	0	1	1	0	400	1	1	1;
    5	2	100	20.30586606	0	0	1	1	0	400	1	1	1;
    6	2	100	25.06236244	0	0	2	1	0	400	1	1	1;
    7	2	100	25.06236244	0	0	2	1	0	400	1	1	1;
    8	2	200	50.12472487	0	0	2	1	0	400	1	1	1;
    9	2	100	25.06236244	0	0	2	1	0	400	1	1	1;
    10	2	100	25.06236244	0	0	2	1	0	400	1	1	1;
    11	2	100	14.24922826	0	0	3	1	0	400	1	1	1;
    12	2	100	14.24922826	0	0	3	1	0	400	1	1	1;
    13	2	200	28.49845652	0	0	3	1	0	400	1	1	1;
    14	2	100	14.24922826	0	0	3	1	0	400	1	1	1;
    15	2	100	14.24922826	0	0	3	1	0	400	1	1	1;];

%% Bus Vm limits
mpc.bus(:,end) = 0.95.*ones(1,15);
mpc.bus(:,end-1) = 1.05.*ones(1,15);
%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
    1	0	0	inf	-inf	1	100	1	450	0	0	0	0	0	0	0	0	0	0	0	0;
    2	0	0	inf	-inf	1	100	1	300	0	0	0	0	0	0	0	0	0	0	0	0;
    4	0	0	inf	-inf	1	100	1	600	0	0	0	0	0	0	0	0	0	0	0	0;
    5	0	0	inf	-inf	1	100	1	450	0	0	0	0	0	0	0	0	0	0	0	0;
    6	0	0	inf	-inf	1	100	1	450	0	0	0	0	0	0	0	0	0	0	0	0;
    7	0	0	inf	-inf	1	100	1	300	0	0	0	0	0	0	0	0	0	0	0	0;
    9	0	0	inf	-inf	1	100	1	600	0	0	0	0	0	0	0	0	0	0	0	0;
    10	0	0	inf	-inf	1	100	1	450	0	0	0	0	0	0	0	0	0	0	0	0;
    11	0	0	inf	-inf	1	100	1	450	0	0	0	0	0	0	0	0	0	0	0	0;
    12	0	0	inf	-inf	1	100	1	300	0	0	0	0	0	0	0	0	0	0	0	0;
    14	0	0	inf	-inf	1	100	1	600	0	0	0	0	0	0	0	0	0	0	0	0;
    15	0	0	inf	-inf	1	100	1	450	0	0	0	0	0	0	0	0	0	0	0	0;];
mpc.gen(:,2)=250.*ones(1,12);
%% Generator bus Vm fixed at 1 pu
mpc.bus(mpc.gen(:,1),end-1:end)=1;
%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [  %% (r and x specified in p.u. here, Rates are  in p.u. here and converted to MW below)
    1	2	0.002085	0.020851	0	1	1	1	0	0	1	-360	360;
    1	3	0.002424	0.024241	0	1.5	1.5	1.5	0	0	1	-360	360;
    2	3	0.002424	0.024241	0	1.5	1.5	1.5	0	0	1	-360	360;
    3	4	0.00695     0.069502	0	4	4	4	0	0	1	-360	360;
    4	5	0.00695 	0.069502	0	4	4	4	0	0	1	-360	360;
    6	7	0.002085	0.020851	0	1	1	1	0	0	1	-360	360;
    6	8	0.002424	0.024241	0	1.5	1.5	1.5	0	0	1	-360	360;
    7	8	0.002424	0.024241	0	1.5	1.5	1.5	0	0	1	-360	360;
    8	9	0.00695     0.069502	0	4	4	4	0	0	1	-360	360;
    9	10	0.00695     0.069502	0	4	4	4	0	0	1	-360	360;
    11	12	0.002085	0.020851	0	1	1	1	0	0	1	-360	360;
    11	13	0.002424	0.024241	0	1.5	1.5	1.5	0	0	1	-360	360;
    12	13	0.002424	0.024241	0	1.5	1.5	1.5	0	0	1	-360	360;
    13	14	0.00695     0.069502	0	4	4	4	0	0	1	-360	360;
    14	15	0.00695     0.069502	0	4	4	4	0	0	1	-360	360;
    3	8	0.00695     0.069502	0	2	2	2	0	0	1	-360	360;
    4	14	0.00695     0.069502	0	2	2	2	0	0	1	-360	360;
    9	13	0.00695     0.069502	0	2	2	2	0	0	1	-360	360;];
mpc.branch(:,6:8)=100.*mpc.branch(:,6:8);
%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
    2	0	0	2	5	0;
    2	0	0	2	6	0;
    2	0	0	2	12	0;
    2	0	0	2	8	0;
    2	0	0	2	13	0;
    2	0	0	2	11	0;
    2	0	0	2	21	0;
    2	0	0	2	18	0;
    2	0	0	2	22	0;
    2	0	0	2	23	0;
    2	0	0	2	25	0;
    2	0	0	2	26	0;
    ];
%% convert branch impedances from Ohms to p.u.
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
    TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;

Vbase = mpc.bus(1, BASE_KV) * 1e3;      %% in Volts
Sbase = mpc.baseMVA * 1e6;                  %% in VA
