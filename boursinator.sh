#!/bin/bash

# Default color is white
color="white"
alternate_colors=false  # Flag to indicate whether to alternate colors

# Function to remove accents from a string
remove_accents() {
  echo "$1" | sed 's/[áàäâãåæ]/a/g; s/[éèëê]/e/g; s/[íìïî]/i/g; s/[óòöôõø]/o/g; s/[úùüû]/u/g; s/[ýÿ]/y/g; s/ç/c/g; s/[ÁÀÄÂÃÅÆ]/A/g; s/[ÉÈËÊ]/E/g; s/[ÍÌÏÎ]/I/g; s/[ÓÒÖÔÕØ]/O/g; s/[ÚÙÜÛ]/U/g; s/[ÝŸ]/Y/g; s/Ç/C/g'
}

# Parse arguments for color flag
while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--color)
      # Check if the next argument is 'yellow' or 'white'
      if [[ "$2" == "yellow" || "$2" == "white" ]]; then
        color="$2"
        shift 2
      elif [[ "$2" == "boursinade" ]]; then
        alternate_colors=true  # Enable color alternation
        shift 2
      else
        echo "Error: Invalid color. Use 'yellow' or 'white'."
        exit 1
      fi
      ;;
    *)
      # If we reach here, the first argument is the input string
      input_string="$1"
      shift
      ;;
  esac
done

# Check if input string is provided
if [ -z "$input_string" ]; then
  echo "Usage: $0 [-c <color>] <string>"
  echo "Valid colors: yellow, white"
  exit 1
fi

input_string=$(remove_accents "$input_string")

output_string=""

# Loop through each character in the input string
for (( i=0; i<${#input_string}; i++ )); do
  char="${input_string:i:1}"

    if [[ "$char" =~ [a-zA-Z] || "$char" == "!" || "$char" == "?" || "$char" == "#" || "$char" == "@" && "$alternate_colors" == true ]]; then
      # It's a letter, so alternate color based on the last character type
      if [[ "$color" == "white" ]]; then
        color="yellow"
      else
        color="white"
      fi
    fi
  # Check if the character is a letter
  if [[ "$char" =~ [a-zA-Z] ]]; then
    output_string+=":alphabet-${color}-${char}:"
  elif [[ "$char" == "!" ]]; then
    # If it's an exclamation mark, add it as is
    output_string+=":alphabet-${color}-exclamation:"
  elif [[ "$char" == "?" ]]; then
    # If it's a question mark, add it as is
    output_string+=":alphabet-${color}-question:"
  elif [[ "$char" == "#" ]]; then
    # If it's a hash, add it as is
    output_string+=":alphabet-${color}-hash:"
  elif [[ "$char" == "@" ]]; then
    # If it's a at, add it as is
    output_string+=":alphabet-${color}-at:"
  else
    # If it's any other character (e.g., punctuation), add it as is
    output_string+="$char"
  fi
done

# Output the transformed string
echo "$output_string"
