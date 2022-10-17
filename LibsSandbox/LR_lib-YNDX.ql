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

reporter(start_time, end_time) := 
{
	//step = step;
	a = 1n;
	log("step_=;" + step 
		+ ";account_=;" + account 
		+ ";equity_=;" + equity 
		+ ";lhigh_=;" + ind("LinearRegression", "line", "high", predict_window, "high", train_window) 
		+ ";lhigh.high_=;" + ind("LinearRegression", "high", "high", predict_window, "high", train_window) 
		+ ";lhigh.low_=;" + ind("LinearRegression", "low", "high", predict_window, "high", train_window) 
		+ ";llow_=;" + ind("LinearRegression", "line", "low", predict_window, "low", train_window)
		+ ";llow.high_=;" + ind("LinearRegression", "high", "low", predict_window, "low", train_window)
		+ ";llow.low_=;" + ind("LinearRegression", "low", "low", predict_window, "low", train_window)
		+ ";llow.slope_=;" + ind("LinearRegression", "slope", "low", predict_window, "low", train_window)
		+ ";llow.mae_=;" + ind("LinearRegression", "mae", "low", predict_window, "low", train_window)
		+ ";nextSLlong_=;" + nextSLlong + ";slope_long_=;" + slope_long
		+ ";nextSLshort_=;" + nextSLshort + ";slope_short_=;" + slope_short
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
		step = 0n; ..reporter(10:00_20.11.20, 23:30_24.11.20)
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
					& close[-1c] #_ (LR = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c])
					//& close[-1c] < (LR_sup = ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
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

	log("LR_strategy_has_stopped")
};

