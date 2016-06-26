function [longPerim, latPerim, bearingTarget] = perimeterSearch(longTarget, latTarget, radius, numPoints, initBearing)
    format long
    longLatRad = (radius/111111); %111,111m in 1degree of long/lat.
    degDiff = ((360) / numPoints);
    degPerim = initBearing:degDiff:(360+initBearing);
    degPerim = mod(degPerim, 360);
    longPerim = double((longLatRad.*cos(degPerim))) + double(longTarget);
    latPerim = double((longLatRad.*sin(degPerim))) + double(latTarget);
    bearingTarget = mod(degPerim + 180, 360);
end