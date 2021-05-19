using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace cs
{
    class Program
    {
        static void Main(string[] args)
        {
            var m = new Main();
            m.main(args.Length, args);
        }
    }

    class Main
    {

        // Online C compiler to run C program online
        int random_seed = 1;

        int random_int()
        {
            random_seed = (int)(((uint)random_seed * 1664525U) + 1013904223U);
            return random_seed;
        }

        double calc_partial_result(double[] values, int num_of_values_to_process)
        {
            int i, j;
            double result = 0.0;

            for (i = 0; i < num_of_values_to_process; i++)
            {
                for (j = 0; j <= i; j++)
                {
                    result += values[i] * (j - 1);
                }
            }

            return result;
        }

        double calc_partial_conditional_result(double[] values, double[] values_conditional, int num_of_values_to_process, double min_conditional_value)
        {
            int i, j;
            double result = 0.0;

            for (i = 0; i < num_of_values_to_process; i++)
            {
                for (j = 0; j <= i; j++)
                {
                    if (values_conditional[j] >= min_conditional_value)
                    {
                        result += values[i] * (j - 1);
                    }
                }
            }

            return result;
        }

        double mean(double[] data, int n)
        {
            int i;
            double sum = 0.0;

            for (i = 0; i < n; i++)
            {
                sum += data[i];
            }

            return sum / n;
        }

        double standard_deviation(double[] data, int n)
        {
            int i;
            double sum_of_data_squared_minus_data = 0.0;

            double avg = mean(data, n);

            for (i = 0; i < n; i++)
            {
                sum_of_data_squared_minus_data += Math.Pow(data[i] - avg, 2);
            }
            return Math.Sqrt(sum_of_data_squared_minus_data / (n - 1));
        }

        public int main(int argc, string[] argv)
        {
            int num_of_values = int.Parse(argv[0]);

            int num_of_executions = 10;
            int num_of_values_to_process = num_of_values / 2;
            double min_conditional_value = 10;

            int i;
            double result;
            var execution_times_in_seconds = new double[num_of_executions];

            var values = new double[num_of_values];
            var values_conditional = new double[num_of_values];

            var sw = new Stopwatch();

            for (i = 0; i < num_of_values; i++)
            {
                values[i] = i + 1;
                values_conditional[i] = (double)random_int();
                //Console.WriteLine(values_conditional[i]);
            }

            // Warmup
            result = calc_partial_result(values, num_of_values_to_process);
            result = calc_partial_conditional_result(values, values_conditional, num_of_values_to_process, min_conditional_value);


            for (i = 0; i < num_of_executions; i++)
            {
                sw.Start();
                result = calc_partial_result(values, num_of_values_to_process);
                sw.Stop();

                execution_times_in_seconds[i] = (double)sw.Elapsed.TotalSeconds;
            }

            Console.WriteLine("calc_partial_result:");
            Console.WriteLine($"num_of_values_to_process: = {num_of_values_to_process}");
            Console.WriteLine($"{mean(execution_times_in_seconds, num_of_executions)} s ± {standard_deviation(execution_times_in_seconds, num_of_executions)} s per loop (mean ± std. dev. of {num_of_executions} runs, 1 loop each)");
            Console.WriteLine($"result = {result}");

            Console.WriteLine("");

            for (i = 0; i < num_of_executions; i++)
            {
                sw.Start();
                result = calc_partial_conditional_result(values, values_conditional, num_of_values_to_process, min_conditional_value);
                sw.Stop();

                execution_times_in_seconds[i] = (double)sw.Elapsed.TotalSeconds;
            }

            Console.WriteLine("calc_partial_conditional_result:");
            Console.WriteLine($"num_of_values_to_process: = {num_of_values_to_process}");
            Console.WriteLine($"{mean(execution_times_in_seconds, num_of_executions)} s ± {standard_deviation(execution_times_in_seconds, num_of_executions)} s per loop (mean ± std. dev. of {num_of_executions} runs, 1 loop each)");
            Console.WriteLine($"result = {result}");

            return 0;
        }

    }
}
