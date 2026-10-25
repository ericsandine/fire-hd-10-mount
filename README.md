# Fire HD 10 — Landscape Wall Mount

A simple, flat-backed **landscape wall mount** for the **Amazon Fire HD 10 (2023 / 13th generation)**,
designed to be hung with **Command 20 lb X-Large Picture Hanging Strips**. Built for running a
Home Assistant wall panel.

![Mount](images/hero.png)

## Design goals

- **Flat back** — a smooth, rigid panel so the Command strips get full, even contact.
- **Both short edges fully open** — the USB-C port, power button and volume rocker all live on a
  single short edge of this tablet, so leaving both short edges open keeps **USB, power and volume
  accessible** no matter which way you orient it.
- **Hidden cable routing** — the charge cable enters through the open USB edge and runs in a channel
  on the **back** of the base (against the wall), out the **bottom-left** and down the wall — nothing
  crosses the front.
- **Recessed Command-strip pads** — two shallow 1.5 mm pockets on the back let the strips sit inset,
  so the mount hangs a little closer to the wall.
- **Tool-free "lift & drop" retention** — no flexing clips to fatigue or snap.
- **Finished look** — beveled front edge, chamfered window, rounded clips and lip.
- **Fits a 256 × 256 mm bed** — the part is 246.8 mm wide, comfortably inside a Bambu P1S/P2S/X1 plate.

## How it holds the tablet

```
  FRONT view                          │ USB edge: power / volume / USB-C
          ┌──[clip]──────────[clip]──┐│  cable plugs in, runs down this edge
          │                          ││
  open ►  │        (window)          │┘
  edge    │                          │
          │                          │   (cable channel is on the BACK, dashed)
          └─────────[ notch ]────────┘
           ◹  ╚═══════════════════◁══╝ ◸  ← channel across the back of the base
              ▼ exits bottom-left, behind the mount, down the wall
```

- **Bottom shelf + front lip** carries the tablet's weight; a center **finger notch** lets you push
  the tablet up and out with a thumb.
- **Two top clips** hold the top edge flat against the panel.
- **Two corner brackets** nest into the tablet's rounded bottom corners to stop it sliding sideways —
  they add no width beyond the tablet.

### Cable routing

The channel runs along the **back of the base** (the wall side), so nothing is visible across the
front. Mount the tablet with its **USB edge on the right**, plug in the cable, and let it run down the
open right edge into the channel, which enters from that edge. It crosses the back behind the tablet
and **exits at the bottom-left**, already against the wall, so it drops straight down. Press the cable
past the three **retention tabs** so it stays put; once the mount is on the wall, the wall holds it in.

The channel only cuts into the thick bottom base (the Command strips mount on the side borders, not the
base), so the strip surfaces and the rest of the back stay flat. It fits a typical ~4–5 mm USB-C cable.
Prefer the USB edge on the left? Mirror the part in your slicer — both short edges are open.

![Back of the mount — cable channel in the base, recessed strip pads on the sides](images/cable.png)

### Inserting / removing

1. Tilt the top edge in **under the two top clips**.
2. Lift the tablet up ~11 mm (there's room above), then **drop the bottom edge in behind the shelf lip**.
3. To remove: lift up until the bottom edge clears the lip, swing the bottom out, lower away from the clips.

## Mounting with Command strips

1. Clean the wall and the **flat back of the mount** with isopropyl alcohol; let dry.
2. Use **4× Command 20 lb XL strips** — the back has **two recessed pads** (one down each side border)
   sized for them; seat the strips in those pockets so the mount hangs closer to the wall. This stays
   well within the 20 lb / strip rating (mount ≈ 74 g + tablet ≈ 434 g ≈ 0.5 kg total).
3. Snap the strip pairs together, press the mount to the wall, hold firmly, then follow the Command
   instructions (press 30 s, remove, wait 1 h before loading).
4. Insert the tablet, then plug the cable into the open edge and route it through the channel.

![Back — recessed strip pads](images/back.png)

> The printed **first layer (the back face) is the flat side** — print it back-down (see below) and the
> back comes out smooth and ideal for the adhesive strips.

## Printing (Bambu Lab, Bambu Studio)

Import `3mf/fire_hd10_mount.3mf` (or `stl/fire_hd10_mount.stl`) into Bambu Studio.

| Setting            | Recommendation                                                        |
|--------------------|-----------------------------------------------------------------------|
| **Orientation**    | **Back panel flat on the plate** (lips/clips pointing up).            |
| **Material**       | PLA is fine indoors. **PETG** if the panel may sit in direct sun/heat.|
| **Supports**       | **On** — the only overhangs needing support are the undersides of the 3 front lips (shelf lip + 2 top clips). "Support on build plate only" is enough. The strip-recess floors and the back cable-channel both self-bridge and need no support. |
| **Walls / infill** | 3 walls, 15–20 % infill. Plenty strong for ~0.5 kg in shear.         |
| **Layer height**   | 0.2 mm.                                                               |

Approx. part: **246.8 × 198.8 × 15 mm**, ~108 cm³ envelope, **~74 g PLA**, a few hours.

## Files

| Path                           | What                                               |
|--------------------------------|----------------------------------------------------|
| `src/fire_hd10_mount.scad`     | Parametric OpenSCAD source (all dimensions here).  |
| `stl/fire_hd10_mount.stl`      | Ready-to-slice mesh.                               |
| `3mf/fire_hd10_mount.3mf`      | Ready-to-slice mesh (3MF).                         |
| `images/`                      | Renders.                                           |

## Customizing

All dimensions are parameters at the top of the `.scad` file (tablet size, clearances, lip depths,
etc.). To regenerate after editing:

```bash
openscad -o stl/fire_hd10_mount.stl src/fire_hd10_mount.scad
python3 tools/stl_to_3mf.py stl/fire_hd10_mount.stl 3mf/fire_hd10_mount.3mf
```

> **Note:** the 3MF is produced from the STL with `tools/stl_to_3mf.py`, **not** `openscad -o …3mf`
> (OpenSCAD's native 3MF embeds base-materials + newer schema namespaces).
>
> Bambu Studio shows *"invalid config, loading geometry only"* when importing **any** 3MF not saved
> as a Bambu project — it's a harmless notice, and the geometry loads normally. **Import the STL**
> (`stl/fire_hd10_mount.stl`) if you'd rather not see it; the geometry is identical.

**Fit too tight or too loose?** Adjust `cl_t` (thickness clearance) and `cl_w` (width clearance).
**Different generation or a case?** Change `tw` / `th` / `tt` to the outer dimensions you measure.

## Tablet reference (2023 / 13th gen)

- Dimensions: **246 × 164.8 × 8.6 mm** · ~434 g
- Power, volume, USB-C (and headphone jack) are all on **one short edge** — the open side in this mount.

Sources: [device specs](https://www.devicespecifications.com/en/model/d20936bf) ·
[button/port layout](https://www.techradar.com/tablets/amazon-fire-hd-10-2023-review-only-smouldering)
