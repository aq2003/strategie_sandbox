// 09.06.2024 16:44:23 Test_MGNT2_3600_LRSAL ql script
// Created 09.06.2024 16:44:23

// +++ parameters -----------------------------------------------------------------------------------------
base_log_level = "Error";

safety_stock = 5%;	// Safety stock in percents to the equity
risk_L = 17%;		// Risk rate in percents for long positions
risk_S = 17%;		// Risk rate in percents for short positions

expiration_time = 15:00_15.12.24;

day_start_time = 10:00;	// Start time of the day trading session
day_end_time = 19:00;	// End time of the day trading session
night_start_time = 19:10;	// Start time of the night trading session
night_end_time = 23:49;	// End time of the night trading session
	
predict_window = "candle"; 
high_offset = "none";
low_offset = "none";
train_window_start = 50c;
train_window_stop = 300c;
train_window_step = 10%;

slope_long_start = 1.2n;
slope_long_stop = 1.2n;
slope_long_step = 2n;
slope_short_start = -1.2n;
slope_short_stop = -1.2n;
slope_short_step = 2n;

slope_long_level_start = -6n;
slope_long_level_stop = 0n;
slope_long_level_step = (slope_long_level_start / -10n);
slope_short_level_start = 0n;
slope_short_level_stop = 6n;
slope_short_level_step = (slope_short_level_stop / 10n);

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

no_activity_start = -1c;
no_activity_stop = -1c;
no_activity_step = 1c;

// target_type := ("best_equity" || "equity_closest_to_max_equity")
target_type = "best_equity";
// --- parameters -----------------------------------------------------------------------------------------

// +++ parameters preparing -------------------------------------------------------------------------------
idx = -1i;
	

i_safety_stock = idx += 1i;	//0 Safety stock in percents to the equity
i_risk_L = idx += 1i;		//1 Risk rate in percents for long positions
i_risk_S = idx += 1i;		//2 Risk rate in percents for short positions
	
i_expiration_time = idx += 1i; 	//3 Time when to stop the strategy
	
i_day_start_time = idx += 1i;	//4 Start time of the day trading session
i_day_end_time = idx += 1i;	//5 End time of the day trading session
i_night_start_time = idx += 1i;	//6 Start time of the night trading session
i_night_end_time = idx += 1i;	//7 End time of the night trading session
	
i_predict_window = idx += 1i;	//8 Signal line predict window type := ("week" || "day" || "candle")
i_high_offset = idx += 1i;	//9 Which type of price to take for the high line offset
i_low_offset = idx += 1i;	//10 Which type of price to take for the low line offset

i_predict_window_support = idx += 1i;	//11 Support line predict window type := ("week" || "day" || "candle")
i_predict_window_resistance = idx += 1i;	//12 Resistance line predict window type := ("week" || "day" || "candle")

i_train_window_support = idx += 1i;	//13 Support line width of training window in candle number
i_train_window_resistance = idx += 1i;	//14 Resistance line width of training window in candle number
i_train_window = idx += 1i;	//15 Signal line width of training window in candle number

i_slope_long = idx += 1i;	//16 Starting slope of linear regression for a long position
i_slope_short = idx += 1i;	//17 Starting slope of linear regression for a short position
i_slope_long_level = idx += 1i;	//18 Slope level of linear regression for a long position
i_slope_short_level = idx += 1i;	//19 Slope level of linear regression for a short position

i_channel_width = idx += 1i;	//20 Width of signal channel to disable trading
i_no_activity = idx += 1i;	//21

// parameters := (..parameter); parameter := (name, start, stop, step, current, index)
params = new("list");
idx = -1i;

// 0
my_param = new("dict");
my_param["name"] = "safety_stock";
//my_param["start"] = safety_stock;
//my_param["stop"] = safety_stock;
//my_param["step"] = safety_stock;
my_param["current"] = safety_stock;
my_param["index"] = i_safety_stock;
params += my_param;

// 1
my_param = new("dict");
my_param["name"] = "risk_L";
//my_param["start"] = risk_L;
//my_param["stop"] = risk_L;
//my_param["step"] = risk_L;
my_param["current"] = risk_L;
my_param["index"] = i_risk_L;
params += my_param;

// 2
my_param = new("dict");
my_param["name"] = "risk_S";
//my_param["start"] = risk_S;
//my_param["stop"] = risk_S;
//my_param["step"] = risk_S;
my_param["current"] = risk_S;
my_param["index"] = i_risk_S;
params += my_param;

// 3
my_param = new("dict");
my_param["name"] = "expiration_time";
//my_param["start"] = expiration_time;
//my_param["stop"] = expiration_time;
//my_param["step"] = expiration_time;
my_param["current"] = expiration_time;
my_param["index"] = i_expiration_time;
params += my_param;

// 4
my_param = new("dict");
my_param["name"] = "day_start_time";
//my_param["start"] = day_start_time;
//my_param["stop"] = day_start_time;
//my_param["step"] = day_start_time;
my_param["current"] = day_start_time;
my_param["index"] = i_day_start_time;
params += my_param;

// 5
my_param = new("dict");
my_param["name"] = "day_end_time";
//my_param["start"] = day_end_time;
//my_param["stop"] = day_end_time;
//my_param["step"] = day_end_time;
my_param["current"] = day_end_time;
my_param["index"] = i_day_end_time;
params += my_param;

// 6
my_param = new("dict");
my_param["name"] = "night_start_time";
//my_param["start"] = night_start_time;
//my_param["stop"] = night_start_time;
//my_param["step"] = night_start_time;
my_param["current"] = night_start_time;
my_param["index"] = i_night_start_time;
params += my_param;

// 7
my_param = new("dict");
my_param["name"] = "night_end_time";
//my_param["start"] = night_end_time;
//my_param["stop"] = night_end_time;
//my_param["step"] = night_end_time;
my_param["current"] = night_end_time;
my_param["index"] = i_night_end_time;
params += my_param;

// 8
my_param = new("dict");
my_param["name"] = "predict_window";
//my_param["start"] = predict_window;
//my_param["stop"] = predict_window;
//my_param["step"] = predict_window;
my_param["current"] = predict_window;
my_param["index"] = i_predict_window;
params += my_param;

// 9
my_param = new("dict");
my_param["name"] = "high_offset";
//my_param["start"] = high_offset;
//my_param["stop"] = high_offset;
//my_param["step"] = high_offset;
my_param["current"] = high_offset;
my_param["index"] = i_high_offset;
params += my_param;

// 10
my_param = new("dict");
my_param["name"] = "low_offset";
//my_param["start"] = low_offset;
//my_param["stop"] = low_offset;
//my_param["step"] = low_offset;
my_param["current"] = low_offset;
my_param["index"] = i_low_offset;
params += my_param;

// 11
my_param = new("dict");
my_param["name"] = "predict_window_support";
//my_param["start"] = predict_window_support;
//my_param["stop"] = predict_window_support;
//my_param["step"] = predict_window_support;
my_param["current"] = predict_window_support;
my_param["index"] = i_predict_window_support;
params += my_param;

// 12
my_param = new("dict");
my_param["name"] = "predict_window_resistance";
//my_param["start"] = predict_window_resistance;
//my_param["stop"] = predict_window_resistance;
//my_param["step"] = predict_window_resistance;
my_param["current"] = predict_window_resistance;
my_param["index"] = i_predict_window_resistance;
params += my_param;

// 13
my_param = new("dict");
my_param["name"] = "train_window_support";
my_param["start"] = 1138c;//train_window_support_start;
my_param["stop"] = 1138c;//train_window_support_start;//train_window_support_stop;
my_param["step"] = train_window_support_step;
my_param["current"] = 1138c;//train_window_support_start;
my_param["index"] = i_train_window_support;
params += my_param;

// 14
my_param = new("dict");
my_param["name"] = "train_window_resistance";
my_param["start"] = 1138c;//train_window_resistance_start;
my_param["stop"] = 1138c;//train_window_resistance_start;//train_window_resistance_stop;
my_param["step"] = train_window_resistance_step;
my_param["current"] = 1138c;//train_window_resistance_start;
my_param["index"] = i_train_window_resistance;
params += my_param;

// 15
my_param = new("dict");
my_param["name"] = "train_window";
my_param["start"] = 81c;//train_window_start;
my_param["stop"] = 81c;//train_window_start;//train_window_stop;
my_param["step"] = train_window_step;
my_param["current"] = 81c;//train_window_start;
my_param["index"] = i_train_window;
params += my_param;

// 16
my_param = new("dict");
my_param["name"] = "slope_long";
my_param["start"] = 2n;//slope_long_start;
my_param["stop"] = 2n;//slope_long_start;
my_param["step"] = slope_long_step;
my_param["current"] = 2n;//slope_long_start;
my_param["index"] = i_slope_long;
params += my_param;

// 17
my_param = new("dict");
my_param["name"] = "slope_short";
my_param["start"] = -2n;//slope_short_start;
my_param["stop"] = -2n;//slope_short_start;
my_param["step"] = slope_short_step;
my_param["current"] = -2n;//slope_short_start;
my_param["index"] = i_slope_short;
params += my_param;

// 18
my_param = new("dict");
my_param["name"] = "slope_long_level";
my_param["start"] = -6n;//slope_long_level_start;
my_param["stop"] = -6n;//slope_long_level_start;
my_param["step"] = slope_long_level_step;
my_param["current"] = -6n;//slope_long_level_start;
my_param["index"] = i_slope_long_level;
params += my_param;

// 19
my_param = new("dict");
my_param["name"] = "slope_short_level";
my_param["start"] = 6n;//slope_short_level_stop;
my_param["stop"] = 6n;//slope_short_level_stop;
my_param["step"] = slope_short_level_step;
my_param["current"] = 6n;//slope_short_level_stop;
my_param["index"] = i_slope_short_level;
params += my_param;

// 20
my_param = new("dict");
my_param["name"] = "channel_width";
my_param["start"] = 0p;//channel_width_start;
my_param["stop"] = 0p;//channel_width_start;
my_param["step"] = channel_width_step;
my_param["current"] = 0p;//channel_width_start;
my_param["index"] = i_channel_width;
params += my_param;

// 21
my_param = new("dict");
my_param["name"] = "no_activity";
my_param["start"] = 1c;//no_activity_stop;
my_param["stop"] = 2c;//no_activity_stop;
my_param["step"] = 1c;//no_activity_step;
my_param["current"] = -1c;//no_activity_stop;
my_param["index"] = i_no_activity;
params += my_param;

params_count = (i_no_activity + 1i);

// --- parameters preparing -------------------------------------------------------------------------------

// +++ best parameters preparing --------------------------------------------------------------------------
best_params = new("list");
my_count = 0i;
..[my_count < params_count]
{
	best_params += 0n;
	my_count += 1i;
};

// --- best parameters preparing --------------------------------------------------------------------------

// +++ best values preparing ------------------------------------------------------------------------------
// best_values := (equity, max_equity, min_equity, target)
best_values = new("dict");
best_values["equity"] = 0p;
best_values["max_equity"] = 0p;
best_values["min_equity"] = 0p;
best_values["target"] = 0p;

// --- best values preparing ------------------------------------------------------------------------------

import("%QTrader_Libs%\Test.aql");

// criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
criteria = "best_equity";
Test(
	params, // parameters := (..parameter); parameter := (name, start, stop, step, current, index)
	params_count, // Total number of parameters in the list; parameters.count
	i_no_activity/*i_train_window_resistance*/, // Number of a parameter to search with
	i_no_activity/*i_train_window_resistance*/,// Parameter number at the first entry
	best_params, // List of best parameter values according to the given criteria; best_parameters := (..value); best_parameters.count == parameters.count
	best_values, // A set of best values; best_values := (equity, max_equity, min_equity, target)
	criteria, // Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
	base_log_level
)



