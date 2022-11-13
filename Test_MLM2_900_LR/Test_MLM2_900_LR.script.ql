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
expiration_time = 15:00_15.12.22;
	
predict_window_type = "candle"; 
high_offset = "none";
low_offset = "none";

train_window_min_start = 20c;
train_window_min_stop = 200c;
train_window_min_step = 15c;
train_window_max_start = 160c;
train_window_max_stop = 320c;
train_window_max_step = 20c;
train_window_divider_start = 1.0n;
train_window_divider_stop = 2.0n;
train_window_divider_step = 0.1n;

slope_long = 0n;
slope_short = 0n;

predict_window_type_support = "week";
predict_window_type_resistance = "week";
train_window_support = 800c;
train_window_resistance = 800c;

channel_width_min_start = 0p;
channel_width_min_stop = 150p;
channel_width_min_step = 10p;
channel_width_max_start = 150p;
channel_width_max_stop = 250p;
channel_width_max_step = 50p;

log("lots_=;" + lots);
log("expiration_time_=;" + expiration_time);
log("predict_window_type_=;" + predict_window_type);
log("high_offset_=;" + high_offset);
log("train_window_min_start_=;" + train_window_min_start + ";train_window_min_stop_=;" + train_window_min_stop + ";train_window_min_step_=;" + train_window_min_step);
log("train_window_max_start_=;" + train_window_max_start + ";train_window_max_stop_=;" + train_window_max_stop + ";train_window_max_step_=;" + train_window_max_step);
log("train_window_divider_start_=;" + train_window_divider_start + ";train_window_divider_stop_=;" + train_window_divider_stop 
	+ ";train_window_divider_step_=;" + train_window_divider_step);
log("slope_long_=;" + slope_long);
log("slope_short_=;" + slope_short);
log("predict_window_type_support_=;" + predict_window_type_support);
log("predict_window_type_resistance_=;" + predict_window_type_resistance);
log("train_window_support_=;" + train_window_support);
log("train_window_resistance_=;" + train_window_resistance);
log("channel_width_min_start_=;" + channel_width_min_start + ";channel_width_min_stop_=;" + channel_width_min_stop + ";channel_width_min_step_=;" + channel_width_min_step);
log("channel_width_max_start_=;" + channel_width_max_start + ";channel_width_max_stop_=;" + channel_width_max_stop + ";channel_width_max_step_=;" + channel_width_max_step);
// --- parameters -----------------------------------------------------------------------------------------
		
import("%OneDrive%\Documents\My Stocks\Stock\HP-HP\QM_Imit\Strategy Sandbox\strategie_sandbox\LibsSandbox\LR_lib (2).aql");

best_equity = 0p;
best_train_window_min = 0c;
best_train_window_max = 0c;
best_train_window_divider = 0n;
best_channel_width_min = 0p;
best_channel_width_max = 0p;

my_train_window_min = train_window_min_start;
my_train_window_max = train_window_max_start;
my_train_window_divider = train_window_divider_start;
my_channel_width_min = channel_width_min_start;
my_channel_width_max = channel_width_max_start;

count0 = 0i;
..[my_channel_width_min <= channel_width_min_stop]
{
	count1 = 0i;
	..[my_channel_width_max <= channel_width_max_stop]
	{
		count2 = 0i;
		..[my_train_window_divider <= train_window_divider_stop]
		{
			count3 = 0i;
			..[my_train_window_min <= train_window_min_stop]
			{
				count4 = 0i;
				..[my_train_window_max <= train_window_max_stop]
				{
					log("test_starting_history..." 
						+ ";count=;" + count0 + "." + count1 + "." + count2 + "." + count3 + "." + count4
						+ ";equity=;" + equity + ";account=;" + account
						+ ";train_window_min=;" + my_train_window_min + ";train_window_max=;" + my_train_window_max 
						+ ";train_window_divider=;" + my_train_window_divider
						+ ";my_channel_width_min=;" + my_channel_width_min + ";my_channel_width_max=;" + my_channel_width_max
						);
		
					log.level = -1i;
					..[candles.is_calculated != 1n] 
					{
						LR_strategy(
							lots,				// Number of lots to open a position
							expiration_time, 	// Time when to stop the strategy
	
							predict_window_type,	// Signal line predict window type := ("week" || "day" || "candle")
							my_train_window_max,	// Maximum training window size of Signal line in candles
							my_train_window_min,	// Minimum training window size of Signal line in candles
							my_train_window_divider,	// Divider and multiplier to adjust train_window by channel_width value
		
							high_offset,	// Which type of price to take for the high line offset
							low_offset,	// Which type of price to take for the low line offset

							slope_long,	// Starting slope of linear regression for a long position
							slope_short,	// Starting slope of linear regression for a short position

							predict_window_type_support,	// Support line predict window type := ("week" || "day" || "candle")
							train_window_support,		// Support line width of training window in candle number
							predict_window_type_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
							train_window_resistance,	// Resistance line width of training window in candle number

							my_channel_width_max,	// Max edge of channel_width range
							my_channel_width_min	// Min edge of channel_width range
						);
					};
	
					{
						best_equity = equity << equity > best_equity;
						best_train_window_min = my_train_window_min;
						best_train_window_max = my_train_window_max;
						best_train_window_divider = my_train_window_divider;
						best_channel_width_min = my_channel_width_min;
						best_channel_width_max = my_channel_width_max
					||
						best_equity = best_equity << equity <= best_equity
					};
		
					log.level = 0i;
					log("test_history_completed" 
						+ ";count=;" + count0 + "." + count1 + "." + count2 + "." + count3 + "." + count4
						+ ";equity=;" + equity + ";account=;" + account
						+ ";best_equity=;" + best_equity 
						+ ";best_window_min=;" + best_train_window_min + ";best_train_window_max=;" + best_train_window_max 
						+ ";best_train_window_divider=;" + best_train_window_divider
						+ ";best_channel_width_min=;" + best_channel_width_min + ";best_channel_width_max=;" + best_channel_width_max
					);
	
					reset_history();
					my_train_window_max += train_window_max_step;
			
					count4 += 1i;
				};
	
				my_train_window_min += train_window_min_step;
				count3 += 1i;
			};
	
			my_train_window_divider += train_window_divider_step;
			count2 += 1i;
		};
	
		my_channel_width_max += channel_width_max_step;
		count1 += 1i;
	};
	
	my_channel_width_min += channel_width_min_step;
	count0 += 1i;
};

log("test_script_stopped")
