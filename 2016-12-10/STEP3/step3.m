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

% ��"timed_digitized_filtered_farming.csv"�ļ��ж�ȡ����
fileID = fopen('input/timed_digitized_filtered_farming.csv', 'r', 'n', 'UTF-8');
formatSpec = '%d %d %d %d %f %s %d %d';
data = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

% ��data����ȡ����
province = data{1};
name = data{4};
averagePrice = data{5};
time = data{6};
provinceName = [province, name];

%% ================= ����ͳ�����ԣ���ʡ��ũ��Ʒ����ƽ���۸� ================= 

% ����ͳ������
recentAveragePrice = zeros(length(province), 1);

% ����ͳ������
[uniqueProvinceName, indexOfUniqueProvinceName, indexOfProvinceName] = unique(provinceName, 'rows');
length(uniqueProvinceName)
for i = 1:length(uniqueProvinceName)
    i
    indexOfSameProvinceName = find(indexOfProvinceName == i);
    timeForSameProvinceName = datetime(time(indexOfSameProvinceName, :));
    for j = 1:length(indexOfSameProvinceName)
        lowDate = timeForSameProvinceName(j) - caldays(10);
        highDate = timeForSameProvinceName(j) - caldays(1);
        index = find(timeForSameProvinceName >= lowDate & timeForSameProvinceName <= highDate);
        if isempty(index)
            recentAveragePrice(indexOfSameProvinceName(j)) = averagePrice(indexOfSameProvinceName(j));
            continue;
        end
        recentAveragePrice(indexOfSameProvinceName(j)) = mean(averagePrice(indexOfSameProvinceName(index)));
    end
end

%% ========================== д������ ========================== 

% �����д����"annotated_timed_digitized_filtered_farming.csv"�ļ���
fileID = fopen([outputPath, 'annotated_timed_digitized_filtered_farming.csv'], 'w', 'n', 'UTF-8');
formatSpec = '%d,%d,%d,%d,%f,%s,%d,%d,%f\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province(row), data{2}(row), data{3}(row), name(row), averagePrice(row), time{row}, data{7}(row), data{8}(row), recentAveragePrice(row));
end
fclose(fileID);

%% ========================== ������ʱ ========================== 

toc