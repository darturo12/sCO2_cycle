within sCO2_cycle;

model data

parameter String wea_file = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Libro2.motab");
//parameter String wea_file_DAMM = Modelica.Utilities.Files.loadResource("modelica://SolarTherm/Data/Weather/Correlaciones.motab");

SolarTherm.Models.Sources.DataTable.DataTable data(lon = -72.46, lat = 11.69, t_zone = -5, year = 2015, file = wea_file) annotation(
    Placement(visible = true, transformation(extent = {{-62, -18}, {-32, 10}}, rotation = 0)));
equation

end data;