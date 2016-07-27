wipe all

model basic -ndm 2 -ndf 3

#########################################################################
# MATERIALES
#########################################################################

# Hormigones

# ConcreteCM (Chang Mander) Sin fibras
set matTag 1
set fpcc	-55
set epcc	-0.0025
set Ec	25000
set rc	8
set xcrn	1.035
set ft	3
set et	0.00015
set rt	1.8
set xcrp	10000
set gap 	0

uniaxialMaterial ConcreteCM $matTag $fpcc $epcc $Ec $rc $xcrn $ft $et $rt $xcrp -GapClose $gap

# ConcreteCM (Chang Mander) Con fibras de acero
set matTag 2
set fpcc	-60
set epcc	-0.0035
set Ec	25000
set rc	9
set xcrn	1.035
set ft	3.2
set et	0.00015
set rt	0.7
set xcrp	10000.0
set gap 	0

uniaxialMaterial ConcreteCM $matTag $fpcc $epcc $Ec $rc $xcrn $ft $et $rt $xcrp -GapClose $gap

# ConcreteCM (Chang Mander) 
set matTag 3
set fpcc	-62
set epcc	-0.0034
set Ec	25000
set rc	9
set xcrn	1.035
set ft	2.8
set et	0.00015
set rt	0.6
set xcrp	1000.0
set gap 	0

uniaxialMaterial ConcreteCM $matTag $fpcc $epcc $Ec $rc $xcrn $ft $et $rt $xcrp -GapClose $gap

# Aceros 

# ReinforcingSteel AT56-50H

set matTag 44
set fy	500
set fu	710
set Es	200000
set Esh	150000
set esh	[expr 1.01*$fy/$Es]
set eult	0.02
set meult	[expr -$eult]

uniaxialMaterial ReinforcingSteel $matTag $fy $fu $Es $Esh $esh $eult

uniaxialMaterial MinMax 4 44 -min $meult -max $eult

# ReinforcingSteel A630S
set matTag 99
set fy	450
set fu	680
set Es	200000
set Esh	20000
set esh	[expr 1.2*$fy/$Es]
set eult	0.09
set meult	[expr -$eult]

uniaxialMaterial ReinforcingSteel $matTag $fy $fu $Es $Esh $esh $eult -IsoHard	3.0 0.01

uniaxialMaterial MinMax 5 99 -min $meult -max $eult


#########################################################################
# Secciones
#########################################################################



set hsost	150
set bsost	1000
set bsostaux	[expr $bsost/2]
set cover 50
set distphi22malla	[expr 50]
set Hmarco	145

set numSubdivY	80
set numSubdivZ	1

set Asmalla	[expr 7.5*7.5*3.1415/4]
set As22	[expr 22*22*3.1415/4]
set As28	[expr 28*28*3.1415/4]

# Sostenimiento sin fibras, con malla y marco 
section Fiber 1 {
	# hormigón sostenimiento
	patch rect 1 $numSubdivY $numSubdivZ [expr -$hsost] [expr -$bsostaux] [expr 0] [expr $bsostaux]
	
	# Acero ReinforcingSteel AT56-50H
	# malla de abajo 
	layer straight 4 6 $Asmalla [expr $cover-$hsost] [expr $bsostaux-$cover] [expr $cover-$hsost] [expr $cover-$bsostaux]
	#layer straight 5 7 $As [expr $cover-$hsost] [expr $bsostaux-$cover] [expr $cover-$hsost] [expr $cover-$bsostaux]
	
	#Acero A630S
	# 2 barras del 22
	layer straight 5 2 $As22 [expr $cover+$distphi22malla-$hsost] [expr $Hmarco/2] [expr $cover+$distphi22malla-$hsost] [expr -$Hmarco/2]	
	# 1 barra del 28
	fiber [expr $cover+$distphi22malla-$hsost+$Hmarco] 0 $As28 5
}


# Sostenimiento con fibras de acero, sin malla y con marco 
section Fiber 2 {
	# hormigón sostenimiento
	patch rect 2 $numSubdivY $numSubdivZ [expr -$hsost] [expr -$bsostaux] [expr 0] [expr $bsostaux]
	
	#Acero A630S
	# 2 barras del 22
	layer straight 5 2 $As22 [expr $cover+$distphi22malla-$hsost] [expr $Hmarco/2] [expr $cover+$distphi22malla-$hsost] [expr -$Hmarco/2]	
	# 1 barra del 28
	fiber [expr $cover+$distphi22malla-$hsost+$Hmarco] 0 $As28 5
}


# Sostenimiento con fibras de acero, sin malla y con marco 
section Fiber 3 {
	# hormigón sostenimiento
	patch rect 3 $numSubdivY $numSubdivZ [expr -$hsost] [expr -$bsostaux] [expr 0] [expr $bsostaux]
	
	#Acero A630S
	# 2 barras del 22
	layer straight 5 2 $As22 [expr $cover+$distphi22malla-$hsost] [expr $Hmarco/2] [expr $cover+$distphi22malla-$hsost] [expr -$Hmarco/2]	
	# 1 barra del 28
	fiber [expr $cover+$distphi22malla-$hsost+$Hmarco] 0 $As28 5
}


# revestimiento de hormigón con una malla
section Fiber 4 {
	# hormigón sostenimiento
	patch rect 1 $numSubdivY $numSubdivZ [expr -$hsost] [expr -$bsostaux] [expr 0] [expr $bsostaux]
	
	
	# Acero ReinforcingSteel AT56-50H
	# malla de arriba 
	layer straight 4 6 $Asmalla [expr -$cover+$hsost] [expr $bsostaux-$cover] [expr -$cover+$hsost] [expr $cover-$bsostaux]
	#layer straight 5 7 $As [expr $cover-$hsost] [expr $bsostaux-$cover] [expr $cover-$hsost] [expr $cover-$bsostaux]
	
	#Acero A630S
	# 2 barras del 22
	#layer straight 5 2 $As22 [expr $cover+$distphi22malla-$hsost] [expr $Hmarco/2] [expr $cover+$distphi22malla-$hsost] [expr -$Hmarco/2]	
	# 1 barra del 28
	#fiber [expr $cover+$distphi22malla-$hsost+$Hmarco] 0 $As28 5
}


#########################################################################
# Modelo
#########################################################################

# Procedimiento para analisis phi-M

proc MomentCurvaturepos {secTag axialLoad maxK {numIncr 100} } {
	# Define two nodes at (0,0)
	wipe
	node 1 0.0 0.0
	node 2 0.0 0.0

	# Fix all degrees of freedom except axial and bending
	fix 1 1 1 1
	fix 2 0 1 0

	# Define element
	#                         tag ndI ndJ  secTag
	element zeroLengthSection  1   1   2  $secTag

	# Create recorder
	recorder Node -file sectiondisp$secTag$axialLoad.pos.out -closeOnWrite -time -node 2 -dof 3 disp
	recorder Node -file sectionreac$secTag$axialLoad.pos.out -closeOnWrite -time -node 1 -dof 3 reaction

	# Define constant axial load
	pattern Plain 1 "Constant" {
		load 2 $axialLoad 0.0 0.0
	}

	# Define analysis parameters
	integrator LoadControl 0.0
	system SparseGeneral -piv;	# Overkill, but may need the pivoting!
	test NormUnbalance 1.0e-7 30 5
	numberer Plain
	constraints Plain
	algorithm Newton
	analysis Static

	# Do one analysis for constant axial load
	analyze 1

	# Define reference moment
	pattern Plain 2 "Linear" {
		load 2 0.0 0.0 1.0
	}

	# Compute curvature increment
	set dK [expr $maxK/$numIncr]

	# Use displacement control at node 2 for section analysis
	integrator DisplacementControl 2 3 [expr $dK]

	# Do the section analysis
	analyze $numIncr
}

proc MomentCurvatureneg {secTag axialLoad maxK {numIncr 100} } {
	# Define two nodes at (0,0)
	wipe
	node 1 0.0 0.0
	node 2 0.0 0.0

	# Fix all degrees of freedom except axial and bending
	fix 1 1 1 1
	fix 2 0 1 0

	# Define element
	#                         tag ndI ndJ  secTag
	element zeroLengthSection  1   1   2  $secTag

	# Create recorder
	recorder Node -file sectiondisp$secTag$axialLoad.neg.out -closeOnWrite -time -node 2 -dof 3 disp
	recorder Node -file sectionreac$secTag$axialLoad.neg.out -closeOnWrite -time -node 1 -dof 3 reaction

	# Define constant axial load
	pattern Plain 1 "Constant" {
		load 2 $axialLoad 0.0 0.0
	}

	# Define analysis parameters
	integrator LoadControl 0.0
	system SparseGeneral -piv;	# Overkill, but may need the pivoting!
	test NormUnbalance 1.0e-7 30 5
	numberer Plain
	constraints Plain
	algorithm Newton
	analysis Static

	# Do one analysis for constant axial load
	analyze 1

	# Define reference moment
	pattern Plain 2 "Linear" {
		load 2 0.0 0.0 1.0
	}

	# Compute curvature increment
	set dK [expr $maxK/$numIncr]

	# Use displacement control at node 2 for section analysis
	integrator DisplacementControl 2 3 [expr -$dK]

	# Do the section analysis
	analyze $numIncr
}

######################################################
# Diags M phi discretos

set numIncr 300;	

# Sostenimiento sin fibras 

MomentCurvaturepos 1 0 0.00092 $numIncr
MomentCurvaturepos 1 [expr -350000] 0.00085 $numIncr
MomentCurvaturepos 1 [expr -1000000] 0.00062 $numIncr
#MomentCurvaturepos 1 [expr -900000] 0.0005 $numIncr
MomentCurvaturepos 1 [expr -1800000] 0.00043 $numIncr

MomentCurvatureneg 1 0 0.00045 $numIncr
MomentCurvatureneg 1 [expr -350000] 0.00052 $numIncr
MomentCurvatureneg 1 [expr -1000000] 0.00037 $numIncr
#MomentCurvatureneg 1 [expr -900000] 0.0005 $numIncr
MomentCurvatureneg 1 [expr -1800000] 0.0002 $numIncr

# Sostenimiento fibras de acero
MomentCurvaturepos 2 0 0.00091 $numIncr
MomentCurvaturepos 2 [expr -350000] 0.00083 $numIncr
MomentCurvaturepos 2 [expr -1000000] 0.00062 $numIncr
#MomentCurvaturepos 2 [expr -900000] 0.0005 $numIncr
MomentCurvaturepos 2 [expr -1800000] 0.00043 $numIncr

MomentCurvatureneg 2 0 0.00043 $numIncr
MomentCurvatureneg 2 [expr -350000] 0.00048 $numIncr
MomentCurvatureneg 2 [expr -1000000] 0.00037 $numIncr
#MomentCurvatureneg 2 [expr -900000] 0.0005 $numIncr
MomentCurvatureneg 2 [expr -1800000] 0.0002 $numIncr

# Sostenimiento fibras de polipropileno
MomentCurvaturepos 3 0 0.00091 $numIncr
MomentCurvaturepos 3 [expr -350000] 0.00083 $numIncr
MomentCurvaturepos 3 [expr -1000000] 0.00062 $numIncr
#MomentCurvaturepos 3 [expr -900000] 0.0005 $numIncr
MomentCurvaturepos 3 [expr -1800000] 0.00043 $numIncr

MomentCurvatureneg 3 0 0.00043 $numIncr
MomentCurvatureneg 3 [expr -350000] 0.00048 $numIncr
MomentCurvatureneg 3 [expr -1000000] 0.00037 $numIncr
#MomentCurvatureneg 3 [expr -900000] 0.0005 $numIncr
MomentCurvatureneg 3 [expr -1800000] 0.0002 $numIncr
