#equalDOF	1	32557	1	2
#equalDOF	8052	33469	1	2

#element truss 9000000 1 32557 $A $matTag <-rho $rho> <-cMass $cFlag> <-doRayleigh $rFlag>


uniaxialMaterial Elastic 123123123 1.0e19

#element twoNodeLink 9000000 1 32557 -mat 123123123 123123123 -dir 1 2 
#element twoNodeLink 9000001 8052 33469 -mat 123123123 123123123 -dir 1 2 

set A 1.0e9
element truss 90000002 200001 232557 $A 123123123 
element truss 90000003 208052 233469 $A 123123123 

#element	elasticBeamColumn	200001	200001	200002	$AINF	$EINF	$IzINF	2
