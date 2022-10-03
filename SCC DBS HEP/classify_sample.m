function [range] = classify_sample(ECGmat, isCondition, comments)
    %set starting and ending sample range
    range = ones(length(isCondition),2);
    isCondition; %contains locations in comments array for conditions
    for i = 1:length(isCondition)
        idx = isCondition(i);
        range(i,1) = comments.(idx){2}; %starting sample
        if i == length(isCondition)
            range(i,2) = length(ECGmat); %last matrix
        else
            idx = isCondition(i+1);
            range(i,2) = comments.(idx){2}-1;%ending sample is next condition -1;; comments(2,i+1)-1;
        end
    end
end