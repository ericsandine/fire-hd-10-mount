#!/usr/bin/env python3
"""Sanity-check an ASCII STL: count connected shells, report size and volume.

"Manifold" alone isn't enough — a part can be manifold yet split into several
disconnected bodies (e.g. a lip that only touches the base along an edge), which
prints as floating pieces. This groups triangles that share an edge and reports
each shell. Exits non-zero unless the mesh is exactly ONE shell.

Usage:  python3 tools/check_mesh.py stl/fire_hd10_mount.stl
"""
import re, sys
from collections import defaultdict
txt = open(sys.argv[1], errors='ignore').read()
v = [tuple(round(float(c), 4) for c in m) for m in re.findall(r'vertex\s+(\S+)\s+(\S+)\s+(\S+)', txt)]
tris = [v[i:i+3] for i in range(0, len(v), 3)]
parent = list(range(len(tris)))
def find(a):
    while parent[a] != a: parent[a] = parent[parent[a]]; a = parent[a]
    return a
owner = {}
for i, tr in enumerate(tris):
    for a, b in ((0, 1), (1, 2), (2, 0)):
        e = tuple(sorted((tr[a], tr[b])))
        if e in owner: parent[find(i)] = find(owner[e])
        else: owner[e] = i
shells = defaultdict(list)
for i in range(len(tris)): shells[find(i)].append(i)
def vol(idx):
    return abs(sum((a[0]*(b[1]*c[2]-c[1]*b[2]) - a[1]*(b[0]*c[2]-c[0]*b[2]) + a[2]*(b[0]*c[1]-c[0]*b[1])) / 6
                   for a, b, c in (tris[i] for i in idx))) / 1000
print(f"shells: {len(shells)}")
for idx in sorted(shells.values(), key=len, reverse=True):
    xs, ys, zs = zip(*[p for i in idx for p in tris[i]])
    print(f"  {vol(idx):7.2f} cm3   {max(xs)-min(xs):6.1f} x {max(ys)-min(ys):6.1f} x {max(zs)-min(zs):5.1f} mm"
          f"   X[{min(xs):.1f},{max(xs):.1f}] Y[{min(ys):.1f},{max(ys):.1f}] Z[{min(zs):.1f},{max(zs):.1f}]")
sys.exit(0 if len(shells) == 1 else 1)
