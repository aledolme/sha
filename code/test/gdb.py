import subprocess

# Set the path to your GDB executable and the name of your program
gdb_path = 'riscv32-unknown-elf-gdb'
program_name = 'myprogram'

# Create a list of GDB commands to run
gdb_commands = [
    f'file {program_name}',
    'set logging file execution.log',
    'set logging on',
    'break main',  # Set a breakpoint at the beginning of the program
    'run',
]

# Execute GDB and run the initial commands
gdb_process = subprocess.Popen([gdb_path, '--batch', '--command=/dev/stdin'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
gdb_input = '\n'.join(gdb_commands).encode('utf-8')
gdb_output, _ = gdb_process.communicate(input=gdb_input)

# Log all instructions to a file
with open('assembly_trace.txt', 'w') as assembly_file:
    gdb_commands = [
        'set logging file assembly_trace.txt',
        'set logging on',
        'set height 0',
        'set width 0',
        'while 1',
        'py $ip',
        'stepi',
        'end',
        'quit'
    ]
    gdb_input = '\n'.join(gdb_commands).encode('utf-8')
    gdb_process = subprocess.Popen([gdb_path, '--batch', '--command=/dev/stdin'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    gdb_output, _ = gdb_process.communicate(input=gdb_input)
