%% Make timers for the Fusieshow, with a background image

%Amount of oil remaining, in barrels:
makeCountdown(1385409339633, -1123.887395833333, 180, 'OilReserves','oilbarrels.png')
%The data from this timer comes from
%https://www.worldometers.info/oil
%Roughly 1123 barrels of oil are used every second, 1385409339633 is the
%projected oil reserves on 2023-11-19

%World population:
makeCountdown(8072065300, 2.262212688581683, 180, 'WorldPopulation','earth.png')
%The data for this timer comes from
%https://www.theworldcounts.com/populations/world/people
%The net growth is 2.26 people per second, 8072065300 is the projected
%world population on 2023-11-19

%% Make timers without background image

makeCountdown(1385409339633, -1123.887395833333, 180, 'OilReserves_plain')
makeCountdown(8072065300, 2.262212688581683, 180, 'WorldPopulation_plain')