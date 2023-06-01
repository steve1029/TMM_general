
% FMM standard code written by H. Kim
% semi-infinite homogeneous space I - multilayer -  semi-infinite homogeneous space II       

clear all;
close all;
clc;

addpath([pwd '\PRCWA_COM']);
addpath([pwd '\FIELD_VISUAL']);
addpath([pwd '\STRUCTURE']);

%% STEP 1 : wavevector setting and structure modeling

% length unit
global nm;  % nano
global um;  % micro
global mm;  % mili

% basic parameters
global k0;               % wavenumber
global c0; global w0;    % speed of light, angular frequency
global eps0; global mu0; % vaccum permittivity & permeability

% refractive index, permittivity, permeability in zero-thickness buffer layer 
global n0; global epr0; global mur0;
% refractive index, permittivity, permeability in homogeneous space I
global ni; global epri; global muri;
% refractive index, permittivity, permeability in homogeneous space II
global nf; global eprf; global murf;        

% x-directional supercell period, y-directional supercell period
global Tx; global Ty;                       
global nx; global ny;                       
% # of x-direction Fourier harmonics, # of y-directional Fourier harmonics
global NBx; global NBy;                     
global num_hx; global num_hy;               
global kx_vc; global ky_vc; global kz_vc;

% input output free space
global kix; global kiy; global kiz; 
global kfz;
global kx_ref; global ky_ref; global kz_ref;
global kx_tra; global ky_tra; global kz_tra;

nm=1e-9;
lambda=532*nm;

 % direct_=1 left-to-right characterization, 
 % direct_=2 right-to-left characterization
 direct_ =1; % 1 = left-to-right , 2 = right-to-left

PRCWA_basic;                                %   3D structure
PRCWA_Gen_K;                                %   zero-thickness buffer

% The example structure is a multi-layer structure with randomly generated
% refractive indices

PRCWA_Gen_Random_Multilayer;                         %   SPP Y branch

%% STEP 2 Block S-matrix computation of single block structures

L=1;

Ta=zeros(2*L,2*L,Nlay); % left to rignt
Ra=zeros(2*L,2*L,Nlay); % left to right
Tb=zeros(2*L,2*L,Nlay); % right to left
Rb=zeros(2*L,2*L,Nlay); % right to left
Ca=zeros(4*L,2*L,Nlay); % left to right
Cb=zeros(4*L,2*L,Nlay); % right to left
tCa=zeros(4*L,2*L,Nlay); % left to right
tCb=zeros(4*L,2*L,Nlay); % right to left

%Diagonal_SMM;               % diagonal anisotropy
Off_diagonal_tensor_SMM;   % off-diagonal anisotropy  


%%  STEP3 S-matrix method 
% The obtained S-matrix and coupling coefficient matrix operator of single
% blocks are combined to generate the S-matrix and coupling coefficient
% operator of interconnected multi-block structures by the Redheffer star
% product...
     
I=eye(2*L,2*L);
T_temp1a=Ta(:,:,1);
R_temp1a=Ra(:,:,1);
T_temp1b=Tb(:,:,1);
R_temp1b=Rb(:,:,1);
    
 %% Important
   tCa=Ca;
   tCb=Cb;
   %%
   
   
for laynt=2:Nlay
   
   %laynt
   
   T_temp2a=Ta(:,:,laynt);
   R_temp2a=Ra(:,:,laynt);
   T_temp2b=Tb(:,:,laynt);
   R_temp2b=Rb(:,:,laynt);

	RRa=(R_temp1a+T_temp1b*inv(I-R_temp2a*R_temp1b)*R_temp2a*T_temp1a);
	TTa=T_temp2a*inv(I-R_temp1b*R_temp2a)*T_temp1a;

	RRb=(R_temp2b+T_temp2a*inv(I-R_temp1b*R_temp2a)*R_temp1b*T_temp2b);
    TTb=T_temp1b*inv(I-R_temp2a*R_temp1b)*T_temp2b;
   
   
   for k=1:laynt-1
   	
   tCa(:,:,k)=Ca(:,:,k)+Cb(:,:,k)*inv(I-R_temp2a*R_temp1b)*R_temp2a*T_temp1a;
   tCb(:,:,k)=Cb(:,:,k)*inv(I-R_temp2a*R_temp1b)*T_temp2b;

   end; % for k
   
   tCa(:,:,laynt)=Ca(:,:,laynt)*inv(I-R_temp1b*R_temp2a)*T_temp1a;
   tCb(:,:,laynt)=Cb(:,:,laynt)+Ca(:,:,laynt)*inv(I-R_temp1b*R_temp2a)*R_temp1b*T_temp2b;
   

   T_temp1a=TTa;
   R_temp1a=RRa;
   T_temp1b=TTb;
   R_temp1b=RRb;
   
   Ca=tCa;
   Cb=tCb; 
end; % laynt
     
 TTa=T_temp1a;  % left-to-right transmission operator
 RRa=R_temp1a;  % left-to-right reflection operator
 TTb=T_temp1b;  % right-to-left transmission operator
 RRb=R_temp1b;  % right-to-left reflection operator
 
%% STEP4 Half-infinite block interconnection & Field visualization
 
 switch direct_
    
    case 1      % left-to-right
            % polarizatoin angle : TM=0, TE=pi/2
            psi=0;      			
            tm_Ux=cos(psi)*cos(theta)*cos(phi)-sin(psi)*sin(phi);  % incident wave�� Ex
            tm_Uy=cos(psi)*cos(theta)*sin(phi)+sin(psi)*cos(phi);  % incident wave�� Ey
            tm_Uz=-cos(psi)*sin(theta);  

            psi=pi/2;
            te_Ux=cos(psi)*cos(theta)*cos(phi)-sin(psi)*sin(phi);  % incident wave�� Ex
            te_Uy=cos(psi)*cos(theta)*sin(phi)+sin(psi)*cos(phi);  % incident wave�� Ey
            te_Uz=-cos(psi)*sin(theta); 

            % Ux=cos(psi)*cos(theta)*cos(phi)-sin(psi)*sin(phi);  % incident wave�� Ex
            % Uy=cos(psi)*cos(theta)*sin(phi)+sin(psi)*cos(phi);  % incident wave�� Ey
            % Uz=-cos(psi)*sin(theta); 

    case 2      % right-to-left
                    % polarizatoin angle : TM=0, TE=pi/2
            psi=0;      			
            tm_Ux=cos(psi)*cos(theta)*cos(phi)-sin(psi)*sin(phi);  % incident wave�� Ex
            tm_Uy=cos(psi)*cos(theta)*sin(phi)+sin(psi)*cos(phi);  % incident wave�� Ey
            tm_Uz=cos(psi)*sin(theta);  

            psi=pi/2;
            te_Ux=cos(psi)*cos(theta)*cos(phi)-sin(psi)*sin(phi);  % incident wave�� Ex
            te_Uy=cos(psi)*cos(theta)*sin(phi)+sin(psi)*cos(phi);  % incident wave�� Ey
            te_Uz=cos(psi)*sin(theta); 

            % Ux=cos(psi)*cos(theta)*cos(phi)-sin(psi)*sin(phi);  % incident wave�� Ex
            % Uy=cos(psi)*cos(theta)*sin(phi)+sin(psi)*cos(phi);  % incident wave�� Ey
            % Uz=cos(psi)*sin(theta); 

end;

Bdr_Smat_case1;   % 1. homogeneous space          - grating - homogeneous space    


 

