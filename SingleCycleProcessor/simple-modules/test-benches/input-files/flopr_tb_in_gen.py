from random import getrandbits, randint

N = 64

def twoComplement(number): # for N bits
    if number >= 0:
        return number
    return (~(-number)+1) + (1 << N)

def setCntBits(number, cntBits):
    return number & ((1 << cntBits) - 1)

def gen(test_number):
    reset = (test_number < 5)
    d = getrandbits(64)
    q = d
    if test_number < 5:
        q = 0

    reset = setCntBits(reset, 1)
    d = setCntBits(d, 64)
    q = setCntBits(q, 64)

    print(f"{reset} {d} {q}")



print("// reset, d, q_expected")
cnt_tests = 11
for i in range(cnt_tests):
    gen(i)