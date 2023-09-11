$Title "DC OPF with reserve" model for Power Market Project by Hamed Najafi

$oneolcom
$eolcom //

sets
bus  /1*15/         //Set of buses from 1 to 15
slack(bus) /1/      // Set of slack bus, containing only bus 1
GenNo /1,2,4,5,6,7,9,10,11,12,14,15/   //Set of generator indices

********** For Reserve market ***********
ReserveGenNo(GenNo) /4,5,9,10,14,15/  // Set of generator indices for reserve-providing units
scalars
Sbase /100/  //Base power value in megawatts (MW)
Vbase /400/  //Base voltage value in kilovolts (kV)

********** For Reserve market ***********
SpinningReserveRequired /180/             //Required spinning reserve in megawatts (MW)
SpinningReserveFraction /3/              //Fraction of spinning reserve capacity required (percentage)
SpinningReserveCapacityFraction /30/    //Fraction of generator's capacity available for spinning reserve (percentage)

;
alias(bus,node);   //Alias declaration for bus and node

table GenData(GenNo,*)  Generating units characteristics
         b     pmin      pmax
1        5        0        450
2        6        0        300
4        12       0        600
5        8        0        450
6        13       0        450
7        11       0        300
9        21       0        600
10       18       0        450
11       22       0        450
12       23       0        300
14       25       0        600
15       26       0        450
;

* -----------------------------------------------------
set GBconect(bus,GenNo) connectivity index of each generating unit to each bus
/        1        .        1
         2        .        2
         4        .        4
         5        .        5
         6        .        6
         7        .        7
         9        .        9
         10        .       10
         11        .       11
         12        .       12
         14        .       14
         15        .       15/ ;
****************************************************
****************************************************
Table BusData(bus,*) Demands of each bus in MW
         Pd
1        100
2        100
3        200
4        100
5        100
6        100
7        100
8        200
9        100
10       100
11       100
12       100
13       200
14       100
15       100
;
****************************************************
set conex          Bus connectivity matrix
/
1        .        2
1        .        3
2        .        3
3        .        4
4        .        5
6        .        7
6        .        8
7        .        8
8        .        9
9        .        10
11        .       12
11        .       13
12        .       13
13        .       14
14        .       15
3        .        8
4        .        14
9        .        13
* -----------------------------------------------------
/;
conex(bus,node)$(conex(node,bus))=1;

table branch(bus,node,*)    Network technical characteristics
                              x           Limit
1        .        2        0.020851        100
1        .        3        0.024241        150
2        .        3        0.024241        150
3        .        4        0.069502        400
4        .        5        0.069502        400
6        .        7        0.020851        100
6        .        8        0.024241        150
7        .        8        0.024241        150
8        .        9        0.069502        400
9        .        10       0.069502        400
11        .       12       0.020851        100
11        .       13       0.024241        150
12        .       13       0.024241        150
13        .       14       0.069502        400
14        .       15       0.069502        400
3        .        8        0.069502        200
4        .       14        0.069502        200
9        .       13        0.069502        200
* -----------------------------------------------------
;

branch(bus,node,'x')$(branch(bus,node,'x')=0)=branch(node,bus,'x');
branch(bus,node,'Limit')$(branch(bus,node,'Limit')=0)=branch(node,bus,'Limit');
branch(bus,node,'bij')$conex(bus,node) =1/branch(bus,node,'x');
*****************************************************
Variables
OF                Objective function value
Pij(bus,node)     Power flow from bus to node
Pg(GenNo)         Power generation of each generator
delta(bus)        Phase angle at each bus
Reserve(GenNo)    Reserve provided by each generator
;

Equations
*********************************************
const1  //DC LF Equation
const2  //Load Balance Constraint at each bus
const3  //OF=sum(Pgi*bi)+sum(Rj*b_Rj) : bi:cost of Pi , b_Rj:cost of b_Rj //P(p.u.),R(MW)

********** For Reserve market ***********
const4  // sum of Reserves is equal to the required spinning reserve
const5  // Ri<=Ri_max
const6  // Ri+Pi<=Pi_max
;
***********************************************************************
const1(bus,node)$( conex(bus,node)) .. Pij(bus,node)=e= branch(bus,node,'bij')*(delta(bus)-delta(node));
const2(bus) .. +sum(GenNo$GBconect(bus,GenNo),Pg(GenNo))-BusData(bus,'pd')/Sbase=e=+sum(node$conex(node,bus),Pij(bus,node));
const3    .. OF=g=sum(GenNo,Pg(GenNo)*GenData(GenNo,'b')*Sbase)+sum(ReserveGenNo, Reserve(ReserveGenNo) * (GenData(ReserveGenNo, 'b') / SpinningReserveFraction));

********** For Reserve market ***********
const4.. sum(ReserveGenNo, Reserve(ReserveGenNo)) =e= SpinningReserveRequired;
const5(ReserveGenNo).. Reserve(ReserveGenNo) =l=(GenData(ReserveGenNo,'pmax'))*SpinningReserveCapacityFraction/100;
const6(ReserveGenNo).. Reserve(ReserveGenNo) + Pg(ReserveGenNo) * Sbase =l= GenData(ReserveGenNo, 'pmax');
***********************************************************************
model loadflow     /const1, const2, const3,const4, const5, const6/;

Pg.lo(GenNo)=GenData(GenNo,'Pmin')/Sbase;  //Pi>=Pi_min
Pg.up(GenNo)=GenData(GenNo,'Pmax')/Sbase;  //Pi<=Pi_max
delta.up(bus)=pi;                          //delta_i<=pi
delta.lo(bus)=-pi;                         //delta_i>=-pi
delta.fx(slack)=0;                         //delta_slack<=0
Pij.up(bus,node)$((conex(bus,node)))=1* branch(bus,node,'Limit')/Sbase; //line limit
Pij.lo(bus,node)$((conex(bus,node)))=-1*branch(bus,node,'Limit')/Sbase; //line limit

********** For Reserve market ***********
Reserve.lo(ReserveGenNo)=0;   //Ri>=0
************************************************************************
solve loadflow minimizing OF using LP;
************************************************************************
parameter report(bus,*);
report(bus,'Gen(MW)')= sum(GenNo$GBconect(bus,GenNo),Pg.l(GenNo))*Sbase;
report(bus,'load(MW)')= BusData(bus,'pd');
report(bus,'LMP($/MWh)')=const2.m(bus)/Sbase;

********** For Reserve market ***********
report(bus,'SR(MW)') = sum(ReserveGenNo$GBconect(bus,ReserveGenNo), Reserve.l(ReserveGenNo));
report(bus,'SRmax(MW)') = sum(ReserveGenNo$GBconect(bus,ReserveGenNo),GenData(ReserveGenNo, 'pmax')*SpinningReserveCapacityFraction/100);
report(bus,'SR+Gen(MW)')= sum(GenNo$GBconect(bus,GenNo),Pg.l(GenNo))*Sbase+sum(ReserveGenNo$GBconect(bus,ReserveGenNo), Reserve.l(ReserveGenNo));
report(bus,'Pmax(MW)') = sum(ReserveGenNo$GBconect(bus,ReserveGenNo),GenData(ReserveGenNo, 'pmax'));
***********************************************************************
display report,Pij.l,Pij.m, Reserve.l,Pg.l;
