import re
import matplotlib.pyplot as plt
from random import random

# Function to extract numeric values from a string
def extract_numeric(string):
    try:
        return float(re.sub(r'[^\d.]', '', string))
    except ValueError:
        return None

# Read the LaTeX table from a file
with open('table.tex', 'r') as file:
    # Read the file line by line
    lines = file.readlines()

# Initialize a flag to indicate whether to start processing
start_processing = False

# Initialize a dictionary to store data for each reference
reference_data = {}

# Create a dictionary to map reference names to custom numbers
reference_numbers = {}

# Read the reference names and numbers from a separate file
with open('reference_numbers.txt', 'r') as num_file:
    for line in num_file:
        name, number = line.strip().split(' ')
        reference_numbers[name] = number

# Iterate through the lines in the file
for line in lines:
    # Check if the line contains the start of the data section
    if re.match(r'^\\cite{Provelengios2012}', line):
        start_processing = True
        continue

    # Check if we should stop processing
    if not start_processing:
        continue

    # Split the line by the '&' character
    cells = [cell.strip() for cell in line.split("&")]
    
    # Extract the reference from the first cell (ignore \cite{})
    reference = re.search(r'\\cite{(.*?)}', cells[0]).group(1)
    area = extract_numeric(cells[3])
    efficiency = extract_numeric(cells[-1])

    # Store data in the dictionary with reference as the key
    reference_data[reference] = {
        "Area": area,
        "Efficiency": efficiency
    }

# Create the scatter plot
plt.figure(figsize=(12, 6))  # Increase the width to accommodate the legend

# Define markers and colors with additional options (excluding white)
markers = ['o', 's', '^', 'D', 'v', 'p', '*', 'H', '+', 'x', '|', '_', '1', '2', '3', '4', '8', '<', '>', 'h', 'd', ',', '.', '1', '2', '3', '4', '8', '<', '>', 'o', 's', '^', 'D', 'v', 'p', '*', 'H', '+']
colors = ['b', 'g', 'r', 'c', 'm', 'y', '#FF5733', '#FFBD33', '#33FFA8', '#337CFF', '#6B33FF', '#FF338A', '#33FFE9', '#334CFF', '#AD33FF', '#33FF6B', '#FF334D', '#CC33FF', '#FF339E', '#33FF26', '#7A33FF', '#FF3365', '#33FFD6', '#E633FF', '#33FF0D', '#5733FF', '#FF33BB', '#33FF88', '#FF33A2', 'y']

# Extend the lists to have at least 40 elements
markers *= 2
colors *= 2

used_label_positions = []

for i, reference in enumerate(reference_data):
    data = reference_data[reference]
    marker = markers[i % len(markers)]
    color = colors[i % len(colors)]

    # Generate random offsets to prevent label overlap
    x_offset = 0.02 * random() - 0.01
    y_offset = 0.02 * random() - 0.01

    # Determine label position based on index
    if i % 2 == 0:
        label_x = data["Area"] + x_offset + 0.005
        label_y = data["Efficiency"] + y_offset + 0.005
    else:
        label_x = data["Area"] + x_offset - 0.005
        label_y = data["Efficiency"] + y_offset - 0.005

            
        
    plt.scatter(data["Area"], data["Efficiency"], marker=marker, color=color, label=reference, s=100)  # Increase point size

    # Annotate the point with a label using the custom number from reference_numbers.txt
    plt.annotate(
        reference_numbers.get(reference, reference),
        (label_x, label_y),
        textcoords="offset points",
        xytext=(10, -2),
        fontsize=14,
    )
    #plt.legend(
    #    bbox_to_anchor=(1.02, 1),
    #    loc='upper left',
    #    ncol=2,
    #    labels=[reference_numbers.get(ref, ref) for ref in reference_data.keys()]
    #)


plt.xlabel("Area [Slices]", fontsize=18)
plt.ylabel("Efficiency [Mbps/Slices]", fontsize=18)
plt.title("Efficiency vs. Area",fontsize=20)
plt.grid(True)

# Move the legend outside the plot to the upper right corner with two columns
#plt.legend(bbox_to_anchor=(1.02, 1), loc='upper left', ncol=2)

# Use LaTeX for rendering text
plt.rc('text', usetex=True)
plt.tight_layout()  # Ensure tight layout to prevent clipping of labels
plt.show()
