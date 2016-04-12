clear all;
clc;

% Three types of buses exist constant output P and Q is type 3
% Voltage controlled bus or generator output P and V is type 2
% Allowed only 1, variable P and Q adjusted by needs of system (known as slack bus)



%%%%%%%%%%%%%%%%%%% INSERT SYSTEM INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pgen = [0 0 0];
Pgen_max = [1 1 1];
Qgen = [0 0 0];
Pload = [0 0 1];
Qload = [0 0 0.5];
bus_type = [1, 2, 3];
V = [1 1 1];
delta = [0 0 0];
coordinatey = [40.6818  38.9017  39.952]; 
coordinatex = -[74.2149  77.0678  75.1634];

j = sqrt(-1);

from_bus = [1 1 2];
to_bus = [2 3 3];
R = [0.02, 0.01, 0.01];
X = [0.3, 0.1, 0.1];
B = [0.15, 0.1, 0.1];
Pmax = [1, 1, 1];

no_bus = 3;

Y = zeros(no_bus,no_bus);

disp('collecting data and running load flow')

%%%%%%%%%%%%%%%%%%%%%%%% CALCULATE ADMITTANCE MATRIX %%%%%%%%%%%%%%%%%%%

for i = 1:no_bus
	for k = 1:no_bus
		if i ~= k
			for w = 1:length (from_bus)
				if from_bus(w) == i
					if to_bus(w) == k
						Y(i,k) = -1/(R(w) + j*X(w));
					end;
				end;
			end;
			
			for w = 1:length (to_bus)
				if to_bus(w) == i
					if from_bus(w) == k
						Y(i,k) = -1/(R(w) + j*X(w));
					end;
				end;
			end;			
		end;
	end;
end;

for i = 1:no_bus
	Y(i,i) = -sum(Y(i,:));
end;

for i = 1:no_bus
	for k = 1:no_bus
		if i ~= k
			for w = 1:length (from_bus)
				if from_bus(w) == i
					if to_bus(w) == k
						Y(i,i) = Y(i,i)  + j*B(w)/2;
					end;
				end;
			end;
			
			for w = 1:length (to_bus)
				if to_bus(w) == i
					if from_bus(w) == k
						Y(i,i) =Y(i,i)  + j*B(w)/2;
					end;
				end;
			end;			
		end;
	end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


error = 1;
too_many = 1;

while error > .0001
too_many = too_many + 1;

%%%%%%%%%%%%%%%%%%%%%% CALCULATE B %%%%%%%%%%%%%%%%%%%%%

pos_delta = 0;
for i = 1:no_bus
	if bus_type(i) ~= 1
		hold = 0;
		for w = 1:no_bus
			hold = V(i)*V(w)*abs(Y(i,w))*cos(delta(i) - delta(w) - angle(Y(i,w))) + hold;
		end;
		pos_delta = pos_delta+1;
		b(pos_delta) = Pgen(i) - Pload(i) - hold;
	end;
end;

for i = 1:no_bus
	if bus_type(i) ~= 1
		if bus_type(i) ~= 2
			hold = 0;
			for w = 1:no_bus
				hold = V(i)*V(w)*abs(Y(i,w))*sin(delta(i) - delta(w) - angle(Y(i,w))) + hold;
			end;
			pos_delta = pos_delta+1;
			b(pos_delta) = Qgen(i) - Qload(i) - hold;
		end;
	end;
end;

%%%%%%%%%%%%%%%%%%%%%%%% JACOBIAN MATRIX CREATION %%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% JACOBIAN 1 %%%%%%%%%%%%%%%


pos_r = 1;
pos_c = 1;
hold_c = 1;
hold_r = 1;
for i = 1:no_bus
	if bus_type(i) ~= 1
		for k = 1:no_bus
			if bus_type(k) ~= 1 
		  		if i == k
					J(pos_r,pos_c) = 0;
					for w = 1:no_bus
						J(pos_r,pos_c) =V(i)*V(w)*abs(Y(i,w))*sin(delta(i) - delta(w) - angle(Y(i,w))) + J(pos_r,pos_c);
					end;
					J(pos_r,pos_c) = J(pos_r,pos_c) + V(i)^2 * abs(Y(i,i)) *sin(angle(Y(i,i)));
					pos_c = pos_c + 1;
				else
					J(pos_r,pos_c) = - V(i) * V(k) * abs(Y(i,k)) *sin(delta(i) - delta(w) - angle(Y(i,k)));
					pos_c = pos_c + 1;
				end;
				
				if hold_c < pos_c
					hold_c = pos_c;
				end;
				
				if k == no_bus
					pos_c = 1;
					pos_r = pos_r + 1;
				end;
				
				if hold_r < pos_r
					hold_r = pos_r;
				end;
			end;
		end;
	end
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% JACOBIAN 2 %%%%%%%%%%%%%%%

pos_c = hold_c;
pos_r = 1;
for i = 1:no_bus
	if bus_type(i) ~= 1 
		for k = 1:no_bus
			if bus_type(k) ~= 1 && bus_type(k) ~= 2
		  		if i == k
					J(pos_r,pos_c) = 0;
					for w = 1:no_bus
						J(pos_r,pos_c) = V(w)*abs(Y(i,w))*cos(delta(i) - delta(w) - angle(Y(i,w))) + J(pos_r,pos_c);
					end;

					J(pos_r,pos_c) = - J(pos_r,pos_c) - V(i) * abs(Y(i,i)) *cos(angle(Y(i,i)));
					pos_c = pos_c + 1;
				else
					J(pos_r,pos_c) = - V(i) * abs(Y(i,k)) *cos(delta(i) - delta(w) - angle(Y(i,k)));
					pos_c = pos_c + 1;
				end;
			end;
			if k == no_bus
				pos_c = hold_c;
				pos_r = pos_r + 1;
			end;
		end;

	end
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%% JACOBIAN 3 %%%%%%%%%%%%%%%

pos_c = 1;
pos_r = hold_r;
for i = 1:no_bus
	if bus_type(i) ~= 1 && bus_type(i) ~= 2
		for k = 1:no_bus
			if bus_type(k) ~= 1 
		  		if i == k
					J(pos_r,pos_c) = 0;
					for w = 1:no_bus
						J(pos_r,pos_c) = V(i)*V(w)*abs(Y(i,w))*cos(delta(i) - delta(w) - angle(Y(i,w))) + J(pos_r,pos_c);
					end;

					J(pos_r,pos_c) = - J(pos_r,pos_c) + V(i)^2 * abs(Y(i,i)) *cos(angle(Y(i,i)));
					pos_c = pos_c + 1;
				else
					J(pos_r,pos_c) = V(i) *V(k) * abs(Y(i,k)) *cos(delta(i) - delta(w) - angle(Y(i,k)));
					pos_c = pos_c + 1;
				end;
			end;
			if k == no_bus
				pos_c = 1;
				pos_r = pos_r + 1;
			end;
		end;

	end
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% JACOBIAN 4 %%%%%%%%%%%%%%%

pos_c = hold_c;
pos_r = hold_r;
for i = 1:no_bus
	if bus_type(i) ~= 1 && bus_type(i) ~= 2
		for k = 1:no_bus
			if bus_type(k) ~= 1 && bus_type(k) ~= 2 
		  		if i == k
					J(pos_r,pos_c) = 0;
					for w = 1:no_bus
						J(pos_r,pos_c) = V(w)*abs(Y(i,w))*sin(delta(i) - delta(w) - angle(Y(i,w))) + J(pos_r,pos_c);
					end;

					J(pos_r,pos_c) = - J(pos_r,pos_c) + V(i) * abs(Y(i,i)) *sin(angle(Y(i,i)));
					pos_c = pos_c + 1;
				else
					J(pos_r,pos_c) = - V(k) * abs(Y(i,k)) *sin(delta(i) - delta(w) - angle(Y(i,k)));
					pos_c = pos_c + 1;
				end;
			end;
			if k == no_bus
				pos_c = hold_c;
				pos_r = pos_r + 1;
			end;
		end;

	end
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%% DETERMINE UNKNOWNS BASED ON BUS TYPE %%%%%%%%%%%%%%%%%%%%

pos = 1;
for i = 1:no_bus
	if bus_type(i) ~= 1
		x(pos) = delta(i);
		pos = pos + 1;
	end;
end;

for i = 1:no_bus
	if bus_type(i) ~= 1 && bus_type(i) ~= 2
		x(pos) = V(i);
		pos = pos + 1;
	end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%% SOLVE FOR X %%%%%%%%%%%%%%%%%%%%

delta_x = inv(J)*b';

x = x - delta_x';

error = max(abs(b));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%% ADJUST PARAMETERS %%%%%%%%%%%%%%%%%%%%

pos = 1;
for i = 1:no_bus
	if bus_type(i) ~= 1
		delta(i) = x(pos);
		pos = pos + 1;
	end;
end;

for i = 1:no_bus
	if bus_type(i) ~= 1 && bus_type(i) ~= 2
		V(i) = x(pos);
		pos = pos + 1;
	end;
end;

if too_many == 100
	error = 10^-10;
	disp('problem solving...maximum iterations reached...solution may not be correct.')
	break;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%% CALCULATE POWER FLOW %%%%%%%%%%%%%%

for i = 1:length(from_bus)
	k = from_bus(i);
	m = to_bus(i);
	Pflow(i) = V(k)*V(m)*abs(Y(k,m))*cos(delta(k)-delta(m)-angle(Y(k,m)))-V(k)^2*abs(Y(k,m))*cos(angle(Y(k,m)));
end;

for i = 1:length(bus_type)
	Phold = 0;
	if bus_type(i) == 1;
		
		for w = 1:length(from_bus)
			if from_bus(w) == i
				k = from_bus(w);
				m = to_bus(w);
				Phold = V(k)*V(m)*abs(Y(k,m))*cos(delta(k)-delta(m)-angle(Y(k,m)))-V(k)^2*abs(Y(k,m))*cos(angle(Y(k,m))) + Phold;
			end;
		end;
			
		for w = 1:length(to_bus)
			if to_bus(w) == i
				k = from_bus(w);
				m = to_bus(w);
				Phold = Phold - (V(k)*V(m)*abs(Y(k,m))*cos(delta(k)-delta(m)-angle(Y(k,m)))-V(k)^2*abs(Y(k,m))*cos(angle(Y(k,m))) );
			end;
		end;
	 	Pgen(i) = Pgen(i) - Pload(i) + Phold;
	 end;
end;		

disp('load flow compete....printing results to kml')

%%%%%%%%%%%%%%%%%%% PLOTTING DATA FOR GOOGLE EARTH %%%%%%%%%%%%%%%%%%%%%


cap=ones(length(coordinatex),1);
mag=ones(length(coordinatex),1);

cap_max = max(cap);
mag_max = cap;

coordinate(:,1) = coordinatex';
coordinate(:,2) = coordinatey';

fid = fopen('Example Three Bus.kml','wt');

fprintf(fid,'<?xml version="1.0" encoding="UTF-8"?>\n');
fprintf(fid,'<kml xmlns="http://www.opengis.net/kml/2.2">\n');
fprintf(fid,'<Document>\n');
fprintf(fid,'<name> System.kml</name>\n');
fprintf(fid,'<open>1</open>\n');

%%%%%%%%%%%%%%%%%%% PLOTTING DATA FOR GENERATORS %%%%%%%%%%%%%%%%%%%%%

a = 1;
for j = 1:length(Pgen)
    
	fprintf(fid,'<Placemark>\n');
	fprintf(fid,'<name>Generator ');
	fprintf(fid,'%.2f', j )
	fprintf(fid,'</name>\n');
	fprintf(fid,'<styleUrl>#ColorIWant</styleUrl>\n');
	fprintf(fid,'<Style id="ColorIWant">\n');
	fprintf(fid,'<LineStyle>\n');
	fprintf(fid,'<color>00ff0000</color>\n');
	fprintf(fid,'<width>.01</width>\n');
	fprintf(fid,'<colorMode>normal</colorMode>\n');
	fprintf(fid,'</LineStyle>\n');
	fprintf(fid,'<PolyStyle>\n');
 
	if (Pgen(j)/Pgen_max(j) <= 1.00)
    	fprintf(fid,'<color>ff0000ff</color>\n');
	elseif (Pgen(j)/Pgen_max(j) > .85) && ( Pgen(j)/Pgen_max(j) < 1.00)
	    fprintf(fid,'<color>ff00ff00</color>\n');
	elseif (Pgen(j)/Pgen_max(j) <= .85)
    	fprintf(fid,'<color>ff0000ff</color>\n');
	end

	fprintf(fid,'<colorMode>normal</colorMode>\n');
	fprintf(fid,'</PolyStyle>\n');
	fprintf(fid,'</Style>\n');
	fprintf(fid,'<description> ')
	
	fprintf(fid,'Generation:\n')
	fprintf(fid,'%.2f',Pgen(j)/Pgen_max(j));
	fprintf(fid,'\n </description>')
	fprintf(fid,'<Polygon>\n');
	fprintf(fid,'<extrude>1</extrude>\n');
	fprintf(fid,'<altitudeMode>relativeToGround</altitudeMode>\n');
	fprintf(fid,'<outerBoundaryIs>\n');
	fprintf(fid,'<LinearRing>\n');
	fprintf(fid,'<coordinates>\n');
	x1 = coordinate(a,1)+.3;
	y1 = coordinate(a,2);
	r = .1;
	points = 5;


	coordinate2 = [x1,y1];
	d = 0: r/points: r+r/points;
	cord(1,:) = [0,-r]+ coordinate2; %coordinate +[0,r]


	% Bottom right of circle
	b = 1;
	for i = 1:length(d)-1
   		b = b + 1;
		new_point = sqrt(r^2 - (r-(d(b)))^2);
		cord(b,:) = cord(1,:) + [new_point,d(b)];
	end

	% Top right of circle
	f = 1;
	ref1 = [r,0]+ coordinate2;
	for i= 1:length(d)-1
    	f = f+1;
   		b = b+1;
    	new_point = sqrt(r^2 - (r-(d(f)))^2);
    	cord(b,:) = ref1 + [-d(f),new_point];
	end

	%Top left of circle
	e = 1;
	ref2 = [0,r]+ coordinate2;
	for i= 1:length(d)-1
    	e = e+1;
    	b = b+1;
    	new_point = sqrt(r^2 - (r-(d(e)))^2);
    	cord(b,:) = ref2 + [-new_point,-d(e)];
	end

	% Bottom left of circle
	c = 1;
	b = b + length(d) - 1;
	ref3 = [0,-r] + coordinate2;
	for i = 1:length(d)-1
   		c = c + 1;
  		new_point = sqrt(r^2 - (r-(d(c)))^2);
		cord(b-i,:) = ref3 + [-new_point,d(c)];
	end

	cord(b,:) = cord(1,:);

 	outputx = cord(:,1);
 	outputy = cord(:,2);
	
	percent_P = Pgen(j)/Pgen_max(j); 
	b = 0; 
	for i = 1:length(outputx)
		b = b + 4;
		if percent_P*100 > b
			outputx(i) = x1;
			outputy(i) = y1;
		end;
	end;
	
	for i = 1:length(outputx)
   		fprintf(fid,'\n%.8f,%.8f,%.0f',outputx(i),outputy(i),5000*cap(a));
	end;
 
	a = a + 1;

	fprintf(fid,'\n</coordinates>\n');
	fprintf(fid,'</LinearRing>\n');
	fprintf(fid,'</outerBoundaryIs>\n');
	fprintf(fid,'</Polygon>\n');
	fprintf(fid,'</Placemark>\n');

end;



%%%%%%%%%%%%%%%%%%% PLOTTING DATA FOR BUSES %%%%%%%%%%%%%%%%%%%%%

a = 1;
for j = 1:length(coordinatex)
    
	fprintf(fid,'<Placemark>\n');
	fprintf(fid,'<name>Bus ');
	fprintf(fid,'%.2f', j )
	fprintf(fid,'</name>\n');
	fprintf(fid,'<styleUrl>#ColorIWant</styleUrl>\n');
	fprintf(fid,'<Style id="ColorIWant">\n');
	fprintf(fid,'<LineStyle>\n');
	fprintf(fid,'<color>00ff0000</color>\n');
	fprintf(fid,'<width>.01</width>\n');
	fprintf(fid,'<colorMode>normal</colorMode>\n');
	fprintf(fid,'</LineStyle>\n');
	fprintf(fid,'<PolyStyle>\n');
 
	if (V(j) <= .95)
    	fprintf(fid,'<color>ff0000ff</color>\n');
	elseif (V(j) > .95) && ( V(j) < 1.05)
	    fprintf(fid,'<color>ff00ff00</color>\n');
	elseif (V(j) >= 1.05)
    	fprintf(fid,'<color>ff0000ff</color>\n');
	end

	fprintf(fid,'<colorMode>normal</colorMode>\n');
	fprintf(fid,'</PolyStyle>\n');
	fprintf(fid,'</Style>\n');
	fprintf(fid,'<description> Bus type:')
	
	if bus_type(j) == 1
		fprintf(fid,'Slack Bus\n');
	elseif bus_type(j) == 2
		fprintf(fid,'Voltage Controlled Bus\n');
	else 
		fprintf(fid,'Load Bus\n');
	end;
	
	fprintf(fid,'Generation:\n')
	fprintf(fid,'Real:')
	fprintf(fid,'%.2f',Pgen(j));
	fprintf(fid,'\nReactive:')
	fprintf(fid,'%.2f',Qgen(j));
	fprintf(fid,'\n\n Load:\n')
	fprintf(fid,' Real:')
	fprintf(fid,'%.2f',Pload(j));
	fprintf(fid,'\n Reactive:')
	fprintf(fid,'%.2f',Qload(j));
	fprintf(fid,'\n\n Voltage:')
	fprintf(fid,'%.2f',V(j));
	fprintf(fid,'\n Angle:')
	fprintf(fid,'%.2f',delta(j)*180/pi);
	fprintf(fid,'\n </description>')
	fprintf(fid,'<Polygon>\n');
	fprintf(fid,'<extrude>1</extrude>\n');
	fprintf(fid,'<altitudeMode>relativeToGround</altitudeMode>\n');
	fprintf(fid,'<outerBoundaryIs>\n');
	fprintf(fid,'<LinearRing>\n');
	fprintf(fid,'<coordinates>\n');
	x1 = coordinate(a,1);
	y1 = coordinate(a,2);
	r = .1;
	points = 5;


	coordinate2 = [x1,y1];
	d = 0: r/points: r+r/points;
	cord(1,:) = [0,-r]+ coordinate2; %coordinate +[0,r]


	% Bottom right of circle
	b = 1;
	for i = 1:length(d)-1
   		b = b + 1;
		new_point = sqrt(r^2 - (r-(d(b)))^2);
		cord(b,:) = cord(1,:) + [new_point,d(b)];
	end

	% Top right of circle
	f = 1;
	ref1 = [r,0]+ coordinate2;
	for i= 1:length(d)-1
    	f = f+1;
   		b = b+1;
    	new_point = sqrt(r^2 - (r-(d(f)))^2);
    	cord(b,:) = ref1 + [-d(f),new_point];
	end

	%Top left of circle
	e = 1;
	ref2 = [0,r]+ coordinate2;
	for i= 1:length(d)-1
    	e = e+1;
    	b = b+1;
    	new_point = sqrt(r^2 - (r-(d(e)))^2);
    	cord(b,:) = ref2 + [-new_point,-d(e)];
	end

	% Bottom left of circle
	c = 1;
	b = b + length(d) - 1;
	ref3 = [0,-r] + coordinate2;
	for i = 1:length(d)-1
   		c = c + 1;
  		new_point = sqrt(r^2 - (r-(d(c)))^2);
		cord(b-i,:) = ref3 + [-new_point,d(c)];
	end

	cord(b,:) = cord(1,:);

 	outputx = cord(:,1);
 	outputy = cord(:,2);

	for i = 1:length(outputx)
   		fprintf(fid,'\n%.8f,%.8f,%.0f',outputx(i),outputy(i),5000*cap(a));
	end;
 
	a = a + 1;

	fprintf(fid,'\n</coordinates>\n');
	fprintf(fid,'</LinearRing>\n');
	fprintf(fid,'</outerBoundaryIs>\n');
	fprintf(fid,'</Polygon>\n');
	fprintf(fid,'</Placemark>\n');

end;

%%%%%%%%%%%%%%%%%%% PLOTTING DATA FOR LINES %%%%%%%%%%%%%%%%%%%%%

for i = 1:length(from_bus)


	fprintf(fid,'\n<Style id="yellowLineGreenPoly">\n');
	fprintf(fid,'<LineStyle>\n');
	fprintf(fid,'<color>7f00ffff</color>\n');
	fprintf(fid,'<width>5</width>\n');
	fprintf(fid,' </LineStyle>\n');
	fprintf(fid,'<color>7f00ff00</color>\n');
	fprintf(fid,'</Style>\n');

	fprintf(fid,'\n<Style id="greenLineGreenPoly">\n');
	fprintf(fid,'<LineStyle>\n');
	fprintf(fid,'<color>7f00ff00</color>\n');
	fprintf(fid,'<width>5</width>\n');
	fprintf(fid,' </LineStyle>\n');
	fprintf(fid,'<color>7f00ff00</color>\n');
	fprintf(fid,'</Style>\n');

	fprintf(fid,'\n<Style id="redLineGreenPoly">\n');
	fprintf(fid,'<LineStyle>\n');
	fprintf(fid,'<color>7f0000ff</color>\n');
	fprintf(fid,'<width>5</width>\n');
	fprintf(fid,' </LineStyle>\n');
	fprintf(fid,'<color>7f00ff00</color>\n');
	fprintf(fid,'</Style>\n');

	fprintf(fid,'<Placemark>\n');
	fprintf(fid,'<name>Transmission line ') 
	fprintf(fid,'%.2f', i)
	fprintf(fid,'</name>\n');
	fprintf(fid,'<description>')
	fprintf(fid,'Resistance:')
	fprintf(fid,'%.2f',R(i));
	fprintf(fid,'\nReactance:')
	fprintf(fid,'%.2f',X(i));
	fprintf(fid,'\nPower flow:')
	fprintf(fid,'%.2f',Pflow(i));
	fprintf(fid,'\nMaximum flow:')
	fprintf(fid,'%.2f',Pmax(i));
	fprintf(fid,'</description>\n')


	if Pflow(i)/Pmax(i) > 1
		fprintf(fid,'<styleUrl>#redLineGreenPoly</styleUrl>\n');
	elseif Pflow(i)/Pmax(i) < 1 && Pflow(i)/Pmax(i) > .85
		fprintf(fid,'<styleUrl>#yellowLineGreenPoly</styleUrl>\n');
	else
		fprintf(fid,'<styleUrl>#greenLineGreenPoly</styleUrl>\n');
	end;

	fprintf(fid,'<LineString>\n');
	fprintf(fid,'<extrude>1</extrude>\n');
	fprintf(fid,'<tessellate>1</tessellate>');
	fprintf(fid,'<altitudeMode>absolute</altitudeMode>\n');
	fprintf(fid,'<coordinates>');
      
	fprintf(fid,'\n%.8f,%.8f,%.0f',coordinatex(from_bus(i)),coordinatey(from_bus(i)),5000);
	fprintf(fid,'\n%.8f,%.8f,%.0f',coordinatex(to_bus(i)),coordinatey(to_bus(i)),5000);
    fprintf(fid,'</coordinates>');
   	fprintf(fid,'</LineString>');
   	fprintf(fid,'</Placemark>');
   
%%%%%%%%%%%%%%%%%%%%%%%%% ADDING FLOW ARROWS %%%%%%%%%%%%%%%%

 	x(1) = coordinatex(from_bus(i));
 	x(2) = coordinatex(to_bus(i));
 	y(1) = coordinatey(from_bus(i));
 	y(2) = coordinatey(to_bus(i));
 
 	base_constant = .3;
 
 	changex = x(2) - x(1);
 	changey = y(2) - y(1);
 
 	mid_y =  [(y(1) + y(2))/2 + changey*1/4, (y(1) + y(2))/2, (y(1) + y(2))/2 - changey*1/4];
 	mid_x =  [(x(1) + x(2))/2 + changex*1/4, (x(1) + x(2))/2, (x(1) + x(2))/2 - changex*1/4];

 	for k = 1:length(mid_y)
 
    constant = Pflow(i)/max(Pflow)*base_constant;
    
 		if changex >= 0 && changey >= 0
 
  			angle_beta = atan(changey/changex);
 			angle_beta_degree = angle_beta*180/pi;
 
 			angle_beta2 = atan(changex/changey);
 			angle_beta_degree2 = angle_beta2*180/pi;
 
 			theta1 = pi/2 - angle_beta - pi/6;
 			theta1_degree = theta1*180/pi;
  
 			theta2 = pi/2 - angle_beta2 - pi/6;
 			theta2_degree = theta2*180/pi;
  
 			y_arrow1 = -constant*cos(theta1)+mid_y(k);
 			x_arrow1 = -constant*sin(theta1)+mid_x(k);
 
 			y_arrow2 = -constant*sin(theta2)+mid_y(k);
 			x_arrow2 = -constant*cos(theta2)+mid_x(k);
 
 		elseif changex <= 0 && changey <= 0
 
 			angle_beta = atan(changey/changex);
 			angle_beta_degree = angle_beta*180/pi;
 
 			angle_beta2 = atan(changex/changey);
 			angle_beta_degree2 = angle_beta2*180/pi;
 	
  			theta1 = pi/2 - angle_beta - pi/6;
 			theta1_degree = theta1*180/pi;
  
 			theta2 = pi/2 - angle_beta2 - pi/6;
 			theta2_degree = theta2*180/pi;
  
 			y_arrow1 = constant*cos(theta1)+mid_y(k);
 			x_arrow1 = constant*sin(theta1)+mid_x(k);
 
 			y_arrow2 = constant*sin(theta2)+mid_y(k);
 			x_arrow2 = constant*cos(theta2)+mid_x(k);
 	
 		elseif changex >= 0 && changey <= 0	

			angle_beta = atan(abs(changey/changex));
 			angle_beta_degree = angle_beta*180/pi
 
 			angle_beta2 = atan(abs(changex/changey));
 			angle_beta_degree2 = angle_beta2*180/pi
 	
  			theta1 = angle_beta - pi/6;
 			theta1_degree = theta1*180/pi;
  
 			theta2 = angle_beta2 - pi/6;
 			theta2_degree = theta2*180/pi;
  
 			y_arrow1 = constant*sin(theta1)+mid_y(k);
 			x_arrow1 = -constant*cos(theta1)+mid_x(k);
 
 			y_arrow2 = constant*cos(theta2)+mid_y(k);
 			x_arrow2 = -constant*sin(theta2)+mid_x(k);

 		else
 
 			angle_beta = atan(abs(changey/changex));
 			angle_beta_degree = angle_beta*180/pi;
 
 			angle_beta2 = atan(abs(changex/changey));
 			angle_beta_degree2 = angle_beta2*180/pi;
 	
  			theta1 = angle_beta - pi/6;
 			theta1_degree = theta1*180/pi;
  
 			theta2 = angle_beta2 - pi/6;
 			theta2_degree = theta2*180/pi;
  
 			y_arrow1 = -constant*sin(theta1)+mid_y(k);
 			x_arrow1 = constant*cos(theta1)+mid_x(k);
 
 			y_arrow2 = -constant*cos(theta2)+mid_y(k);
 			x_arrow2 = constant*sin(theta2)+mid_x(k);
		end;
 
 
 
	fprintf(fid,'<Placemark>\n');
	fprintf(fid,'<name>ORNL</name>\n');
	fprintf(fid,'<styleUrl>#ColorIWant</styleUrl>\n');
	fprintf(fid,'<Style id="ColorIWant">\n');
	fprintf(fid,'<LineStyle>\n');
	fprintf(fid,'<color>00ff0000</color>\n');
	fprintf(fid,'<width>.01</width>\n');
	fprintf(fid,'<colorMode>normal</colorMode>\n');
	fprintf(fid,'</LineStyle>\n');
	fprintf(fid,'<PolyStyle>\n');
 
 	if Pflow(i)/Pmax(i) > 1
		fprintf(fid,'<color>ff0000ff</color>\n');
	elseif Pflow(i)/Pmax(i) < 1 && Pflow(i)/Pmax(i) > .85
		fprintf(fid,'<color>ff00ffff</color>\n');
	else
		fprintf(fid,'<color>ff00ff00</color>\n');
	end;

	fprintf(fid,'<colorMode>normal</colorMode>\n');
	fprintf(fid,'</PolyStyle>\n');
	fprintf(fid,'</Style>\n');
	fprintf(fid,'<Polygon>\n');
	fprintf(fid,'<extrude>1</extrude>\n');
	fprintf(fid,'<altitudeMode>relativeToGround</altitudeMode>\n');
	fprintf(fid,'<outerBoundaryIs>\n');
	fprintf(fid,'<LinearRing>\n');
	fprintf(fid,'<coordinates>\n');

		fprintf(fid,'\n%.8f,%.8f,%.0f',mid_x(k),mid_y(k),5000);
		fprintf(fid,'\n%.8f,%.8f,%.0f',x_arrow1, y_arrow1,5000);
		fprintf(fid,'\n%.8f,%.8f,%.0f',x_arrow2, y_arrow2,5000);
		fprintf(fid,'\n%.8f,%.8f,%.0f',mid_x(k),mid_y(k),5000);      

	fprintf(fid,'\n</coordinates>\n');
	fprintf(fid,'</LinearRing>\n');
	fprintf(fid,'</outerBoundaryIs>\n');
	fprintf(fid,'</Polygon>\n');
	fprintf(fid,'</Placemark>\n');

	end;
end; 

fprintf(fid,'</Document>\n');
fprintf(fid,'</kml>\n');

fclose(fid);

disp('program complete')


