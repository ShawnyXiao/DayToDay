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

% 从"farming.csv"文件中读取数据
fileID = fopen('input/farming.csv', 'r', 'n', 'UTF-8');
formatSpec = '%s %s %s %s %s %s %s %s %s %s %s %s %s';
originData = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

%% =========================== 处理数据 =========================== 

% 从originData中提取数据
time = originData{13};
date = datetime(time);

%% =========================== 去除数据 =========================== 

% 只保留3月-11月的数据；
month = month(date);
index = find(month >= 3 & month <= 11);

%% =========================== 写出数据 ===========================

% 将映射结果写出到"filtered_farming.csv"文件中
fileID = fopen([outputPath, 'filtered_farming.csv'], 'w', 'n', 'UTF-8');
formatSpec = '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n';
for row = index'
    fprintf(fileID, formatSpec, originData{1}{row}, originData{2}{row}, originData{3}{row}, originData{4}{row}, originData{5}{row}, originData{6}{row}, originData{7}{row}, originData{8}{row}, originData{9}{row}, originData{10}{row}, originData{11}{row}, originData{12}{row}, originData{13}{row});
end
fclose(fileID);

%% =========================== 结束计时 ===========================

toc
