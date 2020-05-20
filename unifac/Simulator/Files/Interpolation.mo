within Simulator.Files;

package Interpolation
  function floaterhormannrationalinterpolant
    
    input Integer N; //no of points
    input Real x[N];
    input Real y[N];
    input Integer d;//degree of polynomial
    
    output Real w[N];//weights
    
  protected
    Real s;
    Real threshold = 1.0E-300;
    
    Real flag;
    Real v;
    
    Real s0;
    Integer prem[N];
    Real X[N];
    Integer flag1;
    Real wtemp[N];
  algorithm
    X := x;
    s0 := 1;
    for i in 1:N loop
      s0 := -1 * s0;
    end for;
    for i in 1:N loop
      prem[i] := i;
    end for;
    for i in 1:N loop
      for j in i + 1:N loop
        if X[j] < X[i] then
          flag := X[i];
          X[i] := X[j];
          X[j] := flag;
          flag1 := prem[i];
          prem[i] := prem[j];
          prem[j] := flag1;
        end if;
      end for;
    end for;
    for k in 1:N loop
      s := 0;
      for i in max(k - d, 1):min(k, N - d) loop
        v := 1;
        for j in i:i + d loop
          if j <> k then
            v := v / abs(X[k] - X[j]);
          end if;
        end for;
        s := s + v;
      end for;
      w[k] := s0 * s;
      s0 := -1 * s0;
    end for;
    for i in 1:N loop
      wtemp[i] := w[i];
    end for;
    for i in 1:N loop
      w[prem[i]] := wtemp[i];
    end for;
//////////////////////////////////////////////
  end floaterhormannrationalinterpolant;

  function interpolant
  input Integer N;
    input Real x[N];
    input Real y[N];
    
    input Real t;
    input Integer d;
    output Real result;
  protected
    Integer j;
    Real s;
    Real w[N];
    Real threshold = 1.0E-300;
    Real s1;
    Real s2;
    Real v;
    
  algorithm
    w := floaterhormannrationalinterpolant(N, x, y, d);

    j := 0;
    s := t - x[1];
    for i in 1:N loop
      if abs(t - x[i]) < abs(s) then
        s := t - x[i];
        j := i;
      end if;
    end for;
    if s == 0 then
      result := y[j];
    end if;
    if abs(s) > threshold then
      j := -1;
      s := 1;
    end if;
    s1 := 0;
    s2 := 0;
    for i in 1:N loop
      if i <> j then
        v := s * w[i] / (t - x[i]);
        s1 := s1 + v * y[i];
        s2 := s2 + v;
      end if;
    end for;
    result := s1 / s2;
  end interpolant;
end Interpolation;
