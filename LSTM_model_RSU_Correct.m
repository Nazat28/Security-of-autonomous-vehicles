num_samples= 10000;

%generate the data
[AV_2_A_ft, AV_2_A_label] = generate_anomalous_samples(num_samples/2);
[AV_2_N_ft, AV_2_N_label] = generate_normal_samples(num_samples/2);
AV_2_ft = [AV_2_N_ft;AV_2_A_ft];
AV_2_label = [AV_2_N_label;AV_2_A_label];

a=[AV_2_ft,AV_2_label]
save data_of_AV2.mat a
%% 



%Loading of data
data= mean(AV_2_ft');
label= (AV_2_label);

%Data is divided
N= 0.7 * num_samples;%floor(0.7*numel(data));
dataTrain= data(1:N);
dataTest= data(N+1:end);

%Standardization of data
mu= mean(dataTrain);
sig= std(dataTrain);
dataTrainStandardized = (dataTrain - mu)/sig;

%Prepare Predictors and Responses
XTrain= dataTrainStandardized(1:end-1);
YTrain= dataTrainStandardized(2:end);

%Defining the network architecture
numFeatures= 1; %This will vary according to our data
numResponses= 1;
numHiddenUnits= 200;

layers= [...
sequenceInputLayer(numFeatures)
lstmLayer(numHiddenUnits)
fullyConnectedLayer(numResponses)
regressionLayer];

options= trainingOptions('adam', ...
'MaxEpochs',50, ...
'GradientThreshold',1, ...
'InitialLearnRate',0.005, ...
'LearnRateSchedule','piecewise', ...
'LearnRateDropPeriod',125, ...
'LearnRateDropFactor',0.2, ...
'Verbose',0); %...'Plots','training-progress');

net= trainNetwork(XTrain,YTrain,layers,options);
%% 


%Forecast future time steps
dataTestStandardized= (dataTest - mu)/sig;
XTest= dataTestStandardized(1:end);
net= predictAndUpdateState(net,XTrain);
[net,YPred]= predictAndUpdateState(net,YTrain(end));

numTimeStepTest= numel(XTest);
for i=2:numTimeStepTest
[net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','cpu');
end
YPred= (sig*YPred) + mu;
YTest= dataTest(1:end);
rmse= sqrt(mean((YPred-YTest).^2));

%See if it is anomalous or not

for i=1:size(YTest,2)
 z(i) = (YPred(i)-YTest(i))/YTest(i)*100;
end

%Accuracy of LSTM Model
%accuracy= sum(YPred'==label)/length(label)*100;

lamda_values = 60;
accuracy_values = zeros(size(lamda_values));

accuracy = [];
for j=1:length(lamda_values)
for i = 1:length(z)
    %lamda = lamda_values(i);
    if i<length(z)/2

    % Compute accuracy for current value of lamda
    if abs(z(i)) > lamda_values(j)
        state_of_AV(i) = 1;
    else 
        state_of_AV(i) = 0;
    end
    else 
            if abs(z(i)) > lamda_values(j)
        state_of_AV(i) = 0;
    else 
        state_of_AV(i) = 1;
    end
    end

   % accuracy_values(i) = accuracy;
end
accuracy = [accuracy mean(sum(state_of_AV == label)/length(label)*100)]
end


% Plot results
%plot(lamda_values, accuracy, '-*');

%hold on;
%set(findall(gca, 'Type', 'Line'),'LineWidth',3);
%xlabel('Threshold Value (%)', 'FontSize', 22);
%ylabel('Accuracy of LSTM-based RSU Anomaly Detection','FontSize',22);
%ax = gca;
%ax.FontSize = 22;


