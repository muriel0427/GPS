function [mean_val, std_dev] = custom_std(data)
    [n,~] = size(data);
    mean_val = mean(data);
    sum_sq_diff = sum((data - mean_val).^2);
    std_dev = sqrt(sum_sq_diff / n);
end