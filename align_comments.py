import argparse

def align_comments(file_path, comment_column=40):
    with open(file_path, 'r') as f:
        lines = f.readlines()

    formatted_lines = []
    for line in lines:
        stripped_line = line.lstrip()

        # Preserve lines where the first non-space character is a comment
        if stripped_line.startswith(';'):
            formatted_lines.append(line)
        elif ';' in line:  # Handle lines with inline comments
            parts = line.split(';', 1)
            code = parts[0].rstrip()  # Code part
            comment = '; ' + parts[1].strip()  # Comment part, add consistent space
            # Align the comment to the specified column
            formatted_line = f"{code:<{comment_column - 1}}{comment}\n"
            formatted_lines.append(formatted_line)
        elif stripped_line:  # Handle code-only lines (non-empty, non-comment)
            formatted_lines.append(line.rstrip() + '\n')
        else:  # Preserve empty lines
            formatted_lines.append(line)

    # Write the formatted lines back to the file
    with open(file_path, 'w') as f:
        f.writelines(formatted_lines)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Align comments in 6502 assembly files.")
    parser.add_argument("file", help="The file to process.")
    parser.add_argument("--column", type=int, default=30, help="Column to align comments (default: 40).")

    args = parser.parse_args()

    align_comments(args.file, comment_column=args.column)
