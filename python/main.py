import sys
from time import process_time as clock
import numpy as np
import ctypes

import pyximport
pyximport.install()

# Import random_int from cython, because Python does not support unsigned ints. 
# This ensures same results
import random_int as ri

random_seed = 1

def random_int():
    return ri.random_int()

def calc_partial_result(values, num_of_values_to_process):
    result = 0.0
    
    for i in range(num_of_values_to_process):
        for j in range(i + 1):
            result += values[i] * (j - 1)
    
    return result

def calc_partial_conditional_result(values, values_conditional, num_of_values_to_process, min_conditional_value):
    result = 0
    
    for i in range(num_of_values_to_process):
        for j in range(i + 1):
            if values_conditional[j] >= min_conditional_value:
                result += values[i] * (j - 1)
    
    return result

def mean(data, n):
    sum = 0.0

    for i in range(n):
        sum += data[i]

    return sum / n

def standard_deviation(data, n):
    sum_of_data_squared_minus_data = 0.0

    avg = mean(data, n)

    for i in range(n):
        sum_of_data_squared_minus_data += (data[i] - avg) ** 2

    return (sum_of_data_squared_minus_data / (n - 1)) ** (1 / 2)

def main(argc, argv):
    num_of_values = int(argv[1])

    num_of_executions = 10
    num_of_values_to_process = num_of_values // 2
    min_conditional_value = 10

    execution_times_in_seconds = np.zeros(num_of_executions)

    values = np.zeros(num_of_values)
    values_conditional = np.zeros(num_of_values)
    
    for i in range(num_of_values):
        values[i] = i + 1
        values_conditional[i] = random_int() 

    for i in range(num_of_executions):
        clock_start = clock()
        result = calc_partial_result(values, num_of_values_to_process)
        clock_end = clock()

        clock_diff = clock_end - clock_start

        execution_times_in_seconds[i] = clock_diff

    print("calc_partial_result: ")
    print(f"num_of_values_to_process: = {num_of_values_to_process}")
    print(f"{mean(execution_times_in_seconds, num_of_executions)} s ± {standard_deviation(execution_times_in_seconds, num_of_executions)} s per loop (mean ± std. dev. of {num_of_executions} runs, 1 loop each)")
    print(f"result = {result}")

    print("")

    for i in range(num_of_executions):
        clock_start = clock()
        result = calc_partial_conditional_result(values, values_conditional, num_of_values_to_process, min_conditional_value)
        clock_end = clock()

        clock_diff = clock_end - clock_start

        execution_times_in_seconds[i] = clock_diff

    print("calc_partial_conditional_result: ")
    print(f"num_of_values_to_process: = {num_of_values_to_process}")
    print(f"{mean(execution_times_in_seconds, num_of_executions)} s ± {standard_deviation(execution_times_in_seconds, num_of_executions)} s per loop (mean ± std. dev. of {num_of_executions} runs, 1 loop each)")
    print(f"result = {result}")

    return 0

main(len(sys.argv), sys.argv)