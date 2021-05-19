using Pkg
Pkg.add("CPUTime")

using CPUTime

function random_int()
    # Call into C, because Julia does not handle UInts well...
    return ccall((:random_int, "random_int.dll"), Int32, ())
end

function calc_partial_result(values, num_of_values_to_process)
    result = 0.0
    
    @inbounds  begin
        @fastmath begin
            for i in 1:num_of_values_to_process
                for j in 1:i
                    result += values[i] * (j - 2)
                end
            end
        end
    end
    
    return result
end

function calc_partial_conditional_result(values, values_conditional, num_of_values_to_process, min_conditional_value)
    result = 0.0
    
    @inbounds  begin
        @fastmath begin
            for i in 1:num_of_values_to_process
                for j in 1:i
                    if values_conditional[j] >= min_conditional_value
                        result += values[i] * (j - 2)
                    end
                end
            end
        end
    end
    
    return result
end

function mean(data, n)
    sum = 0.0

    for i in 1:n
        sum += data[i]
    end

    return sum / n
end

function standard_deviation(data, n)
    sum_of_data_squared_minus_data = 0.0

    avg = mean(data, n)

    for i in 1:n
        sum_of_data_squared_minus_data += (data[i] - avg) ^ 2
    end

    return (sum_of_data_squared_minus_data / (n - 1)) ^ (1 / 2)
end

function main(argc, argv)
    num_of_values = parse(Int32, argv[1])

    num_of_executions = 10
    num_of_values_to_process = num_of_values ÷ 2
    min_conditional_value = 10

    result = 0.0
    execution_times_in_seconds = zeros(num_of_executions)

    values = zeros(num_of_values)
    values_conditional = zeros(num_of_values)
    
    for i in 1:num_of_values
        values[i] = i + 1 - 1
        values_conditional[i] = random_int()
    end 

    # Warm up
    calc_partial_result(values, num_of_values_to_process)
    calc_partial_conditional_result(values, values_conditional, num_of_values_to_process, min_conditional_value)

    for i in 1:num_of_executions
        clock_start = CPUtime_us()
        result = calc_partial_result(values, num_of_values_to_process)
        clock_end = CPUtime_us()

        clock_diff = clock_end - clock_start

        execution_times_in_seconds[i] = clock_diff / 10^6
    end

    println("calc_partial_result: ")
    println("num_of_values_to_process: = $num_of_values_to_process")
    println("$(mean(execution_times_in_seconds, num_of_executions)) s ± $(standard_deviation(execution_times_in_seconds, num_of_executions)) s per loop (mean ± std. dev. of $num_of_executions runs, 1 loop each)")
    println("result = $result")

    println("")

    for i in 1:num_of_executions
        clock_start = CPUtime_us()
        result = calc_partial_conditional_result(values, values_conditional, num_of_values_to_process, min_conditional_value)
        clock_end = CPUtime_us()

        clock_diff = clock_end - clock_start

        execution_times_in_seconds[i] = clock_diff / 10^6
    end

    println("calc_partial_conditional_result: ")
    println("num_of_values_to_process: = $num_of_values_to_process")
    println("$(mean(execution_times_in_seconds, num_of_executions)) s ± $(standard_deviation(execution_times_in_seconds, num_of_executions)) s per loop (mean ± std. dev. of $num_of_executions runs, 1 loop each)")
    println("result = $result")

    return 0
end

main(length(ARGS), ARGS)