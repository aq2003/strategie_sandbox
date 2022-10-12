// 10.04.2022 15:11:04 SRZ1_900_LR ql script
// Created 10.04.2022 15:11:04

// +++ Parameters
start_time = 01:30; // Time to start trading every day
end_time = 23:50; // Time to finish trading evry day
threshold = 0.1%; // A threshold level to open position
trades_limit = 10i; // How much trades we are allowed to take during a session
sum_to_open = 1000p; // Sum of money we are allowed to spent for a position
sessionTP = 10%; // Session take profit level
sessionSL = -7%; // Session stop loss level

SL0_level	= 0%;		SL0_move	= -0.1%;
SL1_level	= 0.1%; 	SL1_move	= 0%;
SL2_level	= 0.2%; 	SL2_move	= 0.1%;
SL3_level	= 0.3%; 	SL3_move	= 0.2%;
SL4_level	= 0.4%; 	SL4_move	= 0.3%;
SL5_level	= 0.5%; 	SL5_move	= 0.4%;
SL6_level	= 0.6%; 	SL6_move	= 0.5%;
SL7_level	= 0.7%; 	SL7_move	= 0.6%;
SL8_level	= 1.0%; 	SL8_move	= 0.7%;
SL9_level	= 2.0%; 	SL9_move	= 1.5%;
SL10_level	= 3.0%; 	SL10_move 	= 2.0%;
SL11_level	= 4.0%; 	SL11_move 	= 3.0%;
SL12_level	= 4.0%; 	SL12_move 	= 3.0%;
SL13_level	= 4.0%; 	SL13_move 	= 3.0%;
SL14_level	= 4.0%; 	SL14_move 	= 3.0%;
SL15_level	= 4.0%; 	SL15_move 	= 3.0%;
SL16_level	= 4.0%; 	SL16_move 	= 3.0%;
SL17_level	= 4.0%; 	SL17_move 	= 3.0%;
SL18_level	= 4.0%; 	SL18_move 	= 3.0%;
SL19_level	= 4.0%; 	SL19_move 	= 3.0%;
SL20_level	= 4.0%; 	SL20_move 	= 3.0%;
SL21_level	= 4.0%; 	SL21_move 	= 3.0%;
SL22_level	= 4.0%; 	SL22_move 	= 3.0%;
SL23_level	= 4.0%; 	SL23_move 	= 3.0%;
SL24_level	= 4.0%; 	SL24_move 	= 3.0%;
SL25_level	= 4.0%; 	SL25_move 	= 3.0%;
SL26_level	= 4.0%; 	SL26_move 	= 3.0%;
SL27_level	= 4.0%; 	SL27_move 	= 3.0%;
SL28_level	= 4.0%; 	SL28_move 	= 3.0%;
SL29_level	= 4.0%; 	SL29_move 	= 3.0%;
SL30_level	= 4.0%; 	SL30_move 	= 3.0%;
SL31_level	= 4.0%; 	SL31_move 	= 3.0%;
SL32_level	= 4.0%; 	SL32_move 	= 3.0%;
SL33_level	= 4.0%; 	SL33_move 	= 3.0%;
SL34_level	= 4.0%; 	SL34_move 	= 3.0%;
SL35_level	= 4.0%; 	SL35_move 	= 3.0%;
SL36_level	= 4.0%; 	SL36_move 	= 3.0%;
SL37_level	= 4.0%; 	SL37_move 	= 3.0%;
SL38_level	= 4.0%; 	SL38_move 	= 3.0%;
SL39_level	= 4.0%; 	SL39_move 	= 3.0%;
SL40_level	= 4.0%; 	SL40_move 	= 3.0%;
SL41_level	= 4.0%; 	SL41_move 	= 3.0%;
SL42_level	= 4.0%; 	SL42_move 	= 3.0%;
SL43_level	= 4.0%; 	SL43_move 	= 3.0%;
SL44_level	= 4.0%; 	SL44_move 	= 3.0%;
SL45_level	= 4.0%; 	SL45_move 	= 3.0%;
SL46_level	= 4.0%; 	SL46_move 	= 3.0%;
SL47_level	= 4.0%; 	SL47_move 	= 3.0%;
SL48_level	= 4.0%; 	SL48_move 	= 3.0%;
SL49_level	= 4.0%; 	SL49_move 	= 3.0%;
SL50_level	= 4.0%; 	SL50_move 	= 3.0%;
// --- Parameters

log("Application.StartupPath_=;" + Application.StartupPath);
log("HomeDir_=;" + HomeDir);

import(Application.StartupPath + "\Libs\yar.aql");

yar();

log("stopped")

