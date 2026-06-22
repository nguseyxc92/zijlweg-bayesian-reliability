clear all
close all
clc
% this M-file reads the data of the tests and makes the graphs
% units: kN, mm

%Reading data from Excel sheet with measurements
load data_22_06_2015_yyg.mat

%correcting lasers 1 and 2
corr1 = (zijlwegshear01.lvdt(:,13)-zijlwegshear01.laser(:,3))/(2427-1425)*(878-1425)+zijlwegshear01.laser(:,3);
corr2 = (zijlwegshear01.laser(:,4)-zijlwegshear01.lvdt(:,13))/(4459-2427)*(3955-2427)+zijlwegshear01.lvdt(:,13);
laser01_corr = zijlwegshear01.laser(:,1)-corr1;
laser02_corr = zijlwegshear01.laser(:,2)-corr2;

%measured loading graph
Ftot = abs(zijlwegshear01.p(:,1) + zijlwegshear01.p(:,2) + zijlwegshear01.p(:,3) + zijlwegshear01.p(:,4));
Fomax = max(Ftot)
length = length(Ftot)
f1=figure;
tmax = max(zijlwegshear01.time);
plot(zijlwegshear01.time(1:7000),Ftot(1:7000),'color', 'k', 'linewidth', 2)
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman');
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman');
title('Measured Loading Graph','FontWeight','bold','Fontname', 'Times New Roman');
axis([0 7000 0 Fomax+50]);
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'loading graph.tif')
saveas(gcf,'loading graph.eps')

tminutes = zijlwegshear01.time/60;
tminutesmax = max(tminutes);
figure;
plot(tminutes,Ftot,'color', 'b','linewidth', 2)
xlabel('Time (min)','FontWeight','bold','Fontname', 'Times New Roman');
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman');
title('Measured Loading Graph','FontWeight','bold','Fontname', 'Times New Roman');
axis([0 120 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'loading graph minutes.tif')
saveas(gcf,'loading graph minutes.eps')

%measured force-displacement graph based on LVDT6
so = -zijlwegshear01.disp(:,2);
somax = max(so);
f2=figure;
plot(so,Ftot,'color', 'b','linewidth',1.2)
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F(kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Measured Force-Displacement','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 somax+0.2 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'measured force-displacement.tif')

%longitudinal plot of deck


for i=1:length
    if Ftot(i) >= 392 && Ftot(i)<=396 ;
        val1 = i;
        break
    end
end
for i=1:length
    if Ftot(i) >= 800 && Ftot(i)<=810;
        val2 = i;
        break
    end
end
for i=1:length
    if Ftot(i) >= 1079 && Ftot(i)<=1083;
        val3 = i;
        break
    end
end
for i=1:length
    if Ftot(i) >= 1215 && Ftot(i)<=1220;
        val4 = i;
        break
    end
end
for i=1:length
     if Ftot(i) == Fomax;
        val5 = i;
    end
end

location = [0 2010 1908+2010 1924+1908+2010 1920+1924+1908+2010 9605]; %taken from Support 5, north side

defl1 = [0 zijlwegshear01.disp(val1,1) zijlwegshear01.disp(val1,2) zijlwegshear01.disp(val1,3) zijlwegshear01.disp(val1,4) 0];
defl2 = [0 zijlwegshear01.disp(val2,1) zijlwegshear01.disp(val2,2) zijlwegshear01.disp(val2,3) zijlwegshear01.disp(val2,4) 0];
defl3 = [0 zijlwegshear01.disp(val3,1) zijlwegshear01.disp(val3,2) zijlwegshear01.disp(val3,3) zijlwegshear01.disp(val3,4) 0];
defl4 = [0 zijlwegshear01.disp(val4,1) zijlwegshear01.disp(val4,2) zijlwegshear01.disp(val4,3) zijlwegshear01.disp(val4,4) 0];
defl5 = [0 zijlwegshear01.disp(val5,1) zijlwegshear01.disp(val5,2) zijlwegshear01.disp(val5,3) zijlwegshear01.disp(val5,4) 0];

f3=figure;
plot(location, -defl1, 'k-o','linewidth', 2)
hold on
plot(location, -defl2, 'r-o','linewidth', 2)
plot(location, -defl3, 'b-o','linewidth', 2)
plot(location, -defl4, 'g-o','linewidth', 2)
plot(location, -defl5, 'color', [0.65,0.65,0.65], 'marker', 'o','linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('40 ton','83 ton' ,'111 ton','120 ton','134 ton', 'location','EastOutside')
title ('Longitudinal deflection profiles','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from Sup 5 (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'Longitudinaldeflectionplot.tif')

f3=figure;
plot(location, -defl1, 'k-o','linewidth', 2)
hold on
plot(location, -defl2, 'r-o','linewidth', 2)
plot(location, -defl3, 'b-o','linewidth', 2)
plot(location, -defl4, 'g-o','linewidth', 2)
plot(location, -defl5, 'color', [0.65,0.65,0.65], 'marker', 'o','linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('400 kN','830 kN' ,'1110 kN','1200 kN','1340 kN', 'location','EastOutside')
title ('Longitudinal deflection profiles','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from Sup 5 (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'LongitudinaldeflectionplotkN.tif')
saveas(gcf,'LongitudinaldeflectionplotkN.pdf')

f3=figure;
plot(location, -defl1, 'k-o','linewidth', 2)
hold on
plot(location, -defl2, 'k-o','linewidth', 2)
plot(location, -defl3, 'color', [0.65,0.65,0.65], 'marker', 'o','linewidth', 1)
plot(location, -defl4, 'color', [0.85,0.85,0.85], 'marker', 'o','linewidth', 2)
plot(location, -defl5, 'color', [0.65,0.65,0.65], 'marker', 'o','linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('40 ton','83 ton' ,'111 ton','120 ton','134 ton', 'location','EastOutside')
title ('Longitudinal deflection profiles','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from Sup 5 (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'Longitudinaldeflectionplotbw.eps')

f4=figure;
plot(-zijlwegshear01.disp(:,1), Ftot, 'k')
hold on
plot(-zijlwegshear01.disp(:,2), Ftot, 'r')
plot(-zijlwegshear01.disp(:,3), Ftot, 'b')
plot(-zijlwegshear01.disp(:,4), Ftot, 'g')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT5','LVDT6','LVDT7','LVDT8', 'location','EastOutside')
title ('Measurements in longitudinal direction versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(-zijlwegshear01.disp(:,2))+0.15 0 Fomax+20])
saveas(gcf,'Longitudinalvsload.tif')

f5=figure;
plot(zijlwegshear01.time, zijlwegshear01.disp(:,1),'k','linewidth', 2)
hold on
plot(zijlwegshear01.time, zijlwegshear01.disp(:,2),'r', 'linewidth', 2)
plot(zijlwegshear01.time, zijlwegshear01.disp(:,3),'b', 'linewidth', 2)
plot(zijlwegshear01.time, zijlwegshear01.disp(:,4),'g', 'linewidth', 2)
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT5','LVDT6','LVDT7','LVDT8', 'location','EastOutside')
title ('Measurements in longitudinal direction versus time','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 7000 min(zijlwegshear01.disp(:,2)) 0])
saveas(gcf,'Longitudinalvstime.tif')

f6=figure;
subplot(2,2,1);
plot(-zijlwegshear01.disp(:,1), Ftot, 'b');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
title ('LVDT5','FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3 0 Fomax+20])
subplot(2,2,2);
plot(-zijlwegshear01.disp(:,2), Ftot, 'b');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
title ('LVDT6','FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3 0 Fomax+20])
subplot(2,2,3);
plot(-zijlwegshear01.disp(:,3), Ftot, 'b');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3 0 Fomax+20])
title ('LVDT7','FontWeight','bold','Fontname', 'Times New Roman');
subplot(2,2,4);
plot(-zijlwegshear01.disp(:,4), Ftot, 'b');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
title ('LVDT8','FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3 0 Fomax+20])
saveas(gcf,'Subplotslongvsload.tif')

%transverse plot of deck
widthloc = [5006 3457 1929]; %taken from west side

trans1 = [laser01_corr(val1) zijlwegshear01.disp(val1,2) laser02_corr(val1)];
trans2 = [laser01_corr(val2) zijlwegshear01.disp(val2,2) laser02_corr(val2)];
trans3 = [laser01_corr(val3) zijlwegshear01.disp(val3,2) laser02_corr(val3)];
trans4 = [laser01_corr(val4) zijlwegshear01.disp(val4,2) laser02_corr(val4)];
trans5 = [laser01_corr(val5) zijlwegshear01.disp(val5,2) laser02_corr(val5)];

f7=figure;
plot(widthloc, -trans1, 'k-o','linewidth', 2)
hold on
plot(widthloc, -trans2, 'r-o','linewidth', 2)
plot(widthloc, -trans3, 'b-o','linewidth', 2)
plot(widthloc, -trans4, 'g-o','linewidth', 2)
plot(widthloc, -trans5, 'color', [0.65,0.65,0.65],'marker', 'o','linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on','linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman')
legend('40 ton','83 ton' ,'111 ton','120 ton','134 ton', 'location','EastOutside')
title ('Transverse deflection profiles','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from west side (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 5884 0 max(-zijlwegshear01.disp(:,2))+0.2 ])
saveas(gcf,'Transversedeflectionplot.tif')

f7=figure;
plot(widthloc, -trans1, 'k-o','linewidth', 2)
hold on
plot(widthloc, -trans2, 'r-o','linewidth', 2)
plot(widthloc, -trans3, 'b-o','linewidth', 2)
plot(widthloc, -trans4, 'g-o','linewidth', 2)
plot(widthloc, -trans5, 'color', [0.65,0.65,0.65],'marker', 'o','linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on','linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman')
legend('400 kN','830 kN' ,'1110 kN','1200 kN','1340 kN', 'location','EastOutside')
title ('Transverse deflection profiles','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from west side (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 5884 0 max(-zijlwegshear01.disp(:,2))+0.2 ])
saveas(gcf,'TransversedeflectionplotkN.pdf')

f8=figure;
plot(-laser01_corr, Ftot, 'b')
hold on
plot(-zijlwegshear01.disp(:,2), Ftot, 'r')
plot(-laser02_corr, Ftot, 'g')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('laser1','LVDT6','laser2', 'location','EastOutside')
title ('Measurements in transverse direction versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(-zijlwegshear01.disp(:,2))+0.15 0 Fomax+20])
saveas(gcf,'Transversevsload.tif')

f9=figure;
plot(zijlwegshear01.time, laser01_corr,'b')
hold on
plot(zijlwegshear01.time, zijlwegshear01.disp(:,2),'r')
plot(zijlwegshear01.time, laser02_corr, 'g')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('laser1','LVDT6','laser2', 'location','EastOutside')
title ('Measurements in transverse direction versus time','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 7000 min(zijlwegshear01.disp(:,2))-0.2 max(laser01_corr)+0.1])
saveas(gcf,'Transversevstime.tif')

f10=figure;
subplot(1,3,1);
plot(-laser01_corr, Ftot, 'b');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title ('Laser1','FontWeight','bold','Fontname', 'Times New Roman');
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3 0 Fomax+20])
subplot(1,3,2);
plot(-zijlwegshear01.disp(:,2), Ftot, 'b');
title ('LVDT6','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3 0 Fomax+20])
subplot(1,3,3);
plot(-laser02_corr, Ftot, 'b');
title ('Laser2','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3 0 Fomax+20])
saveas(gcf,'Subplotstransvsload.tif')

%deformations of cross beams
%deformation at Support 5
widthpos5 = [4459 3457 1425]; %taken from west side

pos51 = [zijlwegshear01.laser(val1,3) zijlwegshear01.lvdt(val1,13) zijlwegshear01.laser(val1,4)];
pos52 = [zijlwegshear01.laser(val2,3) zijlwegshear01.lvdt(val2,13) zijlwegshear01.laser(val2,4)];
pos53 = [zijlwegshear01.laser(val3,3) zijlwegshear01.lvdt(val3,13) zijlwegshear01.laser(val3,4)];
pos54 = [zijlwegshear01.laser(val4,3) zijlwegshear01.lvdt(val4,13) zijlwegshear01.laser(val4,4)];
pos55 = [zijlwegshear01.laser(val5,3) zijlwegshear01.lvdt(val5,13) zijlwegshear01.laser(val5,4)];

f11=figure;
plot(widthpos5, -pos51, 'k-o','linewidth', 2)
hold on
plot(widthpos5, -pos52, 'r-o','linewidth', 2)
plot(widthpos5, -pos53, 'b-o','linewidth', 2)
plot(widthpos5, -pos54, 'g-o','linewidth', 2)
plot(widthpos5, -pos55, 'color', [0.65,0.65,0.65],'marker', 'o', 'linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on')
legend('40 ton','83 ton' ,'111 ton','120 ton','134 ton', 'location','EastOutside')
title ('Deflection at Support 5','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from west side (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 5884 0 max(-zijlwegshear01.laser(:,3))+0.2 ])
saveas(gcf,'sup5plot.tif')

f12=figure;
plot(-zijlwegshear01.laser(:,3), Ftot, 'b')
hold on
plot(-zijlwegshear01.lvdt(:,13), Ftot, 'r')
plot(-zijlwegshear01.laser(:,4), Ftot, 'g')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('laser3','LVDT13','laser4', 'location','EastOutside')
title ('Deflections at Support 5 versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)', 'FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(-zijlwegshear01.laser(:,3))+0.15 0 Fomax+20])
saveas(gcf,'Sup5vsload.tif')

f13=figure;
plot(zijlwegshear01.time, zijlwegshear01.laser(:,3),'b','linewidth',2)
hold on
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,13),'r','linewidth',2)
plot(zijlwegshear01.time, zijlwegshear01.laser(:,4), 'g','linewidth',2)
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('laser3','LVDT13','laser4', 'location','EastOutside')
title ('Deflections at Support 5 versus time','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 7000 min(zijlwegshear01.laser(:,3)) 0])
saveas(gcf,'Sup5vstime.tif')

%deformation at Support 4
widthpos4 = [4409 1375]; %taken from west side

pos41 = [zijlwegshear01.laser(val1,5) zijlwegshear01.laser(val1,6)];
pos42 = [zijlwegshear01.laser(val2,5) zijlwegshear01.laser(val2,6)];
pos43 = [zijlwegshear01.laser(val3,5) zijlwegshear01.laser(val3,6)];
pos44 = [zijlwegshear01.laser(val4,5) zijlwegshear01.laser(val4,6)];
pos45 = [zijlwegshear01.laser(val5,5) zijlwegshear01.laser(val5,6)];

f14=figure;
plot(widthpos4, -pos41,  'k-o','linewidth',2)
hold on
plot(widthpos4, -pos42, 'r-o','linewidth',2)
plot(widthpos4, -pos43, 'b-o','linewidth',2)
plot(widthpos4, -pos44, 'g-o','linewidth',2)
plot(widthpos4, -pos45, 'color', [0.65,0.65,0.65],'marker', 'o','linewidth',2)
hold off
axis ij
set(gca,'YGrid','on','linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman')
legend('40 ton','83 ton' ,'111 ton','120 ton','134 ton', 'location','EastOutside')
title ('Deflection at Support 4','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from west side (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 5784 -1 0.6 ])
saveas(gcf,'sup4plot.tif')

f15=figure;
plot(-zijlwegshear01.laser(:,5), Ftot, 'b')
hold on
plot(-zijlwegshear01.laser(:,6), Ftot, 'r')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('laser5','laser6', 'location','EastOutside')
title ('Deflections at Support 4 versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'Sup4vsload.tif')

f16=figure;
plot(zijlwegshear01.time, zijlwegshear01.laser(:,5),'b')
hold on
plot(zijlwegshear01.time, zijlwegshear01.laser(:,6), 'r')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('laser5','laser6', 'location','EastOutside')
title ('Deflections at Support 4 versus time','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'Sup4vstime.tif')

%monitoring of cracks with LVDTs 14, 15 and 16
f17=figure;
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,14), 'color', 'g','linewidth',2)
hold on
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,15), 'color', 'r','linewidth',2)
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,16), 'color', 'b','linewidth',2)
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT14','LVDT15' ,'LVDT16', 'location','EastOutside')
title ('Monitoring existing cracks','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Increase in crack width (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 7000 0 max(zijlwegshear01.lvdt(:,15))+0.005])
saveas(gcf,'existingcracks.tif')

f18=figure;
plot(zijlwegshear01.lvdt(1:6350,14), Ftot(1:6350), 'g')
hold on
plot(zijlwegshear01.lvdt(1:6350,15), Ftot(1:6350), 'r')
plot(zijlwegshear01.lvdt(1:6350,16), Ftot(1:6350), 'b')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT14','LVDT15','LVDT16', 'location','EastOutside')
title ('Crack width versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Measured increase in crack width (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(zijlwegshear01.lvdt(:,15))+0.005 0 Fomax+20])
saveas(gcf,'Crackvsload.tif')

%LVDTs over 1m for strain measurements
%these are corrected with the effect of temperature by LVDT4
f19=figure;
plot(zijlwegshear01.time, zijlwegshear01.strain(:,1)*1e6, 'color', 'g','linewidth',2)
hold on
plot(zijlwegshear01.time, zijlwegshear01.strain(:,2)*1e6, 'color', 'r','linewidth',2)
plot(zijlwegshear01.time, zijlwegshear01.strain(:,3)*1e6, 'color', 'b','linewidth',2)
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT1','LVDT2' ,'LVDT3', 'location','EastOutside')
title ('Strain measurements','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Microstrain','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 7000 min(zijlwegshear01.strain(:,3))*1e6-10 1e6*max(zijlwegshear01.strain(:,2))+10])
saveas(gcf,'strain.tif')

f20=figure;
plot(zijlwegshear01.strain(:,1)*1e6, Ftot, 'g')
hold on
plot(zijlwegshear01.strain(:,2)*1e6, Ftot, 'r')
plot(zijlwegshear01.strain(:,3)*1e6, Ftot, 'b')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT1','LVDT2' ,'LVDT3', 'location','EastOutside')
title ('Strain versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Microstrain','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(zijlwegshear01.strain(:,2))*1e6 0 Fomax+20])
saveas(gcf,'Strainvsload.tif')
saveas(gcf,'Strainvsload.pdf')

%movement in the joint
f21=figure;
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,9), 'color', 'b','linewidth',2)
hold on
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,10), 'color', 'r','linewidth',2)
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,11), 'b:','linewidth',2)
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,12), 'r:','linewidth',2)
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT9','LVDT10' ,'LVDT11', 'LVDT12', 'location','EastOutside')
title ('Movement in the joint','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Displacement (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(zijlwegshear01.time) min(zijlwegshear01.lvdt(:,12)) 0])
saveas(gcf,'joint.tif')

f22=figure;
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,9), 'color', 'b','linewidth',2)
hold on
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,10), 'color', 'r','linewidth',2)
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,11), 'b:','linewidth',2)
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,12), 'r:','linewidth',2)
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT9','LVDT10' ,'LVDT11', 'LVDT12', 'location','EastOutside')
title ('Movement in the joint','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Displacement (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 7000 min(zijlwegshear01.lvdt(:,12)) 0])
saveas(gcf,'jointtest.tif')

f23=figure;
plot(-zijlwegshear01.lvdt(1:6350,9), Ftot(1:6350), 'b')
hold on
plot(-zijlwegshear01.lvdt(1:6350,10), Ftot(1:6350), 'r')
plot(-zijlwegshear01.lvdt(1:6350,11), Ftot(1:6350), 'b:')
plot(-zijlwegshear01.lvdt(1:6350,12), Ftot(1:6350), 'r:')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT9','LVDT10','LVDT11','LVDT12', 'location','EastOutside')
title ('Movement in joint versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Measured displacement (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(-zijlwegshear01.lvdt(:,12))+0.1 0 Fomax+50])
saveas(gcf,'Jointvsload.tif')

f24=figure;
subplot(2,2,1);
plot(-zijlwegshear01.lvdt(1:6350,9), Ftot(1:6350), 'b');
title ('LVDT9','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 2 0 Fomax+50])
subplot(2,2,2);
plot(-zijlwegshear01.lvdt(1:6350,10), Ftot(1:6350), 'b');
title ('LVDT10','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 2 0 Fomax+50])
subplot(2,2,3);
plot(-zijlwegshear01.lvdt(1:6350,11), Ftot(1:6350), 'b');
title ('LVDT11','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 2 0 Fomax+50])
subplot(2,2,4);
plot(-zijlwegshear01.lvdt(1:6350,12), Ftot(1:6350), 'b');
title ('LVDT12','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 2 0 Fomax+50])
saveas(gcf,'Subplotsjointvsload.tif')

%temperature effect
f25=figure;
plot(zijlwegshear01.time, zijlwegshear01.lvdt(:,4)*1000, 'color', 'b', 'linewidth', 2)
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT4','location','EastOutside')
title ('Strain due to temperature','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Microstrain','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'LVDT4.tif')

%total loading scheme
f26=figure;
plot(zijlwegshear01.time,Ftot,'color', 'b','linewidth', 2)
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F(kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Measured Loading Graph','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(zijlwegshear01.time) 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'loading graph full.tif')

%isolate three loops of load-displacement diagram
% first 40 ton, first 110 ton and last loading step
f27=figure;
plot(so(1:360),Ftot(1:360),'color', 'b','linewidth', 2)
hold on
plot(so(2613:2973),Ftot(2613:2973),'color', 'b','linewidth', 2)
plot(so(5253:6500),Ftot(5253:6500),'color', 'b','linewidth', 2)
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Measured Force-Displacement','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 somax+0.2 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'three loops.tif')

EI1 = max(Ftot(1:360))/max(so(1:360))
EIend =(max(Ftot(5253:6250))-min(Ftot(5253:6250)))/(max(so(5253:6250))-min(so(5253:6250)))

% second 40 ton, first 110 ton and last loading step
f28=figure;
plot(so(1:60),Ftot(1:60),'color', 'b','linewidth', 2)
hold on
plot(so(420:720),Ftot(420:720),'color', 'b','linewidth', 2)
plot(so(2613:2973),Ftot(2613:2973),'color', 'b','linewidth', 2)
plot(so(5253:6500),Ftot(5253:6500),'color', 'b','linewidth', 2)
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Measured Force-Displacement','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 somax+0.2 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'three loops two.tif')

%draw envelope of load-displacement curve
envelope = [0 so(val1) so(val2) so(val3) so(val4) so(val5) so(7000)];
F_envelope = [0 Ftot(val1) Ftot(val2) Ftot(val3) Ftot(val4) Ftot(val5) Ftot(7000)];
f29=figure
plot(envelope,F_envelope,'color','b','linewidth', 2)
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Envelope of the measured Force-Displacement','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 somax+0.2 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'envelope.tif')

%plot four loads separately
f30=figure;
plot(zijlwegshear01.time,zijlwegshear01.p(:,1),'color', 'b','linewidth',2)
hold on
plot(zijlwegshear01.time,zijlwegshear01.p(:,2),'color', 'g','linewidth',2)
plot(zijlwegshear01.time,zijlwegshear01.p(:,3),'color', 'r','linewidth',2)
plot(zijlwegshear01.time,zijlwegshear01.p(:,4),'k:')
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Load on each jack','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 7000 0 370])
legend('FS1','FS2','FS3','FS4', 'location','EastOutside')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'jacks.tif')

%crack width as function of load
crackwidth14 = [0 zijlwegshear01.lvdt(val1,14) zijlwegshear01.lvdt(val2,14) zijlwegshear01.lvdt(val3,14) zijlwegshear01.lvdt(val4,14) zijlwegshear01.lvdt(val5,14)];
crackwidth15 = [0 zijlwegshear01.lvdt(val1,15) zijlwegshear01.lvdt(val2,15) zijlwegshear01.lvdt(val3,15) zijlwegshear01.lvdt(val4,15) zijlwegshear01.lvdt(val5,15)];
crackwidth16 = [0 zijlwegshear01.lvdt(val1,16) zijlwegshear01.lvdt(val2,16) zijlwegshear01.lvdt(val3,16) zijlwegshear01.lvdt(val4,16) zijlwegshear01.lvdt(val5,16)];
loads = [0 Ftot(val1) Ftot(val2) Ftot(val3) Ftot(val4) Ftot(val5)];
f31=figure
plot(loads,crackwidth14,'g-o','linewidth',2)
hold on
plot(loads,crackwidth15,'b-o','linewidth',2)
plot(loads,crackwidth16,'r-o','linewidth',2)
hold off
xlabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Increase in crack width (mm)','FontWeight','bold','Fontname', 'Times New Roman')
title('Increase in crack width with load','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 Fomax+10 0 max(crackwidth15)+0.001])
legend('LVDT14','LVDT15','LVDT16','location','EastOutside')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'crack width linear.tif')
saveas(gcf,'crack width linear.eps')
saveas(gcf,'crack width linear.pdf')

%draw entire envelope of load-displacement curve
f32=figure;
plot(so(1:267),Ftot(1:267),'color','b','linewidth',2)
hold on
plot(so(340:371),Ftot(340:371),'color','b','linewidth',2)
plot(so(467:487),Ftot(467:487),'color','b','linewidth',2)
plot(so(623:832),Ftot(623:832),'color','b','linewidth',2)
plot(so(1139:1231),Ftot(1139:1231),'color','b','linewidth',2)
plot(so(1413:1518),Ftot(1413:1518),'color','b','linewidth',2)
plot(so(1912:2638),Ftot(1912:2638),'color','b','linewidth',2)
plot(so(2905:3102),Ftot(2905:3102),'color','b','linewidth',2)
plot(so(3356:3543),Ftot(3356:3543),'color','b','linewidth',2)
plot(so(3940:4137),Ftot(3940:4137),'color','b','linewidth',2)
plot(so(4398:4589),Ftot(4398:4589),'color','b','linewidth',2)
plot(so(4854:5062),Ftot(4854:5062),'color','b','linewidth',2)
plot(so(5318:5547),Ftot(5318:5547),'color','b','linewidth',2)
hold off
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Envelope of the measured Force-Displacement','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 somax+0.2 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'envelope total.tif')

%draw entire envelope of load-displacement curve
f33=figure;
plot(so(1:296),Ftot(1:296),'color','b','linewidth',2)
hold on
plot(so(516:704),Ftot(516:704),'color','b','linewidth',2)
plot(so(924:1122),Ftot(924:1122),'color','b','linewidth',2)
plot(so(1386:1604),Ftot(1386:1604),'color','b','linewidth',2)
plot(so(1829:2025),Ftot(1829:2025),'color','b','linewidth',2)
plot(so(2251:2441),Ftot(2251:2441),'color','b','linewidth',2)
plot(so(2680:2903),Ftot(2680:2903),'color','b','linewidth',2)
plot(so(3139:3330),Ftot(3139:3330),'color','b','linewidth',2)
plot(so(3555:3753),Ftot(3555:3753),'color','b','linewidth',2)
plot(so(4011:4212),Ftot(4011:4212),'color','b','linewidth',2)
plot(so(4459:4653),Ftot(4459:4653),'color','b','linewidth',2)
plot(so(4885:5086),Ftot(4885:5086),'color','b','linewidth',2)
plot(so(5342:6250),Ftot(5342:6250),'color','b','linewidth',2)
hold off
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Envelope of the measured Force-Displacement','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 somax+0.2 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'envelope total.tif')
saveas(gcf,'envelope total.eps')

%draw shear and bending in one graph
sob = -zijlwegbending04.disp(:,2);
FS1_corr = zijlwegbending04.p(:,1)*1.017341;
FS2_corr = zijlwegbending04.p(:,2)*0.982360;
FS3_corr = zijlwegbending04.p(:,3)*0.985239;
FS4_corr = zijlwegbending04.p(:,4)*0.973719;
Ftotb = abs(FS1_corr + FS2_corr + FS3_corr + FS4_corr);

f34=figure;
plot(sob(1:267),Ftotb(1:267),'color','b','linewidth',2)
hold on
plot(so(1:296),Ftot(1:296),'color','r','linewidth',2)
plot(sob(340:832),Ftotb(340:832),'color','b','linewidth',2)
plot(sob(1130:1231),Ftotb(1130:1231),'color','b','linewidth',2)
plot(sob(1413:1518),Ftotb(1413:1518),'color','b','linewidth',2)
plot(sob(1912:2638),Ftotb(1912:2638),'color','b','linewidth',2)
plot(sob(2905:3102),Ftotb(2905:3102),'color','b','linewidth',2)
plot(sob(3356:3543),Ftotb(3356:3543),'color','b','linewidth',2)
plot(sob(3940:4137),Ftotb(3940:4137),'color','b','linewidth',2)
plot(sob(4398:4589),Ftotb(4398:4589),'color','b','linewidth',2)
plot(sob(4854:5062),Ftotb(4854:5062),'color','b','linewidth',2)
plot(sob(5318:5547),Ftotb(5318:5547),'color','b','linewidth',2)
plot(so(516:704),Ftot(516:704),'color','r','linewidth',2)
plot(so(924:1122),Ftot(924:1122),'color','r','linewidth',2)
plot(so(1386:1604),Ftot(1386:1604),'color','r','linewidth',2)
plot(so(1829:2025),Ftot(1829:2025),'color','r','linewidth',2)
plot(so(2251:2441),Ftot(2251:2441),'color','r','linewidth',2)
plot(so(2680:2903),Ftot(2680:2903),'color','r','linewidth',2)
plot(so(3139:3330),Ftot(3139:3330),'color','r','linewidth',2)
plot(so(3555:3753),Ftot(3555:3753),'color','r','linewidth',2)
plot(so(4011:4212),Ftot(4011:4212),'color','r','linewidth',2)
plot(so(4459:4653),Ftot(4459:4653),'color','r','linewidth',2)
plot(so(4885:5086),Ftot(4885:5086),'color','r','linewidth',2)
plot(so(5342:6250),Ftot(5342:6250),'color','r','linewidth',2)
hold off
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Envelope of the measured Force-Displacement','FontWeight','bold','Fontname', 'Times New Roman')
legend('Bending','Shear','location','EastOutside')
axis([0 3.5 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'shear vs bending.tif')
saveas(gcf,'shear vs bending.eps')
saveas(gcf,'shear vs bending.pdf')

f35=figure
plot(sob(1:267),Ftotb(1:267),'color','b','linewidth',2)
hold on
plot(so(1:296),Ftot(1:296),'color','r','linewidth',2)
plot(sob(340:832),Ftotb(340:832),'color','b','linewidth',2)
plot(sob(1130:1231),Ftotb(1130:1231),'color','b','linewidth',2)
plot(sob(1413:1518),Ftotb(1413:1518),'color','b','linewidth',2)
plot(sob(1912:2638),Ftotb(1912:2638),'color','b','linewidth',2)
plot(sob(2905:3102),Ftotb(2905:3102),'color','b','linewidth',2)
plot(sob(3356:3543),Ftotb(3356:3543),'color','b','linewidth',2)
plot(sob(3940:4137),Ftotb(3940:4137),'color','b','linewidth',2)
plot(sob(4398:4589),Ftotb(4398:4589),'color','b','linewidth',2)
plot(sob(4854:5062),Ftotb(4854:5062),'color','b','linewidth',2)
plot(sob(5318:5547),Ftotb(5318:5547),'color','b','linewidth',2)
plot(so(516:704),Ftot(516:704),'color','r','linewidth',2)
plot(so(924:1122),Ftot(924:1122),'color','r','linewidth',2)
plot(so(1386:1604),Ftot(1386:1604),'color','r','linewidth',2)
plot(so(1829:2025),Ftot(1829:2025),'color','r','linewidth',2)
plot(so(2251:2441),Ftot(2251:2441),'color','r','linewidth',2)
plot(so(2680:2903),Ftot(2680:2903),'color','r','linewidth',2)
plot(so(3139:3330),Ftot(3139:3330),'color','r','linewidth',2)
plot(so(3555:3753),Ftot(3555:3753),'color','r','linewidth',2)
plot(so(4011:4212),Ftot(4011:4212),'color','r','linewidth',2)
plot(so(4459:4653),Ftot(4459:4653),'color','r','linewidth',2)
plot(so(4885:5086),Ftot(4885:5086),'color','r','linewidth',2)
plot(so(5342:6250),Ftot(5342:6250),'color','r','linewidth',2)
hold off
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Envelope of the measured Force-Displacement','FontWeight','bold','Fontname', 'Times New Roman')
legend('Bending','Shear','location','EastOutside')
axis([1.5 3.5 800 1400])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'shear vs bending zoom.tif')
saveas(gcf,'shear vs bending zoom.eps')

% ===================================================
% DISPLAY CRACK WIDTH VALUES AT EACH LOAD STEP
% ===================================================

fprintf('\n');
fprintf('==============================================================\n');
fprintf('CRACK WIDTH MEASUREMENTS AT 5 LOAD STEPS (SHEAR TEST)\n');
fprintf('==============================================================\n\n');

% Load Step 1
fprintf('LOAD STEP 1:\n');
fprintf('  Load: %.2f kN\n', Ftot(val1));
fprintf('  LVDT14 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val1,14));
fprintf('  LVDT15 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val1,15));
fprintf('  LVDT16 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val1,16));
fprintf('  Maximum crack width: %.6f mm\n\n', max([zijlwegshear01.lvdt(val1,14), zijlwegshear01.lvdt(val1,15), zijlwegshear01.lvdt(val1,16)]));

% Load Step 2
fprintf('LOAD STEP 2:\n');
fprintf('  Load: %.2f kN\n', Ftot(val2));
fprintf('  LVDT14 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val2,14));
fprintf('  LVDT15 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val2,15));
fprintf('  LVDT16 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val2,16));
fprintf('  Maximum crack width: %.6f mm\n\n', max([zijlwegshear01.lvdt(val2,14), zijlwegshear01.lvdt(val2,15), zijlwegshear01.lvdt(val2,16)]));

% Load Step 3
fprintf('LOAD STEP 3:\n');
fprintf('  Load: %.2f kN\n', Ftot(val3));
fprintf('  LVDT14 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val3,14));
fprintf('  LVDT15 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val3,15));
fprintf('  LVDT16 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val3,16));
fprintf('  Maximum crack width: %.6f mm\n\n', max([zijlwegshear01.lvdt(val3,14), zijlwegshear01.lvdt(val3,15), zijlwegshear01.lvdt(val3,16)]));

% Load Step 4
fprintf('LOAD STEP 4:\n');
fprintf('  Load: %.2f kN\n', Ftot(val4));
fprintf('  LVDT14 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val4,14));
fprintf('  LVDT15 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val4,15));
fprintf('  LVDT16 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val4,16));
fprintf('  Maximum crack width: %.6f mm\n\n', max([zijlwegshear01.lvdt(val4,14), zijlwegshear01.lvdt(val4,15), zijlwegshear01.lvdt(val4,16)]));

% Load Step 5
fprintf('LOAD STEP 5:\n');
fprintf('  Load: %.2f kN\n', Ftot(val5));
fprintf('  LVDT14 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val5,14));
fprintf('  LVDT15 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val5,15));
fprintf('  LVDT16 (crack width): %.6f mm\n', zijlwegshear01.lvdt(val5,16));
fprintf('  Maximum crack width: %.6f mm\n\n', max([zijlwegshear01.lvdt(val5,14), zijlwegshear01.lvdt(val5,15), zijlwegshear01.lvdt(val5,16)]));

% Summary table
fprintf('====================================================================================\n');
fprintf('SUMMARY TABLE FOR CHAPTER 4 - CRACK WIDTH MEASUREMENTS\n');
fprintf('====================================================================================\n');
fprintf('| Load Step | Load (kN) | LVDT14 (mm) | LVDT15 (mm) | LVDT16 (mm) | Max (mm) |\n');
fprintf('|-----------|-----------|--------------|--------------|--------------|----------|\n');
fprintf('|     1     |  %7.2f  |   %8.6f   |   %8.6f   |   %8.6f   | %8.6f |\n', ...
    Ftot(val1), zijlwegshear01.lvdt(val1,14), zijlwegshear01.lvdt(val1,15), ...
    zijlwegshear01.lvdt(val1,16), max([zijlwegshear01.lvdt(val1,14), zijlwegshear01.lvdt(val1,15), zijlwegshear01.lvdt(val1,16)]));
fprintf('|     2     |  %7.2f  |   %8.6f   |   %8.6f   |   %8.6f   | %8.6f |\n', ...
    Ftot(val2), zijlwegshear01.lvdt(val2,14), zijlwegshear01.lvdt(val2,15), ...
    zijlwegshear01.lvdt(val2,16), max([zijlwegshear01.lvdt(val2,14), zijlwegshear01.lvdt(val2,15), zijlwegshear01.lvdt(val2,16)]));
fprintf('|     3     |  %7.2f  |   %8.6f   |   %8.6f   |   %8.6f   | %8.6f |\n', ...
    Ftot(val3), zijlwegshear01.lvdt(val3,14), zijlwegshear01.lvdt(val3,15), ...
    zijlwegshear01.lvdt(val3,16), max([zijlwegshear01.lvdt(val3,14), zijlwegshear01.lvdt(val3,15), zijlwegshear01.lvdt(val3,16)]));
fprintf('|     4     |  %7.2f  |   %8.6f   |   %8.6f   |   %8.6f   | %8.6f |\n', ...
    Ftot(val4), zijlwegshear01.lvdt(val4,14), zijlwegshear01.lvdt(val4,15), ...
    zijlwegshear01.lvdt(val4,16), max([zijlwegshear01.lvdt(val4,14), zijlwegshear01.lvdt(val4,15), zijlwegshear01.lvdt(val4,16)]));
fprintf('|     5     |  %7.2f  |   %8.6f   |   %8.6f   |   %8.6f   | %8.6f |\n', ...
    Ftot(val5), zijlwegshear01.lvdt(val5,14), zijlwegshear01.lvdt(val5,15), ...
    zijlwegshear01.lvdt(val5,16), max([zijlwegshear01.lvdt(val5,14), zijlwegshear01.lvdt(val5,15), zijlwegshear01.lvdt(val5,16)]));
fprintf('====================================================================================\n\n');

% Also display the values that are already calculated in the script
fprintf('Crack width arrays already calculated in script:\n');
fprintf('crackwidth14 = [%.6f, %.6f, %.6f, %.6f, %.6f, %.6f]\n', ...
    0, zijlwegshear01.lvdt(val1,14), zijlwegshear01.lvdt(val2,14), ...
    zijlwegshear01.lvdt(val3,14), zijlwegshear01.lvdt(val4,14), zijlwegshear01.lvdt(val5,14));
fprintf('crackwidth15 = [%.6f, %.6f, %.6f, %.6f, %.6f, %.6f]\n', ...
    0, zijlwegshear01.lvdt(val1,15), zijlwegshear01.lvdt(val2,15), ...
    zijlwegshear01.lvdt(val3,15), zijlwegshear01.lvdt(val4,15), zijlwegshear01.lvdt(val5,15));
fprintf('crackwidth16 = [%.6f, %.6f, %.6f, %.6f, %.6f, %.6f]\n', ...
    0, zijlwegshear01.lvdt(val1,16), zijlwegshear01.lvdt(val2,16), ...
    zijlwegshear01.lvdt(val3,16), zijlwegshear01.lvdt(val4,16), zijlwegshear01.lvdt(val5,16));