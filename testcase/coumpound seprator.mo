model CompSepSimulation "Separating two component system by specifying material balance"
  
   import SI = Modelica.SIunits;
   import Modelica.SIunits.Conversions.*;
  extends Modelica.Icons.Example;
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Benzene benz;
  parameter data.Toluene tol;
   parameter Integer Nc = 2;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] = {benz, tol};
  Simulator.Examples.CompoundSeparator.MS S1( C = C,Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-82, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Examples.CompoundSeparator.MS S2( C = C,Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {64, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Examples.CompoundSeparator.MS S3( C = C,Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {66, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Streams.EnergyStream E1 annotation(
    Placement(visible = true, transformation(origin = {-40, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.UnitOperations.CompoundSeparator B1( C = C,Nc = Nc, SepFact_c = {"Molar_Flow", "Mass_Flow"}, SepStrm = 1) annotation(
    Placement(visible = true, transformation(origin = {-20, 8}, extent = {{-10, -20}, {10, 20}}, rotation = 0)));
equation
connect(S1.Out, B1.In) annotation(
    Line(points = {{-72, -2}, {-43, -2}, {-43, 8}, {-32, 8}}));
connect(B1.Out1, S2.In) annotation(
    Line(points = {{-8, 14}, {22, 14}, {22, 18}, {54, 18}}));
connect(B1.Out2, S3.In) annotation(
    Line(points = {{-8, 3}, {26, 3}, {26, -20}, {56, -20}}));
connect(E1.Out, B1.En) annotation(
    Line(points = {{-30, -50}, {-20, -50}, {-20, -5}}, color = {255, 0, 0}));
  S1.P = from_bar(1.01325);
  S1.T = from_degC(25);
  S1.x_pc[1, :] = {0.5, 0.5};
  S1.F_p[1] = 100;
B1.SepVal_c = {20, from_gps(1500000)};
annotation(
    Documentation(info = "<html><head></head><body><div style=\"font-size: 12px;\">Following problem statement is simulated in this&nbsp;<b>Compound Separator</b>&nbsp;example</div><div style=\"font-size: 12px;\"><b><br></b></div><b style=\"font-size: 12px;\">Component System:</b><span style=\"font-size: 12px;\">&nbsp;Benzene, Toluene</span><div style=\"font-size: 12px;\"><b>Thermodynamics:</b>&nbsp;Raoult's Law</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div><div><br></div><div><br></div><div><div><span style=\"font-size: 12px;\"><b>Compound Separator Specification:</b>&nbsp;Specified Outlet Stream: 1</span></div></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">							</span>Molar Flow Rate of Benzene: 20 mol/s</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">							</span>Mass Flow Rate of Toluene: 1500 kg/s</span></div><div><span style=\"font-size: 12px;\"><br></span></div></body></html>"));
end CompSepSimulation;
