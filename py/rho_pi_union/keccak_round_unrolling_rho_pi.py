# Define the dimensions and N value
N = 64  # Assuming N is 64 for i ranging from 0 to 63
pi_in = [[[0 for _ in range(N)] for _ in range(5)] for _ in range(5)]

# Specify the output file name
output_file = "pi_out_assignments.v"

# Open the output file for writing
with open(output_file, "w") as file:
    # Loop through y, x, and i
    for y in range(5):
        for x in range(5):
            for i in range(N):
                # Generate the assignment statement and write it to the file
                assignment = f"assign pi_out[{(2 * x + 3 * y) % 5}][{0 * x + 1 * y}][{i}] = pi_in[{y}][{x}][{i}];\n"
                file.write(assignment)

print(f"Unrolled assignments written to {output_file}")

# Initialize an empty string to store the unrolled code
unrolled_code = ""

# Loop for each expression block
for block_num in range(1, 6):  # There are 5 blocks with indices from 1 to 5
    for i in range(64):
        if block_num == 1:
            unrolled_code += f"assign rho_out[0][0][{i}] = rho_in[0][0][{i}];\n"
        elif block_num == 2:
            result = (i-1) & 63
            unrolled_code += f"assign rho_out[0][1][{i}] = rho_in[0][1]["+ str(result) + "];\n"
        elif block_num == 3:
            result = (i-62) & 63
            unrolled_code += f"assign rho_out[0][2][{i}] = rho_in[0][2]["+ str(result) + "];\n"
        elif block_num == 4:
            result = (i-28) & 63
            unrolled_code += f"assign rho_out[0][3][{i}] = rho_in[0][3]["+ str(result) + "];\n"
        elif block_num == 5:
            result = (i-27) & 63
            unrolled_code += f"assign rho_out[0][4][{i}] = rho_in[0][4]["+ str(result) + "];\n"

unrolled_code += f"\n"

for block_num in range(11, 16):  # There are 5 blocks with indices from 11 to 15
    for i in range(64):
        if block_num == 11:
            result = (i-36) & 63
            unrolled_code += f"assign rho_out[1][0][{i}] = rho_in[1][0]["+ str(result) + "];\n"
        elif block_num == 12:
            result = (i-44) & 63
            unrolled_code += f"assign rho_out[1][1][{i}] = rho_in[1][1]["+ str(result) + "];\n"
        elif block_num == 13:
            result = (i-6) & 63
            unrolled_code += f"assign rho_out[1][2][{i}] = rho_in[1][2]["+ str(result) + "];\n"
        elif block_num == 14:
            result = (i-55) & 63
            unrolled_code += f"assign rho_out[1][3][{i}] = rho_in[1][3]["+ str(result) + "];\n"
        elif block_num == 15:
            result = (i-20) & 63
            unrolled_code += f"assign rho_out[1][4][{i}] = rho_in[1][4]["+ str(result) + "];\n"

unrolled_code += f"\n"

# Loop for each expression block
for block_num in range(21, 26):  # There are 5 blocks with indices from 21 to 25
    for i in range(64):
        if block_num == 21:
            result = (i-3) & 63
            unrolled_code += f"assign rho_out[2][0][{i}] = rho_in[2][0]["+ str(result) + "];\n"
        elif block_num == 22:
            result = (i-10) & 63
            unrolled_code += f"assign rho_out[2][1][{i}] = rho_in[2][1]["+ str(result) + "];\n"
        elif block_num == 23:
            result = (i-43) & 63
            unrolled_code += f"assign rho_out[2][2][{i}] = rho_in[2][2]["+ str(result) + "];\n"
        elif block_num == 24:
            result = (i-25) & 63
            unrolled_code += f"assign rho_out[2][3][{i}] = rho_in[2][3]["+ str(result) + "];\n"
        elif block_num == 25:
            result = (i-39) & 63
            unrolled_code += f"assign rho_out[2][4][{i}] = rho_in[2][4]["+ str(result) + "];\n"

unrolled_code += f"\n"

for block_num in range(31, 36):  # There are 5 blocks with indices from 31 to 35
    for i in range(64):
        if block_num == 31:
            result = (i-41) & 63
            unrolled_code += f"assign rho_out[3][0][{i}] = rho_in[3][0]["+ str(result) + "];\n"
        elif block_num == 32:
            result = (i-45) & 63
            unrolled_code += f"assign rho_out[3][1][{i}] = rho_in[3][1]["+ str(result) + "];\n"
        elif block_num == 33:
            result = (i-15) & 63
            unrolled_code += f"assign rho_out[3][2][{i}] = rho_in[3][2]["+ str(result) + "];\n"
        elif block_num == 34:
            result = (i-21) & 63
            unrolled_code += f"assign rho_out[3][3][{i}] = rho_in[3][3]["+ str(result) + "];\n"
        elif block_num == 35:
            result = (i-8) & 63
            unrolled_code += f"assign rho_out[3][4][{i}] = rho_in[3][4]["+ str(result) + "];\n"

unrolled_code += f"\n"

for block_num in range(41, 46):  # There are 5 blocks with indices from 41 to 45
    for i in range(64):
        if block_num == 41:
            result = (i-18) & 63
            unrolled_code += f"assign rho_out[4][0][{i}] = rho_in[4][0]["+ str(result) + "];\n"
        elif block_num == 42:
            result = (i-2) & 63
            unrolled_code += f"assign rho_out[4][1][{i}] = rho_in[4][1]["+ str(result) + "];\n"
        elif block_num == 43:
            result = (i-61) & 63
            unrolled_code += f"assign rho_out[4][2][{i}] = rho_in[4][2]["+ str(result) + "];\n"
        elif block_num == 44:
            result = (i-56) & 63
            unrolled_code += f"assign rho_out[4][3][{i}] = rho_in[4][3]["+ str(result) + "];\n"
        elif block_num == 45:
            result = (i-14) & 63
            unrolled_code += f"assign rho_out[4][4][{i}] = rho_in[4][4]["+ str(result) + "];\n"


# Write the unrolled code to a file
with open('rho_out_assignment.v', 'w') as output_file:
    output_file.write(unrolled_code)

print("Unrolled code has been written to 'rho_out_assignment.v'.")


