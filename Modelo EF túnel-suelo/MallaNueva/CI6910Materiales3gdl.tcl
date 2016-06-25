# HORMIGÓN LINING 
model	BasicBuilder -ndm	2	-ndf 3

set IDconcCover 7; 				# material ID tag -- unconfined cover concrete

set fc 		-40e6;		# CONCRETE Compressive Strength, Pa   (+Tension, -Compression)
set Ec 		30000e6;	# Concrete Elastic Modulus

# unconfined concrete
set fc1U 		$fc;			# UNCONFINED concrete (todeschini parabolic model), maximum stress
set eps1U	-0.002;			# strain at maximum strength of unconfined concrete
set fc2U 		[expr 0.2*$fc1U];		# ultimate stress
set eps2U	-0.08;			# strain at ultimate stress
set lambda 0.05;				# ratio between unloading slope at $eps2 and initial slope $Ec

# tensile-strength properties
set ftU 3500000;		# tensile strength +tension
set Ets 200000000;		# tension softening stiffness

uniaxialMaterial Concrete02 $IDconcCover $fc1U $eps1U $fc2U $eps2U $lambda $ftU $Ets;	# build cover concrete (unconfined)
puts "  Material hormigón definido";


# ACERO 1 LINING (MARCO)

set IDreinf 8; 				# material ID tag -- reinforcement

set Fy 		450e6;		# STEEL yield stress
set Es		200000e6;		# modulus of steel
set Bs		0.05;			# strain-hardening ratio 
set R0 18;				# control the transition from elastic to plastic branches
set cR1 0.925;				# control the transition from elastic to plastic branches
set cR2 0.15;				# control the transition from elastic to plastic branches

uniaxialMaterial Steel02 $IDreinf $Fy $Es $Bs $R0 $cR1 $cR2;				# build reinforcement material

# ACERO 2 LINING (MALLA)

set IDreinf2 9; 				# material ID tag -- reinforcement

set Fy 		600e6;		# STEEL yield stress
set Es		200000e6;		# modulus of steel
set Bs		0.01;			# strain-hardening ratio 
set R0 18;				# control the transition from elastic to plastic branches
set cR1 0.925;				# control the transition from elastic to plastic branches
set cR2 0.15;				# control the transition from elastic to plastic branches

uniaxialMaterial Steel02 $IDreinf2 $Fy $Es $Bs $R0 $cR1 $cR2;				# build reinforcement material
puts "  Material aceros definido";
