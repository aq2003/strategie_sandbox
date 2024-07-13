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
CalculateLotsToLong(
	safety_stock,	// Safety stock in percents to the equity
	risk_L		// Risk rate in percents for long positions
) :=
{
	result = 0p;
	
	result = ((equity - equity * safety_stock / risk_L) / risk_L);
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
	
	result = ((equity - equity * safety_stock / risk_S) / risk_S);
};

// Calculates SL percentage for a long 
//	safety_stock - 	Safety stock in percents to the equity
//	risk_L -		Risk rate in percents for short positions
CalculateSLLong(
	safety_stock,	// Safety stock in percents to the equity
	risk_L		// Risk rate in percents for short positions
) :=
{
	result = 0n;
	
	result = (safety_stock * risk_L);
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
	
	result = (safety_stock * risk_S);
};

// Looking for day start candle to pass 2 canles in the past
// Is actual only for periods and papers which have an empty candle at the day start
LR_strategy_condition_start_time() :=
{
	result = 1c;
	
	{
		result = -2c << time == day_start_time;
	||
		result = -1c << time > day_start_time;
	};
};

// A service method of LR_strategy_long_SlopeLevel_AdaptiveLots family.
// Tests a condition for a long position
LR_strategy_long_condition_SlopeLevel_AdaptiveLots(
	_expiration_time, 	// Time when to stop the strategy
	
	_predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
	_train_window,	// Signal line width of training window in candle number
	_high_offset,	// Which type of price to take for the high line offset
	_low_offset,	// Which type of price to take for the low line offset

	_slope_long_start,	// Starting slope of linear regression for a long position
	_slope_short_start,	// Starting slope of linear regression for a short position
	_slope_long_level,	// Slope level of linear regression for a long position
	_slope_short_level,	// Slope level of linear regression for a short position

	_predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
	_train_window_support,		// Support line width of training window in candle number
	_predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
	_train_window_resistance,	// Resistance line width of training window in candle number

	_channel_width/*,	// Width of signal channel to disable trading
	
	_day_start_time,	// Start time of the day trading session
	_day_end_time,	// End time of the day trading session
	_night_start_time,	// Start time of the night trading session
	_night_end_time	// End time of the night trading session
	*/
) :=
{
	result = 0n;
	offset = LR_strategy_condition_start_time();
	result = 
	(
		(
		/*con0 =*/ (time < _expiration_time & (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)) 
		& account == 0l
		& /*con1 =*/ (close[offset] #^ (LR = ind("LinearRegression", "high", "high", _predict_window, _high_offset, _train_window)[offset]))
		& /*con2 =*/ ((
			close[offset] < (LR_sup = ind("LinearRegression", "low", "high", _predict_window_resistance, "high", _train_window_resistance)[offset])
		|
			ind("LinearRegression", "slope", "low", _predict_window_support, "low", _train_window_support)[offset] > 0n
		|
			close[offset] > (LR_sup = ind("LinearRegression", "high", "high", _predict_window_resistance, "high", _train_window_resistance)[offset])
		))
		& /*con3 =*/ (ind("LinearRegression", "slope", "high", _predict_window, _high_offset, _train_window)[-1c] > _slope_long_level)		
		& /*con4 =*/ ((
			close[-1c] > close[-_train_window] & ind("LinearRegression", "slope", "high", _predict_window, _high_offset, _train_window)[-1c] 
				> ind("LinearRegression", "slope", "high", _predict_window, _high_offset, _train_window)[-_train_window]
			|
			close[-1c] < close[-_train_window] & ind("LinearRegression", "slope", "high", _predict_window, _high_offset, _train_window)[-1c] 
				< ind("LinearRegression", "slope", "high", _predict_window, _high_offset, _train_window)[-_train_window]
		))
		& /*con5 =*/ ((ind("LinearRegression", "low", "high", _predict_window_support, "high", _train_window_support) 
			- ind("LinearRegression", "high", "low", _predict_window_support, "low", _train_window_support)) > _channel_width)
		// To open long not lower then support high
		& /*con6 =*/ close[offset] > ind("LinearRegression", "high", "low", _predict_window_support, "low", _train_window_support)
		)
		|
		(
			/*con7 =*/ (close[offset] #^ (LR = ind("LinearRegression", "high", "high", _predict_window_resistance, "high", _train_window_resistance)[offset]))
		)
	);
	
	/* Debug Section 2.06.2024
	log("LR_strategy_long_condition_SlopeLevel_AdaptiveLots;offset=;" + offset + ";result=;" + result
		+ ";con0=;" + con0 + ";con1=;" + con1 + ";con2=;" + con2 + ";con3=;" + con3 + ";con4=;" + con4 + ";con5=;" + con5 + ";con6=;" + con6
	);
	*/
};

// A service method of LR_strategy_short_SlopeLevel_AdaptiveLots family.
// Tests a condition for a short position
LR_strategy_short_condition_SlopeLevel_AdaptiveLots(
	_expiration_time, 	// Time when to stop the strategy
	
	_predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
	_train_window,	// Signal line width of training window in candle number
	_high_offset,	// Which type of price to take for the high line offset
	_low_offset,	// Which type of price to take for the low line offset

	_slope_long_start,	// Starting slope of linear regression for a long position
	_slope_short_start,	// Starting slope of linear regression for a short position
	_slope_long_level,	// Slope level of linear regression for a long position
	_slope_short_level,	// Slope level of linear regression for a short position

	_predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
	_train_window_support,		// Support line width of training window in candle number
	_predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
	_train_window_resistance,	// Resistance line width of training window in candle number

	_channel_width/*,	// Width of signal channel to disable trading
	
	_day_start_time,	// Start time of the day trading session
	_day_end_time,	// End time of the day trading session
	_night_start_time,	// Start time of the night trading session
	_night_end_time	// End time of the night trading session
	*/
) :=
{
	result = 0n;
	offset = LR_strategy_condition_start_time();
	result = 
	(
		(
		/*con0 =*/ (time < _expiration_time & (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)) 
		& account == 0l
		& /*con1 =*/ (close[offset] #_ (LR = ind("LinearRegression", "low", "low", _predict_window, _low_offset, _train_window)[offset]))
		& /*con2 =*/ ((
			close[offset] > (LR_sup = ind("LinearRegression", "high", "low", _predict_window_support, "low", _train_window_support)[offset])
		|
			ind("LinearRegression", "slope", "high", _predict_window_resistance, "high", _train_window_resistance)[offset] < 0n
		|
			(close[offset] < (LR = ind("LinearRegression", "low", "low", _predict_window_resistance, "low", _train_window_resistance)[offset]))
		))
		& /*con3 =*/ (ind("LinearRegression", "slope", "low", _predict_window, _high_offset, _train_window)[-1c] < _slope_short_level)
		& /*con4 =*/ ((
			close[-1c] > close[-_train_window] & ind("LinearRegression", "slope", "high", _predict_window, _high_offset, _train_window)[-1c] 
				> ind("LinearRegression", "slope", "high", _predict_window, _high_offset, _train_window)[-_train_window]
			|
			close[-1c] < close[-_train_window] & ind("LinearRegression", "slope", "high", _predict_window, _high_offset, _train_window)[-1c] 
				< ind("LinearRegression", "slope", "high", _predict_window, _high_offset, _train_window)[-_train_window]
		))
		& /*con5 =*/ ((ind("LinearRegression", "low", "high", _predict_window_support, "high", _train_window_support) 
			- ind("LinearRegression", "high", "low", _predict_window_support, "low", _train_window_support)) > _channel_width)
		// To open short not higher then resistanse low
		& /*con6 =*/ close[offset] < ind("LinearRegression", "low", "high", _predict_window_support, "high", _train_window_support)
		)
		|
		(
			/*con7 =*/ (close[offset] #_ (LR = ind("LinearRegression", "low", "low", _predict_window_resistance, "low", _train_window_resistance)[offset]))
		)
	);
	
	/* Debug Section 2.06.2024
	log("LR_strategy_short_condition_SlopeLevel_AdaptiveLots;offset=;" + offset + ";result=;" + result
		+ ";con0=;" + con0 + ";con1=;" + con1 + ";con2=;" + con2 + ";con3=;" + con3 + ";con4=;" + con4 + ";con5=;" + con5 + ";con6=;" + con6
	);
	*/
};
// A service method of LR_strategy_SlopeLevel_AdaptiveLots family.
// Opens a long position
LR_strategy_long_SlopeLevel_AdaptiveLots(
	p_safety_stock,	// Safety stock in percents to the equity
	p_risk_L,		// Risk rate in percents for long positions
	
	p_expiration_time, 	// Time when to stop the strategy
	
	p_predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
	p_train_window,	// Signal line width of training window in candle number
	p_high_offset,	// Which type of price to take for the high line offset
	p_low_offset,	// Which type of price to take for the low line offset

	p_slope_long_start,	// Starting slope of linear regression for a long position
	p_slope_short_start,	// Starting slope of linear regression for a short position
	p_slope_long_level,	// Slope level of linear regression for a long position
	p_slope_short_level,	// Slope level of linear regression for a short position

	p_predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
	p_train_window_support,		// Support line width of training window in candle number
	p_predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
	p_train_window_resistance,	// Resistance line width of training window in candle number

	p_channel_width/*,	// Width of signal channel to disable trading
	
	p_day_start_time,	// Start time of the day trading session
	p_day_end_time,	// End time of the day trading session
	p_night_start_time,	// Start time of the night trading session
	p_night_end_time	// End time of the night trading session
	*/
) :=
{
	/* +++ Debug Section 2.06.2024
	lots = 0p;
	log("LR_strategy_long_SlopeLevel_AdaptiveLots;started"
		+ ";p_day_start_time=;" + p_day_start_time+ ";p_day_end_time=;" + p_day_end_time
		+ ";p_night_start_time=;" + p_night_start_time+ ";p_night_end_time=;" + p_night_end_time
	);*/
	lots = 0p 
	<< LR_strategy_long_condition_SlopeLevel_AdaptiveLots(
		p_expiration_time, 	// Time when to stop the strategy
	
		p_predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
		p_train_window,	// Signal line width of training window in candle number
		p_high_offset,	// Which type of price to take for the high line offset
		p_low_offset,	// Which type of price to take for the low line offset

		p_slope_long_start,	// Starting slope of linear regression for a long position
		p_slope_short_start,	// Starting slope of linear regression for a short position
		p_slope_long_level,	// Slope level of linear regression for a long position
		p_slope_short_level,	// Slope level of linear regression for a short position

		p_predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
		p_train_window_support,		// Support line width of training window in candle number
		p_predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
		p_train_window_resistance,	// Resistance line width of training window in candle number

		p_channel_width/*,	// Width of signal channel to disable trading
	
		p_day_start_time,	// Start time of the day trading session
		p_day_end_time,	// End time of the day trading session
		p_night_start_time,	// Start time of the night trading session
		p_night_end_time	// End time of the night trading session
		*/
	);
	
	lots = CalculateLotsToLong(p_safety_stock, p_risk_L);
	log("long_lr_break_open_following;trying_to_open_long;lots=;" + lots);
	result = long(lots);
			
	nextTSlong_index = find_min_price_index(p_train_window);
	nextTSlong = low[nextTSlong_index];
	
	log("long_lr_break_open_following;dates" + ";nextTSlong_index=;" + nextTSlong_index
		+ ";start_time=;" + candle.time[nextTSlong_index] + ";start_low=;" + low[nextTSlong_index] 
		+ ";nextTSlong_time=;" + candle.time[-1c] + ";nextTSlong=;" + nextTSlong + ";slope_long=;" + slope_long);
		
	slope_long = ind("LinearRegression", "slope", "low", "once", "low", candle.time[nextTSlong_index - 2c], candle.time[-1c]);
	
	{
		slope_long = slope_long_start << slope_long < slope_long_start /*| nextTSlong_index == -1c*/;
		nextTSlong += (abs(nextTSlong_index) / 1c * slope_long * 1p);
		log("long_lr_break_open_following;start_slope" 
			+ ";start_time=;" + candle.time[nextTSlong_index] + ";start_low=;" + low[nextTSlong_index] 
			+ ";nextTSlong_time=;" + candle.time[-1c] + ";nextTSlong=;" + nextTSlong 
			+ ";slope_long=;" + slope_long + ";nextTSlong_index=;" + nextTSlong_index
		);
	||
		slope_long = slope_long << slope_long >= slope_long_start /*& nextTSlong_index < -1c*/;
		nextTSlong = ind("LinearRegression", "line", "low", "once", "low", candle.time[nextTSlong_index-2c], candle.time[-1c]);
		log("long_lr_break_open_following;calculated_slope" 
			+ ";start_time=;" + candle.time[nextTSlong_index] + ";start_low=;" + low[nextTSlong_index] 
			+ ";nextTSlong_time=;" + candle.time[-1c] + ";nextTSlong=;" + nextTSlong 
			+ ";slope_long=;" + slope_long + ";nextTSlong_index=;" + nextTSlong_index
		);
	};
	
	//nextTSlong = (low[nextTSlong_index] + 1p * (slope_long = slope_long_start) * (-nextTSlong_index / 1c));
	
	absSLlong = (pos.price - (p_safety_stock * p_risk_L)) << account > my_account;
	log("long_lr_break_open_following;pos.price=;" + pos.price + ";account=;" + account + ";lots=;" + lots 
		+ ";start_time=;" + candle.time[nextTSlong_index] + ";start_low=;" + low[nextTSlong_index] 
		+ ";nextTSlong_time=;" + candle.time[-1c] + ";nextTSlong=;" + nextTSlong + ";slope_long=;" + slope_long
		+ ";absSLlong=;" + absSLlong);
	~
};

// A service method of LR_strategy_SlopeLevel family.
// Opens a short position
LR_strategy_short_SlopeLevel_AdaptiveLots(
	p_safety_stock,	// Safety stock in percents to the equity
	p_risk_S,		// Risk rate in percents for short positions
	
	p_expiration_time, 	// Time when to stop the strategy
	
	p_predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
	p_train_window,	// Signal line width of training window in candle number
	p_high_offset,	// Which type of price to take for the high line offset
	p_low_offset,	// Which type of price to take for the low line offset

	p_slope_long_start,	// Starting slope of linear regression for a long position
	p_slope_short_start,	// Starting slope of linear regression for a short position
	p_slope_long_level,	// Slope level of linear regression for a long position
	p_slope_short_level,	// Slope level of linear regression for a short position

	p_predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
	p_train_window_support,		// Support line width of training window in candle number
	p_predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
	p_train_window_resistance,	// Resistance line width of training window in candle number

	p_channel_width/*,	// Width of signal channel to disable trading
	
	p_day_start_time,	// Start time of the day trading session
	p_day_end_time,	// End time of the day trading session
	p_night_start_time,	// Start time of the night trading session
	p_night_end_time	// End time of the night trading session
	*/
) :=
{			
	/* +++ Debug Section 2.06.2024
	lots = 0p;
	log("LR_strategy_short_SlopeLevel_AdaptiveLots;started"
		+ ";p_day_start_time=;" + p_day_start_time+ ";p_day_end_time=;" + p_day_end_time
		+ ";p_night_start_time=;" + p_night_start_time+ ";p_night_end_time=;" + p_night_end_time
	);*/
	lots = 0p 
	<< LR_strategy_short_condition_SlopeLevel_AdaptiveLots(
		p_expiration_time, 	// Time when to stop the strategy
	
		p_predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
		p_train_window,	// Signal line width of training window in candle number
		p_high_offset,	// Which type of price to take for the high line offset
		p_low_offset,	// Which type of price to take for the low line offset

		p_slope_long_start,	// Starting slope of linear regression for a long position
		p_slope_short_start,	// Starting slope of linear regression for a short position
		p_slope_long_level,	// Slope level of linear regression for a long position
		p_slope_short_level,	// Slope level of linear regression for a short position

		p_predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
		p_train_window_support,		// Support line width of training window in candle number
		p_predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
		p_train_window_resistance,	// Resistance line width of training window in candle number

		p_channel_width/*,	// Width of signal channel to disable trading
	
		p_day_start_time,	// Start time of the day trading session
		p_day_end_time,	// End time of the day trading session
		p_night_start_time,	// Start time of the night trading session
		p_night_end_time	// End time of the night trading session
		*/
	);
	
	lots = CalculateLotsToShort(p_safety_stock, p_risk_S);
	log("short_lr_break_open_following;trying_to_open_short;lots=;" + lots);
	result = short(lots);
			
	nextTSshort_index = find_max_price_index(p_train_window);
	nextTSshort = high[nextTSshort_index];
	
	log("short_lr_break_open_following;dates" + ";nextTSshort_index=;" + nextTSshort_index
		+ ";start_time=;" + candle.time[nextTSshort_index] + ";start_high=;" + high[nextTSshort_index] 
		+ ";nextTSshort_time=;" + candle.time[-1c] + ";nextTSshort=;" + nextTSshort + ";slope_short=;" + slope_short);
		
	slope_short = ind("LinearRegression", "slope", "high", "once", "high", candle.time[nextTSshort_index - 2c], candle.time[-1c]);
	
	{
		slope_short = slope_short_start << slope_short > slope_short_start /*| nextTSshort_index == -1c*/;
		nextTSshort += (abs(nextTSshort_index) / 1c * slope_short * 1p);
		log("short_lr_break_open_following;start_slope" 
			+ ";start_time=;" + candle.time[nextTSshort_index] + ";start_high=;" + high[nextTSshort_index] 
			+ ";nextTSshort_time=;" + candle.time[-1c] + ";nextTSshort=;" + nextTSshort 
			+ ";slope_short=;" + slope_short + ";nextTSshort_index=;" + nextTSshort_index
		);
	||
		slope_short = slope_short << slope_short <= slope_short_start /*& nextTSshort_index < -1c*/;
		nextTSshort = ind("LinearRegression", "line", "high", "once", "high", candle.time[nextTSshort_index-2c], candle.time[-1c]);
		log("short_lr_break_open_following;calculated_slope"
			+ ";start_time=;" + candle.time[nextTSshort_index] + ";start_high=;" + high[nextTSshort_index] 
			+ ";nextTSshort_time=;" + candle.time[-1c] + ";nextTSshort=;" + nextTSshort 
			+ ";slope_short=;" + slope_short + ";nextTSshort_index=;" + nextTSshort_index
		);
	};
	
	//nextTSshort = (high[nextTSshort_index] + 1p * (slope_short = slope_short_start) * (-nextTSshort_index / 1c));
	
	absSLshort = (pos.price + (p_safety_stock * p_risk_S)) << account < my_account;
	log("short_lr_break_open_following;pos.price=;" + pos.price + ";account=;" + account + ";lots=;" + lots 
		+ ";start_time=;" + candle.time[nextTSshort_index] + ";start_high=;" + high[nextTSshort_index] 
		+ ";nextTSshort_time=;" + candle.time[-1c] + ";nextTSshort=;" + nextTSshort + ";slope_short=;" + slope_short
		+ ";absSLshort=;" + absSLshort);
	~
};

// Original LR strategy with managing a slope level and calculating lots adaptively.
// It opens a position only when the current slope is above or below a given slope level
LR_strategy_SlopeLevel_AdaptiveLots(
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
	slope_long_level,	// Slope level of linear regression for a long position
	slope_short_level,	// Slope level of linear regression for a short position

	predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
	train_window_support,		// Support line width of training window in candle number
	predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
	train_window_resistance,	// Resistance line width of training window in candle number

	channel_width,	// Width of signal channel to disable trading
	
	no_activity_periods
) :=
{
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
	log("    slope_long_level=;" + slope_long_level + ","); 
	log("    slope_short_level=;" + slope_short_level + ",");
	log("    predict_window_support=;" + predict_window_support + ","); 
	log("    train_window_support=;" + train_window_support + ","); 
	log("    predict_window_resistance=;" + predict_window_resistance + ","); 
	log("    train_window_resistance=;" + train_window_resistance + ",");
	log("    channel_width=;" + channel_width);
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

	{
		predict_window_type = "candle";
		step = 0n; 
		..
		{
			log("step_=;" + step 
			+ ";account_=;" + account 
			+ ";equity_=;" + equity 
			+ ";high_=;" + ind("LinearRegression", "line", "high", predict_window_type, high_offset, train_window) 
			+ ";hhigh_=;" + hhigh = ind("LinearRegression", "high", "high", predict_window_type, high_offset, train_window) 
			+ ";lhigh_=;" + ind("LinearRegression", "low", "high", predict_window_type, high_offset, train_window) 
			+ ";high.slope_=;" + ind("LinearRegression", "slope", "high", predict_window_type, high_offset, train_window) 
			+ ";high.mae_=;" + ind("LinearRegression", "mae", "high", predict_window_type, high_offset, train_window) 
			+ ";low_=;" + ind("LinearRegression", "line", "low", predict_window_type, low_offset, train_window)
			+ ";hlow_=;" + ind("LinearRegression", "high", "low", predict_window_type, low_offset, train_window)
			+ ";llow_=;" + llow = ind("LinearRegression", "low", "low", predict_window_type, low_offset, train_window)
			+ ";llow.slope_=;" + ind("LinearRegression", "slope", "low", predict_window_type, low_offset, train_window)
			+ ";llow.mae_=;" + ind("LinearRegression", "mae", "low", predict_window_type, low_offset, train_window)
			+ ";nextTSlong_=;" + nextTSlong + ";slope_long_=;" + slope_long
			+ ";nextTSshort_=;" + nextTSshort + ";slope_short_=;" + slope_short
			+ ";train_window_=;" + train_window
			+ ";channel_width_=;" + (hhigh - llow)
			);
			step += 1n; 
			
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
				}
			||
				day_start_time = day_start_time << time < night_end_time
			};
			
			~
		};
		
	||
		..{
			my_nextTSlong = (ind("LinearRegression", "high", "low", predict_window, low_offset, train_window)[-1c]);
			my_slope_long = (ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c]);
			
			// Debug
			old_nextTSlong = nextTSlong;
			old_slope_long = slope_long;
			debug_str_l = "debug_moving_nextTSlong";
			
			{// >> <> << ><
				nextTSlong = my_nextTSlong << my_nextTSlong > nextTSlong & my_slope_long >= slope_long; // >>
				slope_long = my_slope_long;
				// Debug
				debug_str_l += ";my_nextTSlong_>_nextTSlong_&_my_slope_long_>=_slope_long";
			||
				{
					slope_long = slope_long << my_nextTSlong > nextTSlong & my_slope_long < slope_long; // ><
					// Debug
					debug_str_l += ";my_nextTSlong_>_nextTSlong_&_my_slope_long_<_slope_long";
				||
					slope_long = my_slope_long << my_nextTSlong <= nextTSlong & my_slope_long >= slope_long; // <>
					// Debug
					debug_str_l += ";my_nextTSlong_<=_nextTSlong_&_my_slope_long_>=_slope_long";
				||
					slope_long = slope_long << my_nextTSlong <= nextTSlong & my_slope_long < slope_long; // <<
					// Debug
					debug_str_l += ";my_nextTSlong_<=_nextTSlong_&_my_slope_long_<_slope_long";
				};
				nextTSlong += (1p * slope_long);
			};
					
			// Debug
			log(debug_str_l + ";my_nextTSlong=;" + my_nextTSlong + ";old_nextTSlong=;" + old_nextTSlong + ";nextTSlong=;" + nextTSlong
				+ ";my_slope_long=;" + my_slope_long + ";old_slope_long=;" + old_slope_long + ";slope_long=;" + slope_long
			);
			~
		&&
			my_nextTSshort = (ind("LinearRegression", "low", "high", predict_window, high_offset, train_window)[-1c]);
			my_slope_short = (ind("LinearRegression", "slope", "high", predict_window, low_offset, train_window)[-1c]);
			
			// Debug
			old_nextTSshort = nextTSshort;
			old_slope_short = slope_short;
			debug_str_s = "debug_moving_nextTSshort";
			
			{// << >> <> ><
				nextTSshort = my_nextTSshort << my_nextTSshort < nextTSshort & my_slope_short <= slope_short; // <<
				slope_short = my_slope_short;
				// Debug
				debug_str_s += ";my_nextTSshort_<_nextTSshort_&_my_slope_short_<=_slope_short";
			||
				{
					slope_short = slope_short << my_nextTSshort < nextTSshort & my_slope_short > slope_short; // <>
					// Debug
					debug_str_s += ";my_nextTSshort_<_nextTSshort_&_my_slope_short_>_slope_short";
				||
					slope_short = my_slope_short << my_nextTSshort >= nextTSshort & my_slope_short <= slope_short; // ><
					// Debug
					debug_str_s += ";my_nextTSshort_>=_nextTSshort_&_my_slope_short_<=_slope_short";
				||
					slope_short = slope_short << my_nextTSshort >= nextTSshort & my_slope_short > slope_short; // >>
					// Debug
					debug_str_s += ";my_nextTSshort_>=_nextTSshort_&_my_slope_short_>_slope_short";
				};
				nextTSshort += (1p * slope_short);
			};
					
			// Debug
			log(debug_str_s + ";my_nextTSshort=;" + my_nextTSshort + ";old_nextTSshort=;" + old_nextTSshort + ";nextTSshort=;" + nextTSshort
				+ ";my_slope_short=;" + my_slope_short + ";old_slope_short=;" + old_slope_short + ";slope_short=;" + slope_short
			);
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
				
				LR_strategy_long_SlopeLevel_AdaptiveLots(
					safety_stock,	// Safety stock in percents to the equity
					risk_L,		// Risk rate in percents for long positions
					
					expiration_time, 	// Time when to stop the strategy
	
					predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
					train_window,	// Signal line width of training window in candle number
					high_offset,	// Which type of price to take for the high line offset
					low_offset,	// Which type of price to take for the low line offset

					slope_long_start,	// Starting slope of linear regression for a long position
					slope_short_start,	// Starting slope of linear regression for a short position
					slope_long_level,	// Slope level of linear regression for a long position
					slope_short_level,	// Slope level of linear regression for a short position

					predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
					train_window_support,		// Support line width of training window in candle number
					predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
					train_window_resistance,	// Resistance line width of training window in candle number

					channel_width/*,	// Width of signal channel to disable trading
					
					my_day_start_time,	// Start time of the day trading session
					my_day_end_time,	// End time of the day trading session
					my_night_start_time,	// Start time of the night trading session
					my_night_end_time	// End time of the night trading session
					*/
				);
				
				// Debug
				//log("LR_strategy_long_SlopeLevel_AdaptiveLots_finished");
				
				
			||
				// Debug
				//log("account_>_0l_already_started...");
				
				nextTSlong = find_min_price(train_window) << my_account > 0l;
				slope_long = slope_long_start;
				log("account_>_0l_already;pos.price_=;" + pos.price + ";account_=;" + account + ";nextTSlong=;" + nextTSlong + ";slope_long=;" + slope_long);
				
				// Debug
				//log("account_>_0l_already_finished");

			||
				// Debug
				//log("LR_strategy_short_SlopeLevel_AdaptiveLots_started...");

				
				LR_strategy_short_SlopeLevel_AdaptiveLots(
					safety_stock,	// Safety stock in percents to the equity
					risk_S,		// Risk rate in percents for short positions
					
					expiration_time, 	// Time when to stop the strategy
	
					predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
					train_window,	// Signal line width of training window in candle number
					high_offset,	// Which type of price to take for the high line offset
					low_offset,	// Which type of price to take for the low line offset

					slope_long_start,	// Starting slope of linear regression for a long position
					slope_short_start,	// Starting slope of linear regression for a short position
					slope_long_level,	// Slope level of linear regression for a long position
					slope_short_level,	// Slope level of linear regression for a short position

					predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
					train_window_support,		// Support line width of training window in candle number
					predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
					train_window_resistance,	// Resistance line width of training window in candle number

					channel_width/*,	// Width of signal channel to disable trading
					
					my_day_start_time,	// Start time of the day trading session
					my_day_end_time,	// End time of the day trading session
					my_night_start_time,	// Start time of the night trading session
					my_night_end_time	// End time of the night trading session
					*/
				);
				
				// Debug
				//log("LR_strategy_short_SlopeLevel_AdaptiveLots_finished");
				
				
			||
				// Debug
				log("account_<_0l_already_started...");
				
				nextTSshort = find_max_price(train_window) << my_account < 0l;
				slope_short = slope_short_start;
				log("account_<_0l_already;pos.price_=;" + pos.price + ";account_=;" + account + ";nextTSlong=;" + nextTSlong + ";slope_long=;" + slope_long);
				
				// Debug
				log("account_<_0l_already_finished");
				
			};
		
			{
				no_activity = -1c;
				
				{
					log("looking_for_closing_long") << account > 0l;
					{
						stop() << account > 0l
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& high[-1c] > (LRSL = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
							& close[-1c] < (LRSL = ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
							& !(ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[-1c] > 0n)
						;
						log("long_lr_TP;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";LRSL=;" + LRSL + ";no_activity=;" + abs(no_activity)) << account == 0l
					||
						stop() << account > 0l
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& close[-1c] < (LRSL = nextTSlong)
						;
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
							log("long_lr_NAS;no_activity=;" + no_activity + ";close=;" + close + ";LRHH=;" + LRHH);
							~
						};
							
						stop() << (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time);

						log("long_lr_NAS;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";no_activity=;" + no_activity) 
							<< account == 0l
					||
						stop() << account > 0l 
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& low < absSLlong
						;
						log("long_lr_SL;pos.abs_profit=;" + pos.abs_profit + ";pos.profit=;" + pos.profit
							+ ";pos.age=;" + pos.age + ";absSLlong=;" + absSLlong + ";no_activity=;" + abs(no_activity)
						) << account == 0l
					}
				||
					log("looking_for_closing_short") << account < 0l;
					{
						stop() << account < 0l
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& low[-1c] < (LRSL = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
							& close[-1c] > (LRSL = ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c])
							& !(ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[-1c] < 0n)
						;
						log("short_lr_TP;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";LRSL=;" + LRSL + ";no_activity=;" + abs(no_activity)) << account == 0l
					||
						stop() << account < 0l
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& close[-1c] > (LRSL = nextTSshort)
						;
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
							log("short_lr_NAS;no_activity=;" + no_activity + ";close=;" + close + ";LRLL=;" + LRLL);
							~
						};
							
						stop() << (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time);

						log("short_lr_NAS;pos.abs_profit=;" + pos.abs_profit + ";pos.age=;" + pos.age + ";no_activity=;" + no_activity) 
							<< account == 0l
					||
						stop() << account < 0l 
							& (time >= day_start_time & time < day_end_time | time >= night_start_time & time < night_end_time)
							& high > absSLshort
						;
						log("short_lr_SL;pos.abs_profit=;" + pos.abs_profit + ";pos.profit=;" + pos.profit
							+ ";pos.age=;" + pos.age + ";absSLshort=;" + absSLshort + ";no_activity=;" + abs(no_activity)
						) << account == 0l
					}
				}
			}
		}
	};

	log("LR_strategy_SlopeLevel_AdaptiveLots_has_expired;" + "expiration_stop");

	stop();

	log("LR_strategy_SlopeLevel_AdaptiveLots_has_finished;" + "script_stopped")
};
// --- LR_strategy_SlopeLevel_AdaptiveLots --- 7.04.2024 -------------------------------------------------------------------------------------------------------------------

TestAdapter_LR_strategy_SlopeLevel_AdaptiveLots(
	params // params := (..value)
) :=
{
	idx = 0i;
	idx -= 1i;
	log("TestAdapter_LR_strategy_SlopeLevel_AdaptiveLots_has_started...;");
	
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

	i_slope_long_start = idx += 1i;	//16 Starting slope of linear regression for a long position
	i_slope_short_start = idx += 1i;	//17 Starting slope of linear regression for a short position
	i_slope_long_level = idx += 1i;	//18 Slope level of linear regression for a long position
	i_slope_short_level = idx += 1i;	//19 Slope level of linear regression for a short position

	i_channel_width = idx += 1i;	//20 Width of signal channel to disable trading
	i_no_activity_periods = idx += 1i;	//21
	
	safety_stock = params[i_safety_stock];	// Safety stock in percents to the equity
	risk_L = params[i_risk_L];		// Risk rate in percents for long positions
	risk_S = params[i_risk_S];	// Risk rate in percents for short positions
	
	expiration_time = params[i_expiration_time]; 	// Time when to stop the strategy
	
	day_start_time = params[i_day_start_time];	// Start time of the day trading session
	day_end_time = params[i_day_end_time];	// End time of the day trading session
	night_start_time = params[i_night_start_time];	// Start time of the night trading session
	night_end_time = params[i_night_end_time];	// End time of the night trading session
	
	predict_window = params[i_predict_window];	// Signal line predict window type := ("week" || "day" || "candle")
	train_window = params[i_train_window];	// Signal line width of training window in candle number
	high_offset = params[i_high_offset];	// Which type of price to take for the high line offset
	low_offset = params[i_low_offset];	// Which type of price to take for the low line offset

	slope_long_start = params[i_slope_long_start];	// Starting slope of linear regression for a long position
	slope_short_start = params[i_slope_short_start];	// Starting slope of linear regression for a short position
	slope_long_level = params[i_slope_long_level];	// Slope level of linear regression for a long position
	slope_short_level = params[i_slope_short_level];	// Slope level of linear regression for a short position

	predict_window_support = params[i_predict_window_support];	// Support line predict window type := ("week" || "day" || "candle")
	train_window_support = params[i_train_window_support];		// Support line width of training window in candle number
	predict_window_resistance = params[i_predict_window_resistance];	// Resistance line predict window type := ("week" || "day" || "candle")
	train_window_resistance = params[i_train_window_resistance];	// Resistance line width of training window in candle number

	channel_width = params[i_channel_width];	// Width of signal channel to disable trading
	
	no_activity_periods = params[i_no_activity_periods];

	LR_strategy_SlopeLevel_AdaptiveLots(
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
		slope_long_level,	// Slope level of linear regression for a long position
		slope_short_level,	// Slope level of linear regression for a short position

		predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
		/*train_window_support*/train_window_resistance,		// Support line width of training window in candle number
		predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
		train_window_resistance,	// Resistance line width of training window in candle number

		channel_width,	// Width of signal channel to disable trading
	
		no_activity_periods
	);
	
	// best_values := (equity, max_equity, min_equity, target)
	res = new("dict");
	res["equity"] = equity;
	res["max_equity"] = max_equity;
	res["min_equity"] = min_equity;
	res["target"] = equity;
	
	log("TestAdapter_LR_strategy_SlopeLevel_AdaptiveLots_has_finished;");
	result = res;
};