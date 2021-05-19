#include "random_int.h"

int random_seed = 1;

int random_int() 
{
    random_seed = random_seed * 1664525U + 1013904223U;
    return random_seed;
}