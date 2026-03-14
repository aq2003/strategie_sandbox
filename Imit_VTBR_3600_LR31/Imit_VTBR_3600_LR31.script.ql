// 14.02.2026 9:47:02 Imit_VTBR_3600_LR31 ql script
// Created 14.02.2026 9:47:02

// 06.02.2026 20:47:41 Imit_VTBR_3600_LR ql script
// Created 06.02.2026 20:47:41

// 23.12.2024 10:37:21 VTBR_3600_LR ql script
// Created 23.12.2024 10:37:21

// 11.02.2024 21:44:00 MGNT_3600_LR ql script
// Created 11.02.2024 21:44:00

// 08.10.2023 16:56:01 SRZ3_900_LR ql script
// Created 08.10.2023 16:56:01

// 10.01.2023 14:10:50 GZH3_900_LR ql script
// Created 10.01.2023 14:10:50

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
//imitator.commission = 0.056%;
//imitator.credit = 20.35%;

safety_stock = 5%;	// Safety stock in percents to the equity
risk_L = 25%;		// Risk rate in percents for long positions
risk_S = 25%;		// Risk rate in percents for short positions

expiration_time = 15:00_30.12.26;

day_start_time = 07:00;	// Start time of the day trading session
day_end_time = 19:00;	// End time of the day trading session
night_start_time = 19:10;	// Start time of the night trading session
night_end_time = 23:49;	// End time of the night trading session

// VTBR-01.02.25		170c		1870c		0,0104n		-0,052n		-0,13n		0,13n		-1c			503 453,70p		279386,6388
	
//  A_channel:
A_train_window_period = 300c; // a number of candles in history to train the model on
A_predict_window_type = "candle"; // a period of time in the future for forecasting := ("candle" || "day" || "week")
A_high_price_type = "high"; // type of price as base for the high channel's border := (open || close || high || low)
A_low_price_type = "low"; // type of price as base for the low channel's border := (open || close || high || low)
A_high_offset_type = "none"; // := ("high" || "low" || "none")
A_low_offset_type = "none"; // := ("high" || "low" || "none")
	
//  B_channel:
B_train_window_period = 1800c; // a number of candles in history to train the model on
B_predict_window_type = "week"; // a period of time in the future for forecasting := ("candle" || "day" || "week")
B_high_price_type = "high"; // type of price as base for the high channel's border := (open || close || high || low)
B_low_price_type = "low"; // type of price as base for the low channel's border := (open || close || high || low)
B_high_offset_type = "high"; //:= ("high" || "low" || "none")
B_low_offset_type = "low"; //:= ("high" || "low" || "none")
	
//  long_opening:
long_open_A_line = "high"; // type of A_channel line which raises condition1 := ("high" || "low" || "line")
long_open_B_line = "high"; // type of B_channel line which raises condition7 := ("high" || "low" || "line")
long_open_OBV_period = 20c;
long_open_OBV_level = 200%; // level of OBV for condition9
	
//  short_opening:
short_open_A_line = "low"; // type of A_channel line which raises condition1 := ("high" || "low" || "line")
short_open_B_line = "low"; // type of B_channel line which raises condition7 := ("high" || "low" || "line")
short_open_OBV_period = 20c;
short_open_OBV_level = -200%; // level of OBV for condition9
	
//  long_closing:
longTS_line = "high"; // a line type of the indicator which serves as nextTSlong base
longTS_price_type = A_low_price_type; // a price type of the indicator which serves as nextTSlong base
longTS_offset_type = A_low_offset_type; // an offset type of the indicator which serves as nextTSlong base
longTS_train_window_period = A_train_window_period; // a train_window period of the indicator which serves as nextTSlong base	
longTS_predict_window_type = A_predict_window_type; // a predict_window type of the indicator which serves as nextTSlong base	
longTS_slope_start = (close * 0.01% / 1p); // Starting slope of linear regression for a long position
longTP_line = "low"; // a line type of the indicator which serves as trailing TP base
longTP_price_type = A_high_price_type; // a price type of the indicator which serves as trailing TP base
longTP_offset_type = A_high_offset_type; // an offset type of the indicator which serves as trailing TP base
longTP_train_window_period = A_train_window_period; // a train_window period of the indicator which serves as trailing TP base
longTP_predict_window_type = A_predict_window_type; // a predict_window type of the indicator which serves as trailing TP base
longTP_level = 10%; // TP level in percents
	
//  short_closing:
shortTS_line = "low"; // a line type of the indicator which serves as nextTSshort base
shortTS_price_type = A_high_price_type; // a price type of the indicator which serves as nextTSshort base
shortTS_offset_type = A_high_offset_type; // an offset type of the indicator which serves as nextTSshort base
shortTS_train_window_period = A_train_window_period; // a train_window period of the indicator which serves as nextTSshort base	
shortTS_predict_window_type = A_predict_window_type; // a predict_window type of the indicator which serves as nextTSshort base	
shortTS_slope_start = -(close * 0.01% / 1p); // Starting slope of linear regression for a short position
shortTP_line = "high"; // a line type of the indicator which serves as trailing TP base
shortTP_price_type = A_low_price_type; // a price type of the indicator which serves as trailing TP base
shortTP_offset_type = A_low_offset_type; // an offset type of the indicator which serves as trailing TP base
shortTP_train_window_period = A_train_window_period; // a train_window period of the indicator which serves as trailing TP base
shortTP_predict_window_type = A_predict_window_type; // a predict_window type of the indicator which serves as trailing TP base
shortTP_level = 10%; // TP level in percents

//predict_window = "week"; 
//train_window = 300c;
//high_offset = "high";
//low_offset = "low";
//
//slope_long_start = 0n;//(close * 0.00372% / 1p * 4n);//0.002916n;
//slope_short_start = 0n;//-(close * 0.00372% / 1p * 4n);//-0.002916n;
//OBV_long_level = 10%;
//OBV_short_level = -10%;
//
//predict_window_support = "week";
//train_window_support = 300c;
//predict_window_resistance = "week";
//train_window_resistance = 300c;
//
//OBV_period = 20c;
//
//no_activity_periods = -1c;
// --- parameters -----------------------------------------------------------------------------------------
		
import("%QTrader_Libs%\LR_strategy_SlopeLevel_AdaptiveLots (35-02).aql");

LR_strategy_SlopeLevel_AdaptiveLots_3502(
	safety_stock,	// Safety stock in percents to the equity
	risk_L,		// Risk rate in percents for long positions
	risk_S,		// Risk rate in percents for short positions
	expiration_time,
	
	day_start_time,	// Start time of the day trading session
	day_end_time,	// End time of the day trading session
	night_start_time,	// Start time of the night trading session
	night_end_time,	// End time of the night trading session
	
	//  A_channel:
	A_train_window_period, // a number of candles in history to train the model on
	A_predict_window_type, // a period of time in the future for forecasting := ("candle" || "day" || "week")
	A_high_price_type, // type of price as base for the high channel's border := (open || close || high || low)
	A_low_price_type, // type of price as base for the low channel's border := (open || close || high || low)
	A_high_offset_type, // := ("high" || "low" || "none")
	A_low_offset_type, // := ("high" || "low" || "none")
	
	//  B_channel:
	B_train_window_period, // a number of candles in history to train the model on
	B_predict_window_type, // a period of time in the future for forecasting := ("candle" || "day" || "week")
	B_high_price_type, // type of price as base for the high channel's border := (open || close || high || low)
	B_low_price_type, // type of price as base for the low channel's border := (open || close || high || low)
	B_high_offset_type, //:= ("high" || "low" || "none")
	B_low_offset_type, //:= ("high" || "low" || "none")
	
	//  long_opening:
	long_open_A_line, // type of A_channel line which raises condition1 := ("high" || "low" || "line")
	long_open_B_line, // type of B_channel line which raises condition7 := ("high" || "low" || "line")
	long_open_OBV_period,
	long_open_OBV_level, // level of OBV for condition9
	
	//  short_opening:
	short_open_A_line, // type of A_channel line which raises condition1 := ("high" || "low" || "line")
	short_open_B_line, // type of B_channel line which raises condition7 := ("high" || "low" || "line")
	short_open_OBV_period,
	short_open_OBV_level, // level of OBV for condition9
	
	//  long_closing:
	longTS_line, // a line type of the indicator which serves as nextTSlong base
	longTS_price_type, // a price type of the indicator which serves as nextTSlong base
	longTS_offset_type, // an offset type of the indicator which serves as nextTSlong base
	longTS_train_window_period, // a train_window period of the indicator which serves as nextTSlong base	
	longTS_predict_window_type, // a predict_window type of the indicator which serves as nextTSlong base	
	longTS_slope_start, // Starting slope of linear regression for a long position
	longTP_line, // a line type of the indicator which serves as trailing TP base
	longTP_price_type, // a price type of the indicator which serves as trailing TP base
	longTP_offset_type, // an offset type of the indicator which serves as trailing TP base
	longTP_train_window_period, // a train_window period of the indicator which serves as trailing TP base
	longTP_predict_window_type, // a predict_window type of the indicator which serves as trailing TP base
	longTP_level, // TP level in percents
	
	//  short_closing:
	shortTS_line, // a line type of the indicator which serves as nextTSshort base
	shortTS_price_type, // a price type of the indicator which serves as nextTSshort base
	shortTS_offset_type, // an offset type of the indicator which serves as nextTSshort base
	shortTS_train_window_period, // a train_window period of the indicator which serves as nextTSshort base	
	shortTS_predict_window_type, // a predict_window type of the indicator which serves as nextTSshort base	
	shortTS_slope_start, // Starting slope of linear regression for a short position
	shortTP_line, // a line type of the indicator which serves as trailing TP base
	shortTP_price_type, // a price type of the indicator which serves as trailing TP base
	shortTP_offset_type, // an offset type of the indicator which serves as trailing TP base
	shortTP_train_window_period, // a train_window period of the indicator which serves as trailing TP base
	shortTP_predict_window_type, // a predict_window type of the indicator which serves as trailing TP base
	shortTP_level // TP level in percents
);

log("expiration_stop");

stop();

log("script_stopped")

