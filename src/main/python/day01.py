import fileinput
import math

# --- Day 1: The Tyranny of the Rocket Equation ---
# --- Part one ---

masses = [x.strip() for x in fileinput.input()]
print(sum([math.floor(int(x) / 3) - 2 for x in masses]))


# --- Part two ---

def calc_fuel(mass):
    def f(x): return math.floor(int(x) / 3) - 2

    act_val = mass
    fuel_sum = 0
    while True:
        act_val = f(act_val)
        if act_val < 0:
            break

        fuel_sum += act_val
    return fuel_sum


assert calc_fuel(100756) == 50346

print(sum([calc_fuel(mass) for mass in masses]))
