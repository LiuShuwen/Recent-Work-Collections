function [phi] = calculatePhi(data)
siz = size(data);
% bias
phi(1:siz(1),1) = 1;
% 1d
phi(1:siz(1),2:siz(2)+1) = data(1:siz(1),1:siz(2));
% 2d
for i=1:siz(1)
   v = phi(i,2:siz(2)+1);
   d2 = v.*v';
   B = reshape(d2,[1,siz(2)*siz(2)]);
   phi(i,siz(2)+2:siz(2)+1+siz(2).^2)=B;
end
% 3d
for i=1:siz(1)
	A = phi(i,siz(2)+2:siz(2)+1+siz(2).^2)'*phi(i,2:siz(2)+1);
	A = reshape(A, [1,siz(2).^3]);
    phi(i,siz(2)+1+siz(2).^2+1: siz(2)+1+siz(2).^2 + siz(2).^3) = A;
end