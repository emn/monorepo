#!/bin/bash
cat file_name_changes.txt | sed 's|\\|/|g' > unix_file_name_changes.txt
cat path_name_changes.txt | sed 's|\\|/|g' > unix_path_name_changes.txt
while read -r file1 file2; do cp -v -- "$file1" "$file2"; done <unix_file_name_changes.txt
while read -r file1 file2; do cp -v -r -- "$file1/" "$file2"; done <unix_path_name_changes.txt
while read -r file1 file2; do cp -v -- "$file1" "$file2"; done <unix_file_name_changes.txt
