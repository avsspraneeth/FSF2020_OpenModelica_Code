package UNIFAC_eg
  model ms
    extends Simulator.Streams.MaterialStream;
    extends Simulator.Files.ThermodynamicPackages.UNIFACnew.UNIFAC2;
    //extends Simulator.Files.ThermodynamicPackages.RaoultsLaw;
  end ms;

  model msUNIFAC
  import data = Simulator.Files.ChemsepDatabase;
    parameter Integer Nc = 2;
    parameter data.Hydrogenchloride hcl;
    parameter data.Water wat;
    parameter data.GeneralProperties C[Nc] = {hcl, wat};
    UNIFAC_eg.ms FEED(Nc = Nc, C = C) annotation(
      Placement(visible = true, transformation(origin = {-38, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    FEED.P = 101325;
    FEED.T = 298.15;
    FEED.F_p[1] = 100;
    FEED.x_pc[1, :] = {0.5, 0.5};
  end msUNIFAC;
end UNIFAC_eg;
