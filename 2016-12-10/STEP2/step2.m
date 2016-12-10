%% =========================== ��ʼ��ʱ ===========================

tic

%% =========================== ��ʼ���� ===========================

% ��չ����������������Ļ
clear
clc

%   ��������ļ����Ŀ¼
outputPath = 'output/';
if ~isdir(outputPath)
    mkdir(outputPath);
end

%% =========================== ��ȡ���� =========================== 

% ��"filtered_farming.csv"�ļ��ж�ȡ����
fileID = fopen('input/filtered_farming.csv', 'r', 'n', 'UTF-8');
formatSpec = '%s %s %s %s %*s %*s %*s %*s %*s %f %*s %*s %s';
originData = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

%% =========================== �������� =========================== 

% ��ʽ��data
data = cell(length(originData{1}), 6);
for i = 1:6
    if i == 5
        data(:, i) = num2cell(originData{i});
        continue;
    end
    data(:, i) = originData{i};
end

% ��data����
[~, dataIndex] = sortrows([data(:, 1), data(:, 2), data(:, 3), data(:, 4), num2cell(datenum(data(:, 6), 'yyyy-mm-dd'))], [1, 2, 3, 4, 5]);
data = data(dataIndex, :);

% ��data����ȡ����
province = data(:, 1);
market = data(:, 2);
type = data(:, 3);
name = data(:, 4);
averagePrice = data(:, 5);
time = data(:, 6);

%% ============================ Ψһ�� ============================

% ��province, market, type, name��Ψһ��
[uniqueProvince, ~, indexOfUniqueProvince] = unique(province);
[uniqueMarket, ~, indexOfUniqueMarket] = unique(market);
[uniqueType, ~, indexOfUniqueType] = unique(type);
[uniqueName, ~, indexOfUniqueName] = unique(name);

%% ======================= ����ӳ���ӳ����� =======================

% ����province, market, type, name��ӳ����󣺵�һ��Ϊ�����ڶ���Ϊֵ����Ȼ����
mapMatrixOfProvince = [uniqueProvince, num2cell([0 : (length(uniqueProvince) - 1)]')];
mapMatrixOfMarket = [uniqueMarket, num2cell([0 : (length(uniqueMarket) - 1)]')];
mapMatrixOfType = [uniqueType, num2cell([0 : (length(uniqueType) - 1)]')];
mapMatrixOfName = [uniqueName, num2cell([0 : (length(uniqueName) - 1)]')];

% ��ӳ�����д�����ļ�ϵͳ��
formatSpec = '%s,%d\n';
writeToFileSystemForMapMatrix([outputPath, 'province_map.csv'], formatSpec, mapMatrixOfProvince);
writeToFileSystemForMapMatrix([outputPath, 'market_map.csv'], formatSpec, mapMatrixOfMarket);
writeToFileSystemForMapMatrix([outputPath, 'type_map.csv'], formatSpec, mapMatrixOfType);
writeToFileSystemForMapMatrix([outputPath, 'name_map.csv'], formatSpec, mapMatrixOfName);

%% ========================== ִ��ӳ����� ==========================

% ����ӳ����󣬶�province, market, type, nameִ��ӳ�������ӳ��Ϊ��Ȼ��
province = mapMatrixOfProvince(indexOfUniqueProvince, 2);
market = mapMatrixOfMarket(indexOfUniqueMarket, 2);
type = mapMatrixOfType(indexOfUniqueType, 2);
name = mapMatrixOfName(indexOfUniqueName, 2);

% ��ӳ����д����"digitized_filtered_farming.csv"�ļ���
fileID = fopen([outputPath, 'digitized_filtered_farming.csv'], 'w', 'n', 'UTF-8');
formatSpec = '%d,%d,%d,%d,%f,%s\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province{row}, market{row}, type{row}, name{row}, averagePrice{row}, time{row});
end
fclose(fileID);

%% =========================== ������ʱ ===========================

toc
