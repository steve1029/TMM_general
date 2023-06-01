% FMM_single_block for off-diagonal anisotropic block
% Bidirectional characterization

function [Ta,Ra,Tb,Rb,CCa,CCb,pfEx,pfEy,pfEz,pfHx,pfHy,pfHz,pevalue,mfEx,mfEy,mfEz,mfHx,mfHy,mfHz,mevalue]=FMM_single_block_tensor(lay_thick,str_tensor,alpha_tm,beta_tm)

global c0; global w0;
global eps0; global mu0;

global nano; global micro; global lambda; 
global n0; global epr0; global mur0;
global eps0; global mu0;
global Tx; global Ty; global nx; global ny; 
global NBx; global NBy; global num_hx; global num_hy; global k0;
global kx_vc; global ky_vc; global kz_vc;




L=NBx*NBy; 

Teigvalue=zeros(1,2*L);

Iden=zeros(2*L,2*L);
for k=1:2*L
Iden(k,k)=1;   
end;

% region II
KII=zeros(2*L,2*L); % KII matrix
for k=1:NBx
   for l=1:NBy
od_ind1=(k-1)*NBy+l;      
K11(od_ind1,od_ind1)=(kx_vc(k)*ky_vc(l))/kz_vc(k,l);
K12(od_ind1,od_ind1)=(kz_vc(k,l)^2+kx_vc(k)^2)/kz_vc(k,l);
K21(od_ind1,od_ind1)=-(ky_vc(l)^2+kz_vc(k,l)^2)/kz_vc(k,l);
K22(od_ind1,od_ind1)=-( ky_vc(l)*kx_vc(k) )/kz_vc(k,l);

   end;
end;

KII(1:L, 1:L)=K11;
KII(1:L, L+1:2*L)=K12;
KII(L+1:2*L, 1:L)=K21;
KII(L+1:2*L,L+1:2*L )=K22;
clear K11;
clear K12;
clear K21;
clear K22;


Kx=zeros(L,L);
Ky=zeros(L,L);
for k=1:NBx 
   for l=1:NBy  
      od_ind=(k-1)*NBy+l;
      Kx(od_ind,od_ind)=kx_vc(k)/k0;
      Ky(od_ind,od_ind)=ky_vc(l)/k0;   
   end;
end;

% Toeplitz matrix
Exx=zeros(L,L);	 
Exy=zeros(L,L);
Exz=zeros(L,L);
Eyx=zeros(L,L);	 
Eyy=zeros(L,L);
Eyz=zeros(L,L);
Ezx=zeros(L,L);	 
Ezy=zeros(L,L);
Ezz=zeros(L,L);

Axx=zeros(L,L);   
Axy=zeros(L,L);
Axz=zeros(L,L);
Ayx=zeros(L,L);  
Ayy=zeros(L,L);
Ayz=zeros(L,L);
Azx=zeros(L,L);   
Azy=zeros(L,L);
Azz=zeros(L,L);

Gxx=zeros(L,L);
Gxy=zeros(L,L);
Gxz=zeros(L,L);
Gyx=zeros(L,L);
Gyy=zeros(L,L);
Gyz=zeros(L,L);
Gzx=zeros(L,L);
Gzy=zeros(L,L);
Gzz=zeros(L,L);

Bxx=zeros(L,L);
Bxy=zeros(L,L);
Bxz=zeros(L,L);
Byx=zeros(L,L);
Byy=zeros(L,L);
Byz=zeros(L,L);
Bzx=zeros(L,L);
Bzy=zeros(L,L);
Bzz=zeros(L,L);

eps_xx=str_tensor.eps_xx;
eps_xy=str_tensor.eps_xy;
eps_xz=str_tensor.eps_xz;
eps_yx=str_tensor.eps_yx;
eps_yy=str_tensor.eps_yy;
eps_yz=str_tensor.eps_yz;
eps_zx=str_tensor.eps_zx;
eps_zy=str_tensor.eps_zy;
eps_zz=str_tensor.eps_zz;

aps_xx=str_tensor.aps_xx;
aps_xy=str_tensor.aps_xy;
aps_xz=str_tensor.aps_xz;
aps_yx=str_tensor.aps_yx;
aps_yy=str_tensor.aps_yy;
aps_yz=str_tensor.aps_yz;
aps_zx=str_tensor.aps_zx;
aps_zy=str_tensor.aps_zy;
aps_zz=str_tensor.aps_zz;

mu_xx=str_tensor.mu_xx;
mu_xy=str_tensor.mu_xy;
mu_xz=str_tensor.mu_xz;
mu_yx=str_tensor.mu_yx;
mu_yy=str_tensor.mu_yy;
mu_yz=str_tensor.mu_yz;
mu_zx=str_tensor.mu_zx;
mu_zy=str_tensor.mu_zy;
mu_zz=str_tensor.mu_zz;

bu_xx=str_tensor.bu_xx;
bu_xy=str_tensor.bu_xy;
bu_xz=str_tensor.bu_xz;
bu_yx=str_tensor.bu_yx;
bu_yy=str_tensor.bu_yy;
bu_yz=str_tensor.bu_yz;
bu_zx=str_tensor.bu_zx;
bu_zy=str_tensor.bu_zy;
bu_zz=str_tensor.bu_zz;


for k=1:NBx
   for l=1:NBy
      od_ind1=(k-1)*NBy+l;
      for kk=1:NBx
      	for ll=1:NBy   
            od_ind2=(kk-1)*NBy+ll;		% od_ind2-od_ind1=
            
            % permittivity
            Exx(od_ind1,od_ind2)=eps_xx(k-kk+NBx,l-ll+NBy); 	
            Exy(od_ind1,od_ind2)=eps_xy(k-kk+NBx,l-ll+NBy); 
            Exz(od_ind1,od_ind2)=eps_xz(k-kk+NBx,l-ll+NBy); 
            Eyx(od_ind1,od_ind2)=eps_yx(k-kk+NBx,l-ll+NBy); 	
            Eyy(od_ind1,od_ind2)=eps_yy(k-kk+NBx,l-ll+NBy); 
            Eyz(od_ind1,od_ind2)=eps_yz(k-kk+NBx,l-ll+NBy);           
            Ezx(od_ind1,od_ind2)=eps_zx(k-kk+NBx,l-ll+NBy); 	
            Ezy(od_ind1,od_ind2)=eps_zy(k-kk+NBx,l-ll+NBy); 
            Ezz(od_ind1,od_ind2)=eps_zz(k-kk+NBx,l-ll+NBy); 
            
         
            Axx(od_ind1,od_ind2)=aps_xx(k-kk+NBx,l-ll+NBy); 	
            Axy(od_ind1,od_ind2)=aps_xy(k-kk+NBx,l-ll+NBy); 
            Axz(od_ind1,od_ind2)=aps_xz(k-kk+NBx,l-ll+NBy);    
            Ayx(od_ind1,od_ind2)=aps_yx(k-kk+NBx,l-ll+NBy); 	
            Ayy(od_ind1,od_ind2)=aps_yy(k-kk+NBx,l-ll+NBy); 
            Ayz(od_ind1,od_ind2)=aps_yz(k-kk+NBx,l-ll+NBy); 
            Azx(od_ind1,od_ind2)=aps_zx(k-kk+NBx,l-ll+NBy); 	
            Azy(od_ind1,od_ind2)=aps_zy(k-kk+NBx,l-ll+NBy); 
            Azz(od_ind1,od_ind2)=aps_zz(k-kk+NBx,l-ll+NBy); 

                       
            % permeability
			Gxx(od_ind1,od_ind2)=mu_xx(k-kk+NBx,l-ll+NBy); 
            Gxy(od_ind1,od_ind2)=mu_xy(k-kk+NBx,l-ll+NBy); 
			Gxz(od_ind1,od_ind2)=mu_xz(k-kk+NBx,l-ll+NBy);       
            Gyx(od_ind1,od_ind2)=mu_yx(k-kk+NBx,l-ll+NBy); 
            Gyy(od_ind1,od_ind2)=mu_yy(k-kk+NBx,l-ll+NBy); 
			Gyz(od_ind1,od_ind2)=mu_yz(k-kk+NBx,l-ll+NBy);     
            Gzx(od_ind1,od_ind2)=mu_zx(k-kk+NBx,l-ll+NBy); 
            Gzy(od_ind1,od_ind2)=mu_zy(k-kk+NBx,l-ll+NBy); 
			Gzz(od_ind1,od_ind2)=mu_zz(k-kk+NBx,l-ll+NBy);     
            
            
            Bxx(od_ind1,od_ind2)=bu_xx(k-kk+NBx,l-ll+NBy); 
            Bxy(od_ind1,od_ind2)=bu_xy(k-kk+NBx,l-ll+NBy); 
			Bxz(od_ind1,od_ind2)=bu_xz(k-kk+NBx,l-ll+NBy);       
            Byx(od_ind1,od_ind2)=bu_yx(k-kk+NBx,l-ll+NBy); 
            Byy(od_ind1,od_ind2)=bu_yy(k-kk+NBx,l-ll+NBy); 
			Byz(od_ind1,od_ind2)=bu_yz(k-kk+NBx,l-ll+NBy);     
            Bzx(od_ind1,od_ind2)=bu_zx(k-kk+NBx,l-ll+NBy); 
            Bzy(od_ind1,od_ind2)=bu_zy(k-kk+NBx,l-ll+NBy); 
			Bzz(od_ind1,od_ind2)=bu_zz(k-kk+NBx,l-ll+NBy);         

                      
      	end;
      end;
   end;
end;


alpha=alpha_tm; % convergence factor
beta=beta_tm;

AE_x=zeros(L,L);
EA_x=zeros(L,L);

AE_y=zeros(L,L);
EA_y=zeros(L,L);

AE_z=zeros(L,L);
EA_z=zeros(L,L);

AE_x=alpha*inv(Axx)+(1-alpha)*Exx;
EA_x=alpha*Exx+(1-alpha)*inv(Axx);

AE_y=alpha*inv(Ayy)+(1-alpha)*Eyy;
EA_y=alpha*Eyy+(1-alpha)*inv(Ayy);

AE_z=alpha*inv(Azz)+(1-alpha)*Ezz;
EA_z=alpha*Ezz+(1-alpha)*inv(Azz);

BG_x=zeros(L,L);
GB_x=zeros(L,L);

BG_y=zeros(L,L);
GB_y=zeros(L,L);

BG_z=zeros(L,L);
GB_z=zeros(L,L);


BG_x=beta*inv(Bxx)+(1-beta)*Gxx;
GB_x=beta*Gxx+(1-beta)*inv(Bxx);


BG_y=beta*inv(Byy)+(1-beta)*Gyy;
GB_y=beta*Gyy+(1-beta)*inv(Byy);


BG_z=beta*inv(Bzz)+(1-beta)*Gzz;
GB_z=beta*Gzz+(1-beta)*inv(Bzz);


% System Matrix

St11= -j*Gxz*inv(Gzz)*Kx - j*Ky*inv(Ezz)*Ezy;   
St12=  j*Gxz*inv(Gzz)*Ky - j*Ky*inv(Ezz)*Ezx;
St13= Gxy - Gxz*inv(Gzz)*Gzy + Ky*inv(Ezz)*Kx; 
St14= BG_x - Gxz*inv(Gzz)*Gzx - Ky*inv(Ezz)*Ky;


St21= j*Gyz*inv(Gzz)*Kx-j*Kx*inv(Ezz)*Ezy;
St22= -j*Gyz*inv(Gzz)*Ky-j*Kx*inv(Ezz)*Ezx;
St23= -GB_y+Gyz*inv(Gzz)*Gzy + Kx*inv(Ezz)*Kx;
St24= -Gyx+Gyz*inv(Gzz)*Gzx - Kx*inv(Ezz)*Ky;

St31= Exy - Exz*inv(Ezz)*Ezy+Ky*inv(Gzz)*Kx;
St32= AE_x - Exz*inv(Ezz)*Ezx-Ky*inv(Gzz)*Ky;
St33= -j*Exz*inv(Ezz)*Kx-j*Ky*inv(Gzz)*Gzy;
St34= j*Exz*inv(Ezz)*Ky-j*Ky*inv(Gzz)*Gzx;

St41= -EA_y+Eyz*inv(Ezz)*Ezy+Kx*inv(Gzz)*Kx;
St42= -Eyx+Eyz*inv(Ezz)*Ezx-Kx*inv(Gzz)*Ky;
St43= j*Eyz*inv(Ezz)*Kx-j*Kx*inv(Gzz)*Gzy;
St44= -j*Eyz*inv(Ezz)*Ky-j*Kx*inv(Gzz)*Gzx;


St=[ St11 St12 St13 St14
     St21 St22 St23 St24
     St31 St32 St33 St34
     St41 St42 St43 St44];

  
St=k0*St;

[W,Dt]=eig(St);  
clear St;


eig_value=zeros(1,4*L);
for k=1:4*L
eig_value(k)=Dt(k,k);   
end;

mcnt=0;
pcnt=0;

%------------------------------------------------------------------------
for k=1:4*L
    
   if real(eig_value(k)) > 0    % negative mode
   
       mcnt=mcnt+1;
       mevalue(mcnt)=eig_value(k);
       mW(:,mcnt)=W(:,k);
       
   else                        % positive mode
       
       pcnt=pcnt+1;
       pevalue(pcnt)=eig_value(k);
       pW(:,pcnt)=W(:,k);
   end;
    
end;

pQ=zeros(2*L);
mQ=zeros(2*L);
for k=1:2*L
    pQ(k,k)=pevalue(k);
    mQ(k,k)=mevalue(k);
end;



% Fourier coefficients (pfEx,pfEy,pfEz,pfHx,pfHy,pfHz) , (mfEx,mfEy,mfEz,mfHx,mfHy,mfHz) 
 
    pfEy=pW(1:L,:);                                               %     pfEy
    pfEx=pW(L+1:2*L,:);                                           %     pfEx
    pfHy=pW(2*L+1:3*L,:);                                         %     pfHy
    pfHx=pW(3*L+1:4*L,:);                                         %     pfHx
    pfEz=inv(Ezz)*(j*Ky*pfHx-j*Kx*pfHy-Ezx*pfEx-Ezy*pfEy);        %     pfEz
    pfHz=inv(Gzz)*(j*Ky*pfEx-j*Kx*pfEy-Gzx*pfHx-Gzy*pfHy);        %     pfHz
    
    pfHy=j*(eps0/mu0)^0.5*pfHy;
    pfHx=j*(eps0/mu0)^0.5*pfHx;
    pfHz=j*(eps0/mu0)^0.5*pfHz;

    mfEy=mW(1:L,:);                                             %     mfEy
    mfEx=mW(L+1:2*L,:);                                           %     mfEx
    mfHy=mW(2*L+1:3*L,:);                        %     mfHy
    mfHx=mW(3*L+1:4*L,:);                        %     mfHx
    mfEz=inv(Ezz)*(j*Ky*mfHx-j*Kx*mfHy-Ezx*mfEx-Ezy*mfEy);      %     mfEz
    mfHz=inv(Gzz)*(j*Ky*mfEx-j*Kx*mfEy-Gzx*mfHx-Gzy*mfHy);      %     mfHz
    
    mfHy=j*(eps0/mu0)^0.5*mfHy;
    mfHx=j*(eps0/mu0)^0.5*mfHx;
    mfHz=j*(eps0/mu0)^0.5*mfHz;
      
%% single layer S-matrix
zm=0;
zp=lay_thick;

Wp_zp=zeros(2*L,pcnt); 
Wm_zp=zeros(2*L,mcnt);
Vp_zp=zeros(2*L,pcnt);
Vm_zp=zeros(2*L,mcnt);

Wp_zm=zeros(2*L,pcnt); 
Wm_zm=zeros(2*L,mcnt);
Vp_zm=zeros(2*L,pcnt);
Vm_zm=zeros(2*L,mcnt);

Wp_zm=Wp_gen(pW,pevalue,pcnt,L,zm-zm); Wm_zm=Wm_gen(mW,mevalue,mcnt,L,zm-zp);
Vp_zm=Vp_gen(pW,pevalue,pcnt,L,zm-zm); Vm_zm=Vm_gen(mW,mevalue,mcnt,L,zm-zp);

Wp_zp=Wp_gen(pW,pevalue,pcnt,L,zp-zm); Wm_zp=Wm_gen(mW,mevalue,mcnt,L,zp-zp);
Vp_zp=Vp_gen(pW,pevalue,pcnt,L,zp-zm); Vm_zp=Vm_gen(mW,mevalue,mcnt,L,zp-zp);

Wh=Iden;
Vh=KII/(w0*mu0);



 % left-to-right
U=eye(2*L,2*L);

S11=inv(Wh)*Wp_zm+inv(Vh)*Vp_zm;
S12=inv(Wh)*Wm_zm+inv(Vh)*Vm_zm;
S21=inv(Wh)*Wp_zp-inv(Vh)*Vp_zp;
S22=inv(Wh)*Wm_zp-inv(Vh)*Vm_zp;

S=[S11 S12; S21 S22];


clear S11;
clear S12;
clear S21;
clear S22;
D=[2*U;zeros(2*L,2*L)];

CCa=inv(S)*D;
Cap=CCa(1:2*L,:);
Cam=CCa(2*L+1:4*L,:);
Ra=inv(Wh)*(Wp_zm*Cap+Wm_zm*Cam-Wh*U);
Ta=inv(Wh)*(Wp_zp*Cap+Wm_zp*Cam);

 % right-to-left

 S11=inv(Wh)*Wp_zm+inv(Vh)*Vp_zm;
 S12=inv(Wh)*Wm_zm+inv(Vh)*Vm_zm;
 S21=inv(Wh)*Wp_zp-inv(Vh)*Vp_zp;
 S22=inv(Wh)*Wm_zp-inv(Vh)*Vm_zp;

S=[S11 S12 ; S21 S22];
clear S11;
clear S12;
clear S21;
clear S22;

D=[zeros(2*L,2*L);2*U];
CCb=inv(S)*D;
Cbp=CCb(1:2*L,:);
Cbm=CCb(2*L+1:4*L,:);

Rb=inv(Wh)*(Wp_zp*Cbp+Wm_zp*Cbm-Wh*U);
Tb=inv(Wh)*(Wp_zm*Cbp+Wm_zm*Cbm);


% 
% 
% 
% 
% 
% 
% 
% % permittivity && permeability
% SA=zeros(2*L, 2*L);
% SB=zeros(2*L,2*L);         
% 
% 
% SA=[ (Ky)*inv(Ez)*(Kx) 		 BG_x-(Ky)*inv(Ez)*(Ky)
%      (Kx)*inv(Ez)*(Kx)-GB_y   -(Kx)*inv(Ez)*(Ky)];
% 
% SB=[ (Ky)*inv(Gz)*(Kx)  		 AE_x-(Ky)*inv(Gz)*(Ky)
%      (Kx)*inv(Gz)*(Kx)-EA_x   -(Kx)*inv(Gz)*(Ky)];
% 
%  St=k0^2*SA*SB;
% clear SB;
% 
% 
% [W,Dt]=eig(St);  % main 8?????? ????????.
% clear St;
% 
% eig_value=zeros(1,2*L);
% for k=1:2*L
% eig_value(k)=Dt(k,k);   
% end;
% 
% c_eig=eig_value;
% for k=1:2*L
%    eig_value(k)=c_eig(k)^0.5;  
%    if real(eig_value(k))>0
%        eig_value(k)=-eig_value(k);
%    end
% end;
% 
% 
% 
% Q=zeros(2*L,2*L);
% for k=1:2*L
%   Q(k,k)=eig_value(k);
% end;
% 
% 
% % X
% X=zeros(2*L,2*L);
% for k=1:2*L
%    X(k,k)=exp(eig_value(k)*lay_thick);
% end;
% 
% Z=inv(k0*SA);
% V=Z*W*Q;
% clear Z;
% clear SA;
% 
% Teigvalue=eig_value;
% 
% 
% Wh=Iden;
% Vh=KII/k0;
% % 
% % Wp=zeros(2*L,2*L);
% % Vp=zeros(2*L,2*L);
% % WpXp=zeros(2*L,2*L);
% % VpXp=zeros(2*L,2*L);
% % 
% % Wm=zeros(2*L,2*L);
% % Vm=zeros(2*L,2*L);
% % WmXm=zeros(2*L,2*L);
% % VmXm=zeros(2*L,2*L);
% % 
% % Wp=W;
% % Vp=j*V;
% % WmXm=W*X;
% % VmXm=-j*V*X;
% % 
% % Wm=W;
% % Vm=-j*V;
% % WpXp=W*X;
% % VpXp=j*V*X;
% 
% %% left-to-right
% U=eye(2*L,2*L);
% %S11=inv(Wh)*Wp+inv(Vh)*Vp;
% %S12=inv(Wh)*WmXm+inv(Vh)*VmXm;
% %S21=inv(Wh)*WpXp-inv(Vh)*VpXp;
% %S22=inv(Wh)*Wm-inv(Vh)*Vm;
% S11=inv(Wh)*W+inv(Vh)*(j*V);
% S12=inv(Wh)*(W*X)+inv(Vh)*(-j*V*X);
% S21=inv(Wh)*(W*X)-inv(Vh)*(j*V*X);
% S22=inv(Wh)*W-inv(Vh)*(-j*V);
% 
% S=[S11 S12; S21 S22];
% clear S11;
% clear S12;
% clear S21;
% clear S22;
% D=[2*U;zeros(2*L,2*L)];
% CCa=inv(S)*D;
% Cap=CCa(1:2*L,:);
% Cam=CCa(2*L+1:4*L,:);
% % Ra=inv(Wh)*(Wp*Cap+WmXm*Cam-Wh*U);
% % Ta=inv(Wh)*(WpXp*Cap+Wm*Cam);
%  Ra=inv(Wh)*(W*Cap+(W*X)*Cam-Wh*U);
%  Ta=inv(Wh)*((W*X)*Cap+W*Cam);
% 
% 
% % right-to-left
% % S11=inv(Wh)*WpXp-inv(Vh)*VpXp;
% % S12=inv(Wh)*Wm-inv(Vh)*Vm;
% % S21=inv(Wh)*Wp+inv(Vh)*Vp;
% % S22=inv(Wh)*WmXm+inv(Vh)*VmXm;
% 
%  S11=inv(Wh)*(W*X)-inv(Vh)*(j*V*X);
%  S12=inv(Wh)*W-inv(Vh)*(-j*V);
%  S21=inv(Wh)*W+inv(Vh)*(j*V);
%  S22=inv(Wh)*(W*X)+inv(Vh)*(-j*V*X);
% 
% S=[S11 S12 ; S21 S22];
% clear S11;
% clear S12;
% clear S21;
% clear S22;
% CCb=inv(S)*D;
% Cbp=CCb(1:2*L,:);
% Cbm=CCb(2*L+1:4*L,:);
% % Tb=inv(Wh)*(Wp*Cbp+WmXm*Cbm);
% % Rb=inv(Wh)*(WpXp*Cbp+Wm*Cbm-Wh*U);
% Tb=inv(Wh)*(W*Cbp+W*X*Cbm);
% Rb=inv(Wh)*(W*X*Cbp+W*Cbm-Wh*U);

