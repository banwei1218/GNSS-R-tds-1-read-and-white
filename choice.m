clc;
clear all;
InPath = 'G:\data\L1B\2018-06\18\H18\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ȡmetadata.nc��ʱ�����ݺ;����λ������
ncdisp(strcat(InPath,'metadata.nc')) %��ȡ����ȡnc�ļ��Ļ�����Ϣ 
% vardata = ncread(source,varname)
source1 = strcat(InPath,'metadata.nc');
ncdisp(strcat(InPath,'DDMs.nc')) %��ȡ����ȡnc�ļ��Ļ�����Ϣ
source2 = strcat(InPath,'DDMs.nc');
TrackID = '/000025/';
Sat_number=ncreadatt(source1,TrackID,'PRN');   %%���Զ���
CodeDelayspsbp=double(ncreadatt(source1, TrackID,'CodeDelaySpacingSamplesBetweenPixels'));
SamplingFre=ncreadatt(source1,TrackID,'SamplingFrequency');
DopplerReso=ncreadatt(source1,TrackID,'DopplerResolution');
TrackingoffDP=ncreadatt(source1,TrackID,'TrackingOffsetDopplerHz');
timemid1 = strcat( TrackID,'IntegrationMidPointTime');
spx =strcat( TrackID, 'SpecularPointPositionX');
spy =strcat( TrackID, 'SpecularPointPositionY');
spz =strcat( TrackID, 'SpecularPointPositionZ');
spl =strcat( TrackID, 'SpecularPointLat');
spb =strcat( TrackID, 'SpecularPointLon');
dt =strcat( TrackID, 'Delay');
dd =strcat( TrackID, 'Doppler');
time2 =strcat( TrackID, 'IntegrationMidPointTime');
ddm =strcat( TrackID, 'DDM');
NoiseBR=strcat( TrackID, 'NoiseBoxRows');
PeakDDM=strcat( TrackID, 'DDMSNRAtPeakSingleDDM');
Time1=ncread(source1,timemid1);
SPPosition_X = ncread(source1,spx);
SPPosition_Y = ncread(source1,spy);
SPPosition_Z = ncread(source1,spz);
SPPosition_Lat = ncread(source1,spl);
SPPosition_Lon = ncread(source1,spb);
NoiseBoxRows = ncread(source1,NoiseBR);
DDMSNRAtPeakSDDM = ncread(source1,PeakDDM);
%SP_Position=[SPPosition_X,SPPosition_Y,SPPosition_Z];
%SP_Position_LB=[SPPosition_Lat,SPPosition_Lon];
Time=ncread(source1,timemid1);
Time_Delay = ncread(source2,dt);
Dopp_Delay= ncread(source2,dd);
Time_ddm= ncread(source2,time2);
DDM = ncread(source2,ddm);

%a=find(SPPosition_Lon>=119 & SPPosition_Lon<=121.5);
%b=find(SPPosition_Lat>=34.5 & SPPosition_Lat<=35.5);   % a��b��Ϊ���Ⱥ�γ�ȵ�ָ��

a=find(SPPosition_Lon>=-31.88 & SPPosition_Lon<=-31.32);
b=find(SPPosition_Lat>=34.5 & SPPosition_Lat<=36.5);   % a��b��Ϊ���Ⱥ�γ�ȵ�ָ��
%b=find(SPPosition_Lat>=33.7 & SPPosition_Lat<=36.75);
lon_num=length(a);
lat_num=length(b);
c=intersect(a,b);     %���������Ľ���
[a1,a2]=size(c);
DDM_F1=zeros(128,20,a1);
%%%%%%%%%%%%%%%%%%%%%%%
%%%%��������ռ�ʱ���ӳ�����
DelayinSecond=((Time_Delay*CodeDelayspsbp)/SamplingFre)*1023000;
DopplerinHz=(Dopp_Delay *DopplerReso-TrackingoffDP)/1000;


%% ��ȡ�������ڷ�Χ�ڵ�����
for i=1:a1
   Time_F(i,1)=Time(c(i)); 
   SP_Position_X(i,1)=SPPosition_X(c(i),:);
   SP_Position_Y(i,1)=SPPosition_Y(c(i),:);
   SP_Position_Z(i,1)=SPPosition_Z(c(i),:);
   SP_Position_Lat(i,1) = SPPosition_Lat(c(i),:);
   SP_Position_Lon(i,1) = SPPosition_Lon(c(i),:);
   PeakSNR(i,1) = DDMSNRAtPeakSDDM(c(i),:);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   PRN(i,1)=Sat_number;
   DDM_F1(:,:,i)=DDM(:,:,c(i));
end

%%������DDM
% Posi_maxxy=zeros(i,2);
% for nor=1:i
%    max_val=max(max(DDM_F1(:,:,nor)));
%    Posi_maxxy(nor,:)=find(max_val==DDM_F1(:,:,nor)); 
%    DDM_F1(:,:,nor)=DDM_F1(:,:,nor)/max_val; 
% % end
% a1=DDM_F1(:,:,1);
% a11=max(max(a1));
% a2=DDM_F1(:,:,2);
% a12=max(max(a2));
% a3=DDM_F1(:,:,3);
% a13=max(max(a3));
% a4=DDM_F1(:,:,4);
% a14=max(max(a4));



%mesh(Dopp_Delay,Time_Delay,DDM_F1(:,:,5));
 pcolor(DopplerinHz,DelayinSecond,DDM(:,:,5));
% hold on
% pcolor(DopplerinHz,DelayinSecond,DDM_F1(:,:,6));
%SP_Position_LB=[SP_Position_Lon,SP_Position_Lat];

 %Final=struct(Time_F,PRN,SP_Position_X,SP_Position_Y,SP_Position_Z,SP_Position_Lat,SP_Position_Lon);
res=[SP_Position_Lat,SP_Position_Lon,PeakSNR];
 
 
fid = fopen('G:\data\res.txt','w');
fprintf(fid,'%d,',res);         
fclose(fid);






