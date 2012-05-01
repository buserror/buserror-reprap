
E=0.001;

TPW = 48.1;
TPL = 50;
TPH = 1.1;

ETHSize	= [15, 13.5, 11.6];
ETHPos = [7.5, -2.7, -2.8];
USBMiniSize = [8.2, 5.5, 3];
USBMiniPos = [27.5, -1.5, -0.5];

//translate([0,0,0]) cube([10, 20, 1]);
roundrect(size=[TPW, TPL, TPH], r=4, fit=0);
translate(ETHPos) cube(size=ETHSize);
translate(USBMiniPos) cube(size=USBMiniSize);

module roundrect(size=[0,0,0], r=1, center=0, fit=1) {
	assign(sx = size[0]- (fit* (2*r)), sy = size[1] - (fit * (2*r)))
	translate([-center*size[0]/2, -center*size[1]/2, -center*size[2]/2])
	linear_extrude(height=size[2], slices=1)
	hull() {
		translate([r,r,0])
			for (x=[0:1]) for (y=[0:1]) 
				translate([x*sx, y*sy, 0])
					circle(r=r);
	}
}
