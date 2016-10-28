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
fileID = fopen('input/farming.csv');
formatSpec = '%s %s %s %s %f %s';
data = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

% 从data中提取数据
province = data{1};
market = data{2};
type = data{3};
name = data{4};
averagePrice = data{5};
time = data{6};

%% ============================ 唯一化 ============================

% 对province, market, type, name做唯一化
[uniqueProvince, ~, indexOfUniqueProvince] = unique(province);
[uniqueMarket, ~, indexOfUniqueMarket] = unique(market);
[uniqueType, ~, indexOfUniqueType] = unique(type);
[uniqueName, ~, indexOfUniqueName] = unique(name);

%% ======================= 构建映射表（映射矩阵） =======================

% 构建province, market, type, name的映射矩阵：第一列为键，第二列为值（自然数）
mapMatrixOfProvince = [uniqueProvince, num2cell([0 : (length(uniqueProvince) - 1)]')];
mapMatrixOfMarket = [uniqueMarket, num2cell([0 : (length(uniqueMarket) - 1)]')];
mapMatrixOfType = [uniqueType, num2cell([0 : (length(uniqueType) - 1)]')];
mapMatrixOfName = [uniqueName, num2cell([0 : (length(uniqueName) - 1)]')];

% 将映射矩阵写出到文件系统中
formatSpec = '%s,%d\n';
writeToFileSystemForMapMatrix([outputPath, 'province_map.csv'], formatSpec, mapMatrixOfProvince);
writeToFileSystemForMapMatrix([outputPath, 'market_map.csv'], formatSpec, mapMatrixOfMarket);
writeToFileSystemForMapMatrix([outputPath, 'type_map.csv'], formatSpec, mapMatrixOfType);
writeToFileSystemForMapMatrix([outputPath, 'name_map.csv'], formatSpec, mapMatrixOfName);

%% ========================== 执行映射操作 ==========================

% 根据映射矩阵，对province, market, type, name执行映射操作，映射为自然数
province = mapMatrixOfProvince(indexOfUniqueProvince, 2);
market = mapMatrixOfMarket(indexOfUniqueMarket, 2);
type = mapMatrixOfType(indexOfUniqueType, 2);
name = mapMatrixOfName(indexOfUniqueName, 2);

% 将映射结果写出到"digitized_farming.csv"文件中
fileID = fopen([outputPath, 'digitized_farming.csv'], 'w');
formatSpec = '%d,%d,%d,%d,%f,%s\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province{row}, market{row}, type{row}, name{row}, averagePrice(row), time{row});
end
fclose(fileID);

%% =========================== 结束计时 ===========================

toc
