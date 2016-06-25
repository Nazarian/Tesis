## CI6910v2 Francisco Nazar - Revestimiento de Túnel, Metro de Santiago, 2016. 
# Unidades: mm, N, s, kg

wipe all;

interp recursionlimit {} 90000
source opensees-vtk.tcl

puts "" 
puts ">Modelo"
## Constantes
set g -9.820 ;#m/s2
set gammas -22500.0; # N/m3
set gammas2 22500.0;#N/m3
set 1mbetaexcavacion 0.6
set betaexcavacion 0.7
set 1mbetaprimario 0.8
set 1mbetasecundario 1
puts "Constantes definidas" 
 
### Modelo del suelo

## Nodos 
# Nodos suelo
source CI6910NodosSuelo.tcl
source CI6910RemoverNodosIncorrectos.tcl
source CI6910NodosCorregidos.tcl
puts "Nodos Suelo definidos";
# Nodos interfaz vigas
source CI6910NodosDummyViga.tcl
source CI6910NodosDummyVigaDer.tcl
puts "Nodos dummy vigas";

## Materiales de suelo, lining, viga, y resortes de interfaz
source CI6910Materiales.tcl
puts "Materiales 2dgl definidos" 

## Elementos
# Elementos Suelo
source CI6910ElementosSuelo.tcl
puts "Elementos Suelo definidos";
# Elementos Interfaz viga suelo
source CI6910ElementosInterfazViga.tcl
source CI6910ElementosInterfazVigaDer.tcl
puts "Elementos Interfaz vigas definidos";

### Modelo Túnel y Viga rígida
 
## Nodos
# Nodos Barra Rígida
source CI6910NodosViga.tcl
source CI6910NodosVigaDer.tcl
puts "Nodos Vigas definidos"

## Transformaciones geométricas quedan igual
geomTransf Linear 2 
geomTransf Linear 3
puts "Transformaciones geométricas definidas"


## Elementos
# Elementos Barra rígida 
source CI6910ElementosViga.tcl
source CI6910ElementosVigaDer.tcl
puts "Elementos Viga definidos"

### Unión entre modelos 
# Conexión entre nodos en la misma ubicación
source CI6910equalDOFViga.tcl
source CI6910equalDOFVigaDer.tcl
source CI6910equalDOFEntreVigas.tcl
puts "Equaldofs definidos"


## Condiciónes de borde
source CI6910CDBPorous.tcl
source CI6910CDBSueloAbajo.tcl
source CI6910CDBVigas.tcl
puts "Condiciones de borde definidas"


#source CI6910Recorders.tcl
#puts " -Recorders definidos"
#recorder pvd RecVTK eleResponse force
#recorder pvd RecVTK eleResponse strain
#recorder pvd RecVTK eleResponse force
#recorder pvd RecVTK disp

# A vtk

set fd [open "./Desplazamientos.vtk" "w"]
#print -ele 1
vtk_output_meta $fd
vtk_output_mesh $fd
#vtk_output_cell_data_header $fd
#vtk_output_ele_resp_stresses $fd
#vtk_output_ele_resp_strains $fd
vtk_output_point_data_header $fd
vtk_output_node_disp $fd
#vtk_output_node_disp $fd
#InitialStateAnalysis on 

source CI6910SoilsStage0.tcl
puts "Soil Stage 0"

numberer RCM
#numberer Plain
#system SparseSYM
#system UmfPack -lvalueFact 35000
#system ProfileSPD
#system SparseGEN
#system BandSPD
system SparseSPD
#system SparseGeneral
test NormDispIncr 1.0e-12 1000 1 1
#test NormUnbalance 1 1000 1 1
#algorithm KrylovNewton
#algorithm ModifiedNewton -initial
#algorithm BFGS
#algorithm NewtonLineSearch
#algorithm SecantNewton
algorithm Newton
#constraints Penalty 1.e18 1.e18
#constraints Transformation
#constraints Lagrange
constraints Plain
set nw 0.5
set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;# 0.1;

analysis Static
#analysis Transient 

#analyze 5 5.0e3
analyze 10

#vtk_output_cell_data_header $fd
#vtk_output_ele_resp_stresses $fd
#vtk_output_ele_resp_strains $fd
vtk_output_node_disp $fd

puts "Gravedad elástica"

source CI6910SoilsStage1.tcl
#source CI6910UpdateMaterialsBulk.tcl
puts "Soil Stage 1"

test NormDispIncr 1e-7 1000 1
#algorithm ModifiedNewton -initial
#algorithm BFGS
#algorithm Broyden
#integrator MinUnbalDispNorm 0.01;# 0.1;
#integrator LoadControl 1;
#integrator ArcLength 1.0 0.1;
#algorithm KrylovNewton
#constraints Plain
algorithm Newton

#analyze 30 5.0e3
analyze 10
#vtk_output_cell_data_header $fd
#vtk_output_ele_resp_stresses $fd
#vtk_output_ele_resp_strains $fd
vtk_output_node_disp $fd


puts "Gravedad plástica OK"


#loadConst -time 0.0
#setTime 0.0

source CI6910UpdateMaterialsInternalbetaexc.tcl


test NormDispIncr 1e-3 1000 1
#algorithm ModifiedNewton -initial
#integrator MinUnbalDispNorm 0.01;# 0.1;
#integrator LoadControl 1;
#integrator ArcLength 1.0 0.1;
#algorithm KrylovNewton
algorithm Newton
#constraints Plain
#algorithm Newton

#analyze 30 5.0e3
analyze 5

#vtk_output_cell_data_header $fd
#vtk_output_ele_resp_stresses $fd
#vtk_output_ele_resp_strains $fd
vtk_output_node_disp $fd

close $fd


puts "Excavación plástica OK"

if 1 {

## Transformaciones geométricas quedan igual

# Nodos interfaz tunel
source CI6910NodosDummyLiningSuelo.tcl; # OK
source CI6910NodosDummyLining.tcl ; # OK

puts "Nodos dummy lining definidos";

# Nodos Túnel
source CI6910NodosLining.tcl
puts "Nodos Lining definidos"

# equalDOF Lining 
source CI6910equaldofLining.tcl; # OK
source CI6910equalDOFLiningSuelo.tcl; # OK
puts "equalDOF Lining definidos"

# Elementos Interfaz tunel suelo
source CI6910ElementosInterfazLining.tcl; # aca esta el problema. 
#source CI6910ElementosInterfazLiningNoSlip.tcl; # OK 
#source CI6910ElementosInterfazLiningFullSlip.tcl; # OK
puts "Elementos Interfaz Lining definidos";


#equalDOF 10374 210374  1 2 
#equalDOF 20519 220519  1 2

## Materiales 3gdl
source CI6910Materiales3gdl.tcl
puts "Materiales 3dgl definidos" 

## Secciones
source CI6910Seccion.tcl
puts "Secciones definidas"

geomTransf Linear 1 
puts "Transformaciones geométricas definidas"

# Elementos Revestimiento
source CI6910ElementosLining.tcl
puts "Elementos Lining definidos"


# Recorders 

source CI6910RecElLining.tcl
source CI6910RecNodLining.tcl
puts "Recorders Lining definidos"

set betaexcavacion2 0.02

source CI6910UpdateMaterialsInternalbetaexc2.tcl

puts "Excavación completa"

test NormDispIncr 5.0e-3 1000 1
#test FixedNumIter 10
#algorithm ModifiedNewton -initial
#integrator MinUnbalDispNorm 0.01;# 0.1;
#integrator LoadControl 0.01;
#integrator ArcLength 1.0 0.1;
#algorithm KrylovNewton
algorithm Newton
#algorithm ModifiedNewton -initial
system UmfPack -lvalueFact 35000; # Porque contact2d son asimetricos
#system SparseGEN
#system BandGeneral

#constraints Plain
#algorithm Newton
#analyze 30 5.0e3
analyze 5

puts "Colocación Lining y excavación completa"


set fd [open "./Desplazamientos2.vtk" "w"]
#print -ele 1
vtk_output_meta $fd
vtk_output_mesh $fd
#vtk_output_cell_data_header $fd
#vtk_output_ele_resp_stresses $fd
#vtk_output_ele_resp_strains $fd
vtk_output_point_data_header $fd
vtk_output_node_disp $fd

vtk_output_node_disp $fd

}

if 1 {
	
set CargaLat 5000000;				# 
	
	pattern Plain 1 Linear {
		load 208052 $CargaLat 0.0 0.0
	}



#constraints Penalty 1.0e15 1.0e15;#Transformation  ;# 
#constraints Transformation
#test NormDispIncr 2.e-5 100 1 1
#algorithm ModifiedNewton -initial
algorithm Newton
#algorithm KrylovNewton
#numberer RCM
#system ProfileSPD
#set InitStiffnessProportionalDamping 0.1
#set massProportionalDamping 0.0
#set gamma 0.5
#rayleigh $massProportionalDamping 0.0 $InitStiffnessProportionalDamping 0.
#integrator Newmark $gamma  [expr pow($gamma+0.5, 2)/4] 
integrator LoadControl 1 
#algorithm KrylovNewton
test NormDispIncr 1.0e-3 1000 1
set incr 0.01
#integrator DisplacementControl 8052 1 $incr 
#analysis Transient 
analysis Static
#analysis VariableTransient 


set deltaT   1.00   ;# time step for analysis
set numSteps 50   ;# Number of analysis steps

analyze $numSteps
#analyze 
#set startT [clock seconds]
#analyze $numSteps $deltaT [expr $deltaT/100] $deltaT 10
#set endT [clock seconds]
#puts "Execution time: [expr $endT-$startT] seconds."





#system SparseSYM
#test NormDispIncr 1e-5 1000 1
#test NormDispIncr 1e-3 1000 1
#constraints Plain; # MODELO GRANDE
#constraints Penalty $alphaSP $alphaMP
#integrator DisplacementControl 8052 1 $Dincr
#integrator LoadControl 1
#algorithm KrylovNewton
#algorithm Newton
#algorithm ModifiedNewton
#numberer Plain
#analysis Static;	

#updateMaterialStage -material 1 -stage 2


#analyze 30 5e5
#analyze 30

puts "Racking"
vtk_output_node_disp $fd

}

vtk_output_node_disp $fd

close $fd

wipe all;

##

