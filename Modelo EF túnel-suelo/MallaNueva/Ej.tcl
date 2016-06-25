wipe

source CI6910NodosSuelo.tcl
source CI6910RemoverNodosIncorrectos.tcl
source CI6910NodosCorregidos.tcl
source CI6910Materiales.tcl
source CI6910ElementosSuelo.tcl
source CI6910CDBPorous.tcl
source CI6910CDBSueloAbajo.tcl
source CI6910SoilsStage0.tcl

numberer RCM
system ProfileSPD
test NormDispIncr 1.0e-5 30 0
algorithm KrylovNewton
constraints Penalty 1.e18 1.e18
set nw 1.5
set nw2 [expr pow($nw+0.5, 2)/4]
integrator Newmark $nw $nw2
analysis Transient 

#updateMaterialStage -material 1 -stage 0

analyze  1 5e3