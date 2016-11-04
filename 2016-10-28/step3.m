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
fileID = fopen('input/digitized_farming.csv');
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
mapOfChineseNewYear('2004') = datetime('2004/1/22');
mapOfChineseNewYear('2005') = datetime('2005/2/9');
mapOfChineseNewYear('2006') = datetime('2006/1/29');
mapOfChineseNewYear('2007') = datetime('2007/2/18');
mapOfChineseNewYear('2008') = datetime('2008/2/7');
mapOfChineseNewYear('2009') = datetime('2009/1/26');
mapOfChineseNewYear('2010') = datetime('2010/2/14');
mapOfChineseNewYear('2011') = datetime('2011/2/3');
mapOfChineseNewYear('2012') = datetime('2012/1/23');
mapOfChineseNewYear('2013') = datetime('2013/2/10');
mapOfChineseNewYear('2014') = datetime('2014/1/31');
mapOfChineseNewYear('2015') = datetime('2015/2/19');

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

% 将结果写出到"timed_digitized_farming.csv"文件中
fileID = fopen([outputPath, 'timed_digitized_farming.csv'], 'w');
formatSpec = '%d,%d,%d,%d,%f,%s,%d,%d\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province(row), market(row), type(row), name(row), averagePrice(row), time{row}, daysFromNewYear(row), daysFromChineseNewYear(row));
end
fclose(fileID);

%% ========================== 结束计时 ========================== 

toc