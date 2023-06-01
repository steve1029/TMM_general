% FMM standard written by H. Kim

% 0. free space                             - grating -  free space       
% 1. semi-infinite homogeneous space        - grating -  semi-infinite homogeneous space       
% 2. semi-infinite homogeneous space        - grating -  semi-infinite inhomogeneous waveguide
% 3. semi-infinite inhomogeneous waveguide  - grating -  semi-infinite homogeneous space
% 4. semi-infinite inhomogeneous waveguide  - grating -  semi-infinite inhomogeneous waveguide

%% STEP 1 : wavevector setting and structure modeling
clear all;
close all;
clc;

addpath([pwd '\PRCWA_COM']);
addpath([pwd '\FIELD_VISUAL']);
addpath([pwd '\STRUCTURE']);

% length unit

global nm;  % nano
global um;  % micro
global mm;  % mili

global k0;                                  % wavenumber
global c0; global w0;
global eps0; global mu0;


% zero-thickness buffer refractive index, permittivity, permeability 
global n0; global epr0; global mur0;
% refractive index, permittivity, permeability in free space I
global ni; global epri; global muri;
% refractive index, permittivity, permeability in free space II
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
 
 % 0. free space - grating - free space                             : L-to-R, R-to-L 
 % 1. homogeneous space - grating - homogeneous space               : L-to-R, R-to-L
 % 2. homogeneous space - grating - inhomogeneous waveguide         : L-to-R, R-to-L
 % 3. inhomogeneous waveguide - grating - homogeneous space         : L-to-R, R-to-L
 % 4. inhomogeneous waveguide - grating - inhomogeneous waveguide   : L-to-R, R-to-L
 
type_   =4;     
direct_ =2; % 1 = left-to-right , 2 = right-to-left

 
PRCWA_basic;                                %   3D structure
PRCWA_Gen_K;                                %   zero-thickness buffer

%PRCWA_Gen_PML2D;                            %   PML build
%PRCWA_Gen_SPP_beaming;                     %   SPP beaming

% The example structure is the triangle grating structure approximated by
% the stepwise multi-blocks. This structure modeling in the MATLAB code lines 23~68
% In PRCWA_Gen_Y_branch.m, open PRCWA_Gen_Y_branch.m and see the annotation

PRCWA_Gen_Y_branch;                         %   SPP Y branch

%% STEP 2 Block S-matrix computation of single block structures



L=NBx*NBy;

Ta=zeros(2*L,2*L,Nlay); % left to rignt
Ra=zeros(2*L,2*L,Nlay); % left to right
Tb=zeros(2*L,2*L,Nlay); % right to left
Rb=zeros(2*L,2*L,Nlay); % right to left
Ca=zeros(4*L,2*L,Nlay); % left to right
Cb=zeros(4*L,2*L,Nlay); % left to right
tCa=zeros(4*L,2*L,Nlay); % left to right
tCb=zeros(4*L,2*L,Nlay); % left to right


Diagonal_SMM;
%Off_diagonal_tensor_SMM;



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


switch type_

    case 0

        Bdr_Smat_case0;   % 0. free space - grating - free space     

    case 1
        
        Bdr_Smat_case1;    % 1. homogeneous space          - grating - homogeneous space    
        
    case 2
        
        Bdr_Smat_case2;   % 2. homogeneous space          - grating - inhomogeneous waveguide

    case 3
        
        Bdr_Smat_case3;   % 3. inhomogeneous waveguide    - grating - homogeneous space

    case 4
        
        Bdr_Smat_case4;   % 4. inhomogeneous waveguide    - grating - inhomogeneous waveguide

end;


