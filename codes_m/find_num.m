function index=find_num(string_vec)
% This is a support function for read_data_all
% find 1st and 6th 
index=[];
c=1;
i=1;
while c<=6
    if(~isspace(str2num(string_vec(i))))
        index=[index;i];
        c=c+1;
    end
    i=i+1;
end
