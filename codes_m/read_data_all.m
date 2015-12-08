function read_data_all(file_name)
% This function read data from txt file and save data into mat files after 
% data processing.
for k=1:length(file_name)
    cd ../data
    fid = fopen(file_name{k});
    headers = fgetl(fid);
    headers = textscan(headers,'%s','delimiter',';');
    % read data as string
    format = repmat('%s',1,size(headers{1,1},1));
    original_data = textscan(fid,format,'delimiter',';');
    original_data=[original_data{:}];
    row_num=size(original_data,1);
    all_data=[];
    state_name=cell(1,row_num+1);
    sen_name=cell(1,row_num+1);
    for j=1:row_num+1
        if j==1
            line=[headers{:}];
            line=line{1,1};
        else
            line=original_data{j-1,1};
        end
        % numerical data
        cong_num=str2num(line(1:3));
        id_num=str2num(line(4:8));
        state_num=str2num(line(9:10));
        dist_num=str2num(line(12));     
        new_line=line(13:end);
        cd ../codes
        new_index=find_num(new_line);
        party_num=str2num(new_line(new_index(1):new_index(1)+2));
        if j==1 && cong_num~=114
            occu_num=0;
            means_num=0;
            if new_index(end)-1==new_index(end-1)
                n=length(new_line(new_index(end)-2:end));
                sen_name{1,j}=deblank(new_line(new_index(3)+3:new_index(4)-1));
            else
                n=length(new_line(new_index(end):end));
                sen_name{1,j}=deblank(new_line(new_index(1)+5:new_index(end)-1));
            end
        else
            occu_num=str2num(new_line(new_index(1)+3));
            means_num=str2num(new_line(new_index(1)+4));
            n=length(new_line(new_index(end):end));
            sen_name{1,j}=deblank(new_line(new_index(1)+5:new_index(end)-1));
        end
        vote=zeros(1,n);
          for i=1:n
              vote(i)=str2num(new_line(end-n+i));
          end
        all_data=[all_data;cong_num id_num state_num dist_num party_num occu_num means_num vote];
        state_name{1,j}=deblank(new_line(1:new_index(1)-1));
    end
    data_name=strcat('senate_',num2str(cong_num));
    data=cell(2,1);
    data{1,1}=all_data;
    data{2,1}=sen_name;
    cd ../data
    save(data_name,'data');
end
cd ../codes

    