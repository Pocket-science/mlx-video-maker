# LTX-2 Prompt Engineering Guide

This guide helps you (or an LLM) craft effective prompts for LTX-2 video generation.

## LTX-2 Capabilities

- **Resolution**: Native 4K support
- **Frame rates**: Up to 50 fps
- **Duration**: Up to 20 seconds continuous video
- **Audio**: Synchronized audio-video generation
- **Thinking**: Interprets prompts like a cinematographer reading director's notes

## Core Principle: Complete Story Picture

Write prompts as flowing narratives, not descriptive lists. Think mini-screenplay: each action leads naturally to the next, camera movements have purpose, and all elements contribute to temporal flow.

## The Six Essential Elements

Every effective prompt should include:

### 1. Shot Establishment
Opening framing and camera position.
- Examples: "Wide shot from across the street," "Extreme close-up on weathered hands," "Bird's eye view"
- Match terminology to genre: documentary = handheld language; cinematic = "dolly," "crane"

### 2. Scene Setting
Environment with lighting, color, texture, atmosphere.
- "Golden hour bounce," "harsh overhead fluorescents," "soft window light"
- "Desaturated blues and grays," "warm amber tones"
- "Thick morning fog," "dust particles in sunbeams"

### 3. Action Description
Present-tense verbs describing motion sequentially.
- Use: "walks," "turns," "reaches" (not "walked," "turning")
- Show cause and effect: "The door swings open, revealing..."
- Include small physical details: "His fingers drum against the table"

### 4. Character Definition
Physical details, clothing, emotional cues through body language.
- Show emotion through action, not labels: "tears welling in her eyes" not "sad"

### 5. Camera Movement
Specify how and when camera moves.
- Pan, tilt, dolly, track, crane movements with speed descriptors
- "Slow dolly forward," "steady tracking shot," "tripod-locked"

### 6. Audio Description
Ambient sounds, music, dialogue in quotes, vocal characteristics.
- "Distant traffic hum," "footsteps echoing on tile," "clock ticking"
- Dialogue: `"Hello, is anyone there?" she calls out`

## Structural Guidelines

**Single Continuous Paragraph**: No line breaks or lists within a prompt. Flow naturally from beginning to end.

**Present Tense Action Verbs**: Essential for conveying dynamic motion.

**Explicit Camera Behavior**: Never assume the model will infer camera movement. Specify angle, movement, and speed.

**Precise Physical Details**: Use measurable movements and specific gestures.
- Generic: "She looks surprised"
- Precise: "Her eyebrows lift, eyes widen, lips part slightly as she inhales sharply"

**Temporal Connectors**: Use "as," "then," "while," "before," "after," "when" to create smooth flow.

## What to Avoid

- **Emotional labels without visual cues**: "A sad woman" → "A woman with slumped shoulders, downcast eyes"
- **Text and logos**: Model cannot generate readable text reliably
- **Complex physics**: Avoid collisions, liquid simulations, chaotic crowds
- **Scene overload**: Too many simultaneous elements create confusion
- **Conflicting lighting**: Don't mix incompatible light sources
- **Overly complicated camera work**: Keep movements clear and purposeful

## Example Prompts

### Nature Scene
```
A lone fisherman rows across a foggy lake before sunrise, the boat creaking softly as water laps at its sides. The camera glides overhead in a slow aerial tracking shot, following his steady progress from behind and slightly above. His lantern casts a warm circle of light that reflects in gentle ripples, while tall reeds sway on the distant shoreline. A distant bird call echoes across the water as mist rolls slowly across the glassy surface.
```

### Character Scene
```
A woman stands at a kitchen counter slicing vegetables in afternoon light streaming through a nearby window. The camera begins in a medium close-up at shoulder height, then slowly pushes forward to focus on her hands. As she hears a creak from the hallway, her eyebrows lift slightly and the blade pauses mid-air. The camera holds steady with shallow depth of field, ambient kitchen sounds—a refrigerator hum, distant traffic—creating a quiet domestic atmosphere.
```

## Advanced Techniques

### Lens and Shutter Language

**Focal lengths:**
- `24mm wide-angle` - expansive, environmental shots
- `50mm standard` - natural perspective
- `85mm portrait` - compressed, intimate
- `200mm telephoto` - compressed depth, isolated subject

**Shutter/motion:**
- `180° shutter equivalent` - cinematic motion blur
- `Natural motion blur` - realistic movement
- `Fast shutter, crisp motion` - sports/action feel

### Keywords for Smooth 50 FPS Motion

**Use these for fluid motion:**
- Camera: "steady dolly," "smooth gimbal," "tripod-locked," "constant speed pan"
- Motion: "natural motion blur," "fluid movement," "controlled motion," "stable tracking"

**Avoid these (causes warps/artifacts):**
- "handheld chaotic," "shaky cam," "erratic movement"

### Six-Part Structured Prompt (4K)

For optimal 4K generation, include these six parts:

1. **Scene Anchor**: Location, time, atmosphere
   - `Dawn over a misty alpine lake, light fog, glassy water`
2. **Subject + Action**: Who/what and a verb
   - `A red canoe gliding across, single rower in a yellow raincoat`
3. **Camera + Lens**: Movement, focal length, aperture, framing
   - `Slow dolly-right, 50mm, f/2.8, medium-wide, stable rig`
4. **Visual Style**: Color science, grading, film emulation
   - `Soft contrast, rich primaries, Kodak 2383 print look`
5. **Motion Cues**: Speed, frame intent, shutter feel
   - `Natural motion blur, 50 fps feel, 180° shutter equivalent`
6. **Guardrails**: What to avoid
   - `No flicker, no high-frequency patterns, no text overlays`

### Tips for Different Video Lengths

**Short (<5 seconds):**
- Single action, simple camera movement or static shot
- Example: `A coffee cup lifts from a saucer, steam rising. Close-up, shallow DOF, soft morning light.`

**Medium (5-10 seconds):**
- 2-3 connected actions, one camera movement, clear progression
- Example: `A woman opens a wooden door, pauses as sunlight streams past her silhouette, then steps inside. The camera tracks forward, following from exterior to interior.`

**Long (10-20 seconds):**
- Mini-narrative with multiple beats, camera movement changes
- **Pro tip**: Start with close-up and move out—helps retain facial/material detail (wider shots can soften likeness)

### Audio-Video Synchronization

LTX-2 generates audio and video simultaneously. Use timing cues:
- `On the downbeat` - sync action to music
- `Constant speed pan` - predictable motion for rhythm
- `Rhythmic footsteps` - regular intervals

### What Works Well

- Controlled camera movements (dolly, crane, tracking shots)
- Subtle facial expressions and natural body language
- Atmospheric settings with weather effects (fog, rain, snow)
- Film emulation looks and color grading styles
- Multilingual voice work with accent specifications

## Video Type Strategies

### Marketing/Product Videos
- Start with product close-ups, controlled camera movements (dolly, crane)
- Lighting that highlights product features
- Include human element (hand interacting) for relatability
- Keywords: "premium aesthetic," "shallow depth of field," "clean whites"

### Educational Content
- Medium shots for presenter visibility, steady tripod-locked camera
- Deliberate pacing, explicit gestures for teaching behaviors
- Keywords: "educational pacing," "clear voice," "professional lighting"

### Social Media Clips
- Immediate high-impact opening, dynamic movements (whip pan, quick zoom)
- Vibrant saturated colors, high contrast
- Keywords: "crushed blacks," "lens flare," "trendy aesthetic," "bass drop synchronized"

### Cinematic Sequences
- Film terminology: "anamorphic," "bokeh," "film grain"
- Subtle micro-expressions, longer sequences with narrative arc
- Reference film stocks: "Kodak 2383 print emulation," "ARRI Alexa look"

## Multi-Shot Continuity

### Scene Transitions
- **Match cut**: Match visual elements (spinning wheel → spinning record)
- **Action match**: Continue action across cut (hand reaching → door opening)
- **Light/color match**: Maintain lighting consistency across shots
- **Audio bridge**: Use sound to connect shots

### Character Consistency Across Shots
- Provide identical detailed descriptions in every prompt
- Include specific clothing, hair, physical details
- Reference "same person as previous shot" when applicable

## Troubleshooting

### Motion Blur Issues
- Add "natural motion blur" and "180-degree shutter equivalent"
- Avoid "fast shutter" unless intentional
- For action: "appropriate motion blur for speed"

### Moiré/Artifact Problems
(brick walls, mesh, fine patterns)
- Add "avoid high-frequency patterns" to prompts
- Use "smooth textures" or "soft focus on background"
- Apply shallow DOF to blur problematic areas

### Audio-Video Sync
- Use timing cues: "on the downbeat," "at 2.5 seconds"
- Describe rhythmic actions: "footsteps in steady rhythm"
- Specify regular patterns: "constant speed," "even intervals"

---

*Based on the official [LTX-Video prompt guidance](https://huggingface.co/Lightricks/LTX-Video#-prompt-guidance)*
