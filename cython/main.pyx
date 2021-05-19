# cython: language_level=3
cimport cython
from libc.time cimport clock, CLOCKS_PER_SEC

import sys
import numpy as np

cdef int random_seed = 1

cdef int random_int():
    global random_seed
    random_seed = random_seed * 1664525U + 1013904223U;
    return random_seed

@cython.boundscheck(False)
@cython.wraparound(False)
@cython.initializedcheck(False)
cdef double calc_partial_result(double[:] values, int num_of_values_to_process):
    cdef int i, j
    cdef double result = 0.0
    
    for i in range(num_of_values_to_process):
        for j in range(i + 1):
            result += values[i] * (j - 1)
    
    return result

@cython.boundscheck(False)
@cython.wraparound(False)
@cython.initializedcheck(False)
cdef double calc_partial_conditional_result(double[:] values, double[:] values_conditional, int num_of_values_to_process, double min_conditional_value):
    cdef int i, j
    cdef double result = 0.0
    
    for i in range(num_of_values_to_process):
        for j in range(i + 1):
            if values_conditional[j] >= min_conditional_value:
                result += values[i] * (j - 1)
    
    return result

cdef double mean(double[:] data, int n):
    cdef int i
    cdef double sum = 0.0

    for i in range(n):
        sum += data[i]

    return sum / n

cdef double standard_deviation(double[:] data, int n):
    cdef int i
    cdef double sum_of_data_squared_minus_data = 0.0

    cdef double avg = mean(data, n)

    for i in range(n):
        sum_of_data_squared_minus_data += (data[i] - avg) ** 2

    return (sum_of_data_squared_minus_data / (n - 1)) ** (1 / 2)

cpdef int main(int argc, list argv):
    cdef int num_of_values = int(argv[1])

    cdef int num_of_executions = 10
    cdef int num_of_values_to_process = num_of_values // 2
    cdef double min_conditional_value = 10

    cdef int i, clock_start, clock_end
    cdef double result, clock_diff
    cdef double[:] execution_times_in_seconds = np.zeros(num_of_executions)

    cdef double[:] values = np.zeros(num_of_values)
    cdef double[:] values_conditional = np.zeros(num_of_values)
    
    for i in range(num_of_values):
        values[i] = i + 1
        values_conditional[i] = random_int() 

    for i in range(num_of_executions):
        clock_start = clock()
        result = calc_partial_result(values, num_of_values_to_process)
        clock_end = clock()

        clock_diff = clock_end - clock_start

        execution_times_in_seconds[i] = clock_diff / CLOCKS_PER_SEC

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

        execution_times_in_seconds[i] = clock_diff / CLOCKS_PER_SEC

    print("calc_partial_conditional_result: ")
    print(f"num_of_values_to_process: = {num_of_values_to_process}")
    print(f"{mean(execution_times_in_seconds, num_of_executions)} s ± {standard_deviation(execution_times_in_seconds, num_of_executions)} s per loop (mean ± std. dev. of {num_of_executions} runs, 1 loop each)")
    print(f"result = {result}")

    return 0

main(len(sys.argv), sys.argv)