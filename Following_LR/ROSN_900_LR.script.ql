// 06.10.2021 16:27:55 ROSN_900_LR ql script
// Created 06.10.2021 16:27:55

// 28.09.2021 8:30:27 GAZP_900_LR ql script
// Created 28.09.2021 8:30:27

// +++ parameters -----------------------------------------------------------------------------------------
lots = 10l;
expiration_time = 23:00_31.12.21;
	
predict_window = "day"; 
train_window = 130c;
high_offset = "high";
low_offset = "low";

start_time_support = 10:00_18.08.21;
end_time_support = 23:00_02.09.21;
start_time_resistance = 10:00_18.08.21;
end_time_resistance = 23:00_02.09.21;
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
		+ ";lhigh_=;" + ind("LinearRegression", "high", "high", predict_window, high_offset, train_window) 
		+ ";lhigh.high_=;" + ind("LinearRegression", "high", "high", predict_window, high_offset, train_window) 
		+ ";lhigh.low_=;" + ind("LinearRegression", "high", "high", predict_window, high_offset, train_window) 
		+ ";llow_=;" + ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)
		+ ";llow.high_=;" + ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)
		+ ";llow.low_=;" + ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)
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
				//& close[-1c] < (LR_sup = ind("LinearRegression", "low", "high", "once", "high", start_time_resistance, end_time_resistance)[-1c])
				& close[-1c] > (LR_sup = ind("LinearRegression", "low", "low", "once", "low", start_time_support, end_time_support)[-1c])
				//& (LR_sup = ind("LinearRegression", "low", "low", "once", "low", start_time_support, end_time_support)) 
				//	> (LR_sup = (ind("LinearRegression", "low", "low", "once", "low", start_time_support, end_time_support)[-1c]))
				//& ind("LinearRegression", "high", "high", predict_window, "none", train_window)[-1c]
				//	- ind("LinearRegression", "low", "low", predict_window, "none", train_window)[-1c] >= 2p
			;
			log("long_lr_break_open_following;pos.price_=;" + pos.price + ";account_=;" + account + ";LR_=;" + LR) << account > my_account;
			~
		||
			log("account_>_0l_already") << my_account > 0l
		||
			short(lots) << time < expiration_time & account == 0l
				& close[-1c] #_ (LR = ind("LinearRegression", "low", "low", predict_window, low_offset, train_window)[-1c])
				& close[-1c] < (LR_sup = ind("LinearRegression", "high", "high", "once", "high", start_time_resistance, end_time_resistance)[-1c])
				& close[-1c] > (LR_sup = ind("LinearRegression", "high", "low", "once", "low", start_time_support, end_time_support)[-1c])
				//& (LR_sup = ind("LinearRegression", "high", "high", "once", "high", start_time_resistance, end_time_resistance)) 
				//	< (LR_sup = (ind("LinearRegression", "high", "high", "once", "high", start_time_resistance, end_time_resistance)[-1c]))
				//& ind("LinearRegression", "high", "high", predict_window, "none", train_window)[-1c]
				//	- ind("LinearRegression", "low", "low", predict_window, "none", train_window)[-1c] >= 2p
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
					& close[-1c] < (LRSL = ind("LinearRegression", "low", "low", "once", "low", start_time_support, end_time_support)[-1c])
				;
				log("long_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
			/*||
				stop() << time > 10:00 & account > 0l
					& high[-1c] > (LRSL = ind("LinearRegression", "low", "high", "once", "high", start_time_resistance, end_time_resistance)[-1c])
				;
				log("long_lr_TP;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l*/
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
					& close[-1c] > (LRSL = ind("LinearRegression", "high", "high", "once", "high", start_time_resistance, end_time_resistance)[-1c])
				;
				log("short_lr_SL;pos.abs_profit_=;" + pos.abs_profit + ";pos.age_=;" + pos.age + ";LRSL_=;" + LRSL) << account == 0l
			||
				stop() << time > 10:00 & account < 0l
					& low[-1c] < (LRSL = ind("LinearRegression", "high", "low", "once", "low", start_time_support, end_time_support)[-1c])
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
