# Initialize an empty dictionary to store the assignments
assignments = {}

# Open the file for reading
with open('rho_out_assignment.v', 'r') as file:
    # Iterate through each line in the file
    for line in file:
        # Split the line into parts using '=' as the delimiter
        parts = line.strip().split('=')
        
        # Ensure there are exactly two parts (lhs and rhs)
        if len(parts) == 2:
            # Trim leading and trailing whitespace from both parts
            lhs = parts[0].strip()
            rhs = parts[1].strip()
            
            # Remove "assign" from the beginning of lhs
            if lhs.startswith("assign "):
                lhs = lhs[len("assign "):]
                
            lhs = lhs.replace("rho_out", "pi_in")
            # Store the assignment in the dictionary
            assignments[lhs] = rhs

# Now, the 'assignments' dictionary contains the mappings
# between the modified left-hand side and right-hand side of each assignment

    
with open('pi_out_assignments.v', 'r') as input_file:
    # Create an output file for the modified assignments
    with open('rhoin_to_piout_assignment.v', 'w') as output_file:
        for line in input_file:
            for key, value in assignments.items():
                line = line.replace(key, value)
            output_file.write(line)