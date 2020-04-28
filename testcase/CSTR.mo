model test1
  extends Modelica.Icons.Example;
  import SI = Modelica.SIunits;
   import Modelica.SIunits.Conversions.*;
  
  import data = Simulator.Files.ChemsepDatabase;
  parameter data.Ethyleneoxide e;
  parameter data.Water w;
  parameter data.Ethyleneglycol eg;
  parameter data.GeneralProperties C[Nc] = {e, w, eg};
  parameter Integer Nc = 3;
  Simulator.UnitOperations.CSTR bmr1(C = C, Mode = "Define_Out_Temperature", Nc = Nc, Phase = 1, Tdef = 350, V = from_litre(1000)) annotation(
    Placement(visible = true, transformation(origin = {25, -3}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Simulator.Examples.CSTR.MS ms1(C = C, Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Examples.CSTR.MS ms2(C = C, Nc = Nc) annotation(
    Placement(visible = true, transformation(origin = {54, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(ms1.Out, bmr1.In) annotation(
    Line(points = {{-40, 0}, {8, 0}, {8, -3}}, color = {0, 70, 70}));
  connect(bmr1.Out, ms2.In) annotation(
    Line(points = {{42, -3}, {44, -3}, {44, 0}}, color = {0, 70, 70}));
  ms1.T = from_degC(46.85);
  ms1.P = from_bar(1.01325);
  ms1.x_pc[1, :] = {0.4, 0.6, 0};
  ms1.F_p[1] = 100;
  annotation(
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the CSTR example where all the components are defined, material stream, CSTR &amp; kinetic reaction specifications are declared, model instances are connected</span><span style=\"font-size: 12px;\">.</span><div><span style=\"font-size: 12px;\"><br></span></div><div><div style=\"font-size: 12px;\"><b>Material Stream Information</b></div><div style=\"font-size: 12px;\"><div><br></div><div><div><b>Molar Flow Rate:</b>&nbsp;27.7778 mol/s</div><div><b>Mole Fraction (Ethylene Oxide):</b>&nbsp;0.4</div><div><b>Mole Fraction (Water):</b>&nbsp;0.6</div><div><b>Mole Fraction (Ethylene Glycol):</b>&nbsp;0</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;320 K</div></div><div><br></div></div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><b>Reaction</b></div><div style=\"font-size: 12px;\">Ethylene Oxide + Water ----&gt; Ethylene Glycol</div><div style=\"font-size: 12px;\"><br></div><span style=\"font-size: 12px;\"><b>CSTR Specification:</b>&nbsp; Reactor Volume: 1 m3</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">			</span>&nbsp; &nbsp; &nbsp; &nbsp;Reactor Outlet Temperature: 350 K</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">			</span>&nbsp; &nbsp; &nbsp; &nbsp;Rate Constant: 0.5</span></div><div><span style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space:pre\">			</span>&nbsp; &nbsp; &nbsp; &nbsp;Reaction Order: 1 (Ethylene Oxide)</span></div></body></html>"));
end test1;
