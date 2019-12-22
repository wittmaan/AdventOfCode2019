from enum import Enum


class Opcode(Enum):
    ADD = 1
    MULTIPLY = 2
    INPUT = 3
    OUTPUT = 4
    JUMP_IF_TRUE = 5
    JUMP_IF_FALSE = 6
    LESS_THAN = 7
    EQUAL = 8
    END = 99


class Mode(Enum):
    POSITION = 0
    IMMEDIATE = 1


def process(x):
    if x == 99:
        return Opcode(x), None
    else:
        return Opcode(x % 10), [Mode((x // 10 ** i) % 10) for i in range(2, 5)]


# assert process(1002) == (Opcode(2), [Mode(0), Mode(1), Mode(0)])


def process_opcode(x, input_instruction):
    pos = 0
    program = x[:]
    output = []

    while True:
        opcode, modes = process(program[pos])
        # print("opcode={}, modes={}".format(opcode, modes))

        if opcode == Opcode.ADD:
            in1 = program[pos + 1] if modes[0] == Mode.POSITION else pos + 1
            in2 = program[pos + 2] if modes[1] == Mode.POSITION else pos + 2
            out = program[pos + 3] if modes[2] == Mode.POSITION else pos + 3
            program[out] = program[in1] + program[in2]
            pos += 4
        elif opcode == Opcode.MULTIPLY:
            in1 = program[pos + 1] if modes[0] == Mode.POSITION else pos + 1
            in2 = program[pos + 2] if modes[1] == Mode.POSITION else pos + 2
            out = program[pos + 3] if modes[2] == Mode.POSITION else pos + 3
            program[out] = program[in1] * program[in2]
            pos += 4
        elif opcode == Opcode.INPUT:
            program[program[pos + 1]] = input_instruction
            pos += 2
        elif opcode == Opcode.OUTPUT:
            out = program[program[pos + 1]] if modes[0] == Mode.POSITION else program[pos + 1]
            output.append(out)
            pos += 2
        elif opcode == Opcode.END:
            break
        else:
            raise ValueError("unknown opcode: {}".format(opcode))

    # print("program={}, output={}".format(program, output))
    return program, output

# assert process_opcode([1002, 4, 3, 4, 33, 99], 2) == ([1002, 4, 3, 4, 99, 99], [])
# assert process_opcode([3, 0, 4, 0, 99], 2) == ([2, 0, 4, 0, 99], [2])
# assert process_opcode([1101, 100, -1, 4, 0], 2) == ([1101, 100, -1, 4, 99], [])
