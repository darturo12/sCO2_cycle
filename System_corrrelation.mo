within sCO2_cycle;

model System_corrrelation
import SolarTherm.{Models,Media};
  import Modelica.SIunits.Conversions.from_degC;
  import SI = Modelica.SIunits;
  import nSI = Modelica.SIunits.Conversions.NonSIunits;
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  import FI = SolarTherm.Models.Analysis.Finances;
  import SolarTherm.Types.Solar_angles;
  import SolarTherm.Types.Currency;
  import Modelica.Math.Vectors.interpolate;
  extends Modelica.Icons.Example;
  // Input Parameters
  // *********************
  parameter Boolean match_sam = false "Configure to match SAM output";
  parameter Boolean fixed_field = false "true if the size of the solar field is fixed";
  replaceable package Medium = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph "Medium props for molten salt";
  parameter String pri_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Prices/aemo_vic_2014.motab") "Electricity price file";
  parameter Currency currency = Currency.USD "Currency used for cost analysis";
  parameter Boolean const_dispatch = true "Constant dispatch of energy";
  parameter String sch_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Schedules/daily_sch_0.motab") if not const_dispatch "Discharging schedule from a file";
  // Weather data
  parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Libro2.motab");
  parameter Real wdelay[8] = {0, 0, 0, 0, 0, 0, 0, 0} "Weather file delays";
  parameter nSI.Angle_deg lon = -116 "Longitude (+ve East)";
  parameter nSI.Angle_deg lat = 32 "Latitude (+ve North)";
  parameter nSI.Time_hour t_zone = -8 "Local time zone (UCT=0)";
  parameter Integer year = 2015 "Meteorological year";
  // Field
  parameter String opt_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Optics/example_optics.motab");
  parameter Solar_angles angles = Solar_angles.dec_hra "Angles used in the lookup table file";
  parameter Real SM = 2.7 "Solar multiple";
  parameter Real land_mult = 6.281845377885782 "Land area multiplier";
  parameter SI.Area land_non_solar = 182108.7 "Non-solar field land area";
  //45 acre. Based on NREL Gen3 SAM model v14.02.2020
  parameter Boolean polar = false "True for polar field layout, otherwise surrounded";
  parameter SI.Area A_heliostat = 144.375 "Heliostat module reflective area";
  parameter Real he_av_design = 0.99 "Heliostats availability";
  parameter SI.Efficiency eff_opt = SM * Q_flow_des / (1 - rec_fr) / (he_av_design * A_heliostat * dni_des * 8134) "Field optical efficiency at design point";
  parameter SI.Irradiance dni_des = 950 "DNI at design point";
  parameter Real C = 534.0 "Concentration ratio";
  parameter Real gnd_cvge = A_field / ((175 / 0.154) ^ 2 / twr_ht_const * CN.pi * excl_fac) "Ground coverage";
  parameter Real excl_fac = 0.97 "Exclusion factor";
  parameter Real twr_ht_const = if polar then 2.25 else 1.25 "Constant for tower height calculation";
  // Receiver
  parameter Integer N_pa_rec = 16 "Number of panels in receiver";
  parameter SI.Thickness t_tb_rec = 1.2e-3 "Receiver tube wall thickness";
  parameter SI.Diameter D_tb_rec = 34.8e-3 "Receiver tube outer diameter";
  parameter Real ar_rec = 21.6 / 17.65 "Height to diameter aspect ratio of receiver aperture";
  //Based on NREL Gen3 SAM model v14.02.2020
  parameter SI.Efficiency ab_rec = 0.98 "Receiver coating absorptance";
  parameter SI.Efficiency em_rec = 0.91 "Receiver coating emissivity";
  parameter SI.RadiantPower R_des(fixed = if fixed_field then true else false) "Input power to receiver at design point";
  parameter Real rec_fr = 0.208 "Receiver loss fraction of radiance at design point";
  parameter SI.Temperature rec_T_amb_des = 298.15 "Ambient temperature at design point";
  // Storage
  parameter Real t_storage(fixed = true, unit = "h") = 12.0 "Hours of storage";
  //Based on NREL Gen3 SAM model v14.02.2020
  parameter SI.Temperature T_cold_set = CV.from_degC(500) "Cold tank target temperature";
  //Based on NREL Gen3 SAM model v14.02.2020
  parameter SI.Temperature T_hot_set = CV.from_degC(720) "Hot tank target temperature";
  //Based on NREL Gen3 SAM model v14.02.2020
  parameter SI.Temperature T_cold_start = CV.from_degC(500) "Cold tank starting temperature";
  //Based on NREL Gen3 SAM model v14.02.2020
  parameter SI.Temperature T_hot_start = CV.from_degC(720) "Hot tank starting temperature";
  //Based on NREL Gen3 SAM model v14.02.2020
  parameter SI.Temperature T_cold_aux_set = CV.from_degC(450) "Cold tank auxiliary heater set-point temperature";
  //Based on NREL Gen3 SAM model v14.02.2020
  parameter SI.Temperature T_hot_aux_set = CV.from_degC(575) "Hot tank auxiliary heater set-point temperature";
  //Based on NREL Gen3 SAM model v14.02.2020
  parameter Medium.ThermodynamicState state_cold_set = Medium.setState_pTX(Medium.p_default, T_cold_set) "Cold salt thermodynamic state at design";
  parameter Medium.ThermodynamicState state_hot_set = Medium.setState_pTX(Medium.p_default, T_hot_set) "Hold salt thermodynamic state at design";
  parameter Real tnk_fr = 0.01 "Tank loss fraction of tank in one day at design point";
  parameter SI.Temperature tnk_T_amb_des = 298.15 "Ambient temperature at design point";
  parameter Real split_cold = 0.7 "Starting medium fraction in cold tank";
  parameter Boolean tnk_use_p_top = true "true if tank pressure is to connect to weather file";
  parameter Boolean tnk_enable_losses = true "true if the tank heat loss calculation is enabled";
  parameter SI.CoefficientOfHeatTransfer alpha = 0.35 "Tank constant heat transfer coefficient with ambient";
  parameter SI.SpecificEnergy k_loss_cold = 0.15e3 "Cold tank parasitic power coefficient";
  parameter SI.SpecificEnergy k_loss_hot = 0.55e3 "Hot tank parasitic power coefficient";
  parameter SI.Power W_heater_hot = 30e6 "Hot tank heater capacity";
  parameter SI.Power W_heater_cold = 15e6 "Cold tank heater capacity";
  parameter Real tank_ar = 9.2 / 60.1 "storage aspect ratio";
  // Power block
  replaceable model Cycle = Models.PowerBlocks.Correlation.sCO2 "sCO2 cycle regression model";
  parameter SI.Temperature T_comp_in = 318.15 "Compressor inlet temperature at design";
  replaceable model Cooling = Models.PowerBlocks.Cooling.DryCooling "PB cooling model";
  parameter SI.Power P_gross(fixed = if fixed_field then false else true) = 111e6 "Power block gross rating at design point";
  parameter SI.Efficiency eff_blk = 0.51 "Power block efficiency at design point";
  parameter Real par_fr = 0.099099099 "Parasitics fraction of power block rating at design point";
  parameter Real par_fix_fr = 0.0055 "Fixed parasitics as fraction of gross rating";
  parameter Boolean blk_enable_losses = true "true if the power heat loss calculation is enabled";
  parameter Boolean external_parasities = true "true if there is external parasitic power losses";
  parameter Real nu_min_blk = 0.5 "minimum allowed part-load mass flow fraction to power block";
  parameter SI.Power W_base_blk = par_fix_fr * P_gross "Power consumed at all times in power block";
  parameter SI.AbsolutePressure p_blk = 10e6 "Power block operating pressure";
  parameter SI.Temperature blk_T_amb_des = from_degC(35) "Ambient temperature at design for power block";
  parameter SI.Temperature par_T_amb_des = from_degC(25) "Ambient temperature at design point";
  parameter Real nu_net_blk = 0.9 "Gross to net power conversion factor at the power block";
  parameter SI.Temperature T_in_ref_blk = from_degC(720) "HTF inlet temperature to power block at design";
  //Based on NREL Gen3 SAM model v14.02.2020
  parameter SI.Temperature T_out_ref_blk = from_degC(500) "HTF outlet temperature to power block at design";
  // Control
  parameter SI.Time t_ramping = 1800 "Power block startup delay";
  parameter SI.Angle ele_min = 0.13962634015955 "Heliostat stow deploy angle";
  parameter Boolean use_wind = true "true if using wind stopping strategy in the solar field";
  parameter SI.Velocity Wspd_max = 15 if use_wind "Wind stow speed";
  parameter Real max_rec_op_fr = 1.2 "Maximum receiver operation fraction";
  parameter Real nu_start = 0.25 "Minimum energy start-up fraction to start the receiver";
  //Based on NREL SAM model from 14.02.2020
  parameter Real nu_min_sf = 0.3 * 330 / 294.18 / SM "Minimum turn-down energy fraction to stop the receiver";
  parameter Real nu_defocus = 0.57 "Energy fraction of the receiver design output at defocus state";
  // This only works if const_dispatch=true. TODO for variable disptach Q_flow_defocus should be turned into an input variable to match the field production rate to the dispatch rate to the power block.
  parameter Real hot_tnk_empty_lb = 180 / H_storage "Hot tank empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real hot_tnk_empty_ub = 1 "Hot tank empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real hot_tnk_full_lb = 123 "Hot tank full trigger lower bound (L_df_off) Level to stop defocus";
  parameter Real hot_tnk_full_ub = 120 "Hot tank full trigger upper bound (L_df_on) Level of start defocus";
  parameter Real cold_tnk_defocus_lb = 5 "Cold tank empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real cold_tnk_defocus_ub = 7 "Cold tank empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real cold_tnk_crit_lb = 0 "Cold tank critically empty trigger lower bound";
  // Level (below which) to stop disptach
  parameter Real cold_tnk_crit_ub = 30 "Cold tank critically empty trigger upper bound";
  // Level (above which) to start disptach
  parameter Real Ti = 0.1 "Time constant for integral component of receiver control";
  parameter Real Kp = -1000 "Gain of proportional component in receiver control";
  // Calculated Parameters
  parameter SI.HeatFlowRate Q_rec_out = 50.4E6 "Receiver thermal output at design point";
  parameter SI.HeatFlowRate Q_flow_des = if fixed_field then if match_sam then R_des / ((1 + rec_fr) * SM) else R_des * (1 - rec_fr) / SM else P_gross / eff_blk "Heat to power block at design";
  parameter SI.Energy E_max = t_storage * 3600 * Q_flow_des "Maximum tank stored energy";
  parameter SI.Area A_field = A_heliostat * n_heliostat "Heliostat field reflective area";
  parameter Integer n_heliostat = heliostatsField.n_h "Number of heliostats";
  parameter SI.Area A_receiver = D_receiver ^ 2 * (CN.pi * ar_rec) "Receiver aperture area";
  parameter SI.Diameter D_receiver = receiver.D_rcv "Receiver diameter";
  parameter SI.Length H_receiver = D_receiver * ar_rec "Receiver height";
  parameter SI.Area A_land = land_mult * A_field + land_non_solar "Land area";
  parameter SI.SpecificEnthalpy h_cold_set = Medium.specificEnthalpy(state_cold_set) "Cold salt specific enthalpy at design";
  parameter SI.SpecificEnthalpy h_hot_set = Medium.specificEnthalpy(state_hot_set) "Hot salt specific enthalpy at design";
  parameter SI.Density rho_cold_set = Medium.density(state_cold_set) "Cold salt density at design";
  parameter SI.Density rho_hot_set = Medium.density(state_hot_set) "Hot salt density at design";
  parameter SI.Mass m_max = E_max / (h_hot_set - h_cold_set) "Max salt mass in tanks";
  parameter SI.Volume V_max = m_max / ((rho_hot_set + rho_cold_set) / 2) "Max salt volume in tanks";
  //Based on NREL Gen3 SAM model v14.02.2020
  parameter SI.MassFlowRate m_flow_fac = 197.5 "Mass flow rate to receiver at design point";
  parameter SI.MassFlowRate m_flow_rec_max = max_rec_op_fr * m_flow_fac "Maximum mass flow rate to receiver";
  parameter SI.MassFlowRate m_flow_rec_start = 0.81394780966 * m_flow_fac "Initial or guess value of mass flow rate to receiver in the feedback controller";
  parameter SI.MassFlowRate m_flow_blk = Q_flow_des / (h_hot_set - h_cold_set) "Mass flow rate to power block at design point";
  parameter SI.Power P_net = (1 - par_fr) * P_gross "Power block net rating at design point";
  parameter SI.Power P_name = P_net "Nameplate rating of power block";
  parameter SI.Length tank_min_l = 1.8 "Storage tank fluid minimum height";
  //Based on NREL Gen3 SAM model v14.02.2020
  parameter SI.Length H_storage = (4 * V_max * tank_ar ^ 2 / CN.pi) ^ (1 / 3) + tank_min_l "Storage tank height";
  //Adjusted to obtain a height of 11 m for 12 hours of storage based on NREL Gen3 SAM model v14.02.2020
  parameter SI.Diameter D_storage = (0.5 * V_max / (H_storage - tank_min_l) * 4 / CN.pi) ^ 0.5 "Storage tank diameter";
  //Adjusted to obtain a diameter of 42.5m for 12 hours of storage based on NREL Gen3 SAM model v14.02.2020
  parameter SI.Length H_tower = receiver.H_tower "Tower height";
  // A_field/(gnd_cvge*excl_fac) is the field gross area
  parameter SI.Diameter D_tower = D_receiver "Tower diameter";
  // That's a fair estimate. An accurate H-to-D correlation may be used.
  //PowerBlock Cost
  //**************************************************************************************************************************************
  // OVERNIGHT TURBOMAQUINARY COST
  parameter Real UF = 1.18 "Money conversion factor (euro to dollar)";
  parameter Integer which_PB_model = 1 "Choice of the Expensive PB model: 0 is for CEA power block, 1 is for NREL-SAM power block";
  //parameter Real Powerblock_design[12](each fixed = false) if which_PB_model == 1 "array to store design point sizing result";
  parameter SI.Efficiency eta1 = 0.89 "Design maximal compressor isentropic efficiency ";
  parameter SI.Efficiency eta2 = 0.93 "Design turbine isentropic efficiency ";
  parameter SI.Area A(fixed = false) "Heat transfer area of heat exchanger at design";
  parameter SI.Temperature T_in_turb = from_degC(700) "Turbine inlet temperature (K) at design";
  parameter SI.Temperature T_in_comp = from_degC(45) "Compressor inlet tempeature (K) at design";
  parameter SI.Pressure P_in_turb = 25e3 "Turbine inlet pressure (kPa) at design";
  parameter SI.Pressure P_in_comp = 25e3 / SPR_comp "Compressor inlet pressure (kPa) at design";
  parameter SI.Temperature T_air_turb = from_degC(1273) "Turbine air equivalent temperature(K)";
  parameter SI.Temperature T_air_comp = from_degC(298) "Compressor air equivalent temperature(K)";
  parameter SI.Pressure P_air_turb = 20 * 101.325;
  //"Turbine air equivalent pressure(kPa)"
  parameter SI.Pressure P_air_comp = 101.325;
  //"Compressor air equivalent pressure(kPa)"
  parameter SI.Pressure P_op = p_blk "Power block operating pressure";
  parameter Real ins_main_turbine = 4.1;
  parameter Real ins_main_compressor = 4.8 "Indicative number of stages";
  parameter SI.Efficiency SPR_turb = 3 "Turbine pressure ratio at design";
  parameter SI.Efficiency SPR_comp = 3 "Compressor pressure at design";
  parameter SI.MassFlowRate m_flow_turb = 77.8 "Turbine mass flow rate at design";
  parameter SI.MassFlowRate m_flow_comp = 77.8 "Compressor mass flow rate at design";
  parameter Real Cst = 1 "Costant for efects of variation of gamma and R";
  parameter Real gamma_air = 1.4 "Heat capacity ratio of air (Cp/Cv)";
  parameter Real gamma_CO2 = 1.289 "Heat capacity ratio of CO2";
  parameter Real R_air = 0.2108 "Air gas constant (kJ/kg*K)";
  parameter Real R_CO2 = 0.1889 "CO2 gas constant (kJ/kg*K)";
  // OTHERS INVESTMENT COSTS
  parameter Real TA = 0.09 "Porcentaje tubería y accesorios";
  parameter Real IE = 0.2 "Porcentaje instalación equipos";
  parameter Real IC = 0.05 "Porcentaje instalación y control";
  parameter Real EME = 0.04 "Porcentaje equipos y materiales electricos";
  parameter Real TECA = 0.05 "Porcentaje trabajo estructural civil y arquitectonico";
  parameter Real INGSUP = 0.3 "Porcentaje ingeniería y supervisión";
  parameter Real CCUC = 0.15 "Costo de construcción y utilidad del contratista";
  parameter Real IMPR = 0.15 "Porcentaje imprevistos";
  parameter Real ap = 0.15 "AFUDC percentage";
  parameter Real TERR = 0 "Costo terreno";
  parameter Real SDI = 0 "porcentaje servicio de instalación";
  parameter Real TCRED = 0.05 "Cost of capital interest rate";
  //Heat transfer area heat exchanger calculation
  parameter SI.Diameter Dh = 1.5 "Heat exchanger hydraulic diameter";
  parameter Real T_c = from_degC(131.763) "Design cold temperature - heat exchanger";
  parameter Real T_h = from_degC(547.216) "Design hot temperature - heat exchanger";
  parameter Real UA(unit = "kW/K") = 1.500 "Design conductance of the overall exchanger";
  final constant Real pi = 2 * Modelica.Math.asin(1.0);
  // 3.14159265358979
  //For interpolation
  parameter Real Tx[11] = {0, 50, 100, 150, 200, 300, 400, 500, 1000, 1500, 2000} "Temperature data vector for interpolation";
  parameter Real miuy[11] = {0.00001375, 0.00001612, 0.00001841, 0.00002063, 0.00002276, 0.00002682, 0.00003061, 0.00003416, 0.00004898, 0.00006106, 0.00007322} "Dynamic viscosity data vector for interpolation";
  parameter Real Pry[11] = {0.7661, 0.7520, 0.7464, 0.7445, 0.7442, 0.7450, 0.7458, 0.7460, 0.755, 0.7745, 0.8815} "Prandtl data vector for interpolation";
  parameter Real Kty[11] = {0.01456, 0.01858, 0.02257, 0.02652, 0.03044, 0.038154, 0.04565, 0.05293, 0.08491, 0.10688, 0.11522} "Thermal conductivity data vector for interpolation";
  parameter Real miu_c(fixed = false) "Cold dynamic viscosity";
  parameter Real miu_h(fixed = false) "Hot dynamic viscosity";
  parameter Real Pr_c(fixed = false) "Prandtl for cold stream";
  parameter Real Pr_h(fixed = false) "Prandtl for hot stream";
  parameter Real Kt_c(fixed = false) "Cold thermal conductivity";
  parameter Real Kt_h(fixed = false) "Hot thermal conductivity";
  // For U calculation
  parameter SI.MassFlowRate m(fixed = false) "Heat exchanger mass flow rate";
  parameter Real Re_c(fixed = false) "Reynolds for cold stream";
  parameter Real Re_h(fixed = false) "Reynolds for hot stream";
  parameter Real h_cold(fixed = false) "Cold convective heat transfer coefficient";
  parameter Real h_hot(fixed = false) "Hot convective heat transfer coefficient";
  parameter Real U(fixed = false) "Coeficiente total de transferencia";
  //Calculated PowerBlock cost
  // Calculos previos
  parameter Real Nt = 927 / (1 - eta2) "Turbine efficiency factor";
  parameter Real Nc = 39 / (1 - eta1) "Compressor efficiency factor";
  parameter Real PR_equiv_comp = SPR_comp ^ ins_main_compressor;
  // Pressure ratio main compressor
  parameter Real PR_equiv_turb = SPR_turb ^ ins_main_turbine;
  // Pressure ratio main turbine
  // Initial calculations for equivalent mass
  parameter Real P_turb = P_air_turb / P_in_turb;
  // Razón de presiones, turbina (air/CO2)
  parameter Real P_comp = P_air_comp / P_in_comp;
  // Razón de presiones, compresor (air/CO2)
  parameter Real gamma = gamma_air / gamma_CO2;
  // Equivalent heat capacity ratio factor (air/CO2)
  parameter Real R = R_CO2 / R_air;
  // Razón de constantes de gas (CO2/air)
  // Costo de los equipos
  parameter SI.MassFlowRate m_equic = Cst * m_flow_comp * P_comp * sqrt(gamma * R * (T_in_comp / T_air_comp)) "Flujo másico equivalente compresor";
  parameter SI.MassFlowRate m_equit = Cst * m_flow_turb * P_turb * sqrt(gamma * R * (1 / T_air_turb)) "Flujo másico equivalente turbina";
  parameter FI.Money_USD cost_compressor = UF * Nc * m_equic * PR_equiv_comp * log(PR_equiv_comp) "Costo compresor principal";
  parameter FI.Money_USD cost_turbine = UF * Nt * m_equit * PR_equiv_turb * log(PR_equiv_turb) * (1 + exp(0.036 * T_in_turb - 31.86)) "Costo turbina principal";
  parameter FI.Money_USD cost_HTR = 3 * UF * 2111 * A ^ 0.69 * P_op ^ 0.28 "Costo recuperator";
  parameter FI.Money_USD cost = cost_compressor + cost_turbine + cost_HTR "Costo del ciclo";
  // Others investment costs (percentage of the total investment cost)
  parameter FI.Money_USD TEC = cost "Costo total de los equipos";
  parameter FI.Money_USD TONSC = TEC * (1 + IE + TA + IC + EME) "Total on-site cost";
  parameter FI.Money_USD TOFSC = TEC * (TECA + SDI) + TERR "Total off-site cost";
  parameter FI.Money_USD TDC = TONSC + TOFSC "Total direct cost";
  parameter FI.Money_USD TIC = TEC * INGSUP + TDC * CCUC "Total indirect cost";
  parameter FI.Money_USD TFCI = (TDC + TIC) * (1 + IMPR) "Total fixed capital investment";
  parameter FI.Money_USD PFI = TFCI + TERR "Plant facilities investment";
  //*********************************************************************************************************************************************
  // Cost data in USD (default) or AUD
  parameter Real r_disc = 0.05 "Real discount rate";
  //Calculated to obtain a nominal discount rate of 0.0701, based on Downselect Criteria, Table 2
  parameter Real r_i = 0.025 "Inflation rate";
  //Based on Downselect Criteria, Table 2
  parameter Integer t_life(unit = "year") = 30 "Lifetime of plant";
  //Based on Downselect Criteria, Table 2
  //parameter Integer t_cons(unit = "year") = 0 "Years of construction";
  //Based on Downselect Criteria, Table 2 it should be 3, but for LCOE simple calculation is set to 0
  parameter Real r_cur = 0.71 "The currency rate from AUD to USD";
  // Valid for 2019. See https://www.rba.gov.au/
  parameter Real f_Subs = 0 "Subsidies on initial investment costs";
  parameter FI.AreaPrice pri_field = if currency == Currency.USD then 75 else 75 / r_cur "Field cost per design aperture area";
  //Field cost per area set to the target value based on DOE 2020 SunShot target, Table 5-1 (https://www.energy.gov/sites/prod/files/2014/01/f7/47927_chapter5.pdf)
  parameter FI.AreaPrice pri_site = if currency == Currency.USD then 10 else 10 / r_cur "Site improvements cost per area";
  //Site improvements cost per area set to the target value based on DOE 2020 SunShot target, Table 5-1 (https://www.energy.gov/sites/prod/files/2014/01/f7/47927_chapter5.pdf)
  parameter FI.EnergyPrice pri_storage = if currency == Currency.USD then 40 / (1e3 * 3600) else 40 / (1e3 * 3600) / r_cur "Storage cost per energy capacity";
  //Storage cost per energy capacity $40/kWht estimate from Devon. The based on DOE 2020 SunShot target is $15/kWht (Table 5-1, https://www.energy.gov/sites/prod/files/2014/01/f7/47927_chapter5.pdf)
  parameter FI.PowerPrice pri_block = if currency == Currency.USD then 900 / 1e3 else 900 / r_cur "Power block cost per gross rated power";
  //Power block cost should be $600/kWe + Primary HX based on Downselection Criteria, page 8, paragraph 7. NREL uses $900/kWe for now to account for PHX.
  parameter FI.PowerPrice pri_bop = if currency == Currency.USD then 0 * 350 / 1e3 else 0 * 350 / 1e3 / r_cur "Balance of plant cost per gross rated power";
  // Balance of plant set to 350 based on SAM 2018 default costing data
  parameter FI.AreaPrice pri_land = if currency == Currency.USD then 10000 / 4046.86 else 10000 / 4046.86 / r_cur "Land cost per area";
  //Land cost set to $10k/acre based on Downselect Criteria, Table 2
  parameter Real pri_om_name(unit = "$/W/year") = if currency == Currency.USD then 40 / 1e3 else 40 / 1e3 / r_cur "Fixed O&M cost per nameplate per year";
  //Fixed O&M Costs set to the target value based on Downselect Criteria, Table 2
  parameter Real pri_om_prod(unit = "$/J/year") = if currency == Currency.USD then 3 / (1e6 * 3600) else 3 / (1e6 * 3600) / r_cur "Variable O&M cost per production per year";
  //Variable O&M Costs set to the target value based on Downselect Criteria, Table 2
  parameter FI.Money_USD C_receiver_ref = 100693310.466007 "Receiver reference Cost";
  //Receiver reference cost updated to match estimated total cost of $152.9M for a receiver aperture area of 2199.11m2 (H=20m, D=35m)
  parameter SI.Area A_receiver_ref = 1571 "Receiver reference area";
  //Receiver reference area set to 1751m2 based on SAM default
  // Calculated costs
  parameter FI.Money_USD C_piping = 18966200 "Piping cost (Riser/Downcomer) including insulation";
  //Based on Chad's last spreadsheet
  //parameter FI.Money_USD C_pumps = 4648000 "Cold Salt pumps";
  //Based on Chad's last spreadsheet
  parameter FI.Money_USD C_field = pri_field * A_field "Field cost";
  parameter FI.Money_USD C_site = pri_site * A_field "Site improvements cost";
  parameter FI.Money_USD C_tower(fixed = false) "Tower cost";
  parameter FI.Money_USD C_receiver = if currency == Currency.USD then C_receiver_ref * (A_receiver / A_receiver_ref) ^ 0.7 else C_receiver_ref * (A_receiver / A_receiver_ref) ^ 0.7 / r_cur "Receiver cost";
  parameter FI.Money_USD C_storage = pri_storage * E_max "Storage cost";
  //parameter FI.Money_USD C_block = pri_block * P_gross "Power block cost";
  parameter FI.Money_USD C_bop = pri_bop * P_gross "Balance of plant cost";
  parameter FI.Money_USD C_cap_dir_sub = (1 - f_Subs) * (C_field + C_site + C_tower + C_receiver + C_storage / 2 + TFCI + C_bop + C_piping) "Direct capital cost subtotal";
  // i.e. purchased equipment costs
  parameter FI.Money_USD C_contingency = 0.1 * C_cap_dir_sub "Contingency costs";
  //Based on Downselect Criteria, Table 2
  parameter FI.Money_USD C_cap_dir_tot = C_cap_dir_sub + C_contingency "Direct capital cost total";
  parameter FI.Money_USD C_EPC = 0.09 * C_cap_dir_tot "Engineering, procurement and construction(EPC) and owner costs";
  //Based on Downselect Criteria, Table 2
  parameter FI.Money_USD C_land = pri_land * A_land "Land cost";
  parameter FI.Money_USD C_cap = C_cap_dir_tot + C_EPC + C_land "Total capital (installed) cost";
  parameter FI.MoneyPerYear C_year = pri_om_name * P_name "Fixed O&M cost per year";
  parameter Real C_prod(unit = "$/J/year") = pri_om_prod "Variable O&M cost per production per year";
  parameter Real CRF = r_disc * (1 + r_disc) ^ t_life / ((1 + r_disc) ^ t_life - 1) "Capital recovery factor";
  // System components
  // *********************
  //Weather data
  SolarTherm.Models.Sources.DataTable.DataTable data(lon = lon, lat = lat, t_zone = t_zone, year = year, file = wea_file) annotation(
    Placement(visible = true, transformation(extent = {{-132, -56}, {-102, -28}}, rotation = 0)));
  //DNI_input
  Modelica.Blocks.Sources.RealExpression DNI_input(y = data.DNI) annotation(
    Placement(transformation(extent = {{-140, 60}, {-120, 80}})));
  //Tamb_input
  Modelica.Blocks.Sources.RealExpression Tamb_input(y = data.Tdry) annotation(
    Placement(visible = true, transformation(extent = {{154, 72}, {134, 92}}, rotation = 0)));
  //WindSpeed_input
  Modelica.Blocks.Sources.RealExpression Wspd_input(y = data.Wspd) annotation(
    Placement(transformation(extent = {{-140, 20}, {-114, 40}})));
  //pressure_input
  Modelica.Blocks.Sources.RealExpression Pres_input(y = data.Pres) annotation(
    Placement(visible = true, transformation(extent = {{156, -106}, {136, -86}}, rotation = 0)));
  //parasitic inputs
  // Or block for defocusing
  //Sun
  SolarTherm.Models.Sources.SolarModel.Sun sun(lon = data.lon, lat = data.lat, t_zone = data.t_zone, year = data.year, redeclare function solarPosition = Models.Sources.SolarFunctions.PSA_Algorithm) annotation(
    Placement(visible = true, transformation(extent = {{-80, 62}, {-60, 82}}, rotation = 0)));
  // Solar field
  SolarTherm.Models.CSP.CRS.HeliostatsField.HeliostatsFieldSAM heliostatsField(redeclare model Optical = Models.CSP.CRS.HeliostatsField.Optical.Table(angles = angles, file = opt_file), A_h = A_heliostat, Q_design = Q_rec_out, Wspd_max = Wspd_max, ele_min(displayUnit = "deg") = ele_min, he_av = he_av_design, lat = data.lat, lon = data.lon, n_h = 1800, nu_defocus = nu_defocus, nu_min = nu_min_sf, nu_start = nu_start, use_defocus = false, use_on = true, use_wind = use_wind) annotation(
    Placement(visible = true, transformation(extent = {{-86, 2}, {-54, 36}}, rotation = 0)));
  // Receiver
  SolarTherm.Models.CSP.CRS.Receivers.ChlorideSaltReceiver receiver(redeclare package Medium = Medium, D_rcv = 7.6, D_tb = D_tb_rec, H_rcv = 9.301, N_pa = 16, ab = ab_rec, const_alpha = true, em = em_rec, m_flow_rec_des = 197.8, t_tb = t_tb_rec) annotation(
    Placement(visible = true, transformation(extent = {{-42, 4}, {-6, 40}}, rotation = 0)));
  // Hot tank
  // Pump hot
  // Cold tank
  // Pump cold
  // PowerBlockControl
  // ReceiverControl
  // Power block
  // Price
  // TODO Needs to be configured in instantiation if not const_dispatch. See SimpleResistiveStorage model
  SolarTherm.Models.Sources.Schedule.Scheduler sch if not const_dispatch;
  // Variables:
  SI.Power P_elec "Output power of power block";
  SI.Energy E_elec(start = 0, fixed = true, displayUnit = "MW.h") "Generate electricity";
  FI.Money R_spot(start = 0, fixed = true) "Spot market revenue";
  Modelica.Blocks.Sources.Constant const1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {76, 122}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = 1.2) annotation(
    Placement(visible = true, transformation(origin = {28, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = 1e5) annotation(
    Placement(visible = true, transformation(origin = {-6, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.PowerBlocks.sCO2CycleNREL sCO2CycleNREL(redeclare package Medium = Medium, E_gross(displayUnit = "J"), E_net(displayUnit = "J"), enable_losses = true) annotation(
    Placement(visible = true, transformation(origin = {106, 25}, extent = {{-20, -21}, {20, 21}}, rotation = 0)));
  sCO2_cycle.Cold_tank cold_tank annotation(
    Placement(visible = true, transformation(origin = {52, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SolarTherm.Models.Analysis.Market market(redeclare model Price = SolarTherm.Models.Analysis.EnergyPrice.Constant) annotation(
    Placement(visible = true, transformation(origin = {138, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation
//Heat transfer area - Heat exchanger
  miu_c = interpolate(Tx, miuy, T_c) "Cold dynamic viscosity";
  miu_h = interpolate(Tx, miuy, T_h) "Hot dynamic viscosity";
  Pr_c = interpolate(Tx, Pry, T_c) "Prandtl for cold stream";
  Pr_h = interpolate(Tx, Pry, T_h) "Prandtl for hot stream";
  Kt_c = interpolate(Tx, Kty, T_c) "Thermal conductivity cold stream";
  Kt_h = interpolate(Tx, Kty, T_h) "Thermal conductivity hot stream";
// Calculate U
  m = 77.8 "Heat exchanger mass flow rate";
  Re_c = 4 * m / Dh * miu_c * pi "Reynolds for cold stream";
  Re_h = 4 * m / Dh * miu_h * pi "Reynolds for hot stream";
  h_cold = 0.78 * Re_c ^ 0.5 * Pr_c ^ (1 / 3) * Kt_c / Dh "Cold convective heat transfer coefficient";
  h_hot = 0.78 * Re_h ^ 0.5 * Pr_h ^ (1 / 3) * Kt_h / Dh "Hot convective heat transfer coefficient";
  U = (h_hot + h_cold) / (h_hot * h_cold) "Coeficiente total de transferencia";
//Heat transfer Area
  A = UA / U "Heat exchanger transfer area";
  if fixed_field then
    P_gross = Q_flow_des * eff_cyc;
  else
    R_des = if match_sam then SM * Q_flow_des * (1 + rec_fr) else SM * Q_flow_des / (1 - rec_fr);
  end if;
  if H_tower > 120 then
// then use concrete tower
    C_tower = if currency == Currency.USD then 7612816.32266742 * exp(0.0113 * H_tower) else 7612816.32266742 * exp(0.0113 * H_tower) / r_cur "Tower cost";
//"Tower cost fixed" updated to match estimated total cost of $55M from analysis of tower costs based on Abengoa report
  else
// use Latticework steel tower
    C_tower = if currency == Currency.USD then 80816 * exp(0.00879 * H_tower) else 80816 * exp(0.00879 * H_tower) / r_cur "Tower cost";
//"Tower cost fixed" updated to match estimated total cost of $125k for a 50 m tower where EPC & Owner costs are 11% of Direct Costs
  end if;
equation
//Connections from data
  connect(DNI_input.y, sun.dni) annotation(
    Line(points = {{-119, 70}, {-98, 70}, {-98, 72}, {-81, 72}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(Wspd_input.y, heliostatsField.Wspd) annotation(
    Line(points = {{-112.7, 30}, {-86, 30}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
// controlCold connections
// controlHot connections
//Solar field connections i.e. solar.heat port and control
  connect(sun.solar, heliostatsField.solar) annotation(
    Line(points = {{-70, 62}, {-70, 36}}, color = {255, 128, 0}));
  connect(heliostatsField.heat, receiver.heat) annotation(
    Line(points = {{-54, 27.5}, {-54.82, 27.5}, {-54.82, 27}, {-42, 27}}, color = {191, 0, 0}));
  connect(heliostatsField.on, receiver.on) annotation(
    Line(points = {{-70, 2}, {-70, -20}, {-44, -20}, {-44, 5}, {-27, 5}}, color = {255, 0, 255}));
  connect(receiver.Tamb, Tamb_input.y) annotation(
    Line(points = {{-24, 36}, {-24, 82}, {133, 82}}, color = {0, 0, 127}));
//PowerBlock connections
  connect(const1.y, sCO2CycleNREL.parasities) annotation(
    Line(points = {{87, 122}, {110, 122}, {110, 38}}, color = {0, 0, 127}));
  connect(sCO2CycleNREL.T_amb, Tamb_input.y) annotation(
    Line(points = {{102, 38}, {102, 82}, {134, 82}}, color = {0, 0, 127}));
// Fluid connections
  connect(const3.y, cold_tank.p_in) annotation(
    Line(points = {{6, -56}, {30, -56}, {30, -8}, {50, -8}, {50, -20}}, color = {0, 0, 127}));
  connect(sCO2CycleNREL.fluid_a, receiver.fluid_b) annotation(
    Line(points = {{98, 32}, {-18, 32}, {-18, 30}}, color = {0, 127, 255}));
  connect(sCO2CycleNREL.W_net, market.W_net) annotation(
    Line(points = {{116, 24}, {128, 24}}, color = {0, 0, 127}));
  P_elec = sCO2CycleNREL.W_net;
  E_elec = sCO2CycleNREL.E_net;
  R_spot = market.profit;
  connect(cold_tank.fluid_a, sCO2CycleNREL.fluid_b) annotation(
    Line(points = {{62, -34}, {82, -34}, {82, 16}, {94, 16}, {94, 16}}, color = {0, 127, 255}));
  connect(cold_tank.fluid_b, receiver.fluid_a) annotation(
    Line(points = {{42, -34}, {6, -34}, {6, 8}, {-20, 8}, {-20, 6}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -120}, {160, 140}}, initialScale = 0.1), graphics = {Text(lineColor = {217, 67, 180}, extent = {{-50, -40}, {-14, -40}}, textString = "on/off strategy", fontSize = 9), Text(origin = {2, 2}, extent = {{-52, 8}, {-4, -12}}, textString = "Receiver", fontSize = 6, fontName = "CMU Serif"), Text(origin = {12, 4}, extent = {{-110, 4}, {-62, -16}}, textString = "Heliostats Field", fontSize = 6, fontName = "CMU Serif"), Text(origin = {-8, -20}, extent = {{-80, 86}, {-32, 66}}, textString = "Sun", fontSize = 6, fontName = "CMU Serif"), Text(origin = {20, 12}, extent = {{30, -24}, {78, -44}}, textString = "Cold Tank", fontSize = 6, fontName = "CMU Serif"), Text(origin = {6, -2}, extent = {{80, 12}, {128, -8}}, textString = "Power Block", fontSize = 6, fontName = "CMU Serif"), Text(origin = {6, 0}, extent = {{112, 16}, {160, -4}}, textString = "Market", fontSize = 6, fontName = "CMU Serif"), Text(origin = {2, 4}, extent = {{-6, 20}, {42, 0}}, textString = "Receiver Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {2, 32}, extent = {{30, 62}, {78, 42}}, textString = "Power Block Control", fontSize = 6, fontName = "CMU Serif"), Text(origin = {8, -26}, extent = {{-146, -26}, {-98, -46}}, textString = "Data Source", fontSize = 7, fontName = "CMU Serif")}),
    Icon(coordinateSystem(extent = {{-140, -120}, {160, 140}})),
    experiment(StopTime = 3.1536e+07, StartTime = 0, Tolerance = 0.0001, Interval = 1800),
    __Dymola_experimentSetupOutput,
    Documentation(revisions = "<html>

	<ul>

	<li> D.Martinez y J.Negrete (Septiembre 2021) :<br>Segunda Versión. </li>

	</ul>

	</html>"));


end System_corrrelation;