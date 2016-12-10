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
fileID = fopen('input/farming.csv', 'r', 'n', 'UTF-8');
formatSpec = '%s %s %s %s %s %s %s %s %s %s %s %s %s';
originData = textscan(fileID, formatSpec, 'Delimiter', ',');
fclose(fileID);

%% =========================== �������� =========================== 

% ��originData����ȡ����
time = originData{13};
date = datetime(time);

%% =========================== ȥ������ =========================== 

% ֻ����3��-11�µ����ݣ�
month = month(date);
index = find(month >= 3 & month <= 11);

%% =========================== д������ ===========================

% ��ӳ����д����"filtered_farming.csv"�ļ���
fileID = fopen([outputPath, 'filtered_farming.csv'], 'w', 'n', 'UTF-8');
formatSpec = '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n';
for row = index'
    fprintf(fileID, formatSpec, originData{1}{row}, originData{2}{row}, originData{3}{row}, originData{4}{row}, originData{5}{row}, originData{6}{row}, originData{7}{row}, originData{8}{row}, originData{9}{row}, originData{10}{row}, originData{11}{row}, originData{12}{row}, originData{13}{row});
end
fclose(fileID);

%% =========================== ������ʱ ===========================

toc
