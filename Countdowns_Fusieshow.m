%% Make timers for the Fusieshow, with a background image

%Total length of the timer, in seconds:
timerDuration = 600;

%Oil data (comes from https://www.worldometers.info/oil)
oilReserve = 1385409339633; %Remaining barrels of oil (on 2023-11-19)
oilLossPerSecond = -1123.887395833333; %Barrels of oil used per second

%World population data (comes from
%https://www.theworldcounts.com/populations/world/people)
worldPopulation = 8072065300; %World population (on 2023-11-19)
worldGrowth = 2.262212688581683; %Net growth of people per second


%Make the oil barrel counter:
makeCountdown(oilReserve, oilLossPerSecond, timerDuration, 'OilReserves','oilbarrels.png')

%Make the world population counter:
makeCountdown(worldPopulation, worldGrowth, timerDuration, 'WorldPopulation','earth.png')


%% Make timers without background image

makeCountdown(oilReserve, oilLossPerSecond, timerDuration, 'OilReserves_plain')
makeCountdown(worldPopulation, worldGrowth, timerDuration, 'WorldPopulation_plain')