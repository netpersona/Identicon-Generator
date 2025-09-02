WIDTH=256
HEIGHT=256
BLOCKS=8
BLOCK_SIZE=$((WIDTH / BLOCKS))
OUTPUT="profile.ppm"

USERNAME="$1"
if [[ -z "$USERNAME" ]]; then
  echo "Usage: $0 <username>"
  exit 1
fi

# Create seed from username
SEED=$(echo -n "$USERNAME" | cksum | awk '{print $1}')
RANDOM=$SEED

# Random colors (deterministic from seed)
BG_R=$((RANDOM % 256))
BG_G=$((RANDOM % 256))
BG_B=$((RANDOM % 256))

FG_R=$((RANDOM % 256))
FG_G=$((RANDOM % 256))
FG_B=$((RANDOM % 256))

# Generate symmetrical pattern
pattern=()
for ((y=0; y<BLOCKS; y++)); do
  row=()
  for ((x=0; x<BLOCKS/2; x++)); do
    if (( RANDOM % 2 )); then
      row+=("1")   # filled
    else
      row+=("0")   # empty
    fi
  done
  # Mirror row
  for ((x=BLOCKS/2-1; x>=0; x--)); do
    row+=("${row[$x]}")
  done
  pattern+=("${row[@]}")
done

# Write PPM header
{
  echo "P3"
  echo "$WIDTH $HEIGHT"
  echo "255"
} > "$OUTPUT"

# Write pixels
for ((y=0; y<HEIGHT; y++)); do
  for ((x=0; x<WIDTH; x++)); do
    block_x=$((x / BLOCK_SIZE))
    block_y=$((y / BLOCK_SIZE))
    idx=$((block_y * BLOCKS + block_x))
    if [[ ${pattern[$idx]} == "1" ]]; then
      echo "$FG_R $FG_G $FG_B"
    else
      echo "$BG_R $BG_G $BG_B"
    fi
  done
done >> "$OUTPUT"

echo "Generated identicon for '$USERNAME': $OUTPUT"
