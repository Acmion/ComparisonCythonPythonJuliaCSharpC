cd cython

source .venv/Scripts/activate

cython main.pyx --embed --annotate -o __cython__/main.c 
gcc __cython__/main.c -municode -D MS_WIN64 -Ofast -march=native -IC:/Python39/include -LC:/Python39/libs -l python39 -o main

./main 10000