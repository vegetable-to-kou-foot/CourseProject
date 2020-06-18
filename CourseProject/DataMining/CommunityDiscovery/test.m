adjmat = [0,1,1,0,1;1,0,0,1,1;1,0,0,0,1;0,1,0,0,1;1,1,1,1,0];
passed = zeros(length(adjmat),1);
path_num = get_paths(adjmat,passed,1,5);
disp(path_num);