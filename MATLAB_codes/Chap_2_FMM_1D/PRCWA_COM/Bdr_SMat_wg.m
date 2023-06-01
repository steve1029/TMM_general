% Bdr_SMat_inwg_outwg
function [Lwg_Tf,Lwg_Rb,Lwg_Tb,Lwg_Rf,Rwg_Tf,Rwg_Rb,Rwg_Tb,Rwg_Rf]=Bdr_SMat_wg(str_tensor,alpha_tm,beta_tm)

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

K11=(kx_vc*ky_vc)/kz_vc;
K12=(kz_vc^2+kx_vc^2)/kz_vc;
K21=-(ky_vc^2+kz_vc^2)/kz_vc;
K22=-( ky_vc*kx_vc )/kz_vc;


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

eps_xx=str_tensor.eps_xx;
eps_yy=str_tensor.eps_yy;
eps_zz=str_tensor.eps_zz;

aps_xx=str_tensor.aps_xx;
aps_yy=str_tensor.aps_yy;
aps_zz=str_tensor.aps_zz;

mu_xx=str_tensor.mu_xx;
mu_yy=str_tensor.mu_yy;
mu_zz=str_tensor.mu_zz;

bu_xx=str_tensor.bu_xx;
bu_yy=str_tensor.bu_yy;
bu_zz=str_tensor.bu_zz;

            
            % permittivity
            Exx=eps_xx; 	
            Eyy=eps_yy; 
            Ezz=eps_zz; 
            
         
            Axx=aps_xx; 	
            Ayy=aps_yy; 
            Azz=aps_zz; 

                       
            % permeability
			Gxx=mu_xx; 
            Gyy=mu_yy; 
		    Gzz=mu_zz;     
            
            
            Bxx=bu_xx; 
            Byy=bu_yy; 
	    	Bzz=bu_zz;         

      

alpha=alpha_tm; % convergence factor
beta=beta_tm;

inv_Axx=inv(Axx);
inv_Ayy=inv(Ayy);
inv_Azz=inv(Azz);


AE_x=alpha*inv_Axx+(1-alpha)*Exx;
EA_x=alpha*Exx+(1-alpha)*inv_Axx;

AE_y=alpha*inv_Ayy+(1-alpha)*Eyy;
EA_y=alpha*Eyy+(1-alpha)*inv_Ayy;

AE_z=alpha*inv_Azz+(1-alpha)*Ezz;
EA_z=alpha*Ezz+(1-alpha)*inv_Azz;

inv_Bxx=inv(Bxx);
inv_Byy=inv(Byy);
inv_Bzz=inv(Bzz);

BG_x=beta*inv_Bxx+(1-beta)*Gxx;
GB_x=beta*Gxx+(1-beta)*inv_Bxx;

BG_y=beta*inv_Byy+(1-beta)*Gyy;
GB_y=beta*Gyy+(1-beta)*inv_Byy;

BG_z=beta*inv_Bzz+(1-beta)*Gzz;
GB_z=beta*Gzz+(1-beta)*inv_Bzz;


% System Matrix

SA=zeros(2*L, 2*L);
SB=zeros(2*L,2*L);         


SA=[ (Ky)*inv(Ezz)*(Kx) 		 BG_x-(Ky)*inv(Ezz)*(Ky)
     (Kx)*inv(Ezz)*(Kx)-GB_y   -(Kx)*inv(Ezz)*(Ky)];

SB=[ (Ky)*inv(Gzz)*(Kx)  		 AE_x-(Ky)*inv(Gzz)*(Ky)
     (Kx)*inv(Gzz)*(Kx)-EA_x   -(Kx)*inv(Gzz)*(Ky)];

St=k0^2*SA*SB;
clear SB;

[W,Dt]=eig(St);  
clear St;


eig_value=zeros(1,2*L);
for k=1:2*L
eig_value(k)=Dt(k,k);   
end;

c_eig=eig_value;
for k=1:2*L
   eig_value(k)=c_eig(k)^0.5;  
   if real(eig_value(k))>0
       eig_value(k)=-eig_value(k);
   end
end;

mcnt=0;
pcnt=0;

%------------------------------------------------------------------------
for k=1:2*L
     
  % positive mode
       
       pcnt=pcnt+1;
       pevalue(pcnt)=eig_value(k);
       pW(:,pcnt)=W(:,k);
  % negative mode
   
       mcnt=mcnt+1;
       mevalue(mcnt)=-eig_value(k);
       mW(:,mcnt)=W(:,k);

end;

pQ=zeros(2*L,2*L);
mQ=zeros(2*L,2*L);

for k=1:2*L
  pQ(k,k)=pevalue(k);
  mQ(k,k)=mevalue(k);
end;


Z=inv(k0*SA);
pV=Z*pW*pQ;
mV=Z*mW*mQ;
clear Z;
clear SA;



% Fourier coefficients (pfEx,pfEy,pfEz,pfHx,pfHy,pfHz) , (mfEx,mfEy,mfEz,mfHx,mfHy,mfHz) 
 
    pfEy=pW(1:L,:);                                            %     pfEy
    pfEx=pW(L+1:2*L,:);                                        %     pfEx
    pfHy=pV(1:L,:);                                            %     pfHy
    pfHx=pV(L+1:2*L,:);                                        %     pfHx  
    pfEz=inv(Ezz)*(j*Ky*pfHx-j*Kx*pfHy);                       %     pfEz
    pfHz=inv(Gzz)*(j*Ky*pfEx-j*Kx*pfEy);                       %     pfHz

    pfHy=j*(eps0/mu0)^0.5*pfHy;                                %     pfHy
    pfHx=j*(eps0/mu0)^0.5*pfHx;                                %     pfHx
    pfHz=j*(eps0/mu0)^0.5*pfHz;                                %     pfHz
    

    mfEy=mW(1:L,:);                                            %     mfEy
    mfEx=mW(L+1:2*L,:);                                        %     mfEx
    mfHy=mV(1:L,:);                                            %     mfHy
    mfHx=mV(L+1:2*L,:);                                        %     mfHx
    mfEz=inv(Ezz)*(j*Ky*mfHx-j*Kx*mfHy);                       %     mfEz
    mfHz=inv(Gzz)*(j*Ky*mfEx-j*Kx*mfEy);                       %     mfHz
    
    mfHy=j*(eps0/mu0)^0.5*mfHy;                                %     mfHy
    mfHx=j*(eps0/mu0)^0.5*mfHx;                                %     mfHx
    mfHz=j*(eps0/mu0)^0.5*mfHz;    

      
%% Boundary S-matrix

Wp=zeros(2*L,pcnt); 
Wm=zeros(2*L,mcnt);
Vp=zeros(2*L,pcnt);
Vm=zeros(2*L,mcnt);

Wp=sWp_gen(pW,pevalue,pcnt,L,0); 
Wm=sWm_gen(mW,mevalue,mcnt,L,0);
Vp=sVp_gen(pV,pevalue,pcnt,L,0); 
Vm=sVm_gen(mV,mevalue,mcnt,L,0);

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








