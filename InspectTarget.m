close all
clear all
format long
lat_t = 53.4325875;
lon_t = -1.58276;
OctoGuided( lat_t, lon_t, 5 )

planFlag = 1;
while(planFlag)
    dataCount = dataCount + 1;
[lat_c, lon_c, alt_c, hdg_c] = OctoPosition( );
latDiff = (lat_t - lat_c);
longDiff = (long_t - long_c);
distance = sqrt(latDiff.^2 + longDiff.^2) * 111111;

if(dataCount == 1)
    image = OctoCam(gimbalPitch(45));
    savedLocation = [lat_c, lon_c, alt_c, hdg_c];
else
    image = cat(1, image, OctoCam(gimbalPitch(j)));
    savedLocation = cat(1, savedLocation, [lat_c, lon_c, alt_c, hdg_c]);
end
    if(distance < 40)
        initBearing = acosd(latDiff/distance);
        radius = 10;
        numPoints = 8;
        [longPerim, latPerim, bearingTarget] = perimeterSearch(lon_t, lat_t, radius, numPoints, initBearing);
        planFlag = 0;
    end
end
altitude = [5, 4, 3];
gimbalPitch = [45, 30, 15];
dataCount = 0;
for j = 1:4
    for i = 1:numPoints+1
        OctoGuided( latPerim(i), longPerim(i), altitude(j), bearingTarget(i) )
        arriveFlag = 0;
        while(arriveFlag == 0)
            dataCount = dataCount + 1;
            [lat_c, lon_c, alt_c, hdg_c] = OctoPosition( );
            latDiff = (lat_t - lat_c);
            longDiff = (long_t - long_c);
            distance = sqrt(latDiff.^2 + longDiff.^2) * 111111;
            if(dataCount == 1)
                image = OctoCam(gimbalPitch(j));
                savedLocation = [lat_c, lon_c, alt_c, hdg_c];
            else
                image = cat(1, image, OctoCam(gimbalPitch(j)));
                savedLocation = cat(1, savedLocation, [lat_c, lon_c, alt_c, hdg_c]);
            end
            if(distance < 2)
                arriveFlag = 1;
            end
        end
    end
end
