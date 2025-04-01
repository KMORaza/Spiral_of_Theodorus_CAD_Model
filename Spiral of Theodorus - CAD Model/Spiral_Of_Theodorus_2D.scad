n = 17;       
height = 5;       
line_width = 0.1; 
function theta_sum(k) = k == 1 ? PI/2 : PI/2 + sum([for (j = [1:k-1]) atan(1/sqrt(j))]);
function sum(v, i = 0, r = 0) = i < len(v) ? sum(v, i + 1, r + v[i]) : r;
points = [for (k = [0:n]) 
    k == 0 ? [0, 0] : [
        sum([for (j = [1:k]) cos(theta_sum(j)) * sqrt(j)]),
        sum([for (j = [1:k]) sin(theta_sum(j)) * sqrt(j)])
    ]
];
module line_segment(p1, p2) {
    hull() {
        translate([p1[0], p1[1], 0]) cube([line_width, line_width, height], center=true);
        translate([p2[0], p2[1], 0]) cube([line_width, line_width, height], center=true);
    }
}
color("white")
for (i = [0:n-1]) {
    line_segment(points[i], points[i+1]);
}
color([1, 1, 0.4])
for (i = [1:n]) {
    line_segment([0, 0], points[i]);
}