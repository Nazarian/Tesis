# CI6910Ensayos.tcl

set L1 1500; # mm
set L1e 1300; # mm
set L2 800; # mm
set L2e 500; # mm
set nele 30; # número de elementos, 30, 60, 90, 
set nnodos [expr $nele+1]; # número de nodos

# Crear Nodos 

for {set i 1} {$i <=$nnodos} {incr i} {
	set x [expr $L1*($i-1)/($nnodos-1)]
	node $i $x 0.0 ;
}

# Condiciones de borde 

fix [expr 1] 0 0 0; 
fix [expr 1 + (L1-L1e)/(2*L1/nele)] 1 1 0; 
fix [expr nnodos - (L1-L1e)/(2*L1/nele)] 1 1 0; 
fix [expr nnodos] 0 0 0; 

