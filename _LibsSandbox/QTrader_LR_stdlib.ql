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

// +++ 1.06.2024 +++ A reporter which puts diagnostic info into the log once a candle ++++++++++++++++++++++++++++++
reporter(
		my_step,			// Current my_step number
		my_predict_window_type,	// Signal line predict window type := ("week" || "day" || "candle")
		my_train_window,	// Signal line width of training window in candle number
		my_high_offset,	// Which type of price to take for the high line offset
		my_low_offset,	// Which type of price to take for the low line offset
		my_nextSLlong,	// A current long SL price value
		my_slope_long,	// A current long SL line slope
		my_nextSLshort,	// A current short SL price value
		my_slope_short	// A current SL line slope
		) := 
{
	a = 1n;
	log("step_=;" + my_step 
		+ ";account_=;" + account 
		+ ";equity_=;" + equity 
		+ ";high_=;" + ind("LinearRegression", "line", "high", my_predict_window_type, my_high_offset, my_train_window) 
		+ ";hhigh_=;" + hhigh = ind("LinearRegression", "high", "high", my_predict_window_type, my_high_offset, my_train_window) 
		+ ";lhigh_=;" + ind("LinearRegression", "low", "high", my_predict_window_type, my_high_offset, my_train_window) 
		+ ";high.slope_=;" + ind("LinearRegression", "slope", "high", my_predict_window_type, my_high_offset, my_train_window) 
		+ ";high.mae_=;" + ind("LinearRegression", "mae", "high", my_predict_window_type, my_high_offset, my_train_window) 
		+ ";low_=;" + ind("LinearRegression", "line", "low", my_predict_window_type, my_low_offset, my_train_window)
		+ ";hlow_=;" + ind("LinearRegression", "high", "low", my_predict_window_type, my_low_offset, my_train_window)
		+ ";llow_=;" + llow = ind("LinearRegression", "low", "low", my_predict_window_type, my_low_offset, my_train_window)
		+ ";llow.slope_=;" + ind("LinearRegression", "slope", "low", my_predict_window_type, my_low_offset, my_train_window)
		+ ";llow.mae_=;" + ind("LinearRegression", "mae", "low", my_predict_window_type, my_low_offset, my_train_window)
		+ ";nextSLlong_=;" + my_nextSLlong + ";my_slope_long_=;" + my_slope_long
		+ ";nextSLshort_=;" + my_nextSLshort + ";my_slope_short_=;" + my_slope_short
		+ ";train_window_=;" + my_train_window
		+ ";channel_width_=;" + (hhigh - llow)
	);
	
	result = (my_step + 1n);
	
	~
};
// --- 1.06.2024 --- A reporter which puts diagnostic info into the log once a candle ------------------------------
