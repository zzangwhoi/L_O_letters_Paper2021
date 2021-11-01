%%  use SOM method to analyze the surface chl in multiple year (2001-2016) 16 years 
clc;clear

num_8day=46;
num_year=16;

% step 0: load DINEOF data
load('./chl_GOM_origin_and_DINEOF.mat');
load('./lon_GOM_2D.mat');
load('./lat_GOM_2D.mat');





    % just use 1st year's data and interpolate to 2'*2' grid 
    data_tmp=chl_GOM_origin_and_DINEOF(:,:,1:num_8day*num_year);
    
    lon_GOM_coarse=[-71:0.025:-65.5];
    lat_GOM_coarse=[42:0.025:44.5];
    [lat_GOM_coarse_2D,lon_GOM_coarse_2D]=meshgrid(lat_GOM_coarse,lon_GOM_coarse);


    % load h and calculate h_mask
    load('./h_GoM.mat');
    h_GoM_coarse=griddata(lon_GOM_2D,lat_GOM_2D,h_GoM,lon_GOM_coarse_2D,lat_GOM_coarse_2D);  
    h_mask=h_GoM_coarse;
    h_mask(h_mask>-50)=NaN; h_mask(~isnan(h_mask))=1;

    
    
    
    for i=1:num_8day*num_year
        i
        data_tmp2(:,:,i)=griddata(lon_GOM_2D,lat_GOM_2D,data_tmp(:,:,i),lon_GOM_coarse_2D,lat_GOM_coarse_2D).*h_mask;
        
    end
    
  
    
        data=reshape(data_tmp2,[size(data_tmp2,1)*size(data_tmp2,2),num_8day*num_year]);
        clear data_nonan
        k=1;
        
        for t=1:num_8day*num_year
            t
            
            ind_nonan=find(~isnan(data(:,1)));
        data_nonan(:,t)=data(ind_nonan,t);
            

        end
        
    sD=data_nonan'; % row is time; column is station
save sD1_16_year_50m sD
save ind_nonan_16_year_50m ind_nonan


% step 1: SOM

sM=som_lininit(sD,'msize',[3 4],'lattice','rect','shape','sheet');
disp('finish initalization');

  sM1 = som_batchtrain(sM, sD,'radius',[3 1],'trainlen',50,'neigh','ep');

save sM1_16_year_50m sM1





