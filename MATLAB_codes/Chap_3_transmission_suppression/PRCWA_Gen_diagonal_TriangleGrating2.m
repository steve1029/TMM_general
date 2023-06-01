% PRCWA_Gen_BMD.m
% BMD electrode & grating structure analysis

% Layer structure
Nlay=1;    %  number of layers

% material permittivity
epra=ni^2;
eprb=epra;
eprm=-9.3+0.18*i;

Grating_gen_TriangleGrating2;             % Fourier series of grating structure

grating_thick=Height/Nlay;               % grating thickness

lay_thick=zeros(Nlay,1); %  layer
for lnt=1:Nlay
lay_thick(lnt)=grating_thick; 
end;

ac_thick=zeros(1,Nlay); 
for cnt1=1:Nlay
	 cnt2=1;
    while cnt2 <= cnt1
       ac_thick(cnt1)=ac_thick(cnt1)+lay_thick(cnt2);
       cnt2=cnt2+1;
    end;
end; % for cnt1

%---------------------- permittivity & permeability -----------------------
eps_xx=zeros(num_hx,num_hy,Nlay); 
eps_yy=zeros(num_hx,num_hy,Nlay); 
eps_zz=zeros(num_hx,num_hy,Nlay); 

aps_xx=zeros(num_hx,num_hy,Nlay);   % reciprocal permittivity 
aps_yy=zeros(num_hx,num_hy,Nlay); 
aps_zz=zeros(num_hx,num_hy,Nlay); 

mu_xx=zeros(num_hx,num_hy,Nlay);    % permeability
mu_yy=zeros(num_hx,num_hy,Nlay);  
mu_zz=zeros(num_hx,num_hy,Nlay); 

bu_xx=zeros(num_hx,num_hy,Nlay);     % reciprocal permeability
bu_yy=zeros(num_hx,num_hy,Nlay); 
bu_zz=zeros(num_hx,num_hy,Nlay); 


for lnt=1:Nlay
    
       eps_xx(:,:,lnt)=eps_L(:,:,lnt);
       eps_yy(:,:,lnt)=eps_L(:,:,lnt);
       eps_zz(:,:,lnt)=eps_L(:,:,lnt);
       aps_xx(:,:,lnt)=aps_L(:,:,lnt);
       aps_yy(:,:,lnt)=aps_L(:,:,lnt);
       aps_zz(:,:,lnt)=aps_L(:,:,lnt);
       mu_xx(:,:,lnt)=  mu_L(:,:,lnt);
       mu_yy(:,:,lnt)=  mu_L(:,:,lnt);
       mu_zz(:,:,lnt)=  mu_L(:,:,lnt);
       bu_xx(:,:,lnt)=  bu_L(:,:,lnt);
       bu_yy(:,:,lnt)=  bu_L(:,:,lnt);
       bu_zz(:,:,lnt)=  bu_L(:,:,lnt);
               
end; % for lnt
       
%% permittivity profile testing        
xx=5*[-Tx/2:Tx*0.01:Tx/2];
%yy=5*[-Ty/2:Ty*0.01:Ty/2];
yy=0;

Gr_str_bg=real(ni)*ones(length(xx),length(yy));
Gr_str_gr=zeros(length(xx),length(yy));
[ya xa]=meshgrid(yy,xx);

for k=-2*nx:2*nx
    for l=-2*ny:2*ny

        Gr_str_gr=Gr_str_gr+eps_xx(k+NBx,l+NBy,1)*exp(j*(k*xa*2*pi/Tx+l*ya*2*pi/Ty));

    end;
end;

figure(5);set(gca,'fontsize',16);set(gca,'fontname','times new roman');
imagesc((0:1399),xx/nm,[repmat(Gr_str_bg,1,600) repmat(real(Gr_str_gr),1,200) repmat(Gr_str_bg,1,600)]);set(gca,'ydir','normal');
set(gca,'fontname','times new roman');
axis equal;axis([0 1400 xx(1)/nm xx(end)/nm]);xlabel('z (nm)');ylabel('x (nm)');set(gca,'fontname','times new roman');
caxis([-10 5]);colorbar;set(gca,'fontsize',16);set(gca,'fontname','times new roman');
%%
     
% for visualization of Ez & Hz
L=NBx*NBy;
Ezz=zeros(L,L,Nlay);  %% permittivity
Azz=zeros(L,L,Nlay);   
Gzz=zeros(L,L,Nlay);
Bzz=zeros(L,L,Nlay);

teps_zz=zeros(num_hx,num_hy);
taps_zz=zeros(num_hx,num_hy);
tmu_zz=zeros(num_hx,num_hy);
tbu_zz=zeros(num_hx,num_hy);

tEzz=zeros(L,L);
tAzz=zeros(L,L);
tGzz=zeros(L,L);
tBzz=zeros(L,L);

for laynt=1:Nlay

  teps_zz=eps_zz(:,:,laynt);
  taps_zz=aps_zz(:,:,laynt);
  tmu_zz =mu_zz(:,:,laynt);
  tbu_zz =bu_zz(:,:,laynt);
   
  for k=1:NBx
   for l=1:NBy
      od_ind1=(k-1)*NBy+l;
      for kk=1:NBx
      	for ll=1:NBy   
            od_ind2=(kk-1)*NBy+ll;		

            % permittivity
            tEzz(od_ind1,od_ind2)=teps_zz(k-kk+NBx,l-ll+NBy);
            tAzz(od_ind1,od_ind2)=taps_zz(k-kk+NBx,l-ll+NBy);
            tGzz(od_ind1,od_ind2)=tmu_zz(k-kk+NBx,l-ll+NBy);  
            tBzz(od_ind1,od_ind2)=tbu_zz(k-kk+NBx,l-ll+NBy); 
      	end;
      end;
   end;
end;

Ezz(:,:,laynt)=tEzz;
Azz(:,:,laynt)=tAzz;
Gzz(:,:,laynt)=tGzz;
Bzz(:,:,laynt)=tBzz;

end; % for laynt


Kx=zeros(L,L);
Ky=zeros(L,L);
for k=1:NBx
   for l=1:NBy  
      od_ind=(k-1)*NBy+l;
      Kx(od_ind,od_ind)=kx_vc(k)/k0;
      Ky(od_ind,od_ind)=ky_vc(l)/k0;   
   end;
end;


