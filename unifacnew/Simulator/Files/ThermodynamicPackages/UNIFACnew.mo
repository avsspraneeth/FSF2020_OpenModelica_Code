within Simulator.Files.ThermodynamicPackages;

package UNIFACnew
  model UNIFAC2
    //new varibles
    Real gma_c[Nc], gmabubl_c[Nc], gmadew_c[Nc];
    Real Cpres_p[3], Hres_p[3], Sres_p[3];
    Real K_c[Nc];
    Real Pvap_c[Nc];
    Real philiqbubl_c[Nc], phivapdew_c[Nc];
    ///
    // Real Psat[Nc];
    //Real gamma[Nc];
    //Real K[Nc];
    //Fugacity coefficient  at the Bubble and Dew Points
    // Real liqfugcoeff_bubl[Nc], vapfugcoeff_dew[Nc];
    //Excess Energy Properties
    // Real resMolSpHeat[3], resMolEnth[3], resMolEntr[3];
    //Activity Coefficient at the Bubble and Dew Points
    //Real gammaBubl[Nc], gammaDew[Nc](each start = 1.5);
  equation
    Cpres_p = zeros(3);
    Hres_p = zeros(3);
    Sres_p = zeros(3);
    for i in 1:Nc loop
      Pvap_c[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP, T);
// Psat[i] = Simulator.Files.Thermodynamic_Functions.Psat(comp[i].VP[:], T);
    end for;
    for i in 1:Nc loop
      philiqbubl_c[i] = 1;
      phivapdew_c[i] = 1;
    end for;
    (gma_c, gmabubl_c, gmadew_c) = UNIFAC_M(Nc, C.UNIFAC_SubGroup, Pvap_c, T, P, x_pc, Pdew);
    for i in 1:Nc loop
      K_c[i] = gma_c[i] * Pvap_c[i] / P;
    end for;
  end UNIFAC2;

  function UNIFAC_M
    input Integer NOC;
    input Integer ID[NOC, 5, 2];
    input Real Psat[NOC];
    input Real T;
    input Real P;
    input Real X[3, NOC];
    input Real Pdew;
    output Real gamma[NOC];
    output Real gammaBubl[NOC];
    output Real gammaDew[NOC];
  protected
    parameter Integer N = 5;
    Integer length;
    Real i, j, k, l, str;
  algorithm
    length := 0;
    for i in 1:NOC loop
      str := 0;
      if i == 1 then
        for j in 1:N loop
          if ID[i, j, 1] <> 0 then
            length := length + 1;
          end if;
        end for;
      else
        for j in 1:N loop
          if ID[i, j, 1] == 0 then
            break;
          end if;
          for k in 1:i - 1 loop
            for l in 1:N loop
              if ID[k, l, 1] == 0 then
                break;
              elseif ID[i, j, 1] == ID[k, l, 1] then
                str := 1;
              end if;
            end for;
          end for;
          if str == 0 then
            length := length + 1;
          end if;
          str := 0;
        end for;
      end if;
    end for;
    (gamma, gammaBubl, gammaDew) := UNIFAC_ID(NOC, ID, length, Psat, T, P, X, Pdew);
  end UNIFAC_M;

  function UNIFAC_ID
  input Integer NOC;
    input Integer ID[NOC, 5, 2];
    input Integer length;
    input Real Psat[NOC];
    input Real T;
    input Real P;
    input Real X[3, NOC];
    input Real Pdew;
    output Real gamma[NOC];
    output Real gammaBubl[NOC];
    output Real gammaDew[NOC];
  protected
    Integer ID_v[length];
    Integer i, j, k, l, str;
    Integer v;
    parameter Integer N = 4;
  algorithm
    v := 1;
    for i in 1:NOC loop
      str := 0;
      if i == 1 then
        for j in 1:N loop
          if ID[i, j, 1] <> 0 then
            ID_v[v] := ID[i, j, 1];
            v := v + 1;
          end if;
        end for;
      else
        for j in 1:N loop
          if ID[i, j, 1] == 0 then
            break;
          end if;
          for k in 1:i - 1 loop
            for l in 1:N loop
              if ID[k, l, 1] == 0 then
                break;
              elseif ID[i, j, 1] == ID[k, l, 1] then
                str := 1;
              end if;
            end for;
          end for;
          if str == 0 then
            ID_v[v] := ID[i, j, 1];
            v := v + 1;
          end if;
          str := 0;
        end for;
      end if;
    end for;
  // (gamma, gammaBubl, gammaDew) := UNIFAC_gamma(NOC, length, ID, ID_v, Psat, T, P, X, Pdew);
   gamma:=Simulator.Files.ThermodynamicPackages.UNIFACnew.UNIFAC_gammaNew(NOC, length, ID, ID_v, Psat, T, P, X[2,:], Pdew,"normal");
   gammaBubl:=Simulator.Files.ThermodynamicPackages.UNIFACnew.UNIFAC_gammaNew(NOC, length, ID, ID_v, Psat, T, P, X[1,:], Pdew,"bubl");
   gammaDew:=Simulator.Files.ThermodynamicPackages.UNIFACnew.UNIFAC_gammaNew(NOC, length, ID, ID_v, Psat, T, P, X[1,:], Pdew,"dew");
  end UNIFAC_ID;

  function UNIFAC_gamma
  input Integer NOC;
    input Integer length;
    input Integer ID[NOC, 5, 2];
    //input Integer ID_sub[NOC,5,2];
    input Integer ID_v[length];
    input Real Psat[NOC];
    input Real T;
    input Real P;
    input Real X[3, NOC];
    input Real Pdew;
    output Real gamma[NOC];
    output Real gammaBubl[NOC];
    output Real gammaDew[NOC];
  protected
    //Intermediate values used to compute UNIFAC R and Q values
    Real q[NOC] "Van der walls molecular surface area";
    Real r[NOC] "Van der walls molecular volume";
    Real e[length, NOC] "Group Surface area fraction of comp i";
    Real tau[length, length] "Boltzmann factors";
    Real B[NOC, length] "UNIFAC parameter ";
    Real theta[length] "UNIFAC parameter";
    Real sum[NOC];
    Real S[length] "Unifac parameter ";
    Real J[NOC](each start = 1) "Surface area fraction of comp i";
    Real L[NOC](each start = 1) "Molecular volume fraction of comp i";
    //Activity Coefficients
    Real gammac[NOC] "Combinatorial activity coefficient of comp i";
    Real gammar[NOC] "Residual activity coefficient of comp i";
    //===============================================================================
    //Bubble Point Calculation Variables
    Real theta_bubl[length] "UNIFAC parameter";
    Real S_bubl[length] "Unifac parameter ";
    Real J_bubl[NOC] "Surface area fraction of comp i";
    Real L_bubl[NOC] "Molecular volume fraction of comp i";
    Real gammac_bubl[NOC] "Combinatorial activity coefficient of components at bubble point";
    Real gammar_bubl[NOC] "Residual activity coefficient of components at bubble point";
    Real sum_bubl[NOC];
    //===============================================================================
    //Dew Point Calculation Routine
    Real theta_dew[length] "UNIFAC parameter";
    Real S_dew[length] "Unifac parameter ";
    Real J_dew[NOC] "Surface area fraction of comp i";
    Real L_dew[NOC] "Molecular volume fraction of comp i";
    Real gammac_dew[NOC] "combinatorial activity coefficient of components at dew point";
    Real gammar_dew[NOC] "residual activity coefficient of components at dew point";
    Real sum_dew[NOC];
    Real dewLiqMolFrac[NOC](each start = 0.5);
  algorithm
    tau := UNIFAC_BIP(length, ID_v, T);
    (r, q, e) := UNIFAC_RQ(NOC, length, ID, ID_v);
    for i in 1:NOC loop
      J[i] := r[i] / sum(r[:] .* X[2, :]);
      L[i] := q[i] / sum(q[:] .* X[2, :]);
      if J[i] > 0 and L[i] > 0 then
        gammac[i] := exp(1 - J[i] + log(J[i]) + (-5 * q[i] * (1 - J[i] / L[i] + log(J[i] / L[i]))));
      else
        gammac[i] := 1;
      end if;
    end for;
    for j in 1:length loop
      theta[j] := sum(X[2, :] .* q[:] .* e[j, :]) / sum(X[2, :] .* q[:]);
    end for;
    for i in 1:length loop
      S[i] := sum(theta[:] .* tau[:, i]);
    end for;
    for i in 1:NOC loop
      for j in 1:length loop
        for l in 1:length loop
          B[i, j] := sum(e[:, i] .* tau[:, j]);
        end for;
      end for;
    end for;
    sum[:] := fill(0, NOC);
    for j in 1:length loop
      for i in 1:NOC loop
        if B[i, j] > 0 and S[j] > 0 then
          sum[i] := sum[i] + theta[j] * B[i, j] / S[j] - e[j, i] * log(B[i, j] / S[j]);
          gammar[i] := exp(q[i] * (1 - sum[i]));
        elseif B[i, j] < 0 and S[j] < 0 then
          sum[i] := sum[i] + theta[j] * B[i, j] / S[j] - e[j, i] * log(B[i, j] / S[j]);
          gammar[i] := exp(q[i] * (1 - sum[i]));
        else
          sum[i] := sum[i];
          gammar[i] := exp(q[i] * (1 - sum[i]));
        end if;
      end for;
    end for;
    for i in 1:NOC loop
      if gammar[i] > 0 and gammac[i] > 0 then
        gamma[i] := exp(log(gammar[i]) + log(gammac[i]));
      elseif gammar[i] > 0 and gammac[i] <= 0 then
        gamma[i] := exp(log(gammar[i]));
      elseif gammar[i] <= 0 and gammac[i] > 0 then
        gamma[i] := exp(log(gammac[i]));
      else
        gamma[i] := 1;
      end if;
    end for;
    
    
    for i in 1:NOC loop
      J_bubl[i] := r[i] / sum(r[:] .* X[1, :]);
      L_bubl[i] := q[i] / sum(q[:] .* X[1, :]);
      if J_bubl[i] > 0 and L_bubl[i] > 0 then
        gammac_bubl[i] := exp(1 - J_bubl[i] + log(J_bubl[i]) + (-5 * q[i] * (1 - J_bubl[i] / L_bubl[i] + log(J_bubl[i] / L_bubl[i]))));
      else
        gammac_bubl[i] := 1;
      end if;
    end for;
    for j in 1:length loop
      theta_bubl[j] := sum(X[1, :] .* q[:] .* e[j, :]) / sum(X[1, :] .* q[:]);
    end for;
    for i in 1:length loop
      S_bubl[i] := sum(theta_bubl[:] .* tau[:, i]);
    end for;
    sum_bubl[:] := fill(0, NOC);
    for j in 1:length loop
      for i in 1:NOC loop
        if B[i, j] > 0 and S_bubl[j] > 0 then
          sum_bubl[i] := sum_bubl[i] + theta_bubl[j] * B[i, j] / S_bubl[j] - e[j, i] * log(B[i, j] / S_bubl[j]);
          gammar_bubl[i] := exp(q[i] * (1 - sum_bubl[i]));
        elseif B[i, j] < 0 and S_bubl[j] < 0 then
          sum_bubl[i] := sum_bubl[i] + theta_bubl[j] * B[i, j] / S_bubl[j] - e[j, i] * log(B[i, j] / S_bubl[j]);
          gammar_bubl[i] := exp(q[i] * (1 - sum_bubl[i]));
        else
          sum_bubl[i] := sum_bubl[i];
          gammar_bubl[i] := exp(q[i] * (1 - sum_bubl[i]));
        end if;
      end for;
    end for;
    for i in 1:NOC loop
      if gammar_bubl[i] > 0 and gammac_bubl[i] > 0 then
        gammaBubl[i] := exp(log(gammar_bubl[i]) + log(gammac_bubl[i]));
      elseif gammar_bubl[i] > 0 and gammac_bubl[i] <= 0 then
        gammaBubl[i] := exp(log(gammar_bubl[i]));
      elseif gammar_bubl[i] <= 0 and gammac_bubl[i] > 0 then
        gammaBubl[i] := exp(log(gammac_bubl[i]));
      else
        gammaBubl[i] := 1;
      end if;
    end for;
//=======================================================================================================
//Dew Point Calculation Routine
    for i in 1:NOC loop
      dewLiqMolFrac[i] := X[1, i] * Pdew / (gammaDew[i] * Psat[i]);
    end for;
    for i in 1:NOC loop
      J_dew[i] := r[i] / sum(r[:] .* dewLiqMolFrac[:]);
      L_dew[i] := q[i] / sum(q[:] .* dewLiqMolFrac[:]);
      if J_dew[i] > 0 and L_dew[i] > 0 then
        gammac_dew[i] := exp(1 - J_dew[i] + log(J_dew[i]) + (-5 * q[i] * (1 - J_dew[i] / L_dew[i] + log(J_dew[i] / L_dew[i]))));
      else
        gammac_dew[i] := exp(1 - 0 + 0 + (-5 * q[i] * (1 - J_dew[i] / L_dew[i] + 1)));
      end if;
    end for;
    for j in 1:length loop
      theta_dew[j] := sum(dewLiqMolFrac[:] .* q[:] .* e[j, :]) / sum(dewLiqMolFrac[:] .* q[:]);
    end for;
    for i in 1:length loop
      S_dew[i] := sum(theta_dew[:] .* tau[:, i]);
    end for;
    sum_dew[:] := fill(0, NOC);
    for j in 1:length loop
      for i in 1:NOC loop
        if B[i, j] > 0 and S_dew[j] > 0 then
          sum_dew[i] := sum_dew[i] + theta_dew[j] * B[i, j] / S_dew[j] - e[j, i] * log(B[i, j] / S_dew[j]);
          gammar_dew[i] := exp(q[i] * (1 - sum_dew[i]));
        elseif B[i, j] < 0 and S_dew[j] < 0 then
          sum_dew[i] := sum_dew[i] + theta_dew[j] * B[i, j] / S_dew[j] - e[j, i] * log(B[i, j] / S_dew[j]);
          gammar_dew[i] := exp(q[i] * (1 - sum_dew[i]));
        else
          sum_dew[i] := sum_dew[i];
          gammar_dew[i] := exp(q[i] * (1 - sum_dew[i]));
        end if;
      end for;
    end for;
    for i in 1:NOC loop
      if gammar_dew[i] > 0 and gammac_dew[i] > 0 then
        gammaDew[i] := exp(log(gammar_dew[i]) + log(gammac_dew[i]));
      elseif gammar_dew[i] <= 0 and gammac_dew[i] > 0 then
        gammaDew[i] := exp(log(gammac_dew[i]));
      elseif gammar_dew[i] > 0 and gammac_dew[i] <= 0 then
        gammaDew[i] := exp(log(gammar_dew[i]));
      else
        gammaDew[i] := 1;
      end if;
    end for;
  end UNIFAC_gamma;

  function UNIFAC_BIP
  input Integer length;
    input Integer ID[length];
    input Real T;
    output Real tau[length, length] "Boltzmann factors";
  protected
    Real A[length, length];
    //ID*ID metrix
    parameter Integer Main_ID[119] = {1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 4, 4, 4, 5, 6, 7, 8, 9, 9, 10, 11, 11, 12, 13, 13, 13, 13, 14, 14, 14, 15, 15, 15, 16, 16, 17, 18, 18, 18, 19, 19, 20, 20, 21, 21, 21, 22, 22, 22, 23, 23, 24, 25, 26, 26, 26, 27, 28, 29, 29, 30, 31, 32, 33, 34, 34, 35, 36, 37, 38, 39, 39, 40, 40, 40, 41, 42, 42, 42, 42, 43, 43, 43, 44, 45, 45, 45, 45, 45, 45, 45, 45, 46, 46, 46, 46, 46, 46, 47, 47, 48, 48, 48, 49, 50, 50, 50, 52, 52, 53, 53, 53, 53, 53, 53, 54, 55, 56};
    //ID number and name
    //[[1, 'CH2'], [2, 'C=C'], [3, 'ACH'], [4, 'ACCH2'], [5, 'OH'], [6, 'MeOH'], [7, 'H2O'], [8, 'ACOH'], [9, 'CH2CO'], [10, 'CHO'], [11, 'COOC'], [12, 'HCOO'], [13, 'CH2O'], [14, 'CNH2'], [15, 'CNH'], [16, 'C3N'], [17, 'ACNH2'], [18, 'Pyridine'], [19, 'CCN'], [20, 'COOH'], [21, 'CCl'], [22, 'CCl2'], [23, 'CCl3'], [24, 'CCl4'], [25, 'ACCl'], [26, 'CNO2'], [27, 'ACNO2'], [28, 'CS2'], [29, 'CH3SH'], [30, 'Furfural'], [31, 'DOH'], [32, 'I'], [33, 'Br'], [34, 'C#C'], [35, 'DMSO'], [36, 'ACRY'], [37, 'ClCC'], [38, 'ACF'], [39, 'DMF'], [40, 'CF2'], [41, 'COO'], [42, 'SiH2'], [43, 'SiO'], [44, 'NMP'], [45, 'CClF'], [46, 'CON'], [47, 'OCCOH'], [48, 'CH2S'], [49, 'Morpholine'], [50, 'Thiophene'],[51, NaN] [52, 'CH2SuCH2'], [53, 'Oxides'], [54, 'Anhydride'], [55, 'Aromatic Nitrile'], [56, 'Aromatic Bromo']]
    parameter Real BIP[56, 56] = {{0.0, 86.02, 61.13, 76.5, 986.5, 697.2, 1318.0, 1333.0, 476.4, 677.0, 232.1, 507.0, 251.5, 391.5, 255.7, 206.6, 920.7, 287.77, 597.0, 663.5, 35.93, 53.76, 24.9, 104.3, 11.44, 661.5, 543.0, 153.6, 184.4, 354.55, 3025.0, 335.8, 479.5, 298.9, 526.5, 689.0, -4.189, 177.12, 485.3, -2.859, 387.1, -244.59, 745.3, 0.0, 0.0, 0.0, 0.0, 187.0, 216.1, 92.99, 0, 808.59, 408.3, 718.01, 0, 153.72}, {-35.36, 0.0, 38.81, 74.15, 524.1, 787.6, 270.6, 526.1, 182.6, 448.8, 37.85, 333.5, 214.5, 240.9, 163.9, 61.11, 749.3, 280.5, 336.9, 318.9, -36.87, 58.55, -13.99, -109.7, 100.1, 357.5, 0, 76.30199999999999, 0, 262.9, 0, 0, 183.8, 31.14, 179.0, -52.87, -66.46, 125.8, -70.45, 449.4, 48.33, 0, 0, 220.3, 0, 390.9, 553.3, -617.0, 62.56, 0, 0, 200.94, 219.9, -677.25, 0, 0}, {-11.12, 3.446, 0.0, 167.0, 636.1, 637.35, 903.8, 1329.0, 25.77, 347.3, 5.994, 287.1, 32.14, 161.7, 122.8, 90.49, 648.2, -4.449, 212.5, 537.4, -18.81, -144.4, -231.9, 3.0, 187.0, 168.0, 194.9, 52.07, -10.43, -64.69, 210.4, 113.3, 261.3, 154.26, 169.9, 383.9, -259.1, 359.3, 245.6, 22.67, 103.5, -450.4, 252.7, 86.46, -5.869, 0, 268.1, 0, -59.58, -39.16, 0, 360.82, 171.49, 272.33, 22.06, 174.35}, {-69.7, -113.6, -146.8, 0.0, 803.2, 603.25, 5695.0, 884.9, -52.1, 586.6, 5688.0, 197.8, 213.1, 19.02, -49.29, 23.5, 664.2, 52.8, 6096.0, 872.3, -114.1, -111.0, -80.25, -141.3, -211.0, 3629.0, 4448.0, -9.451, 393.6, 48.49, 4975.0, 259.0, 210.0, -152.55, 4284.0, -119.2, -282.5, 389.3, 5629.0, -245.39, 69.26, -432.3, 238.9, 30.04, 0, 0, 333.3, 0, -203.6, 184.9, 0, 233.51, -184.68, 9.63, 795.38, -280.9}, {156.4, 457.0, 89.6, 25.82, 0.0, -137.1, 353.5, -259.7, 84.0, -203.6, 101.1, 267.8, 28.06, 83.02, 42.7, -323.0, -52.39, 170.0, 6.712000000000001, 199.0, 75.62, 65.28, -98.12, 143.1, 123.5, 256.5, 157.1, 488.9, 147.5, -120.5, -318.9, 313.5, 202.1, 727.8, -202.1, 74.27, 225.8, 101.4, -143.9, 0, 190.3, 683.3, 355.5, 46.38, -88.11, 200.2, 421.9, 0, 104.7, 57.65, 0, 215.81, 6.39, 0, 0, 147.97}, {16.51, -12.52, -50.0, -44.5, 249.1, 0.0, -181.0, -101.7, 23.39, 306.4, -10.72, 179.7, -128.6, 359.3, -20.98, 53.9, 489.7, 580.5, 53.28, -202.0, -38.32, -102.5, -139.4, -44.76, -28.25, 75.14, 457.88, -31.09, 17.5, -61.76, -119.2, 212.1, 106.3, -119.1, -399.3, -5.224, 33.47, 44.78, -172.4, 0, 165.7, 0, 0, 0, 72.96, 0, 0, 37.63, -59.4, -46.01, 0, 150.02, 98.2, 0, 0, 0}, {300.0, 496.1, 362.3, 377.6, -229.1, 289.6, 0.0, 324.5, -195.4, -116.0, 72.87, 233.87, 540.5, 48.89, 168.0, 304.0, 459.0, 459.0, 112.6, -14.09, 325.4, 370.4, 353.7, 497.5, 133.9, 220.6, 399.5, 887.1, 0, 188.0, 12.72, 0, 777.1, 0, -139.0, 160.8, 0, 0, 319.0, 0, -197.5, -817.7, 0, -504.2, 0, -382.7, -248.3, 0, 407.9, 0, 0, -255.63, -144.77, 0, 0, 580.28}, {275.8, 217.5, 25.34, 244.2, -451.6, -265.2, -601.8, 0.0, -356.1, -271.1, -449.4, -32.52, -162.9, -832.97, 0, 0, -305.5, -305.5, 0, 408.9, 0, 517.27, 0, 1827.0, 6915.0, 0, -413.48, 8484.0, 0, 0, -687.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, -494.2, 0, 0, -452.2, 0, 0, 0, 0, 0, 1005.0, 0, 0, 0, 0, 0, 0}, {26.76, 42.92, 140.1, 365.8, 164.5, 108.7, 472.5, -133.1, 0.0, -37.36, -213.7, -190.4, -103.6, 0, -174.2, -169.0, 6201.0, 7.341, 481.7, 669.4, -191.7, -130.3, -354.6, -39.2, -119.8, 137.5, 548.5, 216.1, -46.28, -163.7, 71.46, 53.59, 245.2, -246.6, -44.58, -63.5, -34.57, 0, -61.7, 0, -18.8, -363.8, 0, 0, 0, 0, 139.6, 0, 0, -162.6, 0, 0, -288.94, 91.01, 0, 179.74}, {505.7, 56.3, 23.39, 106.0, 529.0, -340.2, 480.8, -155.6, 128.0, 0.0, -110.3, 766.0, 304.1, 0, 0, 0, 0, 0, -106.4, 497.5, 751.9, 67.52, -483.7, 0, 0, 0, 0, 0, 0, 0, 0, 117.0, 0, 2.21, 0, -339.2, 172.4, 0, -268.8, 0, -275.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 79.71, 0, 0, 0}, {114.8, 132.1, 85.84, -170.0, 245.4, 249.63, 200.8, -36.72, 372.2, 185.1, 0.0, -241.8, -235.7, 0, -73.5, -196.7, 475.5, -0.13, 494.6, 660.2, -34.74, 108.9, -209.7, 54.57, 442.4, -81.13, 0, 183.0, 0, 202.3, -101.7, 148.3, 18.88, 71.48, 52.08, -28.61, -275.2, 0, 85.33, 0, 560.2, 0, 0, 0, 0, 0, 37.54, 0, 0, 0, 0, 0, 36.34, 446.9, 0, 0}, {329.3, 110.4, 18.12, 428.0, 139.4, 227.8, 124.63, -234.25, 385.4, -236.5, 1167.0, 0.0, -234.0, 0, 0, 0, 0, -233.4, -47.25, -268.1, 0, 31.0, -126.2, 179.7, 24.28, 0, 0, 0, 103.9, 0, 0, 0, 298.13, 0, 0, 0, -11.4, 0, 308.9, 0, -70.24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -77.96, 0, 0, 0}, {83.36, 26.51, 52.13, 65.69, 237.7, 238.4, -314.7, -178.5, 191.1, -7.837999999999999, 461.3, 457.3, 0.0, -78.36, 251.5, 5422.3, -46.39, 213.2, -18.51, 664.6, 301.1, 137.8, -154.3, 47.67, 134.8, 95.18, 155.11, 140.9, -8.538, 170.1, -20.11, -149.5, -202.3, -156.57, 128.8, 0, 240.2, -48.25, 254.8, -172.51, 417.0, -588.9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 567.0, 102.21, 0, 0}, {-30.48, 1.163, -44.85, 296.4, -242.8, -481.7, -330.48, -870.8, 0, 0, 0, 0, 222.1, 0.0, -107.2, -41.11, -200.7, 0, 358.9, 0, -82.92, 0, 0, -99.81, 30.05, 0, 0, 0, -70.14, 0, 0, 0, 0, 0, 874.19, 0, 0, 0, -164.0, 0, 0, 1338.0, 202.7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {65.33, -28.7, -22.31, 223.0, -150.0, -370.3, -448.2, 0, 394.6, 0, 136.0, 0, -56.08, 127.4, 0.0, -189.2, 138.54, 431.49, 147.1, 0, 0, 0, 0, 71.23, -18.93, 0, 0, 0, 0, 0, 939.07, 0, 0, 0, 0, 0, 0, -273.9, -255.22, 0, -38.77, -664.4, 275.9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {-83.98, -25.38, -223.9, 109.9, 28.6, -406.8, -598.8, 0, 225.3, 0, 2889.0, 0, -194.1, 38.89, 865.9, 0.0, 287.43, 0, 1255.1, 0, -182.91, -73.85, -352.9, -262.0, -181.9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 243.1, 0, 0, 570.9, 22.05, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {1139.0, 2000.0, 247.5, 762.8, -17.4, -118.1, -341.6, -253.1, -450.3, 0, -294.8, 0, 285.36, -15.07, 64.3, -24.46, 0.0, 89.7, -281.6, -396.0, 287.0, -111.0, 0, 882.0, 617.5, 0, -139.3, 0, 0, 0, 0.1004, 0, 0, 0, 0, 0, 0, 0, -334.4, 0, -89.42, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {-101.6, -47.63, 31.87, 49.8, -132.3, -378.2, -332.9, -341.6, 29.1, 0, 8.87, 554.4, -156.1, 0, -207.66, 0, 117.4, 0.0, -169.7, -153.7, 0, -351.6, -114.7, -205.3, -2.17, 0, 2845.0, 0, 0, 0, 0, 0, -60.78, 0, 0, 0, 160.7, -196.3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -136.6, 0, 0, 0, 98.82, 0, 0}, {24.82, -40.62, -22.97, -138.4, 185.4, 162.6, 242.8, 0, -287.5, 224.66, -266.6, 99.37, 38.81, -157.3, -108.5, -446.86, 777.4, 134.3, 0.0, 205.27, 4.933, -152.7, -15.62, -54.86, -4.624, -0.515, 0, 230.9, 0.4604, 0, 177.5, 0, -62.17, -203.0, 0, 81.57, -55.77, 0, -151.5, 0, 120.3, 0, 0, 0, 0, 0, 151.8, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {315.3, 1264.0, 62.32, 89.86, -151.0, 339.8, -66.17, -11.0, -297.8, -165.5, -256.3, 193.9, -338.5, 0, 0, 0, 493.8, -313.5, 92.07, 0.0, 13.41, -44.7, 39.63, 183.4, -79.08, 0, 0, 0, 0, -208.9, 0, 228.4, -95.0, 0, -463.6, 0, -11.16, 0, -228.0, 0, -337.0, 448.1, -1327.0, 0, 0, 835.6, 0, 0, 0, 0, 0, 0, 12.55, -60.07, 88.09, 0}, {91.46, 40.25, 4.68, 122.9, 562.2, 529.0, 698.2, 0, 286.3, -47.51, 35.38, 0, 225.4, 131.2, 0, 151.38, 429.7, 0, 54.32, 519.1, 0.0, 108.3, 249.2, 62.42, 153.0, 32.73, 86.2, 450.1, 59.02, 65.56, 0, 2.22, 344.4, 0, 0, 0, -168.2, 0, 6.57, 0, 63.67, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -127.9, 0, 0, 0}, {34.01, -23.5, 121.3, 140.8, 527.6, 669.9, 708.7, 1633.5, 82.86, 190.6, -132.9, 80.99, -197.7, 0, 0, -141.4, 140.8, 587.3, 258.6, 543.3, -84.53, 0.0, 0.0, 56.33, 223.1, 108.9, 0, 0, 0, 149.56, 0, 177.6, 315.9, 0, 215.0, 0, -91.8, 0, -160.28, 0, -96.87, 0, 0, 0, 0, 0, 16.23, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {36.7, 51.06, 288.5, 69.9, 742.1, 649.1, 826.76, 0, 552.1, 242.8, 176.5, 235.6, -20.93, 0, 0, -293.7, 0, 18.98, 74.04, 504.2, -157.1, 0.0, 0.0, -30.1, 192.1, 0, 0, 116.6, 0, -64.38, 0, 86.4, 168.8, 0, 363.7, 0, 111.2, 0, 0, 0, 255.8, 0, 0, -659.0, 0, 0, 0, 565.9, 0, 0, 0, 0, 165.67, 0, 0, 0}, {-78.45, 160.9, -4.7, 134.7, 856.3, 709.6, 1201.0, 10000.0, 372.0, 0, 129.5, 351.9, 113.9, 261.1, 91.13, 316.9, 898.2, 368.5, 492.0, 631.0, 11.8, 17.97, 51.9, 0.0, -75.97, 490.9, 534.7, 132.2, 0, 546.7, 0, 247.8, 146.6, 0, 337.7, 369.5, 187.1, -158.8, 498.6, 0, 256.5, 0, 127.2, 0, 0, 0, 361.1, 63.95, 0, 108.5, 0, 585.19, 291.87, 532.73, 0, 127.16}, {106.8, 70.32, -97.27, 402.5, 325.7, 612.8, -274.5, 622.3, 518.4, 0, -171.1, 383.3, -25.15, 108.5, 102.2, 2951.0, 334.9, 20.18, 363.5, 993.4, -129.7, -8.309, -0.2266, -248.4, 0.0, 132.7, 2213.0, 0, 0, 0, 0, 0, 593.4, 0, 1337.37, 0, 0, 0, 5143.14, 309.58, -145.1, 0, 0, -35.68, 0, 0, 423.1, 0, 0, 0, 0, 0, 0, 0, 0, 8.48}, {-32.69, -1.996, 10.38, -97.05, 261.6, 252.6, 417.9, 0, -142.6, 0, 129.3, 0, -94.49, 0, 0, 0, 0, 0, 0.2827, 0, 113.0, -9.639, 0, -34.68, 132.9, 0.0, 533.2, 320.2, 0, 0, 139.8, 304.3, 10.17, -27.7, 0, 0, 10.76, 0, -223.1, 0, 248.4, 0, 0, 0, -52.1, 0, 0, 0, 0, -4.565, 0, 0, 0, 0, 0, 0}, {5541.0, 0, 1824.0, -127.8, 561.6, 511.29, 360.7, 815.12, -101.5, 0, 0, 0, 220.66, 0, 0, 0, 134.9, 2475.0, 0, 0, 1971.0, 0, 0, 514.6, -123.1, -85.12, 0.0, 0, 0, 0, 0, 2990.0, -124.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1742.53}, {-52.65, 16.62, 21.5, 40.68, 609.8, 914.2, 1081.0, 1421.0, 303.7, 0, 243.8, 0, 112.4, 0, 0, 0, 0, 0, 335.7, 0, -73.09, 0, -26.06, -60.71, 0, 277.8, 0, 0.0, 0, 0, 0, 292.7, 0, 0, 0, 0, -47.37, 0, 0, 0, 469.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 684.78, 0, 0}, {-7.481, 0, 28.41, 19.56, 461.6, 448.6, 0, 0, 160.6, 0, 0, 201.5, 63.71, 106.7, 0, 0, 0, 0, 161.0, 0, -27.94, 0, 0, 0, 0, 0, 0, 0, 0.0, 0, 0, 0, 0, 0, 31.66, 0, 0, 0, 78.92, 0, 0, 0, 0, -209.7, 0, 0, 0, -18.27, 0, 0, 0, 0, 0, 0, 0, 0}, {-25.31, 82.64, 157.3, 128.8, 521.6, 287.0, 23.48, 0, 317.5, 0, -146.3, 0, -87.31, 0, 0, 0, 0, 0, 0, 570.6, -39.46, -116.21, 48.48, -133.16, 0, 0, 0, 0, 0, 0.0, 0, 0, 0, 0, 0, 0, 262.9, 0, 0, 0, 43.37, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {140.0, 0, 221.4, 150.6, 267.6, 240.8, -137.4, 838.4, 135.4, 0, 152.0, 0, 9.207, 0, -213.74, 0, 192.3, 0, 169.6, 0, 0, 0, 0, 0, 0, 481.3, 0, 0, 0, 0, 0.0, 0, 0, 0, -417.2, 0, 0, 0, 302.2, 0, 347.8, 0, 0, 1004.0, 0, 0, 434.1, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {128.0, 0, 58.68, 26.41, 501.3, 431.3, 0, 0, 138.0, 245.9, 21.92, 0, 476.6, 0, 0, 0, 0, 0, 0, 616.6, 179.25, -40.82, 21.76, 48.49, 0, 64.28, 2448.0, -27.45, 0, 0, 0, 0.0, 6.37, 0, 0, 0, 0, 0, 0, 0, 68.55, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 190.81, 0, 0}, {-31.52, 174.6, -154.2, 1112.0, 524.9, 494.7, 79.18, 0, -142.6, 0, 24.37, -92.26, 736.4, 0, 0, 0, 0, -42.71, 136.9, 5256.0, -262.3, -174.5, -46.8, 77.55, -185.3, 125.3, 4288.0, 0, 0, 0, 0, 37.1, 0.0, 0, 32.9, 0, -48.33, 0, 336.25, 0, -195.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {-72.88, 41.38, -101.12, 614.52, 68.95, 967.71, 0, 0, 443.6, -55.87, -111.45, 0, 173.77, 0, 0, 0, 0, 0, 329.1, 0, 0, 0, 0, 0, 0, 174.4, 0, 0, 0, 0, 0, 0, 0, 0.0, 0, 0, 2073.0, 0, -119.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {50.49, 64.07, -2.504, -143.2, -25.87, 695.0, -240.0, 0, 110.4, 0, 41.57, 0, -93.51, -366.51, 0, -257.2, 0, 0, 0, -180.2, 0, -215.0, -343.6, -58.43, -334.12, 0, 0, 0, 85.7, 0, 535.8, 0, -111.2, 0, 0.0, 0, 0, 0, -97.71, 0, 153.7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {-165.9, 573.0, -123.6, 397.4, 389.3, 218.8, 386.6, 0, 114.55, 354.0, 175.5, 0, 0, 0, 0, 0, 0, 0, -42.31, 0, 0, 0, 0, -85.15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, -208.8, 0, -8.804, 0, 423.4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {47.41, 124.2, 395.8, 419.1, 738.9, 528.0, 0, 0, -40.9, 183.8, 611.3, 134.5, -217.9, 0, 0, 0, 0, 281.6, 335.2, 898.2, 383.2, 301.9, -149.8, -134.2, 0, 379.4, 0, 167.9, 0, 82.64, 0, 0, 322.42, 631.5, 0, 837.2, 0.0, 0, 255.0, 0, 730.8, 0, 0, -262.0, 0, 0, 0, 2429.0, 0, 0, 0, 0, -127.06, 0, 0, 0}, {-5.132000000000001, -131.7, -237.2, -157.3, 649.7, 645.9, 0, 0, 0, 0, 0, 0, 167.1, 0, -198.8, 116.5, 0, 159.8, 0, 0, 0, 0, 0, -124.6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 215.2, -110.65, -117.2, 0, 0, 0, 26.35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 117.59}, {-31.95, 249.0, -133.9, -240.2, 64.16, 172.2, -287.1, 0, 97.04, 13.89, -82.12, -116.7, -158.2, 49.7, 10.03, -185.2, 343.7, 0, 150.6, -97.77, -55.21, 397.24, 0, -186.7, -374.16, 223.6, 0, 0, -71.0, 0, -191.7, 0, -176.26, 6.699, 136.6, 5.15, -137.7, 50.06, 0.0, -5.579, 72.31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 39.84}, {147.3, 62.4, 140.6, 839.83, 0, 0, 0, 0, 0, 0, 0, 0, 278.15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33.95, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 185.6, 55.8, 0.0, 0, 0, 0, 0, -218.9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {529.0, 1397.0, 317.6, 615.8, 88.63, 171.0, 284.4, -167.3, 123.4, 577.5, -234.9, 65.37, -247.8, 0, 284.5, 0, -22.1, 0, -61.6, 1179.0, 182.2, 305.4, -193.0, 335.7, 1107.0, -124.7, 0, 885.5, 0, -64.28, -264.3, 288.1, 627.7, 0, -29.34, -53.91, -198.0, 0, -28.65, 0, 0.0, 0, 0, 0, 0, 0, -353.5, 0, 0, 0, 0, 0, 0, -100.53, 0, 0}, {-34.36, 0, 787.9, 191.6, 1913.0, 0, 180.2, 0, 992.4, 0, 0, 0, 448.5, 961.8, 1464.0, 0, 0, 0, 0, 2450.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 169.3, 233.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {110.2, 0, 234.4, 221.8, 84.85, 0, 0, 0, 0, 0, 0, 0, 0, -125.2, 1604.0, 0, 0, 0, 0, 2496.0, 0, 0, 0, 70.81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 745.3, -2166.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {13.89, -16.11, -23.88, 6.2139999999999995, 796.9, 0, 832.2, -234.7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -196.2, 0, 161.5, 0, 0, 0, -274.1, 0, 262.0, 0, 0, 0, 0, 0, -66.31, 185.6, 0, 0, 0, 0, 0, 26.35, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {30.74, 0, 167.9, 0, 794.4, 762.7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 844.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -32.17, 0, 0, 0, 0, 111.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {27.97, 9.755, 0, 0, 394.8, 0, -509.3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -70.25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -322.3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {-11.92, 132.4, -86.88, -19.45, 517.5, 0, -205.7, 0, 156.4, 0, -3.444, 0, 0, 0, 0, 0, 0, 0, 119.2, 0, 0, -194.7, 0, 3.1630000000000003, 7.082000000000001, 0, 0, 0, 0, 0, 515.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 101.2, 0, 0, 0, 0, 0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {39.93, 543.6, 0, 0, 0, 420.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -363.1, -11.3, 0, 0, 0, 0, 6.971, 0, 0, 0, 0, 0, 0, 0, 148.9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0}, {-23.61, 161.1, 142.9, 274.1, -61.2, -89.24, -384.3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0, 0, 0, 0, 0, 0, 0}, {-8.479, 0, 23.93, 2.845, 682.5, 597.8, 0, 810.5, 278.8, 0, 0, 0, 0, 0, 0, 0, 0, 221.4, 0, 0, 0, 0, 0, -79.34, 0, 176.3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {245.21, 384.45, 47.05, 347.13, 72.19, 265.75, 627.39, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 75.04, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {21.49, -2.8, 344.42, 510.32, 244.67, 163.76, 833.21, 0, 569.18, -1.25, -38.4, 69.7, -375.6, 0, 0, 0, 0, 0, 0, 600.78, 291.1, 0, -286.26, -52.93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 177.12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {272.82, 569.71, 165.18, 369.89, 0, 0, 0, 0, -62.02, 0, -229.01, 0, -196.59, 0, 0, 0, 0, 100.25, 0, 472.04, 0, 0, 0, 196.73, 0, 0, 0, 434.32, 0, 0, 0, 313.14, 0, 0, 0, 0, 0, 0, 0, 0, -244.59, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 920.49, 305.77, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 171.94, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {-20.31, 0, -106.7, 568.47, 284.28, 0, 401.2, 0, 106.21, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -108.37, 5.76, 0, -272.01, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 107.84, -33.93, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}};
    //BIP overview
    // a1,1 a1,2 a1,3 ...  a1,56
    // a2,1
    // a3,1
    // .
    // .
    // .
    // a56,1
    // Data are devloped with the help of python script and DWSIM
    parameter Integer i, j;
  algorithm
    for i in 1:length loop
      for j in 1:length loop
        A[i, j] := BIP[Main_ID[ID[i]], Main_ID[ID[j]]];
      end for;
    end for;
    for i in 1:length loop
      tau[i, :] := exp((-A[i, :]) / T);
    end for;
  end UNIFAC_BIP;

  function UNIFAC_RQ
  input Integer NOC;
    input Integer length;
    input Integer ID_sub[NOC, 5, 2];
    input Integer ID_v[length];
    output Real ri[NOC];
    output Real qi[NOC];
    output Real ei[length, NOC];
  protected
    //RQ data base
    //[[1, 'CH2', 'CH3'], [2, 'CH2', 'CH2'], [3, 'CH2', 'CH'], [4, 'CH2', 'C'], [5, 'C=C', 'CH2=CH'], [6, 'C=C', 'CH=CH'], [7, 'C=C', 'CH2=C'], [8, 'C=C', 'CH=C'], [9, 'C=C', 'C=C'], [10, 'ACH', 'ACH'], [11, 'ACH', 'AC'], [12, 'ACCH2', 'ACCH3'], [13, 'ACCH2', 'ACCH2'], [14, 'ACCH2', 'ACCH'], [15, 'OH', 'OH'], [16, 'MeOH', 'CH3OH'], [17, 'H2O', 'H2O'], [18, 'ACOH', 'ACOH'], [19, 'CH2CO', 'CH3CO'], [20, 'CH2CO', 'CH2CO'], [21, 'CHO', 'CHO'], [22, 'COOC', 'CH3COO'], [23, 'COOC', 'CH2COO'], [24, 'HCOO', 'HCOO'], [25, 'CH2O', 'CH3O'], [26, 'CH2O', 'CH2O'], [27, 'CH2O', 'CHO'], [28, 'CH2O', 'THF'], [29, 'CNH2', 'CH3NH2'], [30, 'CNH2', 'CH2NH2'], [31, 'CNH2', 'CHNH2'], [32, 'CNH', 'CH3NH'], [33, 'CNH', 'CH2NH'], [34, 'CNH', 'CHNH'], [35, 'C3N', 'CH3N'], [36, 'C3N', 'CH2N'], [37, 'ACNH2', 'ACNH2'], [38, 'Pyridine', 'C5H5N'], [39, 'Pyridine', 'C5H4N'], [40, 'Pyridine', 'C5H3N'], [41, 'CCN', 'CH3CN'], [42, 'CCN', 'CH2CN'], [43, 'COOH', 'COOH'], [44, 'COOH', 'HCOOH'], [45, 'CCl', 'CH2Cl'], [46, 'CCl', 'CHCl'], [47, 'CCl', 'CCl'], [48, 'CCl2', 'CH2Cl2'], [49, 'CCl2', 'CHCl2'], [50, 'CCl2', 'CCl2'], [51, 'CCl3', 'CHCl3'], [52, 'CCl3', 'CCl3'], [53, 'CCl4', 'CCl4'], [54, 'ACCl', 'ACCl'], [55, 'CNO2', 'CH3NO2'], [56, 'CNO2', 'CH2NO2'], [57, 'CNO2', 'CHNO2'], [58, 'ACNO2', 'ACNO2'], [59, 'CS2', 'CS2'], [60, 'CH3SH', 'CH3SH'], [61, 'CH3SH', 'CH2SH'], [62, 'Furfural', 'Furfural'], [63, 'DOH', 'DOH'], [64, 'I', 'I'], [65, 'Br', 'Br'], [66, 'C#C', 'CH#C'], [67, 'C#C', 'C#C'], [68, 'DMSO', 'DMSO'], [69, 'ACRY', 'Acrylonitrile'], [70, 'ClCC', 'Cl-C=C'], [71, 'ACF', 'ACF'], [72, 'DMF', 'DMF'], [73, 'DMF', 'HCON(CH2)2'], [74, 'CF2', 'CF3'], [75, 'CF2', 'CF2'], [76, 'CF2', 'CF'], [77, 'COO', 'COO'], [78, 'SiH2', 'SiH3'], [79, 'SiH2', 'SiH2'], [80, 'SiH2', 'SiH'], [81, 'SiH2', 'Si'], [82, 'SiO', 'SiH2O'], [83, 'SiO', 'SiHO'], [84, 'SiO', 'SiO'], [85, 'NMP', 'NMP'], [86, 'CClF', 'CCl3F'], [87, 'CClF', 'CCl2F'], [88, 'CClF', 'HCCl2F'], [89, 'CClF', 'HCClF'], [90, 'CClF', 'CClF2'], [91, 'CClF', 'HCClF2'], [92, 'CClF', 'CClF3'], [93, 'CClF', 'CCl2F2'], [94, 'CON', 'CONH2'], [95, 'CON', 'CONHCH3'], [96, 'CON', 'CONHCH2'], [97, 'CON', 'CON(CH3)2'], [98, 'CON', 'CONCH3CH2'], [99, 'CON', 'CON(CH2)2'], [100, 'OCCOH', 'C2H5O2'], [101, 'OCCOH', 'C2H4O2'], [102, 'CH2S', 'CH3S'], [103, 'CH2S', 'CH2S'], [104, 'CH2S', 'CHS'], [105, 'Morpholine', 'morpholine'], [106, 'Thiophene', 'C4H4S'], [107, 'Thiophene', 'C4H3S'], [108, 'Thiophene', 'C4H2S'], [109, 'CH2SuCH2', 'CH2SuCH2'], [110, 'CH2SuCH2', 'CH2SuCH'], [111, 'Oxides', 'CH2OCH2'], [112, 'Oxides', 'CH2OCH'], [113, 'Oxides', 'CH2OC'], [114, 'Oxides', 'CHOCH'], [115, 'Oxides', 'CHOC'], [116, 'Oxides', 'COC'], [117, 'Anhydride', 'O=COC=O'], [118, 'Aromatic Nitrile', 'AC-CN'], [119, 'Aromatic Bromo', 'AC-Br']]
    parameter Real RQ[119, 2] = {{0.9011, 0.848}, {0.6744, 0.54}, {0.4469, 0.228}, {0.2195, 0.0}, {1.3454, 1.176}, {1.1167, 0.867}, {1.1173, 0.988}, {0.8886, 0.6759999999999999}, {0.6605, 0.485}, {0.5313, 0.4}, {0.3652, 0.12}, {1.2663, 0.968}, {1.0396, 0.66}, {0.8121, 0.348}, {1.0, 1.2}, {1.4311, 1.432}, {0.92, 1.4}, {0.8952, 0.68}, {1.6724, 1.4480000000000002}, {1.4457, 1.18}, {0.998, 0.948}, {1.9031, 1.7280000000000002}, {1.6764, 1.42}, {1.242, 1.188}, {1.145, 1.088}, {0.9183, 0.78}, {0.6908, 0.46799999999999997}, {0.9183, 1.1}, {1.5959, 1.544}, {1.3692, 1.236}, {1.1417, 0.924}, {1.4337, 1.244}, {1.207, 0.9359999999999999}, {0.9795, 0.624}, {1.1865, 0.94}, {0.9597, 0.632}, {1.06, 0.816}, {2.9993, 2.113}, {2.8332, 1.8330000000000002}, {2.667, 1.5530000000000002}, {1.8701, 1.724}, {1.6434, 1.416}, {1.3013, 1.224}, {1.528, 1.5319999999999998}, {1.4654, 1.264}, {1.238, 0.9520000000000001}, {1.0106, 0.7240000000000001}, {2.2564, 1.9980000000000002}, {2.0606, 1.6840000000000002}, {1.8016, 1.4480000000000002}, {2.87, 2.41}, {2.6401, 2.184}, {3.39, 2.91}, {1.1562, 0.8440000000000001}, {2.0086, 1.868}, {1.7818, 1.56}, {1.5544, 1.248}, {1.4199, 1.104}, {2.057, 1.65}, {1.8769999999999998, 1.676}, {1.651, 1.368}, {3.168, 2.484}, {2.4088, 2.248}, {1.264, 0.992}, {0.9492, 0.8320000000000001}, {1.2919999999999998, 1.088}, {1.0613, 0.784}, {2.8266, 2.472}, {2.3144, 2.052}, {0.7909999999999999, 0.7240000000000001}, {0.6948, 0.524}, {3.0856, 2.736}, {2.6322, 2.12}, {1.406, 1.38}, {1.0105, 0.92}, {0.615, 0.46}, {1.38, 1.2}, {1.6035, 1.263}, {1.4443, 1.006}, {1.2853, 0.7490000000000001}, {1.047, 0.41}, {1.4838, 1.062}, {1.3030000000000002, 0.764}, {1.1044, 0.466}, {3.9810000000000003, 3.2}, {3.0356, 2.6439999999999997}, {2.2287, 1.916}, {2.406, 2.116}, {1.6493, 1.416}, {1.8174, 1.6480000000000001}, {1.9669999999999999, 1.828}, {2.1721, 2.1}, {2.6243, 2.376}, {1.4515, 1.248}, {2.1905, 1.796}, {1.9637, 1.4880000000000002}, {2.8589, 2.428}, {2.6322, 2.12}, {2.4054, 1.8119999999999998}, {2.1226, 1.9040000000000001}, {1.8952, 1.5919999999999999}, {1.6130000000000002, 1.368}, {1.3863, 1.06}, {1.1589, 0.748}, {3.4739999999999998, 2.7960000000000003}, {2.8569, 2.14}, {2.6908, 1.86}, {2.5247, 1.58}, {2.6869, 2.12}, {2.4595, 1.808}, {1.5926, 1.32}, {1.3652, 1.008}, {1.1378, 0.78}, {1.1378, 0.696}, {0.9103, 0.46799999999999997}, {0.6829, 0.24}, {1.7732, 1.52}, {1.3342, 0.996}, {1.3629, 0.972}};
    //Read the value RQ[RQ_ID,:];  return [Rk, Qk] array
    Integer i, j, k;
    Integer V[NOC, length];
    Real R[NOC, length], Q[NOC, length];
  algorithm
    qi := zeros(NOC);
    ri := zeros(NOC);
    ei := zeros(length, NOC);
    V := zeros(NOC, length);
    Q := zeros(NOC, length);
    R := zeros(NOC, length);
    for i in 1:NOC loop
      for j in 1:5 loop
        for k in 1:length loop
          if ID_v[k] == ID_sub[i, j, 1] then
            V[i, k] := ID_sub[i, j, 2];
          end if;
        end for;
      end for;
    end for;
    for i in 1:NOC loop
      for j in 1:length loop
        if V[i, j] > 0 then
          R[i, j] := RQ[ID_v[j], 1];
          Q[i, j] := RQ[ID_v[j], 2];
        else
          R[i, j] := 0;
          Q[i, j] := 0;
        end if;
      end for;
    end for;
//surface area constant
    for i in 1:NOC loop
      qi[i] := sum(V[i, :] .* Q[i, :]);
      ri[i] := sum(V[i, :] .* R[i, :]);
      ei[:, i] := V[i, :] .* Q[i, :] / qi[i];
    end for;
//surface volume constant
  end UNIFAC_RQ;

function UNIFAC_gammaNew
input Integer NOC;
input Integer length;
input Integer ID[NOC, 5, 2];
input Integer ID_v[length];
input Real Psat[NOC];
input Real T;
input Real P;
input Real x_pc[NOC];
input Real Pdew;
input String flag;

output Real gamma_c[NOC];
protected

Real J_c[NOC];
Real L_c[NOC];
Real r[NOC];
Real q[NOC];
Real X[NOC];
Real gammac_c[NOC];
Real  gammar_c[NOC]; 

Real theta_l[length];
Real S_l[length];
Real a;
Real tau[length, length];
Real sum_c[NOC];
 Real e[length, NOC];
 Real B[NOC, length];
Real p;
Real Xdew[NOC];


algorithm

 
  tau := UNIFAC_BIP(length, ID_v, T);
  (r, q, e) := UNIFAC_RQ(NOC, length, ID, ID_v);
if flag=="dew" then
   for i in 1:NOC loop
     Xdew[i] := x_pc[i] * Pdew / (gamma_c[i] * Psat[i]);
   end for;
   X:=Xdew;
   else 
   Xdew:=zeros(NOC);
   X:=x_pc;
   end if;
 
  for i in 1:NOC loop
    J_c[i] := r[i] / sum(r[:] .* X[:]);
    L_c[i] := q[i] / sum(q[:] .* X[:]);
   

if J_c[i] > 0 and L_c[i] > 0 then
      gammac_c[i] := exp(1 - J_c[i] + log(J_c[i]) + (-5 * q[i] * (1 - J_c[i] / L_c[i] + log(J_c[i] / L_c[i]))));
    elseif flag=="dew" then
     gamma_c[i]:=exp(1 - 0 + 0 + (-5 * q[i] * (1 - J_c[i] / L_c[i] + 1)));//changes
   else
   gamma_c[i]:=1;
    end if;
    
  end for;

 for j in 1:length loop
    theta_l[j] := sum(X[:] .* q[:] .* e[j, :]) / sum(X[:] .* q[:]);
  end for;

for i in 1:length loop
    S_l[i] := sum(theta_l[:] .* tau[:, i]);
  end for;
  sum_c[:] := fill(0, NOC);
////////

  for i in 1:NOC loop
    for j in 1:length loop
      for l in 1:length loop
        B[i, j] := sum(e[:, i] .* tau[:, j]);
      end for;
    end for;
  end for;

////
for j in 1:length loop
  if S_l[j]>0 then
 p:=1;
 elseif S_l[j]<0 then
 p:=-1;
 else
 p:=0;
 end if;

 for i in 1:NOC loop
 if B[i,j]>0 then
 a:=1;
 elseif B[i,j]<0 then
 a:=-1;
 else
 a:=0;
 end if;
 
 if a==1 and p==1 then
    sum_c[i] := sum_c[i] + theta_l[j] * B[i, j] / S_l[j] - e[j, i] * log(B[i, j] / S_l[j]);
gammar_c[i] := exp(q[i] * (1 - sum_c[i]));
 elseif a==-1 and p==-1 then
        sum_c[i] := sum_c[i] + theta_l[j] * B[i, j] / S_l[j] - e[j, i] * log(B[i, j] / S_l[j]);
        gammar_c[i] := exp(q[i] * (1 - sum_c[i]));
  else
        sum_c[i] := sum_c[i];
        gammar_c[i] := exp(q[i] * (1 - sum_c[i]));
      end if;
end for;
  end for;

for i in 1:NOC loop
    if gammar_c[i] > 0 and gammac_c[i] > 0 then
      gamma_c[i] := exp(log(gammar_c[i]) + log(gammac_c[i]));
    elseif gammar_c[i] > 0 and gammac_c[i] <= 0 then
      gamma_c[i] := exp(log(gammar_c[i]));
    elseif gammar_c[i] <= 0 and gammac_c[i] > 0 then
      gamma_c[i] := exp(log(gammac_c[i]));
    else
      gamma_c[i] := 1;
    end if;
  end for;



end UNIFAC_gammaNew;
end UNIFACnew;
