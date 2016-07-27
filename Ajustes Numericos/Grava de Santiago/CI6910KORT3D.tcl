wipe

#############################################################
# EXPERIMENTO 1

#interp recursionlimit {} 80000
#source opensees-vtk.tcl
 
#create the ModelBuilder
model basic -ndm 3 -ndf 3

node 1 0 0 0
node 2 1 0 0
node 3 1 1 0
node 4 0 1 0
node 5 0 0 1
node 6 1 0 1
node 7 1 1 1
node 8 0 1 1
 
fix 1 1 1 1
fix 2 0 1 1
fix 3 0 0 1
fix 4 1 0 1
fix 5 1 1 0
fix 6 0 1 0
fix 7 0 0 0
fix 8 1 0 0

equalDOF 5 6 3
equalDOF 5 7 3
equalDOF 5 8 3


# define material and properties

set rho 2100; # kg/m3
#set rho 0
set E 101140000; # Pa
set poisson 0.25;
set refShearModul [expr $E/(2*(1+$poisson))];
set refBulkModul [expr $E/(3*(1-2*$poisson))];
set pres -600000
# set mpres 10000;
# set refShearModul 130; # MPa
# set refBulkModul 200 # MPa 
set frictionAng 52 ;# grados 
set peakShearStra 0.02 ;# grados 
set refPress 20000;# Pa 
set pressDependCoe 0.5 ;# 
set PTAng 45 ;# 
#set contrac 0 ;# 
#set dilat1 50 ;# 
set liquefac1 0 ;# 
set liquefac2 0 ;# 
set liquefac3 0 ;# 
#$contrac1 $contrac3 $dilat1 $dilat3
set contrac1 0.01
set contrac2 5
set contrac3 0.0
set contrac 0.01
set dilat1 0.5
set dilat2 3 ;# 
set dilat3 0.0
set e 0.3
set cs1 0.9
set cs2 0.02
set cs3 0.7
set pa 101000
set ce 20000; #Pa

#nDMaterial PressureDependMultiYield 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 0 0.6 0.9 0.02 0.7 $pa $ce
#nDMaterial PressureDependMultiYield 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 
#nDMaterial PressureDependMultiYield02 1 2 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 <$noYieldSurf=20 $contrac2=5. $dilat2=3. $liquefac1=1. $liquefac2=0. $e=0.6 $cs1=0.9 $cs2=0.02 $cs3=0.7 $pa=101 <$c=0.1>>
nDMaterial PressureDependMultiYield02 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac1 $contrac3 $dilat1 $dilat3 20 $contrac2 $dilat2 $liquefac1 $liquefac2 $e $cs1 $cs2 $cs3 $pa $ce; # 0 1.
#nDMaterial PressureDependMultiYield02 100 2 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac1 $contrac3 $dilat1 $dilat3 20 5. 3. 1. 0. 0.6 0.9 0.02 0.7 101000 20000 0 1.

              #    ele#                     thick maTag    bulk  mDensity  perm1  perm2  gravity       
#element Quad  1     1 2 3 4 5 6 7 8 9  1.0   1       $bulk $fmass  $hperm  $vperm 0 0    

element stdBrick 1 1 2 3 4 5 6 7 8 1 $pres $pres $pres 
 
recorder Node -file NodosDisp60.out -time -node 1 2 3 4 5 6 7 8  -dof 1 2 3 disp;
recorder Node -file NodosReac60.out -time -node 1 2 3 4 5 6 7 8 -dof 1 2 3 reaction;
 
recorder Element -file Elementostress160.out -closeOnWrite -ele 1 -time material 1 stress
recorder Element -file Elementostrain160.out -closeOnWrite -ele 1 -time material 1 strain
 
 
#set material to elastic for gravity loading
updateMaterialStage -material 1 -stage 0  

#set fd [open "./Prueba.vtk" "w"]
#vtk_output_meta $fd
#vtk_output_mesh $fd
#vtk_output_point_data_header $fd
#vtk_output_ele_resp $fd
#vtk_output_node_disp $fd


#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-5 300 0
#algorithm Newton
#algorithm BFGS
algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1


updateMaterialStage -material 1 -stage 1

#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-5 300 0
#algorithm Newton
#algorithm BFGS
algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1
 
pattern Plain 1 Linear {
    load 5 0 0 -1   ; 
 #   load 2 -1000 0; 
  #  load 3 -1000 0; 
  #
}

#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-6 10000 1
#test RelativeEnergyIncr 1.e-8 100 0
#test NormUnbalance 1.e-5 300 1
algorithm Newton
#algorithm NewtonLineSearch
#algorithm BFGS
#algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
#system FullGeneral
system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator DisplacementControl 5 3 -0.001; # displacement control algorithm seking constant increment of 0.0002 at node 5 at 3'nd dof.

#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 200
 
#vtk_output_ele_resp $fd
#vtk_output_node_disp $fd

 
wipe;  #flush ouput stream


#####################################################################################
#####################################################################################
##### EXPERIMENTO 2

model basic -ndm 3 -ndf 3

node 1 0 0 0
node 2 1 0 0
node 3 1 1 0
node 4 0 1 0
node 5 0 0 1
node 6 1 0 1
node 7 1 1 1
node 8 0 1 1
 
fix 1 1 1 1
fix 2 0 1 1
fix 3 0 0 1
fix 4 1 0 1
fix 5 1 1 0
fix 6 0 1 0
fix 7 0 0 0
fix 8 1 0 0

equalDOF 5 6 3
equalDOF 5 7 3
equalDOF 5 8 3


# define material and properties

set rho 2100; # kg/m3
#set rho 0
set E 181140000; # Pa
set poisson 0.25;
set refShearModul [expr $E/(2*(1+$poisson))];
set refBulkModul [expr $E/(3*(1-2*$poisson))];
set pres -400000
# set mpres 10000;
# set refShearModul 130; # MPa
# set refBulkModul 200 # MPa 
set frictionAng 52 ;# grados 
set peakShearStra 0.02 ;# grados 
set refPress 20000;# Pa 
set pressDependCoe 0.5 ;# 
set PTAng 45 ;# 
#set contrac 0 ;# 
#set dilat1 50 ;# 
set liquefac1 0 ;# 
set liquefac2 0 ;# 
set liquefac3 0 ;# 
#$contrac1 $contrac3 $dilat1 $dilat3
set contrac1 0.01
set contrac2 5
set contrac3 0.0
set contrac 0.01
set dilat1 0.5
set dilat2 3 ;# 
set dilat3 0.0
set e 0.3
set cs1 0.9
set cs2 0.02
set cs3 0.7
set pa 101000
set ce 20000; #Pa

#nDMaterial PressureDependMultiYield 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 0 0.6 0.9 0.02 0.7 $pa $ce
#nDMaterial PressureDependMultiYield 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 
#nDMaterial PressureDependMultiYield02 1 2 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 <$noYieldSurf=20 $contrac2=5. $dilat2=3. $liquefac1=1. $liquefac2=0. $e=0.6 $cs1=0.9 $cs2=0.02 $cs3=0.7 $pa=101 <$c=0.1>>
nDMaterial PressureDependMultiYield02 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac1 $contrac3 $dilat1 $dilat3 20 $contrac2 $dilat2 $liquefac1 $liquefac2 $e $cs1 $cs2 $cs3 $pa $ce; # 0 1.
#nDMaterial PressureDependMultiYield02 100 2 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac1 $contrac3 $dilat1 $dilat3 20 5. 3. 1. 0. 0.6 0.9 0.02 0.7 101000 20000 0 1.

              #    ele#                     thick maTag    bulk  mDensity  perm1  perm2  gravity       
#element Quad  1     1 2 3 4 5 6 7 8 9  1.0   1       $bulk $fmass  $hperm  $vperm 0 0    

element stdBrick 1 1 2 3 4 5 6 7 8 1 $pres $pres $pres 
 
recorder Node -file NodosDisp40.out -time -node 1 2 3 4 5 6 7 8  -dof 1 2 3 disp;
recorder Node -file NodosReac40.out -time -node 1 2 3 4 5 6 7 8 -dof 1 2 3 reaction;
 
recorder Element -file Elementostress140.out -closeOnWrite -ele 1 -time material 1 stress
recorder Element -file Elementostrain140.out -closeOnWrite -ele 1 -time material 1 strain
 
 
#set material to elastic for gravity loading
updateMaterialStage -material 1 -stage 0  

#set fd [open "./Prueba.vtk" "w"]
#vtk_output_meta $fd
#vtk_output_mesh $fd
#vtk_output_point_data_header $fd
#vtk_output_ele_resp $fd
#vtk_output_node_disp $fd


#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-5 300 0
#algorithm Newton
#algorithm BFGS
algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1


updateMaterialStage -material 1 -stage 1

#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-5 300 0
#algorithm Newton
#algorithm BFGS
algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1
 
pattern Plain 1 Linear {
    load 5 0 0 -1   ; 
 #   load 2 -1000 0; 
  #  load 3 -1000 0; 
  #
}

#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-6 10000 1
#test RelativeEnergyIncr 1.e-8 100 0
#test NormUnbalance 1.e-5 300 1
algorithm Newton
#algorithm NewtonLineSearch
#algorithm BFGS
#algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
#system FullGeneral
system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator DisplacementControl 5 3 -0.001; # displacement control algorithm seking constant increment of 0.0002 at node 5 at 3'nd dof.

#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 200
 
#vtk_output_ele_resp $fd
#vtk_output_node_disp $fd

 
wipe;  #flush ouput stream


#####################################################################################
#####################################################################################
##### EXPERIMENTO 3

model basic -ndm 3 -ndf 3

node 1 0 0 0
node 2 1 0 0
node 3 1 1 0
node 4 0 1 0
node 5 0 0 1
node 6 1 0 1
node 7 1 1 1
node 8 0 1 1
 
fix 1 1 1 1
fix 2 0 1 1
fix 3 0 0 1
fix 4 1 0 1
fix 5 1 1 0
fix 6 0 1 0
fix 7 0 0 0
fix 8 1 0 0

equalDOF 5 6 3
equalDOF 5 7 3
equalDOF 5 8 3


# define material and properties

set rho 2100; # kg/m3
#set rho 0
set E 101140000; # Pa
set poisson 0.25;
set refShearModul [expr $E/(2*(1+$poisson))];
set refBulkModul [expr $E/(3*(1-2*$poisson))];
set pres -300000
# set mpres 10000;
# set refShearModul 130; # MPa
# set refBulkModul 200 # MPa 
set frictionAng 52 ;# grados 
set peakShearStra 0.02 ;# grados 
set refPress 20000;# Pa 
set pressDependCoe 0.5 ;# 
set PTAng 45 ;# 
#set contrac 0 ;# 
#set dilat1 50 ;# 
set liquefac1 0 ;# 
set liquefac2 0 ;# 
set liquefac3 0 ;# 
#$contrac1 $contrac3 $dilat1 $dilat3
set contrac1 0.01
set contrac2 5
set contrac3 0.0
set contrac 0.01
set dilat1 0.5
set dilat2 3 ;# 
set dilat3 0.0
set e 0.3
set cs1 0.9
set cs2 0.02
set cs3 0.7
set pa 101000
set ce 20000; #Pa

#nDMaterial PressureDependMultiYield 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 0 0.6 0.9 0.02 0.7 $pa $ce
#nDMaterial PressureDependMultiYield 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 
#nDMaterial PressureDependMultiYield02 1 2 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 <$noYieldSurf=20 $contrac2=5. $dilat2=3. $liquefac1=1. $liquefac2=0. $e=0.6 $cs1=0.9 $cs2=0.02 $cs3=0.7 $pa=101 <$c=0.1>>
nDMaterial PressureDependMultiYield02 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac1 $contrac3 $dilat1 $dilat3 20 $contrac2 $dilat2 $liquefac1 $liquefac2 $e $cs1 $cs2 $cs3 $pa $ce; # 0 1.
#nDMaterial PressureDependMultiYield02 100 2 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac1 $contrac3 $dilat1 $dilat3 20 5. 3. 1. 0. 0.6 0.9 0.02 0.7 101000 20000 0 1.

              #    ele#                     thick maTag    bulk  mDensity  perm1  perm2  gravity       
#element Quad  1     1 2 3 4 5 6 7 8 9  1.0   1       $bulk $fmass  $hperm  $vperm 0 0    

element stdBrick 1 1 2 3 4 5 6 7 8 1 $pres $pres $pres 
 
recorder Node -file NodosDisp30.out -time -node 1 2 3 4 5 6 7 8  -dof 1 2 3 disp;
recorder Node -file NodosReac30.out -time -node 1 2 3 4 5 6 7 8 -dof 1 2 3 reaction;
 
recorder Element -file Elementostress130.out -closeOnWrite -ele 1 -time material 1 stress
recorder Element -file Elementostrain130.out -closeOnWrite -ele 1 -time material 1 strain
 
 
#set material to elastic for gravity loading
updateMaterialStage -material 1 -stage 0  

#set fd [open "./Prueba.vtk" "w"]
#vtk_output_meta $fd
#vtk_output_mesh $fd
#vtk_output_point_data_header $fd
#vtk_output_ele_resp $fd
#vtk_output_node_disp $fd


#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-5 300 0
#algorithm Newton
#algorithm BFGS
algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1


updateMaterialStage -material 1 -stage 1

#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-5 300 0
#algorithm Newton
#algorithm BFGS
algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1
 
pattern Plain 1 Linear {
    load 5 0 0 -1   ; 
 #   load 2 -1000 0; 
  #  load 3 -1000 0; 
  #
}

#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-6 10000 1
#test RelativeEnergyIncr 1.e-8 100 0
#test NormUnbalance 1.e-5 300 1
algorithm Newton
#algorithm NewtonLineSearch
#algorithm BFGS
#algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
#system FullGeneral
system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator DisplacementControl 5 3 -0.001; # displacement control algorithm seking constant increment of 0.0002 at node 5 at 3'nd dof.

#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 200
 
#vtk_output_ele_resp $fd
#vtk_output_node_disp $fd

 
wipe;  #flush ouput stream


#####################################################################################
#####################################################################################
##### EXPERIMENTO 4

model basic -ndm 3 -ndf 3

node 1 0 0 0
node 2 1 0 0
node 3 1 1 0
node 4 0 1 0
node 5 0 0 1
node 6 1 0 1
node 7 1 1 1
node 8 0 1 1
 
fix 1 1 1 1
fix 2 0 1 1
fix 3 0 0 1
fix 4 1 0 1
fix 5 1 1 0
fix 6 0 1 0
fix 7 0 0 0
fix 8 1 0 0

equalDOF 5 6 3
equalDOF 5 7 3
equalDOF 5 8 3


# define material and properties

set rho 2100; # kg/m3
#set rho 0
set E 101140000; # Pa
set poisson 0.25;
set refShearModul [expr $E/(2*(1+$poisson))];
set refBulkModul [expr $E/(3*(1-2*$poisson))];
set pres -200000
# set mpres 10000;
# set refShearModul 130; # MPa
# set refBulkModul 200 # MPa 
set frictionAng 52 ;# grados 
set peakShearStra 0.02 ;# grados 
set refPress 20000;# Pa 
set pressDependCoe 0.5 ;# 
set PTAng 45 ;# 
#set contrac 0 ;# 
#set dilat1 50 ;# 
set liquefac1 0 ;# 
set liquefac2 0 ;# 
set liquefac3 0 ;# 
#$contrac1 $contrac3 $dilat1 $dilat3
set contrac1 0.01
set contrac2 5
set contrac3 0.0
set contrac 0.01
set dilat1 0.5
set dilat2 3 ;# 
set dilat3 0.0
set e 0.3
set cs1 0.9
set cs2 0.02
set cs3 0.7
set pa 101000
set ce 20000; #Pa

#nDMaterial PressureDependMultiYield 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 0 0.6 0.9 0.02 0.7 $pa $ce
#nDMaterial PressureDependMultiYield 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 
#nDMaterial PressureDependMultiYield02 1 2 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 <$noYieldSurf=20 $contrac2=5. $dilat2=3. $liquefac1=1. $liquefac2=0. $e=0.6 $cs1=0.9 $cs2=0.02 $cs3=0.7 $pa=101 <$c=0.1>>
nDMaterial PressureDependMultiYield02 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac1 $contrac3 $dilat1 $dilat3 20 $contrac2 $dilat2 $liquefac1 $liquefac2 $e $cs1 $cs2 $cs3 $pa $ce; # 0 1.
#nDMaterial PressureDependMultiYield02 100 2 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac1 $contrac3 $dilat1 $dilat3 20 5. 3. 1. 0. 0.6 0.9 0.02 0.7 101000 20000 0 1.

              #    ele#                     thick maTag    bulk  mDensity  perm1  perm2  gravity       
#element Quad  1     1 2 3 4 5 6 7 8 9  1.0   1       $bulk $fmass  $hperm  $vperm 0 0    

element stdBrick 1 1 2 3 4 5 6 7 8 1 $pres $pres $pres 
 
recorder Node -file NodosDisp20.out -time -node 1 2 3 4 5 6 7 8  -dof 1 2 3 disp;
recorder Node -file NodosReac20.out -time -node 1 2 3 4 5 6 7 8 -dof 1 2 3 reaction;
 
recorder Element -file Elementostress120.out -closeOnWrite -ele 1 -time material 1 stress
recorder Element -file Elementostrain120.out -closeOnWrite -ele 1 -time material 1 strain
 
 
#set material to elastic for gravity loading
updateMaterialStage -material 1 -stage 0  

#set fd [open "./Prueba.vtk" "w"]
#vtk_output_meta $fd
#vtk_output_mesh $fd
#vtk_output_point_data_header $fd
#vtk_output_ele_resp $fd
#vtk_output_node_disp $fd


#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-5 300 0
#algorithm Newton
#algorithm BFGS
algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1


updateMaterialStage -material 1 -stage 1

#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-5 300 0
#algorithm Newton
#algorithm BFGS
algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1
 
pattern Plain 1 Linear {
    load 5 0 0 -1   ; 
 #   load 2 -1000 0; 
  #  load 3 -1000 0; 
  #
}

#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-6 10000 1
#test RelativeEnergyIncr 1.e-8 100 0
#test NormUnbalance 1.e-5 300 1
algorithm Newton
#algorithm NewtonLineSearch
#algorithm BFGS
#algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
#system FullGeneral
system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator DisplacementControl 5 3 -0.001; # displacement control algorithm seking constant increment of 0.0002 at node 5 at 3'nd dof.

#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 200
 
#vtk_output_ele_resp $fd
#vtk_output_node_disp $fd

 
wipe;  #flush ouput stream


#####################################################################################
#####################################################################################
##### EXPERIMENTO 5

model basic -ndm 3 -ndf 3

node 1 0 0 0
node 2 1 0 0
node 3 1 1 0
node 4 0 1 0
node 5 0 0 1
node 6 1 0 1
node 7 1 1 1
node 8 0 1 1
 
fix 1 1 1 1
fix 2 0 1 1
fix 3 0 0 1
fix 4 1 0 1
fix 5 1 1 0
fix 6 0 1 0
fix 7 0 0 0
fix 8 1 0 0

equalDOF 5 6 3
equalDOF 5 7 3
equalDOF 5 8 3


# define material and properties

set rho 2100; # kg/m3
#set rho 0
set E 101140000; # Pa
set poisson 0.25;
set refShearModul [expr $E/(2*(1+$poisson))];
set refBulkModul [expr $E/(3*(1-2*$poisson))];
set pres -100000
# set mpres 10000;
# set refShearModul 130; # MPa
# set refBulkModul 200 # MPa 
set frictionAng 52 ;# grados 
set peakShearStra 0.02 ;# grados 
set refPress 20000;# Pa 
set pressDependCoe 0.5 ;# 
set PTAng 45 ;# 
#set contrac 0 ;# 
#set dilat1 50 ;# 
set liquefac1 0 ;# 
set liquefac2 0 ;# 
set liquefac3 0 ;# 
#$contrac1 $contrac3 $dilat1 $dilat3
set contrac1 0.01
set contrac2 5
set contrac3 0.0
set contrac 0.01
set dilat1 0.5
set dilat2 3 ;# 
set dilat3 0.0
set e 0.3
set cs1 0.9
set cs2 0.02
set cs3 0.7
set pa 101000
set ce 20000; #Pa

#nDMaterial PressureDependMultiYield 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 0 0.6 0.9 0.02 0.7 $pa $ce
#nDMaterial PressureDependMultiYield 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 
#nDMaterial PressureDependMultiYield02 1 2 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 <$noYieldSurf=20 $contrac2=5. $dilat2=3. $liquefac1=1. $liquefac2=0. $e=0.6 $cs1=0.9 $cs2=0.02 $cs3=0.7 $pa=101 <$c=0.1>>
nDMaterial PressureDependMultiYield02 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac1 $contrac3 $dilat1 $dilat3 20 $contrac2 $dilat2 $liquefac1 $liquefac2 $e $cs1 $cs2 $cs3 $pa $ce; # 0 1.
#nDMaterial PressureDependMultiYield02 100 2 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac1 $contrac3 $dilat1 $dilat3 20 5. 3. 1. 0. 0.6 0.9 0.02 0.7 101000 20000 0 1.

              #    ele#                     thick maTag    bulk  mDensity  perm1  perm2  gravity       
#element Quad  1     1 2 3 4 5 6 7 8 9  1.0   1       $bulk $fmass  $hperm  $vperm 0 0    

element stdBrick 1 1 2 3 4 5 6 7 8 1 $pres $pres $pres 
 
recorder Node -file NodosDisp10.out -time -node 1 2 3 4 5 6 7 8  -dof 1 2 3 disp;
recorder Node -file NodosReac10.out -time -node 1 2 3 4 5 6 7 8 -dof 1 2 3 reaction;
 
recorder Element -file Elementostress110.out -closeOnWrite -ele 1 -time material 1 stress
recorder Element -file Elementostrain110.out -closeOnWrite -ele 1 -time material 1 strain
 
 
#set material to elastic for gravity loading
updateMaterialStage -material 1 -stage 0  

#set fd [open "./Prueba.vtk" "w"]
#vtk_output_meta $fd
#vtk_output_mesh $fd
#vtk_output_point_data_header $fd
#vtk_output_ele_resp $fd
#vtk_output_node_disp $fd


#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-5 300 0
#algorithm Newton
#algorithm BFGS
algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1


updateMaterialStage -material 1 -stage 1

#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-5 300 0
#algorithm Newton
#algorithm BFGS
algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1
 
pattern Plain 1 Linear {
    load 5 0 0 -1   ; 
 #   load 2 -1000 0; 
  #  load 3 -1000 0; 
  #
}

#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-6 10000 1
#test RelativeEnergyIncr 1.e-8 100 0
#test NormUnbalance 1.e-5 300 1
algorithm Newton
#algorithm NewtonLineSearch
#algorithm BFGS
#algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
#system FullGeneral
system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator DisplacementControl 5 3 -0.001; # displacement control algorithm seking constant increment of 0.0002 at node 5 at 3'nd dof.

#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 200
 
#vtk_output_ele_resp $fd
#vtk_output_node_disp $fd

 
wipe;  #flush ouput stream


#####################################################################################
#####################################################################################
##### EXPERIMENTO 6

model basic -ndm 3 -ndf 3

node 1 0 0 0
node 2 1 0 0
node 3 1 1 0
node 4 0 1 0
node 5 0 0 1
node 6 1 0 1
node 7 1 1 1
node 8 0 1 1
 
fix 1 1 1 1
fix 2 0 1 1
fix 3 0 0 1
fix 4 1 0 1
fix 5 1 1 0
fix 6 0 1 0
fix 7 0 0 0
fix 8 1 0 0

equalDOF 5 6 3
equalDOF 5 7 3
equalDOF 5 8 3


# define material and properties

set rho 2100; # kg/m3
#set rho 0
set E 101140000; # Pa
set poisson 0.25;
set refShearModul [expr $E/(2*(1+$poisson))];
set refBulkModul [expr $E/(3*(1-2*$poisson))];
set pres -50000
# set mpres 10000;
# set refShearModul 130; # MPa
# set refBulkModul 200 # MPa 
set frictionAng 52 ;# grados 
set peakShearStra 0.02 ;# grados 
set refPress 20000;# Pa 
set pressDependCoe 0.5 ;# 
set PTAng 45 ;# 
#set contrac 0 ;# 
#set dilat1 50 ;# 
set liquefac1 0 ;# 
set liquefac2 0 ;# 
set liquefac3 0 ;# 
#$contrac1 $contrac3 $dilat1 $dilat3
set contrac1 0.01
set contrac2 5
set contrac3 0.0
set contrac 0.01
set dilat1 0.5
set dilat2 3 ;# 
set dilat3 0.0
set e 0.3
set cs1 0.9
set cs2 0.02
set cs3 0.7
set pa 101000
set ce 20000; #Pa

#nDMaterial PressureDependMultiYield 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 0 0.6 0.9 0.02 0.7 $pa $ce
#nDMaterial PressureDependMultiYield 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 
#nDMaterial PressureDependMultiYield02 1 2 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac $dilat1 $dilat2 $liquefac1 $liquefac2 $liquefac3 <$noYieldSurf=20 $contrac2=5. $dilat2=3. $liquefac1=1. $liquefac2=0. $e=0.6 $cs1=0.9 $cs2=0.02 $cs3=0.7 $pa=101 <$c=0.1>>
nDMaterial PressureDependMultiYield02 1 3 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac1 $contrac3 $dilat1 $dilat3 20 $contrac2 $dilat2 $liquefac1 $liquefac2 $e $cs1 $cs2 $cs3 $pa $ce; # 0 1.
#nDMaterial PressureDependMultiYield02 100 2 $rho $refShearModul $refBulkModul $frictionAng $peakShearStra $refPress $pressDependCoe $PTAng $contrac1 $contrac3 $dilat1 $dilat3 20 5. 3. 1. 0. 0.6 0.9 0.02 0.7 101000 20000 0 1.

              #    ele#                     thick maTag    bulk  mDensity  perm1  perm2  gravity       
#element Quad  1     1 2 3 4 5 6 7 8 9  1.0   1       $bulk $fmass  $hperm  $vperm 0 0    

element stdBrick 1 1 2 3 4 5 6 7 8 1 $pres $pres $pres 
 
recorder Node -file NodosDisp5.out -time -node 1 2 3 4 5 6 7 8  -dof 1 2 3 disp;
recorder Node -file NodosReac5.out -time -node 1 2 3 4 5 6 7 8 -dof 1 2 3 reaction;
 
recorder Element -file Elementostress15.out -closeOnWrite -ele 1 -time material 1 stress
recorder Element -file Elementostrain15.out -closeOnWrite -ele 1 -time material 1 strain
 
 
#set material to elastic for gravity loading
updateMaterialStage -material 1 -stage 0  

#set fd [open "./Prueba.vtk" "w"]
#vtk_output_meta $fd
#vtk_output_mesh $fd
#vtk_output_point_data_header $fd
#vtk_output_ele_resp $fd
#vtk_output_node_disp $fd


#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-5 300 0
#algorithm Newton
#algorithm BFGS
algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1


updateMaterialStage -material 1 -stage 1

#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-5 300 0
#algorithm Newton
#algorithm BFGS
algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
system FullGeneral
#system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator LoadControl 1;
#integrator DisplacementControl 5 3 -0.0001; # displacement control algorithm seking constant increment of 0.1 at node 1 at 2'nd dof.
#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 1
 
pattern Plain 1 Linear {
    load 5 0 0 -1   ; 
 #   load 2 -1000 0; 
  #  load 3 -1000 0; 
  #
}

#constraints Plain ;  # Penalty 1.0e18 1.0e18  ;# 
constraints Plain
test NormDispIncr 1.e-6 10000 1
#test RelativeEnergyIncr 1.e-8 100 0
#test NormUnbalance 1.e-5 300 1
algorithm Newton
#algorithm NewtonLineSearch
#algorithm BFGS
#algorithm ModifiedNewton 
#algorithm KrylovNewton
numberer Plain
#system FullGeneral
system ProfileSPD
#set nw 1.5
#set nw2 [expr pow($nw+0.5, 2)/4]
#integrator Newmark $nw $nw2
integrator DisplacementControl 5 3 -0.001; # displacement control algorithm seking constant increment of 0.0002 at node 5 at 3'nd dof.

#analysis Transient 
analysis Static
 
#analyze 1 
 
analyze 200
 
#vtk_output_ele_resp $fd
#vtk_output_node_disp $fd

 
wipe;  #flush ouput stream


