// 30.10.2021 21:07:03 GMKN_900_LR ql script
// Created 30.10.2021 21:07:03

// 28.09.2021 8:30:27 GAZP_900_LR ql script
// Created 28.09.2021 8:30:27

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

// +++ parameters -----------------------------------------------------------------------------------------
lots = 100000p;
expiration_time = 23:00_31.12.21;
	
predict_window = "day"; 
train_window = 65c;
high_offset = "high";
low_offset = "low";

predict_window_support = "week";
train_window_support = 684c;
predict_window_resistance = "week";
train_window_resistance = 684c;

channel_width = 100p;
// --- parameters -----------------------------------------------------------------------------------------
		
//lib_path = "C:\Users\Admin\Documents\GitHub\libs_sandbox\Libs Sandbox\";
//import(lib_path + "trade_lib.aql");

reporter(start_time, end_time) := 
{
	//step = step;
	a = 1n;
	log("step_=;" + step 
		+ ";account_=;" + account 
		+ ";equity_=;" + equity 
		+ ";lhigh_=;" + ind("LinearRegression", "line", "high", predict_window_resistance, "high", train_window_resistance) 
		+ ";lhigh.high_=;" + ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance) 
		+ ";lhigh.low_=;" + ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance) 
		+ ";llow_=;" + ind("LinearRegression", "line", "low", predict_window_support, "low", train_window_support)
		+ ";llow.high_=;" + ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)
		+ ";llow.low_=;" + ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)
	);
	step += 1n; 
	~
};

{
	step = 0n; ..reporter(10:00_20.11.20, 23:30_24.11.20)
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
					& ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support) 
						<= ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c]
				|
					ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support) 
						> ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c]
				)
				& close[-1c] > (LR_sup = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
				& (ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support) 
					- ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)) > channel_width
			;
			log("long_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account + ";LR_=;" + LR + ";LR_sup_=;" + LR_sup) << account > my_account;
			~
		||
			log("account_>_0l_already") << my_account > 0l
		||
			short(lots) << time < expiration_time & account == 0l
				& close[-1c] #_ (LR = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c])
				& close[-1c] < (LR_sup = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
				& (
					close[-1c] > (LR_sup = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
					& ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance) 
						>= ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c]
				|
					ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance) 
						< ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c]
				)
				& (ind("LinearRegression", "low", "high", predict_window_support, "high", train_window_support) 
					- ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)) > channel_width
			;
			log("short_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account + ";LR_=;" + LR) << account < my_account;
			~
		||
			log("account_<_0l_already") << my_account < 0l
		};
		
		{
			log("looking_for_closing_long") << account > 0l;
			{
				stop() << time > 10:00 & account > 0l
					& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c])
				;
				log("long_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
			||
				stop() << time > 10:00 & account > 0l
					& high[-1c] > (LRSL = ind("LinearRegression", "low", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
					& !(ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support) 
						> ind("LinearRegression", "low", "low", predict_window_support, "low", train_window_support)[-1c])
				;
				log("long_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
			||
				stop() << time > 10:00 & account > 0l
					& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c])
					//& ind("LinearRegression", "high", "high", predict_window, "none", train_window)[-1c]
					//	- ind("LinearRegression", "low", "low", predict_window, "none", train_window)[-1c] >= 2p
				;
				log("long_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
			}
		||
			log("looking_for_closing_short") << account < 0l;
			{
				stop() << time > 10:00 & account < 0l
					& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
				;
				log("short_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
			||
				stop() << time > 10:00 & account < 0l
					& low[-1c] < (LRSL = ind("LinearRegression", "high", "low", predict_window_support, "low", train_window_support)[-1c])
					& !(ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance) 
						< ind("LinearRegression", "high", "high", predict_window_resistance, "high", train_window_resistance)[-1c])
				;
				log("short_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
			||
				stop() << time > 10:00 & account < 0l
					& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", predict_window, high_offset, train_window)[-1c])
					//& ind("LinearRegression", "high", "high", predict_window, "none", train_window)[-1c]
					//	- ind("LinearRegression", "low", "low", predict_window, "none", train_window)[-1c] >= 2p
				;
				log("short_lr_TS;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
			}
		}
	}
};

log("expiration_stop");

stop();

log("script_stopped")
