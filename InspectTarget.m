close all
clear all
format long

%Target Definition
lat_t = 53.4325875;
lon_t = -1.58276;
%Fly to Target
OctoGuided( lat_t, lon_t, 8 )
dataCount = 0
planFlag = 1;
while(planFlag)
    %Initially, measure distance from target
    dataCount = dataCount + 1;
    [lat_c, lon_c, alt_c, hdg_c] = OctoPosition( );
    latDiff = (lat_t - lat_c);
    longDiff = (lon_t - lon_c);
    distance = sqrt(latDiff.^2 + longDiff.^2) * 111111;
    %Save images/location
    image = cell(1,1);
    if(dataCount == 1)
        OctoCam(35);
        image{dataCount} = OctoCam();
        savedLocation = [lat_c, lon_c, alt_c, hdg_c];
    else
        OctoCam(35);
        image{dataCount} = OctoCam();
        savedLocation = cat(1, savedLocation, [lat_c, lon_c, alt_c, hdg_c]);
    end
    %If the target is less than 40m away...
    if(distance < 40)
        initBearing = acosd(latDiff/distance);
        [longPerim, latPerim, bearingTarget] = perimeterSearch(lon_t, lat_t, 5, 8, initBearing);
        planFlag = 0;
    end
end
radius = 10;
numPoints = 8;
altitude = [5, 4, 3];
gimbalPitch = [45, 30, 15];
for j = 1:4
    for i = 1:numPoints+1
        i
        OctoGuided( latPerim(i), longPerim(i), altitude(j), bearingTarget(i) )
        arriveFlag = 0;
        while(arriveFlag == 0)
            distanceOld = distanceNew;
            dataCount = dataCount + 1;
            [lat_c, lon_c, alt_c, hdg_c] = OctoPosition( );
            latDiff = (lat_t - lat_c);
            longDiff = (lon_t - lon_c);
            distanceNew = sqrt(latDiff.^2 + longDiff.^2) * 111111
            %Logging Data from the UAV
            OctoCam(gimbalPitch(j));
            image = OctoCam();
            imwrite(image, sprintf('image%04d.jpg', i));
            savedLocation = cat(1, savedLocation, [lat_c, lon_c, alt_c, hdg_c]);
            
            
            if(distanceNew < 4)
                if(distanceNew < distanceOld)
                    
                end
                arriveFlag = 1;
            else
                 OctoGuided( latPerim(i), longPerim(i), altitude(j), bearingTarget(i) )
            end
        end
    end
end
