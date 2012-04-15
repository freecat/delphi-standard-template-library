unit DSTL.Utils.StopWatch;

interface
uses
  Windows;

type
  TStopWatch = class
  private
    freq: int64;
    starttime, stoptime: int64;
  public
    constructor Create;
    procedure start;
    procedure stop;
    function elapsedSec: double;
    function elapsedMSec: double;
    function elapsedUSec: double;
  end;

implementation

constructor TStopWatch.Create;
begin
  QueryPerformanceFrequency(freq);
end;

procedure TStopWatch.start;
begin
  QueryPerformanceCounter(starttime);
end;

procedure TStopWatch.stop;
begin
  QueryPerformanceCounter(stoptime);
end;

function TStopWatch.elapsedSec: double;
begin
  Result := (stoptime - starttime) / freq;
end;

function TStopWatch.elapsedMSec: double;
begin
  Result := (stoptime - starttime) / freq * 1000;
end;

function TStopWatch.elapsedUSec: double;
begin
  Result := (stoptime - starttime) / freq * 1000000;
end;

end.
