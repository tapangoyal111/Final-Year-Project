clc
clear all;
close all;
F=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
%Very Low
F([10 11 13 16 19 46 55 56 58 59 61 62 73])=0
% Low
F([1 2 6 7 12 14 15 17 18 20 21 22 23 24 25 26 28 29 31 32 33 34 35 37 38 40 41 43 47 48 49 50 51 52 53 57 60 63 74 75 76 77])=1
%Med
F([3 4 5 8 9 27 30 36 39 42 54 64 65 67 68 70 78 79 80])=2
%High
F([45 66 69 71 81])=3
%Very High
F(72)=4
for i=1:1:81
    F(i)
end

T=[1 2 3 4]

R=T(1:2)
R(1)=5
R
T



    