program smallRL;

uses crt;

type
  rect = record
    x, y, w, h: integer;
  end;

var
  map: array of integer;
  mapW, mapH: integer;

procedure generateDungeon;
var
  x, y, i, rn: integer;
  cx, cy: integer;
  w, h: integer;
  ix, iy: integer;
  fails: integer;
  failed: boolean;
  rooms: array of rect;
  pmap: array of integer;
  r: integer;
  xm, ym, tx, ty: integer;
begin
  mapW := 30 + random(20);
  mapH := 15 + random(7);

  setLength(pmap, mapW*mapH);
  setLength(map, mapW*mapH);
  for i := 0 to mapW*mapH-1 do
    map[i] := 0;

  fails := 0;
  rn := 3 + random(5);
  setLength(rooms, rn);

  i := 1;
  while i <= rn do
  begin
    w := 3 + random(4);
    h := 2 + random(3);
    x := 2+random(mapW-w-3);
    y := 2+random(mapH-h-3);
    failed := false;

    for ix := x-1 to x+w+1 do
    begin
      if failed then break;
      for iy := y-1 to y+h+1 do
        if map[iy*mapW+ix] <> 0 then
        begin
          failed := true;
          break;
        end;
    end;

    if not failed then
    begin
      for ix := x-1 to x+w+1 do
        for iy := y-1 to y+h+1 do
          map[iy*mapW+ix] := 2;
      for ix := x to x+w do
        for iy := y to y+h do
          map[iy*mapW+ix] := 1;

      cx := x + w div 2;
      cy := y + h div 2;
      map[(y-1)*mapW+cx] := 0;
      map[cy*mapW+x-1] := 0;
      map[cy*mapW+x+w+1] := 0;
      map[(y+h+1)*mapW+cx] := 0;

      rooms[i-1].x := x;
      rooms[i-1].y := y;
      rooms[i-1].w := w;
      rooms[i-1].h := h;
          
      i += 1;
      continue;
    end;

    fails += 1;

    if fails > 100 then
    begin
      for i := 0 to mapW*mapH-1 do
        map[i] := 0;
      fails := 0;
      i := 1;
    end;
  end;

  for r := 0 to rn-2 do
  begin
    for i := 0 to mapW*mapH-1 do
      if map[i] = 2 then
        pmap[i] := -1
      else
        pmap[i] := 0;

    pmap[
      (rooms[r].y + rooms[r].h div 2) * mapW
      + (rooms[r].x + rooms[r].w div 2)
    ] := 1;
    cx := rooms[r+1].x + rooms[r+1].w div 2;
    cy := rooms[r+1].y + rooms[r+1].h div 2;

    i := 1;
    while pmap[cy*mapW+cx] = 0 do
    begin
      for x := 0 to mapW-1 do
        for y := 0 to mapH-1 do
        begin
          if pmap[y*mapW+x] <> i then continue;

          for xm := -1 to 1 do
            for ym := -1 to 1 do
            begin
              if (xm = 0) and (ym = 0) then continue;
              if (xm <> 0) and (ym <> 0) then continue;

              ix := x + xm;
              iy := y + ym;
              if (ix < 0) or (iy < 0) or (ix >= mapW) or (iy >= mapH) then
                continue;

              if pmap[iy*mapW+ix] = 0 then
                pmap[iy*mapW+ix] := i+1;
            end;
        end;

      i += 1;
    end;

    (*for y := 0 to mapH-1 do
    begin
      for x := 0 to mapW-1 do
        write(pmap[y*mapW+x]);
      writeln;
    end;*)

    x := cx;
    y := cy;
    cx := rooms[r].x + rooms[r].w div 2;
    cy := rooms[r].y + rooms[r].h div 2;

    while (x <> cx) or (y <> cy) do
    begin
      if map[y*mapW+x] = 0 then
        map[y*mapW+x] := 1;

      xm := 0;
      ym := 0;

      for ix := -1 to 1 do
      begin
        if (xm <> 0) or (ym <> 0) then break;

        for iy := -1 to 1 do
        begin
          if (ix <> 0) and (iy <> 0) then continue;
          if (ix = 0) and (iy = 0) then continue;

          tx := x + ix;
          ty := y + iy;
          if (tx < 0) or (ty < 0) or (tx >= mapW) or (ty >= mapH) then
            continue;

          if pmap[ty*mapW+tx] = i then
          begin
            xm := ix;
            ym := iy;
            break;
          end;
        end;
      end;

      x += xm;
      y += ym;
      i -= 1;
    end;

  end;

  for r := 0 to rn-1 do
    for i := 0 to 3 do
    begin
      x := rooms[r].x-1 + (rooms[r].w + 2) * (i mod 2);
      y := rooms[r].y-1 + (rooms[r].h + 2) * ((i+1) mod 2);
      if i < 2 then
        y := rooms[r].y + rooms[r].h div 2
      else
        x := rooms[r].x + rooms[r].w div 2;

      if map[y*mapW+x] = 0 then
        map[y*mapW+x] := 2
      else
        map[y*mapW+x] := 3;
    end;

end;

procedure drawMap;
var
  x, y: integer;
  c: char;
begin
  for y := 0 to mapH-1 do
  begin
    for x := 0 to mapW-1 do
    begin
      c := '?';
      case map[y*mapW+x] of
        0: c := ' ';
        1: c := '.';
        2: c := '#';
        3: c := '+';
      end;

      write(c);
    end;

    writeln;
  end;
end;

begin
  randomize;
  generateDungeon;
  drawMap;
end.
