function path_num = get_paths(adjmat,passed,start,stop)
%GET_PATHS �����start��stop��·����
% adjmat:N*N����ʾA�㵽B����������
% passed:N*1�����ڼ�¼���е��Ƿ��Ѿ�����
% start:������
% stop:��ֹ��
% path_num:N*N����ʾ��A��B��·����

% �����������ֹ���غ�ʱ����DFS��֧��ɣ�·������+1
if start == stop
    path_num = 1;
    return
end
path_num = 0;
passed(start) = 1;
n = length(passed);
for i = 1:n
    conn = adjmat(start,i);
    % �ҵ�һ���ɴ����û�߹������һ���ݹ�
    if conn == 1 && passed(i) == 0
        path_num = path_num + get_paths(adjmat,passed,i,stop);
    end
end
end

