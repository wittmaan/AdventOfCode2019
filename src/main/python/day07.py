import fileinput
import intcode
from itertools import permutations

# --- Day 5: Sunny with a Chance of Asteroids ---
# --- Part one ---

program = [int(x) for x in list(fileinput.input())[0].split(',')]


def run_amplifier(x, phases):
    actual_input = 0
    thrusters = []
    for phase in phases:
        _, output = intcode.process_opcode(x, [phase, actual_input])

        actual_input = output[0]
        thrusters.append(output[0])

        # print("phase={}, output={}".format(phase, output))
    return thrusters


assert max(run_amplifier([3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0], [4, 3, 2, 1, 0])) == 43210
assert max(run_amplifier([3, 23, 3, 24, 1002, 24, 10, 24, 1002, 23, -1, 23,
                          101, 5, 23, 23, 1, 24, 23, 23, 4, 23, 99, 0, 0], [0, 1, 2, 3, 4])) == 54321
assert max(run_amplifier([3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007, 31, 0, 33,
                          1002, 33, 7, 33, 1, 33, 31, 31, 1, 32, 31, 31, 4, 31, 99, 0, 0, 0], [1, 0, 4, 3, 2])) == 65210

thrusters = []
for phases in permutations(range(5)):
    thrusters.append(max(run_amplifier(program, phases)))

print(max(thrusters))
