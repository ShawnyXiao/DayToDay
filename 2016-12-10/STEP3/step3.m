%% =========================== 开始计时 ===========================

tic

%% =========================== 初始操作 ===========================

% 清空工作区变量，清空屏幕
clear
clc

%   创建输出文件存放目录
outputPath = 'output/';
if ~isdir(outputPath)
    mkdir(outputPath);
end

%% =========================== 读取数据 =========================== 

% 从"timed_digitized_filtered_farming.csv"文件中读取数据
fileID = fopen('input/timed_digitized_filtered_farming.csv', 'r', 'n', 'UTF-8');
formatSpec = '%d %d %d %d %f %s %d %d';
data = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

% 从data中提取数据
province = data{1};
name = data{4};
averagePrice = data{5};
time = data{6};
provinceName = [province, name];

%% ================= 增加统计属性：该省该农产品近期平均价格 ================= 

% 声明统计属性
recentAveragePrice = zeros(length(province), 1);

% 计算统计属性
[uniqueProvinceName, indexOfUniqueProvinceName, indexOfProvinceName] = unique(provinceName, 'rows');
length(uniqueProvinceName)
for i = 1:length(uniqueProvinceName)
    i
    indexOfSameProvinceName = find(indexOfProvinceName == i);
    timeForSameProvinceName = datetime(time(indexOfSameProvinceName, :));
    for j = 1:length(indexOfSameProvinceName)
        lowDate = timeForSameProvinceName(j) - caldays(10);
        highDate = timeForSameProvinceName(j) - caldays(1);
        index = find(timeForSameProvinceName >= lowDate & timeForSameProvinceName <= highDate);
        if isempty(index)
            recentAveragePrice(indexOfSameProvinceName(j)) = averagePrice(indexOfSameProvinceName(j));
            continue;
        end
        recentAveragePrice(indexOfSameProvinceName(j)) = mean(averagePrice(indexOfSameProvinceName(index)));
    end
end

%% ========================== 写出数据 ========================== 

% 将结果写出到"annotated_timed_digitized_filtered_farming.csv"文件中
fileID = fopen([outputPath, 'annotated_timed_digitized_filtered_farming.csv'], 'w', 'n', 'UTF-8');
formatSpec = '%d,%d,%d,%d,%f,%s,%d,%d,%f\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province(row), data{2}(row), data{3}(row), name(row), averagePrice(row), time{row}, data{7}(row), data{8}(row), recentAveragePrice(row));
end
fclose(fileID);

%% ========================== 结束计时 ========================== 

toc