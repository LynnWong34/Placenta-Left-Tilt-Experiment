% this program will analyze the left tilt experiment data
% for left tilt experiment, there are 4 frames continuous measurement for supine pose
% and 4 frames continous measurement for left tilt pose
% the gap between two poses are 3 frames
clear all;
% read in data
Placenta_LeftData = readtable('PlacentaLeftTiltRawData.xlsx');
Placenta_LeftRaw = table2array (Placenta_LeftData);
% find out how many subjects in total
Num_Sub=max(Placenta_LeftRaw(:,1));

% Placenta_Left array is the left tilt experiment data
Placenta_Left=zeros(Num_Sub,20);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1 SubjectNo(not ID)              2 SubjectID 
% 3 Mean(StO2) of supine     4 SD(StO2) of supine
% 5 Mean(THC) of supine      6 SD(THC) of supine
% 7 Mean(HbO2) of supine     8 SD(HbO2) of supine
% 9 Mean(StO2) of supine     10 SD(StO2) of supine
% 11 Mean(THC) of supine     12 SD(THC) of supine
% 13 Mean(HbO2) of supine    14 SD(HbO2) of supine
% 15 Delta StO2              16 SD(Delta StO2) 
% 17 Delta HbT               18 SD(Delta HbT) 
% 19 Delta HbO2              20 SD(Delta HbO2) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for measnum=1:1:Num_Sub
    measind=(measnum-1)*8+1:(measnum-1)*8+8;
    Placenta_Left(measnum,1:2)=Placenta_LeftRaw(8*measnum,1:2);
    tem_Plact_Left=Placenta_LeftRaw(measind,:);
    % use the frames who has situation code <5 (marker 1)
    [inindoutcome100,~]=find(tem_Plact_Left(1:4,5)>0 & tem_Plact_Left(1:4,4)<5);
    if isempty(inindoutcome100)
        Placenta_Left(measnum,3:8)=0;
    else
        len_1=length(inindoutcome100);
        Placenta_Left(measnum,3)=mean(tem_Plact_Left(inindoutcome100,5));
        Placenta_Left(measnum,4)=std(tem_Plact_Left(inindoutcome100,5));
        Placenta_Left(measnum,5)=mean(tem_Plact_Left(inindoutcome100,6));
        Placenta_Left(measnum,6)=std(tem_Plact_Left(inindoutcome100,6));
        Placenta_Left(measnum,7)=mean(tem_Plact_Left(inindoutcome100,7));
        Placenta_Left(measnum,8)=std(tem_Plact_Left(inindoutcome100,7));
    end
    % use the frames who has situation code <5 (marker 2)
    [inindoutcome100,rhoind]=find(tem_Plact_Left(5:8,5)>0 & tem_Plact_Left(5:8,4)<5);
    if isempty(inindoutcome100)
        Placenta_Left(measnum,9:14)=0;
    else
        len_2=length(inindoutcome100);
        inindoutcome100=inindoutcome100+4;
        Placenta_Left(measnum,9)=mean(tem_Plact_Left(inindoutcome100,5));
        Placenta_Left(measnum,10)=std(tem_Plact_Left(inindoutcome100,5));
        Placenta_Left(measnum,11)=mean(tem_Plact_Left(inindoutcome100,6));
        Placenta_Left(measnum,12)=std(tem_Plact_Left(inindoutcome100,6));
        Placenta_Left(measnum,13)=mean(tem_Plact_Left(inindoutcome100,7));
        Placenta_Left(measnum,14)=std(tem_Plact_Left(inindoutcome100,7));
    end
        Placenta_Left(measnum,15)=Placenta_Left(measnum,9)-Placenta_Left(measnum,3);
        Placenta_Left(measnum,16)=sqrt(Placenta_Left(measnum,10)^2/len_2+Placenta_Left(measnum,4)^2/len_1);
        Placenta_Left(measnum,17)=Placenta_Left(measnum,11)-Placenta_Left(measnum,5);
        Placenta_Left(measnum,18)=sqrt(Placenta_Left(measnum,12)^2/len_2+Placenta_Left(measnum,6)^2/len_1);
        Placenta_Left(measnum,19)=Placenta_Left(measnum,13)-Placenta_Left(measnum,7);
        Placenta_Left(measnum,20)=sqrt(Placenta_Left(measnum,14)^2/len_2+Placenta_Left(measnum,8)^2/len_1);
end

Base_StO2_Relative=[1 1 1]';
Base_HbT_Relative=[1 1 1]';
Base_HbO2_Relative=[1 1 1]';
Left_StO2_Relative=Placenta_Left(:,9)./Placenta_Left(:,3);
Left_HbT_Relative=Placenta_Left(:,11)./Placenta_Left(:,5);
Left_HbO2_Relative=Placenta_Left(:,13)./Placenta_Left(:,7);

% average the relative change across all the subjects
Avg_Placenta_Left_R(1)=mean(Left_StO2_Relative-1);
Avg_Placenta_Left_R(2)=std(Left_StO2_Relative-1);
Avg_Placenta_Left_R(3)=mean(Left_HbT_Relative-1);
Avg_Placenta_Left_R(4)=std(Left_HbT_Relative-1);
Avg_Placenta_Left_R(5)=mean(Left_HbO2_Relative-1);
Avg_Placenta_Left_R(6)=std(Left_HbO2_Relative-1);
Avg_Placenta_Left_R(7)=median(Left_StO2_Relative-1);
Avg_Placenta_Left_R(8)=iqr(Left_StO2_Relative-1);
Avg_Placenta_Left_R(9)=median(Left_HbT_Relative-1);
Avg_Placenta_Left_R(10)=iqr(Left_HbT_Relative-1);
Avg_Placenta_Left_R(11)=median(Left_HbO2_Relative-1);
Avg_Placenta_Left_R(12)=iqr(Left_HbO2_Relative-1);

% paired t-test for relative change
[H_Left_R(1),P_Left_R(1)]=ttest(Base_StO2_Relative,Left_StO2_Relative);
[H_Left_R(2),P_Left_R(2)]=ttest(Base_HbT_Relative,Left_HbT_Relative);
[H_Left_R(3),P_Left_R(3)]=ttest(Base_HbO2_Relative,Left_HbO2_Relative);

% plot absolute values with S.D. as error bar
x=[1 2];
S_Sto2=[Placenta_Left(:,3),Placenta_Left(:,9)];
E_StO2=[Placenta_Left(:,4),Placenta_Left(:,10)];
S_HbT=[Placenta_Left(:,5),Placenta_Left(:,11)];
E_HbT=[Placenta_Left(:,6),Placenta_Left(:,12)];
S_HbO2=[Placenta_Left(:,7),Placenta_Left(:,13)];
E_HbO2=[Placenta_Left(:,8),Placenta_Left(:,14)];

figure;
set(gcf,'Position',[250 250 1450 550]);
subplot(1,3,1)
for measnum=1:1:Num_Sub
    errorbar(x,S_Sto2(measnum,:)*100,E_StO2(measnum,:)*100,'LineWidth',1.5);
    hold on;
end
xlim([0.5 2.5]);
ylim([40 100]);
xticks([1 2]);
xticklabels({'Supine','Left'});
yticks([40 60 80 100]);
set(gca,'FontSize',12,'FontWeight','bold'); 
subplot(1,3,2)
for measnum=1:1:Num_Sub
    errorbar(x,S_HbT(measnum,:),E_HbT(measnum,:),'LineWidth',1.5);
    hold on;
end
xlim([0.5 2.5]);
ylim([0 100]);
xticks([1 2]);
xticklabels({'Supine','Left'});
yticks([0 20 40 60 80 100]);
set(gca,'FontSize',12,'FontWeight','bold'); 
subplot(1,3,3)
for measnum=1:1:Num_Sub
    errorbar(x,S_HbO2(measnum,:),E_HbO2(measnum,:),'LineWidth',1.5);
    hold on;
end
xlim([0.5 2.5]);
xticklabels({'Supine','Left'});
ylim([0 62]);
xticks([1 2]);
yticks([0 20 40 60]);
set(gca,'FontSize',12,'FontWeight','bold'); 
savefig('PlacentaHemoglobin_AbsoluteValues_LeftTilt.fig');

