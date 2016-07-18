close all
clear all

% Produce 4 Classes Of Normal Data
mu = 2;
sigma = 0.4;
p1 = normrnd(mu,sigma,[250 2]);
mu = -1;
sigma =0.35;
p2 = normrnd(mu,sigma,[250 2]);
mu = -3;
sigma = 0.5;
p3 = normrnd(mu,sigma,[250 2]);
mu = 0.5;
sigma =0.2;
p4 = normrnd(mu,sigma,[250 2]);

training_set = zeros(1000,2);
training_set(1:250,:) = p1;
training_set(251:500,:) = p2;
training_set(501:750,:) = p3;
training_set(751:1000,:) = p4;

% plot clusters
figure(1);plot(p1(:,1),p1(:,2),'k+')
hold on
grid on
plot(p2(:,1),p2(:,2),'b*')
plot(p3(:,1),p3(:,2),'kx')
plot(p4(:,1),p4(:,2),'bd')
% labaling For Clustrs
hleg1 = legend('Class 1','Class 2','Class 3','Class 4');
set(hleg1,'Location','southeast')

train_labels = zeros(1000,1);
train_labels(1:250,:) = 1;
train_labels(251:500,:) = 2;
train_labels(501:750,:) = 3;
train_labels(751:1000,:) = 4;


% close all


mu = 2;
sigma = 0.4;
p1 = normrnd(mu,sigma,[250 2]);
mu = -1;
sigma =0.35;
p2 = normrnd(mu,sigma,[250 2]);
mu = -3;
sigma = 0.5;
p3 = normrnd(mu,sigma,[250 2]);
mu = 0.5;
sigma =0.2;
p4 = normrnd(mu,sigma,[250 2]);

test_set = zeros(1000,2);
test_set(1:250,:) = p1;
test_set(251:500,:) = p2;
test_set(501:750,:) = p3;
test_set(751:1000,:) = p4;


test_labels = zeros(1000,1);
test_labels(1:250,:) = 1;
test_labels(251:500,:) = 2;
test_labels(501:750,:) = 3;
test_labels(751:1000,:) = 4;
