model DistillationSimulation "Separating a mixture of Benzene and Toluene using multifeed Distillation Column with total condenser"
  
   import SI = Modelica.SIunits;
   import Modelica.SIunits.Conversions.*;
  
  extends Modelica.Icons.Example;
  parameter Integer Nc = 2;
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Benzene benz;
  parameter data.Toluene tol;
  parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc] = {benz, tol};
  Simulator.Examples.Distillation.MS S1(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {-88, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Examples.Distillation.MS S3(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {40, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Examples.Distillation.MS S4(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {44, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Streams.EnergyStream E1 annotation(
    Placement(visible = true, transformation(origin = {38, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Streams.EnergyStream E2 annotation(
    Placement(visible = true, transformation(origin = {48, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Examples.Distillation.MS S2(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {-86, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Examples.Distillation.DistColumn B1(Nc = Nc, C = C, Nt = 5, Ni = 2, InT_s = {3, 4}) annotation(
    Placement(visible = true, transformation(origin = {-16, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(B1.Rduty, E2.In) annotation(
    Line(points = {{10, -56}, {38, -56}, {38, -56}, {38, -56}}, color = {255, 0, 0}));
  connect(B1.Bot, S4.In) annotation(
    Line(points = {{10, -26}, {34, -26}, {34, -26}, {34, -26}}, color = {0, 70, 70}));
  connect(B1.Dist, S3.In) annotation(
    Line(points = {{10, 34}, {30, 34}, {30, 34}, {30, 34}}, color = {0, 70, 70}));
  connect(B1.Cduty, E1.In) annotation(
    Line(points = {{10, 64}, {28, 64}}, color = {255, 0, 0}));
  connect(S2.Out, B1.In_s[2]) annotation(
    Line(points = {{-76, -26}, {-54, -26}, {-54, 4}, {-40, 4}, {-40, 4}}, color = {0, 70, 70}));
  connect(S1.Out, B1.In_s[1]) annotation(
    Line(points = {{-78, 12}, {-54, 12}, {-54, 4}, {-40, 4}, {-40, 4}}, color = {0, 70, 70}));
  S1.P = from_bar(1.01325);
  S1.T = from_degC(25);
  S1.F_p[1] = 100;
  S1.x_pc[1, :] = {0.5, 0.5};
  B1.condenser.P = from_bar(1.01325);
  B1.reboiler.P = from_bar(1.01325);
  B1.RR = 2;
  S4.F_p[1] = 50;
  S2.P = from_bar(1.01325);
  S2.T = from_degC(25);
  S2.F_p[1] = 100;
  S2.x_pc[1, :] = {0.5, 0.5};
annotation(
    Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-size: 12px;\">This is an executable model to simualate the Distillation Column example where all the components are defined, material stream &amp; column specifications are declared, model instances are connected.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Feed Stream 1</b></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;101325 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;298.15 K</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Feed Stream 2</b></div><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Benzene):</b>&nbsp;0.5</div><div><b>Mole Fraction (Toluene):</b>&nbsp;0.5</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;298.15 K</div></div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Column Specification: </b>No of stages: 5</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp; Feed Stage Location: 3,4</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Condenser Type: Total</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Reflux Ratio: 2</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Bottoms Flow Rate: 50 mol/s</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Condenser Pressure: 101325 Pa</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp; Reboiler Pressure: 101325 Pa</span></div><!--EndFragment--></body></html>"));
    end DistillationSimulation;

 
 
