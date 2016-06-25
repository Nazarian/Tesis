function datos = obtenerdatos(NodosLining)
largo=length(NodosLining);
datos=zeros(largo,4); % eps kappa P M

for i=1:largo
   aux1=csvread(strcat('Elemento',int2str(NodosLining(i,1)),'deformations.out'));
   aux2=csvread(strcat('Elemento',int2str(NodosLining(i,1)),'forces.out'));
   largo2=length(aux1);
   datos(i,1)=aux1(largo2,2);
   datos(i,2)=aux1(largo2,3);
   datos(i,3)=aux2(largo2,2);
   datos(i,4)=aux2(largo2,3);
   
end

%datos=1;

end