$fn = 64; 
spirals = 200;      
base_scale = 5;      
height_step = 0.5;    
thickness = 0.5;    
line_radius = 0.2;    
module line_segment(p1, p2) {
    dir = p2 - p1;
    length = norm(dir);
    axis = cross([0, 0, 1], dir);
    angle = acos(dir[2] / length) * 180 / PI;
    translate(p1)
    rotate([0, 0, angle])
    rotate([0, atan2(dir[1], dir[0]) * 180 / PI, 0])
    cylinder(r=line_radius, h=length, center=false);
}
module right_triangle(n, angle_sum, height) {
    hypotenuse = sqrt(n) * base_scale;    
    vertical = 1 * base_scale;           
    base = sqrt(n - 1) * base_scale;      
    points = [
        [0, 0, height],               
        [base, 0, height],           
        [base, 0, height + vertical],  
        [0, thickness, height],        
        [base, thickness, height],     
        [base, thickness, height + vertical] 
    ];
    faces = [
        [0, 1, 2],       
        [3, 5, 4],       
        [0, 3, 4, 1],     
        [1, 4, 5, 2],     
        [2, 5, 3, 0]      
    ];
    rotate([0, 0, angle_sum])
    polyhedron(points=points, faces=faces);
}
module conical_theodorus_spiral() {
    angle_sum = 0; 
    right_angle_points = []; 
    for (n = [1:spirals]) {
        angle = atan2(1, sqrt(n-1)) * 180/PI;
        angle_sum = angle_sum + angle;
        height = (n-1) * height_step;
        base = sqrt(n - 1) * base_scale;
        x = base * cos(angle_sum);
        y = base * sin(angle_sum);
        z = height;  
        right_angle_points = concat(right_angle_points, [[x, y, z]]);
        t = (n-1) / (spirals-1);
        r = 1 - t * (1 - 0.4);   
        g = 1;                    
        b = 1;                     
        color([r, g, b])
        translate([0, 0, height])  
        right_triangle(n, angle_sum, 0);
    }
    if (len(right_angle_points) >= 2) {
        color([1, 0, 0])  
        for (i = [0:1:len(right_angle_points)-2]) {
            line_segment(right_angle_points[i], right_angle_points[i+1]);
        }
    }
}
conical_theodorus_spiral();