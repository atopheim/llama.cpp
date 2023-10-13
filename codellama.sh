#!/bin/bash

# Default values
num_tokens=1024
input_file=""
prompt=""

while getopts "n:i:p:" opt; do
  case $opt in
    n)
      num_tokens="$OPTARG"
      ;;
    i)
      input_file="$OPTARG"
      ;;
    p)
      prompt="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Check if both input file and prompt are provided
if [ -n "$input_file" ] && [ -n "$prompt" ]; then
  echo "Usage: llama -i <input_file> OR llama -p <prompt>"
  exit 1
fi

# Generate a timestamp for the output file
timestamp=$(date +%Y%m%d%H%M%S)

# Define the output file path
output_file="/home/torbjorn/Documents/llamas/output_${timestamp}.txt"

# Path to the llama.cpp/main executable
llama_executable="/home/torbjorn/Documents/Github/atopheim/llama.cpp/main"

# Path to the llama model
llama_model="/home/torbjorn/Documents/Github/atopheim/llama.cpp/models/34B/ziya-coding-34b-v1.0.Q4_K_M.gguf"

# Construct the command to run
command="$llama_executable -m $llama_model -n $num_tokens -c 2048"

# Check if an input file is provided and set the input prompt accordingly
if [ -n "$input_file" ]; then
  if [ ! -f "$input_file" ]; then
    echo "Input file not found: $input_file"
    exit 1
  fi
  prompt="$(cat "$input_file")"
fi

# Double-quote prompt variable for correct formatting
prompt="""<human>:
$prompt
<bot>:
"""

command="$command -p \"$prompt\""

# Execute the command and save both to the file and print to the terminal
eval "$command" | tee "$output_file"

# Print a message indicating the output file path
echo "Output written to: $output_file"
