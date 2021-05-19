cd julia

gcc random_int.c -c -fPIC -o random_int.o
gcc random_int.o -shared -fPIC -o random_int.dll

julia main.jl 10000