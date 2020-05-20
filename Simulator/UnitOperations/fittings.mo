within Simulator.UnitOperations;

model fittings 
 
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
 Real x_cl[Nc](each unit = "-", each min = 0, each max = 1,  start = xg) "Component mole fraction";
  Real x_cg[Nc](each unit = "-", each min = 0, each max = 1,  start = xg) "Component mole fraction";
  Real xvapout(unit = "-", min = 0, max = 1, start = xvapg) "Outlet stream vapor phase mole fraction";
  //========================================================================================

Real resv[2](each unit = "-");
Real dph (unit="Pa");
Real dpf;
Real Qvin(unit = "m3/s");
Real Qlin(unit="m3/s");
Real rho_l(unit="kg/m3");
Real rho_v(unit="kg/m3");
Real liqvel(unit="m/s");
Real gasvel(unit ="m/s");
Real ID(unit="m");
String name;
Real rho_cl[Nc](each unit ="kg/m3");
Real MWl[Nc],TMWl;
Real mdotl(unit="kg/s");
Real rho_cg[Nc](each unit ="kg/m3");
Real MWg[Nc],TMWg;
Real mdotg(unit="kg/s");
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
  In.x_pc[2,:]= x_cl[:];
  In.x_pc[3,:]= x_cg[:];
//  In.Fm_pc[2,:] = fmpc[:];
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
///////////////////////////////////////
for j in 1:Nc loop
   MWl[j]=C[j].MW*x_cl[j];
  end for;

TMWl=sum(MWl);



for i in 1:Nc loop
    rho_cl[i] = Simulator.Files.ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, Tin, Pin);
  end for;
  rho_l = (1 / sum(x_cl./ rho_cl))*0.001*TMWl;
  mdotl=TMWl*Fin*0.001*(1-xvapin);
///////////////////////////////////////
for j in 1:Nc loop
   MWg[j]=C[j].MW*x_cg[j];
  end for;

TMWg=sum(MWg);


/*for i in 1:Nc loop
    rho_cg[i] = Simulator.Files.ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, Tin, Pin);
  end for;
  rho_v = (1 / sum(x_cg./ rho_cg))*0.001*TMWl;
  mdotg=TMWg*Fin*0.001*(xvapin);*/
///////////////////
 for  i in 1:Nc loop
      rho_cg[i] = Pin/ (1 * 8.314 * Tin) * C[i].MW * 1E-3;
    end for;
    rho_v = TMWg/ sum(MWg./ rho_cg) ;
    mdotg=TMWg*Fin*0.001*(xvapin);
///////////////////////////////
Qlin=mdotl/rho_l;
Qvin=mdotg/rho_v;
liqvel=Qlin/((22/7)*(ID^2)*0.25);
gasvel=Qvin/((22/7)*(ID^2)*0.25);
algorithm
if name=="elbow90dg" then
resv[1]:=30;
resv[2]:=1;
end if ;
if name=="elbow45dg" then
resv[1]:=16;
resv[2]:=1;
end if ;

if name=="elbow180dg" then
resv[1]:=50;
resv[2]:=1;
end if ;
if name=="anglevalve" then
resv[1]:=55;
resv[2]:=1;
end if ;
if name=="butterflyvalve" then //2 to 14 inches
resv[1]:=40;
resv[2]:=1;
end if ;
if name=="ballvalve" then
resv[1]:=3;
resv[2]:=1;
end if ;

if name=="gatevalve" then //open
resv[1]:=8;
resv[2]:=1;
end if ;
if name=="globevalve" then
resv[1]:=340;
resv[2]:=1;
end if ;
if name=="liftcheckvalve" then
resv[1]:=600;
resv[2]:=1;
end if ;
if name=="poppetdiscvalve" then
resv[1]:=420;
resv[2]:=1;
end if ;
if name=="swingcheckvalve" then
resv[1]:=100;
resv[2]:=1;
end if ;

if name=="ballcheckvalve" then
resv[1]:=400;
resv[2]:=1;
end if ;



if name=="tee" then//branched blanked 
resv[1]:=20;
resv[2]:=1;
end if ;
if name=="tee" then//elbow
resv[1]:=60;
resv[2]:=1;
end if ;

if name=="quickreduction(d/D=1/2)" then
resv[1]:=9.6;
resv[2]:=0;
end if ;

if name=="quickreduction(d/D=1/4)" then
resv[1]:=96;
resv[2]:=0;
end if ;
if name=="quickreduction(d/D=3/4)" then
resv[1]:=11;
resv[2]:=0;
end if ;
if name=="borderinlet" then
resv[1]:=0.25;
resv[2]:=0;
end if ;
if name=="normalinlet" then
resv[1]:=0.78;
resv[2]:=0;
end if ;
if name=="quickexpansion(d/D=1/2)" then
resv[1]:=9;
resv[2]:=0;
end if ;
if name=="quickexpansion(d/D=1/4)" then
resv[1]:=225;
resv[2]:=0;
end if ;
if name=="quickexpansion(d/D=3/4)" then
resv[1]:=0.6;
resv[2]:=0;
end if ;
if name=="bend90dg" then
resv[1]:=60;
resv[2]:=1;
end if ;
if name=="normalreduction(2:1)" then
resv[1]:=5.67;
resv[2]:=0;
end if ;
if name=="normalreduction(4:3)" then
resv[1]:=0.65;
resv[2]:=0;
end if ;
if name=="borderexit" then
resv[1]:=1;
resv[2]:=0;
end if ;
if name=="normalexit" then
resv[1]:=1;
resv[2]:=0;
end if ;











if resv[2]==1 then
  dph:=0;
dpf:= resv[1]*(0.0101*(ID)^(-0.2232))*(((Qlin*rho_l)/(Qlin+Qvin)) + (Qvin*rho_v)/(Qlin+Qvin)) *( (liqvel+gasvel)^2)*0.5;
else 
dph:=0;
dpf:=resv[1]*(((Qlin*rho_l)/(Qlin+Qvin)) + (Qvin*rho_v)/(Qlin+Qvin)) *( (liqvel+gasvel)^2)*0.5;


end if;
 
    Pdel:=dpf;
    Pout:=Pin-dpf;
    end fittings;
