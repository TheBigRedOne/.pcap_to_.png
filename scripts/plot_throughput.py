# scripts/plot_throughput.py

import matplotlib.pyplot as plt
import csv
import sys
import os

def plot_throughput(csv_file):
    times = []
    throughput = []

    with open(csv_file, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            times.append(int(row['time']))
            throughput.append(int(row['throughput']))

    plt.figure(figsize=(10, 5))
    plt.plot(times, throughput, label='Throughput')
    plt.xlabel('Time (seconds)')
    plt.ylabel('Throughput (bytes)')
    plt.title('Network Throughput Over Time')
    plt.legend()
    plt.grid(True)
    output_file = os.path.splitext(csv_file)[0] + '.png'
    plt.savefig(output_file)
    plt.show()

if __name__ == "__main__":
    plot_throughput(sys.argv[1])
