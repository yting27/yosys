#!/home/yting27/.pyenv/versions/3.11.11/bin/python3

# Example: ./extract_cell_data.py -l /mnt/c/Users/ngyen/Documents/Projects/rtl_projects/yosys/examples/test_sog/NangateOpenCellLibrary_typical.lib -o /mnt/c/Users/ngyen/Documents/Projects/rtl_projects/yosys/examples/test_sog/nangate_lib.yaml

import os, re, yaml
import argparse

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description ='Extract cell average leakage power & area from Liberty file.')
    parser.add_argument('--lib_path',    '-l', type=str, help ='Liberty file path as input.', required=True)
    parser.add_argument('--output_path', '-o', type=str, help ='YAML file path to save the extracted cell data.', required=True)

    args = parser.parse_args()

    if os.path.exists(args.lib_path) == False:
        print("Liberty file does not exist.")
        exit(1)

    full_cell_data = []
    with open(args.lib_path, "r") as fread:
        has_cell = False
        done_one_cell = False
        cell_data = {} # name, area, leakage
        with open(args.output_path, "w+") as fwrite:
            for line in fread:
                match_cell = re.search(r'^\s*cell\s+\((\w+)\)', line)
                if match_cell:
                    has_cell = True
                    cell_data["name"] = match_cell.group(1)
                elif has_cell:
                    match_area = re.search(r'^\s*area\s*:\s*([\d\.]+);', line)

                    if match_area:
                        cell_data["area"] = float(match_area.group(1))
                        continue

                    match_leakage = re.search(r'^\s*cell_leakage_power\s*:\s*([\d\.]+);', line)
                    if match_leakage:
                        cell_data["power"] = float(match_leakage.group(1))
                        done_one_cell = True

                if done_one_cell:
                    # Save the extracted data to a YAML file
                    full_cell_data.append(cell_data)
                    # Reset for the next cell
                    has_cell = False
                    cell_data = {}
                    done_one_cell = False

    # Write the extracted data to a YAML file
    with open(args.output_path, 'w') as outfile:
        liberty_data = {
            "liberty_file": args.lib_path,
            "cells": full_cell_data
        }

        yaml.dump(liberty_data, outfile, sort_keys=False)
        print(f"Extracted cell data saved to {args.output_path}")

    print("Extraction done.")
