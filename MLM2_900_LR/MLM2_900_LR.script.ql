// 12.11.2022 17:28:32 MLM2_900_LR ql script
// Created 12.11.2022 17:28:32

// 26.09.2022 8:27:18 VKCO_900_LR ql script
// Created 26.09.2022 8:27:18

// 20.09.2022 12:16:17 VKCO_3600_LR ql script
// Created 20.09.2022 12:16:17

// 01.11.2021 9:37:41 GAZP_900_LR ql script
// Created 01.11.2021 9:37:41

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
lots = 1l;
expiration_time = 23:00_31.12.22;
	
predict_window_type = "candle"; 

train_window_max = 240c;
train_window_min = 20c;
train_window_divider = 1.3n;

high_offset = "none";
low_offset = "none";

slope_long = 0.00n;
slope_short = 0.00n;

predict_window_type_support = "week";
train_window_support = 1400c;
predict_window_type_resistance = "week";
train_window_resistance = 1400c;

channel_width_min = 20p;
channel_width_max = 250p;
// --- parameters -----------------------------------------------------------------------------------------
		
import("%OneDrive%\Documents\My Stocks\Stock\HP-HP\QM_Imit\Strategy Sandbox\strategie_sandbox\LibsSandbox\LR_lib (2).aql");

log("test_starting_history...;"
	+ ";equity=;" + equity + ";account=;" + account
	+ ";train_window_max=;" + train_window_max 
	+ ";train_window_min=;" + train_window_min 
	+ ";train_window_support=;" + train_window_support 
	+ ";train_window_resistance=;" + train_window_resistance 
	+ ";channel_width_max=;" + channel_width_max
	+ ";channel_width_min=;" + channel_width_min
	);
		
LR_strategy(
		lots,				// Number of lots to open a position
		expiration_time, 	// Time when to stop the strategy
	
		predict_window_type,	// Signal line predict window type := ("week" || "day" || "candle")
		train_window_max,	// Maximum training window size of Signal line in candles
		train_window_min,	// Minimum training window size of Signal line in candles
		train_window_divider,	// Divider and multiplier to adjust train_window by channel_width value
		
		high_offset,	// Which type of price to take for the high line offset
		low_offset,	// Which type of price to take for the low line offset

		slope_long,	// Starting slope of linear regression for a long position
		slope_short,	// Starting slope of linear regression for a short position

		predict_window_type_support,	// Support line predict window type := ("week" || "day" || "candle")
		train_window_support,		// Support line width of training window in candle number
		predict_window_type_resistance,	// Resistance line predict window type := ("week" || "day" || "candle")
		train_window_resistance,	// Resistance line width of training window in candle number

		channel_width_max,	// Max edge of channel_width range
		channel_width_min	// Min edge of channel_width range
		);
					
log("test_history_completed;" 
	+ ";equity=;" + equity + ";account=;" + account 
	+ ";train_window=;" + train_window + ";train_window_support=;" + train_window_support 
	+ ";slope_long=;" + slope_long);
	
{
	stop() << time > expiration_time;
	log("expiration_stop") << account != 0l
||
	log("stop_by_stop_signal")
};

log("script_stopped")
