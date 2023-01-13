//Spline cubique d'interpolation
//-------------------------------------------
// définition de la fonction à approcher
function y=f(x)
y=sin(x)**2
endfunction
//--------------------------------------------
// intervalle [a;b] et nombre n de subdivisions
utilisateur = x_mdialog('intervalle [a;b] et nombre n de subdivisions',...
['a';'b';'n'],['0';'6';'10']);
a=evstr(utilisateur(1));
b=evstr(utilisateur(2));
n=evstr(utilisateur(3));
h=(b-a)/n; // pas de la subdivision
//vecteur points d'interpolation yi=f(xi)
Y=[f(a:h:b)];
//construction de la matrice A
v=zeros(1,n-3);
A=toeplitz([4,1,v]);
//construction du second membre b
B=zeros(n-1,1);
for i=1:n-1
B(i,1)=Y(i)-2*Y(i+1)+Y(i+2);
end
B=(6/h^2).*B;
//résolution du système AX=B
X=A\B;// remarque : on n'utilise pas ici le fait que A est tridiagonale
// ----------------------------------------------------------------
Y_2=[0,X',0]; // dérivées secondes aux points xi
// détermination du polynôme d'interpolation nommé spline(x)
function y=spline(x)
// on détermine la subdivision contenant x
if (x==b) then
k=n-1;
else k=floor((x-a)/h);
end
xk=a+k*h; // x appartient à l'intervalle [x_k ; x_k+1]
// -------------------------------------------------------------
Y_1=zeros(1,n); // dérivées aux points xi
Y_3=zeros(1,n); // dérivées troisièmes aux points xi
for i=1:n
Y_1(i)=(Y(i+1)-Y(i))/h-(h/6)*(Y_2(i+1)+2*Y_2(i));
Y_3(i)=(Y_2(i+1)-Y_2(i))/h;
end
// construction du polynôme d'interpolation p(x)
s=poly(0,'s');
t=s-xk;
p=Y(k+1)+t*Y_1(k+1)+t^2*(Y_2(k+1)/2)+t^3*(Y_3(k+1)/6);
y=horner(p,[x]);
end
// -------------------------------
// graphique
// -------------------------------
x=[a:0.1:b];
P=[];
F=[];
for i=1:length(x)
P=[P,spline(x(i))];
F=[F,f(x(i))];
end
clf;
plot2d(x,F,1); // affiche la fonction f
plot2d(x,P,2); // affiche la spline cubique% Spline cubique d'interpolation
// -------------------------------------------
