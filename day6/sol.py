orientations = [(-1, 0), (0, 1), (1, 0), (0, -1)]

def parse_file(filename):
    lines = None
    with open(filename, 'r') as f:
        lines = f.read().splitlines()

    floor_map = list(map(lambda line: list(line), lines))

    for i_row, row in enumerate(floor_map):
        for i_col, position in enumerate(row):
            if position == '^':
                start_pos = (i_row, i_col)
                floor_map[i_row][i_col] = 'X'

    orientation = 0
    return floor_map, start_pos, orientation

def part1(filename = 'input'):
    floor_map, (posx, posy), orientation = parse_file(filename)

    floorx = len(floor_map)
    floory = len(floor_map[0])

    visited = 1

    while True:
        orientationx, orientationy = orientations[orientation]

        newx, newy = posx + orientationx, posy + orientationy

        if newx < 0 or newx >= floorx or newy < 0 or newy >= floory:
            break

        if floor_map[newx][newy] == '#':
            orientation = (orientation + 1) % len(orientations)
            continue

        if floor_map[newx][newy] == '.':
            floor_map[newx][newy] = 'X'
            visited += 1

        # print(('b', visited, posx, posy, orientations[orientation]))
        # print('\n'.join(map(lambda line: ''.join(line), floor_map)))
        posx, posy = newx, newy

    print(visited)
