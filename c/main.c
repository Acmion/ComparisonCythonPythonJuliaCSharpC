// Online C compiler to run C program online
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <math.h>

int random_seed = 1;

int random_int() 
{
    random_seed = random_seed * 1664525U + 1013904223U;
    return random_seed;
}

double calc_partial_result(double *values, int num_of_values_to_process)
{
    int i, j;
    double result = 0.0;
    
    for(i = 0; i < num_of_values_to_process; i++)
    {
        for(j = 0; j <= i; j++)
        {
            result += values[i] * (j - 1);
        }
    }
    
    return result;
}

double calc_partial_conditional_result(double *values, double *values_conditional, int num_of_values_to_process, double min_conditional_value)
{
    int i, j;
    double result = 0.0;
    
    for(i = 0; i < num_of_values_to_process; i++)
    {
        for(j = 0; j <= i; j++)
        {
            if(values_conditional[j] >= min_conditional_value)
            {
                result += values[i] * (j - 1);
            }
        }
    }
    
    return result;
}

double mean(double data[], int n)
{
    int i;
    double sum = 0.0;

    for(i = 0; i < n; i++)
    {
        sum += data[i];
    }

    return sum / n;
}

double standard_deviation(double data[], int n) 
{
    int i;
    double sum_of_data_squared_minus_data = 0.0;

    double avg = mean(data, n);

    for (i = 0; i < n; i++) 
    {
        sum_of_data_squared_minus_data += pow(data[i] - avg, 2);
    }
    return sqrt(sum_of_data_squared_minus_data / (n - 1));
}

int main(int argc, char *argv[]) 
{
    int num_of_values = atoi(argv[1]);

    int num_of_executions = 10;
    int num_of_values_to_process = num_of_values / 2;
    double min_conditional_value = 10;

    int i, clock_start, clock_end;
    double result, clock_diff;
    double execution_times_in_seconds[num_of_executions];

    double *values;
    double *values_conditional;
    
    values = (double *)malloc(num_of_values * sizeof(double));
    values_conditional = (double *)malloc(num_of_values * sizeof(double));
    
    for(i = 0; i < num_of_values; i++)
    {
        values[i] = i + 1;
        values_conditional[i] = (double)random_int();
        //printf("%f\n", values_conditional[i]);
    }

    for(i = 0; i < num_of_executions; i++)
    {
        clock_start = clock();
        result = calc_partial_result(values, num_of_values_to_process);
        clock_end = clock();

        execution_times_in_seconds[i] = (double)(clock_end - clock_start) / CLOCKS_PER_SEC;
    }

    printf("calc_partial_result: \n");
    printf("num_of_values_to_process: = %d\n", num_of_values_to_process);
    printf("%f s ± %f s per loop (mean ± std. dev. of %d runs, 1 loop each)\n", mean(execution_times_in_seconds, num_of_executions), standard_deviation(execution_times_in_seconds, num_of_executions), num_of_executions);
    printf("result = %f\n", result);

    printf("\n");

    for(i = 0; i < num_of_executions; i++)
    {
        clock_start = clock();
        result = calc_partial_conditional_result(values, values_conditional, num_of_values_to_process, min_conditional_value);
        clock_end = clock();

        clock_diff = clock_end - clock_start;

        execution_times_in_seconds[i] = clock_diff / CLOCKS_PER_SEC;
    }

    printf("calc_partial_conditional_result: \n");
    printf("num_of_values_to_process: = %d\n", num_of_values_to_process);
    printf("%f s ± %f s per loop (mean ± std. dev. of %d runs, 1 loop each)\n", mean(execution_times_in_seconds, num_of_executions), standard_deviation(execution_times_in_seconds, num_of_executions), num_of_executions);
    printf("result = %f\n", result);

    return 0;
}
