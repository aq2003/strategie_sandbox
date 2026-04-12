// 19.12.2025 21:49:35 TestGrid_MNH6_3600_LRSLAL33 ql script
// Created 19.12.2025 21:49:35

// 19.12.2025 21:24:28 TestGrid_GLH6_300_LRSLAL33 ql script
// Created 19.12.2025 21:24:28

// 21.12.2024 22:04:04 TestGrid_VTBR_3600_LRSLAL33 ql script
// Created 21.12.2024 22:04:04

// 21.12.2024 21:53:12 TestGrid_VTBR_3600_LRSLAL31 ql script
// Created 21.12.2024 21:53:12

// 21.12.2024 11:36:24 TestGrid_SBER_3600_LRSLAL31 ql script
// Created 21.12.2024 11:36:24

// 13.12.2024 18:36:40 TestGrid_RTKM_3600_LRSLAL31 ql script
// Created 13.12.2024 18:36:40

// 12.12.2024 16:34:45 TestGrid_SNGS_3600_LRSLAL31 ql script
// Created 12.12.2024 16:34:45

// 10.12.2024 13:55:10 TestGrid_AFKS_3600_LRSLAL31 ql script
// Created 10.12.2024 13:55:10

// 09.12.2024 20:28:38 TestGrid_MGNT_3600_LRSLAL33 ql script
// Created 09.12.2024 20:28:38

// 09.12.2024 16:16:03 TestGrid_MGNT_3600_LRSLAL31 ql script
// Created 09.12.2024 16:16:03

// 30.11.2024 12:59:20 Test32_RTKM_3600_LRSLAL ql script
// Created 30.11.2024 12:59:20

// 14.10.2024 8:38:24 Test32_RTKM_3600_LRSLAL ql script
// Created 14.10.2024 8:38:24

// 05.10.2024 16:47:05 Test32_MGNT_3600_LRSLAL ql script
// Created 05.10.2024 16:47:05

// 27.09.2024 21:34:28 Test_MGNT32_3600_LRSLAL ql script
// Created 27.09.2024 21:34:28

// 09.06.2024 16:44:23 Test_MGNT2_3600_LRSAL ql script
// Created 09.06.2024 16:44:23

// +++ parameters -----------------------------------------------------------------------------------------
base_log_level = "Error";

import("%QTrader_Libs%\QTrader_stdlib.aql");
init_slope_start = (close * 0.01% / 1p);
init_slope_start_max = (close * 0.5% / 1p);

script_to_test = "LR_strategy_SlopeLevel_AdaptiveLots (35-023).aql";

turn_1_abs = true;
turn_2_abs = true;
turn_3_abs = true;

equity_treshold = (equity - 50%);

// target_type := ("best_equity" || "equity_closest_to_max_equity")
target_type = "best_equity";
// --- parameters -----------------------------------------------------------------------------------------

// +++ parameters preparing -------------------------------------------------------------------------------
// 0 Safety stock in percents to the equity
safety_stock = 5%;//iter(5%, 15%, 5%);

// 1 Risk rate in percents for long positions
risk_L = security.riskL;

// 2 Risk rate in percents for short positions
risk_S = security.riskS;

// 3
expiration_time = 15:00_31.12.26;

// 4 Start time of the day trading session
day_start_time = 07:00;

// 5 End time of the day trading session
day_end_time = 19:00;

// 6 Start time of the night trading session
night_start_time = 19:10;

// 7 End time of the night trading session
night_end_time = 23:49;

// 8
A_train_window_period = iter(100c, 300c, 10%);//iter(10c, 300c, 1c);

// 9
A_predict_window_type = "candle";

// 10
A_high_price_type = "high";

// 11
A_low_price_type = "low";

// 12
A_high_offset_type = "none";

// 13
A_low_offset_type = "none";

// 14
B_train_window_period = iter(300c, 1800c, 10%);
//B_train_window_period = 800c;

// 15
B_predict_window_type = "day";

// 16
B_high_price_type = "high";

// 17
B_low_price_type = "low";

// 18
B_high_offset_type = "none";

// 19
B_low_offset_type = "none";

// 20
long_open_A_line = "high";

// 21
long_open_B_line = "high";

// 22
long_open_OBV_period = 10c;

// 23
long_open_OBV_level = 0%;

// 24
short_open_A_line = "low";

// 25
short_open_B_line = "low";

// 26
short_open_OBV_period = 10c;

// 27
short_open_OBV_level = 0%;

// 28
longTS_line = "low";//"high";

// 29
longTS_price_type = name(A_low_price_type);

// 30
longTS_offset_type = name(A_low_offset_type);

// 31
longTS_train_window_period = name(A_train_window_period);

// 32
longTS_predict_window_type = name(A_predict_window_type);

// 33
longTS_slope_start = init_slope_start; //0n;

// 34
longTP_line = "low";

// 35
longTP_price_type = name(B_high_price_type);

// 36
longTP_offset_type = name(B_high_offset_type);

// 37
longTP_train_window_period = name(B_train_window_period);

// 38
longTP_predict_window_type = name(B_predict_window_type);

// 39
longTP_level = 15%;

// 40
shortTS_line = "high";//"low";"low";

// 41
shortTS_price_type = name(A_low_price_type);

// 42
shortTS_offset_type = name(A_low_offset_type);

// 43
shortTS_train_window_period = name(A_train_window_period);

// 44
shortTS_predict_window_type = name(A_predict_window_type);

// 45
shortTS_slope_start = -init_slope_start; //0n;

// 46
shortTP_line = "high";

// 47
shortTP_price_type = name(B_high_price_type);

// 48
shortTP_offset_type = name(B_high_offset_type);

// 49
shortTP_train_window_period = name(B_train_window_period);

// 50
shortTP_predict_window_type = name(B_predict_window_type);

// 51
shortTP_level = 15%;

// 52
longTS_slope_start_max = init_slope_start; //0n;

// 53
shortTS_slope_start_max = init_slope_start; //0n;

// parameters := (..parameter); parameter := (name, start, stop, step, current, index)
params = new("list");

// 0 Safety stock in percents to the equity
i_safety_stock = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(safety_stock);
my_param["value"] = safety_stock;

// 1 Risk rate in percents for long positions
i_risk_L = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(risk_L);
my_param["value"] = risk_L;

// 2 Risk rate in percents for short positions
i_risk_S = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(risk_S);
my_param["value"] = risk_S;

// 3
i_expiration_time = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(expiration_time);
my_param["value"] = expiration_time;

// 4 Start time of the day trading session
i_day_start_time = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(day_start_time);
my_param["value"] = day_start_time;

// 5 End time of the day trading session
i_day_end_time = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(day_end_time);
my_param["value"] = day_end_time;

// 6 Start time of the night trading session
i_night_start_time = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(night_start_time);
my_param["value"] = night_start_time;

// 7 End time of the night trading session
i_night_end_time = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(night_end_time);
my_param["value"] = night_end_time;

// 8
iA_train_window_period = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(A_train_window_period);
my_param["value"] = A_train_window_period;

// 9
iA_predict_window_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(A_predict_window_type);
my_param["value"] = A_predict_window_type;

// 10
iA_high_price_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(A_high_price_type);
my_param["value"] = A_high_price_type;

// 11
iA_low_price_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(A_low_price_type);
my_param["value"] = A_low_price_type;

// 12
iA_high_offset_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(A_high_offset_type);
my_param["value"] = A_high_offset_type;

// 13
iA_low_offset_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(A_low_offset_type);
my_param["value"] = A_low_offset_type;

// 14
iB_train_window_period = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(B_train_window_period);
my_param["value"] = B_train_window_period;
//my_param["value"] = 800c;

// 15
iB_predict_window_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(B_predict_window_type);
my_param["value"] = B_predict_window_type;

// 16
iB_high_price_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(B_high_price_type);
my_param["value"] = B_high_price_type;

// 17
iB_low_price_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(B_low_price_type);
my_param["value"] = B_low_price_type;

// 18
iB_high_offset_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(B_high_offset_type);
my_param["value"] = B_high_offset_type;

// 19
iB_low_offset_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(B_low_offset_type);
my_param["value"] = B_low_offset_type;

// 20
ilong_open_A_line = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(long_open_A_line);
my_param["value"] = long_open_A_line;

// 21
ilong_open_B_line = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(long_open_B_line);
my_param["value"] = long_open_B_line;

// 22
ilong_open_OBV_period = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(long_open_OBV_period);
my_param["value"] = long_open_OBV_period;

// 23
ilong_open_OBV_level = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(long_open_OBV_level);
my_param["value"] = long_open_OBV_level;

// 24
ishort_open_A_line = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(short_open_A_line);
my_param["value"] = short_open_A_line;

// 25
ishort_open_B_line = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(short_open_B_line);
my_param["value"] = short_open_B_line;

// 26
ishort_open_OBV_period = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(short_open_OBV_period);
my_param["value"] = short_open_OBV_period;

// 27
ishort_open_OBV_level = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(short_open_OBV_level);
my_param["value"] = short_open_OBV_level;

// 28
ilongTS_line = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTS_line);
my_param["value"] = longTS_line;

// 29
ilongTS_price_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTS_price_type);
my_param["value"] = longTS_price_type;

// 30
ilongTS_offset_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTS_offset_type);
my_param["value"] = longTS_offset_type;

// 31
ilongTS_train_window_period = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTS_train_window_period);
my_param["value"] = longTS_train_window_period;

// 32
ilongTS_predict_window_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTS_predict_window_type);
my_param["value"] = longTS_predict_window_type;

// 33
ilongTS_slope_start = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTS_slope_start);
my_param["value"] = longTS_slope_start;

// 34
ilongTP_line = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTP_line);
my_param["value"] = longTP_line;

// 35
ilongTP_price_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTP_price_type);
my_param["value"] = longTP_price_type;

// 36
ilongTP_offset_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTP_offset_type);
my_param["value"] = longTP_offset_type;

// 37
ilongTP_train_window_period = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTP_train_window_period);
my_param["value"] = longTP_train_window_period;

// 38
ilongTP_predict_window_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTP_predict_window_type);
my_param["value"] = longTP_predict_window_type;

// 39
ilongTP_level = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTP_level);
my_param["value"] = longTP_level;

// 40
ishortTS_line = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTS_line);
my_param["value"] = shortTS_line;

// 41
ishortTS_price_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTS_price_type);
my_param["value"] = shortTS_price_type;

// 42
ishortTS_offset_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTS_offset_type);
my_param["value"] = shortTS_offset_type;

// 43
ishortTS_train_window_period = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTS_train_window_period);
my_param["value"] = shortTS_train_window_period;

// 44
ishortTS_predict_window_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTS_predict_window_type);
my_param["value"] = shortTS_predict_window_type;

// 45
ishortTS_slope_start = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTS_slope_start);
my_param["value"] = shortTS_slope_start;

// 46
ishortTP_line = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTP_line);
my_param["value"] = shortTP_line;

// 47
ishortTP_price_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTP_price_type);
my_param["value"] = shortTP_price_type;

// 48
ishortTP_offset_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTP_offset_type);
my_param["value"] = shortTP_offset_type;

// 49
ishortTP_train_window_period = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTP_train_window_period);
my_param["value"] = shortTP_train_window_period;

// 50
ishortTP_predict_window_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTP_predict_window_type);
my_param["value"] = shortTP_predict_window_type;

// 51
ishortTP_level = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTP_level);
my_param["value"] = shortTP_level;

// 52
ilongTS_slope_start_max = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(longTS_slope_start_max);
my_param["value"] = longTS_slope_start_max;

// 53
ishortTS_slope_start_max = count(params);
params += (my_param = new("dict"));
my_param["name"] = name(shortTS_slope_start_max);
my_param["value"] = shortTS_slope_start_max;

// --- parameters preparing -------------------------------------------------------------------------------

import("%QTrader_Libs%\TestHistory.aql");

// +++ 1st turn ---------------------------------------------------------------------------------------------------------------------------------
best_result = 0n;
// criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity" || "best_PL_rate")
{
	log("+++_1st_turn ---------------------------------------------------------------------------------------------------------------------------------")
		<< turn_1_abs == true;
	criteria = "best_equity";
	_best_result = Test(
		params, // parameters := (..parameter); parameter := (name, start, stop, step, current, index)
		criteria, // criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity" || "best_PL_rate")
		base_log_level,
		script_to_test
	);
	log("---_1st_turn ---------------------------------------------------------------------------------------------------------------------------------");
||
	log("***_1st_turn is missed") << turn_1_abs != true;	
	system.log("Test_stopped;***_1st_turn is missed")	
};

mean_equity = best_result["best_values"];
mean_equity = mean_equity["mean_equity"];
turn_2 = (turn_3 = (mean_equity > equity_treshold));
// --- 1st turn ---------------------------------------------------------------------------------------------------------------------------------

// +++ 2nd turn ---------------------------------------------------------------------------------------------------------------------------------
{
	log("+++_2nd_turn ---------------------------------------------------------------------------------------------------------------------------------")
		<< turn_2 == true & turn_2_abs == true;
	best_parameters = best_result["best_parameters"];

	i = 0i;
	my_count = count(best_parameters);
	..[i < my_count]
	{
		(params[i])["value"] = best_parameters[i];
		i += 1i;
	};

	// 23
	//(params[ilong_open_OBV_level])["value"] = iter(0%, 300%, 100%);
	(params[ilong_open_OBV_period])["value"] = iter(2c, 20c, 1c);

	// 27
	//(params[ishort_open_OBV_level])["value"] = iter(0%, -300%, -100%);
	(params[ishort_open_OBV_period])["value"] = name(long_open_OBV_period);

	criteria = "best_equity";
	_best_result = Test(
		params, // parameters := (..parameter); parameter := (name, start, stop, step, current, index)
		criteria, // Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
		base_log_level,
		script_to_test
	);
	log("---_2nd_turn ---------------------------------------------------------------------------------------------------------------------------------");
||
	log("***_2st_turn is missed") << !(turn_2 == true & turn_2_abs == true);	
	system.log("Test_stopped;***_2st_turn is missed")	
};
// --- 2nd turn ---------------------------------------------------------------------------------------------------------------------------------

// +++ 3rd turn ---------------------------------------------------------------------------------------------------------------------------------
{
	log("+++_3rd_turn ---------------------------------------------------------------------------------------------------------------------------------")
		<< turn_3 == true & turn_3_abs == true;
	best_parameters = best_result["best_parameters"];

	i = 0i;
	my_count = count(best_parameters);
	..[i < my_count]
	{
		(params[i])["value"] = best_parameters[i];
		i += 1i;
	};
	
	// 52
	slope_long_max = (init_slope_start_max * 2n);
	(params[ilongTS_slope_start])["value"] = iter(0n, slope_long_max, slope_long_max / 10n);

	// 53
	slope_short_min = -(init_slope_start_max * 2n);
	(params[ishortTS_slope_start])["value"] = iter(0n, slope_short_min, slope_short_min / 10n);

	criteria = "best_equity";
	_best_result = Test(
		params, // parameters := (..parameter); parameter := (name, start, stop, step, current, index)
		criteria, // Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
		base_log_level,
		script_to_test
	);
	log("---_3rd_turn ---------------------------------------------------------------------------------------------------------------------------------");
||
	log("***_3st_turn is missed") << !(turn_3 == true & turn_3_abs == true);	
	system.log("Test_stopped;***_3st_turn is missed")	
};
// --- 3rd turn ---------------------------------------------------------------------------------------------------------------------------------
