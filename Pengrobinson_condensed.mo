package pgnew
  model PengRobinson
  pgnew.base1 philiq(Nc = Nc, C = C, P = P, T = T, x = x_pc[2, :], mode = "liq");
    pgnew.base1 phivap(Nc = Nc, C = C, P = P, T = T, x = x_pc[3, :], mode = "vap");
    Real Cpres_p[3] "residual specific heat", Hres_p[3] "residual enthalpy", Sres_p[3] "residual Entropy";
    Real philiqbubl_c[Nc], phivapdew_c[Nc], Pvap_c[Nc];
    Real philiq_c[Nc], phivap_c[Nc];
    Real gmabubl_c[Nc] "Activity coefficent at bubble point";
    Real gmadew_c[Nc] "Activity coefficent at dew point";
    Real K_c[Nc];
    Real gma[Nc];
  equation
    Cpres_p[:] = zeros(3);
    Hres_p[:] = zeros(3);
    Sres_p[:] = zeros(3);
    for i in 1:Nc loop
      philiqbubl_c[i] = 1;
      phivapdew_c[i] = 1;
      gmadew_c[i] = 1;
      gmabubl_c[i] = 1;
      gma[i] = 1;
    end for;
    for i in 1:Nc loop
      Pvap_c[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP, T);
    end for;
    philiq_c = philiq.phi_c;
    phivap_c = phivap.phi_c;
//xliqdew_c i snot there
    for i in 1:Nc loop
      if philiq.phi_c[i] == 0 or phivap.phi_c[i] == 0 then
        K_c[i] = 0;
      else
        K_c[i] = philiq.phi_c[i] / phivap.phi_c[i];
// K_c[i]=1;
      end if;
    end for;
  end PengRobinson;

  
  
  model base1
  parameter Integer Nc;
    parameter Real R = 8.314 "Ideal Gas Constant";
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
    parameter Real kij_c[Nc, Nc](each start = 1) = Simulator.Files.ThermodynamicFunctions.BIPPR(Nc, C.name);
    Real aM, bM;
    Real x[Nc];
    Real aij[Nc, Nc];
    Real b_c[Nc];
    Real A, B;
    Real P, T;
    Real Cc[4];
    Real Z_R[3, 2];
    Real Zs[3];
    Real Zss;
    Real sumx[Nc];
    Real E, F, G, H_c[Nc], I_c[Nc];
    // Real b[Nc] ;
    Real phi_c[Nc];
    String mode;
    Real Tr_c[Nc];
    Real m_c[Nc], q_c[Nc], a_c[Nc];
    extends Simulator.GuessModels.InitialGuess;
    //equation
  equation
    Tr_c = T ./ C.Tc;
    b_c = 0.0778 * R * C.Tc ./ C.Pc;
    m_c = 0.37464 .+ 1.54226 * C.AF .- 0.26992 * C.AF .^ 2;
    q_c = 0.45724 * R ^ 2 * C.Tc .^ 2 ./ C.Pc;
    a_c = q_c .* (1 .+ m_c .* (1 .- sqrt(Tr_c))) .^ 2;
    aij = {{(1 - kij_c[i, j]) * sqrt(a_c[i] * a_c[j]) for i in 1:Nc} for j in 1:Nc};
    aM = sum({{x[i] * x[j] * aij[i, j] for i in 1:Nc} for j in 1:Nc});
    bM = sum(b_c .* x[:]);
    A = aM * P / (R * T) ^ 2;
    B = bM * P / (R * T);
    Cc[1] = 1;
    Cc[2] = B - 1;
    Cc[3] = A - 3 * B ^ 2 - 2 * B;
    Cc[4] = B ^ 3 + B ^ 2 - A * B;
    Z_R = Modelica.Math.Vectors.Utilities.roots(Cc);
    Zs = {Z_R[i, 1] for i in 1:3};
    if mode == "vap" then
      Zss = max({Zs});
    else
      Zss = min({Zs});
    end if;
    sumx = {sum({x[j] * aij[i, j] for j in 1:Nc}) for i in 1:Nc};
//
    if Zss + 2.4142135 * A <= 0 and mode == "vap" then
      E = 1;
    elseif Zss + 2.4142135 * B <= 0 and mode == "liq" then
      E = 1;
    else
      E = Zss + 2.4142135 * B;
    end if;
// change
//
    if Zss - 0.414213 * B <= 0 then
      F = 1;
    else
      F = Zss - 0.414213 * B;
    end if;
//
    if Zss - B <= 0 then
      G = 0;
    else
      G = log(Zss - B);
    end if;
//
    for i in 1:Nc loop
      if bM == 0 then
        H_c[i] = 0;
      else
        H_c[i] = b_c[i] / bM;
      end if;
    end for;
    for i in 1:Nc loop
      if aM == 0 then
        I_c[i] = 0;
      else
        I_c[i] = sumx[i] / aM;
      end if;
    end for;
    phi_c = exp(A / (B * sqrt(8)) * log(E / F) .* (H_c .- 2 * I_c) .+ (Zss - 1) * H_c .- G);
  end base1;
end pgnew;
