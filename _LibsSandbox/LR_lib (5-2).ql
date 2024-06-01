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

//lib_path = "C:\Users\Admin\Documents\GitHub\libs_sandbox\Libs Sandbox\";
//import(lib_path + "trade_lib.aql");

my_stop() :=
{
	..[account != 0l]
	{
		log("my_stop_sending;" + "account=;" + account);
		stop();
		~
	};
	log("my_stop_finished;" + "account=;" + account)
};

reporter(
		predict_window_type,	// Signal line predict window type := ("week" || "day" || "candle")
		train_window,	// Signal line width of training window in candle number
		high_offset,	// Which type of price to take for the high line offset
		low_offset		// Which type of price to take for the low line offset
		) := 
{
	//step = step;
	a = 1n;
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
		+ ";nextSLlong_=;" + nextSLlong + ";slope_long_=;" + slope_long
		+ ";nextSLshort_=;" + nextSLshort + ";slope_short_=;" + slope_short
		+ ";train_window_=;" + train_window
		+ ";channel_width_=;" + (hhigh - llow)
	);
	step += 1n; 
	~
};

find_max_price(period) :=
{
	index = 0c;
	index = -period;
	max = high[index];
	
	..[index < 0c]
	{
		{
			max = high[index] << high[index] > max;
		||
			max = max << high[index] <= max;
		};
		
		index += 1c;
	};
	
	result = max;
};

find_max_price_index(period) :=
{
	index = 0c;
	index = -period;
	res = index;
	max = high[index];
	
	..[index < 0c]
	{
		{
			max = high[index] << high[index] > max;
			res = index;
		||
			max = max << high[index] <= max;
		};
		
		index += 1c;
	};
	
	result = res;
};

find_min_price(period) :=
{
	index = 0c;
	index = -period;
	min = low[index];
	
	..[index < 0c]
	{
		{
			min = low[index] << low[index] < min
		||
			min = min << low[index] >= min
		};
		
		index += 1c;
	};
	
	result = min;
};

find_min_price_index(period) :=
{
	index = 0c;
	index = -period;
	res = index;
	min = low[index];
	
	..[index < 0c]
	{
		{
			min = low[index] << low[index] < min;
			res = index;
		||
			min = min << low[index] >= min
		};
		
		index += 1c;
	};
	
	result = res;
};

// A strategy which tunes adaptive its train_window size according to channel_width value with train_window_divider pace
LRS_adaptive(
		lots,				// Number of lots to open a position
		expiration_time, 	// Time when to stop the strategy
	
		predict_window_type,	// Signal line predict window type := ("week" || "day" || "candle")
		train_window_max,	// Maximum training window size of Signal line in candles
		train_window_min,	// Minimum training window size of Signal line in candles
		train_window_divider,	// Divider and multiplier to adjust train_window by channel_width value
		
		high_offset,	// Which type of price to take for the high line offset
		low_offset,	// Which type of price to take for the low line offset

		slope_long_start,	// Starting slope of linear regression for a long position
		slope_short_start,	// Starting slope of linear regression for a short position

		predict_window_type_support,	// Support line predict window type := ("week" || "day" || "candle")
		train_window_support,		// Support line width of training window in candle number
		predict_window_type_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
		train_window_resistance,	// Resistance line width of training window in candle number

		channel_width_max,	// Max edge of channel_width range
		channel_width_min	// Min edge of channel_width range
		) :=
{
	nextSLlong = low;
	nextSLshort = high;
	
	channel_width = 0p;
	train_window = train_window_max;

	{
		step = 0n; ..reporter(predict_window_type,	train_window, high_offset, low_offset)
	||
		..{
			{
				nextSLlong = ind("LinearRegression", "low", "low", predict_window_type, low_offset, train_window)[-1c] << 
					ind("LinearRegression", "low", "low", predict_window_type, low_offset, train_window)[-1c] > nextSLlong
					& ind("LinearRegression", "slope", "low", predict_window_type, low_offset, train_window)[-1c] >= slope_long;
				
				slope_long = ind("LinearRegression", "slope", "low", predict_window_type, low_offset, train_window)[-1c];
			||
				nextSLlong += (1p * slope_long) << 
					!(ind("LinearRegression", "low", "low", predict_window_type, low_offset, train_window)[-1c] > nextSLlong
					& ind("LinearRegression", "slope", "low", predict_window_type, low_offset, train_window)[-1c] >= slope_long)
			};
					
			~
		&&
			{
				nextSLshort = ind("LinearRegression", "high", "high", predict_window_type, high_offset, train_window)[-1c] << 
					ind("LinearRegression", "high", "high", predict_window_type, high_offset, train_window)[-1c] < nextSLshort
					& ind("LinearRegression", "slope", "low", predict_window_type, low_offset, train_window)[-1c] <= slope_short;
				
				slope_short = ind("LinearRegression", "slope", "high", predict_window_type, low_offset, train_window)[-1c];
			||
				nextSLshort += (1p * slope_short) << 
					!(ind("LinearRegression", "high", "high", predict_window_type, high_offset, train_window)[-1c] < nextSLshort
					& ind("LinearRegression", "slope", "low", predict_window_type, low_offset, train_window)[-1c] <= slope_short)
			};
					
			~
		}
		
	||
		..{
			channel_width = (ind("LinearRegression", "high", "high", predict_window_type, high_offset, train_window) 
						- ind("LinearRegression", "low", "low", predict_window_type, low_offset, train_window));
						
			{
				log("start_adjusting...;increase_train_window" 
					+ ";train_window=;" + train_window + ";train_window_min=;" + train_window_min 
					+ ";channel_width=;" + channel_width + ";channel_width_max=;" + channel_width_max)
				<< channel_width > channel_width_max & train_window > train_window_min;
				
				train_window /= train_window_divider;
				log("adjusting;increase_train_window;train_window_=;" + train_window)
			||
				log("start_adjusting...;decrease_train_window" 
					+ ";train_window=;" + train_window + ";train_window_max=;" + train_window_max 
					+ ";channel_width=;" + channel_width + ";channel_width_min=;" + channel_width_min)
				<< channel_width < channel_width_min & train_window < train_window_max;
				
				train_window *= train_window_divider;
				log("adjusting;decrease_train_window;train_window_=;" + train_window)
			||
				log("adjusting;" 
					+ ";train_window=;" + train_window + ";train_window_min=;" + train_window_min + ";train_window_max=;" + train_window_max 
					+ ";channel_width=;" + channel_width + ";channel_width_min=;" + channel_width_min + ";channel_width_max=;" + channel_width_max)
				<< !(channel_width > channel_width_max & train_window > train_window_min) 
					& !(channel_width < channel_width_min & train_window < train_window_max)
			};
			~
		}
	||
	
		..[time < expiration_time]
		{
			my_account = account;
			{
				long(lots) << time < expiration_time & account == 0l
					& close[-1c] #^ (LR = ind("LinearRegression", "high", "high", predict_window_type, high_offset, train_window)[-1c])
					& (
						close[-1c] < (LR_sup = ind("LinearRegression", "low", "high", predict_window_type_resistance, "high", train_window_resistance)[-1c])
					|
						ind("LinearRegression", "slope", "low", predict_window_type_support, "low", train_window_support)[-1c] > 0n
					)
					//& close[-1c] > (LR_sup = ind("LinearRegression", "low", "low", predict_window_type_support, "low", train_window_support)[-1c])
					& (ind("LinearRegression", "high", "high", predict_window_type, high_offset, train_window) 
						- ind("LinearRegression", "low", "low", predict_window_type, low_offset, train_window)) > 0p
				;
				nextSLlong = find_min_price(train_window);
				slope_long = slope_long_start;
				log("long_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account + ";LR_=;" + LR + ";nextSLlong=;" + nextSLlong) << account > my_account;
				~
			||
				log("account_>_0l_already") << my_account > 0l
			||
				short(lots) << time < expiration_time & account == 0l
					& close[-1c] #_ (LR = ind("LinearRegression", "low", "low", predict_window_type, low_offset, train_window)[-1c])
					//& close[-1c] < (LR_sup = ind("LinearRegression", "high", "high", predict_window_type_resistance, "high", train_window_resistance)[-1c])
					& (
						close[-1c] > (LR_sup = ind("LinearRegression", "high", "low", predict_window_type_support, "low", train_window_support)[-1c])
					|
						ind("LinearRegression", "slope", "high", predict_window_type_resistance, "high", train_window_resistance)[-1c] < 0n
					)
					& (ind("LinearRegression", "high", "high", predict_window_type, high_offset, train_window) 
						- ind("LinearRegression", "low", "low", predict_window_type, low_offset, train_window)) > 0p
				;
				nextSLshort = find_max_price(train_window);
				slope_short = slope_short_start;
				log("short_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account + ";LR_=;" + LR + ";nextSLshort=;" + nextSLshort) << account < my_account;
				~
			||
				log("account_<_0l_already") << my_account < 0l
			};
		
			{
				{
					log("looking_for_closing_long") << account > 0l;
					{
						{
						/*	stop() << time > 10:00 & account > 0l
								& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", predict_window_type_support, "low", train_window_support)[-1c])
							;
							log("long_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						||*/
							stop() << time > 07:00 & account > 0l
								& high[-1c] > (LRSL = ind("LinearRegression", "low", "high", predict_window_type_resistance, "high", train_window_resistance)[-1c])
								& !(ind("LinearRegression", "slope", "low", predict_window_type_support, "low", train_window_support)[-1c] > 0n)
							;
							log("long_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						||
							stop() << time > 07:00 & account > 0l
								/*& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", predict_window_type, low_offset, train_window)[-1c])*/
								& close[-1c] < (LRSL = nextSLlong)
								//& ind("LinearRegression", "high", "high", predict_window_type, "none", train_window)[-1c]
								//	- ind("LinearRegression", "low", "low", predict_window_type, "none", train_window)[-1c] >= 2p
							;
							log("long_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						/*||
							stop() << time > 10:00 & account > 0l
							& close[-1c] < absoluteSL
							;
							log("long_lr_absoluteSL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";absoluteSL_=;" + absoluteSL) << account == 0l*/
						}
					}
				||
					log("looking_for_closing_short") << account < 0l;
					{
					/*	stop() << time > 10:00 & account < 0l
							& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", predict_window_type_resistance, "high", train_window_resistance)[-1c])
						;
						log("short_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					||*/
						stop() << time > 07:00 & account < 0l
							& low[-1c] < (LRSL = ind("LinearRegression", "high", "low", predict_window_type_support, "low", train_window_support)[-1c])
							& !(ind("LinearRegression", "slope", "high", predict_window_type_resistance, "high", train_window_resistance)[-1c] < 0n)
						;
						log("short_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					||
						stop() << time > 07:00 & account < 0l
							/*& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", predict_window_type, high_offset, train_window)[-1c])*/
							& close[-1c] > (LRSL = nextSLshort)
							//& ind("LinearRegression", "high", "high", predict_window_type, "none", train_window)[-1c]
							//	- ind("LinearRegression", "low", "low", predict_window_type, "none", train_window)[-1c] >= 2p
						;
						log("short_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					/*||
						stop() << time > 10:00 & account > 0l
							& close[-1c] > absoluteSL
						;
						log("short_lr_absoluteSL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";absoluteSL_=;" + absoluteSL) << account == 0l*/
					}
				}
			}
		}
	};
	
	log("expiration_stop");

	stop();

	log("LR_strategy_has_stopped")
};

// A service method of LR_strategy family.
// Opens a long position
LR_strategy_long(
	lots,				// Number of lots to open a position
	expiration_time, 	// Time when to stop the strategy
	
	predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
	train_window,	// Signal line width of training window in candle number
	high_offset,	// Which type of price to take for the high line offset
	low_offset,	// Which type of price to take for the low line offset

	slope_long_start,	// Starting slope of linear regression for a long position
	slope_short_start,	// Starting slope of linear regression for a short position

	predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
	train_window_support,		// Support line width of training window in candle number
	predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
	train_window_resistance,	// Resistance line width of training window in candle number

	channel_width	// Width of signal channel to disable trading
) :=
{
	long(lots) << time < expiration_time & account == 0l
		& close[-1c] #^ (LR = ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c])
		& (
			close[-1c] < (LR_sup = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
		|
			ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[-1c] > 0n
		)
		//& close[-1c] > (LR_sup = ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c])
		& (ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support) 
			- ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)) > channel_width
	;
			
	nextSLlong_index = (find_min_price_index(train_window) - 1c);
	//nextSLlong = (low[nextSLlong_index] + 1p * (slope_long = slope_long_start) * (-nextSLlong_index / 1c));
	nextSLlong = ind("LinearRegression", "line", "low", "once", "low", candle.time[nextSLlong_index], candle.time);
	slope_long = ind("LinearRegression", "slope", "low", "once", "low", candle.time[nextSLlong_index], candle.time);
	log("long_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account + ";LR_=;" + LR 
		+ ";start_time=;" + candle.time[nextSLlong_index] + ";start_low=;" + low[nextSLlong_index] 
		+ ";nextSLlong_time=;" + candle.time + ";nextSLlong=;" + nextSLlong + ";slope_long=;" + slope_long) << account > my_account;
	~
};

// A service method of LR_strategy family.
// Opens a short position
LR_strategy_short(
	lots,				// Number of lots to open a position
	expiration_time, 	// Time when to stop the strategy
	
	predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
	train_window,	// Signal line width of training window in candle number
	high_offset,	// Which type of price to take for the high line offset
	low_offset,	// Which type of price to take for the low line offset

	slope_long_start,	// Starting slope of linear regression for a long position
	slope_short_start,	// Starting slope of linear regression for a short position

	predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
	train_window_support,		// Support line width of training window in candle number
	predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
	train_window_resistance,	// Resistance line width of training window in candle number

	channel_width	// Width of signal channel to disable trading
) :=
{			
	short(lots) << time < expiration_time & account == 0l
		& close[-1c] #_ (LR = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c])
		& (
			close[-1c] > (LR_sup = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
		|
			ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[-1c] < 0n
		)
		//& close[-1c] < (LR_sup = ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
		& (ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support) 
			- ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)) > channel_width
	;
			
	nextSLshort_index = (find_max_price_index(train_window) - 1c);
	//nextSLshort = (high[nextSLshort_index] + 1p * (slope_short = slope_short_start) * (-nextSLshort_index / 1c));
	nextSLshort = ind("LinearRegression", "line", "high", "once", "high", candle.time[nextSLshort_index], candle.time);
	slope_long = ind("LinearRegression", "slope", "high", "once", "high", candle.time[nextSLshort_index], candle.time);
	log("short_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account + ";LR_=;" + LR 
		+ ";start_time=;" + candle.time[nextSLshort_index] + ";start_high=;" + high[nextSLshort_index] 
		+ ";nextSLshort_time=;" + candle.time + ";nextSLshort=;" + nextSLshort + ";slope_short=;" + slope_short) << account < my_account;
	~
};

// Original LR strategy
LR_strategy(
		lots,				// Number of lots to open a position
		expiration_time, 	// Time when to stop the strategy
	
		predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
		train_window,	// Signal line width of training window in candle number
		high_offset,	// Which type of price to take for the high line offset
		low_offset,	// Which type of price to take for the low line offset

		slope_long_start,	// Starting slope of linear regression for a long position
		slope_short_start,	// Starting slope of linear regression for a short position

		predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
		train_window_support,		// Support line width of training window in candle number
		predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
		train_window_resistance,	// Resistance line width of training window in candle number

		channel_width	// Width of signal channel to disable trading
		) :=
{
nextSLlong = low;
nextSLshort = high;
slope_long = slope_long_start;
slope_short = slope_short_start;

{
	step = 0n; ..reporter(predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
					train_window,	// Signal line width of training window in candle number
					high_offset,	// Which type of price to take for the high line offset
					low_offset)
||
	..{
		{
			nextSLlong = ind("LinearRegression", "low", "high", predict_window, low_offset, train_window)[-1c] << 
				ind("LinearRegression", "low", "high", predict_window, low_offset, train_window)[-1c] > nextSLlong
				& ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c] >= slope_long;
				
			slope_long = ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c];
		||
			nextSLlong += (1p * slope_long);
		};
					
		~
	&&
		{
			nextSLshort = ind("LinearRegression", "high", "low", predict_window, high_offset, train_window)[-1c] << 
				ind("LinearRegression", "high", "low", predict_window, high_offset, train_window)[-1c] < nextSLshort
				& ind("LinearRegression", "slope", "high", predict_window, low_offset, train_window)[-1c] <= slope_short;
				
			slope_short = ind("LinearRegression", "slope", "high", predict_window, low_offset, train_window)[-1c];
		||
			nextSLshort += (1p * slope_short);
		};
					
		~
	}
||
	thread = "";
	
	..[time < expiration_time]
	{
		my_account = account;
		{
			LR_strategy_long(
				lots,				// Number of lots to open a position
				expiration_time, 	// Time when to stop the strategy
	
				predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
				train_window,	// Signal line width of training window in candle number
				high_offset,	// Which type of price to take for the high line offset
				low_offset,	// Which type of price to take for the low line offset

				slope_long_start,	// Starting slope of linear regression for a long position
				slope_short_start,	// Starting slope of linear regression for a short position

				predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
				train_window_support,		// Support line width of training window in candle number
				predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
				train_window_resistance,	// Resistance line width of training window in candle number

				channel_width	// Width of signal channel to disable trading
			)
			
		||
			nextSLlong = find_min_price(train_window) << my_account > 0l;
			slope_long = slope_long_start;
			log("account_>_0l_already;pos.price_=;" + pos.price + ";account_=;" + account + ";nextSLlong=;" + nextSLlong + ";slope_long=;" + slope_long)
		||
			LR_strategy_short(
				lots,				// Number of lots to open a position
				expiration_time, 	// Time when to stop the strategy
	
				predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
				train_window,	// Signal line width of training window in candle number
				high_offset,	// Which type of price to take for the high line offset
				low_offset,	// Which type of price to take for the low line offset

				slope_long_start,	// Starting slope of linear regression for a long position
				slope_short_start,	// Starting slope of linear regression for a short position

				predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
				train_window_support,		// Support line width of training window in candle number
				predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
				train_window_resistance,	// Resistance line width of training window in candle number

				channel_width	// Width of signal channel to disable trading
			)
			
		||
			nextSLshort = find_max_price(train_window) << my_account < 0l;
			slope_short = slope_short_start;
			log("account_<_0l_already;pos.price_=;" + pos.price + ";account_=;" + account + ";nextSLlong=;" + nextSLlong + ";slope_long=;" + slope_long)
		};
		
		{
			{
				log("looking_for_closing_long") << account > 0l;
				{
					{
					/*	stop() << time > 10:00 & account > 0l
							& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c])
						;
						log("long_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					||*/
						stop() << time > 07:00 & account > 0l
							& high[-1c] > (LRSL = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
							& !(ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[-1c] > 0n)
						;
						log("long_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					||
						stop() << time > 07:00 & account > 0l
							/*& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c])*/
							& close[-1c] < (LRSL = nextSLlong)
							//& ind("LinearRegression", "high", "high", predict_window, "none", train_window)[-1c]
							//	- ind("LinearRegression", "low", "low", predict_window, "none", train_window)[-1c] >= 2p
						;
						log("long_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					/*||
						stop() << time > 10:00 & account > 0l
						& close[-1c] < absoluteSL
						;
						log("long_lr_absoluteSL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";absoluteSL_=;" + absoluteSL) << account == 0l*/
					}
				}
			||
				log("looking_for_closing_short") << account < 0l;
				{
				/*	stop() << time > 10:00 & account < 0l
						& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
					;
					log("short_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
				||*/
					stop() << time > 07:00 & account < 0l
						& low[-1c] < (LRSL = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
						& !(ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[-1c] < 0n)
					;
					log("short_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
				||
					stop() << time > 07:00 & account < 0l
						/*& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c])*/
						& close[-1c] > (LRSL = nextSLshort)
						//& ind("LinearRegression", "high", "high", predict_window, "none", train_window)[-1c]
						//	- ind("LinearRegression", "low", "low", predict_window, "none", train_window)[-1c] >= 2p
					;
					log("short_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
				/*||
					stop() << time > 10:00 & account > 0l
						& close[-1c] > absoluteSL
					;
					log("short_lr_absoluteSL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";absoluteSL_=;" + absoluteSL) << account == 0l*/
				}
			}
		}
	}
};

log("expiration_stop");

stop();

log("script_stopped")
};

// Looking for day start candle to pass 2 canles in the past
// Is actual only for periods and papers which have an empty candle at the day start
LR_strategy_condition_start_time()
{
	result = 1c;
	
	{
		result = -2c << time == day_start_time;
	||
		result = -1c << time > day_start_time;
	};
};

// A service method of LR_strategy_long family.
// Tests a condition for a long position
LR_strategy_long_condition() :=
{
	result = 0n;
	offset = LR_strategy_condition_start_time();
	result = (
		// time & account
		(cond0 = (time < expiration_time & account == 0l))
		// Main condition - close crossed LR_high
		& (cond1 = (close[offset] #^ (LR_hh = ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[offset])))
		// close < resistance_line | support_slope > 0
		& (cond2 = (
			close[offset] < (LR_lh = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[offset])
		|
			(LR_sl = (ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[offset])) > 0n
		))
		// line_slope > slope_long_level
		& (cond3 = ((LR_sh = (ind("LinearRegression", "slope", "high", predict_window, high_offset, train_window)[-1c])) > slope_long_level))		
		& (cond4 = (
			//close[-1c] > close[-train_window] & ind("LinearRegression", "slope", "high", predict_window, high_offset, train_window)[-1c] > (LR_sh_o = (ind("LinearRegression", "slope", "high", predict_window, high_offset, train_window)[-train_window]))
			//|
			close[-1c] < close[-train_window] & ind("LinearRegression", "slope", "high", predict_window, high_offset, train_window)[-1c] < (LR_sh_o = (ind("LinearRegression", "slope", "high", predict_window, high_offset, train_window)[-train_window]))
		))
		// resistance_line - support_line > channel_width
		& (cond5 = ((LR_chan = (ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support) 
			- ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support))) > channel_width))
	);
	
	/*log("LR_strategy_long_condition;result=;" + result + ";offset=;" + offset 
		+ ";cond0=;" + cond0 
		+ ";cond1=;" + cond1 + ";close[offset]=;" + close[offset] + ";LR_hh=;" + LR_hh
		+ ";cond2=;" + cond2 + ";LR_lh=;" + LR_lh + ";LR_sl=;" + LR_sl
		+ ";cond3=;" + cond3 + ";LR_sh=;" + LR_sh
		+ ";cond4=;" + cond4 + ";close[-1c]=;" + close[-1c] + ";close[-train_window]=;" + close[-train_window] + ";LR_sh=;" + LR_sh + ";LR_sh_o=;" + LR_sh_o
		+ ";cond5=;" + cond5 + ";close[-1c]=;" + close[-1c] + ";LR_chan=;" + LR_chan + ";channel_width=;" + channel_width
		)*/
};

// A service method of LR_strategy_short family.
// Tests a condition for a short position
LR_strategy_short_condition() :=
{
	result = 0n;
	offset = LR_strategy_condition_start_time();
	result = (
		time < expiration_time & account == 0l
		& close[offset] #_ (LR = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[offset])
		& (
			close[offset] > (LR_sup = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[offset])
		|
			ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[offset] < 0n
		)
		& ind("LinearRegression", "slope", "low", predict_window, high_offset, train_window)[-1c] < slope_short_level
		& (
			close[-1c] > close[-train_window] & ind("LinearRegression", "slope", "high", predict_window, high_offset, train_window)[-1c] > ind("LinearRegression", "slope", "high", predict_window, high_offset, train_window)[-train_window]
			|
			close[-1c] < close[-train_window] & ind("LinearRegression", "slope", "high", predict_window, high_offset, train_window)[-1c] < ind("LinearRegression", "slope", "high", predict_window, high_offset, train_window)[-train_window]
		)
		& (ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support) 
			- ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)) > channel_width
	)
};
			
// +++ LR_strategy_SlopeLevel --- 7.04.2024 --------------------------------------------------------------------------------------------------------------------------------
// A service method of LR_strategy_SlopeLevel family.
// Opens a long position
LR_strategy_long_SlopeLevel(
	lots,				// Number of lots to open a position
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

	channel_width,	// Width of signal channel to disable trading
	
	day_start_time	// Start time of the day trading session
) :=
{
	long(lots) << LR_strategy_long_condition();
			
	nextSLlong_index = (find_min_price_index(train_window) - 1c);
	//nextSLlong = (low[nextSLlong_index] + 1p * (slope_long = slope_long_start) * (-nextSLlong_index / 1c));
	nextSLlong = ind("LinearRegression", "line", "low", "once", "low", candle.time[nextSLlong_index-1c], candle.time[-1c]);
	slope_long = ind("LinearRegression", "slope", "low", "once", "low", candle.time[nextSLlong_index-1c], candle.time[-1c]);
	log("long_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account 
		+ ";start_time=;" + candle.time[nextSLlong_index-1c] + ";start_low=;" + low[nextSLlong_index-1c] 
		+ ";nextSLlong_time=;" + candle.time[-1c] + ";nextSLlong=;" + nextSLlong + ";slope_long=;" + slope_long) << account > my_account;
	~
};

// A service method of LR_strategy_SlopeLevel family.
// Opens a short position
LR_strategy_short_SlopeLevel(
	lots,				// Number of lots to open a position
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

	channel_width,	// Width of signal channel to disable trading
	
	day_start_time	// Start time of the day trading session
) :=
{			
	short(lots) << LR_strategy_short_condition();
			
	nextSLshort_index = (find_max_price_index(train_window) - 1c);
	//nextSLshort = (high[nextSLshort_index] + 1p * (slope_short = slope_short_start) * (-nextSLshort_index / 1c));
	nextSLshort = ind("LinearRegression", "line", "high", "once", "high", candle.time[nextSLshort_index-1c], candle.time[-1c]);
	slope_short = ind("LinearRegression", "slope", "high", "once", "high", candle.time[nextSLshort_index-1c], candle.time[-1c]);
	log("short_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account 
		+ ";start_time=;" + candle.time[nextSLshort_index-1c] + ";start_high=;" + high[nextSLshort_index-1c] 
		+ ";nextSLshort_time=;" + candle.time[-1c] + ";nextSLshort=;" + nextSLshort + ";slope_short=;" + slope_short) << account < my_account;
	~
};

// Original LR strategy with managing a slope level.
// It opens a position only when the current slope is above or below a given slope level
LR_strategy_SlopeLevel(
	lots,				// Number of lots to open a position
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

	channel_width,	// Width of signal channel to disable trading
	
	day_start_time,	// Start time of the day trading session
	
	no_activity_periods
) :=
{
	log("LR_strategy_SlopeLevel_has_started_and_running...");
	log("LR_strategy_SlopeLevel_params=("); 
	log("    lots=;" + lots + ","); 
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
	log(")");
	
	nextSLlong = low;
	nextSLshort = high;
	slope_long = slope_long_start;
	slope_short = slope_short_start;

	{
		step = 0n; ..reporter(
					predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
					train_window,	// Signal line width of training window in candle number
					high_offset,	// Which type of price to take for the high line offset
					low_offset
					)
	||
		..{
			{
				nextSLlong = ind("LinearRegression", "low", "high", predict_window, low_offset, train_window)[-1c] << 
					ind("LinearRegression", "low", "high", predict_window, low_offset, train_window)[-1c] > nextSLlong
					& ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c] >= slope_long;
				
				slope_long = ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c];
			||
				nextSLlong += (1p * slope_long);
			};
					
			~
		&&
			{
				nextSLshort = ind("LinearRegression", "high", "low", predict_window, high_offset, train_window)[-1c] << 
					ind("LinearRegression", "high", "low", predict_window, high_offset, train_window)[-1c] < nextSLshort
					& ind("LinearRegression", "slope", "high", predict_window, low_offset, train_window)[-1c] <= slope_short;
				
				slope_short = ind("LinearRegression", "slope", "high", predict_window, low_offset, train_window)[-1c];
			||
				nextSLshort += (1p * slope_short);
			};
					
			~
		}
	||
		thread = "";
	
		..[time < expiration_time]
		{
			my_account = account;
			{
				LR_strategy_long_SlopeLevel(
					lots,				// Number of lots to open a position
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

					channel_width,	// Width of signal channel to disable trading
					
					day_start_time
				)
				
			||
				nextSLlong = find_min_price(train_window) << my_account > 0l;
				slope_long = slope_long_start;
				log("account_>_0l_already;pos.price_=;" + pos.price + ";account_=;" + account + ";nextSLlong=;" + nextSLlong + ";slope_long=;" + slope_long)
			||
				LR_strategy_short_SlopeLevel(
					lots,				// Number of lots to open a position
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

					channel_width,	// Width of signal channel to disable trading
					
					day_start_time
				)
				
			||
				nextSLshort = find_max_price(train_window) << my_account < 0l;
				slope_short = slope_short_start;
				log("account_<_0l_already;pos.price_=;" + pos.price + ";account_=;" + account + ";nextSLlong=;" + nextSLlong + ";slope_long=;" + slope_long)
			};
		
			{
				{
					log("looking_for_closing_long") << account > 0l;
					{
						{
						/*	stop() << time > 10:00 & account > 0l
								& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c])
							;
							log("long_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						||*/
							stop() << time > 07:00 & account > 0l
								& high[-1c] > (LRSL = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
								& !(ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[-1c] > 0n)
							;
							log("long_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						||
							stop() << time > 07:00 & account > 0l
								/*& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c])*/
								& close[-1c] < (LRSL = nextSLlong)
								//& ind("LinearRegression", "high", "high", predict_window, "none", train_window)[-1c]
								//	- ind("LinearRegression", "low", "low", predict_window, "none", train_window)[-1c] >= 2p
							;
							log("long_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						||
							no_activity = no_activity_periods << account > 0l;
							log("long_lr_NAS;started_watching;no_activity_periods=;" + no_activity);
							
							..[no_activity > 0c]
							{
								no_activity -= 1c << close[-1c] < (LRHH = (ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c]));
								log("long_lr_NAS;no_activity=;" + no_activity + ";close=;" + close + ";LRHH=;" + LRHH);
								~
							};
							
							stop();
							log("long_lr_NAS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age) << account == 0l
						}
					}
				||
					log("looking_for_closing_short") << account < 0l;
					{
					/*	stop() << time > 10:00 & account < 0l
							& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
						;
						log("short_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					||*/
						stop() << time > 07:00 & account < 0l
							& low[-1c] < (LRSL = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
							& !(ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[-1c] < 0n)
						;
						log("short_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					||
						stop() << time > 07:00 & account < 0l
							/*& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c])*/
							& close[-1c] > (LRSL = nextSLshort)
							//& ind("LinearRegression", "high", "high", predict_window, "none", train_window)[-1c]
							//	- ind("LinearRegression", "low", "low", predict_window, "none", train_window)[-1c] >= 2p
						;
						log("short_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					||
						no_activity = no_activity_periods << account < 0l;
						log("short_lr_NAS;started_watching;no_activity_periods=;" + no_activity);
							
						..[no_activity > 0c]
						{
							no_activity -= 1c << close[-1c] > (LRLL = (ind("LinearRegression", "low", "low", predict_window, high_offset, train_window)[-1c]));
							log("short_lr_NAS;no_activity=;" + no_activity + ";close=;" + close + ";LRLL=;" + LRLL);
							~
						};
							
						stop();
						log("short_lr_NAS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age) << account == 0l
					}
				}
			}
		}
	};

	log("LR_strategy_SlopeLevel_has_finished;" + "expiration_stop");

	stop();

	log("LR_strategy_SlopeLevel_has_finished;" + "script_stopped")
};
// --- LR_strategy_SlopeLevel --- 7.04.2024 --------------------------------------------------------------------------------------------------------------------------------

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

// A service method of LR_strategy_SlopeLevel_AdaptiveLots family.
// Opens a long position
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

	channel_width,	// Width of signal channel to disable trading
	
	day_start_time	// Start time of the day trading session
) :=
{
	lots = 0p << LR_strategy_long_condition();
	lots = CalculateLotsToLong(safety_stock, risk_L);
	log("long_lr_break_open_following;trying_to_open_long;lots=;" + lots);
	long(lots);
			
	nextSLlong_index = (find_min_price_index(train_window) - 1c);
	//nextSLlong = (low[nextSLlong_index] + 1p * (slope_long = slope_long_start) * (-nextSLlong_index / 1c));
	nextSLlong = ind("LinearRegression", "line", "low", "once", "low", candle.time[nextSLlong_index-1c], candle.time[-1c]);
	slope_long = ind("LinearRegression", "slope", "low", "once", "low", candle.time[nextSLlong_index-1c], candle.time[-1c]);
	log("long_lr_break_open_following;pos.price=;" + pos.price + ";account=;" + account + ";lots=;" + lots 
		+ ";start_time=;" + candle.time[nextSLlong_index-1c] + ";start_low=;" + low[nextSLlong_index-1c] 
		+ ";nextSLlong_time=;" + candle.time[-1c] + ";nextSLlong=;" + nextSLlong + ";slope_long=;" + slope_long) << account > my_account;
	~
};

// A service method of LR_strategy_SlopeLevel family.
// Opens a short position
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

	channel_width,	// Width of signal channel to disable trading
	
	day_start_time	// Start time of the day trading session
) :=
{			
	lots = 0p << LR_strategy_short_condition();
	lots = CalculateLotsToShort(safety_stock, risk_S);
	log("short_lr_break_open_following;trying_to_open_short;lots=;" + lots);
	short(lots);
			
	nextSLshort_index = (find_max_price_index(train_window) - 1c);
	//nextSLshort = (high[nextSLshort_index] + 1p * (slope_short = slope_short_start) * (-nextSLshort_index / 1c));
	nextSLshort = ind("LinearRegression", "line", "high", "once", "high", candle.time[nextSLshort_index-1c], candle.time[-1c]);
	slope_short = ind("LinearRegression", "slope", "high", "once", "high", candle.time[nextSLshort_index-1c], candle.time[-1c]);
	log("short_lr_break_open_following;pos.price=;" + ";account=;" + account + ";lots=;" + lots 
		+ ";start_time=;" + candle.time[nextSLshort_index-1c] + ";start_high=;" + high[nextSLshort_index-1c] 
		+ ";nextSLshort_time=;" + candle.time[-1c] + ";nextSLshort=;" + nextSLshort + ";slope_short=;" + slope_short) << account < my_account;
	~
};

// Original LR strategy with managing a slope level and calculating lots adaptively.
// It opens a position only when the current slope is above or below a given slope level
LR_strategy_SlopeLevel_AdaptiveLots(
	safety_stock,	// Safety stock in percents to the equity
	risk_L,		// Risk rate in percents for long positions
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

	channel_width,	// Width of signal channel to disable trading
	
	day_start_time	// Start time of the day trading session
) :=
{
	log("LR_strategy_SlopeLevel_AdaptiveLots_has_started_and_running...");
	log("LR_strategy_SlopeLevel_AdaptiveLots_params=("); 
	log("safety_stock=;" + safety_stock + ","); 
	log("risk_L=;" + risk_L + ","); 
	log("risk_S=;" + risk_S + ","); 
	log("expiration_time=;" + expiration_time + ",");
	log("day_start_time=;" + day_start_time + ",");
	log("predict_window=;" + predict_window + ","); 
	log("train_window=;" + train_window + ","); 
	log("high_offset=;" + high_offset + ","); 
	log("low_offset=;" + low_offset + ",");
	log("slope_long_start=;" + slope_long_start + ","); 
	log("slope_short_start=;" + slope_short_start + ","); 
	log("slope_long_level=;" + slope_long_level + ","); 
	log("slope_short_level=;" + slope_short_level + ",");
	log("predict_window_support=;" + predict_window_support + ","); 
	log("train_window_support=;" + train_window_support + ","); 
	log("predict_window_resistance=;" + predict_window_resistance + ","); 
	log("train_window_resistance=;" + train_window_resistance + ",");
	log("channel_width=;" + channel_width);
	log(")");
	
	nextSLlong = low;
	nextSLshort = high;
	slope_long = slope_long_start;
	slope_short = slope_short_start;

	{
		step = 0n; ..reporter(
					predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
					train_window,	// Signal line width of training window in candle number
					high_offset,	// Which type of price to take for the high line offset
					low_offset
					)
	||
		..{
			{
				nextSLlong = ind("LinearRegression", "low", "high", predict_window, low_offset, train_window)[-1c] << 
					ind("LinearRegression", "low", "high", predict_window, low_offset, train_window)[-1c] > nextSLlong
					& ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c] >= slope_long;
				
				slope_long = ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c];
			||
				nextSLlong += (1p * slope_long);
			};
					
			~
		&&
			{
				nextSLshort = ind("LinearRegression", "high", "low", predict_window, high_offset, train_window)[-1c] << 
					ind("LinearRegression", "high", "low", predict_window, high_offset, train_window)[-1c] < nextSLshort
					& ind("LinearRegression", "slope", "high", predict_window, low_offset, train_window)[-1c] <= slope_short;
				
				slope_short = ind("LinearRegression", "slope", "high", predict_window, low_offset, train_window)[-1c];
			||
				nextSLshort += (1p * slope_short);
			};
					
			~
		}
	||
		thread = "";
	
		..[time < expiration_time]
		{
			my_account = account;
			{
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

					channel_width,	// Width of signal channel to disable trading
					
					day_start_time
				)
				
			||
				nextSLlong = find_min_price(train_window) << my_account > 0l;
				slope_long = slope_long_start;
				log("account_>_0l_already;pos.price_=;" + pos.price + ";account_=;" + account + ";nextSLlong=;" + nextSLlong + ";slope_long=;" + slope_long)
			||
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

					channel_width,	// Width of signal channel to disable trading
					
					day_start_time
				)
				
			||
				nextSLshort = find_max_price(train_window) << my_account < 0l;
				slope_short = slope_short_start;
				log("account_<_0l_already;pos.price_=;" + pos.price + ";account_=;" + account + ";nextSLlong=;" + nextSLlong + ";slope_long=;" + slope_long)
			};
		
			{
				{
					log("looking_for_closing_long") << account > 0l;
					{
						{
						/*	stop() << time > 10:00 & account > 0l
								& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c])
							;
							log("long_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						||*/
							stop() << time > 07:00 & account > 0l
								& high[-1c] > (LRSL = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
								& !(ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[-1c] > 0n)
							;
							log("long_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						||
							stop() << time > 07:00 & account > 0l
								/*& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c])*/
								& close[-1c] < (LRSL = nextSLlong)
								//& ind("LinearRegression", "high", "high", predict_window, "none", train_window)[-1c]
								//	- ind("LinearRegression", "low", "low", predict_window, "none", train_window)[-1c] >= 2p
							;
							log("long_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						/*||
							stop() << time > 10:00 & account > 0l
							& close[-1c] < absoluteSL
							;
							log("long_lr_absoluteSL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";absoluteSL_=;" + absoluteSL) << account == 0l*/
						}
					}
				||
					log("looking_for_closing_short") << account < 0l;
					{
					/*	stop() << time > 10:00 & account < 0l
							& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
						;
						log("short_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					||*/
						stop() << time > 07:00 & account < 0l
							& low[-1c] < (LRSL = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
							& !(ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[-1c] < 0n)
						;
						log("short_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					||
						stop() << time > 07:00 & account < 0l
							/*& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c])*/
							& close[-1c] > (LRSL = nextSLshort)
							//& ind("LinearRegression", "high", "high", predict_window, "none", train_window)[-1c]
							//	- ind("LinearRegression", "low", "low", predict_window, "none", train_window)[-1c] >= 2p
						;
						log("short_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					/*||
						stop() << time > 10:00 & account > 0l
							& close[-1c] > absoluteSL
						;
						log("short_lr_absoluteSL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";absoluteSL_=;" + absoluteSL) << account == 0l*/
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

// The strategy watches fast and slow line crossing
LR_strategy2(
		lots,				// Number of lots to open a position
		expiration_time, 	// Time when to stop the strategy
	
		predict_window,	// Fast Signal line predict window type := ("week" || "day" || "candle")
		train_window,	// Fast Signal line width of training window in candle number
		high_offset,	// Which type of price to take for the fast high line offset
		low_offset,	// Which type of price to take for the fast low line offset

		slow_predict_window,	// Slow Signal line predict window type := ("week" || "day" || "candle")
		slow_train_window,	// Slow Signal line width of training window in candle number
		slow_high_offset,	// Which type of price to take for the slow high line offset
		slow_low_offset,	// Which type of price to take for the slow low line offset

		slope_long_start,	// Starting slope of linear regression for a long position
		slope_short_start,	// Starting slope of linear regression for a short position

		predict_window_support,	// Support line predict window type := ("week" || "day" || "candle")
		train_window_support,		// Support line width of training window in candle number
		predict_window_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
		train_window_resistance,	// Resistance line width of training window in candle number

		channel_width	// Width of signal channel to disable trading
		) :=
{
	nextSLlong = low;
	nextSLshort = high;
	slope_long = slope_long_start;
	slope_short = slope_short_start;

	{
		step = 0n; ..reporter(predict_window,	train_window, high_offset, low_offset)
	||
		..{
			{
				nextSLlong = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c] << 
					ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c] > nextSLlong
					& ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c] >= slope_long;
				
				slope_long = ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c];
			||
				nextSLlong += (1p * slope_long) << 
					!(ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c] > nextSLlong
					& ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c] >= slope_long)
			};
					
			~
		&&
			{
				nextSLshort = ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c] << 
					ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c] < nextSLshort
					& ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c] <= slope_short;
				
				slope_short = ind("LinearRegression", "slope", "high", predict_window, low_offset, train_window)[-1c];
			||
				nextSLshort += (1p * slope_short) << 
					!(ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c] < nextSLshort
					& ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c] <= slope_short)
			};
					
			~
		}
	||
		thread = "";
	
		..[time < expiration_time]
		{
			my_account = account;
			{
				long(lots) << time < expiration_time & account == 0l
					& close[-1c] #^ (LR = ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c])
					& (
						close[-1c] < (LR_sup = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
					|
						ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[-1c] > 0n
					)
					//& close[-1c] > (LR_sup = ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c])
					& (ind("LinearRegression", "high", "high", predict_window, high_offset, train_window) 
						- ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)) > channel_width
					& ind("LinearRegression", "high", "high", predict_window, high_offset, train_window) 
						> ind("LinearRegression", "high", "high", slow_predict_window, slow_high_offset, slow_train_window)
				;
				nextSLlong = find_min_price(train_window);
				slope_long = slope_long_start;
				log("long_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account + ";LR_=;" + LR + ";nextSLlong=;" + nextSLlong) << account > my_account;
				~
			||
				log("account_>_0l_already") << my_account > 0l
			||
				short(lots) << time < expiration_time & account == 0l
					& close[-1c] #_ (LR = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c])
					//& close[-1c] < (LR_sup = ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
					& (
						close[-1c] > (LR_sup = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
					|
						ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[-1c] < 0n
					)
					& (ind("LinearRegression", "high", "high", predict_window, high_offset, train_window) 
						- ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)) > channel_width
					& ind("LinearRegression", "low", "low", predict_window, high_offset, train_window) 
						< ind("LinearRegression", "low", "low", slow_predict_window, slow_high_offset, slow_train_window)
				;
				nextSLshort = find_max_price(train_window);
				slope_short = slope_short_start;
				log("short_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account + ";LR_=;" + LR + ";nextSLshort=;" + nextSLshort) << account < my_account;
				~
			||
				log("account_<_0l_already") << my_account < 0l
			};
		
			{
				{
					log("looking_for_closing_long") << account > 0l;
					{
						{
						/*	stop() << time > 10:00 & account > 0l
								& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c])
							;
							log("long_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						||*/
							stop() << time > 07:00 & account > 0l
								& high[-1c] > (LRSL = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
								& !(ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[-1c] > 0n)
							;
							log("long_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						||
							stop() << time > 07:00 & account > 0l
								/*& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c])*/
								& close[-1c] < (LRSL = nextSLlong)
								//& ind("LinearRegression", "high", "high", predict_window, "none", train_window)[-1c]
								//	- ind("LinearRegression", "low", "low", predict_window, "none", train_window)[-1c] >= 2p
							;
							log("long_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						/*||
							stop() << time > 10:00 & account > 0l
							& close[-1c] < absoluteSL
							;
							log("long_lr_absoluteSL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";absoluteSL_=;" + absoluteSL) << account == 0l*/
						}
					}
				||
					log("looking_for_closing_short") << account < 0l;
					{
					/*	stop() << time > 10:00 & account < 0l
							& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
						;
						log("short_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					||*/
						stop() << time > 07:00 & account < 0l
							& low[-1c] < (LRSL = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
							& !(ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[-1c] < 0n)
						;
						log("short_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					||
						stop() << time > 07:00 & account < 0l
							/*& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c])*/
							& close[-1c] > (LRSL = nextSLshort)
							//& ind("LinearRegression", "high", "high", predict_window, "none", train_window)[-1c]
							//	- ind("LinearRegression", "low", "low", predict_window, "none", train_window)[-1c] >= 2p
						;
						log("short_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					/*||
						stop() << time > 10:00 & account > 0l
							& close[-1c] > absoluteSL
						;
						log("short_lr_absoluteSL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";absoluteSL_=;" + absoluteSL) << account == 0l*/
					}
				}
			}
		}
	};
	
	log("expiration_stop");

	stop();

	log("LR_strategy2_has_stopped")
};

