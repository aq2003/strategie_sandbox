// 30.08.2021 9:31:23 SBER_CONV_900 ql script
// Created 30.08.2021 9:31:23

// +++ Parameters
expiration_time = 23:55_31.12.21; // Time when the trading stops

// Convolution parameters
period = 2c;
max_period = 8c;
min_period = 2c;

// trading parameters
lots_to_open = 200000p;
treshold = 0.0p;
expiration_time = 15:00_17.12.21;
// --- Parameters

//import(Application.StartupPath + "\Libs\yar.aql");

//yar();

my_abs_profit = pos.abs_profit;

report(step) :=
{
	result = 0n;
	
	log("step_=;" + step + ";period_=;" + period + ";account_=;" + account + ";equity_=;" + equity + ";open[period]_=;" + open[-period]);
};

tune_period() :=
{
	result = 0n;
	
	{
		period += 2c << pos.abs_profit > my_abs_profit & period < max_period
	||
		period -= 2c << pos.abs_profit < /*my_abs_profit*/ 0p & period > min_period 
	};
	
	my_abs_profit = pos.abs_profit;
};

{
	step = 0n; ..{ report(step); step += 1n; ~ }
||	
	..[time < expiration_time]
	{
		long(lots_to_open) << close[-1c] - open[-period] > treshold & account == 0l & time >= 09:00 & time <= 23:45;
		log("long;account=;" + account) << account > 0l;
		~
	||		
		stop() << close[-1c] - open[-period] < 0p & account > 0l //& time < 18:45
		;
		log("long_bs_stop") << account == 0l;
		
		tune_period();
	||	
		short(lots_to_open) << close[-1c] - open[-period] < -treshold & account == 0l & time >= 09:00 & time <= 23:45;
		log("short;account=;" + account) << account < 0l;
		~
	||		
		stop() << (close[-1c] - open[-period]) > 0p & account < 0l //& time < 18:45
		;
		log("short_bs_stop") << account == 0l;
		
		tune_period();
	};
};

log("stopped")
