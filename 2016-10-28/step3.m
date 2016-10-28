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
fileID = fopen('input/digitized_farming.csv');
formatSpec = '%d %d %d %d %f %s';
data = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

% ��data����ȡ����
province = data{1};
market = data{2};
type = data{3};
name = data{4};
averagePrice = data{5};
time = data{6};

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

% �����д����"timed_digitized_farming.csv"�ļ���
fileID = fopen([outputPath, 'timed_digitized_farming.csv'], 'w');
formatSpec = '%d,%d,%d,%d,%f,%d,%d\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province(row), market(row), type(row), name(row), averagePrice(row), daysFromNewYear(row), daysFromChineseNewYear(row));
end
fclose(fileID);

%% ========================== ������ʱ ========================== 

toc