package units
  type Temperature_degC = Real(final quantity = "ThermodynamicTemperature", final unit = "degC");

  function from_degC "Convert from degCelsius to Kelvin"
    extends Modelica.SIunits.Icons.Conversion;
    import Modelica.SIunits.Conversions.*;
    import SI = Modelica.SIunits;
    input units.Temperature_degC Celsius "Celsius value";
    output SI.Temperature Kelvin "Kelvin value";
  algorithm
    Kelvin := Celsius - Modelica.Constants.T_zero;
    annotation(
      Inline = true,
      Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Text(extent = {{-20, 100}, {-100, 20}}, textString = "degC"), Text(extent = {{100, -20}, {20, -100}}, textString = "K")}));
  end from_degC;

 

  type mol_per_hr = Real(final quantity = "MolarFlowRate", final unit = "mol/h");

  function from_mol_per_hr
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.mol_per_hr mol_p_hr;
    output SI.VolumeFlowRate mol_p_s;
  algorithm
    mol_p_s := mol_p_hr *0.00027778;
  end from_mol_per_hr;

  type mol_per_day = Real(final quantity = "MolarFlowRate", final unit = "mol/d");

  function from_mol_per_day
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.mol_per_day mol_p_d;
    output SI.VolumeFlowRate mol_p_s;
  algorithm
    mol_p_s := mol_p_d * 1.1574070E-5;
  end from_mol_per_day;

  type mol_per_min = Real(final quantity = "MolarFlowRate", final unit = "mol/min");

  function from_mol_per_min
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.mol_per_min mol_p_m;
    output SI.VolumeFlowRate mol_p_s;
  algorithm
    mol_p_s := mol_p_m * 0.016667;
  end from_mol_per_min;

  type kmol_per_sec = Real(final quantity = "MolarFlowRate", final unit = "kmol/s", displayUnit="kmol/s");

  function from_kmol_per_sec
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.kmol_per_sec kmol_p_s;
    output SI.VolumeFlowRate mol_p_s;
  algorithm
    mol_p_s := kmol_p_s * 1000;
  end from_kmol_per_sec;

  type kmol_per_min = Real(final quantity = "MolarFlowRate", final unit = "kmol/min");

  function from_kmol_per_min
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.kmol_per_min kmol_p_m;
    output SI.VolumeFlowRate mol_p_s;
  algorithm
    mol_p_s := kmol_p_m * 16.66667;
  end from_kmol_per_min;

  type kmol_per_hr = Real(final quantity = "MolarFlowRate", final unit = "kmol/h");

  function from_kmol_per_hr
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.kmol_per_hr kmol_p_hr;
    output SI.VolumeFlowRate mol_p_s;
  algorithm
    mol_p_s := kmol_p_hr*0.277778;
  end from_kmol_per_hr;


  type kmol_per_day
= Real(final quantity = "MolarFlowRate", final unit = "kmol/d");

  function from_kmol_per_day
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.kmol_per_day kmol_p_d;
    output SI.VolumeFlowRate mol_p_s;
  algorithm
    mol_p_s := kmol_p_d * 0.0115740740;
  end from_kmol_per_day;

  model Pressure
  equation

  end Pressure;
  //pressure units
  
  
  
  type Pressure_bar = Real(final quantity = "Pressure", final unit = "bar");

  function from_bar
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.Pressure_bar bar;
    output SI.Pressure Pa;
  algorithm
    Pa := bar*(100000);
  end from_bar;
  
  
  
  type atm = Real(final quantity = "Pressure", final unit = "atm");

  function from_atm
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.atm at;
    output SI.Pressure Pa;
  algorithm
    Pa := at*(101325);
  end from_atm;
  
  
  type torr = Real(final quantity = "Pressure", final unit = "torr");

  function from_torr
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.torr t;
    output SI.Pressure Pa;
  algorithm
    Pa := t*(133.3224);
  end from_torr;
  
  
   type in_Hg = Real(final quantity = "Pressure", final unit = "inHg");

  function from_inHg
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.in_Hg ihg;
    output SI.Pressure Pa;
  algorithm
    Pa := ihg*(3386.3887);
  end from_inHg;
  
  
  
   type mmHg = Real(final quantity = "Pressure", final unit = "mmHg");

  function from_mmHg
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.mmHg mhg;
    output SI.Pressure Pa;
  algorithm
    Pa := mhg*(133.3224);
  end from_mmHg;
  
  type dyne_per_cm2 = Real(final quantity = "Pressure", final unit = "dyne/cm2");

  function from_dyne_per_cm2
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.dyne_per_cm2 dpc;
    output SI.Pressure Pa;
  algorithm
    Pa := dpc*(0.1);
  end from_dyne_per_cm2;
  
  type cm_of_water = Real(final quantity = "Pressure", final unit = "cmH2O");

  function from_cm_of_water
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.cm_of_water cow;
    output SI.Pressure Pa;
  algorithm
    Pa := cow*98.0665;
  end from_cm_of_water;
  
   type ft_of_water = Real(final quantity = "Pressure", final unit = "ftH2O");

  function from_ft_of_water
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.ft_of_water fow;
    output SI.Pressure Pa;
  algorithm
    Pa := fow * 2989.0669;
  end from_ft_of_water;
  
  
  
   type inch_of_water = Real(final quantity = "Pressure", final unit = "inH2O");

  function from_inch_of_water
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.inch_of_water iow;
    output SI.Pressure Pa;
  algorithm
    Pa := iow * 249.08890;
  end from_inch_of_water;
  
  
  
  
  
  
  
  type gmf_per_cm2 = Real(final quantity = "Pressure", final unit = "gmf/cm2");

  function from_gmf_per_cm2
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.gmf_per_cm2 gfc;
    output SI.Pressure Pa;
  algorithm
    Pa := gfc * 98.0665;
  end from_gmf_per_cm2;
  
  
  
  
  type ouncef_per_ft2 = Real(final quantity = "Pressure", final unit = "ozf/ft2");

  function from_ouncef_per_ft2
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.ouncef_per_ft2 of;
    output SI.Pressure Pa;
  algorithm
    Pa := of * 47.8803;
  end from_ouncef_per_ft2;
  
  
  
  
  
   type kgf_per_cm2 = Real(final quantity = "Pressure", final unit = "kgf/cm");

  function from_kgf_per_cm2
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.kgf_per_cm2 kfc;
    output SI.Pressure Pa;
  algorithm
    Pa := kfc * 98066.500;
  end from_kgf_per_cm2;

//massflowrate


type grams_per_s = Real (quantity="MassFlowRate", final unit="g/s");


function from_grams_per_s
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.grams_per_s gps;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := gps * 0.001;
  end from_grams_per_s;



type mgrams_per_s = Real (quantity="MassFlowRate", final unit="mg/s");


function from_mgrams_per_s
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.mgrams_per_s mgps;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := mgps * 1E-6;
  end from_mgrams_per_s;
  
  
  
  
type ounce_per_s = Real (quantity="MassFlowRate", final unit="oz/s");


function from_ounce_per_s
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.ounce_per_s ozps;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := ozps * 0.0283495;
  end from_ounce_per_s;

type lb_per_s = Real (quantity="MassFlowRate", final unit="lb/s");


function from_lb_per_s
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.lb_per_s lbps;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := lbps *0.4536;
  end from_lb_per_s;


type lb_per_min = Real (quantity="MassFlowRate", final unit="lb/min");


function from_lb_per_min
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.lb_per_min lbpm;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := lbpm *0.00756;
  end from_lb_per_min;






type lb_per_h = Real (quantity="MassFlowRate", final unit="lb/h");
function from_lb_per_h
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.lb_per_h lbph;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := lbph *0.000125998;
  end from_lb_per_h;





type stone_per_s = Real (quantity="MassFlowRate", final unit="st/s");


function from_stone_per_s
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.stone_per_s sps;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := sps *6.3503;
  end from_stone_per_s;
  
 
 
 
 
 
type kg_per_hr = Real (quantity="MassFlowRate", final unit="kg/h");


function from_kg_per_hr
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.kg_per_hr kgph;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := kgph *0.000277778;
  end from_kg_per_hr;
  
 
 
 type kg_per_d = Real (quantity="MassFlowRate", final unit="kg/d");


function from_kg_per_d
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.kg_per_d kgpd;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := kgpd *1.15740740E-5;
  end from_kg_per_d;
  
  type kg_per_min = Real (quantity="MassFlowRate", final unit="kg/min");
  
  
  function from_kg_per_min
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.kg_per_min kgpm;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := kgpm *0.0166666666;
  end from_kg_per_min;
  
 type dram_per_s = Real (quantity="MassFlowRate", final unit="dram/s");
 
 function from_dram_per_s
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.dram_per_s dpm;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := dpm * 0.0017718452;
  end from_dram_per_s;
  
 type grain_per_s = Real (quantity="MassFlowRate", final unit="grain/s");
 
 function from_grain_per_s
  extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.grain_per_s dpm;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := dpm * 0.0001;
  end from_grain_per_s;
//volumematric flow rate


type lit_per_s = Real(final quantity = "VolumeFlowRate", final unit = "l/s");


function from_lit_per_s
extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.lit_per_s lps;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := lps * 0.001;
  end from_lit_per_s;


type lit_per_min = Real(final quantity = "VolumeFlowRate", final unit = "l/min");


function from_lit_per_min
extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.lit_per_min lpm;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := lpm *0.000016666666667 ;
  end from_lit_per_min;


type lit_per_hr = Real(final quantity = "VolumeFlowRate", final unit = "l/h");


function from_lit_per_hr
extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.lit_per_hr lph;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := lph *2.7777777778E-7  ;
  end from_lit_per_hr;
  
  
  type lit_per_day = Real(final quantity = "VolumeFlowRate", final unit = "l/d");


function from_lit_per_day
extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.lit_per_day lpd;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := lpd *1.1574074074E-8 ;
  end from_lit_per_day;
  
  
type cm3_per_s = Real(final quantity = "VolumeFlowRate", final unit = "cm3/s");


function from_cm3_per_s
extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.cm3_per_s cps;
    output SI.MassFlowRate kgps;
  algorithm
    kgps := cps *1E-6 ;
  end from_cm3_per_s;


 type m3_per_h = Real(final quantity = "VolumeFlowRate", final unit = "m3/h");

  function from_m3_per_h
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.m3_per_h m3ph;
    output SI.VolumeFlowRate m3ps;
  algorithm
    m3ps := m3ph * (1 / 3600);
  end from_m3_per_h;

type m3_per_day = Real(final quantity = "VolumeFlowRate", final unit = "m3/d");

  function from_m3_per_day
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.m3_per_day m3pd;
    output SI.VolumeFlowRate m3ps;
  algorithm
    m3ps := m3pd *0.0000115740741;
  end from_m3_per_day;


type m3_per_min = Real(final quantity = "VolumeFlowRate", final unit = "m3/min");

  function from_m3_per_min
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.m3_per_min m3pm;
    output SI.VolumeFlowRate m3ps;
  algorithm
    m3ps := m3pm *0.016666666667 ;
  end from_m3_per_min;

type in3_per_s = Real(final quantity = "VolumeFlowRate", final unit = "in3/s");

  function from_in3_per_s
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.in3_per_s in3ps;
    output SI.VolumeFlowRate m3ps;
  algorithm
    m3ps := in3ps *0.000016387064;
  end from_in3_per_s;


type bbl3_per_day = Real(final quantity = "VolumeFlowRate", final unit = "bbl3/d");

  function from_bbl3_per_day
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.bbl3_per_day bbl3pd;
    output SI.VolumeFlowRate m3ps;
  algorithm
    m3ps := bbl3pd *0.00000138009805;
  end from_bbl3_per_day;



type bbl3_per_h = Real(final quantity = "VolumeFlowRate", final unit = "bbl3/h");

  function from_bbl3_per_h
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.bbl3_per_h bbl3ph;
    output SI.VolumeFlowRate m3ps;
  algorithm
    m3ps := bbl3ph *0.00003312235311;
  end from_bbl3_per_h;


type ft3_per_s = Real(final quantity = "VolumeFlowRate", final unit = "ft3/s");

  function from_ft3_per_s
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.ft3_per_s ft3ps;
    output SI.VolumeFlowRate m3ps;
  algorithm
    m3ps := ft3ps *0.0283;
  end from_ft3_per_s;




type ft3_per_min = Real(final quantity = "VolumeFlowRate", final unit = "ft3/min");

  function from_ft3_per_min
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.ft3_per_min ft3pm;
    output SI.VolumeFlowRate m3ps;
  algorithm
    m3ps := ft3pm *0.00047194745;
  end from_ft3_per_min;



type ft3_per_h = Real(final quantity = "VolumeFlowRate", final unit = "ft3/h");

  function from_ft3_per_h
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.ft3_per_h ft3ph;
    output SI.VolumeFlowRate m3ps;
  algorithm
    m3ps := ft3ph *0.0000078657907;
  end from_ft3_per_h;
  
  
  






end units;
