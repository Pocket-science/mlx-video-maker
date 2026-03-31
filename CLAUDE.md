# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

mlx-video-maker is a toolkit for generating multi-scene AI videos with seamless transitions on Apple Silicon Macs. It uses LTX-2 (2B parameter DiT model) via the MLX framework for native inference on M1/M2/M3/M4 chips.

## How It Works

The core technique is **I2V chaining**: Scene 1 is generated as text-to-video, then the last frame is extracted and used as the input image for scene 2 (image-to-video), and so on. All scenes are concatenated into a final movie with ffmpeg.

Pipeline: T2V (scene 1) → extract last frame → I2V (scene 2+) → repeat → ffmpeg concat

## Running

```bash
# Generate a movie from a story file
./generate_story.sh stories/my_story.txt [output_dir]

# Background generation (long runs)
nohup ./generate_story.sh stories/my_story.txt output/ > output/nohup.out 2>&1 &
```

### Key parameters (all optional)
- `--width 1920` (must be divisible by 64)
- `--height 1088` (must be divisible by 64)
- `--frames 121` (must satisfy 1 + 8*k)
- `--strength 0.7` (I2V conditioning, 0.0-1.0; 0.7 is sweet spot)
- `--fps 24`
- `--python ./venv/bin/python`

## Architecture

- **`generate_story.sh`** — Single bash script that orchestrates everything. Handles argument parsing, scene generation (calling `mlx_video.generate_av`), frame extraction via ffprobe/ffmpeg, and final concatenation.
- **`stories/`** — Story files: plain text, one prompt per line, `#` for comments, empty lines ignored.
- **`promptguide.md`** — Comprehensive LTX-2 prompt engineering guide covering shot establishment, camera movement, audio description, and multi-shot continuity techniques.
- **`output/`** — Generated artifacts: `scene{N}.mp4`, `scene{N}_lastframe.jpg`, `concat_list.txt`, final movie (gitignored).

## Key Design Decisions

- **Resumable**: Script skips scenes that already exist in the output directory.
- **No Python package structure**: Direct script execution, single pip dependency (`mlx-video` from GitHub).
- **No build/test/lint**: Manual testing by reviewing generated video output.

## Requirements

- Apple Silicon Mac with 64GB+ RAM (32GB minimum at lower resolution)
- Python 3.11+, ffmpeg, ffprobe
- `pip install git+https://github.com/Blaizzy/mlx-video.git`

## Story File Format

```text
# Comments start with #
A cinematic wide shot of a mountain landscape at golden hour...

A close-up tracking shot follows a character walking through fog...
```

Each non-empty, non-comment line is one scene prompt. Prompts should be flowing narrative paragraphs (not keyword lists) following the six elements in promptguide.md: shot establishment, scene setting, action, character definition, camera movement, audio description.
