def print_partition(partition, partitions, names, gamma_estimates):
    print("------------------------------------------------------------------------")
    print("PARTITION SET with", max(partition) + 1, "COMMUNITIES:")
    print("------------------------------------------------------------------------")
    
    for x in gamma_estimates:
        if x[2] == partition:
            print("GAMMA = ", x[3])
    
    for community in sorted(set(partition)):
        indices = []
        for i, j in enumerate(partition):
            if j == community:
                indices += [i]
        print("------------------------------------------------------------------------")
        print("COMMUNITY", community, "with", len(indices), "nodes:")
        community_names = []
        for i in indices:
            community_names += [names[i]]
        print(set(community_names))
