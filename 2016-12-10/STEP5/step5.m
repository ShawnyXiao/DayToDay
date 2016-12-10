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

% 从"digitized_filtered_farming.csv"文件中读取数据
fileID = fopen('input/digitized_filtered_farming.csv', 'r', 'n', 'UTF-8');
formatSpec = '%d %d %d %d %f %s';
data = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

% 从data中提取数据
province = data{1};
market = data{2};
type = data{3};
name = data{4};
averagePrice = data{5};
time = data{6};

%% ================== 计算（距离元旦的天数，年份-2011） ================== 

% 构建当前日期和元旦日期变量
date = datetime(time);
dateOfNewYear = datetime(ymd(date), 1, 1);

% 计算距离元旦的天数
daysFromNewYear = hours(date - dateOfNewYear) ./ 24;

% 计算年份与2011的差
yearFrom2011 = year(date) - 2011;

%% ========================== 写出数据 ========================== 

% 将结果写出到"timed_digitized_filtered_farming.csv"文件中
fileID = fopen([outputPath, 'timed_digitized_filtered_farming.csv'], 'w', 'n', 'UTF-8');
formatSpec = '%d,%d,%d,%d,%f,%s,%d,%d\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province(row), market(row), type(row), name(row), averagePrice(row), time{row}, daysFromNewYear(row), yearFrom2011(row));
end
fclose(fileID);

%% ========================== 结束计时 ========================== 

toc