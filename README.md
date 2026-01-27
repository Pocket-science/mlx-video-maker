# mlx-video-maker

Generate multi-scene AI videos with seamless transitions using I2V (Image-to-Video) chaining on Apple Silicon.

## Example Output

https://github.com/user-attachments/assets/REPLACE_WITH_VIDEO_ASSET_ID

> Sample scene from "The Local AI Revolution" - see [examples/](examples/) for the video file and [stories/local_ai_revolution.txt](stories/local_ai_revolution.txt) for the full story prompts.

## The Power: LLM + Prompting Guide

The real magic is combining an LLM (Claude, local models, etc.) with the included **[promptguide.md](promptguide.md)**. Feed the guide to your LLM, describe your scene in plain language, and get optimized prompts following best practices:

- Flowing narrative paragraphs (not bullet lists)
- Present-tense action verbs
- Explicit camera movements and lens choices
- Audio cues for synchronized generation
- The six essential elements for every scene

Example workflow:
```
You: "Write me a 5-scene story about a detective investigating an abandoned warehouse"
LLM: [Uses promptguide.md to craft cinematic, LTX-2 optimized prompts]
```

The guide covers lens language, shutter terminology, video type strategies, and troubleshooting tips.

## The Technique

```
Scene 1 (T2V) → Extract Last Frame → Scene 2 (I2V) → Extract Last Frame → Scene 3 (I2V) → ...
```

Each scene's last frame becomes the input image for the next scene, creating visual continuity across an entire movie. In theory, you could generate hour-long films this way.

## How It Works

1. **First scene**: Text-to-Video generation (no image input)
2. **Frame extraction**: `ffprobe` counts frames, `ffmpeg` extracts the last frame
3. **Subsequent scenes**: Image-to-Video with `--image` pointing to the previous scene's last frame
4. **Final concat**: High-quality `ffmpeg` merge of all scenes

## Quick Start

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/mlx-video-maker.git
cd mlx-video-maker

# Create a story file (one prompt per line)
cat > stories/my_story.txt << 'EOF'
# Scene 1
Wide aerial shot of misty mountains at dawn, camera slowly descending, cinematic, 4K

# Scene 2
Camera continues revealing a lone hiker on the ridge, steady tracking shot, cinematic, 4K

# Scene 3
Close-up of hiker's face illuminated by golden sunrise, emotional, cinematic, 4K
EOF

# Generate the movie
./generate_story.sh stories/my_story.txt output/
```

For long generations:
```bash
nohup ./generate_story.sh stories/my_story.txt output/ > output/nohup.out 2>&1 &
tail -f output/nohup.out  # Monitor progress
```

## Options

```
./generate_story.sh <story_file> [output_dir] [options]

Options:
  --width       Video width (default: 1920, must be divisible by 64)
  --height      Video height (default: 1088, must be divisible by 64)
  --frames      Frames per scene (default: 121, must satisfy 1 + 8*k)
  --strength    I2V conditioning strength 0.0-1.0 (default: 0.7)
  --fps         Output framerate (default: 24)
  --python      Python executable (default: ./venv/bin/python)
```

### Image Strength Guide

| Value | Effect |
|-------|--------|
| 0.5-0.6 | Strong visual continuity, less motion freedom |
| **0.7** | **Sweet spot** - balanced continuity and new content |
| 0.8-0.9 | More variation, potential visual jumps |

## Story File Format

Plain text, one prompt per line:
- Lines starting with `#` are comments (ignored)
- Empty lines are ignored
- Each non-comment line = one scene

**Pro tip**: Use consistent style suffixes across all prompts for visual coherence:
```
..., cinematic, nature documentary style, 4K
```

## Prompt Engineering

See **[promptguide.md](promptguide.md)** for the complete guide. Key points:

- Write flowing narrative paragraphs, not lists
- Use present-tense verbs: "walks", "turns", "reaches"
- Specify camera explicitly: "slow dolly forward", "steady tracking shot"
- Include audio cues: "distant traffic hum", "footsteps echoing"
- Add consistent style suffixes across all scenes

**Example prompt:**
```
A lone fisherman rows across a foggy lake before sunrise, the boat creaking softly
as water laps at its sides. The camera glides overhead in a slow aerial tracking shot,
following his steady progress from behind and slightly above. His lantern casts a warm
circle of light that reflects in gentle ripples, while tall reeds sway on the distant
shoreline.
```

## Performance

On M3 Max (128GB RAM):
- ~20-22 minutes per scene at 1920x1088, 121 frames
- ~4 hours for a 10-scene movie (~50 seconds)
- ~75GB peak memory usage

**Scaling**: 720 scenes = 1 hour movie = ~10 days generation time

## Requirements

- Apple Silicon Mac (M1/M2/M3/M4)
- 64GB+ RAM recommended (32GB minimum at lower resolution)
- [mlx-video](https://github.com/Blaizzy/mlx-video) with LTX-2 model
- ffmpeg and ffprobe
- Python 3.11+

### Installation

```bash
# Install mlx-video (if not already)
pip install mlx-video

# Install ffmpeg
brew install ffmpeg

# Make script executable
chmod +x generate_story.sh
```

## Future Ideas

- Scene quality detection using image-to-text models (auto-regenerate poor scenes)
- Different transition styles (fade, match cut)
- Branching narratives (generate multiple versions, pick best)
- Audio continuity chaining
- Checkpoint recovery for long generations

## Credits

- [LTX-Video (LTX-2)](https://github.com/Lightricks/LTX-Video) by Lightricks - The 2B parameter DiT model that powers the video generation
- [mlx-video](https://github.com/Blaizzy/mlx-video) by Prince Canuma ([@Blaizzy](https://github.com/Blaizzy)) - MLX port enabling Apple Silicon native inference
- [MLX](https://github.com/ml-explore/mlx) by Apple - The ML framework for Apple Silicon

## License

MIT

---

*Built with [mlx-video](https://github.com/Blaizzy/mlx-video) and [LTX-2](https://github.com/Lightricks/LTX-Video) on Apple Silicon*
