import fileinput
import intcode

# --- Day 5: Sunny with a Chance of Asteroids ---
# --- Part one ---

program = [int(x) for x in list(fileinput.input())[0].split(',')]
_, output = intcode.process_opcode(program, 1)
print(output)

# 4601506

# --- Part two ---
