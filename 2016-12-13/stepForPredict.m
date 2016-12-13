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
fileID = fopen('input/simulate/product_market.csv', 'r', 'n', 'UTF-8');
formatSpec = '%s %s %s %s %s';
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
for i = 1:(length(uniqueProvince)-1)
    uniqueProvince{i} = mapOfProvince(uniqueProvince{i});
end
uniqueProvince{end} = mapOfProvince('�½�');
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

%% =================== ���㣨����Ԫ�������������-2011�� =================== 

% ������ǰ���ں�Ԫ�����ڱ���
date = datetime(time);
dateOfNewYear = datetime(ymd(date), 1, 1);

% ��������
daysFromNewYear = hours(date - dateOfNewYear) ./ 24;

% ���������2011�Ĳ�
yearFrom2011 = year(date) - 2011;

%% ========================== ����ͳ������ ========================== 

% ��"timed_digitized_filtered_farming.csv"�ļ��ж�ȡ����
fileID = fopen('input/simulate/annotated_timed_digitized_filtered_farming.csv', 'r', 'n', 'UTF-8');
formatSpec = '%d %d %d %d %f %s %*d %*d %*f';
originData2 = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

% ��ʽ��data2
data2 = cell(length(originData2{1}), 6);
for i = 1:5
    data2(:, i) = num2cell(originData2{i});
end
data2(:, 6) = originData2{6};

% ȥ��2016-06-21~2016-06-30���������
time2 = datetime(data2(:, 6));
data2 = data2(time2 >= datetime('2016-06-21') & time2 <= datetime('2016-06-30'), :);

% ��data2����ȡ����
province2 = data2(:, 1);
name2 = data2(:, 4);
averagePrice2 = data2(:, 5);
time2 = datetime(data2(:, 6));

% ֻ����2016-07-01~2016-07-10�Ĺ�ȥ10���ƽ���۸�
indexOfOnlyTen = find(date >= datetime('2016-07-01') & date <= datetime('2016-07-10'));

% ����ͳ������
filteredProvince = province(indexOfOnlyTen);
filteredName = name(indexOfOnlyTen);
filteredTime = time(indexOfOnlyTen);
filteredRecentAveragePrice = -ones(length(filteredProvince), 1);
length(filteredProvince)
for i = 1:length(filteredProvince)
    i
    % ���˵���ͬʡ�ݺͲ�ͬũ��Ʒ����
    indexOfSameProvinceName = find(cell2mat(province2) == filteredProvince{i} & cell2mat(name2) == filteredName{i});
    if isempty(indexOfSameProvinceName)
        filteredRecentAveragePrice(i) = -1;
        continue;
    end
    
    % ���˵���ȥ10�������
    lowDate = datetime(filteredTime(i)) - caldays(10);
    highDate = datetime(filteredTime(i)) - caldays(1);
    indexOfRecent = find(time2(indexOfSameProvinceName) >= lowDate & time2(indexOfSameProvinceName) <= highDate);
    if isempty(indexOfRecent)
        filteredRecentAveragePrice(i) = -1;
        continue;
    end
    
    % �������ʮ��ƽ���۸�
    tempAveragePrice = averagePrice2(indexOfSameProvinceName);
    filteredRecentAveragePrice(i) = mean(cell2mat(tempAveragePrice(indexOfRecent)));
end

% ���ͳ������
recentAveragePrice = -ones(length(province), 1);
recentAveragePrice(indexOfOnlyTen) = filteredRecentAveragePrice;

%%  =========================== д���ļ� =========================== 

% �����д����"timed_digitized_product_market.csv"�ļ���
fileID = fopen([outputPath, 'annotated_timed_digitized_filtered_product_market.csv'], 'w');
formatSpec = '%d,%d,%d,%d,%s,%d,%d,%f\n';
for row = 1:length(province)
    fprintf(fileID, formatSpec, province{row}, market{row}, type{row}, name{row}, time{row}, daysFromNewYear(row), yearFrom2011(row), recentAveragePrice(row));
end
fclose(fileID);

%% =========================== ������ʱ ===========================

toc
