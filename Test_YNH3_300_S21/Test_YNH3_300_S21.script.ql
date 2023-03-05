// 23.02.2023 15:34:17 Test_YNH3_300_S21 ql script
// Created 23.02.2023 15:34:17

// 11.02.2023 18:45:49 Test_SRH3_300_S21 ql script
// Created 11.02.2023 18:45:49

// 11.02.2023 12:09:49 Test_SRH3_300_S21 ql script
// Created 11.02.2023 12:09:49

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

// +++ parameters -----------------------------------------------------------------------------------------
lots = 1l; // Number of lots to open position
long_close_price1_start = 0.1%; // Start <Price delta to the long position open price to make the take profit stop>
long_close_price1_stop = 0.2%; // Stop <Price delta to the long position open price to make the take profit stop>
long_close_price1_step = 0.1%; // Step <Price delta to the long position open price to make the take profit stop>

long_close_price2_start = 0.1%; // Start <Price delta to the long position open price to make the take profit stop>
long_close_price2_stop = 0.2%; // Stop <Price delta to the long position open price to make the take profit stop>
long_close_price2_step = 0.2%; // Step <Price delta to the long position open price to make the take profit stop>

short_close_price1_start = 0.4%; // Start <Price delta to the short position open price to make the take profit stop>
short_close_price1_stop = 0.5%; // Stop <Price delta to the short position open price to make the take profit stop>
short_close_price1_step = 0.1%; // Step <Price delta to the short position open price to make the take profit stop>

short_close_price2_start = 0.4%; // Start <Price delta to the short position open price to make the take profit stop>
short_close_price2_stop = 0.5%; // Stop <Price delta to the short position open price to make the take profit stop>
short_close_price2_step = 0.1%; // Step <Price delta to the short position open price to make the take profit stop>

long_stop_loss_start = 1%; // Start <Long position stop loss level relatively to the position open price>
long_stop_loss_stop = 2%; // Stop <Long position stop loss level relatively to the position open price>
long_stop_loss_step = 0.2%; // Step <Long position stop loss level relatively to the position open price>

short_stop_loss_start = 1%; // Start <Short position stop loss level relatively to the position open price>
short_stop_loss_stop = 2%; // Stop <Short position stop loss level relatively to the position open price>
short_stop_loss_step = 0.2%; // Step <Short position stop loss level relatively to the position open price>

log("lots_=;" + lots);
log("long_close_price1_start=;" + long_close_price1_start + ";long_close_price1_stop=;" + long_close_price1_stop + ";long_close_price1_step=;" + long_close_price1_step);
log("long_close_price2_start=;" + long_close_price2_start + ";long_close_price2_stop=;" + long_close_price2_stop + ";long_close_price2_step=;" + long_close_price2_step);
log("short_close_price1_start=;" + short_close_price1_start + ";short_close_price1_stop=;" + short_close_price1_stop + ";short_close_price1_step=;" + short_close_price1_step);
log("short_close_price2_start=;" + short_close_price2_start + ";short_close_price2_stop=;" + short_close_price2_stop + ";short_close_price2_step=;" + short_close_price2_step);
log("long_stop_loss_start=;" + long_stop_loss_start + ";long_stop_loss_stop=;" + long_stop_loss_stop + ";long_stop_loss_step=;" + long_stop_loss_step);
log("short_stop_loss_start=;" + short_stop_loss_start + ";short_stop_loss_stop=;" + short_stop_loss_stop + ";short_stop_loss_step=;" + short_stop_loss_step);
// --- parameters -----------------------------------------------------------------------------------------
		
import("C:\Users\Admin\OneDrive\Documents\My Stocks\Stock\Utils\Libs\S2.aql");

best_equity = 0p;
my_long_close_price1 = long_close_price1_start;
my_long_close_price2 = long_close_price2_start;
my_short_close_price1 = short_close_price1_start;
my_short_close_price2 = short_close_price2_start;
my_long_stop_loss = long_stop_loss_start;
my_short_stop_loss = short_stop_loss_start;

best_long_close_price1 = my_long_close_price1;
best_long_close_price2 = my_long_close_price2;
best_short_close_price1 = my_short_close_price1;
best_short_close_price2 = my_short_close_price2;
best_long_stop_loss = my_long_stop_loss;
best_short_stop_loss = my_short_stop_loss;

my_long_close_price1 = long_close_price1_start;
count5 = 0i;
..[my_long_close_price1 <= long_close_price1_stop]
{
	my_long_close_price2 = long_close_price2_start;
	
	count4 = 0i;
	..[my_long_close_price2 <= long_close_price2_stop]
	{
		my_short_close_price1 = short_close_price1_start;
		
		count3 = 0i;
		..[my_short_close_price1 <= short_close_price1_stop]
		{
			my_short_close_price2 = short_close_price2_start;
		
			count2 = 0i;
			..[my_short_close_price2 <= short_close_price2_stop]
			{
				my_long_stop_loss = long_stop_loss_start;
		
				count1 = 0i;
				..[my_long_stop_loss <= long_stop_loss_stop]
				{
					my_short_stop_loss = short_stop_loss_start;
		
					count0 = 0i;
					..[my_short_stop_loss <= short_stop_loss_stop]
					{
						log("test_starting_history...;count=;" + count5 + "." + count4 + "." + count3 + "." + count2 + "." + count1 + "." + count0 
							+ ";equity=;" + equity + ";account=;" + account
							+ ";my_long_close_price1=;" + my_long_close_price1 
							+ ";my_long_close_price2=;" + my_long_close_price2 
							+ ";my_short_close_price1=;" + my_short_close_price1 
							+ ";my_short_close_price2=;" + my_short_close_price2 
							+ ";my_long_stop_loss=;" + my_long_stop_loss
							+ ";my_short_stop_loss=;" + my_short_stop_loss
							);
		
						log.level = -1i;
						..[candles.is_calculated != 1n] 
						{
							S2(
								lots, 
								my_long_close_price1,
								my_long_close_price2,
								my_long_close_price2 / 2n,
								my_short_close_price1,
								my_short_close_price2,
								my_short_close_price2 / 2n,
								my_long_stop_loss,
								my_short_stop_loss
								);
						};
	
						{
							best_equity = equity << equity > best_equity;
							best_long_close_price1 = my_long_close_price1;
							best_long_close_price2 = my_long_close_price2;
							best_short_close_price1 = my_short_close_price1;
							best_short_close_price2 = my_short_close_price2;
							best_long_stop_loss = my_long_stop_loss;
							best_short_stop_loss = my_short_stop_loss;
						||
							best_equity = best_equity << equity <= best_equity
						};
		
						log.level = 0i;
						log("test_history_completed;count=;" + count5 + "." + count4 + "." + count3 + "." + count2 + "." + count1 + "." + count0 
							+ ";equity=;" + equity + ";account=;" + account 
							+ ";best_equity=;" + best_equity 
							+ ";best_long_close_price1=;" + best_long_close_price1 
							+ ";best_long_close_price2=;" + best_long_close_price2 
							+ ";best_short_close_price1=;" + best_short_close_price1 
							+ ";best_short_close_price2=;" + best_short_close_price2 
							+ ";best_long_stop_loss=;" + best_long_stop_loss
							+ ";best_short_stop_loss=;" + best_short_stop_loss
							);
	
						reset_history();
						
						my_short_stop_loss += short_stop_loss_step;
						count0 += 1i;
					};
					
					my_long_stop_loss += long_stop_loss_step;
					count1 += 1i;
				};
					
				my_short_close_price2 += short_close_price2_step;
				count2 += 1i;
			};
					
			my_short_close_price1 += short_close_price1_step;
			count3 += 1i;		
		};
	
		my_long_close_price2 += long_close_price2_step;
		count4 += 1i;
	};
	
	my_long_close_price1 += long_close_price1_step;
	count5 += 1i;
};

log("test_script_stopped")
