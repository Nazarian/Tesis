#./Opensees

wipe all
model basic -ndm 2 -ndf 2

# nodos
node	1	0	0	
node	2	1	0


fix 1 1 1 0
fix 2 0 1 0

# materiales

# Steel01 (FEDEAS)
set matTag 1
set Fy	680
set E0	200000
set b	0.02
uniaxialMaterial Steel01 $matTag $Fy $E0 $b; # <$a1 $a2 $a3 $a4>

# Steel02 (Giuffré-Menegotto-Pinto con endurecimiento isotrópico)
set matTag 2
set Fy	700
set E	200000
set b	0.01
set R0 5
set cR1	0.925
set cR2	0.15
uniaxialMaterial Steel02 $matTag $Fy $E $b $R0 $cR1 $cR2; # <$a1 $a2 $a3 $a4 $sigInit>

# Steel04

set matTag 3
set f_y 550
set E_0 200000

#uniaxialMaterial Steel4 $matTag $f_y $E_0 < -asym > < -kin $b_k $R_0 $r_1 $r_2 < $b_kc $R_0c $r_1c $r_2c > > < -iso $b_i $rho_i $b_l $R_i $l_yp < $b_ic $rho_ic $b_lc $R_ic> > < -ult $f_u $R_u < $f_uc $R_uc > > < -init $sig_init > < -mem $cycNum >



# ReinforcingSteel 
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

# Ramber Osgood
set matTag 5 
set fy 680 
set E0 200000
set a	0.002
set n	20

uniaxialMaterial RambergOsgoodSteel $matTag $fy $E0 $a $n


# Steel01 (FEDEAS)
set matTag 6
set Fy	550
set E0	200000
set b	0.01
uniaxialMaterial Steel01 $matTag $Fy $E0 $b; # <$a1 $a2 $a3 $a4>

# Steel02 (Giuffré-Menegotto-Pinto con endurecimiento isotrópico)
set matTag 7
set Fy	550
set E	200000
set b	0.015
set R0 2
set cR1	0.925
set cR2	0.15
uniaxialMaterial Steel02 $matTag $Fy $E $b $R0 $cR1 $cR2; # <$a1 $a2 $a3 $a4 $sigInit>

# Steel04

set matTag 8
set f_y 450
set E_0 200000

#uniaxialMaterial Steel4 $matTag $f_y $E_0 < -asym > < -kin $b_k $R_0 $r_1 $r_2 < $b_kc $R_0c $r_1c $r_2c > > < -iso $b_i $rho_i $b_l $R_i $l_yp < $b_ic $rho_ic $b_lc $R_ic> > < -ult $f_u $R_u < $f_uc $R_uc > > < -init $sig_init > < -mem $cycNum >



# ReinforcingSteel 
set matTag 99
set fy	450
set fu	680
set Es	200000
set Esh	20000
set esh	[expr 1.2*$fy/$Es]
set eult	0.09
set meult	[expr -$eult]

uniaxialMaterial ReinforcingSteel $matTag $fy $fu $Es $Esh $esh $eult -IsoHard	3.0 0.01

uniaxialMaterial MinMax 9 99 -min $meult -max $eult


# Ramber Osgood
set matTag 10 
set fy 500 
set E0 200000
set a	0.002
set n	10

uniaxialMaterial RambergOsgoodSteel $matTag $fy $E0 $a $n






# elementos

set Area	1.0
#set Area2	1.0

element truss 1 1 2 $Area 1 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
element truss 2 1 2 $Area 2 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
#element truss 3 1 2 $Area 3 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
element truss 4 1 2 $Area 4 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
element truss 5 1 2 $Area 5 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>


element truss 6 1 2 $Area 6 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
element truss 7 1 2 $Area 7 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
#element truss 3 1 2 $Area 3 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
element truss 9 1 2 $Area 9 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>
element truss 10 1 2 $Area 10 ;# <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>


pattern Plain 1 Linear {
	load 2 1.0 0.0
}

recorder Element -file ElementosfuerzasAceros.out -closeOnWrite -time -ele 1 2 4 5 6 7 9 10 axialForce
recorder Element -file ElementosdeformacionesAceros.out -closeOnWrite -time -ele 1 2 4 5 6 7 9 10 deformations


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
integrator DisplacementControl  2  1 0.0003
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 300



puts "OK"

analyze 1
