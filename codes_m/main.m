% The main file
start_cong=111;
end_cong=114;
file_name=cell(1,end_cong-start_cong+1);
for i=1:(end_cong-start_cong+1)
    file_name{i}=strcat('sen',num2str(i+start_cong-1),'kh.ord');
end
read_data_all(file_name);

cd ../data
% Load and process states' names
fid=fopen('states.txt');
datacell = textscan(fid, '%s%s','delimiter', '\b');
fclose(fid);
states = datacell{1};
states_code = [];
states_name = cell(1,length(states)+1);
for i = 1:length(states)
    line = A{i};
    states_code = [states_code str2num(line(1:2))];
    states_name{i}=line(4:5);
end
states_name {length(states)+1} = 'USA';
states_code = [states_code 99];

for i = 111:114
    mat_name=strcat('senate_',num2str(i),'.mat');
    new_name=strcat('new_senate_',num2str(i),'.mat');
    load(mat_name,'data');
    all_data=data{1};
    [m n]=size(all_data);
    for j = 8:n
        vec = all_data(:,j);
        indx_1 = find(vec<4 & vec >0);
        indx_0 = find(6<vec | vec <1);
        indx_n_1 = find(vec>3 & vec <7);
        all_data(indx_1,j) = 1;
        all_data(indx_0,j) = 0;
        all_data(indx_n_1,j) = -1;
    end
    new_data = cell(2,1);
    new_data{1} = all_data;
    sen_names = data{2};
    new_sen_names = cell(1,length(sen_names));
    for j = 1:length(sen_names)
        state_tmp = states_name{find(states_code==all_data(j,3))};
        if all_data(j,5) == 100
            party = 'D';
        elseif all_data(j,5) == 200
            party = 'R';
        else
            party = 'I';
        end
        new_sen_names{j} = strcat(sen_names{j},32,'(',party,'-',state_tmp,')');
    end
    new_data{2} = new_sen_names; 
    save(new_name,'new_data');
end
cd ../codes
        
    