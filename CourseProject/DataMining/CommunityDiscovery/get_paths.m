function path_num = get_paths(adjmat,passed,start,stop)
%GET_PATHS 计算从start到stop的路径数
% adjmat:N*N，表示A点到B点有无连边
% passed:N*1，用于记录所有点是否已经经过
% start:出发点
% stop:终止点
% path_num:N*N，表示从A到B的路径数

% 当出发点和终止点重合时，该DFS分支完成，路径计数+1
if start == stop
    path_num = 1;
    return
end
path_num = 0;
passed(start) = 1;
n = length(passed);
for i = 1:n
    conn = adjmat(start,i);
    % 找到一个可达点且没走过，则进一步递归
    if conn == 1 && passed(i) == 0
        path_num = path_num + get_paths(adjmat,passed,i,stop);
    end
end
end

