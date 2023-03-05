// 10.01.2023 14:08:53 MLH3_900_LR ql script
// Created 10.01.2023 14:08:53

// 06.06.2022 8:51:21 MLM2_900_LR ql script
// Created 06.06.2022 8:51:21

//// 24.05.2022 4:32:00 SIM2_900_LR ql script
// Created 24.05.2022 4:32:00

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

// +++ parameters -----------------------------------------------------------------------------------------
lots = 4l;
expiration_time = 15:00_17.03.23;
	
predict_window = "candle"; 
train_window = 95c;
high_offset = "none";
low_offset = "none";

slope_long_start = 0.5n;
slope_short_start = -0.5n;

predict_window_support = "week";
train_window_support = 1200c;
predict_window_resistance = "week";
train_window_resistance = 1200c;

channel_width = /*950*/0p;
// --- parameters -----------------------------------------------------------------------------------------
		
import("%OneDrive%\Documents\My Stocks\Stock\HP-HP\QM_Imit\Strategy Sandbox\strategie_sandbox\LibsSandbox\LR_lib.aql");

LR_strategy_w_adaptive_MAE(
		lots, expiration_time,
		predict_window, train_window,
		high_offset, low_offset,
		slope_long_start, slope_short_start,
		predict_window_support, train_window_support,
		predict_window_resistance, train_window_resistance,
		channel_width
		);
		
/*..
{
	log("high=;" + high + ";low=;" + low + ";open=;" + open + ";close=;" + close);
	~
};*/
		
stop();

log("script_stopped")
