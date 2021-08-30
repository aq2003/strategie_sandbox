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

falls_total = 4n;
falls = 1n;

c1_period = 24c;
c2_period = 144c;
ema_period = 48c;

lib_path = "C:\Users\Admin\Documents\GitHub\libs_sandbox\Libs Sandbox\";
import(lib_path + "trade_lib.aql");

p_lbreak_train_window_resistance = 330c;
p_lbreak_train_window_TP = 1320c;
p_lbounce_train_window_support = 330c;
p_lbounce_train_window_TP = 330c;
p_sbreak_train_window_support = 330c;
p_sbreak_train_window_TP = 1320c;
p_sbounce_train_window_resistance = 330c;
p_sbounce_train_window_TP = 330c;

reporter(start_time, end_time) := 
{
	//step = step;
	a = 1n;
	log("step_=;" + step 
		+ ";account_=;" + account 
		+ ";lbreak_=;" + ind("LinearRegression", "high", "high", "day", "high", p_lbreak_train_window_resistance)[09:45] 
		+ ";lbounce_=;" + ind("LinearRegression", "high", "low", "day", "low", p_lbounce_train_window_support)[09:45]
		+ ";sbreak_=;" + ind("LinearRegression", "low", "low", "day", "low", p_sbreak_train_window_support)[09:45]
		+ ";sbounce_=;" + (ind("LinearRegression", "low", "high", "day", "high", p_sbounce_train_window_resistance)[09:45])[-57c]
	);
	step += 1n; 
	~
};

{
	step = 0n; ..reporter(10:00_20.11.20, 23:30_24.11.20)
||
	lots_to_open = 30l;
	expiration_time = 15:00_17.06.21;
	thread = "";
	
	..[time < expiration_time]
	{
		predict_window_resistance = "day"; 
		train_window_resistance = p_lbreak_train_window_resistance;
		
		predict_window_TP = predict_window_resistance;
		train_window_TP = p_lbreak_train_window_TP;
		predict_window_SL = predict_window_resistance;
		train_window_SL = train_window_resistance;
		
		line_TP = "high";
		line_SL = "low";
		
		my_account = account;
		{
			long_lr_break_open_following(predict_window_resistance, train_window_resistance, lots_to_open, expiration_time) 
				<< my_account == 0l & time >= 07:00;
			thread = "long_lr_break_open_following";
			~
		||
			log("account_>_0l_already") << my_account > 0l
		};
		
		long_lr_stop_following(predict_window_TP, train_window_TP, line_TP, predict_window_SL, train_window_SL, line_SL) 
			<< thread == "long_lr_break_open_following";
		thread = ""
	||	
		predict_window_support = "day"; 
		train_window_support = p_lbounce_train_window_support;
		
		predict_window_TP = predict_window_support;
		train_window_TP = p_lbounce_train_window_TP;
		predict_window_SL = predict_window_support;
		train_window_SL = train_window_support;
		
		line_TP = "high";
		line_SL = "low";
		
		my_account = account;
		{
			long_lr_bounce_open_following(predict_window_support, train_window_support, lots_to_open, expiration_time) 
				<< my_account == 0l & time >= 07:00;
			~;
			thread = "long_lr_bounce_open_following";
		||
			log("account_>_0l_already") << my_account > 0l
		};
		
		long_lr_stop_following(predict_window_TP, train_window_TP, line_TP, predict_window_SL, train_window_SL, line_SL) 
			<< thread == "long_lr_bounce_open_following";
		thread = ""
	||	
		predict_window_support = "day"; 
		train_window_support = p_sbreak_train_window_support;
		
		predict_window_TP = predict_window_support;
		train_window_TP = p_sbreak_train_window_TP;
		predict_window_SL = predict_window_support;
		train_window_SL = train_window_support;
		
		line_TP = "low";
		line_SL = "high";
		
		my_account = account;
		{
			short_lr_break_open_following(predict_window_support, train_window_support, lots_to_open, expiration_time) 
				<< my_account == 0l & time >= 07:00;
			thread = "short_lr_break_open_following";
			~
		||
			log("account_<_0l_already") << my_account < 0l
		};
		
		short_lr_stop_following(predict_window_TP, train_window_TP, line_TP, predict_window_SL, train_window_SL, line_SL) 
			<< thread == "short_lr_break_open_following";
		thread = ""
	||
		predict_window_resistance = "day"; 
		train_window_resistance = p_sbounce_train_window_resistance;
		
		predict_window_TP = predict_window_resistance;
		train_window_TP = p_sbounce_train_window_TP;
		predict_window_SL = predict_window_resistance;
		train_window_SL = train_window_resistance;
		
		line_TP = "low";
		line_SL = "high";
		
		my_account = account;
		{
			short_lr_bounce_open_following(predict_window_resistance, train_window_resistance, lots_to_open, expiration_time) 
				<< my_account == 0l & time >= 07:00;
			thread = "short_lr_bounce_open_following";
			~
		||
			log("account_<_0l_already") << my_account < 0l
		};
		
		short_lr_stop_following(predict_window_TP, train_window_TP, line_TP, predict_window_SL, train_window_SL, line_SL) 
			<< thread == "short_lr_bounce_open_following";
		thread = ""
	}
};

log("expiration_stop");

stop();

log("script_stopped")
