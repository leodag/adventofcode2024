def parse_file(filename):
    lines = None
    with open(filename, 'r') as f:
        lines = f.read().splitlines()

    lines_iter = iter(lines)

    dependencies = []

    for line in lines_iter:
        if line == '':
            break

        dependencies.append(list(map(lambda x: int(x), line.split('|'))))

    orders = []
    for line in lines_iter:
        orders.append(list(map(lambda x: int(x), line.split(','))))

    return dependencies, orders

def respects_pageorder(order, order_dependencies):
    printed = set()

    for page in order:
        dependencies = order_dependencies.get(page, set())

        for dependency in dependencies:
            if dependency not in printed:
                return False

        printed.add(page)

    return True

def order_dependencies(order, dependencies):
    pageset = set(order)
    order_dependencies = {}

    for [depended, dependent] in dependencies:
        if depended in pageset and dependent in pageset:
            order_dependencies.setdefault(dependent, set())
            order_dependencies[dependent].add(depended)

    return order_dependencies

def order_dependers(order, dependencies):
    pageset = set(order)
    order_dependers = {}

    for [depended, dependent] in dependencies:
        if depended in pageset and dependent in pageset:
            order_dependers.setdefault(depended, set())
            order_dependers[depended].add(dependent)

    return order_dependers


def part1(filename = 'input'):
    dependencies, orders = parse_file(filename)

    midpage_sum = 0
    for order in orders:
        if respects_pageorder(order, order_dependencies(order, dependencies)):
            midpage_sum += order[len(order)//2]

    print(midpage_sum)

def part2(filename = 'input'):
    dependencies, orders = parse_file(filename)

    incorrect_orders_and_maps = filter(lambda item: not item[2], map(lambda order: (order, (order_deps := order_dependencies(order, dependencies)), respects_pageorder(order, order_deps)), orders))

    midpage_sum = 0

    for order, order_deps, _ in incorrect_orders_and_maps:
        pageset = set(order)

        orderdependers = order_dependers(order, dependencies)

        viable_pages = []
        for page in pageset:
            if len(order_deps.get(page, set())) == 0:
                viable_pages.append(page)

        neworder = []
        while len(viable_pages) > 0:
            page = viable_pages.pop()
            neworder.append(page)

            for dependent in orderdependers.get(page, set()):
                order_deps[dependent].remove(page)
                if len(order_deps[dependent]) == 0:
                    viable_pages.append(dependent)

        midpage_sum += neworder[len(order)//2]

    print(midpage_sum)
