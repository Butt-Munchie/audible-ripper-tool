# This script was created with the use of AI

# This script helps facillitate this ffmpeg script
# ffmpeg -activation_bytes 'hex code' -i 'InputAudiobook.aax' -c copy 'OutputAudiobook.m4b'
# It loops through all audiobooks in a given directory.

set -e

# Check that ffmpeg is installed
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "Error: ffmpeg is not installed or not found in PATH."
    echo "Please install ffmpeg and try again."
    exit 1
fi

# Prompt for directory
read -rp "Enter the directory containing .aax files: " TARGET_DIR
TARGET_DIR=$(eval echo "$TARGET_DIR")

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: Directory does not exist."
    exit 1
fi

# Find .aax files
shopt -s nullglob
AAX_FILES=("$TARGET_DIR"/*.aax)
shopt -u nullglob

if (( ${#AAX_FILES[@]} == 0 )); then
    echo "No .aax files found in $TARGET_DIR"
    exit 0
fi

# Prompt for hex code
echo "Have your hex key ready. If you don't have your hex code, you will need to retrieve it."
read -rp "Enter activation bytes (hex code): " HEX_CODE
if [[ -z "$HEX_CODE" ]]; then
    echo "Hex Code bytes cannot be empty."
    exit 1
fi

# Arrays to store input/output pairs
INPUT_FILES=()
OUTPUT_FILES=()

echo
echo "Specify output filenames (press Enter to accept default):"
echo

# Ask for output filenames FIRST
for INPUT_FILE in "${AAX_FILES[@]}"; do
    BASENAME=$(basename "$INPUT_FILE")
    DEFAULT_OUTPUT="${BASENAME%.aax}.m4b"

    read -rp "$BASENAME → [$DEFAULT_OUTPUT]: " OUTPUT_NAME
    OUTPUT_NAME=${OUTPUT_NAME:-$DEFAULT_OUTPUT}

    INPUT_FILES+=("$INPUT_FILE")
    OUTPUT_FILES+=("$TARGET_DIR/$OUTPUT_NAME")
done

echo
echo "Starting conversions..."
echo

# Run conversions AFTER all prompts
for i in "${!INPUT_FILES[@]}"; do
    echo "Converting:"
    echo "  Input : ${INPUT_FILES[$i]}"
    echo "  Output: ${OUTPUT_FILES[$i]}"

    ffmpeg \
        -activation_bytes "$HEX_CODE" \
        -i "${INPUT_FILES[$i]}" \
        -c copy \
        "${OUTPUT_FILES[$i]}"

    echo "Done."
    echo
done

echo "All conversions completed."
