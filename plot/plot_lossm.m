load navigation_data_final_findsat_with_loop.mat
   
datetime_array = datetime(data_all(:,1:6));


figure;
hold on;
plot(datetime_array, data_all(:,11) , 'rx','MarkerSize', 0.1); 
title('NCUS4 Position loss value per sceond .')
xlabel('Date(YYYY-MM)');
ylabel('loss(m)');
start_date = min(datetime_array(data_all(:,11) ~= 0));
end_date = max(datetime_array(data_all(:,11) ~= 0));
xlim([start_date, end_date]);
datetick('x', 'yyyy-mm','keeplimits', 'keepticks');
hold off;
