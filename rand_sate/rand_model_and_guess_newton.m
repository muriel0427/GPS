num_sate = 8;

[sate_position, receiver_position] = rand_sate_wgs84(num_sate);

[obsPos] = guess_n(receiver_position, sate_position, num_sate);