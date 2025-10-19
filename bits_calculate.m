clear;
clear all;
clc;

ip = rand(1,50); 		%generate 50 random inputs
b1 = [-0.0156 0.0182 0.0417 0.0260 -0.0208 -0.0677 -0.0625 0.0182 0.1536 0.2813];
b2 = fliplr(b1);
b = [b1 0.3333 b2]; 	%filter coefficient

OUTori = conv(ip,b);
OUT_ttl = sum(OUTori); 	%floating point results

for L = 5:15
	b_f = floor(b*2^L)/2^L;
	out = conv(ip,b_f);
	out_ttl = sum(out);	%fixed point results
	X = (OUT_ttl^2);
	Y = (OUTori - out);	%error between floating & fixed point
	Y(L) = sum(Y.^2);
	sqnr(L) = 10*log10(X/Y(L));		%SNR = 10log10(signal power/noise power)
end
bar(sqnr);
