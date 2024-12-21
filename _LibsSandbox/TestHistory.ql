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

IsScalarType(variable) :=
{
	result = false;
	result = (type(variable) == "n" | type(variable) == "p" | type(variable) == "%" | type(variable) == "c" | type(variable) == "l" | type(variable) == "pp" | type(variable) == "i")
};

_Test(
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
			// *** 12.06.2024 To step into a cycle when the value is of scalar type
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
			// *** 14.09.2024 To take one turn when the value is of not scalar type
			my_parameter["index"] = 0i << type(my_parameter["value"]) != "list";
				
			// +++ Debug 14.09.2024
			//log("_Test_entered_not_scalar_section;my_parameter['name']=;" + my_parameter["name"] + ";type(my_parameter['start'])=;" + type(my_parameter["start"]));
			// --- Debug 14.09.2024
				
			my_parameter_value = my_parameter["value"];
			
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
		log("test_starting_history...;" + msg_counts + ";equity=;" + equity + ";account=;" + account + msg_param_values);
					
		my_log_level = log.level;
		log.level = base_log_level;
		
		param_values = CloneDict2List(parameters, "current");
		
		turn_result = 0n;
		test_finished_itself = false;
		..[candles.is_calculated != 1n & test_finished_itself == false]
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
				best_values["equity"] = equity << equity > best_values["equity"];
				best_values["max_equity"] = dealer.max_equity;
				best_values["min_equity"] = dealer.min_equity;
				CopyList2List(param_values, best_parameters);
			||
				//log(level_str + "test_equity_not_best;best_parameters=;" + best_parameters);
				turn_result = turn_result << equity <= best_values["equity"]
			}
		||
			criteria = criteria << criteria == "best_max_equity";
			{
				best_values["equity"] = equity << dealer.max_equity > best_values["max_equity"];
				best_values["max_equity"] = dealer.max_equity;
				best_values["min_equity"] = dealer.min_equity;
				CopyList2List(param_values, best_parameters);
			||
				turn_result = turn_result << dealer.max_equity <= best_values["max_equity"]
			}
		||
			criteria = criteria << criteria == "best_min_equity";
			{
				best_values["equity"] = equity << dealer.min_equity > best_values["min_equity"];
				best_values["max_equity"] = dealer.max_equity;
				best_values["min_equity"] = dealer.min_equity;
				CopyList2List(param_values, best_parameters);
			||
				turn_result = turn_result << dealer.min_equity <= best_values["min_equity"]
			}
		||
			my_equity = equity << criteria == "equity_closest_to_max_equity";
			my_max_equity = dealer.max_equity;
			target = ((my_max_equity + my_equity) / (my_max_equity - my_equity + 1p) * 1p);
			
			{
				best_values["equity"] = equity << target > best_values["target"];
				best_values["max_equity"] = dealer.max_equity;
				best_values["min_equity"] = dealer.min_equity;
				CopyList2List(param_values, best_parameters);
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
		
		// +++ Debug 22.09.2024
		/*log(level_str + "test_history_completed;" + msg_counts
			+ ";equity=;" + equity + ";account=;" + account
			+ ";best_equity=;" + best_values["equity"] + ";best_max_equity=;" + best_values["max_equity"] + ";best_min_equity=;" + best_values["min_equity"]
			+ msg_best_parameters 
		);*/
		// --- Debug 22.09.2024
		log("test_history_completed;" + msg_counts
			+ ";equity=;" + equity + ";account=;" + account
			+ ";best_equity=;" + best_values["equity"] + ";best_max_equity=;" + best_values["max_equity"] + ";best_min_equity=;" + best_values["min_equity"]
			+ msg_best_parameters 
		);
					
		reset_history();
		
	};
	
	// +++ Debug 14.09.2024
	//log("Test_finished;current_parameter_index=;" + current_parameter_index);
	// --- Debug 14.09.2024
};

Test(
	parameters, // parameters := (..parameter); parameter := (name, start, stop, step, current, index)
	criteria, // Optimization criteria; criteria := ("best_equity" || "best_max_equity" || "best_min_equity" || "equity_closest_to_max_equity")
	base_log_level,
	tested_module // A module to test; it has to have a TestAdapter function
) :=
{
	result = 0n;
	
	// First run
	//import("%QTrader_Libs%\LR_strategy_SlopeLevel_AdaptiveLots (30).aql");
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
		
	log("Test_stopped;" 
		+ ";equity=;" + equity + ";account=;" + account
		+ ";best_equity=;" + best_values["equity"] + ";best_max_equity=;" + best_values["max_equity"] + ";best_min_equity=;" + best_values["min_equity"]
		+ msg_best_parameters 
	);
		
	system.log("Test_stopped;" 
		+ ";equity=;" + equity + ";account=;" + account
		+ ";best_equity=;" + best_values["equity"] + ";best_max_equity=;" + best_values["max_equity"] + ";best_min_equity=;" + best_values["min_equity"]
		+ msg_best_parameters 
	)
};
