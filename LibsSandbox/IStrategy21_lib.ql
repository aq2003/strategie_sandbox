// 11.02.2023 11:19:04 SRH3_300_S21 ql script
// Created 11.02.2023 11:19:04

// 06.02.2023 6:29:07 SRH3_300_IS2 ql script
// Created 06.02.2023 6:29:07

// 21.01.2023 13:08:20 Strategy2 ql script
// Created 21.01.2023 13:08:20

// 30.04.2022 18:32:33 New_Robot256 ql script
// Created 30.04.2022 18:32:33

// 25.04.2022 19:58:00 New_Robot256 ql script
// Created 25.04.2022 19:58:00

// +++ Parameters ------------------------------------------------------------------------------------------------------------------
// Trading parameters
lots = 1l; // Number of lots to open position
long_close_price1 = 15p; // Price delta to the long position open price to make the take profit stop
long_close_price2 = 10p; // Price delta to the long position open price to make the take profit stop
short_close_price1 = 15p; // Price delta to the short position open price to make the take profit stop
short_close_price2 = 10p; // Price delta to the short position open price to make the take profit stop
long_stop_loss = 50p; // Long position stop loss level relatively to the position open price
short_stop_loss = 50p; // Short position stop loss level relatively to the position open price
// --- Parameters ------------------------------------------------------------------------------------------------------------------

// Looks for long SL condition and stops the position when it has happened
long_SL(SL) :=
{
	result = 0n;
	
	SL_price = pos.price;
	SL_price -= SL;
	log("long_SL_started" + ";SL_price=;" + SL_price);
	
	{
		stop() << low < SL_price;
		log("long_SL_fired" + ";SL_price=;" + SL_price + ";pos.abs_profit=;" + pos.abs_profit + ";low=;" + low) << account == 0l;
	
	||
		..{log("long_SL_running" + ";SL_price=;" + SL_price); ~}
	}
};

// Looks for short SL condition and stops the position when it has happened
short_SL(SL) :=
{
	result = 0n;
	
	SL_price = pos.price;
	SL_price += SL;
	log("short_SL_started" + ";SL_price=;" + SL_price);
	
	{
		stop() << high > SL_price;
		log("short_SL_fired" + ";SL_price=;" + SL_price + ";pos.abs_profit=;" + pos.abs_profit + ";high=;" + high) << account == 0l
	||
		..{log("short_SL_running" + ";SL_price=;" + SL_price); ~}
	}
};

long_TS(TS1, TS2) :=
{
	result = 0n;
	
	stop_price1 = pos.price;
	stop_price2 = pos.price;
	stop_price1 += TS1;
	stop_price2 += (TS1 + TS2);
	stop_price2_old = stop_price1;
	log("long_TS_started" + ";stop_price1=;" + stop_price1 + ";stop_price2=;" + stop_price2);
		
	{
		log("long_TS_stop1_acieved" + ";stop_price1=;" + stop_price1 + ";stop_price2=;" + stop_price2 + ";close=;" + close) << close > stop_price1;
	
		stop() << close < stop_price1;
		log("long_TS_stop1_fired" + ";stop_price1=;" + stop_price1 + ";pos.abs_profit=;" + pos.abs_profit + ";close=;" + close) << account == 0l
	||
		stop_reason = 0n;
		..[stop_reason == 0n]
		{
			log("long_TS_stop2_acieved" + ";stop_price1=;" + stop_price1 + ";stop_price2=;" + stop_price2 + ";close=;" + close) << close > stop_price2;
			stop_price2_old = stop_price2;
			stop_price2 += TS2;
			log("long_TS_stop2_moved" + ";stop_price1=;" + stop_price1 + ";stop_price2=;" + stop_price2 + ";stop_price2_old=;" + stop_price2_old)
		||
			stop() << close < stop_price2_old & high > stop_price2_old;
			log("long_TS_stop2_fired" + ";stop_price2=;" + stop_price2 + ";stop_price2_old=;" + stop_price2_old + ";pos.abs_profit=;" + pos.abs_profit + ";close=;" + close) << account == 0l;
			stop_reason = 1n
		}
	||
		..{log("long_TS_running" + ";stop_price1=;" + stop_price1 + ";stop_price2=;" + stop_price2); ~}
	}
};

short_TS(TS1, TS2) :=
{
	result = 0n;
	
	stop_price1 = pos.price;
	stop_price2 = pos.price;
	stop_price1 -= TS1;
	stop_price2 -= (TS1 + TS2);
	stop_price2_old = stop_price1;
	log("short_TS_started" + ";stop_price1=;" + stop_price1 + ";stop_price2=;" + stop_price2);
		
	{
		log("short_TS_stop1_acieved" + ";stop_price1=;" + stop_price1 + ";stop_price2=;" + stop_price2 + ";close=;" + close) << close < stop_price1;
	
		stop() << close > stop_price1;
		log("short_TS_stop1_fired" + ";stop_price1=;" + stop_price1 + ";pos.abs_profit=;" + pos.abs_profit + ";close=;" + close) << account == 0l
	||
		stop_reason = 0n;
		..[stop_reason == 0n]
		{
			log("short_TS_stop2_acieved" + ";stop_price1=;" + stop_price1 + ";stop_price2=;" + stop_price2 + ";close=;" + close) << close < stop_price2;
			stop_price2_old = stop_price2;
			stop_price2 -= TS2;
			log("short_TS_stop2_moved" + ";stop_price1=;" + stop_price1 + ";stop_price2=;" + stop_price2 + ";stop_price2_old=;" + stop_price2_old)
		||
			stop() << close > stop_price2_old & low < stop_price2_old;
			log("short_TS_stop2_fired" + ";stop_price2=;" + stop_price2 + ";stop_price2_old=;" + stop_price2_old + ";pos.abs_profit=;" + pos.abs_profit + ";close=;" + close) << account == 0l;
			stop_reason = 1n
		}
	||
		..{log("short_TS_running" + ";stop_price1=;" + stop_price1 + ";stop_price2=;" + stop_price2); ~}
	}
};

// Processes full lifecycle of long position - opens and closes it depending on conditions
process_long() :=
{
	result = 0n;
	
	{
	      long(lots) << time >= 09:00 & time < 23:40 & account == 0l;
	      log("long_open;pos.price=;" + pos.price + ";account_=;" + account + ";signal_=;" + signal) << account > 0l
	||
	      log("long_is_opened_already" + ";account=;" + account) << account > 0l;
	      signal = 1n
	};
	
	{
		long_SL(long_stop_loss) << time >= 09:00 & time <= 23:50;
		~;
		signal = -1n
	||
		long_TS(long_close_price1, long_close_price2) << time >= 09:00 & time <= 23:50;
		~;
		signal = 1n
	}
};

// Processes full lifecycle of long position - opens and closes it depending on conditions
process_short() :=
{
	result = 0n;
	
	{
	      short(lots) << time >= 09:00 & time < 23:40 & account == 0l;
	      log("short_open;pos.price=;" + pos.price + ";account_=;" + account + ";signal_=;" + signal) << account < 0l
	||
	      log("short_is_opened_already" + ";account=;" + account) << account < 0l;
	      signal = -1n
	};
	
	{
		short_SL(short_stop_loss) << time >= 09:00 & time <= 23:50;
		~;
		signal = 1n
	||
		short_TS(short_close_price1, short_close_price2) << time >= 09:00 & time <= 23:50;
		~;
		signal = -1n
	}
};
	
reporter() := 
{
	result = 0n;
	
	log("step_=;" + step 
		+ ";account_=;" + account 
		+ ";pos.abs_profit_=;" + pos.abs_profit 
		+ ";high_=;" + high
		+ ";low_=;" + low
	); 
	step += 1n; 
	~
};

IStrategy21(
			lots, // Number of lots to open position
			long_close_price1, // Price delta to the long position open price to make the take profit stop
			long_close_price2, // Price delta to the long position open price to make the take profit stop
			short_close_price1, // Price delta to the short position open price to make the take profit stop
			short_close_price2, // Price delta to the short position open price to make the take profit stop
			long_stop_loss, // Long position stop loss level relatively to the position open price
			short_stop_loss // Short position stop loss level relatively to the position open price
		) :=
{
	result = 0n;
	
	//my_long_close_price1 = 100000p;
	//my_short_close_price1 = 0p;
	//long_sl_price = 0p;
	//my_short_sl_price = 0p;
	//my_long_open_price = 0p;
	//short_open_price = 0p;

	{
		/*step = 0n;
		..reporter()
	||*/
		// Main cycle
		..
		{
			// Start of a day
			log("day_started") << time >= 09:00 & time < 23:45;
			signal = 1n;
		
			{
				// Intraday cycle
				..
				{
					process_long() << signal > 0n;
				||
					process_short() << signal < 0n; 
				}
			||
				// Day end stop
				log("day_finished") << time > 23:45
			};
	
			// End of a day
			stop();
			log("stop_by_day_end") << account == 0l
		}
	};



	log("IStrategy21_stopped")
};
