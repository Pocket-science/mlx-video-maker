#!/bin/bash
#
# generate_story.sh - Generate multi-scene AI videos with I2V chaining
#
# Usage: ./generate_story.sh <story_file> <output_dir> [options]
#

set -e

# Auto-background: re-exec under nohup if not already backgrounded
if [ -z "$_MLX_BG" ] && [ -t 0 ]; then
    export _MLX_BG=1
    # Determine log file location (need to peek at args for output dir)
    _LOG_DIR="$HOME/Nextcloud/Documents/mlx-video-stories"
    for _arg in "$@"; do
        if [ -n "$_NEXT_IS_DIR" ]; then _LOG_DIR="$_arg"; unset _NEXT_IS_DIR; break; fi
        [[ "$_arg" == --* ]] && break
        [ "$_SEEN_STORY" = "1" ] && _LOG_DIR="$_arg" && break
        _SEEN_STORY=1
    done
    mkdir -p "$_LOG_DIR"
    _LOG="$_LOG_DIR/generation.log"
    echo "Running in background. Log: $_LOG"
    echo "Follow with: tail -f $_LOG"
    nohup "$0" "$@" > "$_LOG" 2>&1 &
    echo "PID: $!"
    exit 0
fi

# Default settings
WIDTH=1280
HEIGHT=768
FRAMES=121
STRENGTH=0.7
FPS=24
PIPELINE="dev-two-stage-hq"
MODEL_REPO="prince-canuma/LTX-2.3-dev"
VENV_PYTHON="${VENV_PYTHON:-./venv/bin/python}"
OUTPUT_DIR="$HOME/Nextcloud/Documents/mlx-video-stories"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

usage() {

    echo "Usage: $0 <story_file> [output_dir] [options]"
    echo ""
    echo "Arguments:"
    echo "  story_file    Text file with one prompt per line"
    echo "  output_dir    Directory to save output files (default: ./output)"
    echo ""
    echo "Options:"
    echo "  --width       Video width (default: 1920)"
    echo "  --height      Video height (default: 1088)"
    echo "  --frames      Frames per scene (default: 121)"
    echo "  --strength    I2V conditioning strength 0.0-1.0 (default: 0.7)"
    echo "  --fps         Output framerate (default: 24)"
    echo "  --python      Python executable (default: python)"
    echo ""
    echo "Example:"
    echo "  $0 stories/mountain.txt output/ --width 1024 --height 768"
    exit 1
}

# Parse arguments
if [ $# -lt 1 ]; then
    usage
fi

STORY_FILE="$1"
shift 1

# Check if second arg is output dir (not an option starting with --)
if [ $# -gt 0 ] && [[ "$1" != --* ]]; then
    OUTPUT_DIR="$1"
    shift 1
fi

while [ $# -gt 0 ]; do
    case "$1" in
        --width) WIDTH="$2"; shift 2 ;;
        --height) HEIGHT="$2"; shift 2 ;;
        --frames) FRAMES="$2"; shift 2 ;;
        --strength) STRENGTH="$2"; shift 2 ;;
        --fps) FPS="$2"; shift 2 ;;
        --pipeline) PIPELINE="$2"; shift 2 ;;
        --model-repo) MODEL_REPO="$2"; shift 2 ;;
        --python) VENV_PYTHON="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

# Validate inputs
if [ ! -f "$STORY_FILE" ]; then
    echo -e "${RED}Error: Story file not found: $STORY_FILE${NC}"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Read prompts into array (compatible with bash 3, skip comments and empty lines)
PROMPTS=()
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    [[ -z "$line" ]] && continue
    [[ "$line" =~ ^[[:space:]]*$ ]] && continue
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    PROMPTS+=("$line")
done < "$STORY_FILE"
NUM_SCENES=${#PROMPTS[@]}

if [ $NUM_SCENES -eq 0 ]; then
    echo -e "${RED}Error: No prompts found in $STORY_FILE${NC}"
    exit 1
fi

# Get story name from filename
STORY_NAME=$(basename "$STORY_FILE" .txt)

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  mlx-video-maker${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Story: ${GREEN}$STORY_NAME${NC}"
echo -e "Scenes: ${GREEN}$NUM_SCENES${NC}"
echo -e "Resolution: ${GREEN}${WIDTH}x${HEIGHT}${NC}"
echo -e "Frames/scene: ${GREEN}$FRAMES${NC}"
echo -e "I2V strength: ${GREEN}$STRENGTH${NC}"
echo -e "Output: ${GREEN}$OUTPUT_DIR${NC}"
echo ""

# Resolve VENV_PYTHON to absolute path before changing directories
if [[ "$VENV_PYTHON" == ./* ]]; then
    VENV_PYTHON="$(pwd)/${VENV_PYTHON:2}"
fi

# Generate scenes
cd "$OUTPUT_DIR"

for i in $(seq 1 $NUM_SCENES); do
    IDX=$((i-1))
    PROMPT="${PROMPTS[$IDX]}"
    SCENE_FILE="scene${i}.mp4"

    # Skip if already exists
    if [ -f "$SCENE_FILE" ]; then
        echo -e "${YELLOW}Scene $i already exists, skipping...${NC}"
        continue
    fi

    echo ""
    echo -e "${BLUE}=== Scene $i / $NUM_SCENES ===${NC}"
    echo -e "${GREEN}Prompt:${NC} ${PROMPT:0:80}..."
    echo ""

    if [ $i -eq 1 ]; then
        # First scene: Text-to-Video
        $VENV_PYTHON -m mlx_video.models.ltx_2.generate \
            --prompt "$PROMPT" \
            --pipeline $PIPELINE \
            --model-repo $MODEL_REPO \
            --text-encoder-repo google/gemma-3-12b-it \
            --height $HEIGHT \
            --width $WIDTH \
            --num-frames $FRAMES \
            --fps $FPS \
            --seed $((42 + i)) \
            --audio \
            --output-path "$SCENE_FILE"
    else
        # Subsequent scenes: Image-to-Video
        PREV=$((i-1))
        PREV_FILE="scene${PREV}.mp4"
        LAST_FRAME="scene${PREV}_lastframe.jpg"

        # Extract last frame from previous scene
        if [ ! -f "$LAST_FRAME" ]; then
            echo -e "${YELLOW}Extracting last frame from scene $PREV...${NC}"
            FRAME_COUNT=$(ffprobe -v error -select_streams v:0 -count_frames \
                -show_entries stream=nb_read_frames \
                -of default=nokey=1:noprint_wrappers=1 "$PREV_FILE")
            LAST_IDX=$((FRAME_COUNT - 1))
            ffmpeg -i "$PREV_FILE" -vf "select=eq(n\\,$LAST_IDX)" \
                -vframes 1 -q:v 2 "$LAST_FRAME" -y 2>/dev/null
        fi

        # Generate with I2V
        $VENV_PYTHON -m mlx_video.models.ltx_2.generate \
            --prompt "$PROMPT" \
            --pipeline $PIPELINE \
            --model-repo $MODEL_REPO \
            --text-encoder-repo google/gemma-3-12b-it \
            --image "$LAST_FRAME" \
            --image-strength $STRENGTH \
            --height $HEIGHT \
            --width $WIDTH \
            --num-frames $FRAMES \
            --fps $FPS \
            --seed $((42 + i)) \
            --audio \
            --output-path "$SCENE_FILE"
    fi

    echo -e "${GREEN}Scene $i complete!${NC}"
done

echo ""
echo -e "${BLUE}=== Concatenating final movie ===${NC}"

# Create concat list
CONCAT_LIST="concat_list.txt"
> "$CONCAT_LIST"
for i in $(seq 1 $NUM_SCENES); do
    if [ -f "scene${i}.mp4" ]; then
        echo "file 'scene${i}.mp4'" >> "$CONCAT_LIST"
    fi
done

# Concatenate with high quality encoding
FINAL_FILE="${STORY_NAME}.mp4"
ffmpeg -f concat -safe 0 -i "$CONCAT_LIST" \
    -c:v libx264 -crf 18 -preset slow \
    -c:a aac -b:a 192k \
    "$FINAL_FILE" -y

# Get duration
DURATION=$(ffprobe -v error -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 "$FINAL_FILE")

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Final movie: ${BLUE}$(pwd)/$FINAL_FILE${NC}"
echo -e "Duration: ${BLUE}${DURATION%.*} seconds${NC}"
echo ""
