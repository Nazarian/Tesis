
Tension60=importdata('Elementostress160.out');
Deformacion60=importdata('Elementostrain160.out');
Fuerzas60 = importdata('NodosReac60.out');
Desplazamientos60 = importdata('NodosDisp60.out');

Tension40=importdata('Elementostress140.out');
Deformacion40=importdata('Elementostrain140.out');
Fuerzas40 = importdata('NodosReac40.out');
Desplazamientos40 = importdata('NodosDisp40.out');

Tension30=importdata('Elementostress130.out');
Deformacion30=importdata('Elementostrain130.out');
Fuerzas30 = importdata('NodosReac30.out');
Desplazamientos30 = importdata('NodosDisp30.out');

Tension20=importdata('Elementostress120.out');
Deformacion20=importdata('Elementostrain120.out');
Fuerzas20 = importdata('NodosReac20.out');
Desplazamientos20 = importdata('NodosDisp20.out');

Tension10=importdata('Elementostress110.out');
Deformacion10=importdata('Elementostrain110.out');
Fuerzas10 = importdata('NodosReac10.out');
Desplazamientos10 = importdata('NodosDisp10.out');

Tension5=importdata('Elementostress15.out');
Deformacion5=importdata('Elementostrain15.out');
Fuerzas5 = importdata('NodosReac5.out');
Desplazamientos5 = importdata('NodosDisp5.out');




%figure(1)
%plot(-Deformacion(:,4)*100,(-Tension(:,4)/1000--Tension(:,3)/1000))
%ylabel('q = (kPa)')
%xlabel('\epsilon_{1} (%)')
%hold on
%xlim([0 20])

figure(2)
plot((-Deformacion60(:,4)+Deformacion60(1,4))*100, ((Fuerzas60(:,4)+Fuerzas60(:,7)+Fuerzas60(:,10)+Fuerzas60(:,13))-(Fuerzas60(:,3)+Fuerzas60(:,6)+Fuerzas60(:,15)+Fuerzas60(:,18)))/1000 )
ylabel('q = \sigma_{1}-\sigma_{3} (kPa)')
xlabel('\epsilon_{1} (%)')
hold on
plot((-Deformacion40(:,4)+Deformacion40(1,4))*100, ((Fuerzas40(:,4)+Fuerzas40(:,7)+Fuerzas40(:,10)+Fuerzas40(:,13))-(Fuerzas40(:,3)+Fuerzas40(:,6)+Fuerzas40(:,15)+Fuerzas40(:,18)))/1000 )
plot((-Deformacion30(:,4)+Deformacion30(1,4))*100, ((Fuerzas30(:,4)+Fuerzas30(:,7)+Fuerzas30(:,10)+Fuerzas30(:,13))-(Fuerzas30(:,3)+Fuerzas30(:,6)+Fuerzas30(:,15)+Fuerzas30(:,18)))/1000 )
plot((-Deformacion20(:,4)+Deformacion20(1,4))*100, ((Fuerzas20(:,4)+Fuerzas20(:,7)+Fuerzas20(:,10)+Fuerzas20(:,13))-(Fuerzas20(:,3)+Fuerzas20(:,6)+Fuerzas20(:,15)+Fuerzas20(:,18)))/1000 )
plot((-Deformacion10(:,4)+Deformacion10(1,4))*100, ((Fuerzas10(:,4)+Fuerzas10(:,7)+Fuerzas10(:,10)+Fuerzas10(:,13))-(Fuerzas10(:,3)+Fuerzas10(:,6)+Fuerzas10(:,15)+Fuerzas10(:,18)))/1000 )
plot((-Deformacion5(:,4)+Deformacion5(1,4))*100, ((Fuerzas5(:,4)+Fuerzas5(:,7)+Fuerzas5(:,5)+Fuerzas5(:,13))-(Fuerzas5(:,3)+Fuerzas5(:,6)+Fuerzas5(:,15)+Fuerzas5(:,18)))/1000 )
set(gca, 'FontSize', 20, 'FontName','Times New Roman')
xlim([0 5])
legend('\sigma3=60 kPa', '\sigma3=40 kPa', '\sigma3=30 kPa', '\sigma3=20 kPa', '\sigma3=10 kPa', '\sigma3=5 kPa', 'Location', 'northwest')
ylim([0 3000])
%grid on

figure(3)

plot([0; ((Fuerzas60(:,4)+Fuerzas60(:,7)+Fuerzas60(:,10)+Fuerzas60(:,13))+(Fuerzas60(:,3)+Fuerzas60(:,6)+Fuerzas60(:,15)+Fuerzas60(:,18)))/2000], [0; ((Fuerzas60(:,4)+Fuerzas60(:,7)+Fuerzas60(:,10)+Fuerzas60(:,13))-(Fuerzas60(:,3)+Fuerzas60(:,6)+Fuerzas60(:,15)+Fuerzas60(:,18)))/1000] )
ylabel('q = \sigma_{1}-\sigma_{3} (kPa)')
xlabel('p=(\sigma_{1}+\sigma_{3})/2 (kPa)')
hold on
plot([0;  ((Fuerzas40(:,4)+Fuerzas40(:,7)+Fuerzas40(:,10)+Fuerzas40(:,13))+(Fuerzas40(:,3)+Fuerzas40(:,6)+Fuerzas40(:,15)+Fuerzas40(:,18)))/2000], [0; ((Fuerzas40(:,4)+Fuerzas40(:,7)+Fuerzas40(:,10)+Fuerzas40(:,13))-(Fuerzas40(:,3)+Fuerzas40(:,6)+Fuerzas40(:,15)+Fuerzas40(:,18)))/1000] )
plot([0; ((Fuerzas30(:,4)+Fuerzas30(:,7)+Fuerzas30(:,10)+Fuerzas30(:,13))+(Fuerzas30(:,3)+Fuerzas30(:,6)+Fuerzas30(:,15)+Fuerzas30(:,18)))/2000], [0; ((Fuerzas30(:,4)+Fuerzas30(:,7)+Fuerzas30(:,10)+Fuerzas30(:,13))-(Fuerzas30(:,3)+Fuerzas30(:,6)+Fuerzas30(:,15)+Fuerzas30(:,18)))/1000] )
plot([0; ((Fuerzas20(:,4)+Fuerzas20(:,7)+Fuerzas20(:,10)+Fuerzas20(:,13))+(Fuerzas20(:,3)+Fuerzas20(:,6)+Fuerzas20(:,15)+Fuerzas20(:,18)))/2000], [0; ((Fuerzas20(:,4)+Fuerzas20(:,7)+Fuerzas20(:,10)+Fuerzas20(:,13))-(Fuerzas20(:,3)+Fuerzas20(:,6)+Fuerzas20(:,15)+Fuerzas20(:,18)))/1000] )
plot([0; ((Fuerzas10(:,4)+Fuerzas10(:,7)+Fuerzas10(:,10)+Fuerzas10(:,13))+(Fuerzas10(:,3)+Fuerzas10(:,6)+Fuerzas10(:,15)+Fuerzas10(:,18)))/2000], [0; ((Fuerzas10(:,4)+Fuerzas10(:,7)+Fuerzas10(:,10)+Fuerzas10(:,13))-(Fuerzas10(:,3)+Fuerzas10(:,6)+Fuerzas10(:,15)+Fuerzas10(:,18)))/1000] )
plot([0; ((Fuerzas5(:,4)+Fuerzas5(:,7)+Fuerzas5(:,5)+Fuerzas5(:,13))+(Fuerzas5(:,3)+Fuerzas5(:,6)+Fuerzas5(:,15)+Fuerzas5(:,18)))/2000], [0; ((Fuerzas5(:,4)+Fuerzas5(:,7)+Fuerzas5(:,5)+Fuerzas5(:,13))-(Fuerzas5(:,3)+Fuerzas5(:,6)+Fuerzas5(:,15)+Fuerzas5(:,18)))/1000 ])
legend('\sigma3=60 kPa', '\sigma3=40 kPa', '\sigma3=30 kPa', '\sigma3=20 kPa', '\sigma3=10 kPa', '\sigma3=5 kPa', 'Location', 'northwest')

set(gca, 'FontSize', 20, 'FontName','Times New Roman')

%figure(3)
%plot([22 44 61 83],[3.2 5 6 8])

figure(4)
plot([0; -Deformacion60(:,4)*100], [0; (Deformacion60(:,4)+Deformacion60(:,2)+Deformacion60(:,3))*100])
hold on
plot([0; -Deformacion40(:,4)*100], [0; (Deformacion40(:,4)+Deformacion40(:,2)+Deformacion40(:,3))*100])
plot([0; -Deformacion30(:,4)*100], [0; (Deformacion30(:,4)+Deformacion30(:,2)+Deformacion30(:,3))*100])
plot([0; -Deformacion20(:,4)*100], [0; (Deformacion20(:,4)+Deformacion20(:,2)+Deformacion20(:,3))*100])
plot([0; -Deformacion10(:,4)*100], [0; (Deformacion10(:,4)+Deformacion10(:,2)+Deformacion10(:,3))*100])
plot([0; -Deformacion5(:,4)*100], [0; (Deformacion5(:,4)+Deformacion5(:,2)+Deformacion5(:,3))*100])
set(gca, 'FontSize', 20, 'FontName','Times New Roman')
legend('\sigma3=60 kPa', '\sigma3=40 kPa', '\sigma3=30 kPa', '\sigma3=20 kPa', '\sigma3=10 kPa', '\sigma3=5 kPa', 'Location', 'northwest')

ylabel('\epsilon_{v} (%)')
xlabel('\epsilon_{1} (%)')