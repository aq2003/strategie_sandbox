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
expiration_time = 15:00_15.09.22;
	
predict_window = "candle"; 
train_window = 35c;
high_offset = "none";
low_offset = "none";

slope_long_start = 0n;
slope_short_start = 0n;

predict_window_support = "week";
train_window_support = 300c;
predict_window_resistance = "week";
train_window_resistance = 300c;

channel_width = /*950*/0p;
// --- parameters -----------------------------------------------------------------------------------------
		
import("%OneDrive%\Documents\My Stocks\Stock\AQ-SERVER\QM_Imit\SRM2_900_LR\LR_lib.aql");

best_equity = 0p;
best_train_window = 0c;
best_train_window_support = 0c;
best_slope_long_start = 0n;
best_slope_short_start = 0n;

my_slope_long_start = slope_long_start;
my_slope_short_start = slope_short_start;

count2 = 0i;
..[my_slope_long_start < 30n]
{
	my_train_window_support = train_window_support;
	my_train_window_resistance = train_window_resistance;
	
	count1 = 0i;
	..[my_train_window_support <= 2000c]
	{
		my_train_window = train_window;
		
		count = 0i;
		..[my_train_window <= 300c]
		{
			log("test_starting_history...;count=;" + count2 + "." + count1 + "." + count 
				+ ";train_window=;" + my_train_window + ";train_window_support=;" + my_train_window_support 
				+ ";slope_long_start=;" + my_slope_long_start);
		
			log.level = -1i;
			..[candles.is_calculated != 1n] 
			{
				LR_strategy(
					lots, expiration_time,
					predict_window, my_train_window,
					high_offset, low_offset,
					my_slope_long_start, my_slope_short_start,
					predict_window_support, my_train_window_support,
					predict_window_resistance, my_train_window_resistance,
					channel_width
					);
			};
	
			{
				best_equity = equity << equity > best_equity;
				best_train_window = my_train_window;
				best_train_window_support = my_train_window_support;
				best_slope_long_start = my_slope_long_start
			||
				best_equity = best_equity << equity <= best_equity
			};
		
			log.level = 0i;
			log("test_history_completed;count=;" + count2 + "." + count1 + "." + count 
				+ ";equity=;" + equity 
				+ ";train_window=;" + my_train_window + ";train_window_support=;" + my_train_window_support 
				+ ";slope_long_start=;" + my_slope_long_start 
				+ ";best_equity=;" + best_equity 
				+ ";best_train_window=;" + best_train_window + ";best_train_window_support=;" + best_train_window_support
				+ ";best_slope_long_start=;" + best_slope_long_start);
	
			reset_history();
			my_train_window += 15c;
			
			count += 1i;
		};
	
		my_train_window_support += 100c;
		my_train_window_resistance += 100c;
		count1 += 1i;
	};
	
	my_slope_long_start += 1n;
	my_slope_short_start -= 1n;
	count2 += 1i;
};

log("test_script_stopped")
