clear all
close all
clc
% this M-file reads the data of the tests and makes the graphs
% units: kN, mm

%Reading data from Excel sheet with measurements
load data_22_06_2015_yyg.mat

%correcting load cells for bending04
FS1_corr = zijlwegbending04.p(:,1)*1.017341;
FS2_corr = zijlwegbending04.p(:,2)*0.982360;
FS3_corr = zijlwegbending04.p(:,3)*0.985239;
FS4_corr = zijlwegbending04.p(:,4)*0.973719;
length = length(FS1_corr);

%correcting lasers 1 and 2
corr1 = (zijlwegbending04.lvdt(:,13)-zijlwegbending04.laser(:,3))/(2427-1425)*(878-1425)+zijlwegbending04.laser(:,3);
corr2 = (zijlwegbending04.laser(:,4)-zijlwegbending04.lvdt(:,13))/(4459-2427)*(3955-2427)+zijlwegbending04.lvdt(:,13);
laser01_corr = zijlwegbending04.laser(:,1)-corr1;
laser02_corr = zijlwegbending04.laser(:,2)-corr2;

%measured loading graph
Ftot = abs(FS1_corr + FS2_corr + FS3_corr + FS4_corr);
Fomax = max(Ftot)
f1=figure;
tmax = max(zijlwegbending04.time);
plot(zijlwegbending04.time,Ftot,'color', 'b','linewidth', 2)
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman');
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman');
title('Measured Loading Graph','FontWeight','bold','Fontname', 'Times New Roman');
axis([0 tmax+10 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'loading graph.tif')
saveas(gcf,'loading graph.eps')

tminutes = zijlwegbending04.time/60;
tminutesmax = max(tminutes);
plot(tminutes,Ftot,'color', 'b','linewidth', 2)
xlabel('Time (min)','FontWeight','bold','Fontname', 'Times New Roman');
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman');
title('Measured Loading Graph','FontWeight','bold','Fontname', 'Times New Roman');
axis([0 tminutesmax+2 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'loading graph minutes.tif')
saveas(gcf,'loading graph minutes.eps')

%measured force-displacement graph based on LVDT6
so = -zijlwegbending04.disp(:,2);
somax = max(so);
f2=figure;
plot(so,Ftot,'color', 'b','linewidth',1.3)
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
    if Ftot(i) >= 845 && Ftot(i)<=848;
        val2 = i;
        break
    end
end
for i=1:length
    if Ftot(i) >= 1089 && Ftot(i)<=1091;
        val3 = i;
        break
    end
end
for i=1:length
    if Ftot(i) >= 1200 && Ftot(i)<=1207;
        val4 = i;
        break
    end
end
for i=1:length
     if Ftot(i) == Fomax;
        val5 = i;
    end
end

location = [0 2010 1908+2010 1924+1908+2010 1920+1924+1908+2010 9605]; %taken from support 5, north side

defl1 = [0 zijlwegbending04.disp(val1,1) zijlwegbending04.disp(val1,2) zijlwegbending04.disp(val1,3) zijlwegbending04.disp(val1,4) 0];
defl2 = [0 zijlwegbending04.disp(val2,1) zijlwegbending04.disp(val2,2) zijlwegbending04.disp(val2,3) zijlwegbending04.disp(val2,4) 0];
defl3 = [0 zijlwegbending04.disp(val3,1) zijlwegbending04.disp(val3,2) zijlwegbending04.disp(val3,3) zijlwegbending04.disp(val3,4) 0];
defl4 = [0 zijlwegbending04.disp(val4,1) zijlwegbending04.disp(val4,2) zijlwegbending04.disp(val4,3) zijlwegbending04.disp(val4,4) 0];
defl5 = [0 zijlwegbending04.disp(val5,1) zijlwegbending04.disp(val5,2) zijlwegbending04.disp(val5,3) zijlwegbending04.disp(val5,4) 0];

f3=figure;
plot(location, -defl1, 'k-o','linewidth', 2)
hold on
plot(location, -defl2, 'r-o','linewidth', 2)
plot(location, -defl3, 'b-o','linewidth', 2)
plot(location, -defl4, 'g-o','linewidth', 2)
plot(location, -defl5, 'color', [0.65,0.65,0.65],'marker', 'o','linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('40 ton','81 ton' ,'110 ton','120 ton','137 ton', 'location','EastOutside')
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
plot(location, -defl5, 'color', [0.65,0.65,0.65],'marker', 'o','linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('400 kN','810 kN' ,'1100 kN','1200 kN','1370 kN', 'location','EastOutside')
title ('Longitudinal deflection profiles','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from Sup 5 (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'LongitudinaldeflectionplotkN.pdf')

f3=figure;
plot(location, -defl1, 'k-o','linewidth', 2)
hold on
plot(location, -defl2, 'k-o','linewidth', 1)
plot(location, -defl3, 'color', [0.35,0.35,0.35],'marker', 'o','linewidth', 2)
plot(location, -defl4, 'color', [0.65,0.65,0.65],'marker', 'o','linewidth', 1)
plot(location, -defl5, 'color', [0.65,0.65,0.65],'marker', 'o','linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('40 ton','81 ton' ,'110 ton','120 ton','137 ton', 'location','EastOutside')
title ('Longitudinal deflection profiles','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from Sup 5 (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'Longitudinaldeflectionplotbw.eps')

f4=figure;
plot(-zijlwegbending04.disp(:,1), Ftot, 'k')
hold on
plot(-zijlwegbending04.disp(:,2), Ftot, 'r')
plot(-zijlwegbending04.disp(:,3), Ftot, 'b')
plot(-zijlwegbending04.disp(:,4), Ftot, 'g')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT5','LVDT6','LVDT7','LVDT8', 'location','EastOutside')
title ('Measurements in longitudinal direction versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(-zijlwegbending04.disp(:,2))+0.15 0 Fomax+20])
saveas(gcf,'Longitudinalvsload.tif')


f5=figure;
plot(zijlwegbending04.time, zijlwegbending04.disp(:,1),'k','linewidth', 2)
hold on
plot(zijlwegbending04.time, zijlwegbending04.disp(:,2),'r','linewidth', 2)
plot(zijlwegbending04.time, zijlwegbending04.disp(:,3),'b','linewidth', 2)
plot(zijlwegbending04.time, zijlwegbending04.disp(:,4),'g','linewidth', 2)
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT5','LVDT6','LVDT7','LVDT8', 'location','EastOutside')
title ('Measurements in longitudinal direction versus time','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(zijlwegbending04.time) min(zijlwegbending04.disp(:,2)) 0])
saveas(gcf,'Longitudinalvstime.tif')

f6=figure;
subplot(2,2,1);
plot(-zijlwegbending04.disp(:,1), Ftot, 'b');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
title ('LVDT5','FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3.5 0 Fomax+20])
subplot(2,2,2);
plot(-zijlwegbending04.disp(:,2), Ftot, 'b');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
title ('LVDT6','FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3.5 0 Fomax+20])
subplot(2,2,3);
plot(-zijlwegbending04.disp(:,3), Ftot, 'b');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3.5 0 Fomax+20])
title ('LVDT7','FontWeight','bold','Fontname', 'Times New Roman');
subplot(2,2,4);
plot(-zijlwegbending04.disp(:,4), Ftot, 'b');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
title ('LVDT8','FontWeight','bold','Fontname', 'Times New Roman');
title ('LVDT8');
axis([0 3.5 0 Fomax+20])
saveas(gcf,'Subplotslongvsload.tif')

%transverse plot of deck
widthloc = [5006 3457 1929]; %taken from west side

trans1 = [laser01_corr(val1) zijlwegbending04.disp(val1,2) laser02_corr(val1)];
trans2 = [laser01_corr(val2) zijlwegbending04.disp(val2,2) laser02_corr(val2)];
trans3 = [laser01_corr(val3) zijlwegbending04.disp(val3,2) laser02_corr(val3)];
trans4 = [laser01_corr(val4) zijlwegbending04.disp(val4,2) laser02_corr(val4)];
trans5 = [laser01_corr(val5) zijlwegbending04.disp(val5,2) laser02_corr(val5)];

f7=figure;
plot(widthloc, -trans1, 'k-o','linewidth',2)
hold on
plot(widthloc, -trans2, 'r-o','linewidth',2)
plot(widthloc, -trans3, 'b-o','linewidth',2)
plot(widthloc, -trans4, 'g-o','linewidth',2)
plot(widthloc, -trans5, 'color', [0.65,0.65,0.65],'marker', 'o','linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on','linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman')
legend('40 ton','81 ton' ,'110 ton','120 ton','137 ton', 'location','EastOutside')
title ('Transverse deflection profiles','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from west side (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 5884 0 max(-zijlwegbending04.disp(:,2))+0.2])
saveas(gcf,'Transversedeflectionplot.tif')

f7=figure;
plot(widthloc, -trans1, 'k-o','linewidth',2)
hold on
plot(widthloc, -trans2, 'r-o','linewidth',2)
plot(widthloc, -trans3, 'b-o','linewidth',2)
plot(widthloc, -trans4, 'g-o','linewidth',2)
plot(widthloc, -trans5, 'color', [0.65,0.65,0.65],'marker', 'o','linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on','linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman')
legend('400 kN','810 kN' ,'1100 kN','1200 kN','1370 kN', 'location','EastOutside')
title ('Transverse deflection profiles','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from west side (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 5884 0 max(-zijlwegbending04.disp(:,2))+0.2])
saveas(gcf,'Transversedeflectionplot.pdf')

f8=figure;
plot(-laser01_corr, Ftot, 'b')
hold on
plot(-zijlwegbending04.disp(:,2), Ftot, 'r')
plot(-laser02_corr, Ftot, 'g')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('laser1','LVDT6','laser2', 'location','EastOutside')
title ('Measurements in transverse direction versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(-zijlwegbending04.disp(:,2))+0.15 0 Fomax+20])
saveas(gcf,'Transversevsload.tif')

f9=figure;
plot(zijlwegbending04.time, laser01_corr,'b')
hold on
plot(zijlwegbending04.time, zijlwegbending04.disp(:,2),'r')
plot(zijlwegbending04.time, laser02_corr, 'g')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('laser1','LVDT6','laser2', 'location','EastOutside')
title ('Measurements in transverse direction versus time','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'Transversevstime.tif')

f10=figure;
subplot(1,3,1);
plot(-laser01_corr, Ftot, 'b');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title ('Laser1','FontWeight','bold','Fontname', 'Times New Roman');
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 4 0 Fomax+20])
subplot(1,3,2);
plot(-zijlwegbending04.disp(:,2), Ftot, 'b');
title ('LVDT6','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 4 0 Fomax+20])
subplot(1,3,3);
plot(-laser02_corr, Ftot, 'b');
title ('Laser2','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 4 0 Fomax+20])
saveas(gcf,'Subplotstransvsload.tif')

%deformations of cross beams
%deformation at support 5
widthpos5 = [4459 3457 1425]; %taken from west side

pos51 = [zijlwegbending04.laser(val1,3) zijlwegbending04.lvdt(val1,13) zijlwegbending04.laser(val1,4)];
pos52 = [zijlwegbending04.laser(val2,3) zijlwegbending04.lvdt(val2,13) zijlwegbending04.laser(val2,4)];
pos53 = [zijlwegbending04.laser(val3,3) zijlwegbending04.lvdt(val3,13) zijlwegbending04.laser(val3,4)];
pos54 = [zijlwegbending04.laser(val4,3) zijlwegbending04.lvdt(val4,13) zijlwegbending04.laser(val4,4)];
pos55 = [zijlwegbending04.laser(val5,3) zijlwegbending04.lvdt(val5,13) zijlwegbending04.laser(val5,4)];

f11=figure;
plot(widthpos5, -pos51, 'k-o','linewidth', 2)
hold on
plot(widthpos5, -pos52, 'r-o','linewidth', 2)
plot(widthpos5, -pos53, 'b-o','linewidth', 2)
plot(widthpos5, -pos54, 'g-o','linewidth', 2)
plot(widthpos5, -pos55, 'color', [0.65,0.65,0.65],'marker', 'o','linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on')
legend('40 ton','83 ton' ,'111 ton','120 ton','134 ton', 'location','EastOutside')
title ('Deflection at Support 5','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from west side (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 5884 0 max(-zijlwegbending04.laser(:,3))+0.2])
saveas(gcf,'sup5plot.tif')

f12=figure;
plot(-zijlwegbending04.laser(:,3), Ftot, 'b')
hold on
plot(-zijlwegbending04.lvdt(:,13), Ftot, 'r')
plot(-zijlwegbending04.laser(:,4), Ftot, 'g')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('laser3','LVDT13','laser4', 'location','EastOutside')
title ('Deflections at Support 5 versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)', 'FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(-zijlwegbending04.laser(:,3))+0.15 0 Fomax+20])
saveas(gcf,'Sup5vsload.tif')

f13=figure;
plot(zijlwegbending04.time, zijlwegbending04.laser(:,3),'b','linewidth', 2)
hold on
plot(zijlwegbending04.time, zijlwegbending04.lvdt(:,13),'r','linewidth', 2)
plot(zijlwegbending04.time, zijlwegbending04.laser(:,4), 'g','linewidth', 2)
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('laser3','LVDT13','laser4', 'location','EastOutside')
title ('Deflections at Support 5 versus time','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(zijlwegbending04.time) min(zijlwegbending04.laser(:,3)) 0])
saveas(gcf,'Sup5vstime.tif')

%deformation at support 4
widthpos4 = [4409 1375]; %taken from west side

pos41 = [zijlwegbending04.laser(val1,5) zijlwegbending04.laser(val1,6)];
pos42 = [zijlwegbending04.laser(val2,5) zijlwegbending04.laser(val2,6)];
pos43 = [zijlwegbending04.laser(val3,5) zijlwegbending04.laser(val3,6)];
pos44 = [zijlwegbending04.laser(val4,5) zijlwegbending04.laser(val4,6)];
pos45 = [zijlwegbending04.laser(val5,5) zijlwegbending04.laser(val5,6)];

f14=figure;
plot(widthpos4, -pos41, 'k-o','linewidth', 2)
hold on
plot(widthpos4, -pos42, 'r-o','linewidth', 2)
plot(widthpos4, -pos43, 'b-o','linewidth', 2)
plot(widthpos4, -pos44, 'g-o','linewidth', 2)
plot(widthpos4, -pos45, 'color', [0.65,0.65,0.65],'marker', 'o','linewidth', 2)
hold off
axis ij
set(gca,'YGrid','on','linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman')
legend('40 ton','83 ton' ,'111 ton','120 ton','134 ton', 'location','EastOutside')
title ('Deflection at Support 4','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Location from west side (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 5784 -0.4 0.4])
saveas(gcf,'sup4plot.tif')

f15=figure;
plot(-zijlwegbending04.laser(:,5), Ftot, 'b')
hold on
plot(-zijlwegbending04.laser(:,6), Ftot, 'r')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('laser5','laser6', 'location','EastOutside')
title ('Deflections at Support 4 versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'Sup4vsload.tif')

f16=figure;
plot(zijlwegbending04.time, zijlwegbending04.laser(:,5),'b')
hold on
plot(zijlwegbending04.time, zijlwegbending04.laser(:,6), 'r')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('laser5','laser6', 'location','EastOutside')
title ('Deflections at Support 4 versus time','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'Sup4vstime.tif')

%monitoring of cracks with LVDTs 14, 15 and 16
f17=figure;
plot(zijlwegbending04.time, zijlwegbending04.lvdt(:,14), 'color', 'g','linewidth', 2)
hold on
plot(zijlwegbending04.time, zijlwegbending04.lvdt(:,15), 'color', 'r','linewidth', 2)
plot(zijlwegbending04.time, zijlwegbending04.lvdt(:,16), 'color', 'b','linewidth', 2)
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT14','LVDT15' ,'LVDT16', 'location','EastOutside')
title ('Monitoring existing cracks','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Increase in crack width (mm)','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'existingcracks.tif')

f18=figure;
plot(zijlwegbending04.lvdt(:,14), Ftot, 'g')
hold on
plot(zijlwegbending04.lvdt(:,15), Ftot, 'r')
plot(zijlwegbending04.lvdt(:,16), Ftot, 'b')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT14','LVDT15','LVDT16', 'location','EastOutside')
title ('Crack width versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Measured increase in crack width (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
axis([-0.005 max(zijlwegbending04.lvdt(:,16))+0.005 0 Fomax+20])
saveas(gcf,'Crackvsload.tif')

%LVDTs over 1m for strain measurements
%these are corrected with the effect of temperature by LVDT4
f19=figure;
plot(zijlwegbending04.time, zijlwegbending04.strain(:,1)*1e6, 'color', 'g','linewidth', 2)
hold on
plot(zijlwegbending04.time, zijlwegbending04.strain(:,2)*1e6, 'color', 'r','linewidth', 2)
plot(zijlwegbending04.time, zijlwegbending04.strain(:,3)*1e6, 'color', 'b','linewidth', 2)
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT1','LVDT2' ,'LVDT3', 'location','EastOutside')
title ('Strain measurements','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Microstrain','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(zijlwegbending04.time) 0 1e6*max(zijlwegbending04.strain(:,2))])
saveas(gcf,'strain.tif')

f20=figure;
plot(zijlwegbending04.strain(:,1)*1e6, Ftot, 'g')
hold on
plot(zijlwegbending04.strain(:,2)*1e6, Ftot, 'r')
plot(zijlwegbending04.strain(:,3)*1e6, Ftot, 'b')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT1','LVDT2' ,'LVDT3', 'location','EastOutside')
title ('Strain versus load','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Microstrain','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(zijlwegbending04.strain(:,2))*1e6 0 Fomax+20])
saveas(gcf,'Strainvsload.tif')
saveas(gcf,'Strainvsload.pdf')

%movement in the joint
f21=figure;
plot(zijlwegbending04.time, zijlwegbending04.lvdt(:,9), 'color', 'b','linewidth', 2)
hold on
plot(zijlwegbending04.time, zijlwegbending04.lvdt(:,10), 'color', 'r','linewidth', 2)
plot(zijlwegbending04.time, zijlwegbending04.lvdt(:,11), 'b:','linewidth', 2)
plot(zijlwegbending04.time, zijlwegbending04.lvdt(:,12), 'r:','linewidth', 2)
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT9','LVDT10' ,'LVDT11', 'LVDT12', 'location','EastOutside')
title ('Movement in the joint','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Displacement (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(zijlwegbending04.time) min(zijlwegbending04.lvdt(:,12)) 0])
saveas(gcf,'joint.tif')

f22=figure;
plot(-zijlwegbending04.lvdt(:,9), Ftot, 'b')
hold on
plot(-zijlwegbending04.lvdt(:,10), Ftot, 'r')
plot(-zijlwegbending04.lvdt(:,11), Ftot, 'b:')
plot(-zijlwegbending04.lvdt(:,12), Ftot, 'r:')
hold off
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT9','LVDT10' ,'LVDT11', 'LVDT12', 'location','EastOutside')
title ('Movement in the joint','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Displacement (mm)','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 max(-zijlwegbending04.lvdt(:,12))+0.1 0 Fomax+50])
saveas(gcf,'Jointvsload.tif')

f23=figure;
subplot(2,2,1);
plot(-zijlwegbending04.lvdt(:,9), Ftot, 'b');
title ('LVDT9','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3 0 Fomax+50])
subplot(2,2,2);
plot(-zijlwegbending04.lvdt(:,10), Ftot, 'b');
title ('LVDT10','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3 0 Fomax+50])
subplot(2,2,3);
plot(-zijlwegbending04.lvdt(:,11), Ftot, 'b');
title ('LVDT11','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3 0 Fomax+50])
subplot(2,2,4);
plot(-zijlwegbending04.lvdt(:,12), Ftot, 'b');
title ('LVDT12','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Load (kN)','FontWeight','bold','Fontname', 'Times New Roman')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
axis([0 3 0 Fomax+50])
saveas(gcf,'Subplotsjointvsload.tif')

%temperature effect
f24=figure;
plot(zijlwegbending04.time, zijlwegbending04.lvdt(:,4)*1000, 'color', 'b','linewidth',2)
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
legend('LVDT4','location','EastOutside')
title ('Strain due to temperature','FontWeight','bold','Fontname', 'Times New Roman');
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Microstrain','FontWeight','bold','Fontname', 'Times New Roman')
saveas(gcf,'LVDT4.tif')

%isolate three loops of load-displacement diagram
% first 40 ton, second 111 ton and last loading step
f25=figure;
plot(so(1:360),Ftot(1:360),'color', 'b','linewidth',2)
hold on
plot(so(2820:3180),Ftot(2820:3180),'color', 'b','linewidth',2)
plot(so(5220:5548),Ftot(5220:5548),'color', 'b','linewidth',2)
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Measured Force-Displacement','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 somax+0.2 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'three loops.tif')
EI1 = max(Ftot(1:360))/max(so(1:360))
EIend =(max(Ftot(5220:5548))-min(Ftot(5520:5548)))/(max(so(5220:5548))-min(so(5220:5548)))

%draw envelope of load-displacement curve
envelope = [0 so(val1) so(val2) so(val3) so(val4) so(val5) so(5548)];
F_envelope = [0 Ftot(val1) Ftot(val2) Ftot(val3) Ftot(val4) Ftot(val5) Ftot(5548)];
f26=figure
plot(envelope,F_envelope,'color','k','linewidth',2)
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Envelope of the measured Force-Displacement','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 somax+0.2 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'envelope.tif')
saveas(gcf,'envelope.eps')

%plot four loads separately
f27=figure;
plot(zijlwegbending04.time,FS1_corr,'color', 'b','linewidth', 1.5)
hold on
plot(zijlwegbending04.time,FS2_corr,'color', 'g','linewidth', 1.5)
plot(zijlwegbending04.time,FS3_corr,'color', 'r','linewidth', 1.5)
plot(zijlwegbending04.time,FS4_corr,'k','linewidth', 1.5)
xlabel('Time (s)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Load on each jack','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 tmax 0 370])
legend('FS1','FS2','FS3','FS4', 'location','EastOutside')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'jacks.tif')

%crack width as function of load
crackwidth14 = [0 zijlwegbending04.lvdt(val1,14) zijlwegbending04.lvdt(val2,14) zijlwegbending04.lvdt(val3,14) zijlwegbending04.lvdt(val4,14) zijlwegbending04.lvdt(val5,14)];
crackwidth15 = [0 zijlwegbending04.lvdt(val1,15) zijlwegbending04.lvdt(val2,15) zijlwegbending04.lvdt(val3,15) zijlwegbending04.lvdt(val4,15) zijlwegbending04.lvdt(val5,15)];
crackwidth16 = [0 zijlwegbending04.lvdt(val1,16) zijlwegbending04.lvdt(val2,16) zijlwegbending04.lvdt(val3,16) zijlwegbending04.lvdt(val4,16) zijlwegbending04.lvdt(val5,16)];
loads = [0 Ftot(val1) Ftot(val2) Ftot(val3) Ftot(val4) Ftot(val5)];
f28=figure
plot(loads,crackwidth14,'k-o','linewidth',2)
hold on
plot(loads,crackwidth15,'color', [0.35,0.35,0.35],'marker', 'o','linewidth', 2)
plot(loads,crackwidth16,'color', [0.75,0.75,0.75],'marker', 'o','linewidth', 2)
hold off
xlabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Increase in crack width (mm)','FontWeight','bold','Fontname', 'Times New Roman')
title('Increase in crack width with load','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 Fomax+10 0 max(crackwidth16)+0.001])
legend('LVDT14','LVDT15','LVDT16','location','EastOutside')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'crack width linear.tif')
saveas(gcf,'crack width linear.eps')
saveas(gcf,'crack width linear.pdf')

%crack width as function of load
crackwidth14 = [0 zijlwegbending04.lvdt(val1,14) zijlwegbending04.lvdt(val2,14) zijlwegbending04.lvdt(val3,14) zijlwegbending04.lvdt(val4,14) zijlwegbending04.lvdt(val5,14)];
crackwidth15 = [0 zijlwegbending04.lvdt(val1,15) zijlwegbending04.lvdt(val2,15) zijlwegbending04.lvdt(val3,15) zijlwegbending04.lvdt(val4,15) zijlwegbending04.lvdt(val5,15)];
crackwidth16 = [0 zijlwegbending04.lvdt(val1,16) zijlwegbending04.lvdt(val2,16) zijlwegbending04.lvdt(val3,16) zijlwegbending04.lvdt(val4,16) zijlwegbending04.lvdt(val5,16)];
loads = [0 Ftot(val1) Ftot(val2) Ftot(val3) Ftot(val4) Ftot(val5)];
f28=figure
plot(loads,crackwidth14,'b-o','linewidth',2)
hold on
plot(loads,crackwidth15,'color', 'r','marker', 'o','linewidth', 2)
plot(loads,crackwidth16,'color', 'g','marker', 'o','linewidth', 2)
hold off
xlabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('Increase in crack width (mm)','FontWeight','bold','Fontname', 'Times New Roman')
title('Increase in crack width with load','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 Fomax+10 0 max(crackwidth16)+0.001])
legend('LVDT14','LVDT15','LVDT16','location','EastOutside')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'crack width linear RBG.tif')
saveas(gcf,'crack width linear RBG.eps')
saveas(gcf,'crack width linear RBG.pdf')

%draw entire envelope of load-displacement curve
f29=figure;
plot(so(1:267),Ftot(1:267),'color','k','linewidth',2)
hold on
plot(so(340:832),Ftot(340:832),'color','k','linewidth',2)
% plot(so(467:487),Ftot(467:487),'color','b','linewidth',2)
% plot(so(620:832),Ftot(620:832),'color','b','linewidth',2)
plot(so(1130:1231),Ftot(1130:1231),'color','k','linewidth',2)
plot(so(1413:1518),Ftot(1413:1518),'color','k','linewidth',2)
plot(so(1912:2638),Ftot(1912:2638),'color','k','linewidth',2)
plot(so(2905:3102),Ftot(2905:3102),'color','k','linewidth',2)
plot(so(3356:3543),Ftot(3356:3543),'color','k','linewidth',2)
plot(so(3940:4137),Ftot(3940:4137),'color','k','linewidth',2)
plot(so(4398:4589),Ftot(4398:4589),'color','k','linewidth',2)
plot(so(4854:5062),Ftot(4854:5062),'color','k','linewidth',2)
plot(so(5318:5547),Ftot(5318:5547),'color','k','linewidth',2)
hold off
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Envelope of the measured Force-Displacement','FontWeight','bold','Fontname', 'Times New Roman')
axis([0 somax+0.2 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'envelope total.tif')
saveas(gcf,'envelope total.eps')


%LVDTs 1,2,3 and 4 without temperature correction
f30=figure;
plot(zijlwegbending04.lvdt(:,1)*1000,Ftot, 'color','b','linewidth',2)
hold on
plot(zijlwegbending04.lvdt(:,2)*1000,Ftot, 'color','r','linewidth',2)
plot(zijlwegbending04.lvdt(:,3)*1000,Ftot, 'color','g','linewidth',2)
plot(zijlwegbending04.lvdt(:,4)*1000,Ftot, 'color','k','linewidth',2)
hold off
xlabel('microstrain','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F (kN)','FontWeight','bold','Fontname', 'Times New Roman')
title('Measured strains (without temperature correction)','FontWeight','bold','Fontname', 'Times New Roman')
axis([-100 300 0 Fomax+50])
legend('LVDT1','LVDT2','LVDT3','LVDT4','location','EastOutside')
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'strains without correction.tif')

%figure for paper
f31=figure;
plot(so(4200:5100),Ftot(4200:5100),'color', 'b','linewidth',1.3)
xlabel('\delta (mm)','FontWeight','bold','Fontname', 'Times New Roman')
ylabel('F(kN)','FontWeight','bold','Fontname', 'Times New Roman')
%axis([0 tmax+10 0 Fomax+50])
set(gca,'XGrid', 'on','YGrid','on', 'linewidth', 1.5, 'FontWeight','bold','Fontname', 'Times New Roman');
saveas(gcf,'two cycles.tif')

% Add this to the script
disp('Strain values at load steps:');
disp(['val1 (' num2str(Ftot(val1)) ' kN): ' num2str(zijlwegbending04.strain(val1,2)*1e6) ' με']);
disp(['val2 (' num2str(Ftot(val2)) ' kN): ' num2str(zijlwegbending04.strain(val2,2)*1e6) ' με']);
disp(['val3 (' num2str(Ftot(val3)) ' kN): ' num2str(zijlwegbending04.strain(val3,2)*1e6) ' με']);
disp(['val4 (' num2str(Ftot(val4)) ' kN): ' num2str(zijlwegbending04.strain(val4,2)*1e6) ' με']);
disp(['val5 (' num2str(Ftot(val5)) ' kN): ' num2str(zijlwegbending04.strain(val5,2)*1e6) ' με']);


% Display strain values at each load step
fprintf('\n=== BENDING TEST STRAIN VALUES ===\n\n');

% Load Step 1
fprintf('Load Step 1 (val1):\n');
fprintf('  Load: %.2f kN\n', Ftot(val1));
fprintf('  LVDT02: %.3f με\n', zijlwegbending04.strain(val1,2)*1e6);
fprintf('  LVDT03: %.3f με\n', zijlwegbending04.strain(val1,3)*1e6);
fprintf('  Max strain: %.3f με\n\n', max(zijlwegbending04.strain(val1,2:3))*1e6);

% Load Step 2
fprintf('Load Step 2 (val2):\n');
fprintf('  Load: %.2f kN\n', Ftot(val2));
fprintf('  LVDT02: %.3f με\n', zijlwegbending04.strain(val2,2)*1e6);
fprintf('  LVDT03: %.3f με\n', zijlwegbending04.strain(val2,3)*1e6);
fprintf('  Max strain: %.3f με\n\n', max(zijlwegbending04.strain(val2,2:3))*1e6);

% Load Step 3
fprintf('Load Step 3 (val3):\n');
fprintf('  Load: %.2f kN\n', Ftot(val3));
fprintf('  LVDT02: %.3f με\n', zijlwegbending04.strain(val3,2)*1e6);
fprintf('  LVDT03: %.3f με\n', zijlwegbending04.strain(val3,3)*1e6);
fprintf('  Max strain: %.3f με\n\n', max(zijlwegbending04.strain(val3,2:3))*1e6);

% Load Step 4
fprintf('Load Step 4 (val4):\n');
fprintf('  Load: %.2f kN\n', Ftot(val4));
fprintf('  LVDT02: %.3f με\n', zijlwegbending04.strain(val4,2)*1e6);
fprintf('  LVDT03: %.3f με\n', zijlwegbending04.strain(val4,3)*1e6);
fprintf('  Max strain: %.3f με\n\n', max(zijlwegbending04.strain(val4,2:3))*1e6);

% Load Step 5
fprintf('Load Step 5 (val5):\n');
fprintf('  Load: %.2f kN\n', Ftot(val5));
fprintf('  LVDT02: %.3f με\n', zijlwegbending04.strain(val5,2)*1e6);
fprintf('  LVDT03: %.3f με\n', zijlwegbending04.strain(val5,3)*1e6);
fprintf('  Max strain: %.3f με\n\n', max(zijlwegbending04.strain(val5,2:3))*1e6);