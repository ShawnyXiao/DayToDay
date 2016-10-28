function writeToFileSystemForMapMatrix(path, formatSpec, mapMatrix)
%WRITETOFILESYSTEMFORMAPMATRIX 将映射矩阵写出到文件系统中
%   WRITETOFILESYSTEMFORMAPMATRIX(path, formatSpec, mapMatrix)
%   将映射矩阵mapMatrix，根据格式化要求formatSpec，
%   写出到文件系统中的路径path下。

fileID = fopen(path, 'w');
for row = 1:length(mapMatrix)
    fprintf(fileID, formatSpec, mapMatrix{row, 1}, mapMatrix{row, 2});
end
fclose(fileID);

end

