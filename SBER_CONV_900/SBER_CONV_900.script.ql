// 30.08.2021 9:31:23 SBER_CONV_900 ql script
// Created 30.08.2021 9:31:23

// +++ Parameters
expiration_time = 23:55_31.12.21; // Time when the trading stops

// Convolution parameters
period = 12c;

// trading parameters
lots_to_open = 200000p;
treshold = 0p;
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
		period += 2c << pos.abs_profit > my_abs_profit //& period > 2c
	||
		period -= 2c << pos.abs_profit < my_abs_profit & period > 2c 
	};
	
	my_abs_profit = pos.abs_profit;
};

{
	step = 0n; ..{ report(step); step += 1n; ~ }
||	
	..[time < expiration_time]
	{
		long(lots_to_open) << close - open[-period] > treshold & account == 0l;
		log("long;account=;" + account) << account > 0l;
		~
	||		
		stop() << close - open[-period] < 0p & account > 0l;
		log("long_bs_stop") << account == 0l;
		
		tune_period();
	||	
		short(lots_to_open) << close - open[-period] < -treshold & account == 0l;
		log("short;account=;" + account) << account < 0l;
		~
	||		
		stop() << (close - open[-period]) > 0p & account < 0l;
		log("short_bs_stop") << account == 0l;
		
		tune_period();
	};
};

log("stopped")
