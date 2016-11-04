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
fileID = fopen('input/product_market.csv', 'r', 'n', 'UTF-8');
formatSpec = '%s %s %s %s %*s %*s %*s %*s %*s %s';
originData = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

% 从"map_matrix.mat"文件中读取数据
load('input/map_matrix.mat');

%% =========================== 处理数据 =========================== 

% 格式化data
data = cell(length(originData{1}), 5);
for i = 1:5
    data(:, i) = originData{i};
end

% 从data中提取数据
province = data(:, 1);
market = data(:, 2);
type = data(:, 3);
name = data(:, 4);
time = data(:, 5);

%% ========================== 构建映射表 ==========================

% 创建映射表
mapOfProvince = containers.Map(mapMatrixOfProvince(:, 1), mapMatrixOfProvince(:, 2));
mapOfMarket = containers.Map(mapMatrixOfMarket(:, 1), mapMatrixOfMarket(:, 2));
mapOfType = containers.Map(mapMatrixOfType(:, 1), mapMatrixOfType(:, 2));
mapOfName = containers.Map(mapMatrixOfName(:, 1), mapMatrixOfName(:, 2));

%% =========================== 映射数据 =========================== 

% 对province, market, type, name做唯一化
[uniqueProvince, ~, indexOfUniqueProvince] = unique(province);
[uniqueMarket, ~, indexOfUniqueMarket] = unique(market);
[uniqueType, ~, indexOfUniqueType] = unique(type);
[uniqueName, ~, indexOfUniqueName] = unique(name);

% 为唯一化数组执行映射操作
for i = 1:length(uniqueProvince)
    uniqueProvince{i} = mapOfProvince(uniqueProvince{i});
end
for i = 1:length(uniqueMarket)
    uniqueMarket{i} = mapOfMarket(uniqueMarket{i});
end
for i = 1:length(uniqueType)
    uniqueType{i} = mapOfType(uniqueType{i});
end
for i = 1:length(uniqueName)
    uniqueName{i} = mapOfName(uniqueName{i});
end

% 替换原始数据为自然数
province = uniqueProvince(indexOfUniqueProvince);
market = uniqueMarket(indexOfUniqueMarket);
type = uniqueType(indexOfUniqueType);
name = uniqueName(indexOfUniqueName);

%% ======================= 计算距离元旦的天数 ======================= 

% 构建当前日期和元旦日期变量
date = datetime(time);
dateOfNewYear = datetime(ymd(date), 1, 1);

% 计算天数
daysFromNewYear = hours(date - dateOfNewYear) ./ 24;

%% ====================== 计算距离农历新年的天数 ====================== 

% 声明映射表
mapOfChineseNewYear = containers.Map;

% 为映射表添加映射对：键为年，值为农历新年的日期
mapOfChineseNewYear('2015') = datetime('2015/2/19');
mapOfChineseNewYear('2016') = datetime('2016/2/8');

% 计算天数
[uniqueYear, ~, indexOfUniqueYear] = unique(ymd(date));
for row = 1:length(uniqueYear)
    dateOfChineseNewYearOfUniqueYear(row, 1) = mapOfChineseNewYear(char(string(uniqueYear(row))));
end
daysFromChineseNewYear = hours(date - dateOfChineseNewYearOfUniqueYear(indexOfUniqueYear)) ./ 24;

% 矫正计算错误的天数（小于0的）
for row = 1:length(uniqueYear)
    dateOfChineseNewYearOfUniqueYear(row, 1) = mapOfChineseNewYear(char(string(uniqueYear(row) - 1)));
end
wrongPositon = daysFromChineseNewYear < 0;
daysForWrongElement = hours(date - dateOfChineseNewYearOfUniqueYear(indexOfUniqueYear)) ./ 24;
daysFromChineseNewYear(wrongPositon) = daysForWrongElement(wrongPositon);

%%  =========================== 写出文件 =========================== 

% 将结果写出到"timed_digitized_product_market.csv"文件中
fileID = fopen([outputPath, 'timed_digitized_product_market.csv'], 'w');
formatSpec = '%d,%d,%d,%d,%s,%d,%d\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province{row}, market{row}, type{row}, name{row}, time{row}, daysFromNewYear(row), daysFromChineseNewYear(row));
end
fclose(fileID);

%% =========================== 结束计时 ===========================

toc
