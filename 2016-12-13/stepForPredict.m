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
fileID = fopen('input/simulate/product_market.csv', 'r', 'n', 'UTF-8');
formatSpec = '%s %s %s %s %s';
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
for i = 1:(length(uniqueProvince)-1)
    uniqueProvince{i} = mapOfProvince(uniqueProvince{i});
end
uniqueProvince{end} = mapOfProvince('新疆');
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

%% =================== 计算（距离元旦的天数，年份-2011） =================== 

% 构建当前日期和元旦日期变量
date = datetime(time);
dateOfNewYear = datetime(ymd(date), 1, 1);

% 计算天数
daysFromNewYear = hours(date - dateOfNewYear) ./ 24;

% 计算年份与2011的差
yearFrom2011 = year(date) - 2011;

%% ========================== 增加统计属性 ========================== 

% 从"timed_digitized_filtered_farming.csv"文件中读取数据
fileID = fopen('input/simulate/annotated_timed_digitized_filtered_farming.csv', 'r', 'n', 'UTF-8');
formatSpec = '%d %d %d %d %f %s %*d %*d %*f';
originData2 = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

% 格式化data2
data2 = cell(length(originData2{1}), 6);
for i = 1:5
    data2(:, i) = num2cell(originData2{i});
end
data2(:, 6) = originData2{6};

% 去除2016-06-21~2016-06-30以外的数据
time2 = datetime(data2(:, 6));
data2 = data2(time2 >= datetime('2016-06-21') & time2 <= datetime('2016-06-30'), :);

% 从data2中提取数据
province2 = data2(:, 1);
name2 = data2(:, 4);
averagePrice2 = data2(:, 5);
time2 = datetime(data2(:, 6));

% 只计算2016-07-01~2016-07-10的过去10天的平均价格
indexOfOnlyTen = find(date >= datetime('2016-07-01') & date <= datetime('2016-07-10'));

% 计算统计属性
filteredProvince = province(indexOfOnlyTen);
filteredName = name(indexOfOnlyTen);
filteredTime = time(indexOfOnlyTen);
filteredRecentAveragePrice = -ones(length(filteredProvince), 1);
length(filteredProvince)
for i = 1:length(filteredProvince)
    i
    % 过滤掉不同省份和不同农产品的项
    indexOfSameProvinceName = find(cell2mat(province2) == filteredProvince{i} & cell2mat(name2) == filteredName{i});
    if isempty(indexOfSameProvinceName)
        filteredRecentAveragePrice(i) = -1;
        continue;
    end
    
    % 过滤掉过去10天外的项
    lowDate = datetime(filteredTime(i)) - caldays(10);
    highDate = datetime(filteredTime(i)) - caldays(1);
    indexOfRecent = find(time2(indexOfSameProvinceName) >= lowDate & time2(indexOfSameProvinceName) <= highDate);
    if isempty(indexOfRecent)
        filteredRecentAveragePrice(i) = -1;
        continue;
    end
    
    % 计算最近十天平均价格
    tempAveragePrice = averagePrice2(indexOfSameProvinceName);
    filteredRecentAveragePrice(i) = mean(cell2mat(tempAveragePrice(indexOfRecent)));
end

% 填充统计属性
recentAveragePrice = -ones(length(province), 1);
recentAveragePrice(indexOfOnlyTen) = filteredRecentAveragePrice;

%%  =========================== 写出文件 =========================== 

% 将结果写出到"timed_digitized_product_market.csv"文件中
fileID = fopen([outputPath, 'annotated_timed_digitized_filtered_product_market.csv'], 'w');
formatSpec = '%d,%d,%d,%d,%s,%d,%d,%f\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province{row}, market{row}, type{row}, name{row}, time{row}, daysFromNewYear(row), yearFrom2011(row), recentAveragePrice(row));
end
fclose(fileID);

%% =========================== 结束计时 ===========================

toc
