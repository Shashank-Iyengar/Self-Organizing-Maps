%% Homework 5 - Shaft Health Assessment
%% Group 1 - Shashank Iyengar, Johann Koshy, Ashwin Kumat, Ketan Shah

close all
clear all
clc
set(0,'DefaultAxesFontName', 'Times New Roman')
set(0,'DefaultAxesFontSize', 15)
set(0,'defaultlinelinewidth',.5)
set(0,'DefaultLineMarkerSize', 5)
set(0,'defaultAxesFontWeight','bold') 

%% Data Acquisition
% Training - Healthy Data
testfiledir = 'C:\Users\johan\Desktop\UC_Spring2019\Big_data\HW4_test\Training\Healthy';
matfiles = dir(fullfile(testfiledir, '*.txt'));
nfiles = length(matfiles);
data  = cell(nfiles);
for i=1:nfiles
    data{i} = dlmread(fullfile(testfiledir, matfiles(i).name), ' ', 5, 0);
end

% Splitting the data array to parts
train_healthy=[];
for i=1:nfiles
    train_healthy(i,:)=cell2mat(data(i,1)); % Healthy data
end

% Training - Faulty Data Unbalance 1
testfiledir = 'C:\Users\johan\Desktop\UC_Spring2019\Big_data\HW4_test\Training\Faulty\Unbalance_1';
matfiles = dir(fullfile(testfiledir, '*.txt'));
nfiles = length(matfiles);
data  = cell(nfiles);
for i=1:nfiles
    data{i} = dlmread(fullfile(testfiledir, matfiles(i).name), ' ', 5, 0);
end

% Splitting the data array to parts
train_faulty_ub1=[];
for i=1:nfiles
    train_faulty_ub1(i,:)=cell2mat(data(i,1)); % Unbalance 1 data
end

% Training - Faulty Data Unbalance 2
testfiledir = 'C:\Users\johan\Desktop\UC_Spring2019\Big_data\HW4_test\Training\Faulty\Unbalance_2';
matfiles = dir(fullfile(testfiledir, '*.txt'));
nfiles = length(matfiles);
data  = cell(nfiles);
for i=1:nfiles
    data{i} = dlmread(fullfile(testfiledir, matfiles(i).name), ' ', 5, 0);
end

% Splitting the data array to parts
train_faulty_ub2=[];
for i=1:nfiles
    train_faulty_ub2(i,:)=cell2mat(data(i,1)); % Unbalance 2 data
end

% Testing Data (30 Sets)
testfiledir = 'C:\Users\johan\Desktop\UC_Spring2019\Big_data\HW4_test\Testing';
matfiles = dir(fullfile(testfiledir, '*.txt'));
nfiles = length(matfiles);
data  = cell(nfiles);
for i = 1 : nfiles
    data{i} = dlmread(fullfile(testfiledir, matfiles(i).name), ' ', 5, 0);
end

% Splitting the data array to parts
test_data=[];
for i=1:nfiles
    test_data(i,:)=cell2mat(data(i,1));
end



%% Feature extraction Time Domain %%
%%%% RMS - Peak to Peak - Skewness - Kurtosis Training
for i=1:20
   
    rms_healthy(i) = rms(train_healthy(i,:));
    rms_faulty_ub1(i) = rms(train_faulty_ub1(i,:));
    rms_faulty_ub2(i) = rms(train_faulty_ub2(i,:));
    
    p2p_healthy(i) = peak2peak(train_healthy(i,:));
    p2p_faulty_ub1(i) = peak2peak(train_faulty_ub1(i,:));
    p2p_faulty_ub2(i) = peak2peak(train_faulty_ub2(i,:));
    
    skewness_healthy(i) = skewness(train_healthy(i,:));
    skewness_faulty_ub1(i) = skewness(train_faulty_ub1(i,:));
    skewness_faulty_ub2(i) = skewness(train_faulty_ub2(i,:));
    
    kurtosis_healthy(i) = kurtosis(train_healthy(i,:));
    kurtosis_faulty_ub1(i) = kurtosis(train_faulty_ub1(i,:));
    kurtosis_faulty_ub2(i) = kurtosis(train_faulty_ub2(i,:));
    
end
%%%% RMS Testing
for i=1:30
    rms_test(i) = rms(test_data(i,:));
    p2p_test(i) = peak2peak(test_data(i,:));
    skewness_test(i) = skewness(test_data(i,:));
    kurtosis_test(i) = kurtosis(test_data(i,:));
end



%% Feature extraction Frequency Domain %%
Fs = 2560;          % Sampling frequency
dt = 1/Fs;          % Time step
Ntime = 38400;      % Number of data points
Ttotal = 15;        % Total time
df = 1/Ttotal;      % Fundamental frequency

for i=1:20
    train_healthy_fft(i,:)=fft(train_healthy(i,:));
    train_faulty_ub1_fft(i,:)=fft(train_faulty_ub1(i,:));
    train_faulty_ub2_fft(i,:)=fft(train_faulty_ub2(i,:));
    
%     figure(i)
%     plot((0:Ntime/2-1)/Ttotal,(2/Ntime)*abs(train_healthy_fft(i,1:Ntime/2)))
%     xlabel(['$ Frequency \;\mathrm{[Hz]} $'],'interpreter','latex')
%     ylabel(['$ Magnitude \;\mathrm{[V]} $'],'interpreter','latex')
%     txt=['FFT Healthy', num2str(i)];
%     title(txt)
%     grid on
%     xlim([0 50])
%     figure(i+20)
%     plot((0:Ntime/2-1)/Ttotal,(2/Ntime)*abs(train_faulty_ub1_fft(i,1:Ntime/2)))
%     xlabel(['$ Frequency \;\mathrm{[Hz]} $'],'interpreter','latex')
%     ylabel(['$ Magnitude \;\mathrm{[V]} $'],'interpreter','latex')
%     txt=['FFT Faulty', num2str(i)];
%     title(txt)
%     grid on
%     xlim([0 50])
%     plot((0:Ntime/2-1)/Ttotal,(2/Ntime)*abs(train_faulty_ub2_fft(i,1:Ntime/2)))
%     xlabel(['$ Frequency \;\mathrm{[Hz]} $'],'interpreter','latex')
%     ylabel(['$ Magnitude \;\mathrm{[V]} $'],'interpreter','latex')
%     txt=['FFT Faulty', num2str(i)];
%     title(txt)
%     grid on
%     xlim([0 50])
    
    amplitude_healthy(i) = max(((2/Ntime)*abs(train_healthy_fft(i,1:750/2))));
    amplitude_faulty_ub1(i) = max(((2/Ntime)*abs(train_faulty_ub1_fft(i,1:750/2))));
    amplitude_faulty_ub2(i) = max(((2/Ntime)*abs(train_faulty_ub2_fft(i,1:750/2))));

end
for i=1:30
    testset(i,:) = fft(test_data(i,:));
    amplitude_testset(i) = max(((2/Ntime)*abs(testset(i,1:750/2))));
end


figure
plot(1:20,amplitude_healthy,'-ko')
hold on
plot(1:20,amplitude_faulty_ub1,'-r*')
hold on
plot(1:20,amplitude_faulty_ub2,'-ro')
xlabel(['$ Samples\;\mathrm{} $'],'interpreter','latex')
ylabel(['$ Amplitude\;\mathrm{[V]} $'],'interpreter','latex')
legend('Healthy Amplitudes','Faulty Amplitudes')
txt=['Feature extraction'];
title(txt)
grid on


%% Feature matrix
% RMS - P2P - Skewness - Kurtosis : order of columns
feature_mat_healthy = [rms_healthy.' p2p_healthy.' amplitude_healthy.']; 
feature_mat_faulty_ub1 = [rms_faulty_ub1.' p2p_faulty_ub1.' amplitude_faulty_ub1.'];
feature_mat_faulty_ub2 = [rms_faulty_ub2.' p2p_faulty_ub2.' amplitude_faulty_ub2.'];
feature_mat_test = [rms_test.' p2p_test.' amplitude_testset.']; 


%% SOM

% D=[feature_mat_healthy; feature_mat_faulty_ub1; feature_mat_faulty_ub2];
% D_MQE=[feature_mat_healthy];
% 
% D_test=[feature_mat_test];
% %%Randomising order of training data
% % D=[];
% % index=randperm(length(D1));
% % for k=1:length(D1)
% %     D(k,:)=D1(index(k),:);
% % end
% 
% %%Creating data structure with variable titles
% sD = som_data_struct(D,'comp_names',{'rms','p2p','ampl'});
% sD_test=som_data_struct(D_test,'comp_names',{'rms','p2p','ampl'})
% sD_MQE=som_data_struct(D_MQE,'comp_names',{'rms','p2p','ampl'});
% 
% %%Normalising Data
% sD=som_normalize(sD,'var');
% sD_test=som_normalize(sD_test,'var');
% sD_MQE=som_normalize(sD_MQE,'var');
% 
% %%Labeling data
% sD = som_label(sD,'add',[1:20]','H');
% sD = som_label(sD,'add',[21:40]','UB1');
% sD = som_label(sD,'add',[41:60]','UB2');
% 
% 
% %%Creating U Matrix
% sM = som_make(sD);
% sM = som_autolabel(sM,sD,'vote');
% 
% sM_MQE = som_make(sD_MQE);
% 
% 
% hits=[];
% %%Hits
% for i=1:30
%  hits(i,:) = som_hits(sM,sD_test.data(i,:));
% end
% 
% %%Displaying Map
% som_show(sM,'umat','all','comp',[1:3],'empty','Labels','norm','d');
% som_show_add('label',sM.labels,'textsize',8,'textcolor','r','subplot',5);
% som_show_add('hit',som_hits(sM,sD_test));
% 
% 
% %%Quanitzation Error
% for i=1:30
% [qe(i),te(i)] = som_quality(sM_MQE,sD_test.data(i,:));
% end
% 
% for i=1:20
% [qe_healthy(i),te_healthy(i)] = som_quality(sM_MQE,sD.data(i,:));
% end
% qe_h=mean(qe_healthy);
% qe_hm=[];
% for i=1:30
%     qe_hm=[qe_hm qe_h]
% end
% 
% figure
% plot(qe,'-ko')
% hold on
% plot(qe_hm,'-bo')
% xlabel(['$ Samples\;\mathrm{} $'],'interpreter','latex')
% ylabel(['$ MQE\;\mathrm{} $'],'interpreter','latex')
% txt=['SOM-MQE'];
% title(txt)
% grid on

