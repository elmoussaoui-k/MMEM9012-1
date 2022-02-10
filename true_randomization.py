import random
dels = ["KE002", "KE003", "KE011", "KE020", "KE027", "KE041", "KE042", "KE053",
        "KE055", "KE056", "KE057", "KE058", "KE061"]
max = 75
n = input("How many samples would you like to select ? Enter an integer between 1 and " + str(max) + " : ")

def get_sample_list():
    tot = []
    for sample in range(1, 10):
        prefix_1 = "KE00"
        tot.append(prefix_1 + str(sample))
    for sample in range(10, max+1):
        prefix_2 = "KE0"
        tot.append(prefix_2 + str(sample))
    samples = [x for x in tot if x not in dels]
    return (samples)

def true_random():
    selection = []
    while len(selection) < int(n):
        req = random.SystemRandom().choices(get_sample_list(), k=1)
        if req not in selection:
            selection.append(req)
    return selection

print(true_random())
