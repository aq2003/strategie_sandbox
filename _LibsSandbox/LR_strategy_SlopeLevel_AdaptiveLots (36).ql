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
	
	OBV_period = OBV(period);
	OBV_history = abs(OBV(history_period)[-period]);
	
	result = (100% * OBV_period / OBV_history);
	
	// +++ Debug
	log("OBVP_finished;period=" + period + ";history_period=;" + history_period + ";OBVP=;" + result 
		+ ";OBV_history=;" + OBV_history + ";OBV_period=;" + OBV_period);
	// ---
};

// 23.02.2026
// A service method of LR_strategy_SlopeLevel family.
// Calculates nextTSlong and slope_long values continuesly depending on account value.
// Parameters:
// - 	indicator_line, 	- A line type of the indicator which serves as nextTSlong base
// -	indicator_price_type,	- A price type of the indicator which serves as nextTSlong base
// -	indicator_predict_window, - A predict_window type of the indicator which serves as nextTSlong base
// -	indicator_offset,	- A offset type of the indicator which serves as nextTSlong base
// -	indicator_train_window	- A train_window period of the indicator which serves as nextTSlong base	
// -	current_nextTSlong,		- An initial nextTSlong value
// -	current_slope_long		- An initial slope_long value
// Returns:
// - nextTSlong - a new value for nextTSlong
// - slope_long - a new value for slope_long
LRSLAL_long_CalcNextTSSlope(
	indicator_line, 	// A line type of the indicator which serves as nextTSlong base
	indicator_price_type,	// A price type of the indicator which serves as nextTSlong base
	indicator_predict_window, // A predict_window type of the indicator which serves as nextTSlong base
	indicator_offset,	// A offset type of the indicator which serves as nextTSlong base
	indicator_train_window,	// A train_window period of the indicator which serves as nextTSlong base	
	current_nextTSlong,		// An initial nextTSlong value
	current_slope_long		// An initial slope_long value
) :=
{
	result = 0n;
	
	{
		// +++ Debug
		//old_slope_long = _slope_long << account > 0l;
		//debug_str_l = "debug_moving_nextTSlong";	
		//log(debug_str_l + ";started...");
		// ---
			
		indicator_slope_long = ind("LinearRegression", "slope", indicator_price_type, indicator_predict_window, indicator_offset, indicator_train_window)[-1c] << account > 0l;
		indicator_nextTSlong = ind("LinearRegression", indicator_line, indicator_price_type, indicator_predict_window, indicator_offset, indicator_train_window)[-1c];
		div_slope_long = ((indicator_nextTSlong - ind("LinearRegression", indicator_line, indicator_price_type, indicator_predict_window, indicator_offset, indicator_train_window)[-2c]) / 1p);
		{
			current_slope_long = indicator_slope_long << indicator_slope_long > current_slope_long /*& indicator_slope_long > div_slope_long*/;
			// +++ Debug
			//debug_str_l += ";indicator_slope_long_the_best"
			// ---
		/*||
			current_slope_long = div_slope_long << div_slope_long > current_slope_long & div_slope_long > indicator_slope_long;
			// +++ Debug
			//debug_str_l += ";div_slope_long_the_best"
			// ---
			*/
		||
			current_slope_long = current_slope_long << /*current_slope_long >= div_slope_long  &*/ current_slope_long >= indicator_slope_long;
			// +++ Debug
			//debug_str_l += ";slope_long_the_best"
			// ---
		};
			
		// +++ Debug
		//log(debug_str_l + ";selected...");
		//old_nextTSlong = _nextTSlong;
		// ---
			
		calc_nextTSlong = (current_nextTSlong + 1p * current_slope_long);
			
		{
			current_nextTSlong = indicator_nextTSlong << indicator_nextTSlong >= calc_nextTSlong;
			// +++ Debug
			//debug_str_l += ";indicator_nextTSlong_the_best";
			// ---
		||
			current_nextTSlong = calc_nextTSlong << calc_nextTSlong > indicator_nextTSlong;
			// +++ Debug
			//debug_str_l += ";calc_nextTSlong_the_best";
			// ---
		};
					
		// +++ Debug
		//log(debug_str_l + ";indicator_nextTSlong=;" + indicator_nextTSlong + ";old_nextTSlong=;" + old_nextTSlong + ";nextTSlong=;" + _nextTSlong
		//	+ ";c_nextTSlong=;" + calc_nextTSlong
		//	+ ";indicator_slope_long=;" + indicator_slope_long + ";old_slope_long=;" + old_slope_long + ";slope_long=;" + _slope_long
		//	+ ";div_slope_long=;" + div_slope_long
		//);
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
// - 	indicator_line, 	- A line type of the indicator which serves as nextTSlong base
// -	indicator_price_type,	- A price type of the indicator which serves as nextTSlong base
// -	indicator_predict_window, - A predict_window type of the indicator which serves as nextTSlong base
// -	indicator_offset,	- A offset type of the indicator which serves as nextTSlong base
// -	indicator_train_window	- A train_window period of the indicator which serves as nextTSlong base	
// -	current_nextTSshort,		- An initial nextTSlong value
// -	current_slope_short		- An initial slope_long value
// Returns:
// - nextTSshort - a new value for nextTSshort
// - slope_short - a new value for slope_short
LRSLAL_short_CalcNextTSSlope(
	indicator_line, 	// A line type of the indicator which serves as nextTSshort base
	indicator_price_type,	// A price type of the indicator which serves as nextTSshort base
	indicator_predict_window, // A predict_window type of the indicator which serves as nextTSshort base
	indicator_offset,	// A offset type of the indicator which serves as nextTSshort base
	indicator_train_window,	// A train_window period of the indicator which serves as nextTSshort base	
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
			
		indicator_slope_short = ind("LinearRegression", "slope", indicator_price_type, indicator_predict_window, indicator_offset, indicator_train_window)[-1c] << account < 0l;
		indicator_nextTSshort = (ind("LinearRegression", indicator_line, indicator_price_type, indicator_predict_window, indicator_offset, indicator_train_window)[-1c]);
		div_slope_short = ((indicator_nextTSshort - ind("LinearRegression", indicator_line, indicator_price_type, indicator_predict_window, indicator_offset, indicator_train_window)[-2c]) / 1p);
		{
			current_slope_short = indicator_slope_short << indicator_slope_short < current_slope_short /*& indicator_slope_short < div_slope_short*/;
			// Debug
			//debug_str_s += ";indicator_slope_short_the_best"
		/*||
			current_slope_short = div_slope_short << div_slope_short < current_slope_short & div_slope_short < indicator_slope_short;
			// Debug
			//debug_str_s += ";div_slope_short_the_best"
			*/
		||
			current_slope_short = current_slope_short << /*current_slope_short <= div_slope_short  &*/ current_slope_short <= indicator_slope_short;
			// Debug
			//debug_str_s += ";slope_short_the_best"
		};
			
		// Debug
		//log(debug_str_s + ";selected...");
		//old_nextTSshort = nextTSshort;
			
		calc_nextTSshort = (current_nextTSshort + 1p * current_slope_short);
			
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
// - 	indicator_line, 	- A line type of the indicator which serves as nextTSlong base
// -	indicator_price_type,	- A price type of the indicator which serves as nextTSlong base
// -	indicator_predict_window, - A predict_window type of the indicator which serves as nextTSlong base
// -	indicator_offset,	- A offset type of the indicator which serves as nextTSlong base
// -	indicator_train_window	- A train_window period of the indicator which serves as nextTSlong base	
// -	current_nextTSlong,		- An initial nextTSlong value
// -	current_slope_long		- An initial slope_long value
// Returns:
// - nextTSlong - a new value for nextTSlong
// - slope_long - a new value for slope_long
LRSLAL_long_Calc1NextTSSlope(
	indicator_line, 	// A line type of the indicator which serves as nextTSlong base
	indicator_price_type,	// A price type of the indicator which serves as nextTSlong base
	indicator_offset,	// A offset type of the indicator which serves as nextTSlong base
	indicator_train_window,	// A train_window period of the indicator which serves as nextTSlong base
	slope_start,			// Initial slope value
	current_nextTSlong,		// An initial nextTSlong value
	current_slope_long		// An initial slope_long value
) :=
{
	result = 0n;
	
	slope_type = "";
	/*log("long_lr_break_open_following;dates" + ";nextTSlong_index=;" + nextTSlong_index
		+ ";start_time=;" + candle.time[nextTSlong_index] + ";start_low=;" + low[nextTSlong_index] 
		+ ";nextTSlong_time=;" + candle.time[-1c] + ";nextTSlong=;" + current_nextTSlong + ";slope_long=;" 
		+ current_slope_long + ";step=;" + step);*/
		
	nextTSlong_index = find_min_price_index(indicator_train_window);
	current_slope_long = ind("LinearRegression", "slope", indicator_price_type, "once", indicator_offset, candle.time[nextTSlong_index - 2c], candle.time[-1c]);
	
	{
		current_slope_long = slope_start << current_slope_long < slope_start;
		current_nextTSlong = (low[nextTSlong_index] + abs(nextTSlong_index) / 1c * current_slope_long * 1p);
		slope_type = "start_slope";
		/*log("long_lr_break_open_following;start_slope" 
			+ ";start_time=;" + candle.time[nextTSlong_index] + ";start_low=;" + low[nextTSlong_index] 
			+ ";nextTSlong_time=;" + candle.time[-1c] + ";nextTSlong=;" + current_nextTSlong 
			+ ";slope_long=;" + current_slope_long + ";nextTSlong_index=;" + nextTSlong_index + ";step=;" + step
		);*/
	||
		current_slope_long = current_slope_long << current_slope_long >= slope_start;
		current_nextTSlong = ind("LinearRegression", indicator_line, indicator_price_type, "once", indicator_offset, candle.time[nextTSlong_index-2c], candle.time[-1c]);
		slope_type = "calculated_slope";
		/*log("long_lr_break_open_following;calculated_slope" 
			+ ";start_time=;" + candle.time[nextTSlong_index] + ";start_low=;" + low[nextTSlong_index] 
			+ ";nextTSlong_time=;" + candle.time[-1c] + ";nextTSlong=;" + current_nextTSlong 
			+ ";slope_long=;" + current_slope_long + ";nextTSlong_index=;" + nextTSlong_index + ";step=;" + step
		);*/
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
// - 	indicator_line, 	- A line type of the indicator which serves as nextTSshort base
// -	indicator_price_type,	- A price type of the indicator which serves as nextTSshort base
// -	indicator_predict_window, - A predict_window type of the indicator which serves as nextTSshort base
// -	indicator_offset,	- A offset type of the indicator which serves as nextTSshort base
// -	indicator_train_window	- A train_window period of the indicator which serves as nextTSshort base	
// -	current_nextTSshort,		- An initial nextTSshort value
// -	current_slope_short		- An initial slope_short value
// Returns:
// - nextTSshort - a new value for nextTSshort
// - slope_short - a new value for slope_short
LRSLAL_short_Calc1NextTSSlope(
	indicator_line, 	// A line type of the indicator which serves as nextTSshort base
	indicator_price_type,	// A price type of the indicator which serves as nextTSshort base
	indicator_offset,	// A offset type of the indicator which serves as nextTSshort base
	indicator_train_window,	// A train_window period of the indicator which serves as nextTSshort base
	slope_start,			// Initial slope value
	current_nextTSshort,		// An initial nextTSshort value
	current_slope_short		// An initial slope_short value
) :=
{
	result = 0n;
	
	slope_type = "";
	
	/*log("short_lr_break_open_following;dates" + ";nextTSshort_index=;" + nextTSshort_index
		+ ";start_time=;" + candle.time[nextTSshort_index] + ";start_high=;" + high[nextTSshort_index] 
		+ ";nextTSshort_time=;" + candle.time[-1c] + ";nextTSshort=;" + current_nextTSshort + ";slope_short=;" + current_slope_short + ";step=;" + step);
	*/	
	nextTSshort_index = find_max_price_index(indicator_train_window);
	current_slope_short = ind("LinearRegression", "slope", indicator_price_type, "once", indicator_offset, candle.time[nextTSshort_index - 2c], candle.time[-1c]);
	
	{
		current_slope_short = slope_start << current_slope_short > slope_start;
		current_nextTSshort = (high[nextTSshort_index] + abs(nextTSshort_index) / 1c * current_slope_short * 1p);
		slope_type = "start_slope";
		/*log("short_lr_break_open_following;start_slope" 
			+ ";start_time=;" + candle.time[nextTSshort_index] + ";start_high=;" + high[nextTSshort_index] 
			+ ";nextTSshort_time=;" + candle.time[-1c] + ";nextTSshort=;" + current_nextTSshort 
			+ ";slope_short=;" + current_slope_short + ";nextTSshort_index=;" + nextTSshort_index + ";step=;" + step
		);*/
	||
		current_slope_short = current_slope_short << current_slope_short <= slope_start;
		current_nextTSshort = ind("LinearRegression", indicator_line, indicator_price_type, "once", indicator_offset, candle.time[nextTSshort_index-2c], candle.time[-1c]);
		slope_type = "calculated_slope";
		/*log("short_lr_break_open_following;calculated_slope"
			+ ";start_time=;" + candle.time[nextTSshort_index] + ";start_high=;" + high[nextTSshort_index] 
			+ ";nextTSshort_time=;" + candle.time[-1c] + ";nextTSshort=;" + current_nextTSshort 
			+ ";slope_short=;" + current_slope_short + ";nextTSshort_index=;" + nextTSshort_index + ";step=;" + step
		);*/
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
LR_strategy_long_condition_SlopeLevel_AdaptiveLots_36(
	expiration_time, 	// Time when to stop the strategy
	
	predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
	train_window,	// Signal line width of training window in candle number
	high_offset,	// Which type of price to take for the high line offset
	low_offset,	// Which type of price to take for the low line offset

	slope_long_start,	// Starting slope of linear regression for a long position
	slope_short_start,	// Starting slope of linear regression for a short position
	OBV_long_level/*slope_long_level*/,	// Slope level of linear regression for a long position
	OBV_short_level/*slope_short_level*/,	// Slope level of linear regression for a short position

	predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
	train_window_support,		// Support line width of training window in candle number
	predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
	train_window_resistance,	// Resistance line width of training window in candle number

	OBV_period/*channel_width*/	// Width of signal channel to disable trading
) :=
{
	result = 0n;
	nextTSlong_index = 0c;
	nextTSlong = 0p;
	
	offset = LR_strategy_condition_start_time();
	
	_long_con0 = (_long_con1 = (_long_con2 = (_long_con3 = (_long_con5 = (_long_con6 = (_long_con7 = (_long_con8 = false)))))));
	_long_con0 = ((time < expiration_time & (time >= _day_start_time & time < _day_end_time | time >= _night_start_time & time < _night_end_time) & account == 0l);
	{
		//_long_con1 = (close[offset] #^ ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[offset]) << _long_con0 == true;
		_long_con7 = (close[offset] #^ ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[offset]
				& close[offset] > ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[offset]) << _long_con0 == true;
		{
			_long_con2 = true/*(	
					ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[offset] > 0n
					|
					close[offset] < ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[offset]
					|
					close[offset] > ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[offset]
				)*/ << _long_con7 == true;
			{
				_long_con3 = true/*(ind("LinearRegression", "slope", "high", predict_window, high_offset, train_window)[-1c] > slope_long_level)*/ << _long_con2 == true;
				{
					_long_con5 = true/*(ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support) 
							- ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support) > channel_width)*/ 
						<< _long_con3 == true;
					{
						_long_con6 = true/*(close[offset] > ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support))*/ << _long_con5 == true;
						{
							res = LRSLAL_long_Calc1NextTSSlope(
									"line", 	// A line type of the indicator which serves as nextTSlong base
									"low",	// A price type of the indicator which serves as nextTSlong base
									"low",	// A offset type of the indicator which serves as nextTSlong base
									train_window,	// A train_window period of the indicator which serves as nextTSlong base	
									slope_long_start,	// Initial slope value
									_nextTSlong,	// An initial nextTSlong value
									_slope_long	// An initial slope_long value
							) << _long_con6 == true;

							_long_con8 = (close[offset] > res["nextTSlong"] & close[offset] > high[res["nextTSlong_index"]]);
							result = (_long_con8 & _long_con9 = (OBVP(OBV_period, train_window_support) > OBV_long_level))
						||
							result = false << _long_con6 != true
						}
					||
						result = false << _long_con5 != true
					}
				||
					result = false << _long_con3 != true
				}
			||
				result = false << _long_con2 != true
			}
		||
			result = (/*_long_con1 |*/ _long_con7) << _long_con7 != true
		}
	||
		result = false << _long_con0 != true
	};
	
	_long_result = result;
	
	// +++ Debug 08.08.2025 --------------------------------------------------------------------------
	/*
	log("LR_strategy_long_condition_SlopeLevel_AdaptiveLots" + ";step=;" + step + ";result=;" + result 
		+ ";con0=;" + _long_con0 + ";con1=;" + _long_con1 + ";con2=;" + _long_con2 + ";con3=;" + _long_con3 
		+ ";con5=;" + _long_con5 + ";con6=;" + _long_con6 + ";con7=;" + _long_con7 + ";con8=;" + _long_con8 
		+ ";nextTSlong_index=;" + nextTSlong_index + ";nextTSlong=;" + nextTSlong + ";close[offset]=;" + close[offset]
		//+ ";supportLH=;" + ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support)
		//+ ";supportHL=;" + ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)
	);
	*/
	// --- Debug 08.08.2025 --------------------------------------------------------------------------

	/* Debug Section 2.06.2024
	log("LR_strategy_long_condition_SlopeLevel_AdaptiveLots;offset=;" + offset + ";result=;" + result
		+ ";con0=;" + con0 + ";con1=;" + con1 + ";con2=;" + con2 + ";con3=;" + con3 + ";con4=;" + con4 + ";con5=;" + con5 + ";con6=;" + con6
	);
	*/
};

// A service method of LR_strategy_short_SlopeLevel_AdaptiveLots family.
// Tests a condition for a short position
// 4.03.2026
LR_strategy_short_condition_SlopeLevel_AdaptiveLots_36(
	expiration_time, 	// Time when to stop the strategy
	
	predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
	train_window,	// Signal line width of training window in candle number
	high_offset,	// Which type of price to take for the high line offset
	low_offset,	// Which type of price to take for the low line offset

	slope_long_start,	// Starting slope of linear regression for a long position
	slope_short_start,	// Starting slope of linear regression for a short position
	OBV_long_level/*slope_long_level*/,	// Slope level of linear regression for a long position
	OBV_short_level/*slope_short_level*/,	// Slope level of linear regression for a short position

	predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
	train_window_support,		// Support line width of training window in candle number
	predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
	train_window_resistance,	// Resistance line width of training window in candle number

	OBV_period/*channel_width*/	// Width of signal channel to disable trading
) :=
{
	result = 0n;
	nextTSshort_index = 0c;
	nextTSshort = 0p;
	
	offset = LR_strategy_condition_start_time();
	
	_short_con0 = (_short_con1 = (_short_con2 = (_short_con3 = (_short_con5 = (_short_con6 = (_short_con7 = (_short_con8 = false)))))));
	_short_con0 = ((time < expiration_time & (time >= _day_start_time & time < _day_end_time | time >= _night_start_time & time < _night_end_time) & account == 0l);
	{
		//_short_con1 = (close[offset] #_ ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[offset]) << _short_con0 == true;
		_short_con7 = (close[offset] #_ ind("LinearRegression", "low", "low", predict_window_resistance, "low", train_window_resistance)[offset]
				& close[offset] < ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[offset]) << _short_con0 == true;
		{
			_short_con2 = true/*(
					ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[offset] < 0n
					|
					close[offset] > ind("LinearRegression", "high", "low", predict_window_resistance, "low", train_window_resistance)[offset]
					|
					close[offset] < ind("LinearRegression", "low", "low", predict_window_resistance, "low", train_window_resistance)[offset]
				)*/ << _short_con1 == true;
			{
				_short_con3 = true/*(ind("LinearRegression", "slope", "low", predict_window, high_offset, train_window)[-1c] < slope_short_level)*/ << _short_con2 == true;
				{
					_short_con5 = true/*(ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance) 
							- ind("LinearRegression", "high", "low", predict_window_resistance, "low", train_window_resistance) > channel_width)*/ 
						<< _short_con3 == true;
					{
						_short_con6 = true/*(close[offset] < ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance))*/ << _short_con5 == true;
						{
							res = LRSLAL_short_Calc1NextTSSlope(
									"line", 	// A line type of the indicator which serves as nextTSshort base
									"high",	// A price type of the indicator which serves as nextTSshort base
									"high",	// A offset type of the indicator which serves as nextTSshort base
									train_window,	// A train_window period of the indicator which serves as nextTSlong base	
									slope_short_start,	// Initial slope value
									_nextTSshort,	// An initial nextTSshort value
									_slope_short	// An initial slope_short value
							) << _short_con6 == true;

							_short_con8 = (close[offset] < res["nextTSshort"] & close[offset] < low[res["nextTSshort_index"]]);
							result = (_short_con8 & _short_con9 = (OBVP(OBV_period, train_window_resistance) < OBV_short_level))
						||
							result = false << _short_con6 != true
						}
					||
						result = false << _short_con5 != true
					}
				||
					result = false << _short_con3 != true
				}
			||
				result = false << _short_con2 != true
			}
		||
			result = (/*_short_con1 |*/ _short_con7) << _short_con7 != true
		}
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
LR_strategy_long_SlopeLevel_AdaptiveLots_36(
	p_safety_stock,	// Safety stock in percents to the equity
	p_risk_L,		// Risk rate in percents for long positions
	
	pexpiration_time, 	// Time when to stop the strategy
	
	ppredict_window,	// Signal line predict window type := ("week" || "day" || "candle")
	ptrain_window,	// Signal line width of training window in candle number
	phigh_offset,	// Which type of price to take for the high line offset
	plow_offset,	// Which type of price to take for the low line offset

	pslope_long_start,	// Starting slope of linear regression for a long position
	pslope_short_start,	// Starting slope of linear regression for a short position
	OBV_long_level/*slope_long_level*/,	// Slope level of linear regression for a long position
	OBV_short_level/*slope_short_level*/,	// Slope level of linear regression for a short position

	ppredict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
	ptrain_window_support,		// Support line width of training window in candle number
	ppredict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
	ptrain_window_resistance,	// Resistance line width of training window in candle number

	OBV_period/*channel_width*/	// Width of signal channel to disable trading
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
		"line", 	// A line type of the indicator which serves as nextTSlong base
		"low",	// A price type of the indicator which serves as nextTSlong base
		"low",	// A offset type of the indicator which serves as nextTSlong base
		ptrain_window,	// A train_window period of the indicator which serves as nextTSlong base	
		pslope_long_start,	// Initial slope value
		_nextTSlong,	// An initial nextTSlong value
		_slope_long	// An initial slope_long value
	);

	_nextTSlong = (res["nextTSlong"]);
	_slope_long = (res["slope_long"]);
	nextTSlong_index = (res["nextTSlong_index"]);
	slope_type = (res["slope_type"]);
	_absSLlong = (pos.price - CalculateSLLong(p_safety_stock, p_risk_L)) << account > my_account;
	
	log("long_lr_break_open_following;" + slope_type + ";pos.price=;" + pos.price + ";account=;" + account + ";lots=;" + lots 
		+ ";start_time=;" + candle.time[nextTSlong_index] + ";start_low=;" + low[nextTSlong_index] 
		+ ";nextTSlong_time=;" + candle.time[-1c] + ";nextTSlong=;" + _nextTSlong + ";slope_long=;" + _slope_long
		+ ";absSLlong=;" + _absSLlong + ";step=;" + step);
	~
};

// A service method of LR_strategy_SlopeLevel family.
// Opens a short position
LR_strategy_short_SlopeLevel_AdaptiveLots_36(
	p_safety_stock,	// Safety stock in percents to the equity
	p_risk_S,		// Risk rate in percents for short positions
	
	pexpiration_time, 	// Time when to stop the strategy
	
	ppredict_window,	// Signal line predict window type := ("week" || "day" || "candle")
	ptrain_window,	// Signal line width of training window in candle number
	phigh_offset,	// Which type of price to take for the high line offset
	plow_offset,	// Which type of price to take for the low line offset

	pslope_long_start,	// Starting slope of linear regression for a long position
	pslope_short_start,	// Starting slope of linear regression for a short position
	OBV_long_level/*slope_long_level*/,	// Slope level of linear regression for a long position
	OBV_short_level/*slope_short_level*/,	// Slope level of linear regression for a short position

	ppredict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
	ptrain_window_support,		// Support line width of training window in candle number
	ppredict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
	ptrain_window_resistance,	// Resistance line width of training window in candle number

	OBV_period/*channel_width*/	// Width of signal channel to disable trading
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
		"line", 	// A line type of the indicator which serves as nextTSshort base
		"high",	// A price type of the indicator which serves as nextTSshort base
		"high",	// A offset type of the indicator which serves as nextTSshort base
		ptrain_window,	// A train_window period of the indicator which serves as nextTSshort base	
		pslope_short_start,	// Initial slope value
		_nextTSshort,	// An initial nextTSshort value
		_slope_short	// An initial slope_short value
	);

	_nextTSshort = (res["nextTSshort"]);
	_slope_short = (res["slope_short"]);
	nextTSshort_index = (res["nextTSshort_index"]);
	slope_type = (res["slope_type"]);
	_absSLshort = (pos.price + CalculateSLShort(p_safety_stock, p_risk_S)) << account < my_account;
	
	log("short_lr_break_open_following;" + slope_type + ";pos.price=;" + pos.price + ";account=;" + account + ";lots=;" + lots 
		+ ";start_time=;" + candle.time[nextTSshort_index] + ";start_high=;" + high[nextTSshort_index] 
		+ ";nextTSshort_time=;" + candle.time[-1c] + ";nextTSshort=;" + _nextTSshort + ";slope_short=;" + _slope_short
		+ ";absSLshort=;" + _absSLshort + ";step=;" + step);
	~
};

// Original LR strategy with managing a slope level and calculating lots adaptively.
// It opens a position only when the current slope is above or below a given slope level
// 4.03.2026
LR_strategy_SlopeLevel_AdaptiveLots_36(
	safety_stock,	// Safety stock in percents to the equity
	risk_L,		// Risk rate in percents for long positions
	risk_S,		// Risk rate in percents for short positions
	
	expiration_time, 	// Time when to stop the strategy
	
	day_start_time,	// Start time of the day trading session
	day_end_time,	// End time of the day trading session
	night_start_time,	// Start time of the night trading session
	night_end_time,	// End time of the night trading session
	
	predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
	train_window,	// Signal line width of training window in candle number
	high_offset,	// Which type of price to take for the high line offset
	low_offset,	// Which type of price to take for the low line offset

	slope_long_start,	// Starting slope of linear regression for a long position
	slope_short_start,	// Starting slope of linear regression for a short position
	OBV_long_level/*slope_long_level*/,	// Slope level of linear regression for a long position
	OBV_short_level/*slope_short_level*/,	// Slope level of linear regression for a short position

	predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
	train_window_support,		// Support line width of training window in candle number
	predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
	train_window_resistance,	// Resistance line width of training window in candle number

	OBV_period,/*channel_width*/	// Width of signal channel to disable trading
	
	no_activity_periods
) :=
{
	my_start_equity = equity;
	my_start_time = time;
	
	import("%QTrader_Libs%\QTrader_stdlib.aql");
	import("%QTrader_Libs%\QTrader_LR_stdlib.aql");

	log("LR_strategy_SlopeLevel_AdaptiveLots_has_started_and_running...");
	log("LR_strategy_SlopeLevel_AdaptiveLots_params=("); 
	log("    safety_stock=;" + safety_stock + ","); 
	log("    risk_L=;" + risk_L + ","); 
	log("    risk_S=;" + risk_S + ","); 
	log("    expiration_time=;" + expiration_time + ",");
	log("    day_start_time=;" + day_start_time + ",");
	log("    predict_window=;" + predict_window + ","); 
	log("    train_window=;" + train_window + ","); 
	log("    high_offset=;" + high_offset + ","); 
	log("    low_offset=;" + low_offset + ",");
	log("    slope_long_start=;" + slope_long_start + ","); 
	log("    slope_short_start=;" + slope_short_start + ","); 
	log("    OBV_long_level=;" + OBV_long_level + ","); 
	log("    OBV_short_level=;" + OBV_short_level + ",");
	log("    predict_window_support=;" + predict_window_support + ","); 
	log("    train_window_support=;" + train_window_support + ","); 
	log("    predict_window_resistance=;" + predict_window_resistance + ","); 
	log("    train_window_resistance=;" + train_window_resistance + ",");
	log("    OBV_period=;" + OBV_period);
	log("    no_activity_periods=;" + no_activity_periods);
	log("    day_start_time=;" + day_start_time);
	log("    day_end_time=;" + day_end_time);
	log("    night_start_time=;" + night_start_time);
	log("    night_end_time=;" + night_end_time);
	log(")");
	
	nextTSlong = low;
	nextTSshort = high;
	slope_long = slope_long_start;
	slope_short = slope_short_start;
	
	absSLlong = nextTSlong;
	absSLshort = nextTSshort;
	
	session_abs_profit_long = 0p;
	session_abs_profit_short = 0p;
	session_abs_loss_long = -1p;
	session_abs_loss_short = -1p;

	long_result = false;
	long_con0 = false;
	long_con1 = false;
	long_con2 = false; 
	long_con3 = false; 
	long_con5 = false; 
	long_con6 = false; 
	long_con7 = false; 
	long_con8 = false; 
	long_con9 = false; 
	
	short_result = false;
	short_con0 = false;
	short_con1 = false;
	short_con2 = false; 
	short_con3 = false; 
	short_con5 = false; 
	short_con6 = false; 
	short_con7 = false; 
	short_con8 = false; 
	short_con9 = false; 
				
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
				log("step_=;" + step 
				+ ";account_=;" + account 
				+ ";equity_=;" + equity 
				+ ";high_=;" + ind("LinearRegression", "line", "high", predict_window, high_offset, train_window) 
				+ ";hhigh_=;" + hhigh = ind("LinearRegression", "high", "high", predict_window, high_offset, train_window) 
				+ ";lhigh_=;" + ind("LinearRegression", "low", "high", predict_window, high_offset, train_window) 
				+ ";high.slope_=;" + ind("LinearRegression", "slope", "high", predict_window, high_offset, train_window) 
				+ ";high.mae_=;" + ind("LinearRegression", "mae", "high", predict_window, high_offset, train_window) 
				+ ";low_=;" + ind("LinearRegression", "line", "low", predict_window, low_offset, train_window)
				+ ";hlow_=;" + ind("LinearRegression", "high", "low", predict_window, low_offset, train_window)
				+ ";llow_=;" + llow = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)
				+ ";llow.slope_=;" + ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)
				+ ";llow.mae_=;" + ind("LinearRegression", "mae", "low", predict_window, low_offset, train_window)
				+ ";nextTSlong_=;" + nextTSlong + ";slope_long_=;" + slope_long
				+ ";nextTSshort_=;" + nextTSshort + ";slope_short_=;" + slope_short
				+ ";absSLlong_=;" + absSLlong
				+ ";absSLshort_=;" + absSLshort
				+ ";train_window_=;" + train_window
				+ ";train_window_resistance=;" + train_window_resistance + ";train_window_support=;" + train_window_support
				+ ";res_high_=;" + ind("LinearRegression", "line", "high", predict_window_resistance, "high", train_window_resistance) 
				+ ";res_hhigh_=;" + hhigh = ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance) 
				+ ";res_lhigh_=;" + ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance) 
				+ ";res_high.slope_=;" + ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance) 
				+ ";res_high.mae_=;" + ind("LinearRegression", "mae", "high", predict_window_resistance, "high", train_window_resistance) 
				+ ";sup_low_=;" + ind("LinearRegression", "line", "low", predict_window_support, "low", train_window_support)
				+ ";sup_hlow_=;" + ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)
				+ ";sup_llow_=;" + llow = ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)
				+ ";sup_llow.slope_=;" + ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)
				+ ";sup_llow.mae_=;" + ind("LinearRegression", "mae", "low", predict_window_support, "low", train_window_support)
				//+ ";OBV_=;" + OBVP(train_window, train_window_support)
				) 
				<< log.level != "Error";
				//step += 1n; 
			
				// +++ Debug 08.08.2025 --------------------------------------------------------------------------
				{
					log("long_conditions" + ";step=;" + step + ";result=;" + long_result 
						+ ";con0=;" + long_con0 
						+ ";con1=;" + long_con1 
						+ ";con2=;" + long_con2 
						+ ";con3=;" + long_con3 
						+ ";con5=;" + long_con5 
						+ ";con6=;" + long_con6 
						+ ";con7=;" + long_con7 
						+ ";con8=;" + long_con8 
						+ ";con9=;" + long_con9 
						+ ";OBVP=;" + OBVP(OBV_period, train_window_support) 
						+ ";supportLH=;" + ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support)
						+ ";supportHL=;" + ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)
					) << /*long_con1 |*/ long_con7 == true;
					long_con1 = (long_con7 = false);
				||
					long_con1 = long_con1 << !(/*long_con1 |*/ long_con7 == true)
				}; 
				
				{
					log("short_conditions" + ";step=;" + step + ";result=;" + short_result 
						+ ";con0=;" + short_con0 
						+ ";con1=;" + short_con1 
						+ ";con2=;" + short_con2 
						+ ";con3=;" + short_con3 
						+ ";con5=;" + short_con5 
						+ ";con6=;" + short_con6 
						+ ";con7=;" + short_con7 
						+ ";con8=;" + short_con8 
						+ ";con9=;" + short_con9 
						+ ";OBVP=;" + OBVP(OBV_period, train_window_resistance) 
						+ ";resistanceLH=;" + ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)
						+ ";resistanceHL=;" + ind("LinearRegression", "high", "low", predict_window_resistance, "low", train_window_resistance)
					) << /*short_con1 |*/ short_con7 == true;
					short_con1 = (short_con7 = false);
				||
					short_con1 = short_con1 << !(/*short_con1 |*/ short_con7 == true)
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
					"low",//"high", 	// A line type of the indicator which serves as nextTSlong base
					"low",	// A price type of the indicator which serves as nextTSlong base
					predict_window, // A predict_window type of the indicator which serves as nextTSlong base
					low_offset,	// A offset type of the indicator which serves as nextTSlong base
					train_window,	// A train_window period of the indicator which serves as nextTSlong base	
					nextTSlong,		// An initial nextTSlong value
					slope_long		// An initial slope_long value
			);
			
			nextTSlong = (res["nextTSlong"]);
			slope_long = (res["slope_long"]);
			
			~
		&&
			res = LRSLAL_short_CalcNextTSSlope(
					"high",//"low", 	// A line type of the indicator which serves as nextTSlong base
					"high",	// A price type of the indicator which serves as nextTSlong base
					predict_window, // A predict_window type of the indicator which serves as nextTSlong base
					high_offset,	// A offset type of the indicator which serves as nextTSlong base
					train_window,	// A train_window period of the indicator which serves as nextTSlong base	
					nextTSshort,		// An initial nextTSlong value
					slope_short		// An initial slope_long value
			);
			
			nextTSshort = (res["nextTSshort"]);
			slope_short = (res["slope_short"]);
			
			~
		}
	||
		thread = "";
	
		..[time < expiration_time]
		{
			my_account = account;
			{
				// Debug
				//log("LR_strategy_long_SlopeLevel_AdaptiveLots_started...");
				
				lots = 0l
				<< LR_strategy_long_condition_SlopeLevel_AdaptiveLots_36(
					expiration_time, 	// Time when to stop the strategy
	
					predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
					train_window,	// Signal line width of training window in candle number
					high_offset,	// Which type of price to take for the high line offset
					low_offset,	// Which type of price to take for the low line offset

					slope_long_start,	// Starting slope of linear regression for a long position
					slope_short_start,	// Starting slope of linear regression for a short position
					OBV_long_level/*slope_long_level*/,	// Slope level of linear regression for a long position
					OBV_short_level/*slope_short_level*/,	// Slope level of linear regression for a short position

					predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
					train_window_support,		// Support line width of training window in candle number
					predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
					train_window_resistance,	// Resistance line width of training window in candle number

					OBV_period/*channel_width*/	// Width of signal channel to disable trading
				) == true;
				
				LR_strategy_long_SlopeLevel_AdaptiveLots_36(
					safety_stock,	// Safety stock in percents to the equity
					risk_L,		// Risk rate in percents for long positions
					
					expiration_time, 	// Time when to stop the strategy
	
					predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
					train_window,	// Signal line width of training window in candle number
					high_offset,	// Which type of price to take for the high line offset
					low_offset,	// Which type of price to take for the low line offset

					slope_long_start,	// Starting slope of linear regression for a long position
					slope_short_start,	// Starting slope of linear regression for a short position
					OBV_long_level/*slope_long_level*/,	// Slope level of linear regression for a long position
					OBV_short_level/*slope_short_level*/,	// Slope level of linear regression for a short position

					predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
					train_window_support,		// Support line width of training window in candle number
					predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
					train_window_resistance,	// Resistance line width of training window in candle number

					OBV_period/*channel_width*/	// Width of signal channel to disable trading
				);
				
				// Debug
				//log("LR_strategy_long_SlopeLevel_AdaptiveLots_finished");
				
			||
				// Debug
				//log("account_>_0l_already_started...");
				slope_long = slope_long_start << my_account > 0l;
				
				res = LRSLAL_long_Calc1NextTSSlope(
					"line", 	// A line type of the indicator which serves as nextTSlong base
					"low",	// A price type of the indicator which serves as nextTSlong base
					"low",	// A offset type of the indicator which serves as nextTSlong base
					train_window,	// A train_window period of the indicator which serves as nextTSlong base	
					slope_long_start,	// Initial slope value
					nextTSlong,	// An initial nextTSlong value
					slope_long	// An initial slope_long value
				);

				nextTSlong = (res["nextTSlong"]);
				slope_long = (res["slope_long"]);
				nextTSlong_index = (res["nextTSlong_index"]);
				slope_type = (res["slope_type"]);
				absSLlong = (pos.price - CalculateSLLong(safety_stock, risk_L));
				
				//nextTSlong = find_min_price(train_window) << my_account > 0l;
				//slope_long = slope_long_start;

				log("account_>_0l_already;" + slope_type + ";pos.price=;" + pos.price + ";account=;" + account
					+ ";start_time=;" + candle.time[nextTSlong_index] + ";start_low=;" + low[nextTSlong_index] 
					+ ";nextTSlong_time=;" + candle.time[-1c] + ";nextTSlong=;" + nextTSlong 
					+ ";slope_long=;" + slope_long
					+ ";absSLlong=;" + absSLlong
				);

				//log("account_>_0l_already;pos.price_=;" + pos.price + ";account_=;" + account + ";nextTSlong=;" + nextTSlong + ";slope_long=;" + slope_long);
				
				// Debug
				//log("account_>_0l_already_finished");

			||
				// Debug
				//log("LR_strategy_short_SlopeLevel_AdaptiveLots_started...");

				lots = 0l
				<< LR_strategy_short_condition_SlopeLevel_AdaptiveLots_36(
					expiration_time, 	// Time when to stop the strategy
	
					predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
					train_window,	// Signal line width of training window in candle number
					high_offset,	// Which type of price to take for the high line offset
					low_offset,	// Which type of price to take for the low line offset

					slope_long_start,	// Starting slope of linear regression for a long position
					slope_short_start,	// Starting slope of linear regression for a short position
					OBV_long_level/*slope_long_level*/,	// Slope level of linear regression for a long position
					OBV_short_level/*slope_short_level*/,	// Slope level of linear regression for a short position

					predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
					train_window_support,		// Support line width of training window in candle number
					predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
					train_window_resistance,	// Resistance line width of training window in candle number

					OBV_period/*channel_width*/	// Width of signal channel to disable trading
				) == true;
				
				LR_strategy_short_SlopeLevel_AdaptiveLots_36(
					safety_stock,	// Safety stock in percents to the equity
					risk_S,		// Risk rate in percents for short positions
					
					expiration_time, 	// Time when to stop the strategy
	
					predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
					train_window,	// Signal line width of training window in candle number
					high_offset,	// Which type of price to take for the high line offset
					low_offset,	// Which type of price to take for the low line offset

					slope_long_start,	// Starting slope of linear regression for a long position
					slope_short_start,	// Starting slope of linear regression for a short position
					OBV_long_level/*slope_long_level*/,	// Slope level of linear regression for a long position
					OBV_short_level/*slope_short_level*/,	// Slope level of linear regression for a short position

					predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
					train_window_support,		// Support line width of training window in candle number
					predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
					train_window_resistance,	// Resistance line width of training window in candle number

					OBV_period/*channel_width*/	// Width of signal channel to disable trading
				);
				
				// Debug
				//log("LR_strategy_short_SlopeLevel_AdaptiveLots_finished");
				
			||
				// Debug
				//log("account_<_0l_already_started...");
				slope_short = slope_short_start << my_account < 0l;
				
				res = LRSLAL_short_Calc1NextTSSlope(
					"line", 	// A line type of the indicator which serves as nextTSshort base
					"high",	// A price type of the indicator which serves as nextTSshort base
					"high",	// A offset type of the indicator which serves as nextTSshort base
					train_window,	// A train_window period of the indicator which serves as nextTSshort base	
					slope_short_start,	// Initial slope value
					nextTSshort,	// An initial nextTSshort value
					slope_short	// An initial slope_short value
				);

				nextTSshort = (res["nextTSshort"]);
				slope_short = (res["slope_short"]);
				nextTSshort_index = (res["nextTSshort_index"]);
				slope_type = (res["slope_type"]);
				absSLshort = (pos.price + CalculateSLShort(safety_stock, risk_S));

				//nextTSshort = find_max_price(train_window) << my_account < 0l;
				//slope_short = slope_short_start;
				//log("account_<_0l_already;pos.price_=;" + pos.price + ";account_=;" + account + ";nextTSlong=;" + nextTSlong + ";slope_long=;" + slope_long);
				
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
				no_activity = -1c;
				lock = 0n;
				
				{
					log("looking_for_closing_long" + ";step=;" + step) << account > 0l;
					{
					/*	lock = 1n
						 << account > 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& high[-1c] > ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c]
							& close[-1c] < ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c]
							& !(ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[-1c] > 0n)
						;
						my_stop();
						log("long_lr_TP;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";no_activity=;" + abs(no_activity)) << account == 0l
					||*/
						lock = 1n
						 << account > 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& pos.profit > 2% & open > close[LR_strategy_condition_start_time()] + 1%
						;
						my_stop();
						log("long_lr_TP1;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";no_activity=;" + abs(no_activity)) << account == 0l
					||
						lock = 1n
						 << account > 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& close[-1c] < (LRSL = nextTSlong)
						;
						my_stop();
						log("long_lr_TS;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";LRSL=;" + LRSL + ";no_activity=;" + abs(no_activity)) << account == 0l
					||
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
						 << account == 0l
					||
						lock = 1n
						 << account > 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& low < absSLlong
						;
						my_stop();
						log("long_lr_SL;pos.abs_profit=;" + pos.abs_profit + ";pos.profit=;" + pos.profit
							+ ";pos.age=;" + pos.age + ";absSLlong=;" + absSLlong + ";no_activity=;" + abs(no_activity)
						) << account == 0l
					};
					
					{
						session_abs_profit_long += pos.abs_profit << pos.abs_profit >= 0p
					||
						session_abs_loss_long += pos.abs_profit << pos.abs_profit < 0p
					}
					
				||
					log("looking_for_closing_short" + ";step=;" + step) << account < 0l;
					{
					/*	lock = 1n
						 << account < 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& low[-1c] < (LRSL = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
							& close[-1c] > (LRSL = ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c])
							& !(ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[-1c] < 0n)
						;
						my_stop();
						log("short_lr_TP;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";LRSL=;" + LRSL + ";no_activity=;" + abs(no_activity)) << account == 0l
					||*/
						lock = 1n
						 << account > 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& pos.profit > 2% & open > close[LR_strategy_condition_start_time()] + 1%
						;
						my_stop();
						log("short_lr_TP1;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";no_activity=;" + abs(no_activity)) << account == 0l
					||
						lock = 1n
						 << account < 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& close[-1c] > (LRSL = nextTSshort)
						;
						my_stop();
						log("short_lr_TS;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";LRSL=;" + LRSL + ";no_activity=;" + abs(no_activity)) << account == 0l
					||
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
							<< account == 0l
					||
						lock = 1n
						 << account < 0l & lock == 0n
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& high > absSLshort
						;
						my_stop();
						log("short_lr_SL;pos.abs_profit=;" + pos.abs_profit + ";pos.profit=;" + pos.profit
							+ ";pos.age=;" + pos.age + ";absSLshort=;" + absSLshort + ";no_activity=;" + abs(no_activity)
						) << account == 0l
					};
					
					{
						session_abs_profit_short += pos.abs_profit << pos.abs_profit >= 0p
					||
						session_abs_loss_short += pos.abs_profit << pos.abs_profit < 0p
					}

				};
			
				session_abs_profit = (session_abs_profit_long + session_abs_profit_short);
				session_abs_loss = (session_abs_loss_long + session_abs_loss_short);
				session_profit_loss_rate = (session_abs_profit / -session_abs_loss);
				session_profit_loss_rate_long = (session_abs_profit_long / -session_abs_loss_long);
				session_profit_loss_rate_short = (session_abs_profit_short / -session_abs_loss_short);
				log("session_profit_&_loss" 
					+ ";session_profit_loss_rate=;" + session_profit_loss_rate
					+ ";session_profit_loss_rate_long=;" + session_profit_loss_rate_long
					+ ";session_profit_loss_rate_short=;" + session_profit_loss_rate_short
					+ ";session_abs_profit_long=;" + session_abs_profit_long + ";session_abs_loss_long=;" + session_abs_loss_long
					+ ";session_abs_profit_short=;" + session_abs_profit_short + ";session_abs_loss_short=;" + session_abs_loss_short
					+ ";session_abs_profit=;" + session_abs_profit + ";session_abs_loss=;" + session_abs_loss
				);
			}

		};
		
		log("LR_strategy_SlopeLevel_AdaptiveLots_has_expired;" + "expiration_stop");

		my_stop();

		log("LR_strategy_SlopeLevel_AdaptiveLots_has_finished;" + "script_stopped")

	};

};
// --- LR_strategy_SlopeLevel_AdaptiveLots --- 7.04.2024 -------------------------------------------------------------------------------------------------------------------

// params := (..value)
TestAdapter(params) :=
{
	idx = 0i;
	idx -= 1i;
	log("TestAdapter_LR_strategy_SlopeLevel_AdaptiveLots_has_started...;");
	
	i_safety_stock = idx += 1i;	//0 Safety stock in percents to the equity
	i_risk_L = idx += 1i;		//1 Risk rate in percents for long positions
	i_risk_S = idx += 1i;		//2 Risk rate in percents for short positions
	
	iexpiration_time = idx += 1i; 	//3 Time when to stop the strategy
	
	i_day_start_time = idx += 1i;	//4 Start time of the day trading session
	i_day_end_time = idx += 1i;	//5 End time of the day trading session
	i_night_start_time = idx += 1i;	//6 Start time of the night trading session
	i_night_end_time = idx += 1i;	//7 End time of the night trading session
	
	ipredict_window = idx += 1i;	//8 Signal line predict window type := ("week" || "day" || "candle")
	ihigh_offset = idx += 1i;	//9 Which type of price to take for the high line offset
	ilow_offset = idx += 1i;	//10 Which type of price to take for the low line offset

	//ipredict_window_support = idx += 1i;	//11 Support line predict window type := ("week" || "day" || "candle")
	ipredict_window_resistance = idx += 1i;	//12 Resistance line predict window type := ("week" || "day" || "candle")

	//itrain_window_support = idx += 1i;	//13 Support line width of training window in candle number
	itrain_window_resistance = idx += 1i;	//14 Resistance line width of training window in candle number
	itrain_window = idx += 1i;	//15 Signal line width of training window in candle number

	islope_long_start = idx += 1i;	//16 Starting slope of linear regression for a long position
	islope_short_start = idx += 1i;	//17 Starting slope of linear regression for a short position
	iOBV_long_level = idx += 1i;	//18 Slope level of linear regression for a long position
	iOBV_short_level = idx += 1i;	//19 Slope level of linear regression for a short position

	iOBV_period = idx += 1i;	//20 Width of signal channel to disable trading
	i_no_activity_periods = idx += 1i;	//21
	
	safety_stock = params[i_safety_stock];	// Safety stock in percents to the equity
	risk_L = params[i_risk_L];		// Risk rate in percents for long positions
	risk_S = params[i_risk_S];	// Risk rate in percents for short positions
	
	expiration_time = params[iexpiration_time]; 	// Time when to stop the strategy
	
	day_start_time = params[i_day_start_time];	// Start time of the day trading session
	day_end_time = params[i_day_end_time];	// End time of the day trading session
	night_start_time = params[i_night_start_time];	// Start time of the night trading session
	night_end_time = params[i_night_end_time];	// End time of the night trading session
	
	predict_window = params[ipredict_window];	// Signal line predict window type := ("week" || "day" || "candle")
	train_window = params[itrain_window];	// Signal line width of training window in candle number
	high_offset = params[ihigh_offset];	// Which type of price to take for the high line offset
	low_offset = params[ilow_offset];	// Which type of price to take for the low line offset

	slope_long_start = params[islope_long_start];	// Starting slope of linear regression for a long position
	slope_short_start = params[islope_short_start];	// Starting slope of linear regression for a short position
	OBV_long_level = params[iOBV_long_level];	// Slope level of linear regression for a long position
	OBV_short_level = params[iOBV_short_level];	// Slope level of linear regression for a short position

	predict_window_support = params[ipredict_window_resistance];	// Support line predict window type := ("week" || "day" || "candle")
	train_window_support = params[itrain_window_resistance];		// Support line width of training window in candle number
	predict_window_resistance = params[ipredict_window_resistance];	// Resistance line predict window type := ("week" || "day" || "candle")
	train_window_resistance = params[itrain_window_resistance];	// Resistance line width of training window in candle number

	OBV_period = params[iOBV_period];	// Width of signal channel to disable trading
	
	no_activity_periods = params[i_no_activity_periods];
	
	LR_strategy_SlopeLevel_AdaptiveLots_36(
		safety_stock,	// Safety stock in percents to the equity
		risk_L,		// Risk rate in percents for long positions
		risk_S,		// Risk rate in percents for short positions
	
		expiration_time, 	// Time when to stop the strategy
	
		day_start_time,	// Start time of the day trading session
		day_end_time,	// End time of the day trading session
		night_start_time,	// Start time of the night trading session
		night_end_time,	// End time of the night trading session
	
		predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
		train_window,	// Signal line width of training window in candle number
		high_offset,	// Which type of price to take for the high line offset
		low_offset,	// Which type of price to take for the low line offset

		slope_long_start,	// Starting slope of linear regression for a long position
		slope_short_start,	// Starting slope of linear regression for a short position
		OBV_long_level,	// Slope level of linear regression for a long position
		OBV_short_level,	// Slope level of linear regression for a short position

		predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
		train_window_support,		// Support line width of training window in candle number
		predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
		train_window_resistance,	// Resistance line width of training window in candle number

		OBV_period,	// Width of signal channel to disable trading
	
		no_activity_periods
	);
	
	// best_values := (equity, max_equity, min_equity, target)
	res = new("dict");
	res["equity"] = equity;
	res["max_equity"] = dealer.max_equity;
	res["min_equity"] = dealer.min_equity;
	res["target"] = equity;
	
	log("TestAdapter_LR_strategy_SlopeLevel_AdaptiveLots_has_finished;");
	result = res;
};
