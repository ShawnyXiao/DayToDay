function writeToFileSystemForMapMatrix(path, formatSpec, mapMatrix)
%WRITETOFILESYSTEMFORMAPMATRIX ��ӳ�����д�����ļ�ϵͳ��
%   WRITETOFILESYSTEMFORMAPMATRIX(path, formatSpec, mapMatrix)
%   ��ӳ�����mapMatrix�����ݸ�ʽ��Ҫ��formatSpec��
%   д�����ļ�ϵͳ�е�·��path�¡�

fileID = fopen(path, 'w');
for row = 1:length(mapMatrix)
    fprintf(fileID, formatSpec, mapMatrix{row, 1}, mapMatrix{row, 2});
end
fclose(fileID);

end

