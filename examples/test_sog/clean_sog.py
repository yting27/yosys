#!/home/yting27/.pyenv/versions/3.11.11/bin/python3

import os, re
import argparse

def vlg_clean(file, out_file=None):
    file_tmp = file + ".tmp"
    os.system(f"cp {file} {file_tmp}")
    saved_sv_file = out_file if out_file else file
    print("Saved", saved_sv_file)

    with open(file_tmp, "r") as fr:
        lines = fr.readlines()

        with open(saved_sv_file, "w+") as f_tmp:
            for line in lines:
                # Remove (* ... *)
                line = re.sub(r'\(\*(.*)\*\)', '', line)
                if line.strip():
                    f_tmp.writelines(line)
    os.remove(file_tmp)


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description ='Clean up the SOG file.')
    parser.add_argument('--file_path', '-f', type=str, help ='Design netlist file path.', required=True)
    parser.add_argument('--output_path', '-o', type=str, help ='Design netlist file after cleanup.', required=False)

    args = parser.parse_args()

    vlg_clean(args.file_path, args.output_path)

    print("Clean up done.")