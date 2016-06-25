# Sección lining
#model	BasicBuilder -ndm	2	-ndf 3

set secTag 24
#set matTag $IDconcCover
set matTag 7
set matTag2 $IDreinf2
set matTag3 $IDreinf
set numSubdivIJ 20
set numSubdivJK	20
set zI -0.5 
set yI -0.15 
set zJ 0.5
set yJ -0.15 
set zK 0.5 
set yK 0.15 
set zL -0.5 
set yL 0.15

set numFiber 7
set areaFiber [expr 295.0/1000*150/1000]
set zStart -0.45 
set yStart 0.1 
set zEnd 0.45 
set yEnd 0.1
set yStart2 -0.1 
set yEnd2 -0.1

set A1 [expr 615.75/1000000]
set A2 [expr 380.1/1000000]

section Fiber 24 {
patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
layer straight $matTag2 $numFiber $areaFiber $yStart $zStart $yEnd $zEnd
layer straight $matTag2 $numFiber $areaFiber $yStart2 $zStart $yEnd2 $zEnd
layer straight $matTag3 2 $A2 -0.05 -0.09 0.05 -0.09
#fiber 450 30 $A2 $matTag3
#fiber 550 30 $A2 $matTag3
layer straight $matTag3 1 $A1 0 0.09 0 0.09
#fiber 500 120 $A1 $matTag3

}


## Sección Vigas

#set secTag 2
#set E 100000000000
#set A 10000000
#set Iz 83333333333333

#section Elastic $secTag $E $A $Iz; # <$Iy $G $J>
