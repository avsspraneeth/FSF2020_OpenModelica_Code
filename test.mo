package test
  model CoolerSimulation "Cooling a three component system by specifying the amount of heat removed"
  extends Modelica.Icons.Example;
    //use non linear solver hybrid to simulate this model
    import data = Simulator.Files.ChemsepDatabase;
    parameter data.Methanol meth;
    parameter data.Ethanol eth;
    parameter data.Water wat;
    parameter Integer Nc = 3;
    parameter data.GeneralProperties C[Nc] = {meth, eth, wat};
    Simulator.UnitOperations.Cooler B1(Pdel = 0, Eff = 1, Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-8, 18}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
    Simulator.Examples.Cooler.MS S1(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-72, 18}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    Simulator.Examples.Cooler.MS S2(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {60, 12}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
    Simulator.Streams.EnergyStream E1 annotation(
      Placement(visible = true, transformation(origin = {47, -27}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  equation
    connect(B1.En, E1.In) annotation(
      Line(points = {{6, 4}, {6, -27}, {34, -27}}, color = {255, 0, 0}));
    connect(B1.Out, S2.In) annotation(
      Line(points = {{6, 18}, {26, 18}, {26, 12}, {48, 12}}));
    connect(S1.Out, B1.In) annotation(
      Line(points = {{-60, 18}, {-22, 18}}));
  equation
    S1.x_pc[1, :] = {0.33, 0.33, 0.34};
    S1.P = 101325;
    S1.T = 353;
    S1.F_p[1] = 100;
    B1.Q = 200000;
    annotation(
      Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">This is an executable model to simualate the Cooler example where all the components are defined, material stream &amp; cooler specifications are declared, model instances are connected.&nbsp;</span><a href=\"modelica://Simulator.UnitOperations.Cooler\" style=\"font-size: 12px;\">Cooler</a><span style=\"font-size: 12px;\">&nbsp;model from the UnitOperations package has been instantiated here.</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><div><b>Material Stream Information</b></div><div><br></div><div><b>Molar Flow Rate:</b>&nbsp;100 mol/s</div><div><b>Mole Fraction (Methanol):</b>&nbsp;0.33</div><div><b>Mole Fraction (Ethanol):</b>&nbsp;0.33</div><div><b>Mole Fraction (Water):</b>&nbsp;0.34</div><div><b>Pressure:</b>&nbsp;101325 Pa</div><div><b>Temperature:</b>&nbsp;353 K</div><div><br></div><b>Cooler Specification:</b>&nbsp;Heat removed: 2000000 W</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp;Efficiency: 100%</div><div style=\"font-size: 12px;\"><span class=\"Apple-tab-span\" style=\"white-space: pre;\">				</span>&nbsp;Pressure Drop: 0 Pa</div></body></html>"));
  end CoolerSimulation;
end test;
