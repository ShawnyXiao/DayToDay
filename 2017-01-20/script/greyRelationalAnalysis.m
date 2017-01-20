%% 初始化
clc
clear

%% 读取数据
Data = [1988 386 839 763;
            2061 408 846 808;
            2335 422 960 953;
            2750 482 1258 1010;
            3356 511 1577 1268;
            3806 561 1893 1352];

% 一些有用的变量
[n, m] = size(Data);
m = m - 1;

%% 无量纲化处理
average = mean(Data);
for i = 1:n
    Data(i, :) = Data(i, :) ./ average;
end

%% 确定参考数列和比较数列
y = Data(:, 1);
X = Data(:, 2:end)';

%% 计算关联系数
Delta = zeros(m, n);
for i = 1:m
    Delta(i, :) = abs(X(i, :) - y');
end

rho = 0.5;
minDelta = min(min(Delta));
maxDelta = max(max(Delta));
Epsilon = (minDelta + rho * maxDelta) ./ (Delta + rho * maxDelta);

%% 计算关联度
R = mean(Epsilon, 2);