# Read the input script
with open('sociopatterns-infectious.txt', 'r') as file:
    lines = file.readlines()

# Process the data, removing the Edge ID and Timestamp columns
processed_lines = set()
for line in lines:
    # Skip lines starting with "%"
    if line.startswith("%"):
        continue
    
    # Split the line into columns
    columns = line.strip().split()
    
    # Keep only the Source and Target columns
    processed_line = " ".join(columns[:2]) + "\n"
    
    processed_lines.add(processed_line)

# Write the result to a new file
with open('sociopatterns-infectious.txt', 'w') as file:
    for entry in processed_lines:
        file.write(entry)

print("Script processed successfully. Check 'output_script.txt'.")

