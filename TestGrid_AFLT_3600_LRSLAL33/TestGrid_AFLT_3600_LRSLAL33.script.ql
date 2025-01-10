// 17.12.2024 20:48:59 TestGrid_AFLT_3600_LRSLAL33 ql script
// Created 17.12.2024 20:48:59

// 17.12.2024 20:39:51 TestGrid_AFLT_3600_LRSLAL31 ql script
// Created 17.12.2024 20:39:51

// 17.12.2024 9:12:45 TestGrid_TATN_3600_LRSLAL31 ql script
// Created 17.12.2024 9:12:45

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

script_to_test = "LR_strategy_SlopeLevel_AdaptiveLots (33).aql";

// target_type := ("best_equity" || "equity_closest_to_max_equity")
target_type = "best_equity";
// --- parameters -----------------------------------------------------------------------------------------

// +++ parameters preparing -------------------------------------------------------------------------------
// parameters := (..parameter); parameter := (name, start, stop, step, current, index)
params = new("list");

// 0 Safety stock in percents to the equity
i_safety_stock = count(params);
params += (my_param = new("dict"));
my_param["name"] = "safety_stock";
my_param["value"] = 5%;//iter(5%, 15%, 5%);

// 1 Risk rate in percents for long positions
i_risk_L = count(params);
params += (my_param = new("dict"));
my_param["name"] = "risk_L";
my_param["value"] = 20%;

// 2 Risk rate in percents for short positions
i_risk_S = count(params);
params += (my_param = new("dict"));
my_param["name"] = "risk_S";
my_param["value"] = 20%;

// 3
i_expiration_time = count(params);
params += (my_param = new("dict"));
my_param["name"] = "expiration_time";
my_param["value"] = 15:00_15.12.25;

// 4 Start time of the day trading session
i_day_start_time = count(params);
params += (my_param = new("dict"));
my_param["name"] = "day_start_time";
my_param["value"] = 10:00;

// 5 End time of the day trading session
i_day_end_time = count(params);
params += (my_param = new("dict"));
my_param["name"] = "day_end_time";
my_param["value"] = 19:00;

// 6 Start time of the night trading session
i_night_start_time = count(params);
params += (my_param = new("dict"));
my_param["name"] = "night_start_time";
my_param["value"] = 19:10;

// 7 End time of the night trading session
i_night_end_time = count(params);
params += (my_param = new("dict"));
my_param["name"] = "night_end_time";
my_param["value"] = 23:49;

// 8
i_predict_window_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = "predict_window_type";
my_param["value"] = "candle";

// 9
i_high_offset_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = "high_offset_type";
my_param["value"] = "none";

// 10
i_low_offset_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = "low_offset_type";
my_param["value"] = "none";

// 12
i_predict_window_slow_type = count(params);
params += (my_param = new("dict"));
my_param["name"] = "predict_window_slow_type";
my_param["value"] = "week";

// 14
i_train_window_slow_period = count(params);
params += (my_param = new("dict"));
my_param["name"] = "train_window_slow_period";
//my_param["value"] = iter(300c, 2000c, 10%);
my_param["value"] = 800c;

// 15
i_train_window_period = count(params);
params += (my_param = new("dict"));
my_param["name"] = "train_window_period";
//my_param["value"] = iter(50c, 300c, 10%);
my_param["value"] = iter(10c, 300c, 1c);

// 16
i_slope_long = count(params);
params += (my_param = new("dict"));
my_param["name"] = "slope_long";
my_param["value"] = 0.026n;//iter(1.2n, 1.2n, 2n);

// 17
i_slope_short = count(params);
params += (my_param = new("dict"));
my_param["name"] = "slope_short";
my_param["value"] = -0.026n;//iter(-1.2n, -1.2n, -2n);

// 18
i_slope_long_level = count(params);
params += (my_param = new("dict"));
my_param["name"] = "slope_long_level";
my_param["value"] = -0.13n;//iter(-6n, -6n, 2n);

// 19
i_slope_short_level = count(params);
params += (my_param = new("dict"));
my_param["name"] = "slope_short_level";
my_param["value"] = 0.13n;//iter(6n, 6n, 2n);

// 20
i_channel_width = count(params);
params += (my_param = new("dict"));
my_param["name"] = "channel_width";
my_param["value"] = 0p;//iter(0p, 0p, 1p);

// 21
i_no_activity = count(params);
params += (my_param = new("dict"));
my_param["name"] = "no_activity";
my_param["value"] = -1c;

// --- parameters preparing -------------------------------------------------------------------------------

import("%QTrader_Libs%\TestHistory.aql");
//import("Z:\Documents\My Stocks\Stock\SASHA-SERVER\QM_Imit\Strategy Sandbox\LibsSandbox\TestHistory.aql");

// +++ 1st turn ---------------------------------------------------------------------------------------------------------------------------------
// criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
log("+++_1st_turn ---------------------------------------------------------------------------------------------------------------------------------");
criteria = "best_equity";
best_result = Test(
	params, // parameters := (..parameter); parameter := (name, start, stop, step, current, index)
	criteria, // Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
	base_log_level,
	script_to_test
);
log("---_1st_turn ---------------------------------------------------------------------------------------------------------------------------------");
// --- 1st turn ---------------------------------------------------------------------------------------------------------------------------------

// +++ 2nd turn ---------------------------------------------------------------------------------------------------------------------------------
log("+++_2nd_turn ---------------------------------------------------------------------------------------------------------------------------------");
best_parameters = best_result["best_parameters"];

// 14
//(params[i_train_window_slow_period])["value"] = best_parameters[i_train_window_slow_period];
(params[i_train_window_slow_period])["value"] = iter(300c, 2000c, 5c);

// 15
(params[i_train_window_period])["value"] = best_parameters[i_train_window_period];

// 21
//my_param = params[i_no_activity];
//my_param["value"] = iter(1c, 20c, 1c);

criteria = "best_equity";
best_result = Test(
	params, // parameters := (..parameter); parameter := (name, start, stop, step, current, index)
	criteria, // Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
	base_log_level,
	script_to_test
);
log("---_2nd_turn ---------------------------------------------------------------------------------------------------------------------------------");
// --- 2nd turn ---------------------------------------------------------------------------------------------------------------------------------

// +++ 3rd turn ---------------------------------------------------------------------------------------------------------------------------------
log("+++_3rd_turn ---------------------------------------------------------------------------------------------------------------------------------");
best_parameters = best_result["best_parameters"];
//my_param = params[i_no_activity];
//my_param["value"] = best_parameters[i_no_activity];

// 14
(params[i_train_window_slow_period])["value"] = best_parameters[i_train_window_slow_period];

// 16
//i_slope_long = count(params);
//params += (my_param = new("dict"));
//my_param["name"] = "slope_long";
//my_param["value"] = 0.01n;//iter(1.2n, 1.2n, 2n);
slope_long_max = params[i_slope_long];
slope_long_max = slope_long_max["value"];
slope_long_max *= 2n;
(params[i_slope_long])["value"] = iter(0n, slope_long_max, slope_long_max / 10n);

// 17
//i_slope_short = count(params);
//params += (my_param = new("dict"));
//my_param["name"] = "slope_short";
//my_param["value"] = -0.01n;//iter(-1.2n, -1.2n, -2n);
slope_short_min = params[i_slope_short];
slope_short_min = slope_short_min["value"];
slope_short_min *= 2n;
(params[i_slope_short])["value"] = iter(0n, slope_short_min, slope_short_min / 10n);

// 18
//my_param = params[i_slope_long_level];
//my_param["value"] = iter(0n, -0.18n, -0.018n);

// 19
//my_param = params[i_slope_short_level];
//my_param["value"] = iter(0n, 0.18n, 0.018n);

criteria = "best_equity";
best_result = Test(
	params, // parameters := (..parameter); parameter := (name, start, stop, step, current, index)
	criteria, // Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
	base_log_level,
	script_to_test
);
log("---_3rd_turn ---------------------------------------------------------------------------------------------------------------------------------");
// --- 3rd turn ---------------------------------------------------------------------------------------------------------------------------------
