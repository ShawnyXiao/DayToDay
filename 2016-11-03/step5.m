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
fileID = fopen('input/product_market.csv', 'r', 'n', 'UTF-8');
formatSpec = '%s %s %s %s %*s %*s %*s %*s %*s %s';
originData = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

% ��"map_matrix.mat"�ļ��ж�ȡ����
load('input/map_matrix.mat');

%% =========================== �������� =========================== 

% ��ʽ��data
data = cell(length(originData{1}), 5);
for i = 1:5
    data(:, i) = originData{i};
end

% ��data����ȡ����
province = data(:, 1);
market = data(:, 2);
type = data(:, 3);
name = data(:, 4);
time = data(:, 5);

%% ========================== ����ӳ��� ==========================

% ����ӳ���
mapOfProvince = containers.Map(mapMatrixOfProvince(:, 1), mapMatrixOfProvince(:, 2));
mapOfMarket = containers.Map(mapMatrixOfMarket(:, 1), mapMatrixOfMarket(:, 2));
mapOfType = containers.Map(mapMatrixOfType(:, 1), mapMatrixOfType(:, 2));
mapOfName = containers.Map(mapMatrixOfName(:, 1), mapMatrixOfName(:, 2));

%% =========================== ӳ������ =========================== 

% ��province, market, type, name��Ψһ��
[uniqueProvince, ~, indexOfUniqueProvince] = unique(province);
[uniqueMarket, ~, indexOfUniqueMarket] = unique(market);
[uniqueType, ~, indexOfUniqueType] = unique(type);
[uniqueName, ~, indexOfUniqueName] = unique(name);

% ΪΨһ������ִ��ӳ�����
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

% �滻ԭʼ����Ϊ��Ȼ��
province = uniqueProvince(indexOfUniqueProvince);
market = uniqueMarket(indexOfUniqueMarket);
type = uniqueType(indexOfUniqueType);
name = uniqueName(indexOfUniqueName);

%% ======================= �������Ԫ�������� ======================= 

% ������ǰ���ں�Ԫ�����ڱ���
date = datetime(time);
dateOfNewYear = datetime(ymd(date), 1, 1);

% ��������
daysFromNewYear = hours(date - dateOfNewYear) ./ 24;

%% ====================== �������ũ����������� ====================== 

% ����ӳ���
mapOfChineseNewYear = containers.Map;

% Ϊӳ������ӳ��ԣ���Ϊ�ֵ꣬Ϊũ�����������
mapOfChineseNewYear('2015') = datetime('2015/2/19');
mapOfChineseNewYear('2016') = datetime('2016/2/8');

% ��������
[uniqueYear, ~, indexOfUniqueYear] = unique(ymd(date));
for row = 1:length(uniqueYear)
    dateOfChineseNewYearOfUniqueYear(row, 1) = mapOfChineseNewYear(char(string(uniqueYear(row))));
end
daysFromChineseNewYear = hours(date - dateOfChineseNewYearOfUniqueYear(indexOfUniqueYear)) ./ 24;

% ������������������С��0�ģ�
for row = 1:length(uniqueYear)
    dateOfChineseNewYearOfUniqueYear(row, 1) = mapOfChineseNewYear(char(string(uniqueYear(row) - 1)));
end
wrongPositon = daysFromChineseNewYear < 0;
daysForWrongElement = hours(date - dateOfChineseNewYearOfUniqueYear(indexOfUniqueYear)) ./ 24;
daysFromChineseNewYear(wrongPositon) = daysForWrongElement(wrongPositon);

%%  =========================== д���ļ� =========================== 

% �����д����"timed_digitized_product_market.csv"�ļ���
fileID = fopen([outputPath, 'timed_digitized_product_market.csv'], 'w');
formatSpec = '%d,%d,%d,%d,%s,%d,%d\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province{row}, market{row}, type{row}, name{row}, time{row}, daysFromNewYear(row), daysFromChineseNewYear(row));
end
fclose(fileID);

%% =========================== ������ʱ ===========================

toc
