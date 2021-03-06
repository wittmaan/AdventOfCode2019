import fileinput
from collections import defaultdict

# --- Day 6: Universal Orbit Map ---
# --- Part one ---

map_data = [x.strip() for x in fileinput.input()]


def fill_dict(data):
    dd = defaultdict(list)
    for d in data:
        key, value = d.split(')')
        dd[key].append(value)
    return dd


def calc_orbit(data, obj):
    n_orbits = 0
    for key, value in data.items():
        if obj in value:
            # print("key={}, value={}".format(key, value))

            # direct orbits
            n_orbits += 1
            # indirect orbits
            n_orbits += calc_orbit(data, key)
    return n_orbits


sample_map_data = ['COM)B', 'B)C', 'C)D', 'D)E', 'E)F', 'B)G', 'G)H', 'D)I', 'E)J', 'J)K', 'K)L']
tmp = fill_dict(sample_map_data)

assert calc_orbit(tmp, 'COM') == 0
assert calc_orbit(tmp, 'B') == 1
assert calc_orbit(tmp, 'C') == 2
assert calc_orbit(tmp, 'G') == 2
assert calc_orbit(tmp, 'H') == 3
assert calc_orbit(tmp, 'D') == 3
assert calc_orbit(tmp, 'I') == 4
assert calc_orbit(tmp, 'E') == 4
assert calc_orbit(tmp, 'J') == 5
assert calc_orbit(tmp, 'K') == 6
assert calc_orbit(tmp, 'L') == 7


def calc_total_orbits(data):
    n_orbits = 0
    objects = set()
    for x in data.keys():
        objects.add(x)
    for value in data.values():
        for v in value:
            objects.add(v)

    for key in objects:
        n_orbits += calc_orbit(data, key)
    return n_orbits


total_orbits = calc_total_orbits(fill_dict(map_data))
print(total_orbits)

# 142497

# --- Part two ---

sample_map_data = ['COM)B', 'B)C', 'C)D', 'D)E', 'E)F', 'B)G', 'G)H', 'D)I', 'E)J', 'J)K', 'K)L', 'K)YOU', 'I)SAN']
tmp = fill_dict(sample_map_data)


def get_path(data, obj):
    path = []
    for key, value in data.items():
        if obj in value:
            path.append(key)
            sub_path = get_path(data, key)
            [path.append(x) for x in sub_path]
    return path


def calc_orbital_transfers(data, source, target):
    path_source = get_path(data, source)
    path_target = get_path(data, target)
    n_transfers = 0
    intersection_found = False
    for idx1, val1 in enumerate(path_source):
        for idx2, val2 in enumerate(path_target):
            if val1 == val2:
                n_transfers += idx1
                n_transfers += idx2
                intersection_found = True
                break
        if intersection_found:
            break
    return n_transfers


total_transfers = calc_orbital_transfers(fill_dict(map_data), 'YOU', 'SAN')
print(total_transfers)

# 301
