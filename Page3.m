
% Plot the obective function, the contour of objective function, and the
% feasible region of a nonlinear programing

%Alireza Kabgani
%a.kagani@gmail.com
%Ref: Jorge Nocedal and Stephen J. Wright: Numerical Optimization (2ed.) Springer, 2006.
%Figure 1.1 in Ref, Page 3

% This code plots the obective function, the contour of objective function, and the
% feasible region of a nonlinear programing
%     min f(x)
%     s.t  g_i(x)<=0
%in a square started at st and end at ed

clear
clc
close

%% Plot objective function and 
%
st=-5; 
en=5;
F=@(x,y) (x-2).^2 + (y-1).^2; %the obective function

%constraints g_i(x)<=0

cond{1} =@(x,y) x.^2-y; 
cond{2} =@(x,y) x+y -2;


%%%%%%%%%%%%% Don't Change %%%%%%%%%%%%%%%%%%%
v1 = st:0.1:en;  % plotting range from -5 to 5
[X,Y] = meshgrid(v1);  % get 2-D mesh for x and y

%Plot the objective function and its contour
subplot(1,2,1);
surf(X,Y,F(X,Y))
title('Objective function');
subplot(1,2,2);
contour(X,Y,F(X,Y),30);
title('Feasible set and the contour of objective function');
hold on

%Plot constraints
v2 = st:0.01:en;  
[X,Y] = meshgrid(v2);  
for i=1:size(cond,2)
condtem{i} = double(cond{i}(X,Y)<=0);  % convert to double for plotting
condtem{i}(condtem{i} == 0) = NaN;  % set the 0s to NaN so they are not plotted
end
contem=ones(size(cond{1}));
for i=1:size(cond,2)
contem=times(contem,condtem{i});
end
surf(X,Y,contem)
view(0,90)    

%% solve optimization problem using fmincon
fun=@(x) F(x(1),x(2));
A = [];
b = [];
Aeq = [];
beq = [];
lb=[];
ub=[];
x0 = [0,0];
c =@(x) cond{1}(x(1),x(2));
for i=2:size(cond,2)
    c=@(x)[c(x);cond{i}(x(1),x(2))];
end

ceq =@(x) [];
nonlinfcn = @(x)deal(c(x),ceq(x));
xsol=fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlinfcn);
fprintf('The optimal point is: [');
fprintf('%g ',xsol);
fprintf(']\n');

hold on
plot(xsol(1),xsol(2),'ko', 'MarkerFaceColor', 'r', ...
'MarkerSize', 7);
text(xsol(1),xsol(2),'  \leftarrow optimal point')

