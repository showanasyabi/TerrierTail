import numpy as np
import sys


folder_path = sys.argv[1]
file_numbers = int(sys.argv[2])
percentile = float(sys.argv[3])
print(folder_path, file_numbers, percentile)

temp_array = []
total_array = []

for i in range(1, file_numbers + 1):
    path = folder_path + '/' + "log" + str(i) + ".log"
    temp_array = np.loadtxt(path, skiprows=1)
    for j in temp_array:
        total_array.append(j)
    temp_array = []

total_array = np.array(total_array)
print("percentile", np.percentile(total_array, percentile))

