RELEASE NOTES for ThermoFlow Modelica base library


Version:
=======

This is version 1.0 beta6, 2001-09-25, of the Modelica
Thermo-hydraulic base library, ThermoFluid.

ThermoFluid is updated from the previous version of ThermoFlow. It now
complies with Modelica 1.4 and has been tested with Dymola $.1c and 4.1d,
ThermoFluid does not work with implementations before
Dymola 4.1a due to the changes in Modelica 1.4, it may work better or
worse with other implementations of the Modelica language than Dymola.

The ThermoFluid Library now has a project at Sourceforge. The latest
updates, news and bug-fixes fresh in CVS can be found at:
http://sourceforge.net/projects/thermofluid.


What is fully implemented:
=========================

Base classes for thermo-hydraulic control volumes with one-dimensional
flow of water, ideal gas and mixtures of ideal gas with constant
composition has been fully implemented and tested.

Some components, mainly for water, has also been implemented, but
there are still many lacking. The components currently in ThermoFluid
are mainly of general character, lacking for example detailed
characteristics.

There are only a few examples, none very large.


Documentation:
=============

There is currently little model documentation. The online
html-documentation is included, but the documentation is incomplete
and may in parts still refer to older versions of the library. The
help has to be downloaded as an extra zip-archive.
In the directory ThermoFluid/Documentation are some pdf-documents, one
describing the basic structure and physics of ThermoFluid, and one
How-to for creating own components from the base models.


Installation instructions
=========================

The library should be included in the same path and parallell with the
Modelica base library. If you are using Dymola, unzip the files in
your Dymola path under ...Dymola/Modelica/Library. If you replace the
file dymodraw.ini with that version of the file that you find in the
ThermoFluid folder, the library will be available in the Library menu.
You have to download the html-helpfiles separately. They should be
placed in the Dymola/Modelica/Library/ThermoFluid/help folder.


Known problems:
==============


Parameter records
-----------------

Due to the handling of parameter records, Dymola can produce
Warnings during model instantiation. These can be ignored.

The use of parameter records for specifying component geometry (geo),
initial values (init) and flow characteristics (char) is not complete.
Specifically, there should be many more variants of parameter records
for different types of valves, pumps etc. The intended usage for
parameter records is to set them via function calls in the
initialization, which is especially useful for complex geometries. Due
to current limitations in Dymola it is not possible to open and look
inside parameter records from the model editor window. Setting
parameters can only be done via modifications in the model parameter
dialog, if you know the variable names inside the record, or from the
simulation window.

Sliding Modes
-------------

In some cases, during simulation, a so-called sliding mode may occur.
This causes series of repeated events, which seem to stop the
simulation completely. There are two main reasons for this:
- events concerning flow reversal at low flow velocities, especially
  with ideal gas. This can usually be overcome by tightening the
  accuracy requirement to something smaller, e.g. 1e-6. Tightening the
  accuracy should always be done, since it also can speed up simulations.
- events crossing the boiling boundary in water-steam tables. This
  problem can be seen in for example the Examples.BoilerFlow model.
  In this case there is currently no good solution to the problem. If
  the heat transfer coefficients for the 1- and 2-phase regions differ
  a lot, it usually helps to have a region of linear interpolation
  between these coefficients. 

Initialization
--------------

The current initialization routines of Dymola are very sensitive to
correct initial values for the pressures and correct ranges of all
pressure-drop related parameters for models with a static momentum
balance. This is especially pronounced with the static flow models.
Initial values may be difficult to obtain, a good rule is to make sure
that the pressure gradient is correct with the direction of flow. We
hope for improvements from Dynasim here!


Future extensions:
=================

This is the first official version of ThermoFluid. Since the base
classes are more or less complete, there will be no major structural
changes to these classes, only extensions. The component libraries are
still sketchy, so there will be improvements in these during 2001.
There will be more different models and the handling of machine
characteristics will be included.

The ideal gas models should in principle be able to use mole fraction,
mole_y, as state instead of mass fraction. But this currently requires
rewriting of one of the equations. Contact Hubertus Tummescheit if you
are interested in this feature.

If you are using the library and willing to contribute bug reports or
models to a public domain library free of charge, you are welcome to
send models to modelica-thermo-dev@lists.sourceforge.net. Bugs can
also be reported and tracked online, sourceforge.net/projects/modelica.

Acknowledgements
================

This package was developed at the department of Automatic Control,
Lund University in collaboration with the Department of Energy
Engineering at the Technical University of Denmark. The development
was made with financial support from Sydkraft Research Foundation and
NUTEK, which is gratefully acknowledged.

Many thanks to the Modelica Design group for such a nice modeling
language. Many thanks to the people that worked with early versions of
the library and contributed with suggestions and bug reports: Olaf
Bauer, Torge Pfafferott and Guido Ströhlein from the TU Hamburg
Harburg.


======================================================================


The ThermoFluid library is (c) the following persons:

Jonas Eborn, jonas@control.lth.se
Hubertus Tummescheit, hubertus@control.lth.se
Falko Jens Wagner, fjw@et.dtu.dk


Lund 2001-06-08,

http://www.control.lth.se/~hubertus/ThermoFluid
