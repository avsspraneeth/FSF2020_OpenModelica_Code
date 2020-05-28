within Simulator.UnitOperations;

model Valve3"Model of a valve to regulate the pressure of a material stream"
  extends Simulator.Files.Icons.Valve;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Valve Specifications", group = "Component Parameters"));
    parameter Integer Nc = 3 "Number of components" annotation(
    Dialog(tab = "Valve Specifications", group = "Component Parameters"));
    parameter Real x=1;
    parameter Real y=1;
    parameter Real OP=100;  
  //====================================================================================
  Real Fin(unit = "mol/s", min = 0, start = Fg) "Inlet stream molar flow rate";
  Real Pin(unit = "Pa", min = 0, start = Pg) "Inlet stream pressure"; 
  Real Tin(unit = "K", min = 0, start = Tg) "Inlet stream emperature";
  Real Hin(unit = "kJ/kmol",start=Htotg) "Inlet stream molar enthalpy"; 
  Real Sin(unit = "kJ/[kmol.K]") "Inlet stream molar entropy";
  Real xvapin(unit = "-", min = 0, max = 1, start = xvapg) "Inlet stream vapor phase mole fraction"; 
  
  Real Tdel(unit = "K") "Temperature increase";
  Real Pdel(unit = "Pa") "Pressure drop"; 
 
  Real Fout(unit = "mol/s", min = 0, start = Fg) "outlet stream molar flow rate";
  Real Pout(unit = "Pa", min = 0, start = Pg) "Outlet stream pressure";
  Real Tout(unit = "K", min = 0, start = Tg) "Outlet stream temperature";
  Real Hout(unit = "kJ/kmol",start=Htotg) "Outlet stream molar enthalpy";
  Real Sout(unit = "kJ/[kmol.K]")  "Outlet stream molar entropy";
  Real x_c[Nc](each unit = "-", each min = 0, each max = 1,  start = xg) "Component mole fraction";
  Real xvapout(unit = "-", min = 0, max = 1, start = xvapg) "Outlet stream vapor phase mole fraction";
  //

Real mdot(unit="kg/s")"massflowrate";


String Calmode"caluclation mode like kvliq,kvgas";
//
Real Kvc"coefficient of Valve sizing";
Real Kvmax"maximum coefficient of Valve sizing";

//
Real P2ant;
Real v2=1/999.85;
 //////////////////
 Real MW[Nc] (unit="g/mol")" molecular weight of each component";
Real TMW(unit="g/mol")"total molecular weight of mixture";
Real rho(unit="mol/m3")"density of each compound";
Real rho_c[Nc](unit="mol/m3")"total density of mixture";
Real rhovap0(unit="kg/m3")"density of vapor at 273.15K ";

Real rhovap0_c[Nc](unit="kg/m3")"density of each component vapor at 273.15K ";
 //========================================================================================
  //========================================================================================
  Simulator.Files.Interfaces.matConn In(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Files.Interfaces.matConn Out(Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //========================================================================================
  extends GuessModels.InitialGuess;
equation
//connector equations
  In.P = Pin;
  In.T = Tin;
  In.F = Fin;
  In.H = Hin;
  In.S = Sin;
  In.x_pc[1, :] = x_c[:];
  In.xvap = xvapin;
  Out.P = Pout;
  Out.T = Tout;
  Out.F = Fout;
  Out.H = Hout;
  Out.S = Sout;
  Out.x_pc[1, :] = x_c[:];
  Out.xvap = xvapout;
//=============================================================================================
  Fin = Fout;
//material balance
  Hin = Hout;
//energy balance
 // Pin - Pdel = Pout;
//pressure calculation
  Tin + Tdel = Tout;
//temperature calculation
  

  algorithm
  Kvc:=Kvmax*0.01* x * OP^(y);
  rhovap0:=0;
rhovap0_c:=zeros(Nc);
rho:=0;
rho_c:=zeros(Nc);
///////////////////////////////////////////////////
for j in 1:Nc loop
   MW[j]:=C[j].MW*x_c[j];
  end for;
  TMW:=sum(MW);
mdot:=TMW*Fin*0.001;




///////////////////////////////////////////////////



if Calmode=="Kvliq" then
   
    for i in 1:Nc loop
    rho_c[i] := Simulator.Files.ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, Tin, Pin);
  end for;
  rho := ((TMW/ sum(x_c ./ rho_c)))*0.001;
 
   
   
   
   Pout:=(Pin/100000) -( 1/(1000*rho) *(mdot*3600/Kvc)^2);
   Pout:=Pout*100000;
   P2ant:=0;
   Pdel:=Pin-Pout;
  end if ;

if Calmode=="Kvgas" then
    for i in 1:Nc loop
      rhovap0_c[i] := 101325 / (1 * 8.314 * 273.15) * C[i].MW * 1E-3;
    end for;
    rhovap0 := TMW/ sum(MW[ :] ./ rhovap0_c[:]) ;
   
   
    Pout:=Pin*0.7/100000;
      for i in 1:1000 loop
        P2ant:=Pout;
         // P2:=((Pi/100000)-(Ti/rho0/P2ant)*((519*Kvc/(mdot*3600))^(-2)));
         Pout:=((Pin/100000)-(Tin/(rhovap0*P2ant))*(((mdot*3600/(519*Kvc))^2))) ;
        end for;
   Pout:=Pout*100000;
   Pdel:=Pin-Pout;
end if;

/*if Calmode=="Kvst" then
 Pout:=Pin*0.7/100000;
   
      for i in 1:1000 loop
        P2ant:=Pout;
          Pout:=(Pin/100000)-(v2*((mdot*3600)/(Kvc*31.62))^2);
       //  P2:=((Pi/100000)-(Ti/(rho0*P2ant))*(((mdot*3600/(519*Kvc))^2))) ;
        end for;
   Pout:=Pout*100000;
   Pdel:=Pin-Pout;
  end if;*/
    
    
    
    end Valve3;
