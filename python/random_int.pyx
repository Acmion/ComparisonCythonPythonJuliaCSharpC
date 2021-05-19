cdef int random_seed = 1

cpdef int random_int():
    global random_seed
    random_seed = random_seed * 1664525U + 1013904223U
    return random_seed