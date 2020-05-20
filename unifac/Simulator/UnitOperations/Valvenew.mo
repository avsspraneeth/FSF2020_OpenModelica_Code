within Simulator.UnitOperations;

model Valvenew "Model of a valve to regulate the pressure of a material stream"
  extends Simulator.Files.Icons.Valve;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] "Component instances array" annotation(
    Dialog(tab = "Valve Specifications", group = "Component Parameters"));
    parameter Integer Nc = 3 "Number of components" annotation(
    Dialog(tab = "Valve Specifications", group = "Component Parameters"));
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
  //========================================================================================
  

Real mdot=1;
Real rho=1.14508;
Real rho0=1.25;
String Calmode;
Real Kvc;//no need
Real P2ant;//no need
Real v2=1/999.85;
////
Boolean kvrelation;
Real Kvmax;
Real OP;
Real x;
Real y;
String Calimode;
  
  
  
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
if Calimode=="normal" then
  Fin = Fout;
//material balance
  Hin = Hout;
//energy balance
  Pin - Pdel = Pout;
//pressure calculation
  Tin + Tdel = Tout;
//temperature calculation
kvrelation=false;
Kvc=0;
Kvmax=0;
OP=0;
x=0;
y=0;
Calmode="notenabled";
P2ant=0;

end if;
  //////////////////////////////////////////////////////
  
  
algorithm

if Calimode=="K" then
Fout:=Fin;
//material balance
 Hout:=Hin;

if kvrelation then
  Kvc:=Kvmax*x*0.01*OP^y;
  else
  Kvc:=Kvmax;
end if;
if Calmode=="Kvliq" then
   Pout:=(Pin/100000) -( 1/(1000*rho) *(mdot*3600/Kvc)^2);
   Pout:=Pout*100000;
   P2ant:=0;
   
elseif Calmode=="Kvgas" then
    Pout:=Pin*0.7/100000;
      for i in 1:1000 loop
        P2ant:=Pout;
        
         Pout:=((Pin/100000)-(Tin/(rho0*P2ant))*(((mdot*3600/(519*Kvc))^2))) ;
        end for;
   Pout:=Pout*100000;

elseif Calmode=="Kvst" then
 
Pout:=Pin*0.7/100000;
 for i in 1:1000 loop
        //have to include volume
        P2ant:=Pout;
        Pout:=(Pin/100000)-v2*((mdot*3600)/(Kvc*31.62))^2;
        end for;
   Pout:=Pout*100000;
   P2ant:=0;
 end if;

 Pdel := Pin-Pout;
//pressure calculation
  Tdel := Tin-Tout;
//temperature calculation
 
end if;

 
 
  end Valvenew;
