within Simulator.UnitOperations;

model CentrifugalPumpnew "Model of a centrifugal pump to provide energy to liquid stream in form of pressure"
  //===========================================================================
  //Header files and Parameters
  extends Simulator.Files.Icons.CentrifugalPump;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Pump Specifications", group = "Component Parameters"));
  parameter Integer Nc "Number of components" annotation(
    Dialog(tab = "Pump Specifications", group = "Component Parameters"));
  Real Eff(unit = "-") "Efficiency" annotation(
    Dialog(tab = "Pump Specifications", group = "Calculation Parameters"));
  //===========================================================================
  //Model Variables
  Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet stream pressure";
  Real Tin(unit = "K", min = 0, start = Tg) "Inlet stream temperature";
  Real Hin(unit = "kJ/kmol",start=Htotg) "Inlet stream molar enthalpy";
  Real Fin(unit = "mol/s", min = 0, start = Fg) "Inlet stream molar flow";
  Real xin_c[Nc](each unit = "-", each min = 0, each max = 1, start=xg) "Inlet stream components molar fraction";
  Real Tdel(unit = "K") "Temperature increase";
  Real Pdel(unit = "K") "Pressure increase";
  Real Q(unit = "W") "Power required";
  Real rho_c[Nc](each unit = "kmol/m3", each min = 0) "Component molar density";
  Real rho(unit = "mol/m3", min = 0) "Density";
  Real Pvap(unit = "Pa", min = 0, start = Pg) "Vapor pressure of mixture at Outlet temperature";
  Real NPSH(unit = "m") "Net Positive Suction Head";
  Real Pout(unit = "Pa", min = 0, start = Pg) "Outlet stream pressure";
  Real Tout(unit = "K", min = 0, start = Tg) "Outlet stream temperature";
  Real Hout(unit = "kJ/kmol",start=Htotg) "Outlet stream molar enthalpy";
  Real Fout(unit = "mol/s", min = 0, start = Fg) "Outlet stream molar flow";
  Real xout_c[Nc](each unit = "-", each min = 0, each max = 1, start=xg) "Outlet stream molar fraction";

 //---------------------------------
 
  Real qin(unit="m3/s")"input volumetric flowrate";
  Real head(unit="m");
  Real syshead(unit="m");
  Real Power(unit"w");
   
  parameter Integer nop=1"no of points for calmode=Curves";
  parameter Real xhead[nop]=zeros(nop) ;
  parameter Real yhead[nop] = zeros(nop);
  parameter Real xsys[nop]= zeros(nop) ;
  parameter Real ysys[nop]= zeros(nop) ;
  parameter Real xpower[nop]= zeros(nop) ;
  parameter Real ypower[nop]= zeros(nop)  ;
  parameter Real xeff[nop] = zeros(nop) ;
  parameter Real yeff[nop] = zeros(nop) ;
  parameter Real xnpshr[nop]= zeros(nop);
  parameter Real ynpshr[nop]= zeros(nop);
  
  Real effin=0;
  Real MW[Nc]"molecular weight of each component";
  Real TMW(unit="g/mol")"total molecular weight of mixture";
  Real mdot(unit="kg/s")"massflowrate ";
  Real NPSHR(unit="m");
  
  Integer deg=3; 
  //---interpolation varibles
  parameter String CalcMode ;
 //Real index[5];
 Integer flag[5];
 Real sort[5];
Real range"range of input molarflowrate for finding opeation point";
  //============================================================================
  //Instantiation of Connectors
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.enConn En annotation(
    Placement(visible = true, transformation(origin = {2, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  extends GuessModels.InitialGuess;
equation
//============================================================================
//Connector equation
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.x_pc[1, :] = xin_c[:];
 
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout;
  Out.H = Hout;
  Out.x_pc[1, :] = xout_c[:];
  En.Q = Q;
//=============================================================================
//Pump equations
  Fin = Fout;
  xin_c = xout_c;

//=============================================================================
//Calculation of Density
  for i in 1:Nc loop
    rho_c[i] = Simulator.Files.ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, Tin, Pin);
  end for;
  rho = (1 / sum(xin_c ./ rho_c));
  qin=Fin/rho;
//==============================================================================
for j in 1:Nc loop
   MW[j]=C[j].MW*xin_c[j];
  end for;

TMW=sum(MW);
mdot=TMW*Fin*0.001;






////////////////////////////////////////////////////////////


if CalcMode =="Normal" then

  Pin + Pdel = Pout;
  Tin + Tdel = Tout;
  Hout = Hin + Pdel / rho;
  Q = Fin * (Hout - Hin) / Eff;
  head=Hout-Hin;
  syshead=head/Eff;
  Power=Q;
 
NPSHR=0;

end if;


//////////////////////////////////////////////////////////////

if CalcMode =="Curves" then







head= Simulator.Files.Interpolation.interpolant(nop,xhead,yhead,qin,deg);
if xeff[nop]<>0 then
    
  
  Eff= Simulator.Files.Interpolation.interpolant(nop,xeff,yeff,qin,deg);
   else
     effin=Eff ;
    
  end if; 

if  xsys[nop]<>0 then
      
    
      syshead=Simulator.Files.Interpolation.interpolant(nop,xsys,ysys,qin,deg);
    
    else
       syshead= head/(Eff/100);
          
   end if;


  
  Pout=Pin + head * 9.81*rho*TMW*0.001;                                     
  Pdel=Pout-Pin;
  

if xpower[nop]<>0 then
  
    

    Power= Simulator.Files.Interpolation.interpolant(nop,xpower,ypower,qin,deg);
  else
    Power=1000*TMW*Fin*9.81*syshead ;

  end if;
 
 Q=Power;
 Tdel = Tin-Tout;
 Hout = Hin +(Power*Eff)/Fin ;



if xnpshr[nop]<>0 then
   
   NPSHR =Simulator.Files.Interpolation. interpolant(nop,xnpshr,ynpshr,qin,deg); 
  else
   NPSHR=0;
  
  end if;


end if;







//===============================================================================
//Vapor Pressure of mixture at Outlet Temperature
  Pvap = sum(xin_c .* exp(C[:].VP[2] + C[:].VP[3] / Tout + C[:].VP[4] * log(Tout) + C[:].VP[5] .* Tout .^ C[:].VP[6]));
 





 NPSH = (Pin - Pvap) / (rho*9.81*TMW*0.001);   


algorithm

 (sort,flag):= Modelica.Math.Vectors.sort({xeff[nop],xsys[nop],xhead[nop],xpower[nop],xnpshr[nop]});
   for i in 1:5 loop
  if sort[i]<>0 then
   range:=sort[i];
   break;
   
   end if;
 end for;
 

end CentrifugalPumpnew;
