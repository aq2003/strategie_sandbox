// 09.06.2024 16:44:23 Test_MGNT2_3600_LRSAL ql script
// Created 09.06.2024 16:44:23

// +++ parameters -----------------------------------------------------------------------------------------
base_log_level = "Error";

import("%QTrader_Libs%\QTrader_stdlib.aql");

//safety_stock = 5%;	// Safety stock in percents to the equity
//risk_L = 17%;		// Risk rate in percents for long positions
//risk_S = 17%;		// Risk rate in percents for short positions

//expiration_time = 15:00_15.12.24;

//day_start_time = 10:00;	// Start time of the day trading session
//day_end_time = 19:00;	// End time of the day trading session
//night_start_time = 19:10;	// Start time of the night trading session
//night_end_time = 23:49;	// End time of the night trading session
	
//predict_window_type = "candle"; 
//high_offset_type = "none";
//low_offset_type = "none";
//train_window_period_start = 50c;
//train_window_period_stop = 300c;
//train_window_period_step = 10%;

//slope_long_start = 1.2n;
//slope_long_stop = 1.2n;
//slope_long_step = 2n;
//slope_short_start = -1.2n;
//slope_short_stop = -1.2n;
//slope_short_step = 2n;

//slope_long_level_start = -6n;
//slope_long_level_stop = 0n;
//slope_long_level_step = (slope_long_level_start / -10n);
//slope_short_level_start = 0n;
//slope_short_level_stop = 6n;
//slope_short_level_step = (slope_short_level_stop / 10n);

//predict_window_support_type = "week";
//predict_window_resistance_type = "week";
//train_window_support_period_start = 300c;
//train_window_support_period_stop = 2000c;
//train_window_support_period_step = 10%;
//train_window_resistance_period_start = 300c;
//train_window_resistance_period_stop = 2000c;
//train_window_resistance_period_step = 10%;

//channel_width_start = 0p;
//channel_width_stop = 300p;
//channel_width_step = 50p;

//no_activity_start = -1c;
//no_activity_stop = -1c;
//no_activity_step = 1c;

// target_type := ("best_equity" || "equity_closest_to_max_equity")
target_type = "best_equity";
// --- parameters -----------------------------------------------------------------------------------------

// +++ parameters preparing -------------------------------------------------------------------------------
// parameters := (..parameter); parameter := (name, start, stop, step, current, index)
params = new("list");

// 0 Safety stock in percents to the equity
params += (my_param = new("dict"));
my_param["name"] = "safety_stock";
my_param["value"] = 5%;//iter(5%, 15%, 5%);

// 1 Risk rate in percents for long positions
params += (my_param = new("dict"));
my_param["name"] = "risk_L";
my_param["value"] = 17%;

// 2 Risk rate in percents for short positions
params += (my_param = new("dict"));
my_param["name"] = "risk_S";
my_param["value"] = 17%;

// 3
params += (my_param = new("dict"));
my_param["name"] = "expiration_time";
my_param["value"] = 15:00_15.12.24;

// 4 Start time of the day trading session
params += (my_param = new("dict"));
my_param["name"] = "day_start_time";
my_param["value"] = 10:00;

// 5 End time of the day trading session
params += (my_param = new("dict"));
my_param["name"] = "day_end_time";
my_param["value"] = 19:00;

// 6 Start time of the night trading session
params += (my_param = new("dict"));
my_param["name"] = "night_start_time";
my_param["value"] = 19:10;

// 7 End time of the night trading session
params += (my_param = new("dict"));
my_param["name"] = "night_end_time";
my_param["value"] = 23:49;

// 8
params += (my_param = new("dict"));
my_param["name"] = "predict_window_type";
my_param["value"] = "candle";

// 9
params += (my_param = new("dict"));
my_param["name"] = "high_offset_type";
my_param["value"] = "none";

// 10
params += (my_param = new("dict"));
my_param["name"] = "low_offset_type";
my_param["value"] = "none";

// 11
/*params += (my_param = new("dict"));
my_param["name"] = "predict_window_support_type";
//my_param["start"] = "week";
my_param["value"] = new("list");
my_param["value"] += "week";
my_param["value"] += "candle";*/

// 12
params += (my_param = new("dict"));
my_param["name"] = "predict_window_slow_type";
my_param["value"] = "week";
/*my_param["value"] = new("list");
my_param["value"] += "week";
my_param["value"] += "candle";*/

// 13
/*params += (my_param = new("dict"));
my_param["name"] = "train_window_support_period";
//my_param["start"] = 1138c;//300c;train_window_support_period_start;
//my_param["stop"] = 1138c;//2000;train_window_support_period_start;//train_window_support_period_stop;
//my_param["step"] = 10%;//train_window_support_period_step;
my_param["value"] = 300c;//iter(300c, 2000c, 20%);*/

// 14
params += (my_param = new("dict"));
my_param["name"] = "train_window_slow_period";
my_param["value"] = 1000c;//iter(300c, 2000c, 20%);

// 15
params += (my_param = new("dict"));
my_param["name"] = "train_window_period";
my_param["value"] = iter(50c, 300c, 10%);

// 16
params += (my_param = new("dict"));
my_param["name"] = "slope_long";
my_param["value"] = 1.2n;//iter(1.2n, 1.2n, 2n);

// 17
params += (my_param = new("dict"));
my_param["name"] = "slope_short";
my_param["value"] = -1.2n;//iter(-1.2n, -1.2n, -2n);

// 18
params += (my_param = new("dict"));
my_param["name"] = "slope_long_level";
my_param["value"] = -6n;//iter(-6n, -6n, 2n);

// 19
params += (my_param = new("dict"));
my_param["name"] = "slope_short_level";
my_param["value"] = 6n;//iter(6n, 6n, 2n);

// 20
params += (my_param = new("dict"));
my_param["name"] = "channel_width";
my_param["value"] = 0p;//iter(0p, 0p, 1p);

// 21
params += (my_param = new("dict"));
my_param["name"] = "no_activity";
my_param["value"] = 2c;//iter(1c, 1c, 1c);

// --- parameters preparing -------------------------------------------------------------------------------

import("%QTrader_Libs%\TestHistory.aql");

// criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
criteria = "best_equity";
Test(
	params, // parameters := (..parameter); parameter := (name, start, stop, step, current, index)
	criteria, // Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
	base_log_level,
	"LR_strategy_SlopeLevel_AdaptiveLots (30).aql"
)



