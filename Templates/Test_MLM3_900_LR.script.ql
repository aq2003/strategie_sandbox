// 10.01.2023 17:47:36 Test_MLH3_900_LR ql script
// Created 10.01.2023 17:47:36

// 05.06.2022 9:41:44 Test_MLM2_900_LR ql script
// Created 05.06.2022 9:41:44

// 21.05.2022 11:06:55 Test_SIM2_900_LR ql script
// Created 21.05.2022 11:06:55

// 14.05.2022 15:42:52 Test_SRM2_900_LR ql script
// Created 14.05.2022 15:42:52

// 10.01.2022 8:39:23 SRH2_900_LR ql script
// Created 10.01.2022 8:39:23

// 29.09.2021 8:27:41 GZZ1_900_LR ql script
// Created 29.09.2021 8:27:41

// 30.09.2021 8:26:13 GZZ1_900_LR ql script
// Created 30.09.2021 8:26:13

// 29.09.2021 8:27:41 GZZ1_900_LR ql script
// Created 29.09.2021 8:27:41

// 26.09.2021 18:18:48 SRZ1_900_LR ql script
// Created 26.09.2021 18:18:48

// 07.10.2021 17:14:01 SBER_900_LR ql script
// Created 07.10.2021 17:14:01

// 06.05.2021 10:07:18 SBER_900_LR ql script
// Created 06.05.2021 10:07:18

// 10.04.2021 21:11:55 SRM1_900_LR ql script
// Created 10.04.2021 21:11:55

// 10.04.2021 21:11:55 SRM1_900_LR ql script
// Created 10.04.2021 21:11:55

// 25.03.2021 10:03:22 SRM1_900_7600yup ql script
// Created 25.03.2021 10:03:22

// 19.03.2021 11:42:30 SRH1_900_LR_7600yup ql script
// Created 19.03.2021 11:42:30

// 18.12.2020 10:05:33 SRH1-900-LR ql script
// Created 18.12.2020 10:05:33

// 11.11.2020 9:38:45 SRZ0_900_7600yup ql script
// Created 11.11.2020 9:38:45

// 05.11.2020 10:03:29 MMZ0_1200_7600yup ql script
// Created 05.11.2020 10:03:29

// 05.10.2020 10:10:37 SFZ0_3600_7600yup ql script
// Created 05.10.2020 10:10:37

// 18.09.2020 9:57:55 SRZ0_300_7600r8m ql script
// Created 18.09.2020 9:57:55

// 18.09.2020 9:56:34 SRZ0_300_7600yup ql script
// Created 18.09.2020 9:56:34

// +++ parameters -----------------------------------------------------------------------------------------
lots = 1l;
expiration_time = 15:00_15.12.23;

start_time = 09:00; 
end_time = 23:00; 
day_start_time = 09:00;
	
predict_window = "candle"; 
high_offset = "none";
low_offset = "none";
train_window_start = 10c;
train_window_stop = 300c;
train_window_step = 20%;

slope_long_start = 0n;
slope_long_stop = 20n;
slope_long_step = 2n;
slope_short_start = 0n;
slope_short_stop = 20n;
slope_short_step = 2n;

predict_window_support = "day";
predict_window_resistance = "day";
train_window_support_start = 300c;
train_window_support_stop = 2000c;
train_window_support_step = 100c;
train_window_resistance_start = 300c;
train_window_resistance_stop = 2000c;
train_window_resistance_step = 300c;

channel_width_start = 0p;
channel_width_stop = 300p;
channel_width_step = 50p;

log("lots_=;" + lots);
log("expiration_time_=;" + expiration_time);
log("predict_window_=;" + predict_window);
log("high_offset_=;" + high_offset);
log("train_window_start_=;" + train_window_start);
log("train_window_stop_=;" + train_window_stop);
log("train_window_step_=;" + train_window_step);
log("slope_long_start_=;" + slope_long_start);
log("slope_long_stop_=;" + slope_long_stop);
log("slope_long_step_=;" + slope_long_step);
log("slope_short_start_=;" + slope_short_start);
log("slope_short_stop_=;" + slope_short_stop);
log("slope_short_step_=;" + slope_short_step);
log("predict_window_support_=;" + predict_window_support);
log("predict_window_resistance_=;" + predict_window_resistance);
log("train_window_support_start_=;" + train_window_support_start);
log("train_window_support_stop_=;" + train_window_support_stop);
log("train_window_support_step_=;" + train_window_support_step);
log("train_window_resistance_start_=;" + train_window_resistance_start);
log("train_window_resistance_stop_=;" + train_window_resistance_stop);
log("train_window_resistance_step_=;" + train_window_resistance_step);
log("channel_width_start_=;" + channel_width_start);
log("channel_width_stop_=;" + channel_width_stop);
log("channel_width_step_=;" + channel_width_step);
// --- parameters -----------------------------------------------------------------------------------------
		
import("%OneDrive%\Documents\My Stocks\Stock\HP-HP\QM_Imit\Strategy Sandbox\strategie_sandbox\LibsSandbox\LR_lib.aql");

best_equity = 0p;
best_train_window = 0c;
best_train_window_support = 0c;
best_slope_long_start = 0n;
best_slope_short_start = 0n;
best_channel_width = 0p;

my_slope_long_start = slope_long_start;
my_slope_short_start = slope_short_start;
my_channel_width = channel_width_start;

count2 = 0i;
..[my_channel_width <= channel_width_stop]
{
	my_train_window_support = train_window_support_start;
	my_train_window_resistance = train_window_resistance_start;
	
	count1 = 0i;
	..[my_train_window_support <= train_window_support_stop]
	{
		my_train_window = train_window_start;
		
		count = 0i;
		..[my_train_window <= train_window_stop]
		{
			log("test_starting_history...;count=;" + count2 + "." + count1 + "." + count
				+ ";equity=;" + equity + ";account=;" + account
				+ ";train_window=;" + my_train_window + ";train_window_support=;" + my_train_window_support 
				+ ";my_channel_width=;" + my_channel_width);
		
			log.level = -1i;
			..[candles.is_calculated != 1n] 
			{
				LR_strategy(
					lots, expiration_time,
					start_time, end_time, day_start_time,
					predict_window, my_train_window,
					high_offset, low_offset,
					my_slope_long_start, my_slope_short_start,
					predict_window_support, my_train_window_support,
					predict_window_resistance, my_train_window_resistance,
					my_channel_width
					);
			};
	
			{
				best_equity = equity << equity > best_equity;
				best_train_window = my_train_window;
				best_train_window_support = my_train_window_support;
				best_channel_width = my_channel_width
			||
				best_equity = best_equity << equity <= best_equity
			};
		
			log.level = 0i;
			log("test_history_completed;count=;" + count2 + "." + count1 + "." + count 
				+ ";equity=;" + equity + ";account=;" + account 
				+ ";train_window=;" + my_train_window + ";train_window_support=;" + my_train_window_support 
				+ ";slope_long_start=;" + my_slope_long_start 
				+ ";best_equity=;" + best_equity 
				+ ";best_train_window=;" + best_train_window + ";best_train_window_support=;" + best_train_window_support
				+ ";best_channel_width=;" + best_channel_width);
	
			reset_history();
			my_train_window += train_window_step;
			
			count += 1i;
		};
	
		my_train_window_support += train_window_support_step;
		my_train_window_resistance += train_window_resistance_step;
		count1 += 1i;
	};
	
	my_channel_width += channel_width_step;
	count2 += 1i;
};

log("test_script_stopped")
