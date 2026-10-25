#!/usr/bin/env python3
"""Convert an ASCII STL into a clean, minimal, core-spec-only 3MF.

OpenSCAD's own `-o file.3mf` export embeds base-materials + exotic schema
namespaces that Bambu Studio flags as "invalid config, loading geometry only".
This writer emits only the 3MF core spec (one object, one build item), which
Bambu Studio imports without complaint. Merges coincident vertices and drops
zero-area triangles.

Usage:  python3 tools/stl_to_3mf.py in.stl out.3mf
"""
import re, sys, zipfile, struct
stl = sys.argv[1]; out = sys.argv[2]
txt = open(stl, errors='ignore').read()
nums = re.findall(r'vertex\s+(\S+)\s+(\S+)\s+(\S+)', txt)
pts = [tuple(float(c) for c in t) for t in nums]
vmap, verts, tris, cur = {}, [], [], []
def key(p): return (round(p[0],5), round(p[1],5), round(p[2],5))
for p in pts:
    k = key(p)
    if k not in vmap: vmap[k] = len(verts); verts.append(k)
    cur.append(vmap[k])
    if len(cur) == 3:
        if len(set(cur)) == 3: tris.append(tuple(cur))
        cur = []
def f(v):
    s = f"{v:.6f}".rstrip('0').rstrip('.'); return '0' if s in ('-0','') else s
m = ['<?xml version="1.0" encoding="UTF-8"?>',
 '<model unit="millimeter" xml:lang="en-US" xmlns="http://schemas.microsoft.com/3dmanufacturing/core/2015/02">',
 ' <metadata name="Application">fire-hd-10-mount</metadata>',
 ' <resources>', '  <object id="1" type="model">', '   <mesh>', '    <vertices>']
m += [f'     <vertex x="{f(x)}" y="{f(y)}" z="{f(z)}"/>' for (x,y,z) in verts]
m += ['    </vertices>', '    <triangles>']
m += [f'     <triangle v1="{a}" v2="{b}" v3="{c}"/>' for (a,b,c) in tris]
m += ['    </triangles>', '   </mesh>', '  </object>', ' </resources>',
 ' <build>', '  <item objectid="1"/>', ' </build>', '</model>']
ct = ('<?xml version="1.0" encoding="UTF-8"?>\n<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">\n'
 ' <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>\n'
 ' <Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/>\n</Types>')
rels = ('<?xml version="1.0" encoding="UTF-8"?>\n<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\n'
 ' <Relationship Id="rel0" Target="/3D/3dmodel.model" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/>\n</Relationships>')
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    z.writestr('[Content_Types].xml', ct)
    z.writestr('_rels/.rels', rels)
    z.writestr('3D/3dmodel.model', '\n'.join(m))
print(f"vertices={len(verts)} triangles={len(tris)}")
