% Bdr_SMat_inwg_outwg
function [Lwg_Tf,Lwg_Rb,Lwg_Tb,Lwg_Rf,Rwg_Tf,Rwg_Rb,Rwg_Tb,Rwg_Rf]=Bdr_SMat_wg_tensor(str_tensor,alpha_tm,beta_tm)

global c0; global w0;
global eps0; global mu0;

global nano; global micro; global lambda; 
global n0; global epr0; global mur0;
global eps0; global mu0;
global Tx; global Ty; global nx; global ny; 
global NBx; global NBy; global num_hx; global num_hy; global k0;
global kx_vc; global ky_vc; global kz_vc;


L=1;

Iden=zeros(2*L,2*L);
for k=1:2*L
Iden(k,k)=1;   
end;

% region II
KII=zeros(2*L,2*L); % KII matrix   
K11= (kx_vc*ky_vc)/kz_vc;
K12= (kz_vc^2+kx_vc^2)/kz_vc;
K21=-(ky_vc^2+kz_vc^2)/kz_vc;
K22=-(ky_vc*kx_vc)/kz_vc;

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
  
Kx=kx_vc/k0;
Ky=ky_vc/k0;

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

  % permittivity
            Exx=eps_xx; 	
            Exy=eps_xy; 
            Exz=eps_xz; 
            Eyx=eps_yx; 	
            Eyy=eps_yy; 
            Eyz=eps_yz;           
            Ezx=eps_zx; 	
            Ezy=eps_zy; 
            Ezz=eps_zz; 
                     
            Axx=aps_xx; 	
            Axy=aps_xy; 
            Axz=aps_xz;    
            Ayx=aps_yx; 	
            Ayy=aps_yy; 
            Ayz=aps_yz; 
            Azx=aps_zx; 	
            Azy=aps_zy; 
            Azz=aps_zz; 
                       
   % permeability
			Gxx=mu_xx; 
            Gxy=mu_xy; 
			Gxz=mu_xz;       
            Gyx=mu_yx; 
            Gyy=mu_yy; 
			Gyz=mu_yz;     
            Gzx=mu_zx; 
            Gzy=mu_zy; 
			Gzz=mu_zz;     
                        
            Bxx=bu_xx; 
            Bxy=bu_xy; 
			Bxz=bu_xz;       
            Byx=bu_yx; 
            Byy=bu_yy; 
			Byz=bu_yz;     
            Bzx=bu_zx; 
            Bzy=bu_zy; 
			Bzz=bu_zz;         

                      
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
      
%% Boundary S-matrix

Wp=zeros(2*L,pcnt); 
Wm=zeros(2*L,mcnt);
Vp=zeros(2*L,pcnt);
Vm=zeros(2*L,mcnt);

Wp=Wp_gen(pW,pevalue,pcnt,L,0); 
Wm=Wm_gen(mW,mevalue,mcnt,L,0);
Vp=Vp_gen(pW,pevalue,pcnt,L,0); 
Vm=Vm_gen(mW,mevalue,mcnt,L,0);

Wh=Iden;
Vh=KII/(w0*mu0);

% left-wg right-free
% (Lwg_Tf,Lwg_Rb,Lwg_Tb,Lwg_Rf)

Lwg_Tf= inv(inv(Wm)*Wh-inv(Vm)*Vh)*(inv(Wm)*Wp-inv(Vm)*Vp);
Lwg_Rb=-inv(inv(Wh)*Wm-inv(Vh)*Vm)*(inv(Wh)*Wp-inv(Vh)*Vp);
Lwg_Tb=2*inv(inv(Wh)*Wm-inv(Vh)*Vm);
Lwg_Rf=-inv(inv(Wm)*Wh-inv(Vm)*Vh)*(inv(Wm)*Wh+inv(Vm)*Vh);

% left-free right-wg
% (Rwg_Tf,Rwg_Rb,Rwg_Tb,Rwg_Rf)

Rwg_Tf= 2*inv(inv(Wh)*Wp+inv(Vh)*Vp);
Rwg_Rb=-inv(inv(Wp)*Wh+inv(Vp)*Vh )*(inv(Wp)*Wh-inv(Vp)*Vh);
Rwg_Tb= inv(inv(Wp)*Wh+inv(Vp)*Vh )*(inv(Wp)*Wm-inv(Vp)*Vm);
Rwg_Rf=-inv(inv(Wh)*Wp+inv(Vh)*Vp )*(inv(Wh)*Wm+inv(Vh)*Vm);





