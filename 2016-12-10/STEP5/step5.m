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

% ��"digitized_filtered_farming.csv"�ļ��ж�ȡ����
fileID = fopen('input/digitized_filtered_farming.csv', 'r', 'n', 'UTF-8');
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

%% ================== ���㣨����Ԫ�������������-2011�� ================== 

% ������ǰ���ں�Ԫ�����ڱ���
date = datetime(time);
dateOfNewYear = datetime(ymd(date), 1, 1);

% �������Ԫ��������
daysFromNewYear = hours(date - dateOfNewYear) ./ 24;

% ���������2011�Ĳ�
yearFrom2011 = year(date) - 2011;

%% ========================== д������ ========================== 

% �����д����"timed_digitized_filtered_farming.csv"�ļ���
fileID = fopen([outputPath, 'timed_digitized_filtered_farming.csv'], 'w', 'n', 'UTF-8');
formatSpec = '%d,%d,%d,%d,%f,%s,%d,%d\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province(row), market(row), type(row), name(row), averagePrice(row), time{row}, daysFromNewYear(row), yearFrom2011(row));
end
fclose(fileID);

%% ========================== ������ʱ ========================== 

toc