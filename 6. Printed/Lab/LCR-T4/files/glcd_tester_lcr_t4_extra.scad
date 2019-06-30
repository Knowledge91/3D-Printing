//
//  case for LCR-T4 
//
//  design by Egil Kvaleberg, Apr 2015
//  modified Apr 2016
//
//  the bottom needs four M3x15 (13..18) countersunk screws for assembly
//  the four holes in the top shoud be treaded using an M3 tap
//
//  this case is for a graphical display component tester with one button
//  account 91make at taobao.com
//
//  the design is based on my LCR-T3 case
//
//  this is a variant for the case where the PCB is <= 2mm larger on
//  the right hand side than the original design (see pcbrx)
//

part = "demo"; // [ demo, both, top, bottom, lid ]
with_lid = false;
pcbrx = 2.0; // extra "uncut" PCB at righthand side, 0 for none

pcb = [70.9, 63.1, 1.6]; 
pcbmntdia = 3.1;
pcbthrdia = 2.5; // for threads
pcbmntdx = pcb[0]/2-(1.0+pcbmntdia/2);
pcbmntdy1 = pcb[1]/2-(1.0+pcbmntdia/2);
pcbmntdy2 = -(pcb[1]/2-(18.7+pcbmntdia/2));

batt = [54.0, 26.0, 17.0]; // 9 V battery with contact
lcdwinsize = [54.0, 30.0];
lcdpos = [-(pcb[0]/2-2.2-6.2-lcdwinsize[0]/2), pcb[1]/2-6.6-lcdwinsize[1]/2]; 
lcdextra = 3.5; // extra room needed on top

pcb2bot = 5.0; // room for components
pcb2lcd = 6.4-pcb[2];
      buttonpos = [pcb[0]/2-0.7-11.9/2, -(pcb[1]/2-2.2-11.9/2)]; 
buttondia = 11.6+0.4;
buttonrimdia = 13.0+0.4;
pcb2button = 8.0; // to top of rim BUG: check
socsize = [33.1, 14.8];
      socpos = [-(pcb[0]/2+1.2-socsize[0]/2), -(pcb[1]/2-0.1-socsize[1]/2)]; 

smtsize = [8.0, 10.0+20.0];
      smtpos = [pcb[0]/2-25.4, -(pcb[1]/2-8.6+20.0/2)]; 

socr = 1.0;
wall = 1.2;
caser = wall;
twall = 3.3*wall; // wall size of top - gets a bit flimsy if too thin
bwall = 3.5*wall; // wall size of bottom - gets a bit flimsy if too thin
digh = 10.0;
digw = digh*5/6;
hingewidth = batt[1]*0.6;
lwall = 0.35*wall; // extra material around lid lip
l2wall = 0.0*pcbmntdia; // extra material around lid lip screw

tol = 0.25;
d = 0.01;

real2bot = max(pcb2bot, batt[2]-pcb[2]-pcb2lcd-(twall-wall)); 

module nut(af, h) { // af is 2*r
	cylinder(r=af/2/cos(30), h=h, $fn=6);
}

module c_cube(x, y, z) {
	translate([-x/2, -y/2, 0]) cube([x, y, z]);
}

module cr_cube(x, y, z, r) {
	hull() {
		for (dx=[-1,1]) for (dy=[-1,1]) translate([dx*(x/2-r), dy*(y/2-r), 0]) cylinder(r=r, h=z, $fn=20);
	}
}

module cr2_cube(x, y, z, r1, r2) {
	hull() {
		for (dx=[-1,1]) for (dy=[-1,1]) translate([dx*(x/2-r1), dy*(y/2-r1), 0]) cylinder(r1=r1, r2=r2, h=z, $fn=20);
	}
}

module sochandle() {
	// cutout for socket handle and socket itself
	translate([socpos[0], socpos[1]-socsize[1]/2+1.0, 0]) hull () {
		rotate([0, -90, 0]) cylinder(r=1.25, h=20, $fn=12);
		translate([0, 0, 5.0]) rotate([0, -90, 0]) cylinder(r=1.25, h=20, $fn=12);
	}
	translate([socpos[0], socpos[1], -(d+pcb2lcd-tol)]) {
		cr_cube(socsize[0]+2*tol, socsize[1]+2*tol, 2*d+pcb2lcd-tol+d+twall+d, socr);
	}
}


module top() {
	sidewalls();
	difference() {
		union() {
			translate([pcbrx/2, batt[1]/2+tol+wall/2+lcdextra/2, -(pcb2lcd-tol)]) {
				cr_cube(pcb[0]+2*wall+2*tol+pcbrx, pcb[1]+batt[1]+lcdextra+3*wall+4*tol, twall+(pcb2lcd-tol), caser);
			}
			for (dx=[pcbmntdx, -pcbmntdx]) {
				translate([dx, pcbmntdy1+batt[1]+lcdextra+wall, -(pcb2lcd+pcb[2])]) { // at battery	
					cylinder(r=pcbmntdia/2+tol+wall, h=pcb[2]+tol+d, $fn=20);
				}
			}
		}
		translate([0, 0, -d]) {
			translate([lcdpos[0], lcdpos[1], 0]) cr2_cube(lcdwinsize[0], lcdwinsize[1], d+twall+d, 0.1, twall/2);
			translate([buttonpos[0], buttonpos[1], 0]) {
				cylinder(r = buttondia/2+tol, h=99.9, $fn=60);
				cylinder(r = buttonrimdia/2+tol, h=d+pcb2button-pcb2lcd, $fn=60);
				translate([0,0, -(d+pcb2lcd-tol)]) c_cube(buttonrimdia+0.5, buttonrimdia+3.0, 2*d+pcb2lcd-tol);
			}

			hull () {
				sochandle();
				translate([3.8, 0, -wall]) sochandle(); // need extra room so that PCB can be inserted
			}

			translate([smtpos[0], smtpos[1], 0]) {
				cr2_cube(smtsize[0]+2*tol+4.0+2*1.0, smtsize[1]+2*tol+4.0+2*1.0, d+twall+d, 4.0, 4.0+0.75);
				translate([0, 0, -(d+pcb2lcd-tol)]) cr2_cube(smtsize[0]+2*tol, smtsize[1]+2*tol, 2*d+pcb2lcd-tol, 1.0, 4.0);
			}
//T3:			translate([bwirepos[0], bwirepos[1], -(d+pcb2lcd-tol)]) c_cube(bwiresize[0]+2*tol, bwiresize[1]+2*tol, d+pcb2lcd-tol);

			for (n=[0:6]) translate([-pcb[0]/2+digw*(n+1), pcb[1]/2 + 2.0, twall+2*d-digh/14]) { // digh/14 is depth
				translate([0, 16.0, 0]) p_ch("1231111"[n], digh);
				p_ch("2223333"[n], digh);
			}
			
			translate([pcbrx/2, lcdpos[1]+(lcdextra+wall+2*tol+4.6)/2, -(d+pcb2lcd-tol)]) 
				c_cube(pcb[0]+2*tol+pcbrx, lcdwinsize[1]+4.0+(lcdextra+wall+2*tol+4.6), 2*d+pcb2lcd-tol);	// inner lcd
	
			translate([0, 0, d]) battery();
			screws();
			lidcutout();
			
			for (dx=[pcbmntdx, -pcbmntdx]) {
				translate([dx, pcbmntdy2, -(d+pcb2lcd+pcb[2])]) {
					cylinder(r=pcbthrdia/2, h=pcb2lcd+pcb[2]+twall-wall, $fn=20);
				}
				translate([dx, pcbmntdy1+batt[1]+lcdextra+wall, -(d+pcb2lcd+pcb[2])]) { // at battery	
					cylinder(r=pcbthrdia/2, h=pcb2lcd+pcb[2]+twall-wall, $fn=20);
				}
			}

		}
	}	

}

module sidewalls() {
	difference() {
		union () {
			difference() {
				translate([0, lcdextra/2, -(wall+real2bot+pcb[2]+pcb2lcd)]) {
					translate([pcbrx/2, batt[1]/2+tol+wall/2, 0]) cr2_cube(pcb[0]+2*wall+2*tol+pcbrx, pcb[1]+batt[1]+lcdextra+3*wall+4*tol, (wall+real2bot+pcb[2]+pcb2lcd+wall), caser, caser);
				}
				translate([0, lcdextra/2, -(real2bot+pcb[2]+pcb2lcd)]) {
					translate([pcbrx/2, batt[1]/2+tol+wall/2, -wall-d]) cr_cube(pcb[0]+2*tol+pcbrx, pcb[1]+batt[1]+lcdextra+wall+4*tol, d+bwall+tol, caser/2); // room for bottom lid

					translate([pcbrx/2, batt[1]/2+tol+wall/2, real2bot+pcb[2]+pcb2lcd-d]) cr_cube(pcb[0]+2*wall+4*tol+pcbrx, pcb[1]+batt[1]+lcdextra+3*wall+6*tol, wall+2*d, caser+tol);
					translate([pcbrx/2, 0, 0]) c_cube(pcb[0]+2*tol+pcbrx, pcb[1]+lcdextra+2*tol, real2bot+pcb[2]+pcb2lcd+d); // room for pcb
					translate([pcbrx/2, pcb[1]/2+batt[1]/2+2*tol+wall+lcdextra/2, 0]) c_cube(pcb[0]+2*tol+pcbrx, batt[1]+2*tol, real2bot+pcb[2]+pcb2lcd+d); // room for battery
				}
			}

		}
		union () { 
			// cutout for smt
			translate([smtpos[0], smtpos[1], -(pcb2lcd-tol)]) cr2_cube(smtsize[0]+2*tol, smtsize[1]+2*tol, d+pcb2lcd-tol+wall, 1.0, 4.0+wall*0.8); 
			// cutout for battery wire
			translate([-0.93*pcb[0]/2, pcb[1]/2, -(real2bot+pcb[2]+pcb2lcd)]) hull () {
    			rotate([-90, 0, 0]) cylinder(r=0.8, h=10, $fn=12);
				translate([0, 0, bwall+2.0]) rotate([-90, 0, 0]) cylinder(r=1.0, h=10, $fn=12);
			}
			sochandle(); 
			battery();
		}
	}
}

module bottom() {
	module support(dx, dy, tap) {
		translate([dx, dy, -(d+real2bot+pcb[2]+pcb2lcd)]) {
			cylinder(r1=pcbmntdia/2+2*wall, r2=pcbmntdia/2+wall, h=d+real2bot, $fn=20);
			if (tap > 0) cylinder(r=pcbmntdia/2-tol, h=d+real2bot+tap, $fn=20);
		}
	}
	difference() {
		union () {
			// bottom lid
			translate([0, lcdextra/2, -(wall+real2bot+pcb[2]+pcb2lcd)]) {
				translate([0, batt[1]/2+tol+wall/2, 0]) {
					translate([pcbrx/2, 0, 0]) cr_cube(pcb[0]+pcbrx, pcb[1]+batt[1]+lcdextra+wall+2*tol, bwall, caser/2);
					if (with_lid) translate([pcb[0]/2 - (pcb[0]-batt[0])/2/2, (pcb[1]+batt[1]+lcdextra+wall+2*tol)/2-batt[1]/2, 0]) cr_cube((pcb[0]-batt[0])/2, batt[1], real2bot+wall, caser/2); // extra supporting bar
				}
			}
			intersection () {
				translate([0, lcdextra/2, -(real2bot+pcb[2]+pcb2lcd)]) {
					translate([pcbrx/2, batt[1]/2+tol+wall/2, 0]) cr_cube(pcb[0]+pcbrx, pcb[1]+batt[1]+lcdextra+wall+2*tol, real2bot+pcb[2], caser/2);
				}
				union () {	
					for (dx=[pcbmntdx, -pcbmntdx]) {
						support(dx, pcbmntdy1, pcb[2]);	
						support(dx, pcbmntdy2, 0/*pcb[2]+pcb2lcd*/);
						support(dx, pcbmntdy1+batt[1]+lcdextra+wall, 0); // at battery	
					}
					support(-pcbmntdx, -pcbmntdy1, 0);
					hull () {
						support(smtpos[0]-smtsize[0]/2, -pcbmntdy1, 0);
						support(smtpos[0]+smtsize[0]/2, -pcbmntdy1, 0);
					}
				}
			}
		}
		battery();
		screws();
		lidcutout();
	}
}


module screws() {
	for (dx=[pcbmntdx, -pcbmntdx]) { // screw?
		translate([dx, pcbmntdy2, -(d+wall+real2bot+pcb[2]+pcb2lcd)]) {
			cylinder(r1=pcbmntdia, r2=0, h=pcbmntdia, $fn=20); // countersink recess
			cylinder(r=pcbmntdia/2+tol, h=d+wall+real2bot+d, $fn=20);
		}
		translate([dx, pcbmntdy1+batt[1]+lcdextra+wall, -(d+wall+real2bot+pcb[2]+pcb2lcd)]) { // at battery	
			cylinder(r1=pcbmntdia, r2=0, h=pcbmntdia, $fn=20); // countersink recess
			cylinder(r=pcbmntdia/2+tol, h=d+wall+real2bot+d, $fn=20);
		}
	}
}

module battery() {
	translate([0, pcb[1]/2+batt[1]/2+2*tol+wall+lcdextra, -batt[2]+(twall-wall)]) cr_cube(batt[0], batt[1], batt[2], 0.5);
}


module lid() {
	translate([0, pcb[1]/2+batt[1]/2+2*tol+wall+lcdextra, -batt[2]+(twall-wall)-wall]) rotate([0,0,180]) 
		difference () { 
			union () {
			c_cube(batt[0], batt[1], wall);
			// hinge
			translate([batt[0]/2, 0, 0]) {	
				hull () {
					translate([-wall/2, 0, wall/2]) c_cube(wall+0.5, hingewidth, d);
					translate([wall/2, 0, wall]) c_cube(wall+0.5, hingewidth, wall);
				}
			}
			// lip: hole is pcbmntdia/2+l2wall from the edge
			translate([-batt[0]/2, 0, 0]) {	
				c_cube(2*(pcbmntdia/2+l2wall), 2*(pcbmntdia+lwall), wall);
				translate([-(pcbmntdia/2+l2wall), 0, 0]) cylinder(r = pcbmntdia+lwall, h=wall, $fn=30);
			}
		}
		// minus recessed screw
		translate([-batt[0]/2-(pcbmntdia/2+l2wall), 0, -d]) {	
			//cylinder(r = pcbmntdia/2, h=d+wall+real2bot+pcb[2], $fn=20);
			cylinder(r1 = pcbmntdia, r2=0, h=pcbmntdia, $fn=20);
		}	
	}
}

module lidcutout() { // cutout for lid
	if (with_lid) translate([0, pcb[1]/2+batt[1]/2+2*tol+wall+lcdextra, -batt[2]+(twall-wall)-wall-d]) rotate([0,0,180]) {
		c_cube(batt[0]+2*tol, batt[1]+2*tol, d+wall+tol);
		// hinge
		translate([batt[0]/2, 0, -d]) {	
			hull () {
				translate([-wall/2, 0, wall/2]) c_cube(wall+0.5+2*tol, hingewidth+2*tol, d);
				translate([wall/2, 0, wall-tol]) c_cube(wall+0.5+2*tol, hingewidth+2*tol, wall+2*tol);
			}
		}
		// lip for screw
		translate([-batt[0]/2, 0, 0]) {	
			c_cube(2*(pcbmntdia/2+l2wall), 2*(pcbmntdia+lwall+tol), wall+2*d);
			translate([-(pcbmntdia/2+l2wall), 0, 0]) cylinder(r = pcbmntdia+lwall+tol, h=wall+2*d, $fn=30);
		}
		// screw
		translate([-batt[0]/2, 0, 0]) {	
			translate([-(pcbmntdia/2+l2wall), 0, 0]) cylinder(r = pcbthrdia/2, h=d+wall+real2bot+pcb[2], $fn=20);
		}

	}
}

module p_ch(ch, hb) {
	// hb is height of character
	hh = hb/10;
	hw = hb/2 + hh/2;
	
	d = 0.01;
	
	if (ch=="1") {
		translate([-hw/2, 0, 0]) cube([hw, hh, hh]);
		translate([-hh/2, 0, 0]) cube([hh, hb, hh]);
		translate([0, hb-hh/2, 0]) rotate([0, 0, 180+45]) translate([0, -hh/2, 0]) cube([hw/2, hh, hh]);
	}
	if (ch=="2") {
		translate([-hw/2, 0, 0]) cube([hw, hh, hh]);
		translate([-hw/2, hh, 0]) rotate([0, 0, 51.5]) translate([0, -hh, 0]) cube([0.665*hb, hh, hh]);
		translate([0, hb-hw/2, 0]) difference () {
			cylinder(r = hw/2, h=hh, $fn=32);
			translate([0,0,-d]) {
				cylinder(r = hw/2-hh, h=hh+2*d, $fn=32);  
				rotate([0, 0, 180]) cube([hw/2, hw/2, hh+2*d]); 
				rotate([0, 0, 180+51.5]) cube([hw/2, hw/2, hh+2*d]); 
			}
		}
	}
	if (ch=="3") difference () {
		union () {
			translate([0, hw/2, 0]) difference () {
				cylinder(r = hw/2, h=hh, $fn=32);
				translate([0,0,-d]) cylinder(r = hw/2-hh, h=hh+2*d, $fn=16);  
			}
			translate([0, hb-hw/2, 0]) difference () {
				cylinder(r = hw/2, h=hh, $fn=32);
				translate([0,0,-d]) cylinder(r = hw/2-hh, h=hh+2*d, $fn=16);  
			}
		}
		translate([-hw/2, hb/2/2, -d]) cube([hw/2-hh/4, hb/2, hh+2*d]);
	}
}


if (part=="top") rotate([0, 180, 0]) top();
if (part=="demo") top();

if (part=="demo" || part=="bottom") bottom();

if (part=="demo" || part=="bottom") bottom();

if (part=="demo" || part=="lid") lid();

if (part=="demo") color("green") battery();

if (part=="both") {
	translate([-pcb[0]/2-wall-4, 0, bwall]) rotate([0, 180, 0]) top();
	translate([pcb[0]/2+wall+4, 0, pcb2lcd+pcb[2]+real2bot+wall+tol]) bottom();
}

// min M3 screw length
echo(bwall+pcb2bot+pcb[2]+2.0); 
// max M3 screw length
echo(bwall+pcb2bot+pcb[2]+pcb2lcd+twall-wall);
