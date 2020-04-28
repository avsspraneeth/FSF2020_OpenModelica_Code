model HeaterSimulation "Heating a three component system by specifying amount of heat added"
  
   import SI = Modelica.SIunits;
   import Modelica.SIunits.Conversions.*;
  extends Modelica.Icons.Example;
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Methanol meth;
  parameter data.Ethanol eth;
  parameter data.Water wat;
  parameter Integer Nc = 3;
  parameter data.GeneralProperties C[Nc] = {meth, eth, wat};
  Simulator.Examples.Heater.MS S1(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {-80, 4}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Simulator.Examples.Heater.MS S2( C = C, Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {20, 8}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Simulator.Streams.EnergyStream E1 annotation(
    Placement(visible = true, transformation(origin = {-75, -35}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
Simulator.UnitOperations.Heater B1(C = C, Eff = 1, Nc = Nc, Pdel = 101325)  annotation(
    Placement(visible = true, transformation(origin = {-30, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(E1.Out, B1.En) annotation(
      Line(points = {{-62, -34}, {-40, -34}, {-40, -4}, {-40, -4}}, color = {255, 0, 0}));
  connect(B1.Out, S2.In) annotation(
      Line(points = {{-20, 6}, {8, 6}, {8, 8}, {8, 8}}, color = {0, 70, 70}));
  connect(S1.Out, B1.In) annotation(
      Line(points = {{-68, 4}, {-40, 4}, {-40, 6}, {-40, 6}}, color = {0, 70, 70}));
  equation
  S1.x_pc[1, :] = {0.33, 0.33, 0.34};
  S1.P = from_bar(2.02650);
  S1.T = from_degC(47);
  S1.F_p[1] = 100;
  B1.Q = from_kWh(0.5555555);
annotation(
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Heater example where all the components are defined, material stream &amp; heater specifications are declared, model instances are connected.&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.Heater\" style=\"font-size: 12px;\">Heater</a><span style=\"font-size: 12px;\">&nbsp;model from the UnitOperations package has been instantiated here.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Methanol):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Ethanol):</b>&nbsp;0.33</div><div style=\"font-size: 12px;\"><b>Mole Fraction (Water):</b>&nbsp;0.34</div><div style=\"font-size: 12px;\"><b>Pressure:</b>&nbsp;202650 Pa</div><div style=\"font-size: 12px;\"><b>Temperature:</b>&nbsp;320 K</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>Heater Specification:</b> Heat added: 2000000 W</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp;Efficiency: 100%</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">				</span>&nbsp;Pressure Drop: 101325 Pa</span></div></body></html>"));
    end HeaterSimulation;
