// 25.11.2023 15:54:20 Test_MNZ3_3600_LR1 ql script
// Created 25.11.2023 15:54:20

// 25.11.2023 10:50:28 Test_MNZ3_900_LR ql script
// Created 25.11.2023 10:50:28

// 07.10.2023 19:33:19 Test_GZZ3_900_LR ql script
// Created 07.10.2023 19:33:19

// 13.01.2023 8:16:03 Test_GZH3_900_LR ql script
// Created 13.01.2023 8:16:03

// 05.06.2022 9:41:44 Test_MLM2_900_LR ql script
// Created 05.06.2022 9:41:44

// 21.05.2022 11:06:55 Test_SIM2_900_LR ql script
// Created 21.05.2022 11:06:55

// 14.05.2022 15:42:52 Test_SRM2_900_LR ql script
// Created 14.05.2022 15:42:52

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

// +++ 09.12.2023 - Test_LR_strategy_SlopeLevel --------------------------------------------------------------------------------------
Test_LR_strategy_SlopeLevel_AdaptiveLots(
	safety_stock,	// Safety stock in percents to the equity
	risk_L,		// Risk rate in percents for long positions
	risk_S,		// Risk rate in percents for short positions
	expiration_time, // = 15:00_15.12.23;
	
	predict_window, // = "candle"; 
	high_offset, // = "none";
	low_offset, // = "none";
	train_window_start, // = 25c;
	train_window_stop, // = 300c;
	train_window_step, // = 20%;

	slope_long_start, // = 0n;
	slope_long_stop, // = 20n;
	slope_long_step, // = 2n;
	slope_short_start, // = 0n;
	slope_short_stop, // = 20n;
	slope_short_step, // = 2n;

	slope_long_level_start, // = -10n;
	slope_long_level_stop, // = 0n;
	slope_long_level_step, // = 1n;
	slope_short_level_start, // = 10n;
	slope_short_level_stop, // = 0n;
	slope_short_level_step, // = -1n;

	predict_window_support, // = "week";
	predict_window_resistance, // = "week";
	train_window_support_start, // = 300c;
	train_window_support_stop, // = 2000c;
	train_window_support_step, // = 20%;
	train_window_resistance_start, // = 300c;
	train_window_resistance_stop, // = 2000c;
	train_window_resistance_step, // = 20%;

	channel_width_start, // = 0p;
	channel_width_stop, // = 300p;
	channel_width_step, // = 50p;

	no_activity_start, // = 0c;
	no_activity_stop, // = 20c;
	no_activity_step, // = 1c;
	
	day_start_time,	// Start time of the day trading session
	day_end_time,	// End time of the day trading session
	night_start_time,	// Start time of the night trading session
	night_end_time,	// End time of the night trading session
	
	target_type, // target_type := ("best_equity", "equity_closest_to_max_equity")
	
	base_log_level  // "Error"
) :=
{
	log("Test_LR_strategy_SlopeLevel_AdaptiveLots_started");
	
	LR_strategy_SlopeLevel_library = "%QTrader_Libs%\LR_strategy_SlopeLevel_AdaptiveLots (2).aql";

	import(LR_strategy_SlopeLevel_library);

	
	// +++ parameters -----------------------------------------------------------------------------------------
	log("    safety_stock=;" + safety_stock + ","); 
	log("    risk_L=;" + risk_L + ","); 
	log("    risk_S=;" + risk_S + ","); 
	log("    expiration_time=;" + expiration_time);
	log("    day_start_time=;" + day_start_time);
	log("    predict_window=;" + predict_window);
	log("    high_offset=;" + high_offset);
	log("    train_window_start=;" + train_window_start);
	log("    train_window_stop=;" + train_window_stop);
	log("    train_window_step=;" + train_window_step);

	log("    slope_long_start=;" + slope_long_start);
	log("    slope_long_stop=;" + slope_long_stop);
	log("    slope_long_step=;" + slope_long_step);
	log("    slope_short_start=;" + slope_short_start);
	log("    slope_short_stop=;" + slope_short_stop);
	log("    slope_short_step=;" + slope_short_step);

	log("    slope_long_level_start=;" + slope_long_level_start);
	log("    slope_long_level_stop=;" + slope_long_level_stop);
	log("    slope_long_level_step=;" + slope_long_level_step);
	log("    slope_short_level_start=;" + slope_short_level_start);
	log("    slope_short_level_stop=;" + slope_short_level_stop);
	log("    slope_short_level_step=;" + slope_short_level_step);

	log("    predict_window_support=;" + predict_window_support);
	log("    predict_window_resistance=;" + predict_window_resistance);
	log("    train_window_support_start=;" + train_window_support_start);
	log("    train_window_support_stop=;" + train_window_support_stop);
	log("    train_window_support_step=;" + train_window_support_step);
	log("    train_window_resistance_start=;" + train_window_resistance_start);
	log("    train_window_resistance_stop=;" + train_window_resistance_stop);
	log("    train_window_resistance_step=;" + train_window_resistance_step);
	log("    channel_width_start=;" + channel_width_start);
	log("    channel_width_stop=;" + channel_width_stop);
	log("    channel_width_step=;" + channel_width_step);
	log("    no_activity_start=;" + no_activity_start);
	log("    no_activity_stop=;" + no_activity_stop);
	log("    no_activity_step=;" + no_activity_step);
	
	log("    target_type=;" + target_type);
	
	// +++ Checking parameter steps and calculating count of turns	
	// +++ Checking parameter steps and calculating count of turns - count4
	count4 = 0i;
	{
		no_activity_stop / no_activity_step << no_activity_step == 0c;
		log("parameter_step_<no_activity_step>_cannot_be_zero");
	||
		no_activity_step = no_activity_step << no_activity_step != 0c
	};
	my_no_activity = no_activity_start;
	..[my_no_activity <= no_activity_stop] 
	{
		my_no_activity += no_activity_step;
		count4 += 1i
	};
	// --- Checking parameter steps and calculating count of turns - count3
	
	// +++ Checking parameter steps and calculating count of turns - count3
	count3 = 0i;
	{
		slope_long_level_stop / slope_long_level_step << slope_long_level_step == 0n;
		log("parameter_step_<slope_long_level_step>_cannot_be_zero");
	||
		slope_long_level_step = slope_long_level_step << slope_long_level_step != 0n
	};
	my_slope_long_level = slope_long_level_start;
	..[my_slope_long_level <= slope_long_level_stop] 
	{
		my_slope_long_level += slope_long_level_step;
		count3 += 1i
	};
	// --- Checking parameter steps and calculating count of turns - count3
	
	// +++ Checking parameter steps and calculating count of turns - count2
	count2 = 0i;
	{
		slope_short_level_stop / slope_short_level_step << slope_short_level_step == 0n;
		log("parameter_step_<slope_short_level_step>_cannot_be_zero");
	||
		slope_short_level_step = slope_short_level_step << slope_short_level_step != 0n
	};
	my_slope_short_level = slope_short_level_start;
	..[my_slope_short_level <= slope_short_level_stop] 
	{
		my_slope_short_level += slope_short_level_step;
		count2 += 1i
	};
	// --- Checking parameter steps and calculating count of turns - count2
	
	// +++ Checking parameter steps and calculating count of turns - count1
	count1 = 0i;
	{
		train_window_support_stop / train_window_support_step << train_window_support_step == 0%;
		log("parameter_step_<train_window_support_step>_cannot_be_zero");
	||
		train_window_support_step = train_window_support_step << train_window_support_step != 0%
	};
	my_train_window_support = train_window_support_start;
	..[my_train_window_support <= train_window_support_stop] 
	{
		my_train_window_support += train_window_support_step;
		count1 += 1i
	};
	// --- Checking parameter steps and calculating count of turns - count1
	
	// +++ Checking parameter steps and calculating count of turns - count
	count = 0i;
	{
		train_window_stop / train_window_step << train_window_step == 0%;
		log("parameter_step_<train_window_step>_cannot_be_zero");
	||
		train_window_step = train_window_step << train_window_step != 0%
	};
	my_train_window = train_window_start;
	..[my_train_window <= train_window_stop] 
	{
		my_train_window += train_window_step;
		count += 1i
	};
	// --- Checking parameter steps and calculating count of turns - count
	total_count = (count * (count4 / 1i) * (count3 / 1i) * (count2 / 1i) * (count1 / 1i));
	log("there_are_" + count4 + "_*_" + count3 + "_*_" + count2 + "_*_" + count1 + "_*_" + count + "_=_" + total_count + "_turns_ongoing");
	// --- Checking parameter steps and calculating count of turns		
	// --- parameters -----------------------------------------------------------------------------------------
		
	target = 0p;
	{
		target = 0p << target_type == "best_equity"
	||
		target = 0p << target_type == "equity_closest_to_max_equity"
	};
	best_target = target;

	best_equity = 0p;
	best_max_equity = 0p;
	best_min_equity = 0p;
	best_train_window = 0c;
	best_train_window_support = 0c;
	best_slope_long = 0n;
	best_slope_short = 0n;
	best_slope_long_level = 0n;
	best_slope_short_level = 0n;
	best_channel_width = 0p;
	best_no_activity = -1c;

	// +++ slope_long_level loop
	my_slope_long = slope_long_start;
	my_slope_short = slope_short_start;
	my_channel_width = channel_width_start;
	
	my_no_activity = no_activity_start;

	count4 = 0i;
	..[my_no_activity <= no_activity_stop]
	{ // count4
	my_slope_long_level = slope_long_level_start;
	
	count3 = 0i;
	..[my_slope_long_level <= slope_long_level_stop]
	{ // count3
		// +++ slope_short_level loop
		my_slope_short_level = slope_short_level_start;

		count2 = 0i;
		..[my_slope_short_level <= slope_short_level_stop]
		{
			// +++ train_window_support loop
			my_train_window_support = train_window_support_start;
			my_train_window_resistance = train_window_resistance_start;
	
			count1 = 0i;
			..[my_train_window_support <= train_window_support_stop]
			{
				// +++ train_window loop
				my_train_window = train_window_start;
		
				count = 0i;
				..[my_train_window <= train_window_stop]
				{
					// +++ History turn
					log("test_starting_history...;count=;" + count3 + "." + count2 + "." + count1 + "." + count
					+ ";equity=;" + equity + ";account=;" + account
					+ ";train_window=;" + my_train_window + ";train_window_support=;" + my_train_window_support 
					+ ";slope_long=;" + my_slope_long + ";slope_short=;" + my_slope_short 
					+ ";slope_long_level=;" + my_slope_long_level + ";slope_short_level=;" + my_slope_short_level 
					+ ";my_channel_width=;" + my_channel_width
					+ ";my_no_activity=;" + my_no_activity
					);
		
					real_log_level = log.level;
					//log.level = "Error";
					log.level = base_log_level;
					..[candles.is_calculated != 1n] 
					{
						// +++ History loop
						LR_strategy_SlopeLevel_AdaptiveLots(
							safety_stock,	// Safety stock in percents to the equity
							risk_L,		// Risk rate in percents for long positions
							risk_S,		// Risk rate in percents for short positions
							expiration_time,
							day_start_time,	// Start time of the day trading session
							day_end_time,	// End time of the day trading session
							night_start_time,	// Start time of the night trading session
							night_end_time,	// End time of the night trading session
							predict_window, my_train_window,
							high_offset, low_offset,
							my_slope_long, my_slope_short,
							my_slope_long_level, my_slope_short_level,
							predict_window_support, my_train_window_support,
							predict_window_resistance, my_train_window_resistance,
							my_channel_width,
							my_no_activity
						);
						// --- History loop
					};
					//log.level = 0i;
					
					// target_type := ("best_equity", "equity_closest_to_max_equity")
					{
						target = equity << target_type == "best_equity";
						log("target_calculated" + ";target_type=;" + target_type + ";target=;" + target + ";best_target=;" + best_target + ";equity=;" + equity + ";max_equity=;" + dealer.max_equity)
					||
						target = ((dealer.max_equity + equity) / (dealer.max_equity - equity + 1p) * 1p) << target_type == "equity_closest_to_max_equity";
						log("target_calculated" + ";target_type=;" + target_type + ";target=;" + target + ";best_target=;" + best_target + ";equity=;" + equity + ";max_equity=;" + dealer.max_equity)
					};
	
					{
						best_target = target << target > best_target;
						best_equity = equity;
						best_max_equity = dealer.max_equity;
						best_min_equity = dealer.min_equity;
						best_train_window = my_train_window;
						best_train_window_support = my_train_window_support;
						best_slope_long = my_slope_long;
						best_slope_short = my_slope_short;
						best_slope_long_level = my_slope_long_level;
						best_slope_short_level = my_slope_short_level;
						best_channel_width = my_channel_width;
						best_no_activity = my_no_activity;
						log("best_target_moved" + ";target_type=;" + target_type + ";target=;" + target + ";best_target=;" + best_target)
					||
						best_target = best_target << target <= best_target
					};
		
					log.level = real_log_level;
					log("test_history_completed;count=;" + count4 + "." + count3 + "." + count2 + "." + count1 + "." + count 
					+ ";equity=;" + equity + ";account=;" + account 
					+ ";best_equity=;" + best_equity 
					+ ";best_max_equity=;" + best_max_equity
					+ ";best_min_equity=;" + best_min_equity
					+ ";best_train_window=;" + best_train_window + ";best_train_window_support=;" + best_train_window_support
					+ ";best_slope_long=;" + best_slope_long + ";best_slope_short=;" + best_slope_short 
					+ ";best_slope_long_level=;" + best_slope_long_level + ";best_slope_short_level=;" + best_slope_short_level 
					+ ";best_no_activity=;" + best_no_activity
					+ ";best_channel_width=;" + best_channel_width
					);
	
					my_train_window += train_window_step;
			
					count += 1i;
					
					reset_history()
					// --- History turn
				};
				// --- train_window loop
	
				my_train_window_support += train_window_support_step;
				my_train_window_resistance += train_window_resistance_step;
				count1 += 1i;
			};
			// --- train_window_support loop
	
			my_slope_short_level += slope_short_level_step;
			count2 += 1i;
		};
		// --- slope_short_level loop
	
		my_slope_long_level += slope_long_level_step;
		count3 += 1i;
	}; // count3
	// --- slope_long_level loop
	
	my_no_activity += no_activity_step;
	count4 += 1i;
	}; // count4

	log("Test_LR_strategy_SlopeLevel_AdaptiveLots_stopped");
	
	system.log("Test_LR_strategy_SlopeLevel_AdaptiveLots_stoppeed;count=;" + count3 + "." + count2 + "." + count1 + "." + count 
			+ ";equity=;" + equity + ";account=;" + account 
			+ ";best_equity=;" + best_equity 
			+ ";best_max_equity=;" + best_max_equity
			+ ";best_min_equity=;" + best_min_equity
			+ ";best_train_window=;" + best_train_window + ";best_train_window_support=;" + best_train_window_support
			+ ";best_slope_long=;" + best_slope_long + ";best_slope_short=;" + best_slope_short 
			+ ";best_slope_long_level=;" + best_slope_long_level + ";best_slope_short_level=;" + best_slope_short_level 
			+ ";best_no_activity=;" + best_no_activity
			+ ";best_channel_width=;" + best_channel_width
			)
};
