package IdealGasData "Data for thermodynamic properties" 
  
  //Changed by Jonas : 2000-11-27 at 12.00 (moved icons to Icons.Images)
  //Changed by Falko : 2000-10-25 at 12.00 (new library structure)
  
  import Modelica.SIunits ;
  import ThermoFluid.Icons.Images;
  extends Icons.Images.BaseLibrary;

record PPDataRecord "prototype for data records"
  extends Images.PropertyData;
  parameter SIunits.MolarMass MM=-1;
  parameter SIunits.SpecificEnthalpy Hf=-1;
  parameter SIunits.SpecificEnthalpy H0=-1;
  parameter SIunits.Temp_K Tlimit=-1;
  parameter Integer[2] Ncoeff={7,7};
  parameter Real[Ncoeff[1]] alow={0,0,0,0,0,0,0};
  parameter Real[2] blow={0,0};
  parameter Real[Ncoeff[2]] ahigh={0,0,0,0,0,0,0};
  parameter Real[2] bhigh={0,0};
  parameter SIunits.SpecificHeatCapacity R=1.0;  
end PPDataRecord;

record IdealGasAirData "Property data for air" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0289651785;
    constant SIunits.SpecificEnthalpy Hf=-4333.82449205345;
    constant SIunits.SpecificEnthalpy H0=298609.0349831609;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={10099.5016,-196.827561,5.00915511,-
        0.00576101373,0.000010668599299999999,-7.94029797e-9,
        2.1852319100000003e-12};
    constant Real[2] blow={-176.796731,-3.92150098};
    constant Real[Ncoeff[2]] ahigh={241521.44299999997,-1257.8746,5.14455867,
        -0.00021385417900000002,7.06522784e-8,-1.07148349e-11,6.57780015e-16};
    constant Real[2] bhigh={6462.26319,-8.14740866};
    constant SIunits.SpecificHeatCapacity R=8.314472/MM;
  end IdealGasAirData;
  
  record IdealGasArData "Property data for argon" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.039948;
    constant SIunits.SpecificEnthalpy Hf=0.;
    constant SIunits.SpecificEnthalpy H0=155137.3785921698;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={0.,0.,2.5,0.,0.,0.,0.};
    constant Real[2] blow={-745.375,4.37967491};
    constant Real[Ncoeff[2]] ahigh={0.,0.,2.5,0.,0.,0.,0.};
    constant Real[2] bhigh={-745.375,4.37967491};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasArData;
  
  record IdealGasH2OData "Property data for water" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.01801528;
    constant SIunits.SpecificEnthalpy Hf=-1.3423382817252908e7;
    constant SIunits.SpecificEnthalpy H0=549760.6476280135;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-39479.5999,575.572977,0.931783351,
        0.00722271091,-7.342554480000001e-6,4.9550413400000005e-9,-
        1.33693261e-12};
    constant Real[2] blow={-33039.7425,17.242053900000002};
    constant Real[Ncoeff[2]] ahigh={1.0349722400000001e6,-2412.69895,
        4.64611114,0.00229199814,-6.83683007e-7,9.42646842e-11,-4.82238028e-15}
      ;
    constant Real[2] bhigh={-13842.8625,-7.97815119};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasH2OData;
  
  record IdealGasO2Data "Property data for oxygen" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0319988;
    constant SIunits.SpecificEnthalpy Hf=0.;
    constant SIunits.SpecificEnthalpy H0=271263.42237833916;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-34255.6269,484.699986,1.11901159,
        0.00429388743,-6.836273130000001e-7,-2.02337478e-9,1.03904064e-12};
    constant Real[2] blow={-3391.4543400000002,18.4969912};
    constant Real[Ncoeff[2]] ahigh={-1.0379399400000001e6,2344.83275,
        1.81972949,0.0012678488699999998,-2.18807142e-7,2.05372411e-11,-
        8.19349062e-16};
    constant Real[2] bhigh={-16890.1253,17.3871835};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasO2Data;
  
  record O2Data "Property data for oxygen" 
    extends PPDataRecord(MM=0.0319988,
			 Hf=0.0,
			 H0=271263.42237833916,
			 Tlimit=1000.0,
			 Ncoeff={7,7},
			 alow={-34255.6269,484.699986,1.11901159,
			       0.00429388743,-6.836273130000001e-7,-2.02337478e-9,1.03904064e-12},
			 blow={-3391.4543400000002,18.4969912},
			 ahigh={-1.0379399400000001e6,2344.83275,
				1.81972949,0.0012678488699999998,-2.18807142e-7,2.05372411e-11,-
				8.19349062e-16},
			 bhigh={-16890.1253,17.3871835},
			 R=8.314472/0.0319988);
  end O2Data;
  
  record IdealGasOData "Property data for atomic oxygen" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0159994;
    constant SIunits.SpecificEnthalpy Hf=1.5574021713314248e7;
    constant SIunits.SpecificEnthalpy H0=420353.4507544033;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-7953.6113000000005,160.7177787,
        1.966226438,0.00101367031,-1.1104154230000001e-6,6.5175075e-10,-
        1.584779251e-13};
    constant Real[2] blow={28403.62437,8.40424182};
    constant Real[Ncoeff[2]] ahigh={261902.0262,-729.872203,3.31717727,-
        0.00042813343599999997,1.036104594e-7,-9.43830433e-12,
        2.7250382970000003e-16};
    constant Real[2] bhigh={33924.2806,-0.667958535};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasOData;
  
  record IdealGasO3Data "Property data for ozone" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0479982;
    constant SIunits.SpecificEnthalpy Hf=2.9542774520711196e6;
    constant SIunits.SpecificEnthalpy H0=215975.1199003296;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-12770.5783,589.163046,-2.54469482,
        0.026895749599999998,-0.0000352749615,2.31235242e-8,-6.04573745e-12};
    constant Real[2] blow={13486.955199999999,38.505648300000004};
    constant Real[Ncoeff[2]] ahigh={-6.95117903e7,190431.551,-186.628617,
        0.08969035930000001,-0.0000189785303,1.78511251e-9,-5.78124347e-14};
    constant Real[2] bhigh={-1.21600533e6,1399.87821};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasO3Data;
  
  record IdealGasN2Data "Property data for nitrogen" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.02801348;
    constant SIunits.SpecificEnthalpy Hf=0.;
    constant SIunits.SpecificEnthalpy H0=309497.57045536645;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={22103.712199999998,-381.846145,6.08273815,
        -0.008530913809999999,0.000013846461,-9.62579293e-9,2.5197056e-12};
    constant Real[2] blow={710.845911,-10.760031999999999};
    constant Real[Ncoeff[2]] ahigh={587709.9079999999,-2239.24255,6.06694267,
        -0.0006139652960000001,1.49179819e-7,-1.92309442e-11,1.06194871e-15};
    constant Real[2] bhigh={12832.061800000001,-15.866348400000001};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasN2Data;
  
  record N2Data "Property data for nitrogen" 
    extends PPDataRecord(MM=0.02801348,
			 Hf=0.0,
			 H0=309497.57045536645,
			 Tlimit=1000.0,
			 Ncoeff={7,7},
			 alow={22103.712199999998,-381.846145,6.08273815,
			       -0.008530913809999999,0.000013846461,-9.62579293e-9,2.5197056e-12},
			 blow={710.845911,-10.760031999999999},
			 ahigh={587709.9079999999,-2239.24255,6.06694267,
				-0.0006139652960000001,1.49179819e-7,-1.92309442e-11,1.06194871e-15},
			 bhigh={12832.061800000001,-15.866348400000001},
			 R=8.314472/0.02801348);
  end N2Data;
  
  record IdealGasNData "Property data for atomic nitrogen" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.01400674;
    constant SIunits.SpecificEnthalpy Hf=3.374661056034452e7;
    constant SIunits.SpecificEnthalpy H0=442460.41548568755;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={0.0,0.,2.5,0.,0.,0.,0.};
    constant Real[2] blow={56104.6378,4.19390932};
    constant Real[Ncoeff[2]] ahigh={88765.0138,-107.12315,2.362188287,
        0.0002916720081,-1.7295151e-7,4.01265788e-11,-2.677227571e-15};
    constant Real[2] bhigh={56973.5133,4.86523579};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasNData;
  
  record IdealGasNHData "Property data for NH" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.01501468;
    constant SIunits.SpecificEnthalpy Hf=2.377886182056494e7;
    constant SIunits.SpecificEnthalpy H0=572846.2411453323;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={13596.5062,-190.029565,4.51849625,-
        0.0024327754,2.37758524e-6,-2.5927805500000003e-10,-2.65968566e-13};
    constant Real[2] blow={42809.7215,-3.88655464};
    constant Real[Ncoeff[2]] ahigh={1.9581400499999998e6,-5782.856589999999,
        9.33573752,-0.00229290818,6.07608715e-7,-6.647936030000001e-11,
        2.38423143e-15};
    constant Real[2] bhigh={78989.0925,-41.1696671};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasNHData;
  
  record IdealGasNH2Data "Property data for NH2" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.01602262;
    constant SIunits.SpecificEnthalpy Hf=1.1804228147456534e7;
    constant SIunits.SpecificEnthalpy H0=620236.5780377991;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-31160.1645,475.07354599999996,1.37457969,
        0.006299445450000001,-5.97605729e-6,4.48239827e-9,-1.41043554e-12};
    constant Real[2] blow={19291.037,15.3894335};
    constant Real[Ncoeff[2]] ahigh={1.6690078900000001e6,-5610.38294,
        9.97188164,-0.0011782813400000001,4.23396549e-7,-6.53976978e-11,
        3.61987805e-15};
    constant Real[2] bhigh={56890.5973,-43.7935788};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasNH2Data;
  
  record IdealGasNH3Data "Property data for NH3" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.01703056;
    constant SIunits.SpecificEnthalpy Hf=-2.697503781437604e6;
    constant SIunits.SpecificEnthalpy H0=589711.729972473;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-76812.26419999999,1270.95161,-3.89322933,
        0.021459884800000002,-0.0000218376679,1.31738577e-8,-
        3.3323222700000003e-12};
    constant Real[2] blow={-12648.8643,43.6601505};
    constant Real[Ncoeff[2]] ahigh={2.45238816e6,-8040.890839999999,
        12.7134588,-0.000398017165,3.55246584e-8,2.53096956e-12,-
        3.3227232299999996e-16};
    constant Real[2] bhigh={43861.8973,-64.6232791};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasNH3Data;
  
  record IdealGasCOData "Property data for CO" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0280104;
    constant SIunits.SpecificEnthalpy Hf=-3.9460343301059604e6;
    constant SIunits.SpecificEnthalpy H0=309563.5906663239;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={14890.27557,-292.2250947,5.72445841,-
        0.008176136939999998,0.00001456885983,-1.087733246e-8,
        3.0279054849999997e-12};
    constant Real[2] blow={-13030.696969999999,-7.85914715};
    constant Real[Ncoeff[2]] ahigh={461915.85599999997,-1944.6857479999999,
        5.91664709,-0.000566423407,1.398802571e-7,-1.787664983e-11,
        9.6208504e-16};
    constant Real[2] bhigh={-2465.738441,-13.873993899999999};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasCOData;
  
  record IdealGasCO2Data "Property data for CO2" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0440098;
    constant SIunits.SpecificEnthalpy Hf=-8.941417593354207e6;
    constant SIunits.SpecificEnthalpy H0=212804.170889211;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={49437.8364,-626.429208,5.30181336,
        0.0025036005710000002,-2.124700099e-7,-7.6914868e-10,2.849979913e-13};
    constant Real[2] blow={-45281.8986,-7.04876965};
    constant Real[Ncoeff[2]] ahigh={117696.9434,-1788.801467,8.29154353,-
        0.00009224778309999999,4.86963541e-9,-1.892063841e-12,6.33067509e-16};
    constant Real[2] bhigh={-39083.4501,-26.526819160000002};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasCO2Data;
  
  record IdealGasSO2Data "property data for SO2" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0640648;
    constant SIunits.SpecificEnthalpy Hf=-4.632965372560282e6;
    constant SIunits.SpecificEnthalpy H0=164647.77849926948;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-53108.4263,909.031238,-2.35689164,
        0.0220445,-0.000025107816399999997,1.44630061e-8,-3.3690713e-12};
    constant Real[2] blow={-41137.5212,40.455150800000006};
    constant Real[Ncoeff[2]] ahigh={-112764.347,-825.225334,7.61617788,-
        0.000199932413,5.6556229e-8,-5.45430606e-12,2.91828893e-16};
    constant Real[2] bhigh={-33513.0922,-16.5577319};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasSO2Data;
  
  record IdealGasNOData "Property data for NO" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.030006139999999997;
    constant SIunits.SpecificEnthalpy Hf=3.041681135927514e6;
    constant SIunits.SpecificEnthalpy H0=305907.72421910986;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-11439.165799999999,153.646774,3.43146865,
        -0.00266859213,8.48139877e-6,-7.68511079e-9,2.38679758e-12};
    constant Real[2] blow={9097.94974,6.72872795};
    constant Real[Ncoeff[2]] ahigh={223903.708,-1289.65624,5.43394039,-
        0.000365605546,9.881017630000001e-8,-1.4160832699999999e-11,
        9.38021642e-16};
    constant Real[2] bhigh={17502.9422,-8.50169908};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasNOData;
  
  record IdealGasNO2Data "Property data for NO2" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.046005540000000004;
    constant SIunits.SpecificEnthalpy Hf=743237.0536244111;
    constant SIunits.SpecificEnthalpy H0=221890.18974671306;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-56420.458399999996,963.309734,-2.43451851
        ,0.0192776414,-0.0000187456362,9.14553637e-9,-1.77766146e-12};
    constant Real[2] blow={-1547.9304300000001,40.6785541};
    constant Real[Ncoeff[2]] ahigh={721271.1760000001,-3832.53763,11.1395534,
        -0.0022380144,6.54762164e-7,-7.61120803e-11,3.3282992600000002e-15};
    constant Real[2] bhigh={25024.4718,-43.050722400000005};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasNO2Data;
  
  record IdealGasN2OData "Property data for N2O" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.044012880000000004;
    constant SIunits.SpecificEnthalpy Hf=1.854002737380512e6;
    constant SIunits.SpecificEnthalpy H0=217684.800449323;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={42881.9647,-644.010891,6.03436692,
        0.000226435378,3.4730229499999996e-6,-3.6279860899999997e-9,
        1.13805486e-12};
    constant Real[2] blow={11794.047,-10.0313474};
    constant Real[Ncoeff[2]] ahigh={343820.009,-2404.48563,9.12555691,-
        0.000540124553,1.31500955e-7,-1.41406483e-11,6.38031254e-16};
    constant Real[2] bhigh={21985.866299999998,-31.4774771};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasN2OData;
  
  record IdealGasH2Data "Property data for hydrogen" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0020158800000000003;
    constant SIunits.SpecificEnthalpy Hf=0.;
    constant SIunits.SpecificEnthalpy H0=4.200697462150524e6;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={40783.22810000001,-800.918545,8.21470167,-
        0.0126971436,0.000017536049300000002,-1.20286016e-8,3.36809316e-12};
    constant Real[2] blow={2682.48438,-30.437886600000002};
    constant Real[Ncoeff[2]] ahigh={560812.338,-837.149134,2.97536304,
        0.0012522499300000002,-3.7407184199999997e-7,5.936628250000001e-11,-
        3.60699573e-15};
    constant Real[2] bhigh={5339.81585,-2.20276405};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasH2Data;
  
  record IdealGasHO2Data "Property data for HO2" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.03300674;
    constant SIunits.SpecificEnthalpy Hf=380285.9658360686;
    constant SIunits.SpecificEnthalpy H0=303033.92579818546;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-75988.426,1329.37771,-4.67735061,
        0.025082969099999998,-0.0000300653396,1.89558645e-8,-4.82852658e-12};
    constant Real[2] blow={-5809.33725,51.9358154};
    constant Real[Ncoeff[2]] ahigh={-1.81066928e6,4963.189179999999,-
        1.03949437,0.0045601454800000005,-1.06185851e-6,1.14456657e-10,-
        4.76305753e-15};
    constant Real[2] bhigh={-31944.1706,40.6684773};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasHO2Data;
  
  record IdealGasHData "Property data for atomic hydrogen" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0010079400000000001;
    constant SIunits.SpecificEnthalpy Hf=2.162815524733615e8;
    constant SIunits.SpecificEnthalpy H0=6.148608052066591e6;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={0.0,0.,2.5,0.,0.,0.,0.};
    constant Real[2] blow={25473.70801,-0.446682853};
    constant Real[Ncoeff[2]] ahigh={60.78774250000001,-0.1819354417,
        2.500211817,-1.2265128640000002e-7,3.7328763299999996e-11,-
        5.6877445599999996e-15,3.410210197e-19};
    constant Real[2] bhigh={25474.863980000002,-0.448191777};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasHData;
  
  record IdealGasHNOData "Property data for HNO" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.03101408;
    constant SIunits.SpecificEnthalpy Hf=3.289883981727009e6;
    constant SIunits.SpecificEnthalpy H0=320560.2100723284;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-68548.4836,955.1734319999999,-0.600120397
        ,0.00799525989,-6.54703437e-7,-3.67067857e-9,1.7835243300000002e-12};
    constant Real[2] blow={6435.29838,30.4819468};
    constant Real[Ncoeff[2]] ahigh={-5.7976498100000005e6,19463.1783,-
        21.538805600000003,0.0179832347,-4.97878003e-6,6.40175565e-10,-
        3.14463101e-14};
    constant Real[2] bhigh={-110471.23400000001,181.955569};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasHNOData;
  
  record IdealGasHCOData "Property data for HCO" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.02901834;
    constant SIunits.SpecificEnthalpy Hf=1.4610708262429896e6;
    constant SIunits.SpecificEnthalpy H0=344246.08712972555;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-11899.06845,215.1611774,2.73018395,
        0.001806621526,4.984153049999999e-6,-5.81446267e-9,1.869659718e-12};
    constant Real[2] blow={2905.719059,11.367965790000001};
    constant Real[Ncoeff[2]] ahigh={691133.5700000001,-3643.2178,9.58708488,-
        0.001104891812,2.8294885440000003e-7,-3.53797286e-11,1.739690104e-15};
    constant Real[2] bhigh={25356.22651,-35.701955999999996};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasHCOData;
  
  record IdealGasOHData "Property data for OH" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.01700734;
    constant SIunits.SpecificEnthalpy Hf=2.313536743547198e6;
    constant SIunits.SpecificEnthalpy H0=518194.26200687466;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-1998.86366,93.0014295,3.05085385,
        0.00152953035,-3.15789256e-6,3.31544734e-9,-1.13876303e-12};
    constant Real[2] blow={3240.0439699999997,4.6741129};
    constant Real[Ncoeff[2]] ahigh={1.0173934899999999e6,-2509.95748,
        5.11654809,0.000130529875,-8.28431902e-8,2.0064755e-11,-1.55699342e-15}
      ;
    constant Real[2] bhigh={20445.2334,-11.012825};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasOHData;
  
  record IdealGasCH3OHData "property data for methanol" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.03204216;
    constant SIunits.SpecificEnthalpy Hf=-6.271112808874308e6;
    constant SIunits.SpecificEnthalpy H0=356882.21393314307;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-241663.747,4032.13812,-20.464095399999998
        ,0.0690367933,-0.0000759890231,4.59818438e-8,-1.15869945e-11};
    constant Real[2] blow={-44332.56970000001,140.013914};
    constant Real[Ncoeff[2]] ahigh={3.41156075e6,-13454.9745,
        22.614046000000002,-0.00214101199,3.7299975399999997e-7,-
        3.4987633200000004e-11,1.36602214e-15};
    constant Real[2] bhigh={56360.6386,-127.781198};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasCH3OHData;
  
  record IdealGasCH3Data "property data for CH3" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.015034819999999999;
    constant SIunits.SpecificEnthalpy Hf=9.770652392246798e6;
    constant SIunits.SpecificEnthalpy H0=689488.7999989358;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-28772.861100000002,509.505607,0.199073056
        ,0.0136396516,-0.0000143455892,1.01396738e-8,-3.02843889e-12};
    constant Real[2] blow={14110.987299999999,20.2339462};
    constant Real[Ncoeff[2]] ahigh={2.76090427e6,-9336.552790000002,
        14.876986299999999,-0.00143922769,2.44392393e-7,-2.22384579e-11,
        8.39158849e-16};
    constant Real[2] bhigh={74847.6479,-79.19483340000001};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasCH3Data;
  
  record IdealGasisooctaneData "Property data for isooctane" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.11423092;
    constant SIunits.SpecificEnthalpy Hf=-1.961027714737831e6;
    constant SIunits.SpecificEnthalpy H0=281622.52391909296;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-168875.867,3126.90339,-21.2350292,
        0.148915153,-0.00011511801699999999,4.47321644e-8,-5.55488286e-12};
    constant Real[2] blow={-44680.6069,141.74558399999998};
    constant Real[Ncoeff[2]] ahigh={2.5389182099999998e7,-91319.3062,
        138.71548099999998,-0.0227381966,5.274807240000001e-6,-
        6.576111639999999e-10,3.3059717900000003e-14};
    constant Real[2] bhigh={529263.833,-919.6306979999999};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasisooctaneData;
  
  record IdealGasEthylbenzeneData "Property data for ethylbenzene" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.1061674;
    constant SIunits.SpecificEnthalpy Hf=281819.0894756771;
    constant SIunits.SpecificEnthalpy H0=209857.26315234246;
    constant SIunits.Temp_K Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-469493.98999999993,9307.168029999999,-
        65.217693,0.261208019,-0.00031817534099999996,2.0513554200000002e-7,-
        5.40181719e-11};
    constant Real[2] blow={-40738.7006,378.090426};
    constant Real[Ncoeff[2]] ahigh={5.20690688e6,-30750.4076,68.231595,-
        0.0061464041700000005,1.38660034e-6,-1.6635569e-10,8.09421715e-15};
    constant Real[2] bhigh={175873.128,-418.463121};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasEthylbenzeneData;
  
  record IdealGasCH4Data "Property data for methane" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.01604276;
    constant SIunits.SpecificEnthalpy Hf=-4.650072680760667e6;
    constant SIunits.SpecificEnthalpy H0=624343.8161513356;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-176654.573,2785.47782,-12.019354700000001
        ,0.0391462588,-0.0000361165608,2.0183879400000002e-8,-4.95577215e-12};
    constant Real[2] blow={-23310.115599999997,89.01080999999999};
    constant Real[Ncoeff[2]] ahigh={3.7462656999999997e6,-13888.5134,
        20.5402982,-0.00194419693,4.3238714500000004e-7,-4.0610127800000005e-11
        ,1.64315927e-15};
    constant Real[2] bhigh={75659.88680000001,-122.29771099999999};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasCH4Data;
  
  record IdealGasC2H6Data "Property data for ethane" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.030069639999999998;
    constant SIunits.SpecificEnthalpy Hf=-2.7885782470292295e6;
    constant SIunits.SpecificEnthalpy H0=395468.45256544475;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-186205.03,3406.20069,-19.5171009,
        0.0756585003,-0.0000820419603,5.06115446e-8,-1.3192880799999999e-11};
    constant Real[2] blow={-27029.3711,129.814356};
    constant Real[Ncoeff[2]] ahigh={5.02580941e6,-20330.3046,33.2256212,-
        0.0038367541499999998,7.23854996e-7,-7.31938449e-11,3.06557995e-15};
    constant Real[2] bhigh={111596.908,-203.94168600000003};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC2H6Data;
  
  record IdealGasC3H8Data "Property data for propane" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.04409652;
    constant SIunits.SpecificEnthalpy Hf=-2.37388347198373e6;
    constant SIunits.SpecificEnthalpy H0=334313.4333502961;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-243172.255,4653.455400000001,-
        29.373778700000003,0.11882880300000001,-0.000137533319,8.80797565e-8,-
        2.34111288e-11};
    constant Real[2] blow={-35390.8414,184.064125};
    constant Real[Ncoeff[2]] ahigh={6.42142917e6,-26600.1757,45.3451297,-
        0.00502125648,9.472478000000001e-7,-9.576809280000001e-11,
        4.01030806e-15};
    constant Real[2] bhigh={145572.981,-281.849306};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC3H8Data;
  
  record IdealGasC4H10_nData "Property data for n-butane" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0581234;
    constant SIunits.SpecificEnthalpy Hf=-2.1641886056218324e6;
    constant SIunits.SpecificEnthalpy H0=330826.87867537;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-317578.326,6176.15971,-38.9142855,
        0.158461241,-0.000185999063,1.19963603e-7,-3.20156445e-11};
    constant Real[2] blow={-45402.8806,237.941814};
    constant Real[Ncoeff[2]] ahigh={7.68222769e6,-32560.2694,57.3670043,-
        0.00619772982,1.1801315e-6,-1.22181533e-10,5.250196e-15};
    constant Real[2] bhigh={177451.096,-358.789555};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC4H10_nData;
  
  record IdealGasC4H10_isoData "Property data for iso-butane" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0581234;
    constant SIunits.SpecificEnthalpy Hf=-2.3224725325772413e6;
    constant SIunits.SpecificEnthalpy H0=308593.45805647987;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-383447.95399999997,7000.04908,-44.400288,
        0.174618297,-0.00020781932099999997,1.33978992e-7,-3.55167205e-11};
    constant Real[2] blow={-50340.2397,265.896821};
    constant Real[Ncoeff[2]] ahigh={7.5277895600000005e6,-32024.573699999997,
        57.001011999999996,-0.00605971519,1.14389765e-6,-1.15695893e-10,
        4.84550921e-15};
    constant Real[2] bhigh={172846.19999999998,-357.613308};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC4H10_isoData;
  
  record IdealGasC5H12_nData "Property data for n-pentane" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.07215028;
    constant SIunits.SpecificEnthalpy Hf=-2.0340877402000383e6;
    constant SIunits.SpecificEnthalpy H0=335189.27438673837;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-332492.538,6564.5071100000005,-
        39.823785799999996,0.16232566799999998,-0.0001646102,8.96887042e-8,-
        1.99470541e-11};
    constant Real[2] blow={-50223.0792,247.255358};
    constant Real[Ncoeff[2]] ahigh={6.21225735e6,-32125.7845,64.0635337,-
        0.00530707663,1.15135703e-6,-1.35479101e-10,6.5380867499999995e-15};
    constant Real[2] bhigh={166725.264,-396.085776};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC5H12_nData;
  
  record IdealGasC6H14_nData "Property data for n-hexane" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.08617716;
    constant SIunits.SpecificEnthalpy Hf=-1.9369401358782304e6;
    constant SIunits.SpecificEnthalpy H0=333058.0863885512;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-581592.6540000001,10790.97705,-66.3394692
        ,0.2523715124,-0.0002904344659,1.80220148e-7,-4.61722358e-11};
    constant Real[2] blow={-72715.4448,393.828348};
    constant Real[Ncoeff[2]] ahigh={1.795732742e7,-66812.2121,
        106.27818529999999,-0.022609646190000002,5.73873836e-6,-
        7.345701080000001e-10,3.70510978e-14};
    constant Real[2] bhigh={384032.66,-691.245421};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC6H14_nData;
  
  record IdealGasC7H16_nData "Property data for n-heptane" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.10020404000000001;
    constant SIunits.SpecificEnthalpy Hf=-1.8739763386785602e6;
    constant SIunits.SpecificEnthalpy H0=331533.53896709153;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-612743.2749999999,11840.854000000001,-
        74.8718841,0.2918466,-0.000341679541,2.15928521e-7,-
        5.6558525499999995e-11};
    constant Real[2] blow={-80134.0877,440.721321};
    constant Real[Ncoeff[2]] ahigh={1.28153359e7,-54125.6205,98.0119459,-
        0.013827065199999999,3.43267831e-6,-4.35995372e-10,2.20016728e-14};
    constant Real[2] bhigh={296664.874,-621.676374};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC7H16_nData;
  
  record IdealGasC8H18_nData "Property data for n-octane" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.11423092;
    constant SIunits.SpecificEnthalpy Hf=-1.8274386654681587e6;
    constant SIunits.SpecificEnthalpy H0=330733.5702102373;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-698664.724,13385.0112,-84.15166049999999,
        0.327193669,-0.000377720964,2.33983703e-7,-6.01089277e-11};
    constant Real[2] blow={-90262.23359999999,493.922275};
    constant Real[Ncoeff[2]] ahigh={7.87250012e6,-42644.1563,92.1432652,-
        0.00701188537,1.73190566e-6,-2.20663557e-10,1.12002653e-14};
    constant Real[2] bhigh={216195.336,-568.106304};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC8H18_nData;
  
  record IdealGasC2H4Data "Property data for ethylene" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.02805376;
    constant SIunits.SpecificEnthalpy Hf=1.8714068987543916e6;
    constant SIunits.SpecificEnthalpy H0=374947.56496098917;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-116361.32699999999,2554.86052,-16.097503,
        0.0662578637,-0.00007885086389999999,5.1252237899999996e-8,-
        1.3703384599999999e-11};
    constant Real[2] blow={-6176.23606,109.33409400000001};
    constant Real[Ncoeff[2]] ahigh={3.40872512e6,-13748.3642,
        23.658848300000002,-0.00242372856,4.43116915e-7,-4.3523484000000003e-11
        ,1.77521829e-15};
    constant Real[2] bhigh={88203.5634,-137.126834};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC2H4Data;
  
  record IdealGasC3H6Data "Property data for propylene" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.04208064;
    constant SIunits.SpecificEnthalpy Hf=475277.9425407978;
    constant SIunits.SpecificEnthalpy H0=322014.0663259874;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-191245.297,3542.05967,-21.1486961,
        0.089014573,-0.000100142483,6.26792612e-8,-1.63786085e-11};
    constant Real[2] blow={-15299.55,140.763678};
    constant Real[Ncoeff[2]] ahigh={5.01762082e6,-20860.8484,36.4415793,-
        0.00388120254,7.2787153e-7,-7.321264290000001e-11,3.05221202e-15};
    constant Real[2] bhigh={126124.58,-219.571652};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC3H6Data;
  
  record IdealGasC5H10_1Data "Property data for 1-pentene" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0701344;
    constant SIunits.SpecificEnthalpy Hf=-303417.43851804535;
    constant SIunits.SpecificEnthalpy H0=309120.77382853493;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-534054.793,9298.917060000002,-
        56.677922699999996,0.21231002100000002,-0.000257129821,1.66683425e-7,-
        4.4340803e-11};
    constant Real[2] blow={-47906.8203,339.60363};
    constant Real[Ncoeff[2]] ahigh={4.5367897e6,-24837.752399999998,
        53.1613809,-0.004122243540000001,9.89975605e-7,-1.2467882400000002e-10,
        6.2899711800000005e-15};
    constant Real[2] bhigh={138141.28699999998,-318.852352};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC5H10_1Data;
  
  record IdealGasC6H12_1Data "Property data for 1-hexene" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.08416128;
    constant SIunits.SpecificEnthalpy Hf=-498447.7422396617;
    constant SIunits.SpecificEnthalpy H0=311782.33030676335;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-669250.578,11802.327399999998,-72.8954727
        ,0.27144794,-0.00033405892,2.18769175e-7,-5.874880499999999e-11};
    constant Real[2] blow={-62319.4053,429.715777};
    constant Real[Ncoeff[2]] ahigh={5.055636739999999e6,-27978.9687,
        61.93418559999999,-0.00429811038,1.06286927e-6,-1.35483513e-10,
        6.8648108099999995e-15};
    constant Real[2] bhigh={152516.074,-372.108902};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC6H12_1Data;
  
  record IdealGasC7H14_1Data "Property data for 1-heptene" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.09818816;
    constant SIunits.SpecificEnthalpy Hf=-639180.9358684388;
    constant SIunits.SpecificEnthalpy H0=313581.596803525;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-747715.0499999999,13361.2708,-
        83.03433679999999,0.311402069,-0.0003795385,2.45310425e-7,-
        6.50682362e-11};
    constant Real[2] blow={-72368.2524,486.87807999999995};
    constant Real[Ncoeff[2]] ahigh={5.1649270200000005e6,-29882.0035,
        69.269669,-0.00367307433,9.165385289999999e-7,-1.16999475e-10,
        5.91881452e-15};
    constant Real[2] bhigh={159015.59100000001,-415.09944699999994};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC7H14_1Data;
  
  record IdealGasC2H2Data "Property data for 1-acetylene" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.026037880000000003;
    constant SIunits.SpecificEnthalpy Hf=8.76415437815982e6;
    constant SIunits.SpecificEnthalpy H0=384280.09500005376;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={159813.325,-2216.6750500000003,
        12.657256100000001,-0.00798017014,8.05580151e-6,-2.43394461e-9,-
        7.50945461e-14};
    constant Real[2] blow={37126.3379,-52.444336500000006};
    constant Real[Ncoeff[2]] ahigh={1.7137921199999999e6,-5928.97095,
        12.361156399999999,0.000131470625,-1.36286904e-7,2.7127460600000002e-11
        ,-1.30208685e-15};
    constant Real[2] bhigh={62664.8973,-58.1886602};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC2H2Data;
  
  record IdealGasC6H6Data "Property data for benzene" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.07811364;
    constant SIunits.SpecificEnthalpy Hf=1.0610182805461378e6;
    constant SIunits.SpecificEnthalpy H0=181719.74830516157;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-168282.654,4412.514520000001,-37.2206393,
        0.164191815,-0.000202321988,1.30966294e-7,-3.44888783e-11};
    constant Real[2] blow={-10392.5432,217.244276};
    constant Real[Ncoeff[2]] ahigh={4.54977027e6,-22615.3394,46.922072,-
        0.004196808220000001,7.87029727e-7,-7.91921643e-11,3.30343e-15};
    constant Real[2] bhigh={139238.84,-286.768912};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC6H6Data;
  
  record IdealGasC6H12cycloData "Property data for cyclohexane" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.08416128;
    constant SIunits.SpecificEnthalpy Hf=-1.4650442578820093e6;
    constant SIunits.SpecificEnthalpy H0=208466.5775045246;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-568004.3,10342.4559,-68.0007246,
        0.23878043,-0.00025118970499999997,1.42529657e-7,-3.4078387e-11};
    constant Real[2] blow={-64046.6935,393.482661};
    constant Real[Ncoeff[2]] ahigh={5.2249787e6,-33641.535299999996,
        71.7456973,-0.00669880265,1.3183976100000002e-6,-1.3907320700000001e-10
        ,6.05974812e-15};
    constant Real[2] bhigh={173251.057,-454.67860900000005};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasC6H12cycloData;
  
  record IdealGasCOSData "Property data for carbonyl sulfide" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0600764;
    constant SIunits.SpecificEnthalpy Hf=-2.358663302062041e6;
    constant SIunits.SpecificEnthalpy H0=165482.56886231533;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={85479.4437,-1319.473564,9.73530042,-
        0.0068709393,0.00001082346243,-7.70570274e-9,2.07860056e-12};
    constant Real[2] blow={-11916.533940000001,-29.92009855};
    constant Real[Ncoeff[2]] ahigh={195869.6362,-1756.061149,8.71032183,-
        0.00041388782099999996,1.0150996510000001e-7,-1.159420921e-11,
        5.6900882e-16};
    constant Real[2] bhigh={-8927.78737,-26.36245997};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasCOSData;
  
  record IdealGasSO3Data "Property data for sulfur trioxide" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.0800642;
    constant SIunits.SpecificEnthalpy Hf=-4.944781812595393e6;
    constant SIunits.SpecificEnthalpy H0=145989.081262287;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={-39530.5842,620.8856370000001,-1.43788522,
        0.0276416789,-0.000031450181999999997,1.79284169e-8,-4.12651535e-12};
    constant Real[2] blow={-51841.1984,33.9141886};
    constant Real[Ncoeff[2]] ahigh={-216640.49200000003,-1301.18145,
        10.9630649,-0.000383813908,8.46987147e-8,-9.70959423e-12,4.50068803e-16
        };
    constant Real[2] bhigh={-43981.8313,-36.5534758};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasSO3Data;
  
  record IdealGasNO3Data "Property data for nitrogen trioxide" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.062004939999999995;
    constant SIunits.SpecificEnthalpy Hf=1.1471666612369919e6;
    constant SIunits.SpecificEnthalpy H0=176742.59502549318;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={34050.8216,226.71304499999997,-3.79334153,
        0.0417080581,-0.0000571002166,3.83423899e-8,-1.02199317e-11};
    constant Real[2] blow={7088.13324,42.7323588};
    constant Real[Ncoeff[2]] ahigh={-394398.322,-824.394536,
        10.613223099999999,-0.000244855256,5.4054803500000005e-8,-
        6.19462817e-12,2.86953273e-16};
    constant Real[2] bhigh={8982.04872,-34.446411499999996};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasNO3Data;
  
  record IdealGasHCNData "Property data for hydrogen cyanide" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.02702568;
    constant SIunits.SpecificEnthalpy Hf=4.995248963208326e6;
    constant SIunits.SpecificEnthalpy H0=341729.162781473;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={90982.9783,-1238.65966,8.72132229,-
        0.00652828128,8.87274723e-6,-4.808908770000001e-9,9.317917729999999e-13
        };
    constant Real[2] blow={21219.7899,-27.4668335};
    constant Real[Ncoeff[2]] ahigh={1.23689825e6,-4446.76184,9.73891163,-
        0.0005855398100000001,1.07285501e-7,-1.0134036e-11,3.34873666e-16};
    constant Real[2] bhigh={42445.948099999994,-40.057974200000004};
    constant SIunits.SpecificHeatCapacity R=8.314472 /MM;
  end IdealGasHCNData;
  
  record IdealGasH2SData "Property data for hydrogen sulfide" 
    extends Images.PropertyData;
    constant SIunits.MolarMass MM=0.034081879999999995;
    constant SIunits.SpecificEnthalpy Hf=-604426.7511064531;
    constant SIunits.SpecificEnthalpy H0=292152.8976687906;
    constant SIunits.Temperature Tlimit=1000.0;
    constant Integer[2] Ncoeff={7,7};
    constant Real[Ncoeff[1]] alow={11970.2267,-102.893977,4.23994708,-
        0.000801813237,4.47642279e-6,-2.74774481e-9,4.52749455e-13};
    constant Real[2] blow={-3114.0341399999998,0.380759538};
    constant Real[Ncoeff[2]] ahigh={1.4323203900000001e6,-5290.974249999999,
        10.1683257,-0.000972134492,2.1196671399999998e-7,-2.18038315e-11,
        9.37291674e-16};
    constant Real[2] bhigh={29131.4495,-43.5420791};
    constant SIunits.SpecificHeatCapacity R=8.314472/MM;
  end IdealGasH2SData;
  
  annotation (
    Coordsys(
      extent=[0, 0; 606, 355], 
      grid=[2, 2], 
      component=[20, 20]), 
    Window(
      x=0.1, 
      y=0.13, 
      width=0.6, 
      height=0.6, 
      library=1, 
      autolayout=1), 
    Documentation(info="<HTML>

<h4>Package description</h4>
This package contains the data records for the properties used in the ThermoFluid Ideal Gas properties.
<h4>Version Info and Revision history
</h4>
<address>Author: Hubertus Tummescheit, <br>
Lund University<br>
Department of Automatic Control<br>
Box 118, 22100 Lund, Sweden<br>
email: hubertus@control.lth.se
</address>
<ul>
<li>Initial version: March 2000</li>
</ul>

<h4>Sources for model and Literature:</h4>
Original Data: Computer program for calculation of complex chemical
equilibrium compositions and applications. Part 1: Analysis
Document ID: 19950013764 N (95N20180) File Series: NASA Technical Reports
Report Number: NASA-RP-1311  E-8017  NAS 1.61:1311
Authors:
Gordon, Sanford (NASA Lewis Research Center)  Mcbride, Bonnie J. (NASA Lewis Research
Center)
Published: Oct 01, 1994.
<h4>Known limits of validity:</h4>
The data is valid for temperatures between 200K and 6000K (some up to 20000K).
A few of the data sets for monoatomic gases
have a discontinous 1st derivative at 1000K, but this never caused problems so far.

<h4>Tips for usage and initialization:</h4>
No known problems.

<p>This file has been generated
automatically through parsing the oringinal text file thermo.inp with
Mathematica (notebook ParseNasaData.nb) and generating Modelica records. The same data will become part
of the Modelica Standard Library eventually.

Most of this will become part of the Modelica Standard Library
eventually.</p>
</HTML>
"));
  
end IdealGasData;
