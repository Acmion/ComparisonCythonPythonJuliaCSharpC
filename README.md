# Comparison Cython Python Julia C# C
Comparing the performance of Cython, Python, Julia, C# and C with two specific numerical micro benchmarks.

## Results
The results of this benchmark. Note that the startup times of each implementation were not accounted for. 
See the benchmark code, in the section "Benchmark Code". Suprisingly, Cython performed best, with C very closely
behind. The compiler commands may be the cause of the slightly slower C code. Julia came in at about 2x slower,
C# at about 10x slower and Python at about 200x - 1000x slower. All implementations calculate used the same input 
values and got the same output.

| Language | Mean Execution Time (s) | Standard Deviation of Execution Time (s) | Result           |
|----------|-------------------------|------------------------------------------|------------------|
| C        | 0.005000                | 0.000471                                 | 78093734373750.0 |
| Cython   | 0.005000                | 0.000737                                 | 78093734373750.0 |
| Julia    | 0.012500                | 0.006603                                 | 78093734373750.0 |
| C#       | 0.061540                | 0.033642                                 | 78093734373750.0 |
| Python   | 5.209375                | 0.105768                                 | 78093734373750.0 |
<p style="text-align: center">Table 1: Statistics for calc_partial_result performance.</p>

| Language | Mean Execution Time (s) | Standard Deviation of Execution Time (s) | Result           |
|----------|-------------------------|------------------------------------------|------------------|
| C        | 0.032200                | 0.001229                                 | 39698235518841.0 |
| Cython   | 0.028999                | 0.000666                                 | 39698235518841.0 |
| Julia    | 0.053200                | 0.008230                                 | 39698235518841.0 |
| C#       | 0.299488                | 0.101629                                 | 39698235518841.0 |
| Python   | 6.353125                | 0.026760                                 | 39698235518841.0 |
<p style="text-align: center">Table 2: Statistics for calc_partial_conditional_result performance.</p>

## Benchmark Code
The performance of these two functions are measured (this code is in C, which has also been translated to the other languages):
```
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
```

## Requirements
Windows:
+ Win10
+ Python 3.9
+ MinGW 64bit
+ Julia 1.6
+ Bash

Linux:
+ ??? (the code should work for the most part, but the scripts under `scripts` may have to be tuned)

## Execution
From the root directory run:
```
sh init.sh
sh execute.sh
```