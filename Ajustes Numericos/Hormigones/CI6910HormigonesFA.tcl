
wipe all
model basic -ndm 2 -ndf 2

# nodos
node	1	0	0	
node	2	1	0


fix 1 1 1 0
fix 2 0 1 0

# materiales

# Concrete02
set matTag 1
set fpc	-60
set epsc0	-0.0035
set fpcu	-38
set epsU	-0.01
set lambda	1
set ft	5
set Ets	100
uniaxialMaterial Concrete02 $matTag $fpc $epsc0 $fpcu $epsU $lambda $ft $Ets

# Concrete04 (Popovics)
set matTag 2
set fc	-60
set ec	-0.0035
set ecu	-2
set Ec 25000
set fct	5
set et	0.0002
set beta	1

uniaxialMaterial Concrete04 $matTag $fc $ec $ecu $Ec $fct $et $beta

# Concrete06 (Thorenfeldt)

set matTag 3
set fc -60
set e0 -0.0035
set n	2.1
set k	1
set alpha1	0.32
set fcr	5
set ecr	0.0002	
set b	0.5
set alpha2	0.08

uniaxialMaterial Concrete06 $matTag $fc $e0 $n $k $alpha1 $fcr $ecr $b $alpha2

# ConcreteCM (Chang Mander) 
set matTag 4
set fpcc	-60
set epcc	-0.0035
set Ec	25000
set rc	9
set xcrn	1.035
set ft	3.2
set et	0.00015
set rt	0.9
set xcrp	10000.0
set gap 	0


uniaxialMaterial ConcreteCM $matTag $fpcc $epcc $Ec $rc $xcrn $ft $et $rt $xcrp -GapClose $gap

#uniaxialMaterial MinMax 4 44 -min $meult -max $eult

# elementos

set Area	1.0
#set Area2	1.0

element truss 1 1 2 $Area 1 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
element truss 2 1 2 $Area 2 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
element truss 3 1 2 $Area 3 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
element truss 4 1 2 $Area 4 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>


pattern Plain 1 Linear {
	load 2 1.0 0.0
}

recorder Element -file ElementosfuerzasFA.out -closeOnWrite -time -ele 1 2 3 4 axialForce
recorder Element -file ElementosdeformacionesFA.out -closeOnWrite -time -ele 1 2 3 4 deformations


constraints Plain
test NormDispIncr 1.e-9 300 0
algorithm Newton
#algorithm BFGS
#algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
#integrator LoadControl 1;
integrator DisplacementControl  2  1 -0.00001
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1000



puts "OK"

analyze 1


wipe all
model basic -ndm 2 -ndf 2

# nodos
node	1	0	0	
node	2	1	0


fix 1 1 1 0
fix 2 0 1 0

# materiales

# Concrete02
set matTag 1
set fpc	-60
set epsc0	-0.0035
set fpcu	-38
set epsU	-0.01
set lambda	1
set ft	5
set Ets	100
uniaxialMaterial Concrete02 $matTag $fpc $epsc0 $fpcu $epsU $lambda $ft $Ets

# Concrete04 (Popovics)
set matTag 2
set fc	-60
set ec	-0.0035
set ecu	-2
set Ec 25000
set fct	5
set et	0.0002
set beta	1

uniaxialMaterial Concrete04 $matTag $fc $ec $ecu $Ec $fct $et $beta

# Concrete06 (Thorenfeldt)

set matTag 3
set fc -60
set e0 -0.0035
set n	2.1
set k	1
set alpha1	0.32
set fcr	5
set ecr	0.0002	
set b	0.5
set alpha2	0.08

uniaxialMaterial Concrete06 $matTag $fc $e0 $n $k $alpha1 $fcr $ecr $b $alpha2

# ConcreteCM (Chang Mander) 
set matTag 4
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

#uniaxialMaterial MinMax 4 44 -min $meult -max $eult

# elementos

set Area	1.0
#set Area2	1.0

element truss 1 1 2 $Area 1 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
element truss 2 1 2 $Area 2 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
element truss 3 1 2 $Area 3 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
element truss 4 1 2 $Area 4 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>


pattern Plain 1 Linear {
	load 2 1.0 0.0
}

recorder Element -file ElementosfuerzasFAtrac.out -time -closeOnWrite -ele 1 2 3 4 axialForce
recorder Element -file ElementosdeformacionesFAtrac.out -time -closeOnWrite -ele 1 2 3 4 deformations


constraints Plain
test NormDispIncr 1.e-9 300 0
algorithm Newton
#algorithm BFGS
#algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
#integrator LoadControl 1;
integrator DisplacementControl  2  1 0.00001
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 250



puts "OK"

analyze 1
