function [ cx, cy ] = find_linear_path( p1, p2 )
% Find the linear path between pixel a and pixel b

cx = [];
cy = [];
p1x = p1(1);  p1y = p1(2);
p2x = p2(1);  p2y = p2(2);

if p2x>p1x
    k1=1;
else
    k1=-1;
end
if p2y>p1y
    k2=1;
else
    k2=-1;
end


if p1x==p2x
    for i=p1y+k2:k2:p2y
        cx = [cx (p1x) ];
        cy = [cy (i) ];
    end
    return;
end
if p1y==p2y
    for i=p1x+k1:k1:p2x
        cx = [cx (i) ];
        cy = [cy (p1y) ];
    end
    return;
end


d1 = abs(p1x-p2x);
d2 = abs(p1y-p2y);
if d1>d2
    d = (d2/d1);
    for i=1:d1
        cx = [cx (p1x+k1*i) ];
        cy = [cy fix(p1y+k2*i*d) ];
    end
    if k2<0 cy(find(cy==0))=1; end
else
    d = (d1/d2);
    for i=1:d2
        cx = [cx fix(p1x+k1*i*d) ];
        cy = [cy (p1y+k2*i) ];
    end
    if k1<0 cx(find(cx==0))=1; end
end


end

