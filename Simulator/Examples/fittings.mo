model fittings

  extends Modelica.Icons.Example;
  import data = Simulator.Files.ChemsepDatabase;
 
  parameter data.Water wat;
  parameter data.Nitrogen nit;
  parameter Integer Nc = 2;
  parameter data.GeneralProperties C[Nc] = { wat,nit};
  Simulator.UnitOperations.joints valve1(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {0, 4}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Simulator.Examples.Valve.ms inlet(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {-74, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Simulator.Examples.Valve.ms outlet(Nc = Nc, C = C) annotation(
    Placement(visible = true, transformation(origin = {71, 3}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
equation
  connect(valve1.Out, outlet.In) annotation(
    Line(points = {{14, 4}, {35, 4}, {35, 3}, {60, 3}}, color = {0, 70, 70}));
  connect(inlet.Out, valve1.In) annotation(
    Line(points = {{-64, 4}, {-14, 4}}, color = {0, 70, 70}));
inlet.x_pc[1, :] = {0.1,0.9};
inlet.P = 101325;

inlet.T = 298.15;
inlet.F_p[1] = 4.34512;
valve1.name="butterflyvalve";
valve1.ID=0.07;

end fittings;
