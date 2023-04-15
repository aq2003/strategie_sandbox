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

// A special reporter for adaptive MAE strategy
reporter_adaptive_MAE(step,
		predict_window_type,	// Signal line predict window type := ("week" || "day" || "candle")
		train_window,	// Signal line width of training window in candle number
		high_offset,	// Which type of price to take for the high line offset
		low_offset		// Which type of price to take for the low line offset
		) := 
{
	//step = step;
	a = 1n;
	
	line_high = ind("LinearRegression", "line", "high", predict_window_type, high_offset, train_window);
	slope_high = ind("LinearRegression", "slope", "high", predict_window_type, high_offset, train_window);
	mae_high = (ind("LinearRegression", "mae", "high", predict_window_type, high_offset, train_window) / abs(slope_high));
	high_high = (line_high + mae_high);
	low_high = (line_high - mae_high);
	
	line_low = ind("LinearRegression", "line", "high", predict_window_type, high_offset, train_window);
	slope_low = ind("LinearRegression", "slope", "high", predict_window_type, high_offset, train_window);
	mae_low = (ind("LinearRegression", "mae", "high", predict_window_type, high_offset, train_window) / abs(slope_low));
	high_low = (line_low + mae_low);
	low_low = (line_low - mae_low);
	
	log("step_=;" + step 
		+ ";account_=;" + account 
		+ ";equity_=;" + equity 
		+ ";line_high=;" + line_high 
		+ ";high_high=;" + high_high 
		+ ";low_high=;" + low_high 
		+ ";slope_high=;" + slope_high 
		+ ";mae_high=;" + mae_high 
		+ ";line_low=;" + line_low
		+ ";high_low=;" + high_low
		+ ";low_low=;" + low_low
		+ ";slope_low=;" + slope_low
		+ ";mae_low=;" + mae_low
		+ ";nextSLlong_=;" + nextSLlong + ";slope_long_=;" + slope_long
		+ ";nextSLshort_=;" + nextSLshort + ";slope_short_=;" + slope_short
		+ ";train_window_=;" + train_window
		+ ";channel_width_=;" + (high_high - low_low)
	);
	step += 1n; 
	~
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

// Moves time bounds which define when the script trading starts and is over
MovingTimeBounds(
			start_time,	// Time of a day when the script trading gets allowed
			end_time,		// Time of a day when the script trading gets not allowed
			day_start_time	// Time of a day when the stock exchange starts
			) :=
{
	result = 0n;
	
	..{
		log("time_watch_started" + ";start_time=;" + start_time + ";end_time=;" + end_time + ";day_start_time=;" + day_start_time);
		start_time += 1D << time > end_time;
		end_time += 1D;
		day_start_time += 1D;
		log("time_moved" + ";start_time=;" + start_time + ";end_time=;" + end_time + ";day_start_time=;" + day_start_time)
	}
};
	
// Original LR strategy
LR_strategy(
		lots,				// Number of lots to open a position
		expiration_time, 	// Time when to stop the strategy
		start_time,	// Time of a day when the script trading gets allowed
		end_time,		// Time of a day when the script trading gets not allowed
		day_start_time,	// Time of a day when the stock exchange starts
	
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
				nextSLlong = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c] << 
					ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c] > nextSLlong
					& ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c] >= slope_long;
				
				slope_long = ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c];
			||
				nextSLlong += (1p * slope_long);
			};
					
			~
		&&
			{
				nextSLshort = ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c] << 
					ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c] < nextSLshort
					& ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c] <= slope_short;
				
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
				long(lots) << time >= day_start_time & time >= start_time & time < end_time & time < expiration_time & account == 0l
					& close[-1c] #^ (LR = ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c])
					& (
						close[-1c] < (LR_sup = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
						|
						ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[-1c] > 0n
					)
					& (ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support) 
						- ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)) > channel_width
				;
				nextSLlong = find_min_price(train_window);
				slope_long = slope_long_start;
				log("long_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account + ";LR_=;" + LR + ";nextSLlong=;" + nextSLlong) << account > my_account;
				~
			||
				log("account_>_0l_already") << my_account > 0l
			||
				short(lots) << time >= day_start_time & time >= start_time & time < end_time & time < expiration_time & account == 0l
					& close[-1c] #_ (LR = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c])
					& (
						close[-1c] > (LR_sup = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
						|
						ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[-1c] < 0n
					)
					& (ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support) 
						- ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)) > channel_width
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
							stop() << time > day_start_time & account > 0l
								& high[-1c] > (LRSL = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
								& !(ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[-1c] > 0n)
							;
							log("long_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						||
							stop() << time > day_start_time & account > 0l
								& close[-1c] < (LRSL = nextSLlong)
							;
							log("long_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
						}
					}
				||
					log("looking_for_closing_short") << account < 0l;
					{
						stop() << time > day_start_time & account < 0l
							& low[-1c] < (LRSL = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
							& !(ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[-1c] < 0n)
						;
						log("short_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					||
						stop() << time > day_start_time & account < 0l
							& close[-1c] > (LRSL = nextSLshort)
						;
						log("short_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
					}
				}
			}
		}
	};

	log("expiration_stop");

	stop();

	log("script_stopped")
	
||
	MovingTimeBounds(start_time, end_time, day_start_time)
};

// An LR strategy which tunes MAE adaptively depending on slope value
LR_strategy_w_adaptive_MAE(
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
	
	high_adaptive_MAE = 0p;
	low_adaptive_MAE = 0p;

	{
		step = 0n; ..reporter_adaptive_MAE(step,
					predict_window,	// Signal line predict window type := ("week" || "day" || "candle")
					train_window,	// Signal line width of training window in candle number
					high_offset,	// Which type of price to take for the high line offset
					low_offset)
	||
		..{
			{
				nextSLlong = (ind("LinearRegression", "line", "low", predict_window, low_offset, train_window)[-1c] - low_adaptive_MAE) << 
					ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c] > nextSLlong
					& ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c] >= slope_long;
				
				slope_long = ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c];
			||
				nextSLlong += (1p * slope_long);
			};
			
			high_adaptive_MAE = (ind("LinearRegression", "mae", "high", predict_window, low_offset, train_window)[-1c] /
							abs(ind("LinearRegression", "slope", "high", predict_window, low_offset, train_window)[-1c]));
					
			~
		&&
			{
				nextSLshort = (ind("LinearRegression", "line", "high", predict_window, high_offset, train_window)[-1c] + high_adaptive_MAE) << 
					ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c] < nextSLshort
					& ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c] <= slope_short;
				
				slope_short = ind("LinearRegression", "slope", "high", predict_window, low_offset, train_window)[-1c];
			||
				nextSLshort += (1p * slope_short);
			};
					
			low_adaptive_MAE = (ind("LinearRegression", "mae", "low", predict_window, low_offset, train_window)[-1c] /
							abs(ind("LinearRegression", "slope", "low", predict_window, low_offset, train_window)[-1c]));
					
			~
		}
	||
		thread = "";
	
		..[time < expiration_time]
		{
			my_account = account;
			{
				long(lots) << time < expiration_time & account == 0l
					& close[-1c] #^ 
						(LR = (ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c] + high_adaptive_MAE))
					& (
						close[-1c] < (LR_sup = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
						|
						ind("LinearRegression", "slope", "low", predict_window_support, "low", train_window_support)[-1c] > 0n
					)
					//& close[-1c] > (LR_sup = ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c])
					& (ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support) 
						- ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)) > channel_width
				;
				nextSLlong = find_min_price(train_window);
				slope_long = slope_long_start;
				log("long_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account + ";LR_=;" + LR + ";nextSLlong=;" + nextSLlong) << account > my_account;
				~
			||
				log("account_>_0l_already") << my_account > 0l
			||
				short(lots) << time < expiration_time & account == 0l
					& close[-1c] #_ 
						(LR = (ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c] - low_adaptive_MAE))
					& (
						close[-1c] > (LR_sup = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
						|
						ind("LinearRegression", "slope", "high", predict_window_resistance, "high", train_window_resistance)[-1c] < 0n
					)
					//& close[-1c] < (LR_sup = ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
					& (ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support) 
						- ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)) > channel_width
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

	log("LR_strategy_script_stopped")
};

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

