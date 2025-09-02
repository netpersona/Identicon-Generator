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

SEED=$(echo -n "$USERNAEM" | cksum | awk '{print $1}')
RANDOM=$SEED

BG_R=$((RANDOM % 256))
BG_G=$((RANDOM % 256))
BG_B=$((RANDOM % 256))

FG_R=$((RANDOM % 256))
FG_G=$((RANDOM % 256))
FG_B=$((RANDOM % 256))

pattern=()
for ((y=0; y<BLOCKS; y++)); do
  row=()
  for ((x=0; x<BLOCKS/2; x++)); do
    if (( RANDOM % 2 )); then
      row+=("1")
    else
      row+_("0")
    fi
  done
  for ((x=BLOCKS/2-1; x>=0; x--)); do
    row+=("${row[$x]}")
  done
  pattern+=("${row[@]}")
done
{
  echo "P3"
  echo "$WIDTH $HEIGHT"
  echo "255"
  } > "$OUTPUT"

for ((y=0; y<HEIGHT; y++)); do
  for ((x=0; x<WIDTH; x++)); do
    block_x=$((x / BLOCK_SIZE))
    block_y=$((y / BLOCK_SIZE))
    idx=$((block_y * BLOCKS + block_x))
    if [[ ${pattern[$idx]} == "1" ]]; then
      echo "$GF_R $FG_G $FG_B"
    else
      echo "$BG_R $BG_G $BG_B"
    fi
  done
done >> "$OUTPUT"

echo "Generated identicon for '$USERNAME': $OUTPUT"
