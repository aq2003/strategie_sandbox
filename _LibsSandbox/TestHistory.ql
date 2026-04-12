// TestGrid on history
// 
CloneList2List(source) :=
{
	my_index = 0i;
	target = new("list");
	count = count(source);
	
	..[my_index < count]
	{
		target += source[my_index];
			
		my_index += 1i;
	};
	
	result = target;
};

// +++ 15.09.2024 --- CopyList2List ------------------------------------------------------------------------
// Lists source and target must be of same size
CopyList2List(source, target) :=
{
	my_index = 0i;
	count = count(source);
	
	..[my_index < count]
	{
		target[my_index] = source[my_index];
			
		my_index += 1i;
	};
	
	result = target;
};
// --- 15.09.2024 --- CopyList2List ------------------------------------------------------------------------

CloneDict2List(source, param_name) :=
{
	my_index = 0i;
	target = new("list");
	count = count(source);
	
	..[my_index < count]
	{
		my_param = source[my_index];
		target += my_param[param_name];
			
		my_index += 1i;
	};
	
	result = target;
};

CopyValuesList2Dict(source, target, param_name) :=
{
	my_index = 0i;
	count = count(source);
	
	..[my_index < count]
	{
		my_param = target[my_index];
		my_param[param_name] = source[my_index];
			
		my_index += 1i;
	};
	
	result = target;
};

// Tests the variable type whether is it scalar ro not
// Parameters:
// - variable - a variable to test type of
// Returns:
// - true if the type is scalar, false if not
IsScalarType(variable) :=
{
	result = false;
	result = (type(variable) == "n" | type(variable) == "p" | type(variable) == "%" | type(variable) == "c" | type(variable) == "l" | type(variable) == "pp" | type(variable) == "i")
};

// +++ 09.03.2026 --- FindParameter ---------------------------
// Runs through a given parameter list to find out a parameter with given name
// Parameters:
// - param_list - a list of parameters to run through
// - params_count - count of parameters in the list
// - param_name - name of a parameter to find out
// Returns:
// - parameter found or null
FindParameter(param_list, params_count, param_name) :=
{
	result = 0n;
	
	i = 0i;
	..[i < params_count]
	{
		my_param = param_list[i];
		p_name = my_param["name"];
		
		// +++ Debug
		//log("FindParameter" + ";i=;" + i + ";my_param=;" + my_param + ";p_name=;" + p_name + ";param_name=;" + param_name);
		// --- Debug
		
		{
			result = my_param << p_name == param_name;
			i = params_count;
		||
			result = result << p_name != param_name
		};
		i += 1i
	}
};

// +++ 14.03.2026 --- CopyBestValues ---------------------------
// Copies 'best_values' set of parameters from a source into a target
// Parameters:
// - source - 'best_values' set of parameters to copy from
// - target - 'best_values' set of parameters to copy into
// Returns:
// - target set
CopyBestValues(source, target) :=
{
	result = 0n;
	
	//log("CopyBestValues;" + "source=;" + source);
	//log("CopyBestValues;" + "target=;" + target);
	
	target["equity"] = source["equity"];
	target["max_equity"] = source["max_equity"];
	target["min_equity"] = source["min_equity"];
	target["target"] = source["target"];
	target["session_PL_rate"] = source["session_PL_rate"];
	target["session_PL_rate_long"] = source["session_PL_rate_long"];
	target["session_PL_rate_short"] = source["session_PL_rate_short"];
	target["session_abs_profit_long"] = source["session_abs_profit_long"];
	target["session_abs_loss_long"] = source["session_abs_loss_long"];
	target["session_abs_profit_short"] = source["session_abs_profit_short"]; 
	target["session_abs_loss_short"] = source["session_abs_loss_short"];
	target["session_abs_profit"] = source["session_abs_profit"]; 
	target["session_abs_loss"] = source["session_abs_loss"];

	result = target;				
};

// --- 09.03.2026 --- FindParameter ---------------------------

_Test(
	parameters, 			// parameters := (..parameter); parameter := (name, start, stop, step, current, index)
	parameters_count, 		// Total number of parameters in the list; parameters.count
	start_parameter_index,	// Parameter number at the first entry
	current_parameter_index, 	// Number of a parameter to search with
	best_parameters, 		// List of best parameter values according to the given criteria; best_parameters := (..value); best_parameters.count == parameters.count
	best_values, 			// A set of best values; best_values := (equity, max_equity, min_equity, target)
	criteria, 				// Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
	base_log_level
) :=
{
	result = 0n;
	
	i = start_parameter_index;
	level_str = "-";
	..[i < current_parameter_index]
	{
		level_str += "-";
		i += 1i;
	};
	level_str += ">";
	
	// +++ Debug 14.09.2024
	//log("_Test_started;start_parameter_index=;" + start_parameter_index + ";current_parameter_index=;" + current_parameter_index);
	// --- Debug 14.09.2024

	my_index = current_parameter_index;

	{
		// To call a nested _Test
		my_parameter = parameters[my_index] << my_index < parameters_count;

		{
			// *** 12.06.2024 To step into a cycle when the value is a list
			my_parameter["index"] = 0i << type(my_parameter["value"]) == "list";
				
			// +++ Debug 14.09.2024
			//log("_Test_entered_scalar_section;my_parameter['name']=;" + my_parameter["name"] + ";type(my_parameter['start'])=;" + type(my_parameter["start"]));
			// --- Debug 14.09.2024
		
			/*my_parameter_value = my_parameter["start"];
			my_parameter_stop = my_parameter["stop"];
			my_parameter_step = my_parameter["step"];*/
			
			i = 0i;
			my_parameter_value = my_parameter["value"];
			my_parameter_count = count(my_parameter_value);
			//log("my_parameter['value']=;" + my_parameter["value"] + ";my_parameter_value=;" + my_parameter_value);
		
			..[/*abs(my_parameter_value) <= abs(my_parameter_stop)*/i < my_parameter_count]
			{
				my_parameter["current"] = my_parameter_value[i];
				my_parameter["index"] = i;
				// +++ Debug 12.06.2024
				/*log(level_str + "Nested_test_calling...;my_index=;" + my_index 
					+ ";my_parameter['current']=;" + my_parameter["current"] 
					+ ";my_parameter['name']=;" + my_parameter["name"] 
					+ ";my_parameter['index']=;" + my_parameter["index"]
					//+ ";best_parameters=;" + best_parameters
				);*/
				// --- Debug 12.06.2024
				_Test(
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
				/*log(level_str + "Nested_test_finished...;my_index=;" + my_index 
					+ ";my_parameter['current']=;" + my_parameter["current"] 
					+ ";my_parameter['name']=;" + my_parameter["name"] 
					+ ";my_parameter['index']=;" + my_parameter["index"]
					//+ ";best_parameters=;" + best_parameters
				);*/
				// --- Debug 12.06.2024
				//my_parameter_value += my_parameter_step;
				my_parameter["index"] = (i += 1i);
			}
			
		||
			// *** 14.09.2024 To take one turn when the value is not a list
			my_parameter["index"] = 0i << type(my_parameter["value"]) != "list";
				
			// +++ Debug 14.09.2024
			//log("_Test_entered_not_scalar_section;my_parameter['name']=;" + my_parameter["name"] + ";type(my_parameter['start'])=;" + type(my_parameter["start"]));
			// --- Debug 14.09.2024
			
			// +++ 09.03.2026 Here to substitute a named parameter
			my_parameter_value = 0n;
			{
				param_found = FindParameter(parameters, current_parameter_index, my_parameter["value"]) << type(my_parameter["value"]) == "s";
				{
					my_parameter_value = param_found["current"]
					// +++ Debug
					//log(level_str + "FindParameter_finished_success;param_found=;" + param_found + ";my_parameter;" + my_parameter) 
					//my_parameter_value = param_found["current"]
					// --- Debug
					<< type(param_found) != "n";
				||
					my_parameter_value = my_parameter["value"] 
					// +++ Debug
					//log(level_str + "FindParameter_finished_unsuccess;my_parameter=;" + my_parameter + ";param_found;" + param_found) 
					//my_parameter_value = my_parameter["value"]
					// --- Debug
					<< type(param_found) == "n";
				}
			||
				my_parameter_value = my_parameter["value"] << type(my_parameter["value"]) != "s"
			};
			// --- 09.03.2026 Here to substitute a named parameter
				
			//my_parameter_value = my_parameter["value"];
			
			my_parameter["current"] = my_parameter_value;
			// +++ Debug 12.06.2024
			/*log(level_str + "Nested_test_calling...;my_index=;" + my_index 
				+ ";my_parameter['current']=;" + my_parameter["current"] 
				+ ";my_parameter['name']=;" + my_parameter["name"] 
				+ ";my_parameter['index']=;" + my_parameter["index"]
				//+ ";best_parameters=;" + best_parameters
			);*/
			// --- Debug 12.06.2024
			_Test(
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
			/*log(level_str + "Nested_test_finished...;my_index=;" + my_index 
				+ ";my_parameter['current']=;" + my_parameter["current"] 
				+ ";my_parameter['name']=;" + my_parameter["name"] 
				+ ";my_parameter['index']=;" + my_parameter["index"]
				//+ ";best_parameters=;" + best_parameters
			);*/
			// --- Debug 12.06.2024
		};
		
	||
		// +++ Debug 14.09.2024
		//log("Test_starting_my_index==parameters_count;");
		// --- Debug 14.09.2024
				
		// To call a tested function
		param_index = start_parameter_index << my_index == parameters_count;
		msg_counts = "count=;";
		msg_param_values = "";
		t_count = 1i;
		..[param_index < parameters_count]
		{
			my_param = parameters[param_index];
			
			{
				msg_counts += ("" + (my_param["index"] + 1i) + "*") << param_index < parameters_count
			||
				msg_counts += ("" + (my_param["index"] + 1i)) << param_index == parameters_count
			};
			
			j = (param_index + 1i);
			c_i = my_param["index"];
			..[j < parameters_count]
			{
				c_p = parameters[j];
				c_i *= (c_p["count"] / 1i);
				j += 1i;
			};
			
			//t_count *= ((my_param["index"] + 1i) / 1i);
			t_count += c_i;
			
			msg_param_values += (";" + my_param["name"] + "=" + my_param["current"]);
			
			param_index += 1i;
		};
		
		msg_counts += ("=" + t_count + "_of_" + _total_count);
		
		// +++ Debug 22.09.2024
		//log(level_str + "test_starting_history...;" + msg_counts + ";equity=;" + equity + ";account=;" + account + msg_param_values);
		// --- Debug 22.09.2024
		first_time = system.time;
		log("test_starting_history...;" + msg_counts + ";equity=;" + equity + ";account=;" + account + msg_param_values);
					
		my_log_level = log.level;
		log.level = base_log_level;
		
		param_values = CloneDict2List(parameters, "current");
		
		turn_result = 0n;
		test_finished_itself = false;
		..[/*candles.is_calculated != 1n &*/ test_finished_itself == false]
		{
			turn_result = TestAdapter(param_values);
			test_finished_itself = true;
		};
		
		log.level = my_log_level;
		
		{
			log("there_is_something_unusual_in_the_test,_check_expiration_date") << test_finished_itself == true;
		||
			test_finished_itself = false << test_finished_itself == false;
		};
		
		{
			criteria = criteria << criteria == "best_equity";
			{
				/*best_values = turn_result*/CopyBestValues(turn_result, best_values) << turn_result["equity"] > best_values["equity"];
				//best_values["equity"] = equity << equity > best_values["equity"];
				//best_values["max_equity"] = dealer.max_equity;
				//best_values["min_equity"] = dealer.min_equity;
				//CopyBestValues(turn_result, best_values);
				CopyList2List(param_values, best_parameters);
			||
				//log(level_str + "test_equity_not_best;best_parameters=;" + best_parameters);
				turn_result = turn_result << turn_result["equity"] <= best_values["equity"]
			}
		||
			criteria = criteria << criteria == "best_max_equity";
			{
				/*best_values = turn_result*/CopyBestValues(turn_result, best_values) << turn_result["max_equity"] > best_values["max_equity"];
				//best_values["equity"] = equity << dealer.max_equity > best_values["max_equity"];
				//best_values["max_equity"] = dealer.max_equity;
				//best_values["min_equity"] = dealer.min_equity;
				//CopyBestValues(turn_result, best_values);
				CopyList2List(param_values, best_parameters);
			||
				turn_result = turn_result << turn_result["max_equity"] <= best_values["max_equity"]
			}
		||
			criteria = criteria << criteria == "best_min_equity";
			{
				/*best_values = turn_result*/CopyBestValues(turn_result, best_values) << turn_result["min_equity"] > best_values["min_equity"];
				//best_values["equity"] = equity << dealer.min_equity > best_values["min_equity"];
				//best_values["max_equity"] = dealer.max_equity;
				//best_values["min_equity"] = dealer.min_equity;
				//CopyBestValues(turn_result, best_values);
				CopyList2List(param_values, best_parameters);
			||
				turn_result = turn_result << turn_result["min_equity"] <= best_values["min_equity"]
			}
		||
			my_equity = equity << criteria == "equity_closest_to_max_equity";
			my_max_equity = dealer.max_equity;
			target = ((my_max_equity + my_equity) / (my_max_equity - my_equity + 1p) * 1p);
			
			{
				//best_values["equity"] = equity << target > best_values["target"];
				//best_values["max_equity"] = dealer.max_equity;
				//best_values["min_equity"] = dealer.min_equity;
				CopyBestValues(turn_result, best_values);
				CopyList2List(param_values, best_parameters);
			||
				turn_result = turn_result << target <= best_values["target"]
			}
		||
			criteria = criteria << criteria == "best_PL_rate";
			{
				/*best_values = turn_result*/CopyBestValues(turn_result, best_values) << turn_result["session_PL_rate"] > best_values["session_PL_rate"];
				//best_values["equity"] = equity << dealer.min_equity > best_values["min_equity"];
				//best_values["max_equity"] = dealer.max_equity;
				//best_values["min_equity"] = dealer.min_equity;
				//CopyBestValues(turn_result, best_values);
				CopyList2List(param_values, best_parameters);
			||
				turn_result = turn_result << turn_result["session_PL_rate"] <= best_values["session_PL_rate"]
			}
		};
		// +++ Debug
		log("Criteria_finished;" + "criteria=;" + criteria);
		// --- Debug
		
		best_parameter_index = start_parameter_index;
		msg_best_parameters = "";
		..[best_parameter_index < parameters_count]
		{
			my_param = parameters[best_parameter_index];
			msg_best_parameters += (";" + my_param["name"] + ";=" + best_parameters[best_parameter_index]);
			
			best_parameter_index += 1i;
		};
		
		// +++ Debug 22.09.2024
		/*log(level_str + "test_history_completed;" + msg_counts
			+ ";equity=;" + equity + ";account=;" + account
			+ ";best_equity=;" + best_values["equity"] + ";best_max_equity=;" + best_values["max_equity"] + ";best_min_equity=;" + best_values["min_equity"]
			+ msg_best_parameters 
		);*/
		// --- Debug 22.09.2024
		second_time = system.time;
		delta_time = (second_time - first_time);
		log("test_history_completed;" + msg_counts
			+ ";equity=;" + equity + ";account=;" + account
			+ ";best_equity=;" + best_values["equity"] + ";best_max_equity=;" + best_values["max_equity"] + ";best_min_equity=;" + best_values["min_equity"]
			+ msg_best_parameters + ";seconds_spent=;" + seconds(delta_time)
		);
		
		best_values["mean_equity"] += equity;
					
		reset_history();
		
	};
	
	// +++ Debug 14.09.2024
	//log("Test_finished;current_parameter_index=;" + current_parameter_index);
	// --- Debug 14.09.2024
};

// Makes a grid test on given a set of parameters and a module to test
// Parameters:
// - 	parameters - a set of parameters; parameters := (..parameter); parameter := (name, value, current, index, count); value := (list || scalar)
// -	criteria - optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
// -	base_log_level - log level to set when test has started running; prevents flooding in the log
// -	tested_module - a module to test; it has to have a TestAdapter function
// Returns:
// - best_values - a set of values produced on the best turn
// - best_parameters - set of tested module parameter values corresponding best_values
//
// If a parameter has type "s" then its value might be name of another parameter. In this case parameter's value for each turn repeats the value of that another parameter
//
Test(
	parameters, // parameters := (..parameter); parameter := (name, start, stop, step, current, index)
	criteria, // Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
	base_log_level,
	tested_module // A module to test; it has to have a TestAdapter function
) :=
{
	result = 0n;
	
	// First run
	import("%QTrader_Libs%\" + tested_module);
		
	parameters_count = count(parameters);
		
	// +++ best parameters preparing and counting counts ------------------------------------------------------
	best_parameters = new("list");
	str_count = "";
	total_count = 1i;
	my_count = 0i;
	..[my_count < parameters_count]
	{
		best_parameters += (my_count / 1i);
		
		my_parameter = parameters[my_count];
		my_parameter_value = my_parameter["value"];
		step_count = count(my_parameter_value);
		
		{
			str_count += ("_*_" + step_count) << my_count > 0i
		||
			str_count += (step_count) << my_count == 0i
		};
		
		my_parameter["count"] = step_count;
		total_count *= (step_count / 1i);
		
		my_count += 1i;
	};
	
	log("Test_started;there_are_" + str_count + "=" + total_count + "_turns_ongoing");

	// --- best parameters preparing and counting counts ------------------------------------------------------

	// +++ best values preparing ------------------------------------------------------------------------------
	// best_values := (equity, max_equity, min_equity, target)
	best_values = new("dict");
	best_values["equity"] = 0p;
	best_values["max_equity"] = 0p;
	best_values["min_equity"] = 0p;
	best_values["target"] = 0p;
	best_values["mean_equity"] = 0p;
	best_values["session_PL_rate"] = 0n;
	best_values["session_PL_rate_long"] = 0n;
	best_values["session_PL_rate_short"] = 0n;
	best_values["session_abs_profit_long"] = 0p;
	best_values["session_abs_loss_long"] = 0p;
	best_values["session_abs_profit_short"] = 0p; 
	best_values["session_abs_loss_short"] = 0p;
	best_values["session_abs_profit"] = 0p; 
	best_values["session_abs_loss"] = 0p;
		
	// --- best values preparing ------------------------------------------------------------------------------
		
	_Test(
		parameters, // parameters := (..parameter); parameter := (start, stop, step, current)
		parameters_count, // Total number of parameters in the list; parameters.count
		0i,// Parameter number at the first entry
		0i, // Number of a parameter to search with
		best_parameters, // List of best parameter values according to the given criteria; best_parameters := (..value); best_parameters.count == parameters.count
		best_values, // A set of best values; best_values := (equity, max_equity, min_equity, target)
		criteria, // Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
		base_log_level
		);
	
	best_parameter_index = 0i;
	msg_best_parameters = "";
	..[best_parameter_index < parameters_count]
	{
		my_param = parameters[best_parameter_index];
				
		msg_best_parameters += (";" + my_param["name"] + ";=" + best_parameters[best_parameter_index]);
			
		best_parameter_index += 1i;
	};
	
	result = new("dict");
	result["best_values"] = best_values;
	result["best_parameters"] = best_parameters;
	
	best_values["mean_equity"] /= total_count;
		
	log("Test_stopped;" 
		+ ";equity=;" + equity + ";account=;" + account
		+ ";best_equity=;" + best_values["equity"] + ";best_max_equity=;" + best_values["max_equity"] + ";best_min_equity=;" + best_values["min_equity"] + ";mean_equity=;" + best_values["mean_equity"]
		+ msg_best_parameters 
	);
	
	log("session_profit_&_loss" 
		+ ";session_PL_rate=;" + best_values["session_PL_rate"]
		+ ";session_PL_rate_long=;" + best_values["session_PL_rate_long"]
		+ ";session_PL_rate_short=;" + best_values["session_PL_rate_short"]
		+ ";session_abs_profit_long=;" + best_values["session_abs_profit_long"] + ";session_abs_loss_long=;" + best_values["session_abs_loss_long"]
		+ ";session_abs_profit_short=;" + best_values["session_abs_profit_short"] + ";session_abs_loss_short=;" + best_values["session_abs_loss_short"]
		+ ";session_abs_profit=;" + best_values["session_abs_profit"] + ";session_abs_loss=;" + best_values["session_abs_loss"]
	);
		
	system.log("Test_stopped;" 
		+ ";equity=;" + equity + ";account=;" + account
		+ ";best_equity=;" + best_values["equity"] + ";best_max_equity=;" + best_values["max_equity"] + ";best_min_equity=;" + best_values["min_equity"] + ";mean_equity=;" + best_values["mean_equity"]
		+ msg_best_parameters 
	);
	
	system.log("session_profit_&_loss" 
		+ ";session_PL_rate=;" + best_values["session_PL_rate"]
		+ ";session_PL_rate_long=;" + best_values["session_PL_rate_long"]
		+ ";session_PL_rate_short=;" + best_values["session_PL_rate_short"]
		+ ";session_abs_profit_long=;" + best_values["session_abs_profit_long"] + ";session_abs_loss_long=;" + best_values["session_abs_loss_long"]
		+ ";session_abs_profit_short=;" + best_values["session_abs_profit_short"] + ";session_abs_loss_short=;" + best_values["session_abs_loss_short"]
		+ ";session_abs_profit=;" + best_values["session_abs_profit"] + ";session_abs_loss=;" + best_values["session_abs_loss"]
	)
};
