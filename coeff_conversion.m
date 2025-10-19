clear;
clear all;
clc;

ip = rand(1,50); 		%generate 50 random inputs
b1 = [-0.0156 0.0182 0.0417 0.0260 -0.0208 -0.0677 -0.0625 0.0182 0.1536 0.2813];
b2 = fliplr(b1);
b = [b1 0.3333 b2]; 	%filter coefficient

for i = 1:numel(b)
	binaryCoeff = dec2bin(floor(b(i) * 2^9),9); %get 9 bits
	fprintf('%s\n', binaryCoeff);
end