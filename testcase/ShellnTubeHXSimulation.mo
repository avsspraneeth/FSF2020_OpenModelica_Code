model ShellnTubeHXSimulation "Calculating outlet temperatures of material stream by specifying the shell and tube side properties in a Heat Exchanger"
extends Modelica.Icons.Example;
import data = Simulator.Files.ChemsepDatabase;
  
   import SI = Modelica.SIunits;
   import Modelica.SIunits.Conversions.*;
  parameter data.Water wat;
  parameter data.Noctane oct;
  parameter data.Nnonane non;
  parameter data.Ndecane dec;
  
  parameter Integer Nc = 4;
  parameter data.GeneralProperties C[Nc] = {wat,oct,non,dec};
  
  Simulator.UnitOperations.HeatExchanger B1( C = C,Cmode = "Design", Mode = "CounterCurrent", Nc = Nc, Pdelc = 0, Pdelh = 0, Qloss = 0) annotation(
    Placement(visible = true, transformation(origin = {-16, -2}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Simulator.Examples.HeatExchanger.MS S1(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {-86, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Examples.HeatExchanger.MS S3(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {68, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Examples.HeatExchanger.MS S2(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {-22, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Examples.HeatExchanger.MS S4(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {46, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
connect(S1.Out, B1.In_Hot) annotation(
    Line(points = {{-76, 38}, {-76, -2}, {-38, -2}}));
connect(B1.Out_Hot, S3.In) annotation(
    Line(points = {{6, -2}, {6, 45}, {58, 45}, {58, 70}}));
connect(B1.Out_Cold, S4.In) annotation(
    Line(points = {{-16, -24}, {-16, -48}, {36, -48}}));
connect(S2.Out, B1.In_Cold) annotation(
    Line(points = {{-12, 64}, {-12, 38}, {-16, 38}, {-16, 20}}));
S1.x_pc[1, :] = {0, 0, 0.1, 0.9};
S2.x_pc[1, :] = {1, 0, 0, 0};
S1.F_p[1] = 212.94371;
S2.F_p[1] = 3077.38424;
S1.T = from_degF(710.67);
S2.T = from_degC(31.111111);
S1.P = 1116948.66173;
S2.P = from_bar(6.0673754464);
annotation(
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Heat Exchanger example where all the components are defined, material stream &amp; heat exchanger specifications are declared, model instances are connected.&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.HeatExchanger\" style=\"font-size: 12px;\">Heat Exchanger</a><span style=\"font-size: 12px;\">&nbsp;model from the UnitOperations package has been instantiated here.</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Material Stream Information</b></div><div><br></div><div><b>Hot Stream</b></div><div><b>Molar Flow Rate:</b>&nbsp;212.94371 mol/s</div><div><b>Mole Fraction (Water):</b>&nbsp;0</div><div><b>Mole Fraction (N-Octane):</b>&nbsp;0</div><div><div><b>Mole Fraction (N-Nonane):</b>&nbsp;0.1</div><div><b>Mole Fraction (N-Decane):</b>&nbsp;0.9</div></div><div><b>Pressure:</b>&nbsp;1116948.66 Pa</div><div><b>Temperature:</b>&nbsp;377.03889 K</div><div><br></div><div><br></div><div><b>Cold Stream</b></div><div><div><b>Molar Flow Rate:</b>&nbsp;3077.38424 mol/s</div><div><div><b>Mole Fraction (Water):</b>&nbsp;1</div><div><b>Mole Fraction (N-Octane):</b>&nbsp;0</div><div><div><b>Mole Fraction (N-Nonane):</b>&nbsp;1</div></div><div><b>Mole Fraction (N-Decane):</b>&nbsp;0</div><div><b>Pressure:</b>&nbsp;606737.54464 Pa</div></div><div><b>Temperature:</b>&nbsp;304.26111 K</div></div></div></body></html>"));
    end ShellnTubeHXSimulation;
