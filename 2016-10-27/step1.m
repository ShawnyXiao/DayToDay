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

% ��"farming.csv"�ļ��ж�ȡ����
fileID = fopen('input/farming.csv');
formatSpec = '%s %s %s %s %f %s';
data = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

% ��data����ȡ����
province = data{1};
market = data{2};
type = data{3};
name = data{4};
averagePrice = data{5};
time = data{6};

%% ============================ Ψһ�� ============================

% ��province, market, type, name��Ψһ��
[uniqueProvince, ~, indexOfUniqueProvince] = unique(province);
[uniqueMarket, ~, indexOfUniqueMarket] = unique(market);
[uniqueType, ~, indexOfUniqueType] = unique(type);
[uniqueName, ~, indexOfUniqueName] = unique(name);

%% ======================= ����ӳ�����ӳ����� =======================

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

% ��ӳ����д����"digitized_farming.csv"�ļ���
fileID = fopen([outputPath, 'digitized_farming.csv'], 'w');
formatSpec = '%d,%d,%d,%d,%f,%s\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province{row}, market{row}, type{row}, name{row}, averagePrice(row), time{row});
end
fclose(fileID);

%% =========================== ������ʱ ===========================

toc