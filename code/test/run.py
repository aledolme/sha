import subprocess

# Define your GDB commands as a multi-line string
gdb_commands = """
    set logging file assembly_trace.txt
    set logging on
    set height 0
    set width 0
    while 1
    py $ip
    stepi
    end
    quit
"""

# Define the GDB command to execute your program and run the specified commands
gdb_command = f"riscv32-unknown-elf-gdb -ex 'file myprogram' -ex 'target sim' -ex 'load'"

# Execute the GDB command
subprocess.call(gdb_command, shell=True)
