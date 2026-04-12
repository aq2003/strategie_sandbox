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

// +++ LR_strategy_SlopeLevel_AdaptiveLots --- 7.04.2024 -------------------------------------------------------------------------------------------------------------------
// Calculates amount of money to spend for a long position as a safe part of equity 
//	safety_stock - 	Safety stock in percents to the equity
//	risk_L -		Risk rate in percents for long positions

// +++ LR_strategy_SlopeLevel_AdaptiveLots (35-01) --- 23.02.2026 ----------------------------------------------------------------------------------------------------------
// Derives from 35-1
// LRSLAL_long_CalcNextTSSlope and LRSLAL_short_CalcNextTSSlope functions to calculate nextTS and slope like serving a position
// LRSLAL_long_Calc1NextTSSlope and LRSLAL_short_Calc1NextTSSlope functions to calculate nextTS and slope like a position just started
// OBV by period condition has been entered

// +++ LR_strategy_SlopeLevel_AdaptiveLots (36) --- 4.03.2026 --------------------------------------------------------------------------------------------------------------
// Derives from 35-01
// Condition1 is not playing. Condition7 is a main one

// +++ LR_strategy_SlopeLevel_AdaptiveLots (35-02) --- 7.03.2026 --------------------------------------------------------------------------------------------------------------
// Derives from 36
// An universal parametrised strategy
//
// Parameters:
//  A_channel:
//  - A_train_window_period - a number of candles in history to train the model on
//  - A_predict_window_type - a period of time in the future for forecasting := ("candle" || "day" || "week")
//  - A_high_price_type - type of price as base for the high channel's border := (open || close || high || low)
//  - A_low_price_type - type of price as base for the low channel's border := (open || close || high || low)
//  - A_high_offset_type := ("high" || "low" || "none")
//  - A_low_offset_type := ("high" || "low" || "none")
//  B_channel:
//  - B_train_window_period - a number of candles in history to train the model on
//  - B_predict_window_type - a period of time in the future for forecasting := ("candle" || "day" || "week")
//  - B_high_price_type - type of price as base for the high channel's border := (open || close || high || low)
//  - B_low_price_type - type of price as base for the low channel's border := (open || close || high || low)
//  - B_high_offset_type := ("high" || "low" || "none")
//  - B_low_offset_type := ("high" || "low" || "none")
//  long_opening:
//  - long_open_A_line - type of A_channel line which raises condition1 := ("high" || "low" || "line")
//  - long_open_B_line - type of B_channel line which raises condition7 := ("high" || "low" || "line")
//  - long_open_OBV_period
//  - long_open_OBV_level - level of OBV for condition9
//  short_opening:
//  - short_open_A_line - type of A_channel line which raises condition1 := ("high" || "low" || "line")
//  - short_open_B_line - type of B_channel line which raises condition7 := ("high" || "low" || "line")
//  - short_open_OBV_period
//  - short_open_OBV_level - level of OBV for condition9
//  long_closing:
//  - longTS_line - a line type of the indicator which serves as nextTSlong base
//  - longTS_price_type - a price type of the indicator which serves as nextTSlong base
//  - longTS_offset_type - an offset type of the indicator which serves as nextTSlong base
//  - longTS_train_window_period - a train_window period of the indicator which serves as nextTSlong base	
//  - longTS_predict_window_type - a predict_window type of the indicator which serves as nextTSlong base	
//  - longTS_slope_start - Starting slope of linear regression for a long position
//  - longTP_level - TP level in percents
//  short_closing:
//  - shortTS_line - a line type of the indicator which serves as nextTSshort base
//  - shortTS_price_type - a price type of the indicator which serves as nextTSshort base
//  - shortTS_offset_type - an offset type of the indicator which serves as nextTSshort base
//  - shortTS_train_window_period - a train_window period of the indicator which serves as nextTSshort base	
//  - shortTS_predict_window_type - a predict_window type of the indicator which serves as nextTSshort base	
//  - shortTS_slope_start - Starting slope of linear regression for a short position
//  - shortTP_level - TP level in percents
//
// +++ LR_strategy_SlopeLevel_AdaptiveLots (35-022) --- 11.04.2026 --------------------------------------------------------------------------------------------------------------
// longTS_slope_start_max and shortTS_slope_start_max have been entered

CalculateLotsToLong(
	safety_stock,	// Safety stock in percents to the equity
	risk_L		// Risk rate in percents for long positions
) :=
{
	result = 0p;
	
	{
		result = ((equity - safety_stock/* / risk_L*/) / risk_L) << security.board == "TQBR"
	||
		result = (equity - safety_stock) << security.board == "FUT"
	}
};

// Calculates amount of money to spend for a short position as a safe part of equity 
//	safety_stock - 	Safety stock in percents to the equity
//	risk_S -		Risk rate in percents for short positions
CalculateLotsToShort(
	safety_stock,	// Safety stock in percents to the equity
	risk_S		// Risk rate in percents for short positions
) :=
{
	result = 0p;
	
	{
		result = ((equity - safety_stock/* / risk_S*/) / risk_S) << security.board == "TQBR"
	||
		result = (equity - safety_stock) << security.board == "FUT"
	}
};

// Calculates SL percentage for a long 
//	safety_stock - 	Safety stock in percents to the equity
//	risk_L -		Risk rate in percents for short positions
CalculateSLLong(
	safety_stock,	// Safety stock in percents to the equity
	risk_L		// Risk rate in percents for short positions
) :=
{
	result = 0%;
	
	{
		result = (safety_stock * risk_L) << security.board == "TQBR"
	||
		result = (safety_stock * (security.buy_deposit / security.lotprice)) << security.board == "FUT"
	}
};

// Calculates SL percentage for a short 
//	safety_stock - 	Safety stock in percents to the equity
//	risk_S -		Risk rate in percents for short positions
CalculateSLShort(
	safety_stock,	// Safety stock in percents to the equity
	risk_S		// Risk rate in percents for short positions
) :=
{
	result = 0n;
	
	{
		result = (safety_stock * risk_S) << security.board == "TQBR"
	||
		result = (safety_stock * (security.sell_deposit / security.lotprice)) << security.board == "FUT"
	}
};

// Looking for day start candle to pass 2 canles in the past
// Is actual only for periods and papers which have an empty candle at the day start
LR_strategy_condition_start_time() :=
{
	result = 1c;
	
	{
		result = -2c << time == _day_start_time;
	||
		result = -1c << time > _day_start_time;
	};
};

// Finds a LR slope max value on a given time section for given period and price type
//  slope_period - train_window value for the SL slope indicator
//  price_type - type of the price for the SL slope indicator
//  start_time - start point for time section
//  end_time - finish time for time section
// Returns slope max value
LR_strategy_Slope_Max(
	slope_period,
	price_type,
	start_time,
	end_time
) :=
{
	result = 0n;
	
	start_candleno = candle.number[start_time];
	end_candleno = candle.number[end_time];
	current_candleno = candle.number;
	
	offset = (start_candleno - current_candleno);
	end_offset = (end_candleno - current_candleno);
	//log("LR_strategy_Slope_Max" + ";start_candleno=" + start_candleno + ";end_candleno=" + end_candleno + ";offset=" + offset + ";end_offset=" + end_offset);
	..[offset <= end_offset]
	{
		slope = ind("LinearRegression", "slope", price_type, "candle", "none", slope_period)[offset];
		{
			result = slope << slope > result
		||
			result = result << slope <= result
		};
		
		offset += 1c
	};
		
	//result = slope_max
};

// Finds a LR slope min value on a given time section for given period and price type
//  slope_period - train_window value for the SL slope indicator
//  price_type - type of the price for the SL slope indicator
//  start_time - start point for time section
//  end_time - finish time for time section
// Returns slope min value
LR_strategy_Slope_Min(
	slope_period,
	price_type,
	start_time,
	end_time
) :=
{
	result = 0n;
	
	start_candleno = candle.number[start_time];
	end_candleno = candle.number[end_time];
	current_candleno = candle.number;
	
	offset = (start_candleno - current_candleno);
	end_offset = (end_candleno - current_candleno);
	//log("LR_strategy_Slope_Min" + ";start_candleno=" + start_candleno + ";end_candleno=" + end_candleno + ";offset=" + offset + ";end_offset=" + end_offset);
	..[offset <= end_offset]
	{
		slope = ind("LinearRegression", "slope", price_type, "candle", "none", slope_period)[offset];
		{
			result = slope << slope < result
		||
			result = result << slope >= result
		};
		
		offset += 1c
	};
	
	//result = slope_min
};

// 27.02.2026
// OBV indicator by a period
// Parameters:
// - period - period in candles to calculate OBV on
// Returns:
// - OBV calculated by a period
OBV(period) :=
{
	result = 0n;
		
	// +++ Debug
	//log("OBV_started...;period=" + period);
	// ---
	
	vol = 0n;
	i = -period;
	..[i < 0c]
	{
		vol = volume[i];
		{
			result += vol << close[i] > close[i - 1c]
		||
			result -= vol << close[i] <= close[i - 1c]
		};
		
		i += 1c;
	};
	
	// +++ Debug
	//log("OBV_finished;period=" + period + ";OVB=;" + result + ";OVB=;" + result);
	// ---
};

// 05.03.2026
// OBV indicator by a period averaged by the period
// Parameters:
// - period - period in candles to calculate OBV on
// - history_period - period in candles for OBV to compare with
// Returns:
// - (OBV(period) - OBV(history_period)) / OBV(history_period) * 100%
OBVP(period, history_period) :=
{
	result = 0n;
	
	// +++ Debug
	//log("OBVP_started...;period=" + period + ";history_period=;" + history_period);
	// ---
	
	//OBV_period = OBV(period);
	//OBV_history = OBV(history_period)[-period];
	OBV_period = ind("OBV", period);
	OBV_history = ind("OBV", history_period)[-period];
	
	result = (100% * OBV_period / abs(OBV_history));
	//result = OBV_period;
	
	// +++ Debug
	//log("OBVP_finished;period=" + period + ";history_period=;" + history_period + ";OBVP=;" + result 
	//	+ ";OBV_history=;" + OBV_history + ";OBV_period=;" + OBV_period
	//);
	// ---
};

// 23.02.2026
// A service method of LR_strategy_SlopeLevel family.
// Calculates nextTSlong and slope_long values continuesly depending on account value.
// Parameters:
// - 	longTS_line, 	- A line type of the indicator which serves as nextTSlong base
// -	longTS_price_type,	- A price type of the indicator which serves as nextTSlong base
// -	longTS_predict_window_type, - A predict_window type of the indicator which serves as nextTSlong base
// -	longTS_offset_type,	- A offset type of the indicator which serves as nextTSlong base
// -	longTS_train_window_period	- A train_window period of the indicator which serves as nextTSlong base	
// -	current_nextTSlong,		- An initial nextTSlong value
// -	current_slope_long		- An initial slope_long value
// Returns:
// - nextTSlong - a new value for nextTSlong
// - slope_long - a new value for slope_long
LRSLAL_long_CalcNextTSSlope(
	longTS_line, 	// A line type of the indicator which serves as nextTSlong base
	longTS_price_type,	// A price type of the indicator which serves as nextTSlong base
	longTS_predict_window_type, // A predict_window type of the indicator which serves as nextTSlong base
	longTS_offset_type,	// A offset type of the indicator which serves as nextTSlong base
	longTS_train_window_period,	// A train_window period of the indicator which serves as nextTSlong base	
	longTS_slope_start_max,
	current_nextTSlong,		// An initial nextTSlong value
	current_slope_long		// An initial slope_long value
) :=
{
	result = 0n;
	
	{
		// +++ Debug
		old_slope_long = _slope_long << account > 0l;
		debug_str_l = ("debug_moving_nextTSlong" + ";pos.age=" + pos.age + ";longTS_slope_start_max=" + longTS_slope_start_max);
		//log(debug_str_l + ";started...;" + ";pos.age=" + pos.age + ";longTS_slope_start_max=" + longTS_slope_start_max);
		// ---
			
		indicator_slope_long = ind("LinearRegression", "slope", longTS_price_type, longTS_predict_window_type, longTS_offset_type, longTS_train_window_period)[-1c] << account > 0l;
		indicator_nextTSlong = ind("LinearRegression", longTS_line, longTS_price_type, longTS_predict_window_type, longTS_offset_type, longTS_train_window_period)[-1c];
		
		div_slope_long = -1000n;
		{
			div_slope_long = ((indicator_nextTSlong - ind("LinearRegression", longTS_line, longTS_price_type, longTS_predict_window_type, longTS_offset_type, longTS_train_window_period)[-2c]) / 1p)
			<< longTS_predict_window_type == "candle" & longTS_offset_type == "none"
		||
			div_slope_long = div_slope_long << longTS_predict_window_type != "candle" | longTS_offset_type != "none"
		};
		
		{
			current_slope_long = indicator_slope_long << indicator_slope_long > current_slope_long & indicator_slope_long > div_slope_long //& indicator_slope_long > slope_long_start
			;
			// +++ Debug
			debug_str_l += (";indicator_slope_long_the_best" + ";indicator_slope_long=" + indicator_slope_long + ";div_slope_long=" + div_slope_long + ";current_slope_long=" + current_slope_long)
			// ---
		||
			current_slope_long = div_slope_long << div_slope_long > current_slope_long & div_slope_long > indicator_slope_long //& div_slope_long > slope_long_start
			;
			// +++ Debug
			debug_str_l += (";div_slope_long_the_best" + ";indicator_slope_long=" + indicator_slope_long + ";div_slope_long=" + div_slope_long + ";current_slope_long=" + current_slope_long)
			// ---
			
		//||
		//	current_slope_long = slope_long_start << slope_long_start > div_slope_long  & slope_long_start > indicator_slope_long  & slope_long_start > current_slope_long;
		//	// +++ Debug
		//	//debug_str_l += (";slope_long_start_the_best" + ";slope_long_start=" + slope_long_start)
		//	// ---
		||
			current_slope_long = current_slope_long << current_slope_long >= div_slope_long  & current_slope_long >= indicator_slope_long  //& current_slope_long >= slope_long_start
			;
			// +++ Debug
			debug_str_l += (";current_slope_long_the_best" + ";indicator_slope_long=" + indicator_slope_long + ";div_slope_long=" + div_slope_long + ";current_slope_long=" + current_slope_long)
			// ---
		};
			
		// +++ Debug
		//log(debug_str_l + ";selected;" + "pos.age=" + pos.age);
		old_nextTSlong = _nextTSlong;
		// ---
			
		calc_nextTSlong = 1p;
		slope_long_start = (longTS_slope_start_max / ((pos.age + 1c) / 1c));
		{
			calc_nextTSlong = (current_nextTSlong + 1p * current_slope_long) << current_slope_long > slope_long_start;
			// +++ Debug
			debug_str_l += (";current_slope_long_the_best" + ";slope_long_start=" + slope_long_start + ";current_slope_long=" + current_slope_long + ";calc_nextTSlong=" + calc_nextTSlong);
			// ---
		||
			calc_nextTSlong = (current_nextTSlong + 1p * slope_long_start) << current_slope_long <= slope_long_start;
			// +++ Debug
			debug_str_l += (";slope_long_start_the_best" + ";slope_long_start=" + slope_long_start + ";current_slope_long=" + current_slope_long + ";calc_nextTSlong=" + calc_nextTSlong);
			// ---
		};
		
			
		{
			current_nextTSlong = indicator_nextTSlong << indicator_nextTSlong >= calc_nextTSlong;
			// +++ Debug
			debug_str_l += (";indicator_nextTSlong_the_best" + ";indicator_nextTSlong=" + indicator_nextTSlong + ";calc_nextTSlong=" + calc_nextTSlong + ";current_nextTSlong=" + current_nextTSlong);
			// ---
		||
			current_nextTSlong = calc_nextTSlong << calc_nextTSlong > indicator_nextTSlong;
			// +++ Debug
			debug_str_l += (";calc_nextTSlong_the_best" + ";indicator_nextTSlong=" + indicator_nextTSlong + ";calc_nextTSlong=" + calc_nextTSlong + ";current_nextTSlong=" + current_nextTSlong);
			// ---
		};
					
		// +++ Debug
		log(debug_str_l 
		//	+ ";indicator_nextTSlong=;" + indicator_nextTSlong + ";old_nextTSlong=;" + old_nextTSlong + ";nextTSlong=;" + _nextTSlong
		//	+ ";c_nextTSlong=;" + calc_nextTSlong
		//	+ ";indicator_slope_long=;" + indicator_slope_long + ";old_slope_long=;" + old_slope_long + ";slope_long=;" + _slope_long
		//	+ ";div_slope_long=;" + div_slope_long
		);
		// ---
			
	||
		current_slope_long = current_slope_long << account <= 0l;
				
		// +++ Debug
		//log("debug_moving_nextTSlong;skip");
		// ---
	};
	
	result = new("dict");
	result["nextTSlong"] = current_nextTSlong;
	result["slope_long"] = current_slope_long;
};

// 23.02.2026
// A service method of LR_strategy_SlopeLevel family.
// Calculates nextTSshort and slope_short values continuesly depending on account value.
// Parameters:
// - 	shortTS_line, 	- A line type of the indicator which serves as nextTSlong base
// -	shortTS_price_type,	- A price type of the indicator which serves as nextTSlong base
// -	shortTS_predict_window_type, - A predict_window type of the indicator which serves as nextTSlong base
// -	shortTS_offset_type,	- A offset type of the indicator which serves as nextTSlong base
// -	shortTS_train_window_period	- A train_window period of the indicator which serves as nextTSlong base	
// -	current_nextTSshort,		- An initial nextTSlong value
// -	current_slope_short		- An initial slope_long value
// Returns:
// - nextTSshort - a new value for nextTSshort
// - slope_short - a new value for slope_short
LRSLAL_short_CalcNextTSSlope(
	shortTS_line, 	// A line type of the indicator which serves as nextTSshort base
	shortTS_price_type,	// A price type of the indicator which serves as nextTSshort base
	shortTS_predict_window_type, // A predict_window type of the indicator which serves as nextTSshort base
	shortTS_offset_type,	// A offset type of the indicator which serves as nextTSshort base
	shortTS_train_window_period,	// A train_window period of the indicator which serves as nextTSshort base	
	shortTS_slope_start_max,
	current_nextTSshort,		// An initial nextTSshort value
	current_slope_short		// An initial slope_short value
) :=
{
	result = 0n;
	
	{
		// Debug
		//old_slope_short = slope_short;
		//debug_str_s = "debug_moving_nextTSshort";
			
		//log(debug_str_s + ";started...");
			
		indicator_slope_short = ind("LinearRegression", "slope", shortTS_price_type, shortTS_predict_window_type, shortTS_offset_type, shortTS_train_window_period)[-1c] << account < 0l;
		indicator_nextTSshort = (ind("LinearRegression", shortTS_line, shortTS_price_type, shortTS_predict_window_type, shortTS_offset_type, shortTS_train_window_period)[-1c]);
		
		div_slope_short = 1000n;
		{
			div_slope_short = ((indicator_nextTSshort - ind("LinearRegression", shortTS_line, shortTS_price_type, shortTS_predict_window_type, shortTS_offset_type, shortTS_train_window_period)[-2c]) / 1p)
			<< shortTS_predict_window_type == "candle" & shortTS_offset_type == "none"
		||
			div_slope_short = div_slope_short << shortTS_predict_window_type != "candle" | shortTS_offset_type != "none"
		};
		
		{
			current_slope_short = indicator_slope_short << indicator_slope_short < current_slope_short & indicator_slope_short < div_slope_short //& indicator_slope_short < slope_short_start
			;
			// Debug
			//debug_str_s += ";indicator_slope_short_the_best"
		||
			current_slope_short = div_slope_short << div_slope_short < current_slope_short & div_slope_short < indicator_slope_short //& div_slope_short < slope_short_start
			;
			// Debug
			//debug_str_s += ";div_slope_short_the_best"
			
		//||
		//	current_slope_short = slope_short_start << slope_short_start < div_slope_short  & slope_short_start < indicator_slope_short  & slope_short_start < current_slope_short;
		//	// Debug
		//	//debug_str_s += ";slope_short_start_the_best"
		||
			current_slope_short = current_slope_short << current_slope_short <= div_slope_short  & current_slope_short <= indicator_slope_short  //& current_slope_short <= slope_short_start
			;
			// Debug
			//debug_str_s += ";current_slope_short_the_best"
		};
			
		// Debug
		//log(debug_str_s + ";selected...");
		//old_nextTSshort = nextTSshort;
			
		calc_nextTSshort = 1p;
		slope_short_start = (shortTS_slope_start_max / ((pos.age + 1c) / 1c));
		{
			calc_nextTSshort = (current_nextTSshort + 1p * current_slope_short) << current_slope_short < slope_short_start
		||
			calc_nextTSshort = (current_nextTSshort + 1p * slope_short_start) << current_slope_short >= slope_short_start
		};
			
		{
			current_nextTSshort = indicator_nextTSshort << indicator_nextTSshort <= calc_nextTSshort;
			// Debug
			//debug_str_s += ";indicator_nextTSshort_the_best";
		||
			current_nextTSshort = calc_nextTSshort << calc_nextTSshort < indicator_nextTSshort;
			// Debug
			//debug_str_s += ";calc_nextTSshort_the_best";
		};
					
		// Debug
		//log(debug_str_s + ";indicator_nextTSshort=;" + indicator_nextTSshort + ";old_nextTSshort=;" + old_nextTSshort + ";nextTSshort=;" + current_nextTSshort
		//	+ ";c_nextTSshort=;" + calc_nextTSshort
		//	+ ";indicator_slope_short=;" + indicator_slope_short + ";old_slope_short=;" + old_slope_short + ";slope_short=;" + current_slope_short
		//	+ ";div_slope_short=;" + div_slope_short
		//);	
						
	||
		current_slope_short = current_slope_short << account >= 0l;
				
		// +++ Debug
		//log("debug_moving_nextTSlong;skip");
		// ---
	};
	
	result = new("dict");
	result["nextTSshort"] = current_nextTSshort;
	result["slope_short"] = current_slope_short;
};

// 23.02.2026
// A service method of LR_strategy_SlopeLevel family.
// Calculates first step nextTSlong and slope_long values.
// Parameters:
// - 	longTS_line, 	- A line type of the indicator which serves as nextTSlong base
// -	longTS_price_type,	- A price type of the indicator which serves as nextTSlong base
// -	longTS_predict_window_type, - A predict_window type of the indicator which serves as nextTSlong base
// -	longTS_offset_type,	- A offset type of the indicator which serves as nextTSlong base
// -	longTS_train_window_period	- A train_window period of the indicator which serves as nextTSlong base	
// -	current_nextTSlong,		- An initial nextTSlong value
// -	current_slope_long		- An initial slope_long value
// Returns:
// - nextTSlong - a new value for nextTSlong
// - slope_long - a new value for slope_long
LRSLAL_long_Calc1NextTSSlope(
	longTS_line, 	// A line type of the indicator which serves as nextTSlong base
	longTS_price_type,	// A price type of the indicator which serves as nextTSlong base
	longTS_offset_type,	// A offset type of the indicator which serves as nextTSlong base
	longTS_train_window_period,	// A train_window period of the indicator which serves as nextTSlong base
	longTS_slope_start,			// Initial slope value
	current_nextTSlong,		// An initial nextTSlong value
	current_slope_long		// An initial slope_long value
) :=
{
	result = 0n;
	
	slope_type = "";
		
	nextTSlong_index = find_min_price_index(longTS_train_window_period);
	current_slope_long = ind("LinearRegression", "slope", longTS_price_type, "once", longTS_offset_type, candle.time[nextTSlong_index - 2c], candle.time[-1c]);
	
	{
		current_slope_long = longTS_slope_start << current_slope_long < longTS_slope_start;
		current_nextTSlong = (low[nextTSlong_index] + abs(nextTSlong_index) / 1c * current_slope_long * 1p);
		slope_type = "start_slope";
	||
		current_slope_long = current_slope_long << current_slope_long >= longTS_slope_start;
		current_nextTSlong = ind("LinearRegression", longTS_line, longTS_price_type, "once", longTS_offset_type, candle.time[nextTSlong_index-2c], candle.time[-1c]);
		slope_type = "calculated_slope";
	};

	result = new("dict");
	result["nextTSlong"] = current_nextTSlong;
	result["slope_long"] = current_slope_long;
	result["nextTSlong_index"] = nextTSlong_index;
	result["slope_type"] = slope_type;
}; 	

// 23.02.2026
// A service method of LR_strategy_SlopeLevel family.
// Calculates first step nextTSshort and slope_short values.
// Parameters:
// - 	shortTS_line, 	- A line type of the indicator which serves as nextTSshort base
// -	shortTS_price_type,	- A price type of the indicator which serves as nextTSshort base
// -	shortTS_offset_type,	- A offset type of the indicator which serves as nextTSshort base
// -	shortTS_train_window_period	- A train_window period of the indicator which serves as nextTSshort base	
// -	current_nextTSshort,		- An initial nextTSshort value
// -	current_slope_short		- An initial slope_short value
// Returns:
// - nextTSshort - a new value for nextTSshort
// - slope_short - a new value for slope_short
LRSLAL_short_Calc1NextTSSlope(
	shortTS_line, // a line type of the indicator which serves as nextTSshort base
	shortTS_price_type, // a price type of the indicator which serves as nextTSshort base
	shortTS_offset_type, // an offset type of the indicator which serves as nextTSshort base
	shortTS_train_window_period, // a train_window period of the indicator which serves as nextTSshort base	
	shortTS_slope_start, // Starting slope of linear regression for a short position
	current_nextTSshort,		// An initial nextTSshort value
	current_slope_short		// An initial slope_short value
) :=
{
	result = 0n;
	
	slope_type = "";
	
	nextTSshort_index = find_max_price_index(shortTS_train_window_period);
	current_slope_short = ind("LinearRegression", "slope", shortTS_price_type, "once", shortTS_offset_type, candle.time[nextTSshort_index - 2c], candle.time[-1c]);
	
	{
		current_slope_short = shortTS_slope_start << current_slope_short > shortTS_slope_start;
		current_nextTSshort = (high[nextTSshort_index] + abs(nextTSshort_index) / 1c * current_slope_short * 1p);
		slope_type = "start_slope";
	||
		current_slope_short = current_slope_short << current_slope_short <= shortTS_slope_start;
		current_nextTSshort = ind("LinearRegression", shortTS_line, shortTS_price_type, "once", shortTS_offset_type, candle.time[nextTSshort_index-2c], candle.time[-1c]);
		slope_type = "calculated_slope";
	};

	result = new("dict");
	result["nextTSshort"] = current_nextTSshort;
	result["slope_short"] = current_slope_short;
	result["nextTSshort_index"] = nextTSshort_index;
	result["slope_type"] = slope_type;
}; 	

// A service method of LR_strategy_long_SlopeLevel_AdaptiveLots family.
// Tests a condition for a long position
// 4.03.2026
LR_strategy_long_condition_SlopeLevel_AdaptiveLots_35022(
	expiration_time, 	// Time when to stop the strategy
	
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
	
	//  long_closing:
	longTS_line, // a line type of the indicator which serves as nextTSlong base
	longTS_price_type, // a price type of the indicator which serves as nextTSlong base
	longTS_offset_type, // an offset type of the indicator which serves as nextTSlong base
	longTS_train_window_period, // a train_window period of the indicator which serves as nextTSlong base	
	longTS_predict_window_type, // a predict_window type of the indicator which serves as nextTSlong base	
	longTS_slope_start // Starting slope of linear regression for a long position
) :=
{
	// +++ Debug
	long_OBVP1 = 0%;
	long_OBVP7 = 0%;
	// --- Debug
	
	result = 0n;
	nextTSlong_index = 0c;
	nextTSlong = 0p;
	
	offset = LR_strategy_condition_start_time();
	
	_long_con0 = (_long_con1 = (_long_con2 = (_long_con3 = (_long_con5 = (_long_con6 = (_long_con7 = (_long_con8 = false)))))));
	_long_con0 = ((time < expiration_time & (time >= _day_start_time & time < _day_end_time | time >= _night_start_time & time < _night_end_time) & account == 0l);
	{
		_long_con1 = (close[offset] #^ ind("LinearRegression", long_open_A_line, A_high_price_type, A_predict_window_type, A_high_offset_type, A_train_window_period)[offset]) << _long_con0 == true;
		_long_con7 = (close[offset] #^ ind("LinearRegression", long_open_B_line, B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period)[offset]) << _long_con0 == true;
		
		{
			_long_con12 = (	
				ind("LinearRegression", "slope", B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)[offset] > 0n
				//&
				//close[offset] < ind("LinearRegression", "low", B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period)[offset]
				//&
				//close[offset] > ind("LinearRegression", "high", B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)
				| 
				ind("LinearRegression", "slope", B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)[offset] <= 0n
				&
				close[offset] > ind("LinearRegression", "high", B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period)[offset]
			) << _long_con1 == true;
			
			{
				_long_con16 = true/*(close[offset] > ind("LinearRegression", "high", B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period))*/ << _long_con12 == true;
				
				{
					res = LRSLAL_long_Calc1NextTSSlope(
							longTS_line, 	// A line type of the indicator which serves as nextTSlong base
							longTS_price_type,	// A price type of the indicator which serves as nextTSlong base
							longTS_offset_type,	// A offset type of the indicator which serves as nextTSlong base
							longTS_train_window_period,	// A train_window period of the indicator which serves as nextTSlong base	
							longTS_slope_start,	// Initial slope value
							_nextTSlong,	// An initial nextTSlong value
							_slope_long	// An initial slope_long value
					) << _long_con16 == true;

					_long_con18 = (close[offset] > res["nextTSlong"] /*& close[offset] <= high[res["nextTSlong_index"]]*/);
					_long_con19 = true;//(long_OBVP1 = OBVP(long_open_OBV_period, long_open_OBV_period/*B_train_window_period*/) > long_open_OBV_level);
					//_long_con19 = (
					//			ind("LinearRegression", "low", A_low_price_type, A_predict_window_type, A_low_offset_type, A_train_window_period) < 
					//			ind("LinearRegression", "high", B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period)
					//		);
					_long_con10 = (_long_con18 & _long_con19)
				||
					_long_con10 = false << _long_con16 != true
				}
			||
				_long_con10 = false << _long_con12 != true;
			};
			
		||
			_long_con10 = false << _long_con1 != true
		};
		
		{
			_long_con76 = (close[offset] > ind("LinearRegression", long_open_A_line, A_high_price_type, A_predict_window_type, A_high_offset_type, A_train_window_period)[offset]) << _long_con7 == true;
			
			{
				res = LRSLAL_long_Calc1NextTSSlope(
						longTS_line, 	// A line type of the indicator which serves as nextTSlong base
						longTS_price_type,	// A price type of the indicator which serves as nextTSlong base
						longTS_offset_type,	// A offset type of the indicator which serves as nextTSlong base
						longTS_train_window_period,	// A train_window period of the indicator which serves as nextTSlong base	
						longTS_slope_start,	// Initial slope value
						_nextTSlong,	// An initial nextTSlong value
						_slope_long	// An initial slope_long value
				) << _long_con76 == true;

				_long_con78 = (close[offset] > res["nextTSlong"] & close[offset] > high[res["nextTSlong_index"]]);
				_long_con79 = (long_OBVP7 = OBVP(long_open_OBV_period, long_open_OBV_period/*B_train_window_period*/) > long_open_OBV_level);
				_long_con70 = (_long_con78 & _long_con79)
			||
				_long_con70 = false << _long_con76 != true
			}
		||
			_long_con70 = false << _long_con7 != true
		};
		
		result = (_long_con10 | _long_con70)
		
	||
		result = false << _long_con0 != true
	};
	
	_long_result = result;
	
	// +++ Debug 08.08.2025 --------------------------------------------------------------------------
	//log("LR_strategy_long_condition_SlopeLevel_AdaptiveLots" + ";step=;" + step + ";result=;" + result 
	//	+ ";long_OBVP1=;" + long_OBVP1 + ";long_OBVP7=;" + long_OBVP7
	//	+ ";con0=;" + _long_con0 + ";con1=;" + _long_con1 + ";con2=;" + _long_con2 + ";con3=;" + _long_con3 
	//	+ ";con5=;" + _long_con5 + ";con6=;" + _long_con6 + ";con7=;" + _long_con7 + ";con8=;" + _long_con8 
	//	+ ";nextTSlong_index=;" + nextTSlong_index + ";nextTSlong=;" + nextTSlong + ";close[offset]=;" + close[offset]
	//	//+ ";supportLH=;" + ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support)
	//	//+ ";supportHL=;" + ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)
	//);
	// --- Debug 08.08.2025 --------------------------------------------------------------------------
};

// A service method of LR_strategy_short_SlopeLevel_AdaptiveLots family.
// Tests a condition for a short position
// 4.03.2026
LR_strategy_short_condition_SlopeLevel_AdaptiveLots_35022(
	expiration_time, 	// Time when to stop the strategy
	
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
	
	//  short_opening:
	short_open_A_line, // type of A_channel line which raises condition1 := ("high" || "low" || "line")
	short_open_B_line, // type of B_channel line which raises condition7 := ("high" || "low" || "line")
	short_open_OBV_period,
	short_open_OBV_level, // level of OBV for condition9
	
	//  short_closing:
	shortTS_line, // a line type of the indicator which serves as nextTSshort base
	shortTS_price_type, // a price type of the indicator which serves as nextTSshort base
	shortTS_offset_type, // an offset type of the indicator which serves as nextTSshort base
	shortTS_train_window_period, // a train_window period of the indicator which serves as nextTSshort base	
	shortTS_predict_window_type, // a predict_window type of the indicator which serves as nextTSshort base	
	shortTS_slope_start // Starting slope of linear regression for a short position
) :=
{
	result = 0n;
	nextTSshort_index = 0c;
	nextTSshort = 0p;
	
	offset = LR_strategy_condition_start_time();
	
	_short_con0 = (_short_con1 = (_short_con2 = (_short_con3 = (_short_con5 = (_short_con6 = (_short_con7 = (_short_con8 = false)))))));
	_short_con0 = ((time < expiration_time & (time >= _day_start_time & time < _day_end_time | time >= _night_start_time & time < _night_end_time) & account == 0l);
	{
		_short_con1 = (close[offset] #_ ind("LinearRegression", short_open_A_line, A_low_price_type, A_predict_window_type, A_low_offset_type, A_train_window_period)[offset]) << _short_con0 == true;
		_short_con7 = (close[offset] #_ ind("LinearRegression", short_open_B_line, B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)[offset]) << _short_con0 == true;
		{
			_short_con12 = (
					ind("LinearRegression", "slope", B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period)[offset] < 0n
					//&
					//close[offset] > ind("LinearRegression", "high", B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)[offset]
					//&
					//close[offset] < ind("LinearRegression", "low", B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period)
					| 
					ind("LinearRegression", "slope", B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period)[offset] >= 0n
					&
					close[offset] < ind("LinearRegression", "low", B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)[offset]
			) << _short_con1 == true;
			
			{
				_short_con16 = true/*(close[offset] < ind("LinearRegression", "low", B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period))*/ << _short_con12 == true;
						
				{
					res = LRSLAL_short_Calc1NextTSSlope(								
							shortTS_line, // a line type of the indicator which serves as nextTSshort base
							shortTS_price_type, // a price type of the indicator which serves as nextTSshort base
							shortTS_offset_type, // an offset type of the indicator which serves as nextTSshort base
							shortTS_train_window_period, // a train_window period of the indicator which serves as nextTSshort base	
							shortTS_slope_start, // Starting slope of linear regression for a short position
							_nextTSshort,	// An initial nextTSshort value
							_slope_short	// An initial slope_short value
					) << _short_con16 == true;

					_short_con18 = (close[offset] < res["nextTSshort"] /*& close[offset] >= low[res["nextTSshort_index"]]*/);
					_short_con19 = true;//(OBVP(short_open_OBV_period, short_open_OBV_period/*B_train_window_period*/) < short_open_OBV_level);
					//_short_con19 = (
					//			ind("LinearRegression", "high", A_high_price_type, A_predict_window_type, A_high_offset_type, A_train_window_period) >
					//			ind("LinearRegression", short_open_B_line, B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)
					//		);
					_short_con10 = (_short_con18 & _short_con19)
				||
					_short_con10 = false << _short_con16 != true
				}
			||
				_short_con10 = false << _short_con12 != true
			}
			
		||
			_short_con10 = false << _short_con1 != true
		};
		
		{
			_short_con76 = (close[offset] < ind("LinearRegression", short_open_A_line, A_low_price_type, A_predict_window_type, A_low_offset_type, A_train_window_period)[offset]) << _short_con7 == true
						
			{
				res = LRSLAL_short_Calc1NextTSSlope(								
						shortTS_line, // a line type of the indicator which serves as nextTSshort base
						shortTS_price_type, // a price type of the indicator which serves as nextTSshort base
						shortTS_offset_type, // an offset type of the indicator which serves as nextTSshort base
						shortTS_train_window_period, // a train_window period of the indicator which serves as nextTSshort base	
						shortTS_slope_start, // Starting slope of linear regression for a short position
						_nextTSshort,	// An initial nextTSshort value
						_slope_short	// An initial slope_short value
				) << _short_con76 == true;

				_short_con78 = (close[offset] < res["nextTSshort"] & close[offset] < low[res["nextTSshort_index"]]);
				_short_con79 = (OBVP(short_open_OBV_period, short_open_OBV_period/*B_train_window_period*/) < short_open_OBV_level);
				_short_con70 = (_short_con78 & _short_con79)
			||
				_short_con70 = false << _short_con76 != true
			}
		||
			_short_con70 = false << _short_con7 != true
		};
		
		result = (_short_con10 | _short_con70)
		
	||
		result = false << _short_con0 != true
	};
	
	_short_result = result;
	
	// +++ Debug 08.08.2025 --------------------------------------------------------------------------
	/*
	log("LR_strategy_short_condition_SlopeLevel_AdaptiveLots" + ";step=;" + step + ";result=;" + result 
		+ ";con0=;" + _short_con0 + ";con1=;" + _short_con1 + ";con2=;" + _short_con2 + ";con3=;" + _short_con3 
		+ ";con5=;" + _short_con5 + ";con6=;" + _short_con6 + ";con7=;" + _short_con7 + ";con8=;" + _short_con8 
		+ ";nextTSshort_index=;" + nextTSshort_index + ";nextTSshort=;" + nextTSshort + ";close[offset]=;" + close[offset]
		//+ ";resistanceLH=;" + ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)
		//+ ";resistanceHL=;" + ind("LinearRegression", "high", "low", predict_window_resistance, "low", train_window_resistance)
	);
	*/
	// --- Debug 08.08.2025 --------------------------------------------------------------------------
	
	/* Debug Section 2.06.2024
	log("LR_strategy_short_condition_SlopeLevel_AdaptiveLots;offset=;" + offset + ";result=;" + result
		+ ";con0=;" + con0 + ";con1=;" + con1 + ";con2=;" + con2 + ";con3=;" + con3 + ";con4=;" + con4 + ";con5=;" + con5 + ";con6=;" + con6
	);
	*/
};
// A service method of LR_strategy_SlopeLevel_AdaptiveLots family.
// Opens a long position
LR_strategy_long_SlopeLevel_AdaptiveLots_35022(
	p_safety_stock,	// Safety stock in percents to the equity
	p_risk_L,		// Risk rate in percents for long positions
	
	longTS_line, // a line type of the indicator which serves as nextTSlong base
	longTS_price_type, // a price type of the indicator which serves as nextTSlong base
	longTS_offset_type, // an offset type of the indicator which serves as nextTSlong base
	longTS_train_window_period, // a train_window period of the indicator which serves as nextTSlong base	
	longTS_slope_start, // Starting slope of linear regression for a long position
	longTP_level // TP level in percents
) :=
{
	/* +++ Debug Section 2.06.2024
	lots = 0p;
	log("LR_strategy_long_SlopeLevel_AdaptiveLots;started"
		+ ";p_day_start_time=;" + p_day_start_time+ ";p_day_end_time=;" + p_day_end_time
		+ ";p_night_start_time=;" + p_night_start_time+ ";p_night_end_time=;" + p_night_end_time
	);*/

	lots = 0p;
	lots = CalculateLotsToLong(p_safety_stock, p_risk_L);
	log("long_lr_break_open_following;trying_to_open_long;lots=;" + lots);
	my_account = account;
	result = long(lots);
			
	res = LRSLAL_long_Calc1NextTSSlope(
		longTS_line, 	// A line type of the indicator which serves as nextTSlong base
		longTS_price_type,	// A price type of the indicator which serves as nextTSlong base
		longTS_offset_type,	// A offset type of the indicator which serves as nextTSlong base
		longTS_train_window_period,	// A train_window period of the indicator which serves as nextTSlong base	
		longTS_slope_start,	// Initial slope value
		_nextTSlong,	// An initial nextTSlong value
		_slope_long	// An initial slope_long value
	) 
	<< account > my_account;

	_nextTSlong = (res["nextTSlong"]);
	_slope_long = (res["slope_long"]);
	nextTSlong_index = (res["nextTSlong_index"]);
	slope_type = (res["slope_type"]);
	_nextTPlong = (pos.price + longTP_level);
	_absSLlong = (pos.price - CalculateSLLong(p_safety_stock, p_risk_L));
	
	log("long_lr_break_open_following;" + slope_type + ";pos.price=;" + pos.price + ";account=;" + account + ";lots=;" + lots 
		+ ";start_time=;" + candle.time[nextTSlong_index] + ";start_low=;" + low[nextTSlong_index] 
		+ ";nextTSlong_time=;" + candle.time[-1c] + ";nextTSlong=;" + _nextTSlong + ";slope_long=;" + _slope_long
		+ ";absSLlong=;" + _absSLlong + ";nextTPlong=;" + _nextTPlong + ";step=;" + step);
	~
};

// A service method of LR_strategy_SlopeLevel family.
// Opens a short position
LR_strategy_short_SlopeLevel_AdaptiveLots_35022(
	p_safety_stock,	// Safety stock in percents to the equity
	p_risk_S,		// Risk rate in percents for short positions
	
	shortTS_line, // a line type of the indicator which serves as nextTSshort base
	shortTS_price_type, // a price type of the indicator which serves as nextTSshort base
	shortTS_offset_type, // an offset type of the indicator which serves as nextTSshort base
	shortTS_train_window_period, // a train_window period of the indicator which serves as nextTSshort base	
	shortTS_slope_start, // Starting slope of linear regression for a short position
	shortTP_level // TP level in percents
) :=
{			
	/* +++ Debug Section 2.06.2024
	lots = 0p;
	log("LR_strategy_short_SlopeLevel_AdaptiveLots;started"
		+ ";p_day_start_time=;" + p_day_start_time+ ";p_day_end_time=;" + p_day_end_time
		+ ";p_night_start_time=;" + p_night_start_time+ ";p_night_end_time=;" + p_night_end_time
	);*/

	lots = 0p;
	lots = CalculateLotsToShort(p_safety_stock, p_risk_S);
	log("short_lr_break_open_following;trying_to_open_short" + ";lots=;" + lots + ";step=;" + step);
	my_account = account;
	result = short(lots);
			
	res = LRSLAL_short_Calc1NextTSSlope(
		shortTS_line, // a line type of the indicator which serves as nextTSshort base
		shortTS_price_type, // a price type of the indicator which serves as nextTSshort base
		shortTS_offset_type, // an offset type of the indicator which serves as nextTSshort base
		shortTS_train_window_period, // a train_window period of the indicator which serves as nextTSshort base	
		shortTS_slope_start, // Starting slope of linear regression for a short position
		_nextTSshort,	// An initial nextTSshort value
		_slope_short	// An initial slope_short value
	) 
	<< account < my_account;

	_nextTSshort = (res["nextTSshort"]);
	_slope_short = (res["slope_short"]);
	nextTSshort_index = (res["nextTSshort_index"]);
	slope_type = (res["slope_type"]);
	_nextTPshort = (pos.price - shortTP_level);
	_absSLshort = (pos.price + CalculateSLShort(p_safety_stock, p_risk_S));
	
	log("short_lr_break_open_following;" + slope_type + ";pos.price=;" + pos.price + ";account=;" + account + ";lots=;" + lots 
		+ ";start_time=;" + candle.time[nextTSshort_index] + ";start_high=;" + high[nextTSshort_index] 
		+ ";nextTSshort_time=;" + candle.time[-1c] + ";nextTSshort=;" + _nextTSshort + ";slope_short=;" + _slope_short
		+ ";absSLshort=;" + _absSLshort + ";nextTPshort=;" + _nextTPshort + ";step=;" + step);
	~
};

// Original LR strategy with managing a slope level and calculating lots adaptively.
// It opens a position only when the current slope is above or below a given slope level
// 4.03.2026
// Parameters:
//  A_channel:
//  - A_train_window_period - a number of candles in history to train the model on
//  - A_predict_window_type - a period of time in the future for forecasting := ("candle" || "day" || "week")
//  - A_high_price_type - type of price as base for the high channel's border := (open || close || high || low)
//  - A_low_price_type - type of price as base for the low channel's border := (open || close || high || low)
//  - A_high_offset_type := ("high" || "low" || "none")
//  - A_low_offset_type := ("high" || "low" || "none")
//  B_channel:
//  - B_train_window_period - a number of candles in history to train the model on
//  - B_predict_window_type - a period of time in the future for forecasting := ("candle" || "day" || "week")
//  - B_high_price_type - type of price as base for the high channel's border := (open || close || high || low)
//  - B_low_price_type - type of price as base for the low channel's border := (open || close || high || low)
//  - B_high_offset_type := ("high" || "low" || "none")
//  - B_low_offset_type := ("high" || "low" || "none")
//  long_opening:
//  - long_open_A_line - type of A_channel line which raises condition1 := ("high" || "low" || "line")
//  - long_open_B_line - type of B_channel line which raises condition7 := ("high" || "low" || "line")
//  - long_open_OBV_period
//  - long_open_OBV_level - level of OBV for condition9
//  short_opening:
//  - short_open_A_line - type of A_channel line which raises condition1 := ("high" || "low" || "line")
//  - short_open_B_line - type of B_channel line which raises condition7 := ("high" || "low" || "line")
//  - short_open_OBV_period
//  - short_open_OBV_level - level of OBV for condition9
//  long_closing:
//  - longTS_line - a line type of the indicator which serves as nextTSlong base
//  - longTS_price_type - a price type of the indicator which serves as nextTSlong base
//  - longTS_offset_type - an offset type of the indicator which serves as nextTSlong base
//  - longTS_train_window_period - a train_window period of the indicator which serves as nextTSlong base	
//  - longTS_predict_window_type - a predict_window type of the indicator which serves as nextTSlong base	
//  - longTP_level - TP level in percents
//  short_closing:
//  - shortTS_line - a line type of the indicator which serves as nextTSshort base
//  - shortTS_price_type - a price type of the indicator which serves as nextTSshort base
//  - shortTS_offset_type - an offset type of the indicator which serves as nextTSshort base
//  - shortTS_train_window_period - a train_window period of the indicator which serves as nextTSshort base	
//  - shortTS_predict_window_type - a predict_window type of the indicator which serves as nextTSshort base	
//  - shortTP_level - TP level in percents
LR_strategy_SlopeLevel_AdaptiveLots_35022(
	safety_stock,	// Safety stock in percents to the equity
	risk_L,		// Risk rate in percents for long positions
	risk_S,		// Risk rate in percents for short positions
	
	expiration_time, 	// Time when to stop the strategy
	
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
	shortTP_level, // TP level in percents

	longTS_slope_start_max, // Starting max slope of linear regression for a long position
	shortTS_slope_start_max // Starting max slope of linear regression for a short position
) :=
{
	my_start_equity = equity;
	my_start_time = time;
	
	import("%QTrader_Libs%\QTrader_stdlib.aql");
	import("%QTrader_Libs%\QTrader_LR_stdlib.aql");

	log("LR_strategy_SlopeLevel_AdaptiveLots_3502_has_started_and_running...");
	log("LR_strategy_SlopeLevel_AdaptiveLots_3502_params=("); 
	log("    safety_stock=;" + safety_stock + ","); 
	log("    risk_L=;" + risk_L + ","); 
	log("    risk_S=;" + risk_S + ","); 
	log("    expiration_time=;" + expiration_time + ",");
	log("    day_start_time=;" + day_start_time);
	log("    day_end_time=;" + day_end_time);
	log("    night_start_time=;" + night_start_time);
	log("    night_end_time=;" + night_end_time);
	
	log("    A_train_window_period=;" + A_train_window_period + ","); 
	log("    A_predict_window_type=;" + A_predict_window_type + ","); 
	log("    A_high_price_type=;" + A_high_price_type + ","); 
	log("    A_low_price_type=;" + A_low_price_type + ",");
	log("    A_high_offset_type=;" + A_high_offset_type + ","); 
	log("    A_low_offset_type=;" + A_low_offset_type + ",");
	log("    B_train_window_period=;" + B_train_window_period + ","); 
	log("    B_predict_window_type=;" + B_predict_window_type + ","); 
	log("    B_high_price_type=;" + B_high_price_type + ","); 
	log("    B_low_price_type=;" + B_low_price_type + ",");
	log("    B_high_offset_type=;" + B_high_offset_type + ","); 
	log("    B_low_offset_type=;" + B_low_offset_type + ",");
	
	log("    long_open_A_line=;" + long_open_A_line + ","); 
	log("    long_open_B_line=;" + long_open_B_line + ",");
	log("    long_open_OBV_period=;" + long_open_OBV_period + ","); 
	log("    long_open_OBV_level=;" + long_open_OBV_level + ",");
	log("    short_open_A_line=;" + short_open_A_line + ","); 
	log("    short_open_B_line=;" + short_open_B_line + ",");
	log("    short_open_OBV_period=;" + short_open_OBV_period + ","); 
	log("    short_open_OBV_level=;" + short_open_OBV_level + ",");
	
	log("    longTS_line=;" + longTS_line + ",");
	log("    longTS_price_type=;" + longTS_price_type + ",");
	log("    longTS_offset_type=;" + longTS_offset_type + ",");
	log("    longTS_train_window_period=;" + longTS_train_window_period + ",");
	log("    longTS_predict_window_type=;" + longTS_predict_window_type + ",");
	log("    longTS_slope_start=;" + longTS_slope_start + ",");
	log("    longTP_line=;" + longTP_line + ",");
	log("    longTP_price_type=;" + longTP_price_type + ",");
	log("    longTP_offset_type=;" + longTP_offset_type + ",");
	log("    longTP_train_window_period=;" + longTP_train_window_period + ",");
	log("    longTP_predict_window_type=;" + longTP_predict_window_type + ",");
	log("    longTP_level=;" + longTP_level + ",");
	
	log("    shortTS_line=;" + shortTS_line + ",");
	log("    shortTS_price_type=;" + shortTS_price_type + ",");
	log("    shortTS_offset_type=;" + shortTS_offset_type + ",");
	log("    shortTS_train_window_period=;" + shortTS_train_window_period + ",");
	log("    shortTS_predict_window_type=;" + shortTS_predict_window_type + ",");
	log("    shortTS_slope_start=;" + shortTS_slope_start + ",");
	log("    shortTP_line=;" + shortTP_line + ",");
	log("    shortTP_price_type=;" + shortTP_price_type + ",");
	log("    shortTP_offset_type=;" + shortTP_offset_type + ",");
	log("    shortTP_train_window_period=;" + shortTP_train_window_period + ",");
	log("    shortTP_predict_window_type=;" + shortTP_predict_window_type + ",");
	log("    shortTP_level=;" + shortTP_level + ",");
	
	log("    longTS_slope_start_max=;" + longTS_slope_start_max + ",");
	log("    shortTS_slope_start_max=;" + shortTS_slope_start_max + ",");
	log(")");
	
	nextTSlong = low;
	nextTSshort = high;
	slope_long = longTS_slope_start;
	slope_short = shortTS_slope_start;
	//slope_long_start = longTS_slope_start;
	//slope_short_start = shortTS_slope_start;
	
	absSLlong = nextTSlong;
	absSLshort = nextTSshort;
	
	nextTPlong = low;
	nextTPshort = high;
	
	session_abs_profit_long = 0p;
	session_abs_profit_short = 0p;
	session_abs_loss_long = -1p;
	session_abs_loss_short = -1p;
	
	session_abs_profit = 0p;
	session_abs_loss = 0p;
	session_PL_rate = 0n;
	session_PL_rate_long = 0n;
	session_PL_rate_short = 0n;

	long_result = false;
	long_con0 = false;
	long_con1 = false;
	long_con10 = false;
	long_con12 = false; 
	long_con16 = false; 
	long_con18 = false; 
	long_con19 = false; 
	long_con7 = false; 
	long_con70 = false; 
	long_con76 = false; 
	long_con78 = false; 
	long_con79 = false; 
	
	short_result = false;
	short_con0 = false;
	short_con1 = false;
	short_con10 = false;
	short_con12 = false; 
	short_con16 = false; 
	short_con18 = false; 
	short_con19 = false; 
	short_con7 = false; 
	short_con70 = false; 
	short_con76 = false; 
	short_con78 = false; 
	short_con79 = false; 
				
	{
		predict_window_type = "candle";
		//step = 0n; 
		..
		{
			this_night_end_time = night_end_time;
			
			{
				day_start_time = day_start_time << time >= night_end_time;
				
				..[time >= night_end_time]
				{
					day_start_time += 1D << time >= night_end_time;
					day_end_time += 1D;
					night_start_time += 1D;
					night_end_time += 1D;
				};
			||
				day_start_time = day_start_time << time < night_end_time
			};
			
			{
				log("step=;" + step 
				+ ";account=;" + account 
				+ ";equity=;" + equity 
				+ ";ahigh=;" + ind("LinearRegression", "line", A_high_price_type, A_predict_window_type, A_high_offset_type, A_train_window_period) 
				+ ";ahhigh=;" + ind("LinearRegression", "high", A_high_price_type, A_predict_window_type, A_high_offset_type, A_train_window_period) 
				+ ";alhigh=;" + ind("LinearRegression", "low", A_high_price_type, A_predict_window_type, A_high_offset_type, A_train_window_period) 
				+ ";ahigh.slope=;" + ind("LinearRegression", "slope", A_high_price_type, A_predict_window_type, A_high_offset_type, A_train_window_period) 
				+ ";ahigh.mae=;" + ind("LinearRegression", "mae", A_high_price_type, A_predict_window_type, A_high_offset_type, A_train_window_period) 
				+ ";alow=;" + ind("LinearRegression", "line", A_low_price_type, A_predict_window_type, A_low_offset_type, A_train_window_period)
				+ ";ahlow=;" + ind("LinearRegression", "high", A_low_price_type, A_predict_window_type, A_low_offset_type, A_train_window_period)
				+ ";allow=;" + ind("LinearRegression", "low", A_low_price_type, A_predict_window_type, A_low_offset_type, A_train_window_period)
				+ ";alow.slope=;" + ind("LinearRegression", "slope", A_low_price_type, A_predict_window_type, A_low_offset_type, A_train_window_period)
				+ ";alow.mae=;" + ind("LinearRegression", "mae", A_low_price_type, A_predict_window_type, A_low_offset_type, A_train_window_period)

				+ ";nextTSlong=;" + nextTSlong + ";slope_long_=;" + slope_long
				+ ";nextTSshort=;" + nextTSshort + ";slope_short_=;" + slope_short
				+ ";absSLlong=;" + absSLlong
				+ ";absSLshort=;" + absSLshort
				
				+ ";bhigh=;" + ind("LinearRegression", "line", B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period) 
				+ ";bhhigh=;" + hhigh = ind("LinearRegression", "high", B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period) 
				+ ";blhigh=;" + ind("LinearRegression", "low", "high", B_predict_window_type, B_high_offset_type, B_train_window_period) 
				+ ";bhigh.slope=;" + ind("LinearRegression", "slope", B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period) 
				+ ";bhigh.mae=;" + ind("LinearRegression", "mae", B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period) 
				+ ";blow=;" + ind("LinearRegression", "line", B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)
				+ ";bhlow=;" + ind("LinearRegression", "high", B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)
				+ ";bllow=;" + llow = ind("LinearRegression", "low", B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)
				+ ";blow.slope=;" + ind("LinearRegression", "slope", B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)
				+ ";blow.mae=;" + ind("LinearRegression", "mae", B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)
				+ ";OBV=;" + ind("OBV", long_open_OBV_period)
				+ ";OBVP=;" + OBVP(long_open_OBV_period, long_open_OBV_period)
				) 
				<< log.level != "Error";
				//step += 1n; 
			
				// +++ Debug 08.08.2025 --------------------------------------------------------------------------
				{
					log("long_conditions" + ";step=;" + step + ";result=;" + long_result 
						+ ";con0=;" + long_con0 
						+ ";con1=;" + long_con1 
						+ ";con10=;" + long_con10 
						+ ";con12=;" + long_con12 
						+ ";con16=;" + long_con16 
						+ ";con18=;" + long_con18 
						+ ";con19=;" + long_con19 
						+ ";con7=;" + long_con7 
						+ ";con70=;" + long_con70 
						+ ";con76=;" + long_con76 
						+ ";con78=;" + long_con78 
						+ ";con79=;" + long_con79 
						+ ";OBVP=;" + OBVP(long_open_OBV_period, B_train_window_period) 
					) << long_con1 | long_con7 == true;
					long_con1 = (long_con7 = false);
				||
					long_con1 = long_con1 << !(long_con1 | long_con7 == true)
				}; 
				
				{
					log("short_conditions" + ";step=;" + step + ";result=;" + short_result 
						+ ";con0=;" + short_con0 
						+ ";con1=;" + short_con1 
						+ ";con10=;" + short_con10 
						+ ";con12=;" + short_con12 
						+ ";con16=;" + short_con16 
						+ ";con18=;" + short_con18 
						+ ";con19=;" + short_con19 
						+ ";con7=;" + short_con7 
						+ ";con70=;" + short_con70 
						+ ";con76=;" + short_con76 
						+ ";con78=;" + short_con78 
						+ ";con79=;" + short_con79 
						+ ";OBVP=;" + OBVP(short_open_OBV_period, B_train_window_period) 
					) << short_con1 | short_con7 == true;
					short_con1 = (short_con7 = false);
				||
					short_con1 = short_con1 << !(short_con1 | short_con7 == true)
				};
				// --- Debug 08.08.2025 --------------------------------------------------------------------------
				
				{
					day_start_time = day_start_time << time >= night_end_time;
				
					..[time >= night_end_time]
					{
						day_start_time += 1D << time >= night_end_time;
						day_end_time += 1D;
						night_start_time += 1D;
						night_end_time += 1D;
						log("debug_day_time_moved;" + ";day_start_time=;" + day_start_time + ";day_end_time=;" + day_end_time
							+ ";night_start_time=;" + night_start_time + ";night_end_time=;" + night_end_time
						)
					};
						
					log("daily_report;start_equity=;" + my_start_equity + ";start_time=;" + my_start_time + ";equity=;" + equity + ";abs_equity_diff=;" 
						+ (equity - my_start_equity) + ";p_equity_diff=;" + 100% * ((equity - my_start_equity) / my_start_equity))
				
				||
					day_start_time = day_start_time << time < night_end_time
				};

			||
				step = step << log.level == "Error";
			};
			
			~
		};
		
	||
		..{			
			res = LRSLAL_long_CalcNextTSSlope(
					longTS_line, 	// A line type of the indicator which serves as nextTSlong base
					longTS_price_type,	// A price type of the indicator which serves as nextTSlong base
					longTS_predict_window_type, // A predict_window type of the indicator which serves as nextTSlong base
					longTS_offset_type,	// A offset type of the indicator which serves as nextTSlong base
					longTS_train_window_period,	// A train_window period of the indicator which serves as nextTSlong base
					longTS_slope_start_max,
					nextTSlong,		// An initial nextTSlong value
					slope_long		// An initial slope_long value
			);
			
			nextTSlong = (res["nextTSlong"]);
			slope_long = (res["slope_long"]);
			
			~
		&&
			res = LRSLAL_short_CalcNextTSSlope(
					shortTS_line, 	// A line type of the indicator which serves as nextTSlong base
					shortTS_price_type,	// A price type of the indicator which serves as nextTSlong base
					shortTS_predict_window_type, // A predict_window type of the indicator which serves as nextTSlong base
					shortTS_offset_type,	// A offset type of the indicator which serves as nextTSlong base
					shortTS_train_window_period,	// A train_window period of the indicator which serves as nextTSlong base	
					shortTS_slope_start_max,
					nextTSshort,		// An initial nextTSshort value
					slope_short		// An initial slope_short value
			);
			
			nextTSshort = (res["nextTSshort"]);
			slope_short = (res["slope_short"]);
			
			~
		}
	||
		thread = "";
	
		..[time < expiration_time & candles.is_calculated != 1n]
		{
			my_account = account;
			{
				// Debug
				//log("LR_strategy_long_SlopeLevel_AdaptiveLots_started...");
				
				lots = 0l
				<< LR_strategy_long_condition_SlopeLevel_AdaptiveLots_35022(
					expiration_time, 	// Time when to stop the strategy
	
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
	
					//  long_closing:
					longTS_line, // a line type of the indicator which serves as nextTSlong base
					longTS_price_type, // a price type of the indicator which serves as nextTSlong base
					longTS_offset_type, // an offset type of the indicator which serves as nextTSlong base
					longTS_train_window_period, // a train_window period of the indicator which serves as nextTSlong base	
					longTS_predict_window_type, // a predict_window type of the indicator which serves as nextTSlong base	
					longTS_slope_start // Starting slope of linear regression for a long position
				) == true;
				
				LR_strategy_long_SlopeLevel_AdaptiveLots_35022(
					safety_stock,	// Safety stock in percents to the equity
					risk_L,		// Risk rate in percents for long positions
					
					longTS_line, // a line type of the indicator which serves as nextTSlong base
					longTS_price_type, // a price type of the indicator which serves as nextTSlong base
					longTS_offset_type, // an offset type of the indicator which serves as nextTSlong base
					long_open_OBV_period,//longTS_train_window_period, // a train_window period of the indicator which serves as nextTSlong base	
					longTS_slope_start, // Starting slope of linear regression for a long position
					longTP_level // TP level in percents
				);
				
				// Debug
				//log("LR_strategy_long_SlopeLevel_AdaptiveLots_finished");
				
			||
				// Debug
				//log("account_>_0l_already_started...");
				slope_long = longTS_slope_start << my_account > 0l;
				
				res = LRSLAL_long_Calc1NextTSSlope(
					longTS_line, // a line type of the indicator which serves as nextTSlong base
					longTS_price_type, // a price type of the indicator which serves as nextTSlong base
					longTS_offset_type, // an offset type of the indicator which serves as nextTSlong base
					longTS_train_window_period, // a train_window period of the indicator which serves as nextTSlong base	
					longTS_slope_start, // Starting slope of linear regression for a long position
					nextTSlong,	// An initial nextTSlong value
					slope_long	// An initial slope_long value
				);

				nextTSlong = (res["nextTSlong"]);
				slope_long = (res["slope_long"]);
				nextTSlong_index = (res["nextTSlong_index"]);
				slope_type = (res["slope_type"]);
				nextTPlong = (pos.price + longTP_level);
				absSLlong = (pos.price - CalculateSLLong(safety_stock, risk_L));
				
				log("account_>_0l_already;" + slope_type + ";pos.price=;" + pos.price + ";account=;" + account
					+ ";start_time=;" + candle.time[nextTSlong_index] + ";start_low=;" + low[nextTSlong_index] 
					+ ";nextTSlong_time=;" + candle.time[-1c] + ";nextTSlong=;" + nextTSlong 
					+ ";slope_long=;" + slope_long
					+ ";absSLlong=;" + absSLlong
				);

				// Debug
				//log("account_>_0l_already_finished");

			||
				// Debug
				//log("LR_strategy_short_SlopeLevel_AdaptiveLots_started...");

				lots = 0l
				<< LR_strategy_short_condition_SlopeLevel_AdaptiveLots_35022(
					expiration_time, 	// Time when to stop the strategy
	
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
	
					//  short_opening:
					short_open_A_line, // type of A_channel line which raises condition1 := ("high" || "low" || "line")
					short_open_B_line, // type of B_channel line which raises condition7 := ("high" || "low" || "line")
					short_open_OBV_period,
					short_open_OBV_level, // level of OBV for condition9
	
					//  short_closing:
					shortTS_line, // a line type of the indicator which serves as nextTSshort base
					shortTS_price_type, // a price type of the indicator which serves as nextTSshort base
					shortTS_offset_type, // an offset type of the indicator which serves as nextTSshort base
					shortTS_train_window_period, // a train_window period of the indicator which serves as nextTSshort base	
					shortTS_predict_window_type, // a predict_window type of the indicator which serves as nextTSshort base	
					shortTS_slope_start // Starting slope of linear regression for a short position
				) == true;
				
				LR_strategy_short_SlopeLevel_AdaptiveLots_35022(
					safety_stock,	// Safety stock in percents to the equity
					risk_S,		// Risk rate in percents for short positions
					
					shortTS_line, // a line type of the indicator which serves as nextTSshort base
					shortTS_price_type, // a price type of the indicator which serves as nextTSshort base
					shortTS_offset_type, // an offset type of the indicator which serves as nextTSshort base
					short_open_OBV_period,//shortTS_train_window_period, // a train_window period of the indicator which serves as nextTSshort base	
					shortTS_slope_start, // Starting slope of linear regression for a short position
					shortTP_level // TP level in percents
				);
				
				// Debug
				//log("LR_strategy_short_SlopeLevel_AdaptiveLots_finished");
				
			||
				// Debug
				//log("account_<_0l_already_started...");
				slope_short = shortTS_slope_start << my_account < 0l;
				
				res = LRSLAL_short_Calc1NextTSSlope(
					shortTS_line, // a line type of the indicator which serves as nextTSshort base
					shortTS_price_type, // a price type of the indicator which serves as nextTSshort base
					shortTS_offset_type, // an offset type of the indicator which serves as nextTSshort base
					shortTS_train_window_period, // a train_window period of the indicator which serves as nextTSshort base	
					shortTS_slope_start, // Starting slope of linear regression for a short position
					nextTSshort,	// An initial nextTSshort value
					slope_short	// An initial slope_short value
				);

				nextTSshort = (res["nextTSshort"]);
				slope_short = (res["slope_short"]);
				nextTSshort_index = (res["nextTSshort_index"]);
				slope_type = (res["slope_type"]);
				nextTPshort = (pos.price - shortTP_level);
				absSLshort = (pos.price + CalculateSLShort(safety_stock, risk_S));

				log("account_<_0l_already;" + slope_type + ";pos.price=;" + pos.price + ";account=;" + account 
					+ ";start_time=;" + candle.time[nextTSshort_index] + ";start_high=;" + high[nextTSshort_index] 
					+ ";nextTSshort_time=;" + candle.time[-1c] + ";nextTSshort=;" + nextTSshort 
					+ ";slope_short=;" + slope_short
					+ ";absSLshort=;" + absSLshort
				);

				// Debug
				//log("account_<_0l_already_finished");
				
			};
		
			{
				//no_activity = -1c;
				lock = 0n;
				
				{
					log("looking_for_closing_long" + ";step=;" + step) << account > 0l;
					{
					//	lock = 1n
					//	 << account > 0l & lock == 0n
					//		& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
					//		& high[-1c] > ind("LinearRegression", longTP_line, longTP_price_type, longTP_predict_window_type, longTP_offset_type, longTP_train_window_period)[-1c]
					//		& close[-1c] < ind("LinearRegression", long_open_B_line, B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period)[-1c]
					//		& !(ind("LinearRegression", "slope", B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)[-1c] > 0n)
					//		& !long_con70
					//	;
					//	my_stop();
					//	log("long_lr_TP;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age/* + ";no_activity=;" + abs(no_activity)*/) << account == 0l
					//||
						lock = 1n
						 << account > 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& high[-1c] > nextTPlong /*& open > close[LR_strategy_condition_start_time()] + 1%*/
						;
						my_stop();
						log("long_lr_TP1;pos.abs_profit=;" + pos.abs_profit + ";pos.profit=;" + pos.profit 
							+ ";pos.age=;" + pos.age/* + ";no_activity=;" + abs(no_activity)*/) << account == 0l
					||
						lock = 1n
						 << account > 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& close[-1c] < nextTSlong
						;
						my_stop();
						log("long_lr_TS;pos.abs_profit=;" + pos.abs_profit + ";pos.profit=;" + pos.profit 
							+ ";pos.age=;" + pos.age + ";nextTSlong=;" + nextTSlong/* + ";no_activity=;" + abs(no_activity)*/) << account == 0l
					/*||
						no_activity = no_activity_periods << account > 0l;
							
						// Debug Section 2.06.2024
						//log("long_lr_NAS;started_watching;no_activity_periods=;" + no_activity_periods + ";no_activity=;" + no_activity);
							
						..[no_activity != 0c]
						{
							no_activity -= 1c << 
							close[-1c] < (LRHH = (ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c]))
							& pos.abs_profit < 0p;
							log("long_lr_NAS;no_activity=;" + no_activity + ";close=;" + close + ";LRHH=;" + LRHH + ";step=;" + step);
							~
						};
							
						lock = 1n
						 << (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time) 
								& lock == 0n;
						my_stop();
						log("long_lr_NAS;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";no_activity=;" + no_activity + ";step=;" + step) 
						 << account == 0l*/
					||
						lock = 1n
						 << account > 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& low < absSLlong
						;
						my_stop();
						log("long_lr_SL;pos.abs_profit=;" + pos.abs_profit + ";pos.profit=;" + pos.profit
							+ ";pos.age=;" + pos.age + ";absSLlong=;" + absSLlong/* + ";no_activity=;" + abs(no_activity)*/
						) << account == 0l
					};
					
					// +++ Debug
					//log("session_profit_&_loss_long_started..." 
					//	+ ";session_abs_profit_long=;" + session_abs_profit_long + ";session_abs_loss_long=;" + session_abs_loss_long
					//);
					// --- Debug
					
					{
						session_abs_profit_long += pos.abs_profit << pos.abs_profit >= 0p
					||
						session_abs_loss_long += pos.abs_profit << pos.abs_profit < 0p
					};
					
					// +++ Debug
					//log("session_profit_&_loss_long_finished" 
					//	+ ";session_abs_profit_long=;" + session_abs_profit_long + ";session_abs_loss_long=;" + session_abs_loss_long
					//);
					// --- Debug

					
				||
					log("looking_for_closing_short" + ";step=;" + step) << account < 0l;
					{
					//	lock = 1n
					//	 << account < 0l & lock == 0n
					//		& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
					//		& low[-1c] < ind("LinearRegression", shortTP_line, shortTP_price_type, shortTP_predict_window_type, shortTP_offset_type, shortTP_train_window_period)[-1c]
					//		& close[-1c] > ind("LinearRegression", short_open_B_line, B_low_price_type, B_predict_window_type, B_low_offset_type, B_train_window_period)[-1c]
					//		& !(ind("LinearRegression", "slope", B_high_price_type, B_predict_window_type, B_high_offset_type, B_train_window_period)[-1c] < 0n)
					//		& !short_con70
					//	;
					//	my_stop();
					//	log("short_lr_TP;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";nextTSshort=;" + nextTSshort/* + ";no_activity=;" + abs(no_activity)*/) << account == 0l
					//||
						lock = 1n
						 << account > 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& low[-1c] < nextTPshort /*& open > close[LR_strategy_condition_start_time()] + 1%*/
						;
						my_stop();
						log("short_lr_TP1;pos.abs_profit=;" + pos.abs_profit + ";pos.profit=;" + pos.profit 
							+ ";pos.age=;" + pos.age/* + ";no_activity=;" + abs(no_activity)*/) << account == 0l
					||
						lock = 1n
						 << account < 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& close[-1c] > nextTSshort
						;
						my_stop();
						log("short_lr_TS;pos.abs_profit=;" + pos.abs_profit + ";pos.profit=;" 
							+ pos.profit + ";pos.age=;" + pos.age + ";nextTSshort=;" + nextTSshort/* + ";no_activity=;" + abs(no_activity)*/) << account == 0l
					/*||
						no_activity = no_activity_periods << account < 0l;
						
						// Debug Section 2.06.2024
						//log("short_lr_NAS;started_watching;no_activity_periods=;" + no_activity_periods + ";no_activity=;" + no_activity);
							
						..[no_activity != 0c]
						{
							no_activity -= 1c << 
							close[-1c] > (LRLL = (ind("LinearRegression", "low", "low", predict_window, high_offset, train_window)[-1c]))
							& pos.abs_profit < 0p;
							log("short_lr_NAS;no_activity=;" + no_activity + ";close=;" + close + ";LRLL=;" + LRLL + ";step=;" + step);
							~
						};
							
						lock = 1n
						 << (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time) 
								& lock == 0n;
						my_stop();
						log("short_lr_NAS;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";no_activity=;" + no_activity + ";step=;" + step) 
							<< account == 0l*/
					||
						lock = 1n
						 << account < 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& high > absSLshort
						;
						my_stop();
						log("short_lr_SL;pos.abs_profit=;" + pos.abs_profit + ";pos.profit=;" + pos.profit
							+ ";pos.age=;" + pos.age + ";absSLshort=;" + absSLshort/* + ";no_activity=;" + abs(no_activity)*/
						) << account == 0l
					};
					
					// +++ Debug
					//log("session_profit_&_loss_short_started..." 
					//	+ ";session_abs_profit_short=;" + session_abs_profit_short + ";session_abs_loss_short=;" + session_abs_loss_short
					//);
					// --- Debug
					
					{
						session_abs_profit_short += pos.abs_profit << pos.abs_profit >= 0p
					||
						session_abs_loss_short += pos.abs_profit << pos.abs_profit < 0p
					};
					
					// +++ Debug
					//log("session_profit_&_loss_short_finished" 
					//	+ ";session_abs_profit_short=;" + session_abs_profit_short + ";session_abs_loss_short=;" + session_abs_loss_short
					//);
					// --- Debug

				};
			
				session_abs_profit = (session_abs_profit_long + session_abs_profit_short);
				session_abs_loss = (session_abs_loss_long + session_abs_loss_short);
				session_PL_rate = (session_abs_profit / -session_abs_loss);
				session_PL_rate_long = (session_abs_profit_long / -session_abs_loss_long);
				session_PL_rate_short = (session_abs_profit_short / -session_abs_loss_short);
				log("session_profit_&_loss" 
					+ ";session_PL_rate=;" + session_PL_rate
					+ ";session_PL_rate_long=;" + session_PL_rate_long
					+ ";session_PL_rate_short=;" + session_PL_rate_short
					+ ";session_abs_profit_long=;" + session_abs_profit_long + ";session_abs_loss_long=;" + session_abs_loss_long
					+ ";session_abs_profit_short=;" + session_abs_profit_short + ";session_abs_loss_short=;" + session_abs_loss_short
					+ ";session_abs_profit=;" + session_abs_profit + ";session_abs_loss=;" + session_abs_loss
				);
			}

		};
		
		{
			log("LR_strategy_SlopeLevel_AdaptiveLots_3502_has_expired;" + "expiration_stop") << time >= expiration_time
		||
			log("LR_strategy_SlopeLevel_AdaptiveLots_3502_history_calculated;" + "history_calculated") << candles.is_calculated == 1n
		};
		

		my_stop();

		log("LR_strategy_SlopeLevel_AdaptiveLots_3502_has_finished;" + "script_stopped")

	};
	
	result = new("dict");
	result["session_PL_rate"] = session_PL_rate;
	result["session_PL_rate_long"] = session_PL_rate_long;
	result["session_PL_rate_short"] = session_PL_rate_short;
	result["session_abs_profit_long"] = session_abs_profit_long; 
	result["session_abs_loss_long"] = session_abs_loss_long;
	result["session_abs_profit_short"] = session_abs_profit_short; 
	result["session_abs_loss_short"] = session_abs_loss_short;
	result["session_abs_profit"] = session_abs_profit; 
	result["session_abs_loss"] = session_abs_loss;
	
};
// --- LR_strategy_SlopeLevel_AdaptiveLots --- 7.04.2024 -------------------------------------------------------------------------------------------------------------------

// params := (..value)
//	//  A_channel:
//	A_train_window_period, // a number of candles in history to train the model on
//	A_predict_window_type, // a period of time in the future for forecasting := ("candle" || "day" || "week")
//	A_high_price_type, // type of price as base for the high channel's border := (open || close || high || low)
//	A_low_price_type, // type of price as base for the low channel's border := (open || close || high || low)
//	A_high_offset_type, // := ("high" || "low" || "none")
//	A_low_offset_type, // := ("high" || "low" || "none")
//	
//	//  B_channel:
//	B_train_window_period, // a number of candles in history to train the model on
//	B_predict_window_type, // a period of time in the future for forecasting := ("candle" || "day" || "week")
//	B_high_price_type, // type of price as base for the high channel's border := (open || close || high || low)
//	B_low_price_type, // type of price as base for the low channel's border := (open || close || high || low)
//	B_high_offset_type, //:= ("high" || "low" || "none")
//	B_low_offset_type, //:= ("high" || "low" || "none")
//	
//	//  long_opening:
//	long_open_A_line, // type of A_channel line which raises condition1 := ("high" || "low" || "line")
//	long_open_B_line, // type of B_channel line which raises condition7 := ("high" || "low" || "line")
//	long_open_OBV_period,
//	long_open_OBV_level, // level of OBV for condition9
//	
//	//  short_opening:
//	short_open_A_line, // type of A_channel line which raises condition1 := ("high" || "low" || "line")
//	short_open_B_line, // type of B_channel line which raises condition7 := ("high" || "low" || "line")
//	short_open_OBV_period,
//	short_open_OBV_level, // level of OBV for condition9
//	
//	//  long_closing:
//	longTS_line, // a line type of the indicator which serves as nextTSlong base
//	longTS_price_type, // a price type of the indicator which serves as nextTSlong base
//	longTS_offset_type, // an offset type of the indicator which serves as nextTSlong base
//	longTS_train_window_period, // a train_window period of the indicator which serves as nextTSlong base	
//	longTS_predict_window_type, // a predict_window type of the indicator which serves as nextTSlong base	
//	longTS_slope_start, // Starting slope of linear regression for a long position
//	longTP_level, // TP level in percents
//	
//	//  short_closing:
//	shortTS_line, // a line type of the indicator which serves as nextTSshort base
//	shortTS_price_type, // a price type of the indicator which serves as nextTSshort base
//	shortTS_offset_type, // an offset type of the indicator which serves as nextTSshort base
//	shortTS_train_window_period, // a train_window period of the indicator which serves as nextTSshort base	
//	shortTS_predict_window_type, // a predict_window type of the indicator which serves as nextTSshort base	
//	shortTS_slope_start, // Starting slope of linear regression for a short position
//	shortTP_level // TP level in percents
TestAdapter(params) :=
{
	idx = 0i;
	idx -= 1i;
	log("TestAdapter_LR_strategy_SlopeLevel_AdaptiveLots_has_started...;");
	
	i_safety_stock = idx += 1i;	//0 Safety stock in percents to the equity
	i_risk_L = idx += 1i;			//1 Risk rate in percents for long positions
	i_risk_S = idx += 1i;			//2 Risk rate in percents for short positions
	
	iexpiration_time = idx += 1i; 	//3 Time when to stop the strategy
	
	i_day_start_time = idx += 1i;	//4 Start time of the day trading session
	i_day_end_time = idx += 1i;	//5 End time of the day trading session
	i_night_start_time = idx += 1i;	//6 Start time of the night trading session
	i_night_end_time = idx += 1i;	//7 End time of the night trading session
	
	//  A_channel:
	iA_train_window_period = idx += 1i; 	//8 a number of candles in history to train the model on
	iA_predict_window_type = idx += 1i; 	//9 a period of time in the future for forecasting := ("candle" || "day" || "week")
	iA_high_price_type = idx += 1i; 	//10 type of price as base for the high channel's border := (open || close || high || low)
	iA_low_price_type = idx += 1i; 		//11 type of price as base for the low channel's border := (open || close || high || low)
	iA_high_offset_type = idx += 1i; 	//12 := ("high" || "low" || "none")
	iA_low_offset_type = idx += 1i; 	//13 := ("high" || "low" || "none")
	
	//  B_channel:
	iB_train_window_period = idx += 1i; 	//14 a number of candles in history to train the model on
	iB_predict_window_type = idx += 1i; 	//15 a period of time in the future for forecasting := ("candle" || "day" || "week")
	iB_high_price_type = idx += 1i; 	//16 type of price as base for the high channel's border := (open || close || high || low)
	iB_low_price_type = idx += 1i; 		//17 type of price as base for the low channel's border := (open || close || high || low)
	iB_high_offset_type = idx += 1i; 	//18:= ("high" || "low" || "none")
	iB_low_offset_type = idx += 1i; 	//19:= ("high" || "low" || "none")

	//  long_opening:
	ilong_open_A_line = idx += 1i; 		//20 type of A_channel line which raises condition1 := ("high" || "low" || "line")
	ilong_open_B_line = idx += 1i; 		//21 type of B_channel line which raises condition7 := ("high" || "low" || "line")
	ilong_open_OBV_period = idx += 1i; 	//22
	ilong_open_OBV_level = idx += 1i; 	//23 level of OBV for condition9
	
	//  short_opening:
	ishort_open_A_line = idx += 1i; 	//24 type of A_channel line which raises condition1 := ("high" || "low" || "line")
	ishort_open_B_line = idx += 1i; 	//25 type of B_channel line which raises condition7 := ("high" || "low" || "line")
	ishort_open_OBV_period = idx += 1i; 	//26
	ishort_open_OBV_level = idx += 1i; 	//27 level of OBV for condition9
	
	//  long_closing:
	ilongTS_line = idx += 1i; 			//28 a line type of the indicator which serves as nextTSlong base
	ilongTS_price_type = idx += 1i; 	//29 a price type of the indicator which serves as nextTSlong base
	ilongTS_offset_type = idx += 1i; 	//30 an offset type of the indicator which serves as nextTSlong base
	ilongTS_train_window_period = idx += 1i; //31 a train_window period of the indicator which serves as nextTSlong base	
	ilongTS_predict_window_type = idx += 1i; //32 a predict_window type of the indicator which serves as nextTSlong base	
	ilongTS_slope_start = idx += 1i; 	//33 Starting slope of linear regression for a long position
	ilongTP_line = idx += 1i; //34 a line type of the indicator which serves as trailing TP base
	ilongTP_price_type = idx += 1i; //35 a price type of the indicator which serves as trailing TP base
	ilongTP_offset_type = idx += 1i; //36 an offset type of the indicator which serves as trailing TP base
	ilongTP_train_window_period = idx += 1i; //37 a train_window period of the indicator which serves as trailing TP base
	ilongTP_predict_window_type = idx += 1i; //38 a predict_window type of the indicator which serves as trailing TP base
	ilongTP_level = idx += 1i; 		//39 TP level in percents
	
	//  short_closing:
	ishortTS_line = idx += 1i; 		//40 a line type of the indicator which serves as nextTSshort base
	ishortTS_price_type = idx += 1i; 	//41 a price type of the indicator which serves as nextTSshort base
	ishortTS_offset_type = idx += 1i; 	//42 an offset type of the indicator which serves as nextTSshort base
	ishortTS_train_window_period = idx += 1i; //43 a train_window period of the indicator which serves as nextTSshort base	
	ishortTS_predict_window_type = idx += 1i; //44 a predict_window type of the indicator which serves as nextTSshort base	
	ishortTS_slope_start = idx += 1i; 	//45 Starting slope of linear regression for a short position
	ishortTP_line = idx += 1i; //46 a line type of the indicator which serves as trailing TP base
	ishortTP_price_type = idx += 1i; //47 a price type of the indicator which serves as trailing TP base
	ishortTP_offset_type = idx += 1i; //48 an offset type of the indicator which serves as trailing TP base
	ishortTP_train_window_period = idx += 1i; //49 a train_window period of the indicator which serves as trailing TP base
	ishortTP_predict_window_type = idx += 1i; //50 a predict_window type of the indicator which serves as trailing TP base
	ishortTP_level = idx += 1i; 		//51 TP level in percents
	
	ilongTS_slope_start_max = idx += 1i; 	//52 Starting max slope of linear regression for a long position
	ishortTS_slope_start_max = idx += 1i; 	//53 Starting max slope of linear regression for a short position
	
	safety_stock = params[i_safety_stock];	// Safety stock in percents to the equity
	risk_L = params[i_risk_L];		// Risk rate in percents for long positions
	risk_S = params[i_risk_S];	// Risk rate in percents for short positions
	
	expiration_time = params[iexpiration_time]; 	// Time when to stop the strategy
	
	day_start_time = params[i_day_start_time];	// Start time of the day trading session
	day_end_time = params[i_day_end_time];	// End time of the day trading session
	night_start_time = params[i_night_start_time];	// Start time of the night trading session
	night_end_time = params[i_night_end_time];	// End time of the night trading session
	
	//  A_channel:
	A_train_window_period = params[iA_train_window_period]; 	//8 a number of candles in history to train the model on
	A_predict_window_type = params[iA_predict_window_type]; 	//9 a period of time in the future for forecasting := ("candle" || "day" || "week")
	A_high_price_type = params[iA_high_price_type]; 	//10 type of price as base for the high channel's border := (open || close || high || low)
	A_low_price_type = params[iA_low_price_type]; 		//11 type of price as base for the low channel's border := (open || close || high || low)
	A_high_offset_type = params[iA_high_offset_type]; 	//12 := ("high" || "low" || "none")
	A_low_offset_type = params[iA_low_offset_type]; 	//13 := ("high" || "low" || "none")
	
	//  B_channel:
	B_train_window_period = params[iB_train_window_period]; 	//14 a number of candles in history to train the model on
	B_predict_window_type = params[iB_predict_window_type]; 	//15 a period of time in the future for forecasting := ("candle" || "day" || "week")
	B_high_price_type = params[iB_high_price_type]; 	//16 type of price as base for the high channel's border := (open || close || high || low)
	B_low_price_type = params[iB_low_price_type]; 		//17 type of price as base for the low channel's border := (open || close || high || low)
	B_high_offset_type = params[iB_high_offset_type]; 	//18:= ("high" || "low" || "none")
	B_low_offset_type = params[iB_low_offset_type]; 	//19:= ("high" || "low" || "none")

	//  long_opening:
	long_open_A_line = params[ilong_open_A_line]; 		//20 type of A_channel line which raises condition1 := ("high" || "low" || "line")
	long_open_B_line = params[ilong_open_B_line]; 		//21 type of B_channel line which raises condition7 := ("high" || "low" || "line")
	long_open_OBV_period = params[ilong_open_OBV_period]; 	//22
	long_open_OBV_level = params[ilong_open_OBV_level]; 	//23 level of OBV for condition9
	
	//  short_opening:
	short_open_A_line = params[ishort_open_A_line]; 	//24 type of A_channel line which raises condition1 := ("high" || "low" || "line")
	short_open_B_line = params[ishort_open_B_line]; 	//25 type of B_channel line which raises condition7 := ("high" || "low" || "line")
	short_open_OBV_period = params[ishort_open_OBV_period]; 	//26
	short_open_OBV_level = params[ishort_open_OBV_level]; 	//27 level of OBV for condition9
	
	//  long_closing:
	longTS_line = params[ilongTS_line]; 			//28 a line type of the indicator which serves as nextTSlong base
	longTS_price_type = params[ilongTS_price_type]; 	//29 a price type of the indicator which serves as nextTSlong base
	longTS_offset_type = params[ilongTS_offset_type]; 	//30 an offset type of the indicator which serves as nextTSlong base
	longTS_train_window_period = params[ilongTS_train_window_period]; //31 a train_window period of the indicator which serves as nextTSlong base	
	longTS_predict_window_type = params[ilongTS_predict_window_type]; //32 a predict_window type of the indicator which serves as nextTSlong base	
	longTS_slope_start = params[ilongTS_slope_start]; 	//33 Starting slope of linear regression for a long position
	longTP_line = params[ilongTP_line]; //34 a line type of the indicator which serves as trailing TP base
	longTP_price_type = params[ilongTP_price_type]; //35 a price type of the indicator which serves as trailing TP base
	longTP_offset_type = params[ilongTP_offset_type]; //36 an offset type of the indicator which serves as trailing TP base
	longTP_train_window_period = params[ilongTP_train_window_period]; //37 a train_window period of the indicator which serves as trailing TP base
	longTP_predict_window_type = params[ilongTP_predict_window_type]; //38 a predict_window type of the indicator which serves as trailing TP base
	longTP_level = params[ilongTP_level]; 		//39 TP level in percents
	
	//  short_closing:
	shortTS_line = params[ishortTS_line]; 		//40 a line type of the indicator which serves as nextTSshort base
	shortTS_price_type = params[ishortTS_price_type]; 	//41 a price type of the indicator which serves as nextTSshort base
	shortTS_offset_type = params[ishortTS_offset_type]; 	//42 an offset type of the indicator which serves as nextTSshort base
	shortTS_train_window_period = params[ishortTS_train_window_period]; //43 a train_window period of the indicator which serves as nextTSshort base	
	shortTS_predict_window_type = params[ishortTS_predict_window_type]; //44 a predict_window type of the indicator which serves as nextTSshort base	
	shortTS_slope_start = params[ishortTS_slope_start]; 	//45 Starting slope of linear regression for a short position
	shortTP_line = params[ishortTP_line]; //46 a line type of the indicator which serves as trailing TP base
	shortTP_price_type = params[ishortTP_price_type]; //47 a price type of the indicator which serves as trailing TP base
	shortTP_offset_type = params[ishortTP_offset_type]; //48 an offset type of the indicator which serves as trailing TP base
	shortTP_train_window_period = params[ishortTP_train_window_period]; //49 a train_window period of the indicator which serves as trailing TP base
	shortTP_predict_window_type = params[ishortTP_predict_window_type]; //50 a predict_window type of the indicator which serves as trailing TP base
	shortTP_level = params[ishortTP_level]; 		//51 TP level in percents
	
	longTS_slope_start_max = params[ilongTS_slope_start_max]; 	//52 Starting max slope of linear regression for a long position
	shortTS_slope_start_max = params[ishortTS_slope_start_max]; 	//53 Starting max slope of linear regression for a short position
	
	res =
	LR_strategy_SlopeLevel_AdaptiveLots_35022(
		safety_stock,	// Safety stock in percents to the equity
		risk_L,		// Risk rate in percents for long positions
		risk_S,		// Risk rate in percents for short positions
	
		expiration_time, 	// Time when to stop the strategy
	
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
		shortTP_level, // TP level in percents
		
		longTS_slope_start_max, // Starting max slope of linear regression for a long position
		shortTS_slope_start_max // Starting max slope of linear regression for a short position
	);
	
	// best_values := (equity, max_equity, min_equity, target)
	//res = new("dict");
	res["equity"] = equity;
	res["max_equity"] = dealer.max_equity;
	res["min_equity"] = dealer.min_equity;
	res["target"] = equity;
	
	log("TestAdapter_LR_strategy_SlopeLevel_AdaptiveLots_has_finished;");
	result = res;
};
