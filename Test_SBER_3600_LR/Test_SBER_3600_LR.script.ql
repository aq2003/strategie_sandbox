// 23.03.2024 12:39:51 Test_SBER_3600_LR ql script
// Created 23.03.2024 12:39:51

// 24.12.2023 20:18:35 Test_MGNT_3600_LR ql script
// Created 24.12.2023 20:18:35

// 10.12.2023 11:09:39 Test_MNZ3_3600_LR3 ql script
// Created 10.12.2023 11:09:39

// 25.11.2023 10:50:28 Test_MNZ3_900_LR ql script
// Created 25.11.2023 10:50:28

// 07.10.2023 19:33:19 Test_GZZ3_900_LR ql script
// Created 07.10.2023 19:33:19

// 13.01.2023 8:16:03 Test_GZH3_900_LR ql script
// Created 13.01.2023 8:16:03

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
lots = 830450p;
safety_stock = 5%;	// Safety stock in percents to the equity
risk_L = 17%;		// Risk rate in percents for long positions
risk_S = 17%;		// Risk rate in percents for short positions

expiration_time = 15:00_15.12.24;
day_start_time = 10:00;
base_log_level = "Error";
	
predict_window = "candle"; 
high_offset = "none";
low_offset = "none";
train_window_start = 50c;
train_window_stop = 300c;
train_window_step = 10%;

slope_long_start = 0n;
slope_long_stop = 0n;
slope_long_step = 0n;
slope_short_start = 0n;
slope_short_stop = 0n;
slope_short_step = 0n;

slope_long_level_start = -5n;
slope_long_level_stop = 0n;
slope_long_level_step = 0.5n;
slope_short_level_start = 0n;
slope_short_level_stop = 5n;
slope_short_level_step = 0.5n;

predict_window_support = "week";
predict_window_resistance = "week";
train_window_support_start = 300c;
train_window_support_stop = 2000c;
train_window_support_step = 10%;
train_window_resistance_start = 300c;
train_window_resistance_stop = 2000c;
train_window_resistance_step = 10%;

channel_width_start = 0p;
channel_width_stop = 300p;
channel_width_step = 50p;

// target_type := ("best_equity" || "equity_closest_to_max_equity")
target_type = "best_equity";
// --- parameters -----------------------------------------------------------------------------------------
		
Test_LR_strategy_SlopeLevel_path = "%OneDrive%\Documents\My Stocks\Stock\HP-HP\QM_Imit\Strategy Sandbox\strategie_sandbox\LibsSandbox\Test_LR_strategy_SlopeLevel_AdaptiveLots.aql";

import(Test_LR_strategy_SlopeLevel_path);

best_equity = 0p;
best_max_equity = 0p;
best_train_window = 0c;
best_train_window_support = 0c;
best_slope_long = 0n;
best_slope_short = 0n;
best_slope_long_level = 0n;
best_slope_short_level = 0n;
best_channel_width = 0p;

log("1st_turn");
Test_LR_strategy_SlopeLevel_AdaptiveLots(
	safety_stock,	// Safety stock in percents to the equity
	risk_L,		// Risk rate in percents for long positions
	risk_S,		// Risk rate in percents for short positions
	expiration_time, // = 15:00_15.12.23;
	
	predict_window, // = "candle"; 
	high_offset, // = "none";
	low_offset, // = "none";
	train_window_start, // = 25c;
	train_window_stop, // = 300c;
	train_window_step, // = 20%;

	slope_long_stop, // = 0n;
	slope_long_stop, // = 20n;
	slope_long_step, // = 2n;
	slope_short_stop, // = 0n;
	slope_short_stop, // = 20n;
	slope_short_step, // = 2n;

	slope_long_level_start, // = -10n;
	slope_long_level_start, // = 0n;
	slope_long_level_step, // = 1n;
	slope_short_level_stop, // = 10n;
	slope_short_level_stop, // = 0n;
	slope_short_level_step, // = -1n;

	predict_window_support, // = "week";
	predict_window_resistance, // = "week";
	train_window_support_start, // = 300c;
	train_window_support_stop, // = 2000c;
	train_window_support_step, // = 20%;
	train_window_resistance_start, // = 300c;
	train_window_resistance_stop, // = 2000c;
	train_window_resistance_step, // = 20%;

	channel_width_start, // = 0p;
	channel_width_start, // = 300p;
	channel_width_step, // = 50p;
	
	"best_equity", // target_type := ("best_equity", "equity_closest_to_max_equity")
	
	day_start_time,
	
	base_log_level
);

log("2nd_turn");

Test_LR_strategy_SlopeLevel_AdaptiveLots(
	safety_stock,	// Safety stock in percents to the equity
	risk_L,		// Risk rate in percents for long positions
	risk_S,		// Risk rate in percents for short positions
	expiration_time, // = 15:00_15.12.23;
	
	predict_window, // = "candle"; 
	high_offset, // = "none";
	low_offset, // = "none";
	best_train_window, // = 25c;
	best_train_window, // = 300c;
	train_window_step, // = 20%;

	slope_long_start, // = 0n;
	slope_long_stop, // = 20n;
	slope_long_step, // = 2n;
	slope_short_start, // = 0n;
	slope_short_stop, // = 20n;
	slope_short_step, // = 2n;

	slope_long_level_start, // = -10n;
	slope_long_level_stop, // = 0n;
	slope_long_level_step, // = 1n;
	slope_short_level_start, // = 10n;
	slope_short_level_stop, // = 0n;
	slope_short_level_step, // = -1n;

	predict_window_support, // = "week";
	predict_window_resistance, // = "week";
	best_train_window_support, // = 300c;
	best_train_window_support, // = 2000c;
	train_window_support_step, // = 20%;
	best_train_window_support, // = 300c;
	best_train_window_support, // = 2000c;
	train_window_resistance_step, // = 20%;

	channel_width_start, // = 0p;
	channel_width_stop, // = 300p;
	channel_width_step, // = 50p;
	
	"equity_closest_to_max_equity", // target_type := ("best_equity", "equity_closest_to_max_equity")
	
	day_start_time
)

