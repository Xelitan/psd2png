program psd2png;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Interfaces, Classes, Graphics, SysUtils, BGRABitmap, BGRAreadPSD, BGRAClasses;

const PROG = 'psd2png';
      VERSION = '1.0';

function Convert(InName, OutName: String): Integer;
var Img: TGraphic;
    Ext: String;
    Bmp: TBitmap;
    Bmp2: TBGRABitmap;
begin
  Result := 0;

  try
    Bmp2 := TBgraBitmap.Create;
    Bmp2.LoadFromFile(InName);

    Bmp := TBitmap.Create;
    Bmp.PixelFormat := pf32bit;
    Bmp.SetSize(Bmp2.Width, Bmp2.Height);
    Bmp.Canvas.Brush.Color := clWhite;
    Bmp.Canvas.FillRect(0,0, Bmp.Width, Bmp.Height);

    Bmp2.Draw(Bmp.Canvas, 0,0, False);
    Bmp2.Free;
  except
    Writeln('Conversion error');
    Exit(1);
  end;

  Ext := LowerCase(ExtractFileExt(OutName));

  if Ext = '.bmp' then Img := TBitmap.Create
  else if Ext = '.jpg' then Img := TJPEGImage.Create
  else if Ext = '.ppm' then Img := TPortableAnyMapGraphic.Create
  else if Ext = '.png' then Img := TPortableNetworkGraphic.Create;

  Img.Assign(Bmp);
  Bmp.Free;

  Img.SaveToFile(OutName);
  Img.Free;
end;

var UserDpi: Integer;
begin
  if (ParamCount <> 2) then begin
    Writeln('===================================================');
    Writeln('  ', PROG, ' - .PSD to .PNG image converter');
    Writeln('  github.com/Xelitan/', PROG);
    Writeln('  version: ', VERSION);
    Writeln('  license: GNU LGPL'); //like BGRA
    Writeln('===================================================');
    Writeln('  Usage: ', PROG, ' INPUT OUTPUT');
    Writeln('  Output format is guessed from extension.');
    Writeln('  Supported: bmp,jpg,png,ppm');
    ExitCode := 0;
    Exit;
  end;

  ExitCode := Convert(ParamStr(1), ParamStr(2));
end.



