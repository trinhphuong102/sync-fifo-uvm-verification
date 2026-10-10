import os
import subprocess
import shutil
import sys
import argparse

QUESTA_BIN = r"E:\questaaa\win64"

# Đường dẫn trỏ tới các file thực thi
VLIB = os.path.join(QUESTA_BIN, "vlib.exe")
VLOG = os.path.join(QUESTA_BIN, "vlog.exe")
VSIM = os.path.join(QUESTA_BIN, "vsim.exe")

COMPILE_FILES = [
    "../rtl/sync_fifo.sv",
    "../tb/fifo_if.sv",
    "../tb/fifo_top.sv",
]

def run_command(cmd):
    print(f"\n[EXEC] {cmd}")
    result = subprocess.run(cmd, shell=True)
    
    if result.returncode != 0:
        print(f"\n[ERROR] Command failed: {cmd}")
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description="Python script to run UVM simulation on QuestaSim")
    parser.add_argument('-gui', action='store_true', help="Open QuestaSim GUI for waveform debugging")
    args = parser.parse_args()

    print("==================================================")
    print("       STARTING COMPILATION AND SIMULATION        ")
    print("==================================================")

    if os.path.exists("work"):
        print("[CLEAN] Removing old 'work' library...")
        shutil.rmtree("work")
    
    run_command(f'"{VLIB}" work')

    for file in COMPILE_FILES:
        run_command(f'"{VLOG}" -sv +incdir+../tb {file}')

    print("\n[INFO] Compilation successful! Starting simulation...\n")

    if args.gui:
        with open("wave.do", "w") as f:
            f.write("add wave -position insertpoint sim:/tb_top/vif/*\n")
            f.write("run -all\n")
        
        vsim_cmd = f'"{VSIM}" -voptargs=+acc -uvmcontrol=all work.tb_top -do wave.do'
        run_command(vsim_cmd)
    else:
        vsim_cmd = f'"{VSIM}" -c -voptargs=+acc work.tb_top -do "run -all; quit"'
        run_command(vsim_cmd)

    print("\n==================================================")
    print("               SIMULATION COMPLETED               ")
    print("==================================================")

if __name__ == "__main__":
    main()