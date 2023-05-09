close all; clear all; clc;
%AV1
%Preparing dataset
%% 

num_samples_normal = 8000;
num_samples_anomalous = 2000;
S1_N = unifrnd(1,10,[num_samples_normal,1]);
S1_A = unifrnd(11,50,[num_samples_anomalous,1]);
S2_N = randi([0,1],num_samples_normal,1);
S2_A = randi([2,3],num_samples_anomalous,1);
S3_N = unifrnd(50,90,[num_samples_normal,1]);
S3_A_1 = unifrnd(91,150,[num_samples_anomalous/2,1]);
S3_A_2 = unifrnd(0,49,[num_samples_anomalous/2,1]);
S3_A = [S3_A_1;S3_A_2];
S4_N = unifrnd(1,10,[num_samples_normal,1]);
S4_A_1 = unifrnd(11,50,[num_samples_anomalous/2,1]);
S4_A_2 = unifrnd(0,1,[num_samples_anomalous/2,1]);
S4_A = [S4_A_1;S4_A_2];
S5_N = randi([0,1],num_samples_normal,1);
S5_A = randi([2,3],num_samples_anomalous,1);
S6_N = unifrnd(1,2,[num_samples_normal,1]);
S6_A = 3*ones(num_samples_anomalous,1);
S7_N = unifrnd(0.3,0.95,[num_samples_normal,1]);
S7_A_1 = unifrnd(0.96,2,[num_samples_anomalous/2,1]);
S7_A_2 = unifrnd(0.01,0.29,[num_samples_anomalous/2,1]);
S7_A = [S7_A_1;S7_A_2];
S8_N = unifrnd(1,100,[num_samples_normal,1]); %order of messages
S8_A = unifrnd(101,200,[num_samples_anomalous,1]);
S9_N = unifrnd(50,200,[num_samples_normal,1]);
S9_A_1 = unifrnd(1,49,[num_samples_anomalous/2,1]);
S9_A_2 = unifrnd(201,300,[num_samples_anomalous/2,1]);
S9_A = [S9_A_1;S9_A_2];
S10_N = randi([0,1],num_samples_normal,1);
S10_A = randi([4,5],num_samples_anomalous,1);

ft_N = [S1_N,S2_N,S3_N,S4_N,S5_N,S6_N,S7_N,S8_N,S9_N,S10_N];
ft_A = [S1_A,S2_A,S3_A,S4_A,S5_A,S6_A,S7_A,S8_A,S9_A,S10_A];
a= ones(num_samples_anomalous,1);
b= zeros(num_samples_normal,1);
label = vertcat(b,a);
%label1 = label(randperm(numel(label),12000));
%ft1 = [S1_N,S2_N,S3_N,S4_N,S5_N,S6_N,S7_N,S8_N,S9_N,S10_N,label1];
ft = [ft_N;ft_A];
x = ft(:,1:10);
y= label;
w=[x, y]
save dataset82.mat w
%% 

rand = randperm(num_samples_anomalous+num_samples_normal);

%Training of data
xtr= x(rand(1:.7*length(rand)), :);
ytr= y(rand(1:.7*length(rand)), :);

%Testing of data
xt= x(rand(.7*length(rand)+1:end), :);
yt= y(rand(.7*length(rand)+1:end), :);

%Train Model
model = fitcsvm(xtr,ytr,'KernelFunction','rbf', ...
        'OptimizeHyperparameters','auto', ...
        'HyperparameterOptimizationOptions', struct('AcquisitionFunctionName',...
        'expected-improvement-plus', 'ShowPlots', true))

%Test Model
result = predict(model,xt);
accuracy = sum(result == yt)/length(yt)*100
%% 
C = confusionmat(yt, result);
precision = C(1,1) / (C(1,1) + C(1,2))
recall = C(1,1) / (C(1,1) + C(2,1))
f1_score = 2 * precision * recall / (precision + recall)