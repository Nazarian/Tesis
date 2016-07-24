wipe all
model basic -ndm 2 -ndf 3

# constantes
set L 1500; # mm
set nele 20; # numero de elementos
set nnodos [expr $nele+1]; # numero de nodos
set numIntgrPts 3; # puntos de integracion
set transfTag 1; # transformacion geometrica
set intType "Legendre"; #cuadratura de gauss-legendre
geomTransf Corotational $transfTag

# Crear nodos
for {set i 1} {$i <=$nnodos} {incr i} {
	set x [expr $L*($i-1)/($nnodos-1)]
	node $i $x 0.0 ;
}

# Condición de borde (viga simplemente apoyada). 
fix 1 1 1 0;
#fix [expr 1+$nele/15] 1 1 0; 
#fix [expr $nnodos-$nele/15] 0 1 0;
fix $nnodos 0 1 0; 

# Materiales

# ConcreteCM (Chang Mander) 
set matTag 4
set fpcc	-55
set epcc	-0.0025
set Ec	23000
set rc	7
set xcrn	1.035
set ft	2
set et	0.00012
set rt	1.2
set xcrp	10000
set gap 	0

uniaxialMaterial ConcreteCM $matTag $fpcc $epcc $Ec $rc $xcrn $ft $et $rt $xcrp -GapClose $gap

# Aceros 

# ReinforcingSteel AT56-50H

set matTag 44
set fy	500
set fu	700
set Es	200000
set Esh	150000
set esh	[expr 1.01*$fy/$Es]
set eult	0.017
set meult	[expr -$eult]

uniaxialMaterial ReinforcingSteel $matTag $fy $fu $Es $Esh $esh $eult

uniaxialMaterial MinMax 5 44 -min $meult -max $eult

# Secciones

set numSubdivY	100
set numSubdivZ	1
set As	[expr 4.1*4.1*3.1415/4]

set colWidth 500
set colDepth 150
set cover 30
set cover2 30

set y1 [expr $colDepth/2.0]
set z1 [expr $colWidth/2.0]


section Fiber 4 {
	patch rect 4 $numSubdivY $numSubdivZ [expr -$y1] [expr -$z1] [expr $y1] [expr $z1]
	# Acero ReinforcingSteel AT56-50H
	# malla de arriba
	layer straight 5 5 $As [expr $y1-$cover2] [expr $z1-$cover] [expr $y1-$cover2] [expr $cover-$z1]
	# malla de abajo 
	layer straight 5 5 $As [expr $cover-$y1] [expr $z1-$cover] [expr $cover-$y1] [expr $cover-$z1]
}



set A [expr $colDepth*$colWidth]
set I [expr $colDepth*$colDepth*$colDepth*$colWidth/12]
# Elementos
for {set i 1} {$i <= $nele} {incr i} {
	set j [expr $i+1]; #nodo siguiente
	# Elementos
	#element nonlinearBeamColumn $i $i $j $numIntgrPts 4 $transfTag
	#element forceBeamColumn $i $i $j $transfTag "HingeRadau 4 [expr 1*$colDepth] 4 [expr 1*$colDepth] 4"
	element dispBeamColumn $i $i $j $numIntgrPts 4 $transfTag
	#element beamWithHinges $i $i $j 4 [expr 0.6*$colDepth] 4 [expr 0.6*$colDepth] $Ec $A $I $transfTag
	
}


# carga axial con efecto de excentricidad

set lcacho 500; ## mm
node 1001 [expr -$lcacho] 0.0 ;
node 1002 [expr $L+$lcacho] 0.0;

set Einf 2000000;
set Ainf 1000000; 
set Izinf 1000000000000;

element elasticBeamColumn 1001 1001 1 $Ainf $Einf $Izinf $transfTag
element elasticBeamColumn 1002 $nnodos 1002 $Ainf $Einf $Izinf $transfTag


# Recorders

set nodocentral [expr ($nnodos+1)/2]

recorder Node -file ProbetasA2disp2.out -time -closeOnWrite -node $nodocentral -dof 2 disp
recorder Node -file ProbetasA2reac2.out -time -closeOnWrite -node 1 [expr 1+$nele/15] [expr $nnodos-$nele/15] $nnodos -dof 2 reaction

set Cargaaxial 190000; # Newton 

pattern Plain 1 Constant {
	load 1001 $Cargaaxial 0.0 0.0
	load 1002 [expr -$Cargaaxial] 0.0 0.0
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
integrator LoadControl 1.0
#integrator DisplacementControl  $nodocentral  2 -0.02
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
analyze 1 
 
 
 
set nanalize 140

set stepanalisis [expr -40.0/$nanalize]

pattern Plain 2 Linear {
	load $nodocentral 0.0 -1.0 0.0 
}

constraints Plain
test FixedNumIter 2 1
#test NormDispIncr 1.e-6 200 5
algorithm Newton
#algorithm BFGS
#algorithm ModifiedNewton -initial
#algorithm KrylovNewton
numberer Plain
#system BandSPD
#system ProfileSPD
#system SparseGEN
system UmfPack 
integrator DisplacementControl  $nodocentral  2 $stepanalisis
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static

analyze $nanalize


puts "OK"
