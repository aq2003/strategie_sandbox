// +++ 1.06.2024 +++ QTrader_stdlib - QTrader standard QL library ++++++++++++++++++++++++++++++++++++++++++++++++++
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

// +++ 18.09.2024 - iter -----------------------------------------------------------------------------------
// Returns a list filled with valiues produced by iterations 
// Parameters:
// - pstart - start bound of iteration sequence
// - pstop - stop bound of iteration sequence
// - pstep - step of iteration sequence
iter(pstart, pstop, pstep) :=
{
	result = 1n;
	result = new("list");
	target = abs(pstop);
	
	current = pstart;
	..[abs(current) <= target]
	{
		// +++ Debug - 20.09.2024 ----------------------------------------------------------------
		//log("iter(pstart=" + pstart + ", pstop=" + pstop + ", pstep=" + pstep + ")=" + current);
		// --- Debug - 20.09.2024 ----------------------------------------------------------------
		result += current;
		current += pstep;
	};
};
// --- 18.09.2024 - iter -----------------------------------------------------------------------------------

my_stop() :=
{
	my_account = account;
	
	{
		log("my_stop_sending;" + "account=;" + account) << account < 0l;
		..[account != 0l]
		{
			stop();
			~
		}
	||
		log("my_stop_sending;" + "account=;" + account) << account > 0l;
		..[account != 0l]
		{
			stop();
			~
		}
	||
		log("no_stop_sending;" + "account=;" + account) << account == 0l;
	};
	
	log("my_stop_finished;" + "account=;" + account)
};

find_max_price(period) :=
{
	index = 0c;
	index = -period;
	max = high[index];
	
	..[index < 0c]
	{
		{
			max = high[index] << high[index] > max;
		||
			max = max << high[index] <= max;
		};
		
		index += 1c;
	};
	
	result = max;
};

find_max_price_index(period) :=
{
	index = 0c;
	index = -period;
	res = index;
	max = high[index];
	
	..[index < 0c]
	{
		{
			max = high[index] << high[index] > max;
			res = index;
		||
			max = max << high[index] <= max;
		};
		
		index += 1c;
	};
	
	result = res;
};

find_min_price(period) :=
{
	index = 0c;
	index = -period;
	min = low[index];
	
	..[index < 0c]
	{
		{
			min = low[index] << low[index] < min
		||
			min = min << low[index] >= min
		};
		
		index += 1c;
	};
	
	result = min;
};

find_min_price_index(period) :=
{
	index = 0c;
	index = -period;
	res = index;
	min = low[index];
	
	..[index < 0c]
	{
		{
			min = low[index] << low[index] < min;
			res = index;
		||
			min = min << low[index] >= min
		};
		
		index += 1c;
	};
	
	result = res;
};

// +++ MovingTimeBounds --- 16.04.2023 -----------------------------------------------------------------------------------------------------
// Moves time bounds which define when the script trading starts and is over
// !!!Under construction!!!
MovingTimeBounds(
	my_day_start_time,	// Start time of the day trading session
	my_day_end_time,	// End time of the day trading session
	my_night_start_time,	// Start time of the night trading session
	my_night_end_time	// End time of the night trading session
) :=
{
	result = 0n;
	
	..{
		log("time_watch_started" + ";start_time=;" + my_start_time + ";end_time=;" + my_end_time + ";day_start_time=;" + my_day_start_time);
		my_start_time += 1D << time > my_end_time;
		my_end_time += 1D;
		my_day_start_time += 1D;
		log("time_moved" + ";start_time=;" + my_start_time + ";end_time=;" + my_end_time + ";day_start_time=;" + my_day_start_time)
	}
};
// --- MovingTimeBounds --------------------------------------------------------------------------------------------------------------------


// --- 1.06.2024 --- QTrader_stdlib - QTrader standard QL library --------------------------------------------------
