CloneList2List(source, count) :=
{
	my_index = 0i;
	target = new("list");
	
	..[my_index < count]
	{
		target += source[my_index];
			
		my_index += 1i;
	};
	
	result = target;
};

CloneDict2List(source, param_name, count) :=
{
	my_index = 0i;
	target = new("list");
	
	..[my_index < count]
	{
		my_param = source[my_index];
		target += my_param[param_name];
			
		my_index += 1i;
	};
	
	result = target;
};

CopyValuesList2Dict(source, target, param_name, count) :=
{
	my_index = 0i;
	..[my_index < count]
	{
		my_param = target[my_index];
		my_param[param_name] = source[my_index];
			
		my_index += 1i;
	};
	
	result = target;
};

Test(
	parameters, // parameters := (..parameter); parameter := (name, start, stop, step, current, index)
	parameters_count, // Total number of parameters in the list; parameters.count
	start_parameter_index,// Parameter number at the first entry
	current_parameter_index, // Number of a parameter to search with
	best_parameters, // List of best parameter values according to the given criteria; best_parameters := (..value); best_parameters.count == parameters.count
	best_values, // A set of best values; best_values := (equity, max_equity, min_equity, target)
	criteria, // Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
	base_log_level
) :=
{
	result = 0n;
	
	{
		// First run
		import("%QTrader_Libs%\LR_strategy_SlopeLevel_AdaptiveLots (3).aql") << start_parameter_index == current_parameter_index;
	||
		result = 0n << start_parameter_index != current_parameter_index;
	};
		
	
	log("Test_started;start_parameter_index=;" + start_parameter_index + ";current_parameter_index=;" + current_parameter_index);

	my_index = current_parameter_index;

	{
		my_parameter = parameters[my_index] << my_index < parameters_count;

		my_parameter_value = my_parameter["start"];
		my_parameter_stop = my_parameter["stop"];
		my_parameter_step = my_parameter["step"];
		my_parameter["index"] = 0i;
		
		..[my_parameter_value <= my_parameter_stop]
		{
			my_parameter["current"] = my_parameter_value;
			// +++ Debug 12.06.2024
			log("Nested_test_calling...;my_index=;" + my_index 
				+ ";my_parameter['current']=;" + my_parameter["current"] 
				+ ";my_parameter['name']=;" + my_parameter["name"] 
				+ ";my_parameter['index']=;" + my_parameter["index"]
			);
			// --- Debug 12.06.2024
			Test(
				parameters, // parameters := (..parameter); parameter := (start, stop, step, current)
				parameters_count, // Total number of parameters in the list; parameters.count
				start_parameter_index,// Parameter number at the first entry
				current_parameter_index + 1i, // Number of a parameter to search with
				best_parameters, // List of best parameter values according to the given criteria; best_parameters := (..value); best_parameters.count == parameters.count
				best_values, // A set of best values; best_values := (equity, max_equity, min_equity, target)
				criteria, // Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
				base_log_level
			);
			// +++ Debug 12.06.2024
			log("Nested_test_finished...;my_index=;" + my_index 
				+ ";my_parameter['current']=;" + my_parameter["current"] 
				+ ";my_parameter['name']=;" + my_parameter["name"] 
				+ ";my_parameter['index']=;" + my_parameter["index"]
			);
			// --- Debug 12.06.2024
			my_parameter_value += my_parameter_step;
			my_parameter["index"] += 1i;
		};
		
		{
			best_parameter_index = start_parameter_index << current_parameter_index == start_parameter_index;
			msg_best_parameters = "";
			..[best_parameter_index < parameters_count]
			{
				msg_best_parameters += (";" + my_param["name"] + ";=" + best_parameters[best_parameter_index]);
			
				best_parameter_index += 1i;
			};
		
			system.log("Test_LR_strategy_SlopeLevel_AdaptiveLots_stopped;" 
				+ ";equity=;" + equity + ";account=;" + account
				+ ";best_equity=;" + best_values["equity"] + ";best_max_equity=;" + best_values["max_equity"] + ";best_min_equity=;" + best_values["min_equity"]
				+ msg_best_parameters 
			)
		||
			start_parameter_index = start_parameter_index << current_parameter_index != start_parameter_index;
		}
		
	||
		param_values = new("list") << my_index == parameters_count;
		log("Test_starting_my_index==parameters_count;");
				
		param_index = start_parameter_index;
		msg_counts = "count=;";
		msg_param_values = "";
		..[param_index < parameters_count]
		{
			my_param = parameters[param_index];
			msg_counts += ("" + my_param["index"] + ".");
			msg_param_values += (";" + my_param["name"] + "=" + my_param["current"]);
			
			param_index += 1i;
		};
		
		log("test_starting_history...;" + msg_counts + ";equity=;" + equity + ";account=;" + account + msg_param_values);
					
		my_log_level = log.level;
		log.level = base_log_level;
		
		param_values = CloneDict2List(parameters, "current", parameters_count);
		
		turn_result = 0n;
		..[candles.is_calculated != 1n]
		{
			turn_result = TestAdapter_LR_strategy_SlopeLevel_AdaptiveLots(param_values)
		};
		
		log.level = my_log_level;
		
		{
			log("Test_checking_criteria;criteria=;" + criteria) << criteria == "best_equity";
			criteria = criteria << criteria == "best_equity";
			{
				//best_values["equity"] = res["equity"] << res["equity"] > best_values["equity"];
				//best_values["max_equity"] = res["max_equity"];
				//best_values["min_equity"] = res["min_equity"];
				//best_parameters = param_values

				best_values["equity"] = equity << equity > best_values["equity"];
				best_values["max_equity"] = dealer.max_equity;
				best_values["min_equity"] = dealer.min_equity;
				best_parameters = CloneList2List(param_values, parameters_count)
			||
				//res = res << res["equity"] <= best_values["equity"]
				turn_result = turn_result << equity <= best_values["equity"]
			}
		||
			log("Test_checking_criteria;criteria=;" + criteria) << criteria == "best_max_equity";
			criteria = criteria << criteria == "best_max_equity";
			{
				best_values["equity"] = turn_result["equity"] << turn_result["max_equity"] > best_values["max_equity"];
				best_values["max_equity"] = turn_result["max_equity"];
				best_values["min_equity"] = turn_result["min_equity"];
				best_parameters = CloneList2List(param_values, parameters_count)
			||
				turn_result = turn_result << turn_result["max_equity"] <= best_values["max_equity"]
			}
		||
			log("Test_checking_criteria;criteria=;" + criteria) << criteria == "best_min_equity";
			criteria = criteria << criteria == "best_min_equity";
			{
				best_values["equity"] = turn_result["equity"] << turn_result["min_equity"] > best_values["min_equity"];
				best_values["max_equity"] = turn_result["max_equity"];
				best_values["min_equity"] = turn_result["min_equity"];
				best_parameters = CloneList2List(param_values, parameters_count)
			||
				turn_result = turn_result << turn_result["min_equity"] <= best_values["min_equity"]
			}
		||
			my_equity = turn_result["equity"] << criteria == "equity_closest_to_max_equity";
			my_max_equity = turn_result["max_equity"];
			target = ((my_max_equity + my_equity) / (my_max_equity - my_equity + 1p) * 1p);
			
			{
				best_values["equity"] = turn_result["equity"] << target > best_values["target"];
				best_values["max_equity"] = turn_result["max_equity"];
				best_values["min_equity"] = turn_result["min_equity"];
				best_parameters = CloneList2List(param_values, parameters_count)
			||
				turn_result = turn_result << target <= best_values["target"]
			}
		};
		
		best_parameter_index = start_parameter_index;
		msg_best_parameters = "";
		..[best_parameter_index < parameters_count]
		{
			my_param = parameters[best_parameter_index];
			msg_best_parameters += (";" + my_param["name"] + ";=" + best_parameters[best_parameter_index]);
			
			best_parameter_index += 1i;
		};
		
		log("test_history_completed;" + msg_counts
			+ ";equity=;" + equity + ";account=;" + account
			+ ";best_equity=;" + best_values["equity"] + ";best_max_equity=;" + best_values["max_equity"] + ";best_min_equity=;" + best_values["min_equity"]
			+ msg_best_parameters 
		);
					
		reset_history();
		
	};
	
	log("Test_finished;current_parameter_index=;" + current_parameter_index);

};
