wipe all
model basic -ndm 2 -ndf 3

# constantes
set L 500; # m
set nele 10; # numero de elementos
set nnodos [expr $nele+1]; # numero de nodos
set numIntgrPts 3; # puntos de integracion
set transfTag 1; # transformacion geometrica
set intType "Legendre"; #cuadratura de gauss-legendre
geomTransf Corotational $transfTag

# Crear nodos
for {set i 1} {$i <=$nnodos} {incr i} {
	set x [expr $L*($i-1)/($nnodos-1)]
	node $i $x 0.0 ;
	node [expr $i+$nnodos]	$x 0.0;
}

# Condición de borde (viga simplemente apoyada). 
fix 1 1 1 0; 
fix [expr $nnodos+1] 1 1 0;
fix $nnodos 0 1 0; 
fix [expr $nnodos+$nnodos] 0 1 0;

# Materiales

set matTag 3
set fc -62
set e0 -0.0034
set n	2.3
set k	1
set alpha1	0.32
set fcr	2.0
set ecr	0.00015
set b	0.15
set alpha2	0.1

uniaxialMaterial Concrete06 $matTag $fc $e0 $n $k $alpha1 $fcr $ecr $b $alpha2

# ConcreteCM (Chang Mander) 
set matTag 4
set fpcc	-62
set epcc	-0.0034
set Ec	25000
set rc	9
set xcrn	1.035
set ft	1.6
set et	0.00015
set rt	0.6
set xcrp	1000.0
set gap 	0

uniaxialMaterial ConcreteCM $matTag $fpcc $epcc $Ec $rc $xcrn $ft $et $rt $xcrp -GapClose $gap

# Secciones

set numSubdivY	50
set numSubdivZ	50

set colWidth 150
set colDepth 125

set y1 [expr $colDepth/2.0]
set z1 [expr $colWidth/2.0]


section Fiber 3 {
patch rect 3 $numSubdivY $numSubdivZ [expr -$y1] [expr -$z1] [expr $y1] [expr $z1]
}

section Fiber 4 {
patch rect 4 $numSubdivY $numSubdivZ [expr -$y1] [expr -$z1] [expr $y1] [expr $z1]
}


# Elementos
for {set i 1} {$i <= $nele} {incr i} {
	set j [expr $i+1]; #nodo siguiente
	# Elementos
	set label2	[expr $i+$nele]; # elementos en paralelo
	#element nonlinearBeamColumn $i $i $j $numIntgrPts 3 $transfTag
	#element nonlinearBeamColumn $label2 $i $j $numIntgrPts 4 $transfTag 
	#element forceBeamColumn $i $i $j $transfTag "HingeRadau 3 $colDepth 3 $colDepth 3"
	#element forceBeamColumn $label2 $i $j $transfTag "HingeRadau 4 $colDepth 4 $colDepth 4"
	element dispBeamColumn $i $i $j $numIntgrPts 3 $transfTag
	element dispBeamColumn $label2 [expr $i+$nnodos] [expr $j+$nnodos] $numIntgrPts 4 $transfTag
}

# Recorders

#region 1 -eleRange 1 $nele
#region 1 -eleRange [expr 1+$nele] [expr 2*$nele]

set nodocentral [expr ($nnodos+1)/2]

recorder Node -file EN14651FAdispFP.out -time -closeOnWrite -node $nodocentral -dof 2 disp
recorder Node -file EN14651FAreacFP.out -time -closeOnWrite -node 1 $nnodos [expr $nnodos+1] [expr $nnodos+$nnodos] -dof 2 reaction

#recorder Element -file EN14651FAreac..out -time -ele $nodocentral force

# Carga 1 

equalDOF $nodocentral	[expr $nodocentral+$nnodos]	2

pattern Plain 1 Linear {
	load $nodocentral 0.0 -1.0 0.0
	#load [expr $nodocentral+$nnodos] 0.0 -1.0 0.0
}


constraints Plain
test NormDispIncr 2.e-5 300 1
algorithm Newton
#algorithm BFGS
#algorithm ModifiedNewton -initial
#algorithm KrylovNewton
numberer Plain
#system BandSPD
system ProfileSPD
#system SparseGEN
#system UmfPack 
integrator DisplacementControl  $nodocentral  2 -0.02
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 200


puts "OK"

analyze 1
