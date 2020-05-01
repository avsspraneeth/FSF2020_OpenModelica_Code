package units
  type Temperature_degC = Real(final quantity = "ThermodynamicTemperature", final unit = "degC");

  function from_degC "Convert from degCelsius to Kelvin"
    extends Modelica.SIunits.Icons.Conversion;
    import Modelica.SIunits.Conversions.*;
    import SI = Modelica.SIunits;
    input units.Temperature_degC Celsius "Celsius value";
    output SI.Temperature Kelvin "Kelvin value";
  algorithm
    Kelvin := Celsius +273.15;
    annotation(
      Inline = true,
      Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Text(extent = {{-20, 100}, {-100, 20}}, textString = "degC"), Text(extent = {{100, -20}, {20, -100}}, textString = "K")}));
  end from_degC;

 

type Temperature_degF = Real (final quantity="ThermodynamicTemperature",final unit="degF");



function from_degF "Convert from degFahrenheit to Kelvin"
  extends Modelica.SIunits.Icons.Conversion;
    import Modelica.SIunits.Conversions.*;
    import SI = Modelica.SIunits;
  input units.Temperature_degF Fahrenheit "Fahrenheit value";
  output SI.Temperature Kelvin "Kelvin value";
algorithm
  Kelvin := (Fahrenheit - 32)*(5/9) + 273.15;
  
end from_degF;



type Temperature_degRa = Real (final quantity="ThermodynamicTemperature",final unit="degRa");



function from_degRa
  extends Modelica.SIunits.Icons.Conversion;
    import Modelica.SIunits.Conversions.*;
    import SI = Modelica.SIunits;
  input units.Temperature_degRa ra;
  output SI.Temperature Kelvin;
algorithm
  Kelvin := ra/1.8;
  
end from_degRa;





type Temperature_degRe = Real (final quantity="ThermodynamicTemperature",final unit="degRe");



function from_degRe
  extends Modelica.SIunits.Icons.Conversion;
    import Modelica.SIunits.Conversions.*;
    import SI = Modelica.SIunits;
  input units.Temperature_degRe re;
  output SI.Temperature Kelvin;
algorithm
  Kelvin := (re*1.25)+273.15;
  
end from_degRe;














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
  
  
 type ft3_per_d = Real(final quantity = "VolumeFlowRate", final unit = "ft3/d");

  function from_ft3_per_d
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.ft3_per_d ft3pd;
    output SI.VolumeFlowRate m3ps;
  algorithm
    m3ps := ft3pd *3.2774128472E-7;
  end from_ft3_per_d;


 type gallonUS_per_s = Real(final quantity = "VolumeFlowRate", final unit = "gal(US)/s");

  function from_gallonUS_per_s
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.gallonUS_per_s gaps;
    output SI.VolumeFlowRate m3ps;
  algorithm
    m3ps := gaps *0.00378541;
  end from_gallonUS_per_s;


 type gallonUK_per_s = Real(final quantity = "VolumeFlowRate", final unit = "gal(UK)/s");

  function from_gallonUK_per_s
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.gallonUK_per_s gaps;
    output SI.VolumeFlowRate m3ps;
  algorithm
    m3ps := gaps *0.00454609029;
  end from_gallonUK_per_s;

//density

type g_per_m3 = Real (final quantity="Density",final unit="g/m3");


 function from_g_per_m3
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.g_per_m3 gpm;
    output SI.VolumeFlowRate kgpm3;
  algorithm
   kgpm3 := gpm *0.001;
  end from_g_per_m3;




type g_per_cc = Real (final quantity="Density",final unit="g/cc");


 function from_g_per_cc
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.g_per_cc gpcc;
    output SI.VolumeFlowRate kgpm3;
  algorithm
   kgpm3 := gpcc *1000;
  end from_g_per_cc;




type kg_per_cc = Real (final quantity="Density",final unit="kg/cc");


 function from_kg_per_cc
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.kg_per_cc kgpcc;
    output SI.VolumeFlowRate kgpm3;
  algorithm
   kgpm3 := gpcc *1000000;
  end from_kg_per_cc;



type kg_per_l = Real (final quantity="Density",final unit="kg/l");


 function from_kg_per_l
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.kg_per_l kgpl;
    output SI.VolumeFlowRate kgpm3;
  algorithm
   kgpm3 := kgpl *1000;
  end from_kg_per_l;


type g_per_l = Real (final quantity="Density",final unit="g/l");


 function from_g_per_l
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.g_per_l gpl;
    output SI.VolumeFlowRate kgpm3;
  algorithm
   kgpm3 := gpl *1;
  end from_g_per_l;


type mg_per_l = Real (final quantity="Density",final unit="mg/l");


 function from_mg_per_l
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.mg_per_l mgpl;
    output SI.VolumeFlowRate kgpm3;
  algorithm
   kgpm3 := mgpl *0.001;
  end from_mg_per_l;


type lb_per_in3 = Real (final quantity="Density",final unit="lb/in3");


 function from_lb_per_in3
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.lb_per_in3 lbpi;
    output SI.VolumeFlowRate kgpm3;
  algorithm
   kgpm3 :=lbpi *27679.904710191;
  end from_lb_per_in3;


type lb_per_ft3 = Real (final quantity="Density",final unit="lb/ft3");


 function from_lb_per_ft3
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.lb_per_ft3 lbpf3;
    output SI.VolumeFlowRate kgpm3;
  algorithm
   kgpm3 :=lbpf3 * 16.018463376;
  end from_lb_per_ft3;
  
  
  
type lb_per_gallon_UK = Real (final quantity="Density",final unit="lb/gal(UK)");


 function from_lb_per_gallon_UK
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.lb_per_gallon_UK lbpg;
    output SI.VolumeFlowRate kgpm3;
  algorithm
   kgpm3 :=lbpg * 99.776372663;
  end from_lb_per_gallon_UK;
  
  
  
  
type lb_per_gallon_US = Real (final quantity="Density",final unit="lb/gal(US)");


 function from_lb_per_gallon_US
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.lb_per_gallon_US lbpg;
    output SI.VolumeFlowRate kgpm3;
  algorithm
   kgpm3 :=lbpg * 119.826427318;
  end from_lb_per_gallon_US;
  
  
  
  
type ounce_per_gallon_UK = Real (final quantity="Density",final unit="oz/gal(UK)");


 function from_ounce_per_gallon_UK
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.ounce_per_gallon_UK ozpg;
    output SI.VolumeFlowRate kgpm3;
  algorithm
   kgpm3 :=ozpg * 6.236023291;
  end from_ounce_per_gallon_UK;



  type ounce_per_gallon_US = Real (final quantity="Density",final unit="oz/gal(US)");


 function from_ounce_per_gallon_US
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.ounce_per_gallon_US ozpg;
    output SI.VolumeFlowRate kgpm3;
  algorithm
   kgpm3 :=ozpg * 7.489151707;
  end from_ounce_per_gallon_US;
  
 //molar_specific_enthalpy
 

type cal_per_mol = Real (final quantity="MolarEnergy", final unit="cal/mol");



function from_cal_per_mol
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.cal_per_mol cpm;
    output SI.MolarEnergy jpm;
  algorithm
   jpm:=cpm* 4.1868;
  end from_cal_per_mol;
  
  
  type BTU_per_mol = Real (final quantity="MolarEnergy", final unit="BTU/mol");



function from_BTU_per_mol
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.BTU_per_mol bpm;
    output SI.MolarEnergy jpm;
  algorithm
   jpm:=bpm* 1055.06;
  end from_BTU_per_mol;
  
//molar_spcific_entropy

type Kcal_per_molKelvin = Real (final quantity="MolarEntropy", final unit="Kcal/Kmol.K");

function from_Kcal_per_molKelvin
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.Kcal_per_molKelvin cpmk;
    output SI.MolarEnergy jpmk;
  algorithm
   jpmk:=cpmk* 4.1868;
  end from_Kcal_per_molKelvin;
  
//specfic enthalpy

  type BTU_per_lb = Real (final quantity="SpecificEnergy", final unit="BTU/lb");



function from_BTU_per_lb
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.BTU_per_lb bpl;
    output SI.MolarEnergy kjpkg;
  algorithm
   kjpkg:=bpl* 2.324444623E-3;
  end from_BTU_per_lb;
  
  
 type cal_per_g = Real (final quantity="SpecificEnergy", final unit="cal/g");



function from_cal_per_g
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.cal_per_g cpg;
    output SI.MolarEnergy kjpkg;
  algorithm
   kjpkg:=cpg* 4.487E-3;
  end from_cal_per_g;
   
   
   type kcal_per_kg = Real (final quantity="SpecificEnergy", final unit="kcal/kg");
   
   
function from_kcal_per_kg
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.kcal_per_kg kcpkg;
    output SI.MolarEnergy kjpkg;
  algorithm
   kjpkg:=kcpkg* 4.487E-3;
  end from_kcal_per_kg;  
  
  //molar entropy
  
type cal_per_gKelvin = Real (final quantity="SpecificEntropy", final unit="cal/g.K");


function from_cal_per_gKelvin
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.cal_per_gKelvin cpgk;
    output SI.MolarEnergy kjpkg;
  algorithm
   kjpkg:=cpgk* 4.487E-3;
  end from_cal_per_gKelvin;  
  
  
  
  type BTU_per_lb_F = Real (final quantity="SpecificEntropy", final unit="BTU/lb.F");



function from_BTU_per_lb_F
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.BTU_per_lb_F bpl;
    output SI.MolarEnergy kjpkg;
  algorithm
   kjpkg:=bpl*  4.487E-3;
  end from_BTU_per_lb_F;
  
   
 type BTU_per_lb_R = Real (final quantity="SpecificEntropy", final unit="BTU/lb.R");



function from_BTU_per_lb_R
    extends Modelica.SIunits.Icons.Conversion;
    import SI = Modelica.SIunits;
    input units.BTU_per_lb_R bpl;
    output SI.MolarEnergy kjpkg;
  algorithm
   kjpkg:=bpl*  4.487E-3;
  end from_BTU_per_lb_R;
   
  

end units;
