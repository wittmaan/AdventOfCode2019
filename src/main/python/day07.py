import fileinput
import intcode
from itertools import permutations
from collections import defaultdict

# --- Day 7: Amplification Circuit ---
# --- Part one ---

program = [int(x) for x in list(fileinput.input())[0].split(',')]


def run_amplifier(x, phases):
    actual_input = 0
    thrusters = []
    for phase in phases:
        _, output, _ = intcode.process_opcode(x, [actual_input, phase])

        actual_input = output[0]
        thrusters.append(output[0])

        # print("phase={}, output={}".format(phase, output))
    return thrusters


assert max(run_amplifier([3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0], [4, 3, 2, 1, 0])) == 43210
assert max(run_amplifier([3, 23, 3, 24, 1002, 24, 10, 24, 1002, 23, -1, 23,
                          101, 5, 23, 23, 1, 24, 23, 23, 4, 23, 99, 0, 0], [0, 1, 2, 3, 4])) == 54321
assert max(run_amplifier([3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007, 31, 0, 33,
                          1002, 33, 7, 33, 1, 33, 31, 31, 1, 32, 31, 31, 4, 31, 99, 0, 0, 0], [1, 0, 4, 3, 2])) == 65210


def get_max_thruster(x, values):
    thrusters = []
    for phases in permutations(values):
        thrusters.append(max(run_amplifier(x, phases)))
    return max(thrusters)


print(get_max_thruster(program, range(5)))

# 47064


# --- Part two ---

class AmplifierContainer(object):
    def __init__(self, pos, x):
        self.pos = pos
        self.program = x


def run_amplifier_mod(x, phases):
    actual_input = 0
    thrusters = []
    count = 0
    program_dict = defaultdict(AmplifierContainer)

    finished = False
    while True:
        for phase in phases:
            if count == 0:
                input_instruction = [actual_input, phase]
                program_dict[phase] = AmplifierContainer(0, x[:])
            else:
                input_instruction = [actual_input]

            program_tmp, output, pos_tmp = intcode.process_opcode(program_dict[phase].program, input_instruction,
                                                                  program_dict[phase].pos)
            if len(output) == 0:
                finished = True
                break

            program_dict[phase].program = program_tmp
            program_dict[phase].pos = pos_tmp

            actual_input = output[0]
            thrusters.append(output[0])
            # print("phase={}, output={}".format(phase, output))
        count += 1
        if finished:
            break

    return thrusters


# assert max(run_amplifier_mod([3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27, 26,
#                              27, 4, 27, 1001, 28, -1, 28, 1005, 28, 6, 99, 0, 0, 5], [9, 8, 7, 6, 5])) == 139629729

# assert max(run_amplifier_mod(
#    [3, 52, 1001, 52, -5, 52, 3, 53, 1, 52, 56, 54, 1007, 54, 5, 55, 1005, 55, 26, 1001, 54, -5, 54, 1105, 1, 12, 1,
#     53, 54, 53, 1008, 54, 0, 55, 1001, 55, 1, 55, 2, 53, 55, 53, 4, 53, 1001, 56, -1, 56, 1005, 56, 6, 99, 0, 0, 0,
#     0, 10], [9, 7, 8, 5, 6])) == 18216


def get_max_thruster(x, values):
    thrusters = []
    for phases in permutations(values):
        thrusters.append(max(run_amplifier_mod(x, phases)))
    return max(thrusters)


print(get_max_thruster(program, [9, 8, 7, 6, 5]))

# 4248984
