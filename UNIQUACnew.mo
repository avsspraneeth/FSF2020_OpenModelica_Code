package UNIQUACnew
  model UNIQUAC
  UNIQUACnew.Qnew gma(Nc = Nc, C = C, x =  x_pc[2, :], P = P    , T = T, Pvap_c = Pvap_c,rho_c=rho_c);
  UNIQUACnew.Qnew gmabubl(Nc = Nc, C = C, x = x_pc[1, :], P = Pbubl, T = T, Pvap_c = Pvap_c,rho_c=rho_c); 
  UNIQUACnew.Qnew gmadew(Nc = Nc, C = C, x = xliqdew_c, P = Pdew, T = T, Pvap_c = Pvap_c,rho_c=rho_c);
   
    Real rho_c[Nc];
    Real Cpres_p[3] "residual specific heat", Hres_p[3] "residual enthalpy", Sres_p[3] "residual Entropy", K_c[Nc];
    Real philiqbubl_c[Nc], phivapdew_c[Nc], Pvap_c[Nc];
    // Real K_c[Nc](each start = 0.7) "Distribution Coefficient";
    Real xliqdew_c[Nc](each start = 0.5, each min = 0, each max = 1);
    Real gmanew_c[Nc](each start = 1.2);
    Real gmabubl_c[Nc](each start = 1) "Activity coefficent at bubble point";
    Real gmadew_c[Nc](each start = 2.2) "Activity coefficent at dew point";
  equation
    Cpres_p = zeros(3);

    Hres_p = zeros(3);

    Sres_p = zeros(3);

    for i in 1:Nc loop
      rho_c[i] = Simulator.Files.ThermodynamicFunctions.Dens(C[i].LiqDen, C[i].Tc, T, P) * 1E-3;

    end for;
    
    for i in 1:Nc loop
      philiqbubl_c[i] = 1;
      phivapdew_c[i] = 1;
    end for;
    for i in 1:Nc loop
      Pvap_c[i] = Simulator.Files.ThermodynamicFunctions.Psat(C[i].VP, T);

    end for;
////////////////
    for i in 1:Nc loop
      if gmadew.q== 0 or  x_pc[1, i] == 0 then
        xliqdew_c[i] = 0;
      else
        xliqdew_c[i] = x_pc[1, i] * Pdew/ (gmadew_c[i] * Pvap_c[i]);
      end if;
      end for;
    //////////////
    
    gmanew_c = gma.gma;
    gmabubl_c = gmabubl.gma;
    gmadew_c = gmadew.gma;
  
    for i in 1:Nc loop
      K_c[i] = gmanew_c[i] .* Pvap_c[i] ./ P;
    end for;
  end UNIQUAC;

  model Qnew
  Real T;
    parameter Simulator.Files.ChemsepDatabase.GeneralProperties C[Nc];
    parameter Integer Nc = 3;
    Real r (each start = 2, min = 0, max = 1), q(each start = 2);
    Real R[Nc] = C.UniquacR;
    Real Q[Nc] = C.UniquacQ;
    Real x[Nc] ;
    parameter Real a[Nc, Nc] = Simulator.Files.ThermodynamicFunctions.BIPUNIQUAC(Nc, C.name);
    Real Theta[Nc];
    Real S[Nc](each start = 1);
    Real rho_c[Nc];
    Real Pvap_c[Nc];
    Real tow[Nc, Nc];
    Real sum[Nc](each start = 2);
    Real Cc[Nc];
    Real gmar[Nc](each start = 1) ;
    Real D[Nc];
    Real E[Nc];
    Real F[Nc];
    Real A[Nc];
    Real B[Nc];
    Real gmac[Nc](each start = 2);
    Real gmaold[Nc](each start = 1);
    Real Z = 10;
    Real gma[Nc](each start = 1);
    Real PCF[Nc];
    Real phi[Nc](each start = 0.5);
    Real P;
    extends Simulator.GuessModels.InitialGuess;
  equation
  
    tow = Simulator.Files.ThermodynamicFunctions.TowUNIQUAC(Nc, a, T);
    r = sum(x[:] .* R[:]);
    q = sum(x[:] .* Q[:]);
    
    ///////////////
   /* for i in 1:Nc loop
      if q== 0 or x[ i] == 0 then
        xliqdew_c[i] = 0;
      else
        xliqdew_c[i] = x[i] * P / (gma[i] * Pvap_c[i]);
      end if;
  */
    
    //////////////
    for i in 1:Nc loop
      if x[i] == 0 or q == 0 then
        Theta[i] = 0;
      else
        Theta[i] = x[i] * Q[i] * 1 / q;
      end if;
      if Theta[i] == 0 then
        S[i] = 1;
      else
        S[i] = sum(Theta[:] .* tow[i, :]);
      end if;
    end for;
////////////////////////////
    for i in 1:Nc loop
      if S[i] == 1 then
        sum[i] = 0;
      else
        sum[i] = sum(Theta[:] .* tow[i, :] ./ S[:]);
      end if;
      if S[i] == 1 then
        Cc[i] = 0;
      elseif S[i] > 0 then
        Cc[i] = log(S[i]);
      else
        Cc[i] = 0;
      end if;
      gmar[i] = exp(Q[i] * (1 - Cc[i] - sum[i]));
    end for;
/////////////////////////////////
    for i in 1:Nc loop
      if r == 0 then
        D[i] = 0;
      else
        D[i] = R[i] / r;
      end if;
      if q == 0 then
        E[i] = 0;
      else
        E[i] = Q[i] / q;
      end if;
      if E[i] == 0 then
        F[i] = 0;
      else
        F[i] = D[i] / E[i];
      end if;
      if D[i] > 0 then
        A[i] = log(D[i]);
      elseif D[i] == 1 then
        A[i] = 0;
      else
        A[i] = 0;
      end if;
      if F[i] > 0 then
        B[i] = log(F[i]);
      elseif F[i] == 1 then
        B[i] = 0;
      else
        B[i] = 0;
      end if;
      log(gmac[i]) = 1 - D[i] + A[i] + (-Z / 2 * Q[i] * (1 - F[i] + B[i]));
      gmaold[i] = gmac[i] * gmar[i];
    end for;
    for i in 1:Nc loop
      PCF[i] = Simulator.Files.ThermodynamicFunctions.PoyntingCF(Nc, C[i].Pc, C[i].Tc, C[i].Racketparam, C[i].AF, C[i].MW, T, P, gma[i], Pvap_c[i], rho_c[i]);
      if P == 0 then
        phi[i] = 1;
        gma[i] = 1;
      else
        phi[i] = gmaold[i] .* Pvap_c[i] ./ P .* PCF[i];
        phi[i] = gma[i] .* Pvap_c[i] ./ P;
      end if;
    end for;
  end Qnew;
end UNIQUACnew;
