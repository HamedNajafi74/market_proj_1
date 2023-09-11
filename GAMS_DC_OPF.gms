$Title "DC OPF" model for Power Market Project by Hamed Najafi

$oneolcom
$eolcom //

sets
bus  /1*15/            //Set of buses from 1 to 15
slack(bus) /1/         // Set of slack bus, containing only bus 1
GenNo /1,2,4,5,6,7,9,10,11,12,14,15/  //Set of generator indices

scalars
Sbase /100/
Vbase /400/
;
alias(bus,node);

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
OF
Pij(bus,node)
Pg(GenNo)
delta(bus)
;

Equations
*********************************************
const1
const2
const3
;
***********************************************************************
const1(bus,node)$( conex(bus,node)) .. Pij(bus,node)=e= branch(bus,node,'bij')*(delta(bus)-delta(node));
const2(bus) .. +sum(GenNo$GBconect(bus,GenNo),Pg(GenNo))-BusData(bus,'pd')/Sbase=e=+sum(node$conex(node,bus),Pij(bus,node));
const3    .. OF=g=sum(GenNo,Pg(GenNo)*GenData(GenNo,'b')*Sbase);

model loadflow     /const1,const2,const3/;

Pg.lo(GenNo)=GenData(GenNo,'Pmin')/Sbase;
Pg.up(GenNo)=GenData(GenNo,'Pmax')/Sbase;
delta.up(bus)=pi;
delta.lo(bus)=-pi;
delta.fx(slack)=0;
Pij.up(bus,node)$((conex(bus,node)))=1* branch(bus,node,'Limit')/Sbase;
Pij.lo(bus,node)$((conex(bus,node)))=-1*branch(bus,node,'Limit')/Sbase;

solve loadflow minimizing OF using lp;
parameter report(bus,*);
report(bus,'Gen(MW)')= sum(GenNo$GBconect(bus,GenNo),Pg.l(GenNo))*sbase;
report(bus,'load(MW)')= BusData(bus,'pd');
report(bus,'LMP($/MWh)')=const2.m(bus)/sbase ;

display report,Pij.l,Pij.m;

